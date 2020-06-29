{{ config(tags = ["stackoverflow","base"]) }}

with source as (

    select * from {{ source('stackoverflow', 'answers') }}

),
base as (

    select

        id as answer_id,
        last_editor_user_id,
        owner_user_id as answer_user_id,
        coalesce(cast(owner_user_id as string), owner_display_name) as answer_user_id_combined,
        parent_id as question_id,

        body,
        comment_count,
        owner_display_name,
        score,

        creation_date as created_at,
        last_activity_date as last_activity_at,
        last_edit_date as last_edit_at

    from source

)

select * from base
