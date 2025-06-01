//
@EndUserText.label: 'Parts Count (Calculate View)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_R_PART
  as select from znept_qz_prt
{
  key test_id   as Test_ID,
      count (*) as Part_Count
}
group by
  test_id
