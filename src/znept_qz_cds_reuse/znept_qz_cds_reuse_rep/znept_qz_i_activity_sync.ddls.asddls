//
@EndUserText.label: 'Activity Sync (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_ACTIVITY_SYNC
  as select from ZNEPT_QZ_V_ACTIVITY_SYNC as _Activity_Sync

  association [1..1] to ZNEPT_QZ_I_QUIZ as _Quiz on  $projection.TestId   = _Quiz.TestId
                                                 and $projection.UploadOn = _Quiz.UploadOn
                                                 and $projection.UploadAt = _Quiz.UploadAt

{

  key _Activity_Sync.SyncBy   as SyncBy,
  key _Activity_Sync.TestId   as TestId,
  key _Activity_Sync.UploadOn as UploadOn,
  key _Activity_Sync.UploadAt as UploadAt,

      _Activity_Sync.SyncId   as SyncId,

      // -------------------------------------------------- //
      // Progress and activity remains for deleted content  //
      // -------------------------------------------------- //
      case
        when _Quiz.TestId is null then 'X'
        else ''
      end                     as Quiz_Deleted,

      /* Associations */

      _Quiz
}
