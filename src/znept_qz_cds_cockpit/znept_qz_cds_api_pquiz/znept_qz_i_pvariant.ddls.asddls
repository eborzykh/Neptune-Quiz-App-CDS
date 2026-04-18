//
@EndUserText.label: 'Personalised Variants (Composite)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE

define view entity ZNEPT_QZ_I_PVARIANT
  as select from ZNEPT_QZ_I_VARIANT as _Variant

  association to parent ZNEPT_QZ_I_PQUESTION as _Question on  $projection.TestId     = _Question.TestId
                                                          and $projection.QuestionId = _Question.QuestionId

{
  key TestId,
  key QuestionId,
  key VariantId,

      Correct,
      Variant,
      Sort,

      _Question.Part_Sort as Part_Sort,
      _Question.Sort as Question_Sort,

      /* Associations */

      _Question
}
