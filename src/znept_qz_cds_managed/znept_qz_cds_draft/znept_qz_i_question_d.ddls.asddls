//
@EndUserText.label: 'Questions (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUESTION_D
  as select from ZNEPT_QZ_I_QUESTION as _Question

  association        to parent ZNEPT_QZ_I_QUIZ_D as _Quiz on  $projection.TestId = _Quiz.TestId

  association [0..1] to ZNEPT_QZ_I_PART_D        as _Part on  $projection.TestId = _Part.TestId
                                                          and $projection.PartId = _Part.PartId

  composition [0..*] of ZNEPT_QZ_I_VARIANT_D     as _Variant

{
  key _Question.TestId      as TestId,
  key _Question.QuestionId  as QuestionId,

      _Question.Sort        as Sort,
      _Question.PartId      as PartId,
      _Question.Question    as Question,
      _Question.Explanation as Explanation,
      
      _Question.Version     as Version,
      
      /* Associations */

      _Quiz,
      _Part,
      _Variant
}
