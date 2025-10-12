//
@EndUserText.label: 'Activity Data (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_V_ACTIVITY_DATA
  as select from znept_qz_mtd as _Activity_Data

{

  key    _Activity_Data.sync_id         as SyncId,
  key    _Activity_Data.question_id     as QuestionId,
  key    _Activity_Data.active_on       as ActiveOn,
  key    _Activity_Data.active_at       as ActiveAt,

         DATS_TIMS_TO_TSTMP ( active_on,
                               active_at,
                               $session.user_timezone,
                               $session.client,
                               'NULL' ) as ActiveTSTMP,

         _Activity_Data.sync_on         as SyncOn,
         _Activity_Data.sync_at         as SyncAt,

         _Activity_Data.progress        as Progress
}
