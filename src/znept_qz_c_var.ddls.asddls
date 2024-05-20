@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_C_VAR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Variants (Consumption)'

@Metadata.allowExtensions: true

define view ZNEPT_QZ_C_VAR
  as select from ZNEPT_QZ_I_VAR as _Variants

  association        to parent ZNEPT_QZ_C_QST as _Questions on  $projection.Test_ID     = _Questions.Test_ID
                                                            and $projection.Part_ID     = _Questions.Part_ID
                                                            and $projection.Question_ID = _Questions.Question_ID

  association [1..1] to ZNEPT_QZ_C_TST        as _Quiz      on  $projection.Test_ID = _Quiz.Test_ID

{

  key _Variants.Test_ID,
  key _Variants.Part_ID,
  key _Variants.Question_ID,
  key _Variants.Variant_ID,

      _Variants.Correct,
      _Variants.Variant,

      /* Associations */

      _Questions,
      _Quiz
}
