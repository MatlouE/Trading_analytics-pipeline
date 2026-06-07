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
        

