//
@EndUserText.label: 'Questions (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_QUESTION_LOAD
  as projection on ZNEPT_QZ_I_QUESTION_LOAD

{
  key TestId,
  key QuestionId,

      @ObjectModel.text.element: ['PartDescription']
      PartId,
      _Part.Description as PartDescription,      
      
      Question,
      Explanation,

      /* Associations */

      _Quiz    : redirected to parent ZNEPT_QZ_C_QUIZ_LOAD,
      _Part    : redirected to ZNEPT_QZ_C_PART_LOAD,
      _Variant : redirected to composition child ZNEPT_QZ_C_VARIANT_LOAD
}
