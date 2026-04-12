//
@EndUserText.label: 'Personalised Questions (Composite)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE

define view entity ZNEPT_QZ_I_PQUESTION_SYNC
  as select from ZNEPT_QZ_I_QUESTION as _Question

  association [1] to ZNEPT_QZ_I_PQUIZ_SYNC as _Quiz_Sync on _Quiz_Sync.TestId = _Question.TestId

{
  key _Question.TestId,
  key _Question.QuestionId,

      _Question.PartId,
      _Question.Question,
      _Question.Explanation,
      _Question.Sort,

      _Quiz_Sync.SyncId,

      /* Associations */

      _Quiz_Sync
}
