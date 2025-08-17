//
@EndUserText.label: 'Questions (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUESTION_R
  as select from ZNEPT_QZ_I_QUESTION as _Question

  association        to parent ZNEPT_QZ_I_PART_R as _Part on  $projection.TestId = _Part.TestId
                                                          and $projection.PartId = _Part.PartId

  association [1..1] to ZNEPT_QZ_I_QUIZ_R        as _Quiz on  $projection.TestId = _Quiz.TestId

  composition [0..*] of ZNEPT_QZ_I_VARIANT_R     as _Variant
  
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
