
  
  create view "dev"."main"."stg_tradelog__dbt_tmp" as (
    with raw_data as (
    select * from read_csv_auto('trading_log_dbt/data/trade_data.csv')
)

select * from raw_data
  );
