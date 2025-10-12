//
@EndUserText.label: 'Quiz (Consumption)'

@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['TestId']

define root view entity ZNEPT_QZ_C_QUIZ_ATT
  provider contract transactional_query
  as projection on ZNEPT_QZ_I_QUIZ_ATT as _Quiz
{
          @Search.defaultSearchElement: true
  key     TestId,

          UploadOn,
          UploadAt,
          UploadTSTMP,
          UploadBy,
          
          Upload_By_Name,
          Description,
          Published,
           
          Part_Count,
          Question_Count,

          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC_ATT'
  virtual StreamFileName : abap.char(128),

          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC_ATT'
          @Semantics.mimeType: true
  virtual StreamMimeType : abap.char(128),

          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC_ATT'
          @Semantics.largeObject: {

            acceptableMimeTypes: [ 'text/*' ],
            cacheControl.maxAge: #MEDIUM,
            contentDispositionPreference: #INLINE, // #ATTACHMENT - download as file
                                                       // #INLINE - open in new window
            fileName     : 'StreamFileName',
            mimeType     : 'StreamMimeType'
          }
  virtual StreamFile     : abap.rawstring(0)

}
