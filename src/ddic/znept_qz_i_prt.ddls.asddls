//
@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_I_PRT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Parts (Basic)'

define view ZNEPT_QZ_I_PRT
  as select from znept_qz_prt as _Parts

{
  key _Parts.test_id     as Test_ID,
  key _Parts.part_id     as Part_ID,

      _Parts.description as Description
}
