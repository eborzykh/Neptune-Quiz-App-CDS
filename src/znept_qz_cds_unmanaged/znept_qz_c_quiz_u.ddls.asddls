//
@EndUserText.label: 'Quiz (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true

@Search.searchable: true
define root view entity ZNEPT_QZ_C_QUIZ_U
  provider contract transactional_query
  as projection on ZNEPT_QZ_I_QUIZ_U as _Quiz
{
      @Search.defaultSearchElement: true
  key TestId,

      UploadOn,
      UploadAt,
      UploadBy,
      
      Description,

      @ObjectModel.text.element: ['PublishedText']
      Published,
      PublishedText,

      Part_Count,
      Question_Count,
      Upload_By_Name,
      
      Version,
      
      /* Associations */

      _Part     : redirected to composition child ZNEPT_QZ_C_PART_U,
      _Question : redirected to composition child ZNEPT_QZ_C_QUESTION_U
}
