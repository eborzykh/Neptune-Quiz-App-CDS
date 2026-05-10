FUNCTION znept_qz_quiz_trivia.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_DB_QUIZ) TYPE  ZNEPT_QZ_DB_TESTS_S
*"     REFERENCE(IV_CATEGORY) TYPE  ZNEPT_QZ_TRIVIA_CATEGORY_ID_DE
*"     REFERENCE(IV_DIFFICULTY) TYPE  ZNEPT_QZ_TRIVIA_DIFFPARAM_DE
*"     REFERENCE(IV_COUNT) TYPE  INT2
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------
  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CALL METHOD zcl_nept_qz_data_cds=>quiz_trivia
    EXPORTING
      is_db_quiz    = is_db_quiz
      iv_category   = iv_category
      iv_difficulty = iv_difficulty
      iv_count      = iv_count
    IMPORTING
      et_messages   = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
