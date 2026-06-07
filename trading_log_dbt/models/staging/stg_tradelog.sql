with raw_data as (
    select * from read_csv_auto('trading_log_dbt/data/trade_data.csv')
),

-- apply timezone conversion to timestamp columns
timezoned as (
    select
        *,
        {{ convert_to_ny_timezone('Time') }} as entryTime_NY,
        {{ convert_to_ny_timezone('Time_1') }} as exitTime_NY
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
        cast(Volume as decimal(10, 2)) as lotsize,

        -- Financial calculations
        cast(replace(cast(Price as varchar), ' ', '') as decimal(10, 2)) as entry_price,
        cast(replace(cast("S / L" as varchar), ' ', '') as decimal(10, 2)) as stop_loss,
        cast(replace(cast("T / P" as varchar), ' ', '') as decimal(10, 2)) as take_profit,
        cast(Time_1 as timestamp) as exitTime,
        exitTime_NY,
        cast(replace(cast(Price_1 as varchar), ' ', '') as decimal(10, 2)) as exit_price,
        cast(replace(cast(Profit as varchar), ' ', '') as decimal(10, 2)) as profit,
    from timezoned
)

select * from staged
        


