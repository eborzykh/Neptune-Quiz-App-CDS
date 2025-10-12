//
@EndUserText.label: 'Abstract Entity for Attachment'

@Metadata: {
    allowExtensions: true
}

define root abstract entity ZNEPT_QZ_A_QUIZ_ATT
{

  @EndUserText.label: 'Attachment file'
  @Semantics.largeObject: {
  
    acceptableMimeTypes: [ 'text/*' ],
    cacheControl.maxAge: #MEDIUM,
    contentDispositionPreference: #INLINE, // #ATTACHMENT - download as file
                                               // #INLINE - open in new window
  
    fileName     : 'Filename',
    mimeType     : 'MimeType'
  }
  StreamFile     : abap.rawstring(0);

  @UI.hidden: true
  @Semantics.mimeType: true
  MimeType : abap.char(128);

  @UI.hidden: true
  Filename : abap.char(128);

}
