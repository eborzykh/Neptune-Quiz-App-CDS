//
@EndUserText.label: 'Questions (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUESTION 
  as select from znept_qz_qst as _Question
{
  key _Question.test_id     as TestId,
  key _Question.question_id as QuestionId,

      _Question.part_id     as PartId,
      _Question.question    as Question,
      _Question.explanation as Explanation,

      case
        when _Question.sort is initial then _Question.question_id
        else _Question.sort
      end                   as Sort
}
