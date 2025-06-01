//
@EndUserText.label: 'Parts (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_PART_R
  as select from znept_qz_prt as _Part

  association to parent ZNEPT_QZ_I_QUIZ_R     as _Quiz on $projection.TestId = _Quiz.TestId

  composition [0..*] of ZNEPT_QZ_I_QUESTION_R as _Question

{
  key _Part.test_id     as TestId,
  key _Part.part_id     as PartId,

      _Part.description as Description,

      /* Associations */

      _Quiz,
      _Question

}
