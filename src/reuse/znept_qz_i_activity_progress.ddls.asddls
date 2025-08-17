//
@EndUserText.label: 'Activity and Progress (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_ACTIVITY_PROGRESS
  as select from znept_qz_mtd as _Activity_Progress

  association [1..1] to ZNEPT_QZ_I_ACTIV_PROGRESS_VH as _Progress on $projection.Progress = _Progress.Progress
  
{

  key _Activity_Progress.sync_id     as SyncId,
  key _Activity_Progress.question_id as QuestionId,
  key _Activity_Progress.active_on   as ActiveOn,
  key _Activity_Progress.active_at   as ActiveAt,

      _Activity_Progress.sync_on     as SyncOn,
      _Activity_Progress.sync_at     as SyncAt,
      _Activity_Progress.progress    as Progress,

      _Progress.ProgressText  as ProgressText

}
