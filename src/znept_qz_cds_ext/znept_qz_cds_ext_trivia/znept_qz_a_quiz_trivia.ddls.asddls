//
@EndUserText.label: 'Abstract Entity for Trivia'
@Metadata.allowExtensions: true

define root abstract entity ZNEPT_QZ_A_QUIZ_TRIVIA
{
  @EndUserText.label: 'New Quiz Name'
  p_Name       : znept_qz_test_name_de;

  @EndUserText.label: 'Select Category'
  @Consumption.valueHelpDefinition: [ { entity: {name: 'ZZNEPT_QZ_I_TRIVIA_CAT_QUER_VH', element: 'Category' }, useForValidation: true } ]
  p_Category   : znept_qz_trivia_category_id_de;

  @EndUserText.label: 'Select Difficulty'
  @Consumption.valueHelpDefinition: [ { entity: {name: 'ZZNEPT_QZ_I_TRIVIA_DIFFPAR_VH', element: 'Difficulty' }, useForValidation: true } ]
  p_Difficulty : znept_qz_trivia_diffparam_de;

  @EndUserText.label: 'Number of Questions'
  p_Count      : abap.int2;
}
