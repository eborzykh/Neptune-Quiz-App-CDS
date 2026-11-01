CLASS ltcl_quiz_d DEFINITION DEFERRED FOR TESTING.

CLASS lhc_Quiz DEFINITION INHERITING FROM cl_abap_behavior_handler
  FRIENDS ltcl_quiz_d.
  PRIVATE SECTION.

    METHODS triviaQuiz FOR MODIFY
      IMPORTING keys FOR ACTION Quiz~triviaQuiz RESULT result.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR Quiz RESULT result.

    METHODS GetDfltsFor_triviaQuiz FOR READ
      IMPORTING keys FOR FUNCTION Quiz~GetDfltsFor_triviaQuiz RESULT result.

ENDCLASS.

CLASS lhc_Quiz IMPLEMENTATION.

  METHOD get_global_features.

    IF requested_features-%action-triviaQuiz = if_abap_behv=>mk-on.
      TRY.
          zcl_nept_qz_src_trivia=>get_count_overall( IMPORTING ev_questions = DATA(lv_trivia_total) ).
        CATCH zcx_nept_qz_src_trivia_api.
          CLEAR lv_trivia_total.
      ENDTRY.
    ENDIF.

    result = VALUE #( %action-triviaQuiz = COND #( WHEN lv_trivia_total > 0
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled ) ).

  ENDMETHOD.

  METHOD triviaQuiz.

**********************************************************************
*
*                TO DO: FM call to be replaced with EML (draft)
*
**********************************************************************

    DATA: lt_messages TYPE symsg_tab,
          ls_db_tests TYPE znept_qz_db_tests_s.

    READ TABLE keys INDEX 1 INTO DATA(ls_keys).
    IF sy-subrc = 0.

      CALL FUNCTION 'ZNEPT_QZ_QUIZ_TRIVIA'
        EXPORTING
          iv_description = ls_keys-%param-p_name
          iv_category    = ls_keys-%param-p_category
          iv_difficulty  = ls_keys-%param-p_difficulty
          iv_count       = ls_keys-%param-p_count
        IMPORTING
          es_db_tests    = ls_db_tests
          et_messages    = lt_messages.

      IF lt_messages IS NOT INITIAL.
        APPEND INITIAL LINE TO failed-quiz ASSIGNING FIELD-SYMBOL(<fs_failed_quiz>).
        <fs_failed_quiz>-%cid = ls_keys-%cid.

        LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<fs_messages>).
          APPEND INITIAL LINE TO reported-quiz ASSIGNING FIELD-SYMBOL(<fs_reported_quiz>).
          <fs_reported_quiz>-%cid = ls_keys-%cid.
          <fs_reported_quiz>-%msg = new_message( id = <fs_messages>-msgid
                                                 number = <fs_messages>-msgno
                                                 v1 = <fs_messages>-msgv1
                                                 v2 = <fs_messages>-msgv2
                                                 v3 = <fs_messages>-msgv3
                                                 v4 = <fs_messages>-msgv4
                                                severity = if_abap_behv_message=>severity-error ).
          <fs_reported_quiz>-%element-description = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDIF.

* display toast like message

      IF lt_messages[] IS INITIAL.
        reported-quiz = VALUE #( FOR key IN keys ( %cid = key-%cid
                                                   %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Created with Trivia'(001) )
                                                   %op-%action-triviaQuiz = if_abap_behv=>mk-on ) ).
      ENDIF.

* read changed data for action result (does not work without it in _O4)

      result = VALUE #( ( %cid = ls_keys-%cid %param-TestId = ls_db_tests-test_id  ) ).

    ENDIF.

  ENDMETHOD.

  METHOD GetDfltsFor_triviaQuiz.

    LOOP AT keys INTO DATA(key).
      INSERT INITIAL LINE INTO TABLE result REFERENCE INTO DATA(lr_result).
      lr_result->%param-p_Count = zcl_nept_qz_src_trivia=>gc_def_questions.
      lr_result->%param-p_Name = 'Trivia Quiz'.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
