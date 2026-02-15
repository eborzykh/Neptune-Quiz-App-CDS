//
@EndUserText.label: 'Quiz (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZNEPT_QZ_I_QUIZ_LOAD
  as select from ZNEPT_QZ_I_QUIZ as _Quiz

  composition [0..*] of ZNEPT_QZ_I_PART_LOAD     as _Part

  composition [0..*] of ZNEPT_QZ_I_QUESTION_LOAD as _Question

{

  key _Quiz.TestId         as TestId,

      _Quiz.ETag           as ETag,
      _Quiz.UploadTSTMP    as UploadTSTMP,

      _Quiz.UploadOn       as UploadOn,
      _Quiz.UploadAt       as UploadAt,
      _Quiz.UploadBy       as UploadBy,
      _Quiz.Published      as Published,
      _Quiz.Description    as Description,
      _Quiz.Version        as Version,

      _Quiz.Part_Count     as Part_Count,
      _Quiz.Question_Count as Question_Count,
      _Quiz.PublishedText  as UI_Published,
      _Quiz.Upload_By_Name as Upload_By_Name,

      /* Associations */

      _Part,
      _Question

}
