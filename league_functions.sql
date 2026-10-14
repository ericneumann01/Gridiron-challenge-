-- Gridiron Challenge Stage 3: real league creation and invite-code joining.
-- Run this in Supabase Dashboard > SQL Editor > New query.
create or replace function public.create_league_with_manager(
  p_name text,
  p_required_picks integer default 4,
  p_max_parlays integer default 2
)
returns table(league_id uuid, league_name text, invite_code text)
language plpgsql
security definer
set search_path = ''
as $$
declare
  new_id uuid;
  new_code text;
  clean_name text;
begin
  if auth.uid() is null then raise exception 'Please sign in first.'; end if;
  clean_name := nullif(trim(p_name), '');
  if clean_name is null then raise exception 'Enter a league name.'; end if;
  if p_required_picks < 1 or p_required_picks > 32 then raise exception 'Required picks must be from 1 to 32.'; end if;
  if p_max_parlays < 0 or p_max_parlays > 5 then raise exception 'Maximum parlays must be from 0 to 5.'; end if;
  loop
    new_code := upper(substr(encode(gen_random_bytes(5), 'hex'), 1, 8));
    exit when not exists (select 1 from public.leagues l where l.invite_code = new_code);
  end loop;
  insert into public.leagues(name, invite_code, created_by, required_picks, max_parlays)
    values(clean_name, new_code, auth.uid(), p_required_picks, p_max_parlays)
    returning id into new_id;
  insert into public.league_members(league_id, user_id, role)
    values(new_id, auth.uid(), 'manager');
  return query select new_id, clean_name, new_code;
end;
$$;

create or replace function public.join_league_by_code(p_invite_code text)
returns table(league_id uuid, league_name text, member_role text)
language plpgsql
security definer
set search_path = ''
as $$
declare found_league public.leagues%rowtype;
begin
  if auth.uid() is null then raise exception 'Please sign in first.'; end if;
  select * into found_league from public.leagues where invite_code = upper(trim(p_invite_code));
  if found_league.id is null then raise exception 'No league found for that invitation code.'; end if;
  insert into public.league_members(league_id, user_id, role)
    values(found_league.id, auth.uid(), 'player')
    on conflict (league_id, user_id) do nothing;
  return query select found_league.id, found_league.name, 'player'::text;
end;
$$;

revoke all on function public.create_league_with_manager(text, integer, integer) from public;
revoke all on function public.join_league_by_code(text) from public;
grant execute on function public.create_league_with_manager(text, integer, integer) to authenticated;
grant execute on function public.join_league_by_code(text) to authenticated;
