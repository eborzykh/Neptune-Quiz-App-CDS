//
@EndUserText.label: 'Activity and Progress (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_ACTIVITY_PROGRESS
  as select from ZNEPT_QZ_R_ACTIVITY_DATE as _Activity_Date

  /*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ] }*/
  association [1] to ZNEPT_QZ_V_ACTIVITY_DATA as _Activity      on  _Activity.SyncId      = $projection.SyncId
                                                                and _Activity.QuestionId  = $projection.QuestionId
                                                                and _Activity.ActiveTSTMP = $projection.ActiveTSTMP

  /*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ] }*/
  association [1] to ZNEPT_QZ_I_ACTIVITY_SYNC as _Activity_Sync on  _Activity_Sync.SyncId = $projection.SyncId

{

  key _Activity_Date.SyncId      as SyncId,
  key _Activity_Sync.TestId      as TestId,
  key _Activity_Date.QuestionId  as QuestionId,

      _Activity_Date.ActiveTSTMP as ActiveTSTMP,

      _Activity.ActiveOn         as ActiveOn,
      _Activity.ActiveAt         as ActiveAt,

      _Activity.Progress         as Progress

}
where
  _Activity_Sync.Quiz_Deleted is initial
