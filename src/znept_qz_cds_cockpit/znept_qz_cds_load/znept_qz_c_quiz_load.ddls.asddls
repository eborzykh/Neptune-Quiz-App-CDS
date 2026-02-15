//
@EndUserText.label: 'Quiz (Consumption)'

@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['TestId']

define root view entity ZNEPT_QZ_C_QUIZ_LOAD
  provider contract transactional_query
  as projection on ZNEPT_QZ_I_QUIZ_LOAD as _Quiz
{
          @Search.defaultSearchElement: true
  key     TestId,

          UploadOn,
          UploadAt,
          UploadBy,
          Published,
          Description,
          
          UploadTSTMP,

          Part_Count,
          Question_Count,
          Upload_By_Name,

          UI_Published,

          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC_LOAD'
  virtual StreamFileName : abap.char(128),

          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC_LOAD'
          @Semantics.mimeType: true
  virtual StreamMimeType : abap.char(128),

          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC_LOAD'
          @Semantics.largeObject: { acceptableMimeTypes: [ 'text/*' ],
                                    cacheControl.maxAge: #MEDIUM,
                                    contentDispositionPreference: #INLINE, // #ATTACHMENT - download as file
                                                                           // #INLINE - open in new window
                                    fileName : 'StreamFileName',
                                    mimeType : 'StreamMimeType' }
                                    
  virtual StreamFile     : abap.rawstring(0),

          /* Associations */

          _Part     : redirected to composition child ZNEPT_QZ_C_PART_LOAD,
          _Question : redirected to composition child ZNEPT_QZ_C_QUESTION_LOAD
}
