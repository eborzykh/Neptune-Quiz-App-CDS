//
@EndUserText.label: 'Questions (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_QUESTION_D
  as projection on ZNEPT_QZ_I_QUESTION_D

{

  key TestId,
  key QuestionId,

      PartId,
      Question,
      Explanation,

      /* Associations */

      _Part    : redirected to ZNEPT_QZ_C_PART_D,
      _Quiz    : redirected to parent ZNEPT_QZ_C_QUIZ_D,
      _Variant : redirected to composition child ZNEPT_QZ_C_VARIANT_D
}
