//
@EndUserText.label: 'Variants (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_VARIANT_D
  as select from ZNEPT_QZ_I_VARIANT as _Variant

  association        to parent ZNEPT_QZ_I_QUESTION_D  as _Question on  $projection.TestId     = _Question.TestId
                                                                   and $projection.QuestionId = _Question.QuestionId

  association [1..1] to ZNEPT_QZ_I_QUIZ_D             as _Quiz     on  $projection.TestId = _Quiz.TestId

  association [1..1] to ZNEPT_QZ_I_VARIANT_CORRECT_VH as _Correct  on  $projection.Correct = _Correct.Correct

{
  key _Variant.TestId      as TestId,
  key _Variant.QuestionId  as QuestionId,
  key _Variant.VariantId   as VariantId,

      _Variant.Sort        as Sort,
      _Variant.Correct     as Correct,
      _Correct.CorrectText as CorrectText,
      _Variant.Variant     as Variant,
      _Variant.Vesrion     as Version,

      /* Associations */

      _Quiz,
      _Question,
      _Correct
}
