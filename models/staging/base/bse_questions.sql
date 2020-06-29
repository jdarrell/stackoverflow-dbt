{{ config(tags = ["stackoverflow","base"]) }}

with source as (

    select * from {{ source('stackoverflow', 'questions') }}

),
base as (

    select

        id as question_id,
        accepted_answer_id,
        last_editor_user_id,
        owner_user_id as question_user_id,
        coalesce(cast(owner_user_id as string), owner_display_name) as question_user_id_combined,

        answer_count,
        body,
        comment_count,
        coalesce(favorite_count, 0) as favorite_count,
        owner_display_name,
        split(tags, '|') as tag_list,
        tags,
        title,
        score,
        view_count,

        community_owned_date as community_owned_at,
        creation_date as created_at,
        last_activity_date as last_activity_at,
        last_edit_date as last_edit_at

    from source

)

select * from base
