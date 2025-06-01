//
@EndUserText.label: 'Quiz (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZNEPT_QZ_I_QUIZ_R
  as select from    znept_qz_tst        as _Quiz
    left outer join ZNEPT_QZ_R_PART     as _R_Part     on _Quiz.test_id = _R_Part.Test_ID
    left outer join ZNEPT_QZ_R_QUESTION as _R_Question on _Quiz.test_id = _R_Question.Test_ID

  composition [0..*] of ZNEPT_QZ_I_PART_R     as _Part

  association [0..*] to ZNEPT_QZ_I_VARIANT_R  as _Variant  on $projection.TestId = _Variant.TestId

  association [0..*] to ZNEPT_QZ_I_QUESTION_R as _Question on $projection.TestId = _Question.TestId

{

  key _Quiz.test_id                       as TestId,

      _Quiz.upload_on                     as UploadOn,
      _Quiz.upload_at                     as UploadAt,
      _Quiz.upload_by                     as UploadBy,
      _Quiz.published                     as Published,
      _Quiz.description                   as Description,

      _R_Part.Part_Count                  as Part_Count,
      _R_Question.Question_Count          as Question_Count,

      case
        when _R_Part.Part_Count > 0 then '' else 'X'
      end                                 as UI_Hide_Part,

      case
        when _R_Part.Part_Count > 0 then 'X' else ''
      end                                 as UI_Hide_Question,

      case
        when _Quiz.published is initial then 'Private'
        else 'Published'
      end                                 as UI_Published,
      
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC_QUIZ'
      cast('' as znept_qz_upload_name_de) as Upload_By_Name,

      /* Associations */

      _Part,
      _Question,
      _Variant
}
