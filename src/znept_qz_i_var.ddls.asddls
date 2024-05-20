@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_I_VAR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Variants (Basic)'

define view ZNEPT_QZ_I_VAR as select from znept_qz_var as _Variants
{
  key _Variants.test_id     as Test_ID,
  key _Variants.part_id     as Part_ID, 
  key _Variants.question_id as Question_ID,
  key _Variants.variant_id  as Variant_ID,

      _Variants.correct     as Correct,
      _Variants.variant     as Variant
}
