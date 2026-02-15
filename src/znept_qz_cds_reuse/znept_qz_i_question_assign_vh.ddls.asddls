//
@EndUserText.label: 'Neptune Quiz App (CDS): Question Assign'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Search.searchable: true

//@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZNEPT_QZ_I_QUESTION_ASSIGN_VH
  as select from znept_qz_prt
{
      @Search.defaultSearchElement: true
      @UI.lineItem: [ { importance: #HIGH } ]
      @UI.selectionField: [ { position: 10 } ]
  key test_id     as TestId,

      @UI.lineItem: [ { importance: #HIGH } ]
      @UI.selectionField: [ { position: 20 } ]
      @ObjectModel.text.element: ['Description']
  key part_id     as PartId,

      @Semantics.text: true
      description as Description

}
