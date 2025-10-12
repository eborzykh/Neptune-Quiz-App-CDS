//
@EndUserText.label: 'Quiz (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZNEPT_QZ_I_QUIZ_ATT
  as select from ZNEPT_QZ_I_QUIZ as _Quiz

{

  key _Quiz.TestId         as TestId,

      _Quiz.UploadOn       as UploadOn,
      _Quiz.UploadAt       as UploadAt,
      _Quiz.UploadTSTMP    as UploadTSTMP,
      _Quiz.UploadBy       as UploadBy,
      
      _Quiz.Upload_By_Name as Upload_By_Name,
       
      _Quiz.Published      as Published,
      _Quiz.Description    as Description,

      _Quiz.Part_Count     as Part_Count,
      _Quiz.Question_Count as Question_Count
      
}
