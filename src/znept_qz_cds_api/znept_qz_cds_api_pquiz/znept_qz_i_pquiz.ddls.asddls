//
@EndUserText.label: 'Personalised List (Composite)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE

define root view entity ZNEPT_QZ_I_PQUIZ
  as select from ZNEPT_QZ_I_PQUIZ_PROGRESS as _Quiz_Progress

  composition [0..*] of ZNEPT_QZ_I_PQUESTION as _Question

{
  key _Quiz_Progress.TestId,

      _Quiz_Progress.UploadOn,
      _Quiz_Progress.UploadAt,
      _Quiz_Progress.UploadBy,
      _Quiz_Progress.UploadTSTMP,
      _Quiz_Progress.ETag,
      _Quiz_Progress.Upload_By_Name,
      _Quiz_Progress.Description,
      _Quiz_Progress.Published,
      _Quiz_Progress.Part_Count,
      _Quiz_Progress.Question_Count,
      _Quiz_Progress.SessionUser,
      _Quiz_Progress.As_Owner,
      _Quiz_Progress.SyncId,
      _Quiz_Progress.No_Sync_Data,
      _Quiz_Progress.Progress,
      _Quiz_Progress.Percentage,

      /* Associations */

      _Question
}
