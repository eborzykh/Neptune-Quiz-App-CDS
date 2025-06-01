//
@EndUserText.label: 'Questions (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUESTION_R
  as select from znept_qz_qst as _Question

  association        to parent ZNEPT_QZ_I_PART_R as _Part on  $projection.TestId = _Part.TestId
                                                          and $projection.PartId = _Part.PartId

  association [1..1] to ZNEPT_QZ_I_QUIZ_R        as _Quiz on  $projection.TestId = _Quiz.TestId

  composition [0..*] of ZNEPT_QZ_I_VARIANT_R     as _Variant
{
  key _Question.test_id     as TestId,
  key _Question.question_id as QuestionId,

      _Question.part_id     as PartId,
      _Question.question    as Question,
      _Question.explanation as Explanation,


      /* Associations */

      _Quiz,
      _Part,
      _Variant
}
