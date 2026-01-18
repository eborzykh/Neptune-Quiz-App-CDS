//
@EndUserText.label: 'Quiz (Consumption)'

@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['TestId']

define root view entity ZNEPT_QZ_C_QUIZ_D
  provider contract transactional_query
  as projection on ZNEPT_QZ_I_QUIZ_D as _Quiz
{
      @Search.defaultSearchElement: true
  key TestId,

      UploadOn,
      UploadAt,
      UploadBy,
      Published,
      Description,

      Version,

      Part_Count,
      Question_Count,
      Upload_By_Name,

      UI_Published,

      /* Associations */

      _Part     : redirected to composition child ZNEPT_QZ_C_PART_D,
      _Question : redirected to composition child ZNEPT_QZ_C_QUESTION_D
}
