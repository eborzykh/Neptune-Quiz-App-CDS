CLASS lhc_Quiz DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Quiz RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Quiz.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Quiz.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Quiz.

    METHODS read FOR READ
      IMPORTING keys FOR READ Quiz RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Quiz.

    METHODS rba_Part FOR READ
      IMPORTING keys_rba FOR READ Quiz\_Part FULL result_requested RESULT result LINK association_links.

    METHODS cba_Part FOR MODIFY
      IMPORTING entities_cba FOR CREATE Quiz\_Part.

    METHODS copyQuiz FOR MODIFY
      IMPORTING keys FOR ACTION Quiz~copyQuiz.

    METHODS uploadQuiz FOR MODIFY
      IMPORTING keys FOR ACTION Quiz~uploadQuiz.
    METHODS Publish FOR MODIFY
      IMPORTING keys FOR ACTION Quiz~Publish RESULT result.

    METHODS Unpublish FOR MODIFY
      IMPORTING keys FOR ACTION Quiz~Unpublish RESULT result.

ENDCLASS.

CLASS lhc_Quiz IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Part.
  ENDMETHOD.

  METHOD cba_Part.
  ENDMETHOD.

  METHOD copyQuiz.

  ENDMETHOD.

  METHOD uploadQuiz.

  ENDMETHOD.

  METHOD Publish.

    READ TABLE keys INDEX 1 ASSIGNING FIELD-SYMBOL(<fs_quiz>).
    IF sy-subrc = 0.
      DATA(ls_db_tests_key) = VALUE znept_qz_db_tests_key_s( test_id = <fs_quiz>-TestId ).
      CALL METHOD zcl_nept_qz_data_provider=>publish
        EXPORTING
          is_db_tests_key = ls_db_tests_key
          iv_published    = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD Unpublish.

    READ TABLE keys INDEX 1 ASSIGNING FIELD-SYMBOL(<fs_quiz>).
    IF sy-subrc = 0.
      DATA(ls_db_tests_key) = VALUE znept_qz_db_tests_key_s( test_id = <fs_quiz>-TestId ).
      CALL METHOD zcl_nept_qz_data_provider=>publish
        EXPORTING
          is_db_tests_key = ls_db_tests_key
          iv_published    = abap_false.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Part DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Part.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Part.

    METHODS read FOR READ
      IMPORTING keys FOR READ Part RESULT result.

    METHODS rba_Question FOR READ
      IMPORTING keys_rba FOR READ Part\_Question FULL result_requested RESULT result LINK association_links.

    METHODS rba_Quiz FOR READ
      IMPORTING keys_rba FOR READ Part\_Quiz FULL result_requested RESULT result LINK association_links.

    METHODS cba_Question FOR MODIFY
      IMPORTING entities_cba FOR CREATE Part\_Question.

ENDCLASS.

CLASS lhc_Part IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Question.
  ENDMETHOD.

  METHOD rba_Quiz.
  ENDMETHOD.

  METHOD cba_Question.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Question DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Question.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Question.

    METHODS read FOR READ
      IMPORTING keys FOR READ Question RESULT result.

    METHODS rba_Part FOR READ
      IMPORTING keys_rba FOR READ Question\_Part FULL result_requested RESULT result LINK association_links.

    METHODS rba_Quiz FOR READ
      IMPORTING keys_rba FOR READ Question\_Quiz FULL result_requested RESULT result LINK association_links.

    METHODS rba_Variant FOR READ
      IMPORTING keys_rba FOR READ Question\_Variant FULL result_requested RESULT result LINK association_links.

    METHODS cba_Variant FOR MODIFY
      IMPORTING entities_cba FOR CREATE Question\_Variant.

ENDCLASS.

CLASS lhc_Question IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Part.
  ENDMETHOD.

  METHOD rba_Quiz.
  ENDMETHOD.

  METHOD rba_Variant.
  ENDMETHOD.

  METHOD cba_Variant.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Variant DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Variant.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Variant.

    METHODS read FOR READ
      IMPORTING keys FOR READ Variant RESULT result.

    METHODS rba_Question FOR READ
      IMPORTING keys_rba FOR READ Variant\_Question FULL result_requested RESULT result LINK association_links.

    METHODS rba_Quiz FOR READ
      IMPORTING keys_rba FOR READ Variant\_Quiz FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Variant IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Question.
  ENDMETHOD.

  METHOD rba_Quiz.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZNEPT_QZ_I_QUIZ_C DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZNEPT_QZ_I_QUIZ_C IMPLEMENTATION.

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
