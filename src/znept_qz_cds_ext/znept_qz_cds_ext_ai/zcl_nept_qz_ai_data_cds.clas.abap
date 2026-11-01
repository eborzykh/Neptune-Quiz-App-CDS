CLASS zcl_nept_qz_ai_data_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS quiz_ai_clone
      IMPORTING
        !is_db_quiz_ref TYPE znept_qz_db_tests_s
        !iv_description TYPE znept_qz_test_name_de
        !iv_count       TYPE int2
        !iv_api_key     TYPE znept_qz_ai_api_key_de
        !iv_progress    TYPE znept_qz_ai_progress_de OPTIONAL
        !iv_difficulty  TYPE znept_qz_ai_diffparam_de OPTIONAL
        !iv_max_token   TYPE int2 OPTIONAL
        !iv_model       TYPE znept_qz_ai_model_de OPTIONAL
      EXPORTING
        !es_db_tests    TYPE znept_qz_db_tests_s
        !et_messages    TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .

    CLASS-METHODS quiz_ai_create
      IMPORTING
        !iv_topic       TYPE string
        !iv_description TYPE znept_qz_test_name_de
        !iv_count       TYPE int2
        !iv_api_key     TYPE znept_qz_ai_api_key_de
        !iv_max_token   TYPE int2 OPTIONAL
        !iv_model       TYPE znept_qz_ai_model_de OPTIONAL
      EXPORTING
        !es_db_tests    TYPE znept_qz_db_tests_s
        !et_messages    TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_nept_qz_ai_data_cds IMPLEMENTATION.

  METHOD quiz_ai_clone.

    DATA: ls_db_tests_ref TYPE znept_qz_db_tests_s,
          lv_description  TYPE znept_qz_test_name_de,
          lv_db_error     TYPE abap_bool,
          lv_do_commit    TYPE abap_bool.

    REFRESH et_messages.

    CLEAR es_db_tests.

    IF is_db_quiz_ref-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_ai_cds=>quiz_not_exist_ref ) TO et_messages.
      RETURN.
    ENDIF.

    CALL METHOD zcl_nept_qz_data_cds=>quiz_read
      EXPORTING
        is_db_quiz  = is_db_quiz_ref
      IMPORTING
        es_db_quiz  = ls_db_tests_ref
        et_messages = et_messages.

    IF NOT et_messages IS INITIAL.
      RETURN.
    ENDIF.

    CONCATENATE ls_db_tests_ref-description '(AI clone)'
      INTO lv_description SEPARATED BY space IN CHARACTER MODE ##NO_TEXT.

    TRY.
        zcl_nept_qz_src_ai=>get_quiz_clone( EXPORTING is_db_tests = is_db_quiz_ref
                                                      iv_descriptiopn = iv_description
                                                      iv_progress = iv_progress
                                                      iv_difficulty = iv_difficulty
                                                      iv_count = iv_count
                                                      iv_api_key = iv_api_key
                                                      iv_max_token = iv_max_token
                                                      iv_model = iv_model
                                            IMPORTING et_db_parts = DATA(lt_db_parts)
                                                      et_db_questions = DATA(lt_db_questions)
                                                      et_db_variants = DATA(lt_db_variants) ).

      CATCH zcx_nept_qz_src_ai_api INTO DATA(lr_ai_api).
        APPEND lr_ai_api TO et_messages.
        RETURN.
    ENDTRY.

    IF NOT lt_db_questions[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_provider=>add
        EXPORTING
          iv_description  = lv_description
          iv_published    = abap_false
          it_db_parts     = lt_db_parts
          it_db_questions = lt_db_questions
          it_db_variants  = lt_db_variants
        IMPORTING
          es_db_tests     = es_db_tests
          ev_db_error     = lv_db_error
          ev_do_commit    = lv_do_commit.

    ENDIF.

    IF lv_db_error = abap_true OR lv_do_commit = abap_false.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_ai_cds=>quiz_clone_error ) TO et_messages.
    ENDIF.

  ENDMETHOD.

  METHOD quiz_ai_create.

    DATA: lv_description TYPE znept_qz_test_name_de,
          lv_db_error    TYPE abap_bool,
          lv_do_commit   TYPE abap_bool.

    REFRESH et_messages.

    CLEAR es_db_tests.

    IF iv_topic IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_ai_cds=>quiz_no_context ) TO et_messages.
      RETURN.
    ENDIF.

    lv_description = iv_description.

    TRY.
        zcl_nept_qz_src_ai=>get_quiz_create( EXPORTING iv_descriptiopn = iv_description
                                                       iv_topic = iv_topic
                                                       iv_count = iv_count
                                                       iv_api_key = iv_api_key
                                                       iv_max_token = iv_max_token
                                                       iv_model = iv_model
                                             IMPORTING et_db_parts = DATA(lt_db_parts)
                                                       et_db_questions = DATA(lt_db_questions)
                                                       et_db_variants = DATA(lt_db_variants) ).

      CATCH zcx_nept_qz_src_ai_api INTO DATA(lr_ai_api).
        APPEND lr_ai_api TO et_messages.
        RETURN.
    ENDTRY.

    IF NOT lt_db_questions[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_provider=>add
        EXPORTING
          iv_description  = lv_description
          iv_published    = abap_false
          it_db_parts     = lt_db_parts
          it_db_questions = lt_db_questions
          it_db_variants  = lt_db_variants
        IMPORTING
          es_db_tests     = es_db_tests
          ev_db_error     = lv_db_error
          ev_do_commit    = lv_do_commit.

    ENDIF.

    IF lv_db_error = abap_true OR lv_do_commit = abap_false.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_ai_cds=>quiz_create_error ) TO et_messages.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
