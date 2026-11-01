FUNCTION znept_qz_quiz_ai_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_TOPIC) TYPE  STRING
*"     REFERENCE(IV_COUNT) TYPE  INT2
*"     REFERENCE(IV_DESCRIPTION) TYPE  ZNEPT_QZ_TEST_NAME_DE
*"     REFERENCE(IV_API_KEY) TYPE  ZNEPT_QZ_AI_API_KEY_DE
*"     REFERENCE(IV_MAX_TOKEN) TYPE  INT2 OPTIONAL
*"     REFERENCE(IV_MODEL) TYPE  ZNEPT_QZ_AI_MODEL_DE OPTIONAL
*"  EXPORTING
*"     REFERENCE(ES_DB_TESTS) TYPE  ZNEPT_QZ_DB_TESTS_S
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------
  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CLEAR es_db_tests.

  CALL METHOD zcl_nept_qz_ai_data_cds=>quiz_ai_create
    EXPORTING
      iv_topic       = iv_topic
      iv_description = iv_description
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
