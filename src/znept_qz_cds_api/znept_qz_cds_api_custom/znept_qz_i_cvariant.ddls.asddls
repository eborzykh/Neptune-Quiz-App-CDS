@EndUserText.label: 'Variants (Custom Entity)'
@ObjectModel: { query: { implementedBy: 'ABAP:ZCL_NEPT_QZ_API_CUSTOM_SOURCE' } }

define custom entity ZNEPT_QZ_I_CVARIANT
  with parameters
    p_test_id : znept_qz_test_id_de
{

  key question_id : znept_qz_question_id_de;
  key variant_id  : znept_qz_variant_id_de;
      correct     : znept_qz_correct_de;
      variant     : znept_qz_variant_de;
      sort        : znept_qz_variant_ord_de;

}
