@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_I_C2'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Questions Count (Calculate View)'

define view ZNEPT_QZ_I_C2
  as select from znept_qz_qst
{
  key test_id   as Test_ID,
      count (*) as Questions_Count
}
group by
  test_id
