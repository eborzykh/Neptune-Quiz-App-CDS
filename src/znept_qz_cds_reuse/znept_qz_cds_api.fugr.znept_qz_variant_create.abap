FUNCTION znept_qz_variant_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_DB_VARIANT) TYPE  ZNEPT_QZ_DB_VARIANTS_S
*"  EXPORTING
*"     REFERENCE(ES_DB_VARIANT) TYPE  ZNEPT_QZ_DB_VARIANTS_S
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------

  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CALL METHOD zcl_nept_qz_data_cds=>variant_create
    EXPORTING
      is_db_variant = is_db_variant
    IMPORTING
      es_db_variant = es_db_variant
      et_messages   = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
