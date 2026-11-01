@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Neptune Quiz App (CDS): Media Images'
@VDM.viewType: #BASIC

define view entity ZNEPT_QZ_ZZ_I_ATTA
  as select from znept_qz_att as _ZZ_Attachment
{
  key test_id     as TestId,
  key question_id as QuestionId,

      @Semantics.largeObject: { acceptableMimeTypes: [ 'image/*', 'application/*' ], 
                                cacheControl.maxAge: #MEDIUM,
                                contentDispositionPreference: #INLINE, // #ATTACHMENT - download as file
                                                                       // #INLINE - open in new window
                                fileName : 'Filename',
                                mimeType : 'MimeType' }
      attachment  as Attachment,

      @Semantics.mimeType: true
      mime_type   as MimeType,
      filename    as Filename
}
