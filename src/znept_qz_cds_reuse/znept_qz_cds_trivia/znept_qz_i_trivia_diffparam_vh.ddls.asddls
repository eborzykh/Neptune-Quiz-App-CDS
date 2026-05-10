//
@EndUserText.label: 'Trivia Difficulty (Visual Help)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@ObjectModel.resultSet.sizeCategory: #XS

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZNEPT_QZ_I_TRIVIA_DIFFPARAM_VH
  as select from ZNEPT_QZ_I_DOMAIN ( p_domain_name: 'ZNEPT_QZ_TRIVIA_DIFFPARAM_DM' )
{
       @ObjectModel.text.element: ['DifficultyText']
  key  cast(Value as znept_qz_trivia_diffparam_de) as Difficulty,

       @Semantics.text: true
       Description                                 as DifficultyText
}
