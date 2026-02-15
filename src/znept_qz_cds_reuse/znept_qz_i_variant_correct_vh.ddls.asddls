//
@EndUserText.label: 'Neptune Quiz App (CDS): Variant Correct'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@ObjectModel.resultSet.sizeCategory: #XS

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZNEPT_QZ_I_VARIANT_CORRECT_VH
  as select from ZNEPT_QZ_I_DOMAIN ( p_domain_name: 'ZNEPT_QZ_CORRECT_DM' )
{

      @ObjectModel.text.element: ['CorrectText']
  key Value       as Correct,

      @Semantics.text: true
      Description as CorrectText

}
