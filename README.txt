GRIDIRON CHALLENGE — STAGE 3: REAL LEAGUES

This update adds real league creation and invite-code joining through Supabase RPC functions. Existing demo picks, sample games, parlays, and sample standings remain demo/local for now; this stage only makes league creation and membership shared.

IMPORTANT: Before uploading this version, install the SQL functions in your Supabase project:
1. Open https://supabase.com/dashboard and select project andrvwdgvvtbrmksract.
2. Open SQL Editor > New query.
3. Open league_functions.sql from this package and copy all of its contents.
4. Paste into the SQL Editor and press Run.
5. Confirm it completes without an error.

THEN publish the updated website:
1. Extract this ZIP in the iPhone Files app.
2. Upload the contents of the gridiron_challenge_stage3_leagues folder to your existing Netlify site, replacing the previous index.html. Keep index.html at the published site's root.
3. If the upload tool deploys a new site instead, use its new URL or update the existing site through Netlify's Deploys page.

Test:
- Open the site and confirm you are signed in.
- Open League Settings.
- Create a league and note the invitation code.
- Use a second account/browser to join with that code.
- The league should appear in My real leagues.

Security: This package uses the existing Supabase public anon key in the browser. Never put a service_role or secret key in the website.
