@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_I_C1'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Parts Count (Calculate View)'

define view ZNEPT_QZ_I_C1
  as select from znept_qz_prt
{
  key test_id   as Test_ID,
      count (*) as Parts_Count
}
group by
  test_id
