with raw_data as (
    select * from read_csv_auto('trading_log_dbt/data/trade_data.csv')
)

select * from raw_data