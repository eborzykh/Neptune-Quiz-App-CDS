//
@EndUserText.label: 'Activity Summary (Calculate View)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC

define view entity ZNEPT_QZ_R_USAGE
  as select from ZNEPT_QZ_I_ACTIVITY_DATA
{
  key SyncId            as SyncId,

      count( * )        as Attempts,

      min (ActiveOn)    as FirstOn,
      max (ActiveOn)    as LastOn,

      min (ActiveTSTMP) as FirstOnTSTMP,
      max (ActiveTSTMP) as LastOnTSTMP
}
group by
  SyncId
