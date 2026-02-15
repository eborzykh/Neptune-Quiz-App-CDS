//
@EndUserText.label: 'Variants (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_VARIANT_LOAD
  as projection on ZNEPT_QZ_I_VARIANT_LOAD
{
  key TestId,
  key QuestionId,
  key VariantId,

      @ObjectModel.text.element: ['CorrectText']
      Correct,
      _Correct.CorrectText,

      /* Associations */

      _Quiz     : redirected to ZNEPT_QZ_C_QUIZ_LOAD,
      _Question : redirected to parent ZNEPT_QZ_C_QUESTION_LOAD,
      _Correct
}
