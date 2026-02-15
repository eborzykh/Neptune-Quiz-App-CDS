//
@EndUserText.label: 'Parts (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_PART_LOAD
  as projection on ZNEPT_QZ_I_PART_LOAD
{
  key TestId,
  key PartId,

      Description,

      /* Associations */

      _Question : redirected to ZNEPT_QZ_C_QUESTION_LOAD,
      _Quiz     : redirected to parent ZNEPT_QZ_C_QUIZ_LOAD
}
