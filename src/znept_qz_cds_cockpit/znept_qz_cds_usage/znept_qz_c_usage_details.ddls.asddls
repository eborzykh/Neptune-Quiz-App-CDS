//
@EndUserText.label: 'Usage Details (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_USAGE_DETAILS
  as projection on ZNEPT_QZ_I_USAGE_DETAILS

{

  key SyncId,  
  key Progress,

      TestId,
       
      ProgressText,

      Progress_Count,

      ProgressInt,
      CriticalityCode,
  
      /* Associations */
 
      _Usage           : redirected to parent ZNEPT_QZ_C_USAGE,
      _Usage_Questions : redirected to composition child ZNEPT_QZ_C_USAGE_QUESTIONS

}
