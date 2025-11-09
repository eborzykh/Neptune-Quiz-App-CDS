//
@EndUserText.label: 'Parts (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_PART_M
  as select from ZNEPT_QZ_I_PART as _Part

  association        to parent ZNEPT_QZ_I_QUIZ_M as _Quiz     on  $projection.TestId = _Quiz.TestId

  association [0..*] to ZNEPT_QZ_I_QUESTION_M    as _Question on  $projection.TestId = _Question.TestId
                                                              and $projection.PartId = _Question.PartId

{
  key _Part.TestId      as TestId,
  key _Part.PartId      as PartId,

      _Part.Sort        as Sort,
      _Part.Description as Description,
      _Part.Version     as Version,

      /* Associations */

      _Quiz,
      _Question
}
