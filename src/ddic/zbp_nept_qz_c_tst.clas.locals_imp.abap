CLASS lhc_quiz DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ quiz RESULT result.

    METHODS rba_parts FOR READ
      IMPORTING keys_rba FOR READ quiz\_parts FULL result_requested RESULT result LINK association_links.

    METHODS publish FOR MODIFY
      IMPORTING keys FOR ACTION quiz~publish.

    METHODS unpublish FOR MODIFY
      IMPORTING keys FOR ACTION quiz~unpublish.

ENDCLASS.

CLASS lhc_quiz IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_parts.
  ENDMETHOD.

  METHOD publish.
    READ TABLE keys INDEX 1 INTO DATA(ls_quiz).
    IF sy-subrc = 0.
      DATA(ls_db_tests_key) = VALUE znept_qz_db_tests_key_s( test_id = ls_quiz-test_id ).

      CALL METHOD zcl_nept_qz_data_provider=>publish
        EXPORTING
          is_db_tests_key = ls_db_tests_key
          iv_published    = abap_true.

    ENDIF.
  ENDMETHOD.

  METHOD unpublish.
    READ TABLE keys INDEX 1 INTO DATA(ls_quiz).
    IF sy-subrc = 0.
      DATA(ls_db_tests_key) = VALUE znept_qz_db_tests_key_s( test_id = ls_quiz-test_id ).

      CALL METHOD zcl_nept_qz_data_provider=>publish
        EXPORTING
          is_db_tests_key = ls_db_tests_key
          iv_published    = abap_false.

    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_part DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ part RESULT result.

    METHODS rba_questions FOR READ
      IMPORTING keys_rba FOR READ part\_questions FULL result_requested RESULT result LINK association_links.

    METHODS rba_quiz FOR READ
      IMPORTING keys_rba FOR READ part\_quiz FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_part IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_questions.
  ENDMETHOD.

  METHOD rba_quiz.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_question DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ question RESULT result.

    METHODS rba_parts FOR READ
      IMPORTING keys_rba FOR READ question\_parts FULL result_requested RESULT result LINK association_links.

    METHODS rba_quiz FOR READ
      IMPORTING keys_rba FOR READ question\_quiz FULL result_requested RESULT result LINK association_links.

    METHODS rba_variants FOR READ
      IMPORTING keys_rba FOR READ question\_variants FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_question IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_parts.
  ENDMETHOD.

  METHOD rba_quiz.
  ENDMETHOD.

  METHOD rba_variants.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_variant DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ variant RESULT result.

    METHODS rba_questions FOR READ
      IMPORTING keys_rba FOR READ variant\_questions FULL result_requested RESULT result LINK association_links.

    METHODS rba_quiz FOR READ
      IMPORTING keys_rba FOR READ variant\_quiz FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_variant IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_questions.
  ENDMETHOD.

  METHOD rba_quiz.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_znept_qz_c_tst DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_znept_qz_c_tst IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
