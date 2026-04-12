//
@EndUserText.label: 'Personalised List (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.lifecycle.contract.type: #PUBLIC_REMOTE_API
@VDM.viewType: #CONSUMPTION

define root view entity ZNEPT_QZ_A_PQUIZ
  provider contract transactional_query
  as projection on ZNEPT_QZ_I_PQUIZ as _Quiz

{
  key TestId,
  
      UploadOn,
      UploadAt,
      UploadBy,
      UploadTSTMP,
      Upload_By_Name,
      Description,
      Published,
      Part_Count,
      Question_Count,
      SessionUser,
      As_Owner,
      SyncId,
      No_Sync_Data,
      Progress,
      Percentage,
      
      /* Associations */
      
      _Question : redirected to composition child ZNEPT_QZ_A_PQUESTION
}
