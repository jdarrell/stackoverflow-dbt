{{ config(tags = ["stackoverflow","base"]) }}

with source as (

    select * from {{ source('stackoverflow', 'users') }}

),
base as (

    select

        id as user_id,

        about_me,
        display_name,
        down_votes,
        location,
        profile_image_url,
        reputation,
        timestamp_diff(current_timestamp(), creation_date, day) as tenure,
        down_votes + up_votes as total_votes,
        up_votes,
        views,
        website_url,

        creation_date as created_at, --datetime(creation_date, 'America/Denver') as created_at,
        last_access_date as last_activity_at

    from source

)

select * from base
