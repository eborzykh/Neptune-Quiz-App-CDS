//
@EndUserText.label: 'Parts (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_PART_U
  as projection on ZNEPT_QZ_I_PART_U
{
  key TestId,
  key PartId,

      Sort,

      Description,

      /* Associations */

      _Question : redirected to ZNEPT_QZ_C_QUESTION_U,
      _Quiz     : redirected to parent ZNEPT_QZ_C_QUIZ_U
}
