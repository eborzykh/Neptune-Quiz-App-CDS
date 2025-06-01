//
@EndUserText.label: 'Parts (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_PART_R
  as projection on ZNEPT_QZ_I_PART_R
{
  key TestId,
  key PartId,

      Description,

      /* Associations */

      _Question : redirected to composition child ZNEPT_QZ_C_QUESTION_R,
      _Quiz     : redirected to parent ZNEPT_QZ_C_QUIZ_R
}
