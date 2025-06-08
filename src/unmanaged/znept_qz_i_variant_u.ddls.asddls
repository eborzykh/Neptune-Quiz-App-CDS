//
@EndUserText.label: 'Variants (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_VARIANT_U
  as select from znept_qz_var as _Variant

  association        to parent ZNEPT_QZ_I_QUESTION_U  as _Question on  $projection.TestId     = _Question.TestId
                                                                   and $projection.QuestionId = _Question.QuestionId

  association [1..1] to ZNEPT_QZ_I_QUIZ_U             as _Quiz     on  $projection.TestId = _Quiz.TestId

  association [1..1] to ZNEPT_QZ_I_VARIANT_CORRECT_VH as _Correct  on  $projection.Correct = _Correct.Correct

{
  key test_id              as TestId,
  key question_id          as QuestionId,
  key variant_id           as VariantId,

      correct              as Correct,
      _Correct.CorrectText as CorrectText,
      variant              as Variant,

      /* Associations */

      _Quiz,
      _Question,
      _Correct
}
