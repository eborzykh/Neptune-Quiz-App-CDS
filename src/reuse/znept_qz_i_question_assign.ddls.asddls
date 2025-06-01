//
@EndUserText.label: 'Neptune Quiz App (CDS): Question Assign'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_QUESTION_ASSIGN
  as select from znept_qz_prt
{
  key test_id     as TestId,
  
  key part_id     as PartId,

      @Semantics.text: true
      description as Description
      
}

