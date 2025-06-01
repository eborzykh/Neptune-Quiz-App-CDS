//
@EndUserText.label: 'Parts (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_PART_M
  as select from znept_qz_prt as _Part

  association to parent ZNEPT_QZ_I_QUIZ_M     as _Quiz on $projection.TestId = _Quiz.TestId

  composition [0..*] of ZNEPT_QZ_I_QUESTION_M as _Question

{
  key test_id     as TestId,
  key part_id     as PartId,
  
      description as Description,

      /* Associations */

      _Quiz,
      _Question

}
