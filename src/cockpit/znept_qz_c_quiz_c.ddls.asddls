//
@EndUserText.label: 'Quiz (Consumption)'

@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['TestId']

define root view entity ZNEPT_QZ_C_QUIZ_C
  provider contract transactional_query
  as projection on ZNEPT_QZ_I_QUIZ_C as _Quiz
{
      @Search.defaultSearchElement: true
  key TestId,

      UploadOn,
      UploadAt,
      UploadBy,
      Published,
      Description,

      Part_Count,
      Question_Count,
      Upload_By_Name,

      UI_Hide_Part,
      UI_Hide_Question,
      UI_Published,

      /* Associations */

      _Part     : redirected to composition child ZNEPT_QZ_C_PART_C,
      _Question : redirected to ZNEPT_QZ_C_QUESTION_C,
      _Variant  : redirected to ZNEPT_QZ_C_VARIANT_C

}
