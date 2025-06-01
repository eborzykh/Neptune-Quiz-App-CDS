//
@EndUserText.label: 'Variant Correct Count (Calculate View)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_R_VARIANT_CORRECT
  as select from znept_qz_var
{
  key test_id     as Test_ID,
  key question_id as Question_ID,
      count (*)   as Variant_Count
}
where 
  correct is not initial
group by
  test_id,
  question_id
