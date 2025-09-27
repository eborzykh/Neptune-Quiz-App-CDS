//
@EndUserText.label: 'Activity Progress (Visual Help)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZNEPT_QZ_I_ACTIV_PROGRESS_VH
  as select from ZNEPT_QZ_I_DOMAIN ( p_domain_name: 'ZNEPT_QZ_PROGRESS_DM' )
{

      @ObjectModel.text.element: ['ProgressText']
  key Value       as Progress,

      @Semantics.text: true
      Description as ProgressText

}
