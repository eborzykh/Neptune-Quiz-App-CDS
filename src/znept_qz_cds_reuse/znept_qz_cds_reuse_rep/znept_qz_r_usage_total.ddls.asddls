//
@EndUserText.label: 'Usage Total (Group View)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_R_USAGE_TOTAL
  as select from ZNEPT_QZ_I_QUESTION_PROGRESS as _Question_Progress

{

  key _Question_Progress.SyncId   as SyncId,
  key _Question_Progress.Progress as Progress,

      count ( * )                 as Progress_Count

}

//where
//  Quiz_Deleted is initial

group by
  SyncId,
  Progress
