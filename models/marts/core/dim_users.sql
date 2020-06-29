{{ config(tags = ["stackoverflow","dim"]) }}

with users as (

    select * from {{ ref('bse_users') }}

),
questions as (

    select * from {{ ref('bse_questions') }}

),
answers as (

    select * from {{ ref('fct_answers') }}

),
question_aggregate as (

    select

        owner_user_id,

        count(owner_user_id) as question_count,
        sum(if(answer_count = 0, 1, 0)) as unanswered_question_count,
        sum(if(accepted_answer_id is not null, 1, 0)) as answer_accepted_count,
        avg(view_count) as average_question_view_count,
        min(created_at) as first_question_at,
        max(created_at) as last_question_at

    from questions

    group by 1

),
answer_aggregate as (

    select

        owner_user_id,

        count(*) as answer_count,
        sum(if(is_accepted_answer, 1, 0)) as accepted_answer_count,
        avg(score) as average_answer_score,
        min(created_at) as first_answer_at,
        max(created_at) as last_answer_at

    from answers

    group by 1

),
joined as (

    select

        users.*,

        question_aggregate.question_count,
        question_aggregate.unanswered_question_count,
        question_aggregate.answer_accepted_count,
        question_aggregate.average_question_view_count,
        question_aggregate.first_question_at,
        question_aggregate.last_question_at,

        answer_aggregate.answer_count,
        answer_aggregate.accepted_answer_count,
        answer_aggregate.average_answer_score,
        answer_aggregate.first_answer_at,
        answer_aggregate.last_answer_at

    from users
    left join question_aggregate on users.user_id = question_aggregate.owner_user_id
    left join answer_aggregate on users.user_id = answer_aggregate.owner_user_id

)

select * from joined
