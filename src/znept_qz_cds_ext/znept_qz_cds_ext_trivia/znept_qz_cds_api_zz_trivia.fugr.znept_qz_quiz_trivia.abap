FUNCTION znept_qz_quiz_trivia.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_DESCRIPTION) TYPE  ZNEPT_QZ_TEST_NAME_DE
*"     REFERENCE(IV_CATEGORY) TYPE  ZNEPT_QZ_TRIVIA_CATEGORY_ID_DE
*"     REFERENCE(IV_DIFFICULTY) TYPE  ZNEPT_QZ_TRIVIA_DIFFPARAM_DE
*"     REFERENCE(IV_COUNT) TYPE  INT2
*"  EXPORTING
*"     REFERENCE(ES_DB_TESTS) TYPE  ZNEPT_QZ_DB_TESTS_S
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------

  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CLEAR es_db_tests.

  CALL METHOD zcl_nept_qz_trivia_data_cds=>quiz_trivia
    EXPORTING
      iv_description = iv_description
      iv_category    = iv_category
      iv_difficulty  = iv_difficulty
      iv_count       = iv_count
    IMPORTING
      es_db_tests    = es_db_tests
      et_messages    = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
