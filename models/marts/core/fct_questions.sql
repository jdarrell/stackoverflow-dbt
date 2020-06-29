{{ config(tags = ["stackoverflow","fact"]) }}

with questions as (

    select * from {{ ref('bse_questions') }}

),
answers as (

    select * from {{ ref('bse_answers') }}

),
answer_aggregate as (

    select

        question_id,

        max(score) as max_answer_score,
        min(created_at) as first_answer_at,
        max(created_at) as last_answer_at

    from answers

    group by 1

),
joined as (

    select

        questions.*,

        answer_aggregate.max_answer_score,
        answer_aggregate.first_answer_at,
        answer_aggregate.last_answer_at,
        timestamp_diff(answer_aggregate.first_answer_at, questions.created_at, second) / 60.0 as minutes_to_first_answer,
        if(
            questions.answer_count = 0,
            timestamp_diff(current_timestamp(), questions.created_at, second),
            null
        ) / 60.0 as question_unanswered_minutes

    from questions
    left join answer_aggregate on questions.question_id = answer_aggregate.question_id

)

select * from joined
