//
@EndUserText.label: 'Abstract Entity for Question Assigning'
define root abstract entity ZNEPT_QZ_A_QUESTION_ASSIGN
{

//  @UI.hidden  : true
//  TestId      : znept_qz_test_id_de;

  @EndUserText.label: 'New Part Assignment'
  @Consumption.valueHelpDefinition: [
    { entity  : {name: 'ZNEPT_QZ_I_QUESTION_ASSIGN_VH', element: 'PartId' },
//      additionalBinding: [ { localElement: 'TestId',    element: 'TestId',    usage: #FILTER} ],
      useForValidation: true }
   ]
  new_Part_Id : znept_qz_part_id_de;

}
