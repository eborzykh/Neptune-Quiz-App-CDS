//
@EndUserText.label: 'Variants (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_VARIANT_R
  as select from znept_qz_var as _Variant

  association        to parent ZNEPT_QZ_I_QUESTION_R  as _Question on  $projection.TestId     = _Question.TestId
                                                                   and $projection.QuestionId = _Question.QuestionId

  association [1..1] to ZNEPT_QZ_I_QUIZ_R             as _Quiz     on  $projection.TestId = _Quiz.TestId

  association [1..1] to ZNEPT_QZ_I_VARIANT_CORRECT_VH as _Correct  on  $projection.Correct = _Correct.Correct

{
  key _Variant.test_id     as TestId,
  key _Variant.question_id as QuestionId,
  key _Variant.variant_id  as VariantId,

      _Variant.variant     as Variant,
      _Variant.correct     as Correct,
      _Correct.CorrectText as CorrectText,

      /* Associations */

      _Quiz,
      _Question,
      _Correct
}
