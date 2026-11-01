@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Extencion'
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION

define view entity ZNEPT_QZ_ZZ_C_ATTA_M
  as projection on ZNEPT_QZ_ZZ_I_ATTA_M
{
  key TestId,
  
  @Consumption.valueHelpDefinition: [{entity: { name: 'ZNEPT_QZ_I_QUESTION_VH', element: 'QuestionId' } }]
  key QuestionId,

      Attachment,
      MimeType,
      Filename,

      /* Associations */

      _Quiz     : redirected to parent ZNEPT_QZ_C_QUIZ_M
}
