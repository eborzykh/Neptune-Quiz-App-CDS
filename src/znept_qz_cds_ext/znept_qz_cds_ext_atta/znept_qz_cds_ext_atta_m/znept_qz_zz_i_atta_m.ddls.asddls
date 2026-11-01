@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Extension'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #COMPOSITE

define view entity ZNEPT_QZ_ZZ_I_ATTA_M
  as select from ZNEPT_QZ_ZZ_I_ATTA as _ZZ_Attachment

  association        to parent ZNEPT_QZ_I_QUIZ_M as _Quiz     on  $projection.TestId = _Quiz.TestId

  association [1..1] to ZNEPT_QZ_I_QUESTION_M    as _Question on  $projection.TestId     = _ZZ_Attachment.TestId
                                                              and $projection.QuestionId = _ZZ_Attachment.QuestionId

{
  key TestId,
  key QuestionId,

      _Quiz.ETag as Etag,

      Attachment,
      MimeType,
      Filename,

      /* Associations */

      _Quiz,
      _Question
}
