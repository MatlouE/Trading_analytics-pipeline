with raw_data as (
    select * from {{ source('raw_data', 'raw_trading_log') }}
),

-- apply timezone conversion to timestamp columns
timezoned as (
    select
        *,
        {{ convert_to_ny_timezone('Time') }} as entryTime_NY,
        {{ convert_to_ny_timezone('Time1') }} as exitTime_NY
    from raw_data
),

-- data cleaning
staged as (
    select
        cast(Time as timestamp) as entryTime_NY,
        cast(Position as varchar) as tradeid,
        cast(Symbol as varchar) as symbol,
        cast(Type as varchar) as type,
        cast(Volume as float) as lotsize,

        -- Financial calculations
        cast(Price as float) as entry_price,
        cast(S / L as float) as stop_loss,
        cast(T / P as float) as take_profit,
        cast(Time1 as timestamp) as exixTime_NY,
        cast(Price1 as float) as exit_price,
        cast(Profit as float) as profit,
    from timezoned
),

select * from staged
        


