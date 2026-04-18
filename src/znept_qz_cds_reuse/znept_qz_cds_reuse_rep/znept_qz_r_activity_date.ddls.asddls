//
@EndUserText.label: 'Activity Data (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC

define view entity ZNEPT_QZ_R_ACTIVITY_DATE
  as select from ZNEPT_QZ_I_ACTIVITY_DATA as _Activity_Data
{
  key _Activity_Data.SyncId              as SyncId,
  key _Activity_Data.QuestionId          as QuestionId,

      max ( _Activity_Data.ActiveTSTMP ) as ActiveTSTMP
}
group by
  _Activity_Data.SyncId,
  _Activity_Data.QuestionId
