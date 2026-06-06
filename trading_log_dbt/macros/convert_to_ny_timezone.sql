{% macro convert_sast_to_ny(column_name) %}
    --interprets column as johburg time and converts to ny
    timezone(
        'America/New_York',
        timezone('Africa/Johannesburg', {{ column_name }})
    )
{% endmacro %}
