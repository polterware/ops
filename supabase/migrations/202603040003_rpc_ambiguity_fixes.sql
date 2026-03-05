-- Fix PL/pgSQL ambiguity in RPCs (output column names vs table columns)

create or replace function public.reserve_inventory_stock(
  p_product_id uuid,
  p_location_id uuid,
  p_quantity integer,
  p_reason text default null
)
returns table(inventory_level_id uuid, quantity_reserved integer)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_level public.inventory_levels%rowtype;
begin
  perform app_private.require_operator();

  if p_quantity <= 0 then
    raise exception 'Quantity must be positive';
  end if;

  select *
  into v_level
  from public.inventory_levels
  where product_id = p_product_id
    and location_id = p_location_id
    and deleted_at is null
  for update;

  if not found then
    raise exception 'Inventory level not found for product/location';
  end if;

  if v_level.quantity_available < p_quantity then
    raise exception 'Insufficient inventory available';
  end if;

  update public.inventory_levels as il
  set quantity_reserved = il.quantity_reserved + p_quantity,
      quantity_available = il.quantity_available - p_quantity
  where il.id = v_level.id;

  insert into public.inventory_movements (
    inventory_level_id,
    movement_type,
    quantity,
    reason,
    reference_type,
    created_by
  ) values (
    v_level.id,
    'reservation',
    p_quantity,
    coalesce(p_reason, 'reserved via rpc'),
    'reservation',
    auth.uid()
  );

  return query
  select v_level.id, (v_level.quantity_reserved + p_quantity)::integer;
end;
$$;

grant execute on function public.reserve_inventory_stock(uuid, uuid, integer, text) to authenticated;

create or replace function public.release_inventory_stock(
  p_product_id uuid,
  p_location_id uuid,
  p_quantity integer,
  p_reason text default null
)
returns table(inventory_level_id uuid, quantity_available integer)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_level public.inventory_levels%rowtype;
begin
  perform app_private.require_operator();

  if p_quantity <= 0 then
    raise exception 'Quantity must be positive';
  end if;

  select *
  into v_level
  from public.inventory_levels
  where product_id = p_product_id
    and location_id = p_location_id
    and deleted_at is null
  for update;

  if not found then
    raise exception 'Inventory level not found for product/location';
  end if;

  if v_level.quantity_reserved < p_quantity then
    raise exception 'Not enough reserved quantity to release';
  end if;

  update public.inventory_levels as il
  set quantity_reserved = il.quantity_reserved - p_quantity,
      quantity_available = il.quantity_available + p_quantity
  where il.id = v_level.id;

  insert into public.inventory_movements (
    inventory_level_id,
    movement_type,
    quantity,
    reason,
    reference_type,
    created_by
  ) values (
    v_level.id,
    'release',
    p_quantity,
    coalesce(p_reason, 'released via rpc'),
    'release',
    auth.uid()
  );

  return query
  select v_level.id, (v_level.quantity_available + p_quantity)::integer;
end;
$$;

grant execute on function public.release_inventory_stock(uuid, uuid, integer, text) to authenticated;

create or replace function public.update_order_status(
  p_order_id uuid,
  p_status text,
  p_payment_status text default null,
  p_fulfillment_status text default null
)
returns table(order_id uuid, status text)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_order public.orders%rowtype;
begin
  perform app_private.require_operator();

  select * into v_order
  from public.orders
  where id = p_order_id
    and deleted_at is null
  for update;

  if not found then
    raise exception 'Order not found';
  end if;

  update public.orders as o
  set status = coalesce(p_status, o.status),
      payment_status = coalesce(p_payment_status, o.payment_status),
      fulfillment_status = coalesce(p_fulfillment_status, o.fulfillment_status)
  where o.id = v_order.id;

  return query
  select v_order.id, coalesce(p_status, v_order.status);
end;
$$;

grant execute on function public.update_order_status(uuid, text, text, text) to authenticated;
