//
@EndUserText.label: 'Quiz (Consumption)'

@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['TestId']

define root view entity ZNEPT_QZ_C_QUIZ_M
  provider contract transactional_query
  as projection on ZNEPT_QZ_I_QUIZ_M as _Quiz
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

      UI_Published,

      /* Associations */

      _Part     : redirected to composition child ZNEPT_QZ_C_PART_M,
      _Question : redirected to ZNEPT_QZ_C_QUESTION_M,
      _Variant  : redirected to ZNEPT_QZ_C_VARIANT_M

}
