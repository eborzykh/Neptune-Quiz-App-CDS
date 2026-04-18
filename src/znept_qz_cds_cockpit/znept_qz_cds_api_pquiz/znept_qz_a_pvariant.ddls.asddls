//
@EndUserText.label: 'Personalised Variants (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.lifecycle.contract.type: #PUBLIC_REMOTE_API
@VDM.viewType: #CONSUMPTION

define view entity ZNEPT_QZ_A_PVARIANT
  as projection on ZNEPT_QZ_I_PVARIANT as _Variant

{
  key TestId,
  key QuestionId,
  key VariantId,

      Correct,
      Variant,
      Sort,
      Question_Sort,
      Part_Sort,

      /* Associations */

      _Question : redirected to parent ZNEPT_QZ_A_PQUESTION
}
