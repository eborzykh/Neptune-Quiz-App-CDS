//
@EndUserText.label: 'Personalised Questions (Composite)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE

define view entity ZNEPT_QZ_I_PQUESTION_PROGRESS
  as select from ZNEPT_QZ_I_PQUESTION_SYNC as _Question_Sync

  association [0..1] to ZNEPT_QZ_I_PROGRESS_QUESTION as _Question_Progress on  $projection.SyncId     = _Question_Progress.SyncId
                                                                           and $projection.QuestionId = _Question_Progress.QuestionId

{
  key _Question_Sync.TestId,
  key _Question_Sync.QuestionId,

      _Question_Sync.PartId,
      _Question_Sync.Question,
      _Question_Sync.Explanation,
      _Question_Sync.Sort,
      _Question_Sync.SyncId,

      _Question_Progress.Progress,
      // ----------------------------------------------------------- //
      // For just uploaded quiz there will be no sync/progress data  //
      // ----------------------------------------------------------- //
      @EndUserText.label: 'No progress'
      @EndUserText.quickInfo: 'No progress available for this question'
      case
        when _Question_Progress.Progress is null then 'X'
        else ''
      end as No_Progress
}
