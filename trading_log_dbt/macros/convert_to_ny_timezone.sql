{% macro convert_to_ny_timezone(column_name) %}
    --interprets column as johburg time and converts to ny
    timezone(
        'America/New_York',
        timezone('Africa/Johannesburg', {{ column_name }})
    )
{% endmacro %}
