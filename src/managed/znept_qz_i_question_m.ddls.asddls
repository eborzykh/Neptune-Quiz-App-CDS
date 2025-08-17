//
@EndUserText.label: 'Questions (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUESTION_M
  as select from ZNEPT_QZ_I_QUESTION as _Question

  association        to parent ZNEPT_QZ_I_PART_M as _Part on  $projection.TestId = _Part.TestId
                                                          and $projection.PartId = _Part.PartId

  composition [0..*] of ZNEPT_QZ_I_VARIANT_M     as _Variant

  association [1..1] to ZNEPT_QZ_I_QUIZ_M        as _Quiz on  $projection.TestId = _Quiz.TestId

{
  key _Question.TestId      as TestId,
  key _Question.QuestionId  as QuestionId,

      _Question.PartId      as PartId,
      _Question.Question    as Question,
      _Question.Explanation as Explanation,

      /* Associations */

      _Quiz,
      _Part,
      _Variant
}
