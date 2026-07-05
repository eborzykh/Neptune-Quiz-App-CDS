@EndUserText.label: 'Questions (Custom Entity)'
@ObjectModel: { query: { implementedBy: 'ABAP:ZCL_NEPT_QZ_API_CUSTOM_SOURCE' } }

define custom entity ZNEPT_QZ_I_CQUESTION
  with parameters
    p_test_id : znept_qz_test_id_de
{

  key question_id      : znept_qz_question_id_de;

      part_id          : znept_qz_part_id_de;
      question         : znept_qz_question_de;
      explanation      : znept_qz_explanation_de;
      progress         : znept_qz_progress_de;

      @EndUserText.label:'No progress'
      @EndUserText.quickInfo: 'No progress available for this question'
      no_progress      : abap.char( 1 ); // znept_qz_no_progress_de;

      sort             : znept_qz_question_ord_de;
      sort_part        : znept_qz_part_ord_de;
      part_description : znept_qz_part_name_de;

}
