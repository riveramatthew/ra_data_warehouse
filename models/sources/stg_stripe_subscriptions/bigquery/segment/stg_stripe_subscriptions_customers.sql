{{config(enabled = target.type == 'bigquery')}}
{% if var("subscriptions_warehouse_sources") %}
{% if 'stripe_subscriptions' in var("subscriptions_warehouse_sources") %}

with source as (
  {{ filter_segment_relation(relation=source('segment_stripe_subscriptions','customers')) }}

),
renamed as (
  select concat('stg_stripe_payments_segment-',metadata_CLIENTREPLACEME_user_id) as customer_id,
  email as customer_email,
  description as customer_description,
  concat('{{ var('stg_stripe_payments_id-prefix') }}',id) as customer_alternative_id,
  cast(null as {{ dbt_utils.type_string() }}) as customer_plan,
  metadata_source as customer_source,
  cast(null as {{ dbt_utils.type_string() }}) as customer_type,
  cast(null as {{ dbt_utils.type_string() }}) as customer_industry,
  cast(null as {{ dbt_utils.type_string() }}) as customer_currency,
  cast(null as {{ dbt_utils.type_boolean() }}) as customer_is_enterprise,
  cast(null as {{ dbt_utils.type_boolean() }}) as customer_is_delinquent,
  cast(null as {{ dbt_utils.type_boolean() }}) as customer_is_deleted,
   cast(null as {{ dbt_utils.type_timestamp() }}) as customer_created_date,
   cast(null as {{ dbt_utils.type_timestamp() }}) as customer_last_modified_date
from source
)
select * from renamed

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
