//
@EndUserText.label: 'AI Adjust Difficulty (Visual Help)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@ObjectModel.resultSet.sizeCategory: #XS

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZZNEPT_QZ_I_AI_DIFFPAR_VH
  as select from ZNEPT_QZ_I_DOMAIN ( p_domain_name: 'ZNEPT_QZ_AI_DIFFPARAM_DM' )
{
       @ObjectModel.text.element: ['DifficultyText']
  key  cast(Value as znept_qz_ai_diffparam_de) as Difficulty,

       @Semantics.text: true
       Description                             as DifficultyText
}
