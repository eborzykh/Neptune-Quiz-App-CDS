//
@EndUserText.label: 'Parts (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_PART_C
  as projection on ZNEPT_QZ_I_PART_C
{
  key TestId,
  key PartId,

      Description,

      /* Associations */

      _Question : redirected to composition child ZNEPT_QZ_C_QUESTION_C,
      _Quiz     : redirected to parent ZNEPT_QZ_C_QUIZ_C
}
