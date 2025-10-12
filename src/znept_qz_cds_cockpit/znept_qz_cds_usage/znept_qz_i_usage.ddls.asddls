//
@EndUserText.label: 'Usage Data (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZNEPT_QZ_I_USAGE 
  as select from    ZNEPT_QZ_I_ACTIVITY_SYNC                        as _Activity_Sync

    left outer join ZNEPT_QZ_R_USAGE                                as _R_Usage               on _Activity_Sync.SyncId = _R_Usage.SyncId

    left outer join ZNEPT_QZ_R_QUESTION                             as _R_Question            on _Activity_Sync.TestId = _R_Question.Test_ID

    left outer join ZNEPT_QZ_R_QUESTION_PROGRESS ( p_correct: 'X',
                                                   p_improved: 'X',
                                                   p_incorrect: ' ',
                                                   p_unanswered: ' ' ) as _R_Progress            on _Activity_Sync.SyncId = _R_Progress.SyncId
    left outer join ZNEPT_QZ_R_QUESTION_PROGRESS ( p_correct: 'X',
                                                   p_improved: ' ',
                                                   p_incorrect: ' ',
                                                   p_unanswered: ' ' ) as _R_Progress_Correct    on _Activity_Sync.SyncId = _R_Progress_Correct.SyncId
    left outer join ZNEPT_QZ_R_QUESTION_PROGRESS ( p_correct: ' ',
                                                   p_improved: 'X',
                                                   p_incorrect: ' ',
                                                   p_unanswered: ' ' ) as _R_Progress_Improved   on _Activity_Sync.SyncId = _R_Progress_Improved.SyncId
    left outer join ZNEPT_QZ_R_QUESTION_PROGRESS ( p_correct: ' ',
                                                   p_improved: ' ',
                                                   p_incorrect: 'X',
                                                   p_unanswered: ' ' ) as _R_Progress_Incorrect  on _Activity_Sync.SyncId = _R_Progress_Incorrect.SyncId
    left outer join ZNEPT_QZ_R_QUESTION_PROGRESS ( p_correct: ' ',
                                                   p_improved: ' ',
                                                   p_incorrect: ' ',
                                                   p_unanswered: 'X' ) as _R_Progress_Unanswered on _Activity_Sync.SyncId = _R_Progress_Unanswered.SyncId

   composition [0..*] of ZNEPT_QZ_I_USAGE_DETAILS as _Usage_Details 
  
{

  key _Activity_Sync.SyncId,
      _Activity_Sync.SyncBy,
  
      _Activity_Sync.UploadOn,
      _Activity_Sync.UploadAt,
      _Activity_Sync.TestId,

      _Activity_Sync._Quiz.Description                                          as Description,

      _R_Question.Question_Count                                                as Total,

      _R_Progress.Progress                                                      as Progress,

      _R_Progress_Correct.Progress                                              as Correct,
      _R_Progress_Incorrect.Progress                                            as Incorrect,
      _R_Progress_Improved.Progress                                             as Improved,
      _R_Progress_Unanswered.Progress                                           as Unanswered,

      _R_Usage.FirstOn                                                          as FirstOn,
      _R_Usage.LastOn                                                           as LastOn,

      DATS_DAYS_BETWEEN($projection.FirstOn, $projection.LastOn)                as UseDays,
      DATS_DAYS_BETWEEN($projection.LastOn, $session.user_date)                 as LastOnDays,

      round ( $projection.Progress / $projection.Total * 100, 0 )               as Percentage,

      case
        when $projection.Percentage is null or $projection.Percentage = 0 then 1
        when $projection.Percentage between 1 and 79 then 2
        when $projection.Percentage between 80 and 100 then 3
        else 0
      end                                                                       as CriticalityCode,

      concat((concat_with_space('Sync entity', _Activity_Sync.SyncId, 1)), '.') as TextTitle,
      concat((concat_with_space('Quiz entity', _Activity_Sync.TestId, 1)), '.') as TextDescription,

      /* Associations */

      _Usage_Details
}
where
  _Activity_Sync.Quiz_Deleted is initial
