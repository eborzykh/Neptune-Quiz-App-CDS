//
@EndUserText.label: 'Usage Questions (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_USAGE_QUESTIONS
  as select from ZNEPT_QZ_I_QUESTION_PROGRESS as _Activity_Progress

  association     to parent ZNEPT_QZ_I_USAGE_DETAILS as _Usage_Details on  $projection.SyncId   = _Usage_Details.SyncId
                                                                       and $projection.Progress = _Usage_Details.Progress

  association [1] to ZNEPT_QZ_I_USAGE                as _Usage         on  $projection.SyncId = _Usage.SyncId

{

  key _Activity_Progress.SyncId      as SyncId,
  key _Activity_Progress.QuestionId  as QuestionId,

      _Activity_Progress.TestId      as TestId,

      _Activity_Progress.PartId      as PartId,
      _Activity_Progress.Question    as Question,
      _Activity_Progress.Explanation as Explanation,
      _Activity_Progress.Sort        as Sort,

      _Activity_Progress.Progress    as Progress,

      _Usage_Details.CriticalityCode as CriticalityCode,

      /* Associations */

      _Usage,
      _Usage_Details
}
