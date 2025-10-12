//
@EndUserText.label: 'Usage Details (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_USAGE_DETAILS
  as select from ZNEPT_QZ_R_USAGE_TOTAL as _Usage_Total

  association        to parent ZNEPT_QZ_I_USAGE      as _Usage    on $projection.SyncId = _Usage.SyncId

  composition [0..*] of ZNEPT_QZ_I_USAGE_QUESTIONS   as _Usage_Questions

  association [1] to ZNEPT_QZ_I_ACTIV_PROGRESS_VH as _Progress on $projection.Progress = _Progress.Progress

{ 

  key _Usage_Total.SyncId         as SyncId, 
  key _Usage_Total.Progress       as Progress,

     _Usage.TestId  as TestId,
  
      cast(Progress as abap.int1) as ProgressInt,

      _Progress.ProgressText      as ProgressText,

      _Usage_Total.Progress_Count as Progress_Count,

      case
        when $projection.ProgressInt = 0 then 0
        when $projection.ProgressInt = 1 then 1
        when $projection.ProgressInt between 2 and 4 then 2
        when $projection.ProgressInt = 5 then 3
        else 0
      end                         as CriticalityCode,

      /* Associations */

      _Usage,
      _Usage_Questions
} 
