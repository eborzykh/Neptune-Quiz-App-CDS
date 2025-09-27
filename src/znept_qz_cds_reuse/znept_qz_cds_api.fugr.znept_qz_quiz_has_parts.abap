FUNCTION znept_qz_quiz_has_parts.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_DB_QUIZ) TYPE  ZNEPT_QZ_DB_TESTS_S
*"  EXPORTING
*"     REFERENCE(EV_HAS_PARTS) TYPE  ABAP_BOOL
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------

  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CALL METHOD zcl_nept_qz_data_cds=>quiz_has_parts
    EXPORTING
      is_db_quiz   = is_db_quiz
    IMPORTING
      ev_has_parts = ev_has_parts
      et_messages  = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
