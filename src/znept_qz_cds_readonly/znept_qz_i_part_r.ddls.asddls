//
@EndUserText.label: 'Parts (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_PART_R
  as select from ZNEPT_QZ_I_PART as _Part

  association to parent ZNEPT_QZ_I_QUIZ_R     as _Quiz on $projection.TestId = _Quiz.TestId

  composition [0..*] of ZNEPT_QZ_I_QUESTION_R as _Question

{
  key _Part.TestId      as TestId,
  key _Part.PartId      as PartId,

      _Part.Description as Description,

      /* Associations */

      _Quiz,
      _Question
}
