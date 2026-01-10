//
@EndUserText.label: 'Usage Questions (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_USAGE_QUESTIONS
  as projection on ZNEPT_QZ_I_USAGE_QUESTIONS

{
 
  key SyncId, 
  key QuestionId, 

      TestId,

      PartId,
      Question,
      Explanation,
      Sort,

      Progress,
      
      CriticalityCode,

      /* Associations */

      _Usage,
      _Usage_Details : redirected to parent ZNEPT_QZ_C_USAGE_DETAILS

}
