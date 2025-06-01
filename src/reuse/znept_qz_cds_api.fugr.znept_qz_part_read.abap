FUNCTION znept_qz_part_read.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_DB_PART) TYPE  ZNEPT_QZ_DB_PARTS_S
*"  EXPORTING
*"     REFERENCE(ES_DB_PART) TYPE  ZNEPT_QZ_DB_PARTS_S
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------

  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CALL METHOD zcl_nept_qz_data_cds=>part_read
    EXPORTING
      is_db_part  = is_db_part
    IMPORTING
      es_db_part  = es_db_part
      et_messages = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
