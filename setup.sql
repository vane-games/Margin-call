-- Margin Call leaderboard. Paste into Supabase: SQL Editor -> New query -> Run.
create table if not exists public.scores (
  id bigint generated always as identity primary key,
  name text not null check (name ~ '^[A-Za-z0-9_]{1,15}$'),
  ret numeric not null check (ret between -1 and 1000000),
  equity bigint not null check (equity >= 0),
  stake int not null check (stake in (100, 1000, 10000, 100000)),
  lev int not null check (lev in (2, 5, 10, 25)),
  rounds int not null check (rounds between 1 and 1000),
  created_at timestamptz not null default now()
);
create index if not exists scores_ret_idx on public.scores (ret desc);

alter table public.scores enable row level security;

-- Anyone can read the board and add a score. Nobody can edit or delete through the public key.
create policy "read scores" on public.scores for select to anon using (true);
create policy "add score" on public.scores for insert to anon with check (true);
