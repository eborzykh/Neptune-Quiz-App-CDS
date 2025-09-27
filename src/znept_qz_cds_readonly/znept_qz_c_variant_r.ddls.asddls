//
@EndUserText.label: 'Variants (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_VARIANT_R
  as projection on ZNEPT_QZ_I_VARIANT_R
{
  key TestId,
  key QuestionId,
  key VariantId,

      @ObjectModel.text.element: ['CorrectText']
      Correct,
      _Correct.CorrectText,
      
      _Question.Question,
      _Question.Explanation,

      Variant,

      /* Associations */

      _Quiz     : redirected to ZNEPT_QZ_C_QUIZ_R,
      _Question : redirected to parent ZNEPT_QZ_C_QUESTION_R,
      _Correct
}
