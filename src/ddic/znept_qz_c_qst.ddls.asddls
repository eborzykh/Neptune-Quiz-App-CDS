//
@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_C_QST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Questions (Consumption)'

@Metadata.allowExtensions: true

define view ZNEPT_QZ_C_QST
  as select from ZNEPT_QZ_I_QST as _Questions

  association        to parent ZNEPT_QZ_C_PRT as _Parts on  $projection.Test_ID = _Parts.Test_ID
                                                        and $projection.Part_ID = _Parts.Part_ID

  composition [1..*] of ZNEPT_QZ_C_VAR        as _Variants

  association [1..1] to ZNEPT_QZ_C_TST        as _Quiz  on  $projection.Test_ID = _Quiz.Test_ID

{
  key _Questions.Test_ID,
  key _Questions.Question_ID,

      _Questions.Part_ID,
      _Questions.Question,
      _Questions.Explanation,

      /* Associations */

      _Quiz,
      _Parts,
      _Variants
}
