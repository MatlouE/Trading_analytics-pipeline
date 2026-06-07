-- created_at: 2026-06-07T18:47:35.984331448+00:00
-- finished_at: 2026-06-07T18:47:35.987253142+00:00
-- elapsed: 2ms
-- outcome: success
-- dialect: duckdb
-- node_id: not available
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "trading_log_dbt", "target_name": "dev"} */

    
    select schema_name
    from system.information_schema.schemata
    
    where lower(catalog_name) = '"dev"'
    
  
  ;
-- created_at: 2026-06-07T18:47:35.988099973+00:00
-- finished_at: 2026-06-07T18:47:35.988854441+00:00
-- elapsed: 754us
-- outcome: success
-- dialect: duckdb
-- node_id: not available
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "trading_log_dbt", "target_name": "dev"} */

    
        select type from duckdb_databases()
        where lower(database_name)='dev'
        and type='sqlite'
    
  ;
-- created_at: 2026-06-07T18:47:35.990001893+00:00
-- finished_at: 2026-06-07T18:47:35.991886701+00:00
-- elapsed: 1ms
-- outcome: success
-- dialect: duckdb
-- node_id: not available
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "trading_log_dbt", "target_name": "dev"} */

    
    
        create schema if not exists "dev"."main"
    ;
-- created_at: 2026-06-07T18:47:36.069826329+00:00
-- finished_at: 2026-06-07T18:47:36.076831311+00:00
-- elapsed: 7ms
-- outcome: success
-- dialect: duckdb
-- node_id: model.trading_log_dbt.stg_tradelog
-- query_id: not available
-- desc: get_relation > list_relations call
SELECT table_catalog, table_schema, table_name, table_type FROM information_schema.tables WHERE table_schema = 'main';
-- created_at: 2026-06-07T18:47:36.080516069+00:00
-- finished_at: 2026-06-07T18:47:36.126089144+00:00
-- elapsed: 45ms
-- outcome: success
-- dialect: duckdb
-- node_id: model.trading_log_dbt.stg_tradelog
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.trading_log_dbt.stg_tradelog", "profile_name": "trading_log_dbt", "target_name": "dev"} */

  
  create view "dev"."main"."stg_tradelog__dbt_tmp" as (
    with raw_data as (
    select * from read_csv_auto('trading_log_dbt/data/trade_data.csv')
),

-- apply timezone conversion to timestamp columns
timezoned as (
    select
        *,
        
    --interprets column as johburg time and converts to ny
    timezone(
        'America/New_York',
        timezone('Africa/Johannesburg', Time)
    )
 as entryTime_NY,
        
    --interprets column as johburg time and converts to ny
    timezone(
        'America/New_York',
        timezone('Africa/Johannesburg', Time_1)
    )
 as exitTime_NY
    from raw_data
),

-- data cleaning
staged as (
    select
        cast(Time as timestamp) as entryTime,
        entryTime_NY,
        cast(Position as varchar) as tradeid,
        cast(Symbol as varchar) as symbol,
        cast(Type as varchar) as type,
        ROUND(cast(replace(cast(Volume as varchar), ' ', '') as float), 2) as lotsize,

        -- Financial calculations
        ROUND(cast(replace(cast(Price as varchar), ' ', '') as float), 2) as entry_price,
        ROUND(cast(replace(cast("S / L" as varchar), ' ', '') as float), 2) as stop_loss,
        ROUND(cast(replace(cast("T / P" as varchar), ' ', '') as float), 2) as take_profit,
        cast(Time_1 as timestamp) as exitTime,
        exitTime_NY,
        ROUND(cast(replace(cast(Price_1 as varchar), ' ', '') as float), 2) as exit_price,
        ROUND(cast(replace(cast(Profit as varchar), ' ', '') as float), 2) as profit,
    from timezoned
)

select * from staged
        


  );
;
-- created_at: 2026-06-07T18:47:36.129913302+00:00
-- finished_at: 2026-06-07T18:47:36.134519161+00:00
-- elapsed: 4ms
-- outcome: success
-- dialect: duckdb
-- node_id: model.trading_log_dbt.stg_tradelog
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.trading_log_dbt.stg_tradelog", "profile_name": "trading_log_dbt", "target_name": "dev"} */

      alter view "dev"."main"."stg_tradelog" rename to "stg_tradelog__dbt_backup"
    ;
-- created_at: 2026-06-07T18:47:36.135940584+00:00
-- finished_at: 2026-06-07T18:47:36.146769417+00:00
-- elapsed: 10ms
-- outcome: success
-- dialect: duckdb
-- node_id: model.trading_log_dbt.stg_tradelog
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.trading_log_dbt.stg_tradelog", "profile_name": "trading_log_dbt", "target_name": "dev"} */

      alter view "dev"."main"."stg_tradelog__dbt_tmp" rename to "stg_tradelog"
    ;
-- created_at: 2026-06-07T18:47:36.149524620+00:00
-- finished_at: 2026-06-07T18:47:36.151407354+00:00
-- elapsed: 1ms
-- outcome: success
-- dialect: duckdb
-- node_id: model.trading_log_dbt.stg_tradelog
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.trading_log_dbt.stg_tradelog", "profile_name": "trading_log_dbt", "target_name": "dev"} */

      drop view if exists "dev"."main"."stg_tradelog__dbt_backup" cascade
    ;
