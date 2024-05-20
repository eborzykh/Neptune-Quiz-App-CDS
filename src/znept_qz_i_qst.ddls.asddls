@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_I_QST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Questions (Basic)'

define view ZNEPT_QZ_I_QST as select from znept_qz_qst as _Questions
{
  key _Questions.test_id     as Test_ID,
  key _Questions.part_id     as Part_ID,
  key _Questions.question_id as Question_ID,

      _Questions.question    as Question,
      _Questions.explanation as Explanation
}
