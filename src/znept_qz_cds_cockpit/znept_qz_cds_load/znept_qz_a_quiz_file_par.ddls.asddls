//
@EndUserText.label: 'Abstract Entity for Attachment Par'

//@Metadata: {
//    allowExtensions: true
//}

define root abstract entity ZNEPT_QZ_A_QUIZ_FILE_PAR
{
  _StreamFile : association [1] to ZNEPT_QZ_A_QUIZ_FILE on 1 = 1;
  
  @UI.hidden: true
  dummy : abap.char( 1 );
}
