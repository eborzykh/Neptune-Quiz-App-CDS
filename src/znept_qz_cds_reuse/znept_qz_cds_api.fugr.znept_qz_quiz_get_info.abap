FUNCTION znept_qz_quiz_get_info.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_DB_QUIZ) TYPE  ZNEPT_QZ_DB_TESTS_S
*"  EXPORTING
*"     REFERENCE(EV_HAS_PARTS) TYPE  ABAP_BOOL
*"     REFERENCE(EV_HAS_QUESTIONS) TYPE  ABAP_BOOL
*"     REFERENCE(EV_TOTAL_PARTS) TYPE  INT2
*"     REFERENCE(EV_TOTAL_QUESTIONS) TYPE  INT2
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------

  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CALL METHOD zcl_nept_qz_data_cds=>quiz_get_info
    EXPORTING
      is_db_quiz         = is_db_quiz
    IMPORTING
      ev_has_parts       = ev_has_parts
      ev_has_questions   = ev_has_questions
      ev_total_parts     = ev_total_parts
      ev_total_questions = ev_total_questions
      et_messages        = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
