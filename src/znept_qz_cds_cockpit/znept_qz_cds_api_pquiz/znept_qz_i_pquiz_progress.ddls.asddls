//
@EndUserText.label: 'Personalised List (Composite)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE

define view entity ZNEPT_QZ_I_PQUIZ_PROGRESS
  as select from    ZNEPT_QZ_I_PQUIZ_SYNC                              as _Quiz_Sync

    left outer join ZNEPT_QZ_R_PROGRESS_QUESTION ( p_correct: 'X',
                                                   p_improved: 'X',
                                                   p_incorrect: ' ',
                                                   p_unanswered: ' ' ) as _R_Progress on _Quiz_Sync.SyncId = _R_Progress.SyncId

{
  key _Quiz_Sync.TestId,

      _Quiz_Sync.UploadOn,
      _Quiz_Sync.UploadAt,
      _Quiz_Sync.UploadBy,
      _Quiz_Sync.UploadTSTMP,
      _Quiz_Sync.ETag,
      _Quiz_Sync.Upload_By_Name,
      _Quiz_Sync.Description,
      _Quiz_Sync.Published,
      _Quiz_Sync.Part_Count,
      _Quiz_Sync.Question_Count,
      _Quiz_Sync.SessionUser,
      _Quiz_Sync.As_Owner,
      _Quiz_Sync.SyncId,
      _Quiz_Sync.No_Sync_Data,

      @EndUserText.label: 'Correct'
      @EndUserText.quickInfo: 'Correct answers'
      _R_Progress.Progress                                                                             as Progress,

      @EndUserText.label: 'Percentage'
      @EndUserText.quickInfo: 'Percentage of correct answers'
      cast( round ( $projection.Progress / $projection.question_count * 100, 0 ) as abap.dec( 5, 2 ) ) as Percentage
}
