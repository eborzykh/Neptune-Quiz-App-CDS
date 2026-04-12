//
@EndUserText.label: 'Personalised List (Composite)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE

define view entity ZNEPT_QZ_I_PQUIZ_SYNC
  as select from ZNEPT_QZ_I_QUIZ as _Quiz

  association [0..1] to ZNEPT_QZ_I_ACTIVITY_SYNC as _Activity_Sync on  _Quiz.SessionUser = _Activity_Sync.SyncBy
                                                                   and _Quiz.TestId      = _Activity_Sync.TestId
                                                                   and _Quiz.UploadOn    = _Activity_Sync.UploadOn
                                                                   and _Quiz.UploadAt    = _Activity_Sync.UploadAt

{
  key _Quiz.TestId,

      _Quiz.UploadOn,
      _Quiz.UploadAt,
      _Quiz.UploadBy,
      _Quiz.UploadTSTMP,
      _Quiz.ETag,
      _Quiz.Upload_By_Name,
      _Quiz.Description,
      _Quiz.Published,
      _Quiz.Part_Count,
      _Quiz.Question_Count,
      _Quiz.SessionUser,
      _Quiz.As_Owner,

      _Activity_Sync.SyncId as SyncId,

      // ----------------------------------------------------------- //
      // For just uploaded quiz there will be no sync/progress data  //
      // ----------------------------------------------------------- //
      @EndUserText.label: 'Not synced'
      @EndUserText.quickInfo: 'Has no sync data available'
      case
        when _Activity_Sync.SyncId is null then 'X'
        else ''
      end                   as No_Sync_Data
}
where
     _Quiz.UploadBy      = _Quiz.SessionUser
  or not _Quiz.Published is initial
