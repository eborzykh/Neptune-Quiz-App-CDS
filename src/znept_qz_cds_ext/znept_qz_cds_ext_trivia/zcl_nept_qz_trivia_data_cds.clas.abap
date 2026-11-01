CLASS zcl_nept_qz_trivia_data_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS quiz_trivia
      IMPORTING
        !iv_description TYPE znept_qz_test_name_de
        !iv_category    TYPE znept_qz_trivia_category_id_de
        !iv_difficulty  TYPE znept_qz_trivia_diffparam_de
        !iv_count       TYPE int2
      EXPORTING
        !es_db_tests    TYPE znept_qz_db_tests_s
        !et_messages    TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_nept_qz_trivia_data_cds IMPLEMENTATION.

  METHOD quiz_trivia.

    DATA: lv_db_error  TYPE abap_bool,
          lv_do_commit TYPE abap_bool.

    REFRESH et_messages.

    CLEAR es_db_tests.

    TRY.
        zcl_nept_qz_src_trivia=>get_quiz( EXPORTING iv_category = iv_category
                                                    iv_difficulty = iv_difficulty
                                                    iv_count = iv_count
                                          IMPORTING et_db_parts = DATA(lt_db_parts)
                                                    et_db_questions = DATA(lt_db_questions)
                                                    et_db_variants = DATA(lt_db_variants) ).
      CATCH zcx_nept_qz_src_trivia_api INTO DATA(lr_trivia_api).
        APPEND lr_trivia_api TO et_messages.
        RETURN.
    ENDTRY.

    IF NOT lt_db_questions[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_provider=>add
        EXPORTING
          iv_description  = iv_description
          iv_published    = abap_false
          it_db_parts     = lt_db_parts
          it_db_questions = lt_db_questions
          it_db_variants  = lt_db_variants
        IMPORTING
          es_db_tests     = es_db_tests
          ev_db_error     = lv_db_error
          ev_do_commit    = lv_do_commit.

    ENDIF.

    IF lv_db_error = abap_true OR lv_do_commit = abap_false OR es_db_tests IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_trivia_cds=>quiz_create_error ) TO et_messages.
    ENDIF.

  ENDMETHOD.


ENDCLASS.
