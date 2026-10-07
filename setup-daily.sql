-- Margin Call: daily challenge table. Paste into Supabase SQL Editor -> New query -> Run.
create table if not exists public.daily_scores (
  id bigint generated always as identity primary key,
  day date not null,
  name text not null check (name ~ '^[A-Za-z0-9_]{1,15}$'),
  ret numeric not null check (ret between -1 and 1000000),
  lev int not null check (lev in (2, 5, 10, 25)),
  good int not null default 0 check (good between 0 and 1000),
  bad int not null default 0 check (bad between 0 and 1000),
  created_at timestamptz not null default now()
);
-- one counted run per player per day
create unique index if not exists daily_one_per_day on public.daily_scores (day, lower(name));
create index if not exists daily_day_ret on public.daily_scores (day, ret desc);

alter table public.daily_scores enable row level security;
create policy "read daily" on public.daily_scores for select to anon using (true);
create policy "add daily" on public.daily_scores for insert to anon with check (day between current_date - 1 and current_date + 1);
