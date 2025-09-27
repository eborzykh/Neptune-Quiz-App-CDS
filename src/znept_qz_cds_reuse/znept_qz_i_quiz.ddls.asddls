//
@EndUserText.label: 'Quiz (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUIZ
  as select from    znept_qz_tst        as _Quiz
    left outer join ZNEPT_QZ_R_PART     as _R_Part     on _Quiz.test_id = _R_Part.Test_ID
    left outer join ZNEPT_QZ_R_QUESTION as _R_Question on _Quiz.test_id = _R_Question.Test_ID

  association [1..1] to ZNEPT_QZ_I_QUIZ_PUBLISHED_VH as _Published on $projection.Published = _Published.Published

{

  key _Quiz.test_id                       as TestId,

      _Quiz.upload_on                     as UploadOn,
      _Quiz.upload_at                     as UploadAt,
      _Quiz.upload_by                     as UploadBy,
      _Quiz.description                   as Description,

      _Quiz.published                     as Published,
      _Published.PublishedText            as PublishedText,

      _R_Part.Part_Count                  as Part_Count,
      _R_Question.Question_Count          as Question_Count,

      //      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC_QUIZ'
      cast('' as znept_qz_upload_name_de) as Upload_By_Name
}
