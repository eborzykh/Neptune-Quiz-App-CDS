//
@EndUserText.label: 'Activity Sync (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_V_ACTIVITY_SYNC
  as select from znept_qz_mts as _Activity_Sync

{

  key _Activity_Sync.sync_by   as SyncBy,
  key _Activity_Sync.test_id   as TestId,
  key _Activity_Sync.upload_on as UploadOn,
  key _Activity_Sync.upload_at as UploadAt,

      _Activity_Sync.sync_id   as SyncId
      
}
