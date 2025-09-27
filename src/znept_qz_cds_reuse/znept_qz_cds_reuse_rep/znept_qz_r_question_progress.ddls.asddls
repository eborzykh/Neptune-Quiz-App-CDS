//
@EndUserText.label: 'Usage Calculation (Calculate View)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_R_QUESTION_PROGRESS
  with parameters
    @Consumption.defaultValue: ''
    p_correct    : boolean,
    @Consumption.defaultValue: ''
    p_improved   : boolean,
    @Consumption.defaultValue: ''
    p_incorrect  : boolean,
    @Consumption.defaultValue: ''
    p_unanswered : boolean

  as select from ZNEPT_QZ_I_QUESTION_PROGRESS as _Question_Progress
{

  key _Question_Progress.SyncId as SyncId,
      count (*)                 as Progress

}
where
  (
        $parameters.p_correct       =       'X'
    and _Question_Progress.Progress =       '5'
  )
  or(
        $parameters.p_improved      =       'X'
    and _Question_Progress.Progress between '2' and '4'
  )
  or(
        $parameters.p_incorrect     =       'X'
    and _Question_Progress.Progress =       '1'
  )
  or(
        $parameters.p_unanswered    =       'X'
    and _Question_Progress.Progress =       '0'
  )

group by
  _Question_Progress.SyncId
