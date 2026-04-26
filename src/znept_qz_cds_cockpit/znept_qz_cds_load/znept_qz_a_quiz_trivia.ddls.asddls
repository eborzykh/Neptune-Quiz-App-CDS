//
@EndUserText.label: 'Abstract Entity for Trivia API'
@Metadata.allowExtensions: true

define root abstract entity ZNEPT_QZ_A_QUIZ_TRIVIA
{
  @EndUserText.label: 'Select Category'
  @Consumption.valueHelpDefinition: [ { entity: {name: 'ZNEPT_QZ_I_TRIVIA_CATEGORY_VH', element: 'Category' }, useForValidation: true } ]
  p_Category   : znept_qz_trivia_category_de;

  @EndUserText.label: 'Select Difficulty'
  @Consumption.valueHelpDefinition: [ { entity: {name: 'ZNEPT_QZ_I_TRIVIA_DIFFICULT_VH', element: 'Difficulty' }, useForValidation: true } ]
  p_Difficulty : znept_qz_trivia_difficulty_de;

  @EndUserText.label: 'Number of Questions'
  p_Count      : abap.int2;
}

// ---------------------------------------------------------------- //
// Inspired by https://opentdb.com/api_config.php
// ---------------------------------------------------------------- //
