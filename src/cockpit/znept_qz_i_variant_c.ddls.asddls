//
@EndUserText.label: 'Variants (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_VARIANT_C
  as select from znept_qz_var as _Variant

  association        to parent ZNEPT_QZ_I_QUESTION_C    as _Question on  $projection.TestId     = _Question.TestId
//                                                                   and $projection.partid     = _Question.PartId
                                                                   and $projection.QuestionId = _Question.QuestionId

  association [1..1] to ZNEPT_QZ_I_QUIZ_C               as _Quiz     on  $projection.TestId = _Quiz.TestId

  association [1..1] to ZNEPT_QZ_I_VARIANT_CORRECT_VH as _Correct  on  $projection.Correct = _Correct.Correct

{
  key test_id              as TestId,
//  key part_id              as PartId,
  key question_id          as QuestionId,
  key variant_id           as VariantId,

// part_id              as PartId,

      correct              as Correct,

      _Correct.CorrectText as CorrectText,

      variant              as Variant,

      /* Associations */

      _Quiz,
      _Question,
      _Correct
}
