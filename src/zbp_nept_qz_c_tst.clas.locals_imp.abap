CLASS lhc_quiz DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ quiz RESULT result.

    METHODS publish FOR MODIFY
      IMPORTING it_quiz FOR ACTION quiz~publish RESULT et_quiz.

    METHODS unpublish FOR MODIFY
      IMPORTING it_quiz FOR ACTION quiz~unpublish RESULT et_quiz.

ENDCLASS.

CLASS lhc_quiz IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.


  METHOD publish.

    READ TABLE it_quiz INDEX 1 INTO DATA(ls_quiz).
    IF sy-subrc = 0.
      DATA(ls_db_tests_key) = VALUE znept_qz_db_tests_key_s( test_id   = ls_quiz-test_id ).
      CALL METHOD zcl_nept_qz_data_provider=>publish
        EXPORTING
          is_db_tests_key = ls_db_tests_key
          iv_published    = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD unpublish.

    READ TABLE it_quiz INDEX 1 INTO DATA(ls_quiz).
    IF sy-subrc = 0.
      DATA(ls_db_tests_key) = VALUE znept_qz_db_tests_key_s( test_id   = ls_quiz-test_id ).
      CALL METHOD zcl_nept_qz_data_provider=>publish
        EXPORTING
          is_db_tests_key = ls_db_tests_key
          iv_published    = abap_false.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_znept_qz_c_tst DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_znept_qz_c_tst IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

ENDCLASS.
