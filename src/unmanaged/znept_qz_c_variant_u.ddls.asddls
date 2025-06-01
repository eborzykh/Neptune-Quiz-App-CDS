//
@EndUserText.label: 'Variants (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_VARIANT_U
  as projection on ZNEPT_QZ_I_VARIANT_U
{
  key TestId,
  key QuestionId,
  key VariantId,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZNEPT_QZ_I_VARIANT_CORRECT_VH', element: 'Correct' } }]
      @ObjectModel.text.element: ['CorrectText']
      Correct,
      _Correct.CorrectText,

      Variant,

      /* Associations */

      _Quiz     : redirected to ZNEPT_QZ_C_QUIZ_U,
      _Question : redirected to parent ZNEPT_QZ_C_QUESTION_U,
      _Correct
}
