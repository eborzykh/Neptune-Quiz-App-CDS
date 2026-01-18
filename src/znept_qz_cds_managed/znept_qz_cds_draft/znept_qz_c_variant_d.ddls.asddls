//
@EndUserText.label: 'Variants (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_VARIANT_D
  as projection on ZNEPT_QZ_I_VARIANT_D
{
  key TestId,
  key QuestionId,
  key VariantId,

      Sort,
      Variant,
      @ObjectModel.text.element: ['CorrectText']
      Correct,
      _Correct.CorrectText,

      Version,

      /* Associations */

      _Quiz     : redirected to ZNEPT_QZ_C_QUIZ_D,
      _Question : redirected to parent ZNEPT_QZ_C_QUESTION_D,
      _Correct
}
