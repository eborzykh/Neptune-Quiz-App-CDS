//
@EndUserText.label: 'Abstract Entity for AI Quiz Create'
@Metadata.allowExtensions: true

define root abstract entity ZNEPT_QZ_A_QUIZ_AI_CREATE
{
  @EndUserText.label: 'New Quiz Name'
  p_Name  : znept_qz_test_name_de;

  @EndUserText.label: 'Content'
  @UI.multiLineText: true
  p_Topic : abap.string(0);

  @EndUserText.label: 'Number of Questions'
  p_Count : abap.int2;

  @EndUserText.label: 'API Key'
  p_Key   : znept_qz_ai_api_key_de;

  @EndUserText.label: 'Model'
//  @Consumption.valueHelpDefinition: [ { entity: {name: 'ZZNEPT_QZ_I_AI_MODEL_VH', element: 'Model' }, useForValidation: true } ]
  p_Model : znept_qz_ai_model_de;

  //  @EndUserText.label: 'Max Completion Tokens'
  //  p_MaxToken   : abap.int2;
}
