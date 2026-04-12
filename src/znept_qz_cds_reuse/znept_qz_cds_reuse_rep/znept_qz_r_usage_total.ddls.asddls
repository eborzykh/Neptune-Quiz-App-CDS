//
@EndUserText.label: 'Usage Total (Group View)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC

define view entity ZNEPT_QZ_R_USAGE_TOTAL
  as select from ZNEPT_QZ_I_PROGRESS_QUESTION as _Question_Progress
{
  key _Question_Progress.SyncId   as SyncId,
  key _Question_Progress.Progress as Progress,

      count ( * )                 as Progress_Count
}
group by
  SyncId,
  Progress
