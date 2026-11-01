//
@EndUserText.label: 'Questions (ZNEPT_QZ_I_QUESTION_VH)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE

//@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZNEPT_QZ_I_QUESTION_VH
  as select from ZNEPT_QZ_I_QUESTION as _Question_VH

{

  key TestId,
  key QuestionId,

      PartId,

      @Semantics.text: true
      Question

}
