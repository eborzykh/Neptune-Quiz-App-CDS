//
@EndUserText.label: 'Variants (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_VARIANT_C
  as projection on ZNEPT_QZ_I_VARIANT_C
{

  key TestId,
//  key PartId,
  key QuestionId,
  key VariantId,

//  PartId,
  
      @ObjectModel.text.element: ['CorrectText']
      Correct,
      _Correct.CorrectText,

      Variant,

      /* Associations */

      _Quiz     : redirected to ZNEPT_QZ_C_QUIZ_C,
      _Question : redirected to parent ZNEPT_QZ_C_QUESTION_C,
      _Correct
}
