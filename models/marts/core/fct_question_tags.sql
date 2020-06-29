{{ config(tags = ["stackoverflow","fact"]) }}

with questions as (

    select * from {{ ref('fct_questions') }}

),
tag_breakout as (

    select distinct

        question_id,
        question_user_id_combined,
        tag

    from questions, unnest(tag_list) as tag

),
added_key as (

    select

        {{ dbt_utils.surrogate_key('question_id', 'tag') }} as question_tag_id,
        tag_breakout.*

    from tag_breakout

)

select * from added_key
