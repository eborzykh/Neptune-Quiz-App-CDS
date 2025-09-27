//
@EndUserText.label: 'Neptune Quiz App (CDS): Quiz Pablished'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZNEPT_QZ_I_QUIZ_PUBLISHED_VH
  as select from ZNEPT_QZ_I_DOMAIN ( p_domain_name: 'ZNEPT_QZ_PUBLISHED_DM' )
{

      @ObjectModel.text.element: ['PublishedText']
  key Value       as Published,

      @Semantics.text: true
      Description as PublishedText

}
