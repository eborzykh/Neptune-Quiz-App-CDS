//
@EndUserText.label: 'AI Adjust Difficulty (Visual Help)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@ObjectModel.resultSet.sizeCategory: #XS

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZZNEPT_QZ_I_AI_PROGRESS_VH
  as select from ZNEPT_QZ_I_DOMAIN ( p_domain_name: 'ZNEPT_QZ_AI_PROGRESS_DM' )
{
       @ObjectModel.text.element: ['ProgressText']
  key  cast(Value as znept_qz_ai_progress_de) as Progress,

       @Semantics.text: true
       Description                            as ProgressText
}
