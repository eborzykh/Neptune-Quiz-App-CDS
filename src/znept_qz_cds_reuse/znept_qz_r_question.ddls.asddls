//
@EndUserText.label: 'Questions Count (Calculate View)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_R_QUESTION
  as select from znept_qz_qst
{
  key test_id   as Test_ID,
      count (*) as Question_Count
}
group by
  test_id
