FUNCTION znept_qz_question_read.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_DB_QUESTION) TYPE  ZNEPT_QZ_DB_QUESTIONS_S
*"  EXPORTING
*"     REFERENCE(ES_DB_QUESTION) TYPE  ZNEPT_QZ_DB_QUESTIONS_S
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------

  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CALL METHOD zcl_nept_qz_data_cds=>question_read
    EXPORTING
      is_db_question = is_db_question
    IMPORTING
      es_db_question = es_db_question
      et_messages    = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
