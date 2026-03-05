-- RLS hardening for legacy/public tables detected by Supabase linter.
-- Idempotent migration to enforce RLS and baseline policies.

-- 1) Ensure RLS is enabled on listed tables (including legacy shop_config).
alter table if exists public.shop_config enable row level security;
alter table if exists public.brands enable row level security;
alter table if exists public.categories enable row level security;
alter table if exists public.locations enable row level security;
alter table if exists public.inventory_levels enable row level security;
alter table if exists public.inventory_movements enable row level security;

-- 2) Create missing policies only when they do not exist.
do $rls$
begin
  -- Legacy shop_config: role-gated access (if table exists).
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'shop_config'
  ) then
    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'shop_config' and policyname = 'shop_config_select'
    ) then
      execute $policy$
        create policy shop_config_select on public.shop_config
        for select
        using (app_private.has_role(array['admin', 'operator', 'analyst']))
      $policy$;
    end if;

    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'shop_config' and policyname = 'shop_config_write'
    ) then
      execute $policy$
        create policy shop_config_write on public.shop_config
        for all
        using (app_private.has_role(array['admin', 'operator']))
        with check (app_private.has_role(array['admin', 'operator']))
      $policy$;
    end if;
  end if;

  -- brands
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'brands'
  ) then
    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'brands' and policyname = 'brands_select'
    ) then
      execute $policy$
        create policy brands_select on public.brands
        for select
        using (app_private.has_role(array['admin', 'operator', 'analyst']))
      $policy$;
    end if;

    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'brands' and policyname = 'brands_write'
    ) then
      execute $policy$
        create policy brands_write on public.brands
        for all
        using (app_private.has_role(array['admin', 'operator']))
        with check (app_private.has_role(array['admin', 'operator']))
      $policy$;
    end if;
  end if;

  -- categories
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'categories'
  ) then
    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'categories' and policyname = 'categories_select'
    ) then
      execute $policy$
        create policy categories_select on public.categories
        for select
        using (app_private.has_role(array['admin', 'operator', 'analyst']))
      $policy$;
    end if;

    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'categories' and policyname = 'categories_write'
    ) then
      execute $policy$
        create policy categories_write on public.categories
        for all
        using (app_private.has_role(array['admin', 'operator']))
        with check (app_private.has_role(array['admin', 'operator']))
      $policy$;
    end if;
  end if;

  -- locations
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'locations'
  ) then
    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'locations' and policyname = 'locations_select'
    ) then
      execute $policy$
        create policy locations_select on public.locations
        for select
        using (app_private.has_role(array['admin', 'operator', 'analyst']))
      $policy$;
    end if;

    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'locations' and policyname = 'locations_write'
    ) then
      execute $policy$
        create policy locations_write on public.locations
        for all
        using (app_private.has_role(array['admin', 'operator']))
        with check (app_private.has_role(array['admin', 'operator']))
      $policy$;
    end if;
  end if;

  -- inventory_levels
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'inventory_levels'
  ) then
    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'inventory_levels' and policyname = 'inventory_levels_select'
    ) then
      execute $policy$
        create policy inventory_levels_select on public.inventory_levels
        for select
        using (app_private.has_role(array['admin', 'operator', 'analyst']))
      $policy$;
    end if;

    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'inventory_levels' and policyname = 'inventory_levels_write'
    ) then
      execute $policy$
        create policy inventory_levels_write on public.inventory_levels
        for all
        using (app_private.has_role(array['admin', 'operator']))
        with check (app_private.has_role(array['admin', 'operator']))
      $policy$;
    end if;
  end if;

  -- inventory_movements
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'inventory_movements'
  ) then
    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'inventory_movements' and policyname = 'inventory_movements_select'
    ) then
      execute $policy$
        create policy inventory_movements_select on public.inventory_movements
        for select
        using (app_private.has_role(array['admin', 'operator', 'analyst']))
      $policy$;
    end if;

    if not exists (
      select 1 from pg_policies
      where schemaname = 'public' and tablename = 'inventory_movements' and policyname = 'inventory_movements_write'
    ) then
      execute $policy$
        create policy inventory_movements_write on public.inventory_movements
        for all
        using (app_private.has_role(array['admin', 'operator']))
        with check (app_private.has_role(array['admin', 'operator']))
      $policy$;
    end if;
  end if;
end;
$rls$;
