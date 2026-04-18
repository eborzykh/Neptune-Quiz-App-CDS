//
@EndUserText.label: 'Activity Sync (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE

define view entity ZNEPT_QZ_I_ACTIVITY_SYNC
  as select from znept_qz_mts as _Activity_Sync

  association [1] to ZNEPT_QZ_I_QUIZ as _Quiz on  $projection.TestId   = _Quiz.TestId
                                              and $projection.UploadOn = _Quiz.UploadOn
                                              and $projection.UploadAt = _Quiz.UploadAt
{
  key _Activity_Sync.sync_by   as SyncBy,
  key _Activity_Sync.test_id   as TestId,
  key _Activity_Sync.upload_on as UploadOn,
  key _Activity_Sync.upload_at as UploadAt,

      _Activity_Sync.sync_id   as SyncId,

      // ------------------------------------------------- //
      // Progress and activity remain for deleted content  //
      // ------------------------------------------------- //
      case
        when _Quiz.TestId is null then 'X'
        else ''
      end                      as Quiz_Deleted,

      /* Associations */

      _Quiz
}
