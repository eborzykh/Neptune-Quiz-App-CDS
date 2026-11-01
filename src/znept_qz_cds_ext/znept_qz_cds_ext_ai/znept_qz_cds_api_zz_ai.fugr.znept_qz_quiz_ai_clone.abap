FUNCTION znept_qz_quiz_ai_clone.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_DB_QUIZ_REF) TYPE  ZNEPT_QZ_DB_TESTS_S
*"     REFERENCE(IV_DESCRIPTION) TYPE  ZNEPT_QZ_TEST_NAME_DE
*"     REFERENCE(IV_COUNT) TYPE  INT2
*"     REFERENCE(IV_API_KEY) TYPE  ZNEPT_QZ_AI_API_KEY_DE
*"     REFERENCE(IV_PROGRESS) TYPE  ZNEPT_QZ_AI_PROGRESS_DE OPTIONAL
*"     REFERENCE(IV_DIFFICULTY) TYPE  ZNEPT_QZ_AI_DIFFPARAM_DE OPTIONAL
*"     REFERENCE(IV_MAX_TOKEN) TYPE  INT2 OPTIONAL
*"     REFERENCE(IV_MODEL) TYPE  ZNEPT_QZ_AI_MODEL_DE OPTIONAL
*"  EXPORTING
*"     REFERENCE(ES_DB_TESTS) TYPE  ZNEPT_QZ_DB_TESTS_S
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------
  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CLEAR es_db_tests.

  CALL METHOD zcl_nept_qz_ai_data_cds=>quiz_ai_clone
    EXPORTING
      iv_description = iv_description
      iv_progress    = iv_progress
      is_db_quiz_ref = is_db_quiz_ref
      iv_difficulty  = iv_difficulty
      iv_count       = iv_count
      iv_api_key     = iv_api_key
      iv_max_token   = iv_max_token
      iv_model       = iv_model
    IMPORTING
      es_db_tests    = es_db_tests
      et_messages    = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
