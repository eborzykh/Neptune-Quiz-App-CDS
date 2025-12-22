//
@EndUserText.label: 'Questions (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_QUESTION_M
  as projection on ZNEPT_QZ_I_QUESTION_M

{

  key TestId,
  key QuestionId,

      Sort,
      PartId,
      Question,
      Explanation,

      Version,
      
      SortQuestion,       
      SortPart,

      /* Associations */

      _Part    : redirected to ZNEPT_QZ_C_PART_M,
      _Quiz    : redirected to parent ZNEPT_QZ_C_QUIZ_M,
      _Variant : redirected to composition child ZNEPT_QZ_C_VARIANT_M
}
