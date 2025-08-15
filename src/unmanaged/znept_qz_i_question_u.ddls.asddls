//
@EndUserText.label: 'Questions (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUESTION_U
  as select from znept_qz_qst as _Question

  association        to parent ZNEPT_QZ_I_QUIZ_U as _Quiz on  $projection.TestId = _Quiz.TestId

  association [0..1] to ZNEPT_QZ_I_PART_U        as _Part on  $projection.TestId = _Part.TestId
                                                          and $projection.PartId = _Part.PartId

  composition [0..*] of ZNEPT_QZ_I_VARIANT_U     as _Variant

{
  key test_id     as TestId,
  key question_id as QuestionId,

      part_id     as PartId,
      question    as Question,
      explanation as Explanation,

      case
        when sort is initial then question_id
        else sort
      end         as SortQuestion,

      _Part.Sort  as SortPart,

      /* Associations */

      _Quiz,
      _Part,
      _Variant
}
