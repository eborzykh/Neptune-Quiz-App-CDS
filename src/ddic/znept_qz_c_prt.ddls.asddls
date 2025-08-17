//
@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_C_PRT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Parts (Consumption)'

@Metadata.allowExtensions: true

define view ZNEPT_QZ_C_PRT
  as select from ZNEPT_QZ_I_PRT as _Parts

  association to parent ZNEPT_QZ_C_TST as _Quiz on $projection.Test_ID = _Quiz.Test_ID

  composition [0..*] of ZNEPT_QZ_C_QST as _Questions 

{
  key _Parts.Test_ID,
  key _Parts.Part_ID,

      _Parts.Description,

      /* Associations */

      _Quiz,
      _Questions

}
