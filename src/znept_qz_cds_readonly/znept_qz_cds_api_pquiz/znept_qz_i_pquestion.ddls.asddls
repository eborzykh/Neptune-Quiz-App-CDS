//
@EndUserText.label: 'Personalised Questions (Composite)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE

define view entity ZNEPT_QZ_I_PQUESTION
  as select from ZNEPT_QZ_I_PQUESTION_PROGRESS as _Question_Progress

  association        to parent ZNEPT_QZ_I_PQUIZ as _Quiz on  $projection.TestId = _Quiz.TestId

  composition [1..*] of ZNEPT_QZ_I_PVARIANT     as _Variant

  association [0..1] to ZNEPT_QZ_I_PART         as _Part on  $projection.TestId = _Part.TestId
                                                         and $projection.PartId = _Part.PartId

{
  key _Question_Progress.TestId,
  key _Question_Progress.QuestionId,

      _Question_Progress.PartId,
      _Part.Description as Part_Description,
      _Question_Progress.Question,
      _Question_Progress.Explanation,
      _Question_Progress.Sort,
      _Part.Sort        as Part_Sort,
      _Question_Progress.SyncId,
      _Question_Progress.Progress,
      _Question_Progress.No_Progress,

      /* Associations */

      _Quiz,
      _Part,
      _Variant
}
