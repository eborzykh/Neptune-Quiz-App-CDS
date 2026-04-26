//
@EndUserText.label: 'Trivia Category (Visual Help)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZNEPT_QZ_I_TRIVIA_CATEGORY_VH
  as select from ZNEPT_QZ_I_DOMAIN ( p_domain_name: 'ZNEPT_QZ_TRIVIA_CATEGORY_DM' )
{
       @ObjectModel.text.element: ['CategoryText']
  key  cast(Value as znept_qz_trivia_category_de) as Category,

       @Semantics.text: true
       Description                                as CategoryText
}
