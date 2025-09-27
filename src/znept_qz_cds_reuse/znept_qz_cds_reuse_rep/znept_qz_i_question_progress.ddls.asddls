//
@EndUserText.label: 'Activity and Progress (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUESTION_PROGRESS
  as select from    ZNEPT_QZ_I_ACTIVITY_SYNC as _Activity_Sync

    left outer join ZNEPT_QZ_I_QUESTION      as _Question on _Question.TestId = _Activity_Sync.TestId

  association [1] to ZNEPT_QZ_I_ACTIVITY_PROGRESS as _Activity_Progress on  _Activity_Progress.SyncId     = $projection.SyncId
                                                                        and _Activity_Progress.TestId     = $projection.TestId
                                                                        and _Activity_Progress.QuestionId = $projection.QuestionId

{

  key _Activity_Sync.SyncId as SyncId,
  key _Question.QuestionId  as QuestionId,

      _Question.TestId      as TestId,

      _Question.PartId      as PartId,
      _Question.Question    as Question,
      _Question.Explanation as Explanation,
      _Question.Sort        as Sort,

      case
        when _Activity_Progress.Progress is null then '0'
        else _Activity_Progress.Progress
      end                   as Progress

}
