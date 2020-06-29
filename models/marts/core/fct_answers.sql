{{ config(tags = ["stackoverflow","fact"]) }}

with answers as (

    select * from {{ ref('bse_answers') }}

),
questions as (

    select * from {{ ref('bse_questions') }}

),
accepted_answers as (

    select distinct accepted_answer_id from questions where accepted_answer_id is not null

),
joined as (

    select

        answers.*,

        if(accepted_answers.accepted_answer_id is not null, true, false) is_accepted_answer,
        row_number() over (partition by answers.question_id order by answers.created_at) as answer_sequence

    from answers
    left join accepted_answers on answers.answer_id = accepted_answers.accepted_answer_id
    left join questions on answers.question_id = questions.question_id

    where questions.created_at >= '2014-01-01'

)

select * from joined
