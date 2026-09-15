-- График смен + зарплата: Supabase schema
-- Выполнить целиком в Supabase -> SQL Editor.

create table if not exists public.planner_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.planner_data enable row level security;
revoke all on table public.planner_data from anon;
grant select, insert, update, delete on table public.planner_data to authenticated;

drop policy if exists "Users can read own planner data" on public.planner_data;
drop policy if exists "Users can insert own planner data" on public.planner_data;
drop policy if exists "Users can update own planner data" on public.planner_data;
drop policy if exists "Users can delete own planner data" on public.planner_data;

create policy "Users can read own planner data"
on public.planner_data for select to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can insert own planner data"
on public.planner_data for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can update own planner data"
on public.planner_data for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "Users can delete own planner data"
on public.planner_data for delete to authenticated
using ((select auth.uid()) = user_id);

-- Для Realtime-синхронизации между двумя устройствами.
alter publication supabase_realtime add table public.planner_data;

-- Не обязательно, но удобно для отображения имени пользователя.
create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
revoke all on table public.profiles from anon;
grant select, insert, update, delete on table public.profiles to authenticated;

drop policy if exists "Users can read own profile" on public.profiles;
drop policy if exists "Users can insert own profile" on public.profiles;
drop policy if exists "Users can update own profile" on public.profiles;
drop policy if exists "Users can delete own profile" on public.profiles;

create policy "Users can read own profile"
on public.profiles for select to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can insert own profile"
on public.profiles for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can update own profile"
on public.profiles for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "Users can delete own profile"
on public.profiles for delete to authenticated
using ((select auth.uid()) = user_id);

-- Чтобы updated_at обновлялся автоматически.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists planner_data_updated_at on public.planner_data;
create trigger planner_data_updated_at
before update on public.planner_data
for each row execute function public.set_updated_at();

drop trigger if exists profiles_updated_at on public.profiles;
create trigger profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();
