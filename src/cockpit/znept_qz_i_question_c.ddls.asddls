//
@EndUserText.label: 'Questions (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUESTION_C
  as select from znept_qz_qst as _Question

  association        to parent ZNEPT_QZ_I_PART_C as _Part on  $projection.TestId = _Part.TestId
                                                          and $projection.PartId = _Part.PartId

  composition [0..*] of ZNEPT_QZ_I_VARIANT_C     as _Variant

  association [1..1] to ZNEPT_QZ_I_QUIZ_C        as _Quiz on  $projection.TestId = _Quiz.TestId

{
  key test_id     as TestId,
//  key part_id     as PartId,
  key question_id as QuestionId,

 part_id     as PartId,

      question    as Question,
      explanation as Explanation,

      /* Associations */

      _Quiz,
      _Part,
      _Variant
}
