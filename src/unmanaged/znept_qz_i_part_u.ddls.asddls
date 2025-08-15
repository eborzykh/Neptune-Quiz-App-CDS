//
@EndUserText.label: 'Parts (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_PART_U
  as select from znept_qz_prt as _Part

  association        to parent ZNEPT_QZ_I_QUIZ_U as _Quiz     on  $projection.TestId = _Quiz.TestId

  association [0..*] to ZNEPT_QZ_I_QUESTION_U    as _Question on  $projection.TestId = _Question.TestId
                                                              and $projection.PartId = _Question.PartId

{
  key test_id     as TestId,
  key part_id     as PartId,

      description as Description,
      
      case
        when sort is initial then part_id
        else sort
      end         as Sort,

      /* Associations */

      _Quiz,
      _Question
}
