//
@EndUserText.label: 'Quiz (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUIZ
  as select from    znept_qz_tst        as _Quiz

    left outer join ZNEPT_QZ_R_PART     as _R_Part     on _Quiz.test_id = _R_Part.Test_ID
    left outer join ZNEPT_QZ_R_QUESTION as _R_Question on _Quiz.test_id = _R_Question.Test_ID

  association [1] to ZNEPT_QZ_I_QUIZ_PUBLISHED_VH as _Published on $projection.Published = _Published.Published

{
  key _Quiz.test_id                                                     as TestId,

      _Quiz.upload_on                                                   as UploadOn,
      _Quiz.upload_at                                                   as UploadAt,
      _Quiz.upload_by                                                   as UploadBy,

      DATS_TIMS_TO_TSTMP ( _Quiz.upload_on, _Quiz.upload_at,
                           $session.user_timezone, $session.client,
                           'NULL' )                                     as UploadTSTMP,

      // ETag calculation
      CONCAT(_Quiz.upload_by, CONCAT(_Quiz.upload_on, _Quiz.upload_at)) as ETag,

      // @ObjectModel.readOnly: true
      // for non read-only scenario apply: field ( readonly ) .. Upload_By_Name ..
      @EndUserText.label: 'Uploaded By'
      @EndUserText.quickInfo:'Quiz Uploaded By User'
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC_QUIZ'
      cast('' as znept_qz_upload_name_de)                               as Upload_By_Name,

      _Quiz.version                                                     as Version, // to be replaced with hash-key
      _Quiz.description                                                 as Description,
      _Quiz.published                                                   as Published,
      _Published.PublishedText                                          as PublishedText,

      @EndUserText.label: 'Parts Count'
      @EndUserText.quickInfo: 'Number of Parts in this Quiz'
      _R_Part.Part_Count                                                as Part_Count,

      @EndUserText.label: 'Questions Count'
      @EndUserText.quickInfo: 'Number of Questions in this Quiz'
      _R_Question.Question_Count                                        as Question_Count
}
