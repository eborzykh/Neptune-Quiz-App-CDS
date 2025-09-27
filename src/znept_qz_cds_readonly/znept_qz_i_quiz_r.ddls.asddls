//
@EndUserText.label: 'Quiz (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZNEPT_QZ_I_QUIZ_R
  as select from ZNEPT_QZ_I_QUIZ as _Quiz

  composition [0..*] of ZNEPT_QZ_I_PART_R     as _Part

  association [0..*] to ZNEPT_QZ_I_VARIANT_R  as _Variant  on $projection.TestId = _Variant.TestId

  association [0..*] to ZNEPT_QZ_I_QUESTION_R as _Question on $projection.TestId = _Question.TestId

{

  key _Quiz.TestId         as TestId,

      _Quiz.UploadOn       as UploadOn,
      _Quiz.UploadAt       as UploadAt,
      _Quiz.UploadBy       as UploadBy,
      _Quiz.Published      as Published,
      _Quiz.Description    as Description,

      _Quiz.Upload_By_Name as Upload_By_Name,
      _Quiz.Part_Count     as Part_Count,
      _Quiz.Question_Count as Question_Count,
      _Quiz.PublishedText  as UI_Published,

      case
        when Part_Count > 0 then '' else 'X'
      end                  as UI_Hide_Part,

      case
        when Part_Count > 0 then 'X' else ''
      end                  as UI_Hide_Question,

      /* Associations */

      _Part,
      _Question,
      _Variant
}
