//
@EndUserText.label: 'Parts (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_PART_M
  as projection on ZNEPT_QZ_I_PART_M
{
  key TestId,
  key PartId,

      Sort,
      Description,
      
      Version,

      /* Associations */

      _Question : redirected to ZNEPT_QZ_C_QUESTION_M,
      _Quiz     : redirected to parent ZNEPT_QZ_C_QUIZ_M
}
