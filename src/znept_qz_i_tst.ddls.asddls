@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_I_TST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Quiz (Basic)'

define root view ZNEPT_QZ_I_TST
  as select from    znept_qz_tst  as _Quiz
    left outer join ZNEPT_QZ_I_C1 as _C1 on _Quiz.test_id = _C1.Test_ID
    left outer join ZNEPT_QZ_I_C2 as _C2 on _Quiz.test_id = _C2.Test_ID

{
  key _Quiz.test_id                     as Test_ID,

      _Quiz.upload_on                   as Upload_On,
      _Quiz.upload_at                   as Upload_At,
      _Quiz.upload_by                   as Upload_By,

      _Quiz.published                   as Published,
      _Quiz.description                 as Description,

      _C1.Parts_Count                   as Parts_Count,
      _C2.Questions_Count               as Questions_Count,

      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_NEPT_QZ_EXIT_CALC'
      cast('' as znept_qz_upload_name_de) as Upload_By_Name
}
