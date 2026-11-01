CLASS ltcl_quiz_u DEFINITION DEFERRED FOR TESTING.

CLASS lhc_Quiz DEFINITION INHERITING FROM cl_abap_behavior_handler
  FRIENDS ltcl_quiz_u.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Quiz RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Quiz RESULT result.

    METHODS pasteQuiz FOR MODIFY
      IMPORTING keys FOR ACTION Quiz~pasteQuiz.

ENDCLASS.

CLASS lhc_Quiz IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF znept_qz_i_quiz_u IN LOCAL MODE
      ENTITY quiz
        FIELDS ( published description part_count question_count )
        WITH CORRESPONDING #( keys )
    RESULT DATA(lt_quiz).

* (2022) it returns initial part_count question_count
    DATA: ls_db_quiz         TYPE znept_qz_tst,
          lv_total_questions TYPE int2,
          lv_total_parts     TYPE int2.
    LOOP AT lt_quiz ASSIGNING FIELD-SYMBOL(<fs_quiz_add_info>).
      CLEAR ls_db_quiz.
      ls_db_quiz-test_id = <fs_quiz_add_info>-%key-testid.
      CALL FUNCTION 'ZNEPT_QZ_QUIZ_GET_INFO'
        EXPORTING
          is_db_quiz         = ls_db_quiz
        IMPORTING
          ev_total_questions = lv_total_questions
          ev_total_parts     = lv_total_parts.

      <fs_quiz_add_info>-question_count = lv_total_questions.
      <fs_quiz_add_info>-part_count = lv_total_parts.
    ENDLOOP.

    result = VALUE #(
      FOR ls_quiz_read_result IN lt_quiz ( %tky = ls_quiz_read_result-%tky
        %features-%action-pasteQuiz = COND #( WHEN ( ls_quiz_read_result-question_count = 0 AND ls_quiz_read_result-part_count = 0 )
                                              THEN if_abap_behv=>fc-o-enabled
                                              ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

    IF requested_authorizations-%action-pasteQuiz = if_abap_behv=>mk-on.

      READ ENTITIES OF znept_qz_i_quiz_u IN LOCAL MODE
        ENTITY quiz
          FIELDS ( uploadby )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_quiz).

      LOOP AT lt_quiz INTO DATA(ls_quiz).
        DATA(lv_auth_change) = COND #( WHEN ls_quiz-uploadby = sy-uname THEN if_abap_behv=>auth-allowed
                                                                        ELSE if_abap_behv=>auth-unauthorized ).

        APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
        <fs_result>-%key = ls_quiz-%key.

        <fs_result>-%action-pasteQuiz = lv_auth_change.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD pasteQuiz.

    DATA: lt_db_parts     TYPE znept_qz_db_parts_t,
          lt_db_questions TYPE znept_qz_db_questions_t,
          lt_db_variants  TYPE znept_qz_db_variants_t,
          ls_db_parts     TYPE znept_qz_db_parts_s,
          ls_db_questions TYPE znept_qz_db_questions_s,
          ls_db_variants  TYPE znept_qz_db_variants_s,
          lv_test_name    TYPE znept_qz_test_name_de,
          lv_xcontent     TYPE xstring,
          lv_content      TYPE string,
          lt_file         TYPE TABLE OF string,
          lt_block        TYPE TABLE OF string,
          lv_line         TYPE string,
          lv_block        TYPE string,
          lv_dummy        TYPE string,                      "#EC NEEDED
          lv_block_size   TYPE i,
          lv_total_lines  TYPE i,
          lv_tabix        TYPE i,
          lv_test_id      TYPE znept_qz_test_id_de.

    DATA: ls_db_tests_key    TYPE znept_qz_db_tests_key_s,
          lv_count_parts     TYPE int2,
          lv_count_questions TYPE int2.

    LOOP AT keys INTO DATA(ls_keys).
      lv_content = ls_keys-%param-streamtext.
      lv_test_id = ls_keys-testid.
      EXIT.
    ENDLOOP.

* The button is still available and can be pressed again
    ls_db_tests_key-test_id = lv_test_id.
    zcl_nept_qz_data_provider=>info( EXPORTING is_db_tests_key    = ls_db_tests_key
                                     IMPORTING ev_total_parts     = lv_count_parts
                                               ev_total_questions = lv_count_questions ).
    IF lv_count_parts + lv_count_questions > 0.
      INSERT VALUE #(
        %msg = new_message_with_text( text = 'Quiz is not empty'(001)
        severity = if_abap_behv_message=>severity-error )
      ) INTO TABLE reported-Quiz.
      RETURN.
    ENDIF.

    IF NOT lv_content IS INITIAL.
      SPLIT lv_content AT cl_abap_char_utilities=>newline INTO TABLE lt_file.

      lv_total_lines = lines( lt_file ).

      LOOP AT lt_file INTO lv_line.                        "#EC INTO_OK
        lv_tabix = sy-tabix.

        IF strlen( lv_line ) > 1.
          APPEND lv_line TO lt_block.

          IF lv_tabix < lv_total_lines.
            CONTINUE.
          ENDIF.
        ENDIF.

        IF lt_block[] IS INITIAL.
          CONTINUE.
        ENDIF.

        lv_block_size = lines( lt_block ).

        LOOP AT lt_block INTO lv_block.                    "#EC INTO_OK

          IF lv_block_size = 1.
            SPLIT lv_block AT cl_abap_char_utilities=>horizontal_tab INTO ls_db_parts-description lv_dummy.

            ls_db_parts-part_id = ls_db_parts-part_id + 1.
            APPEND ls_db_parts TO lt_db_parts.

            CONTINUE.
          ENDIF.

          IF ls_db_variants-variant_id IS INITIAL.
            ls_db_questions-part_id     = ls_db_parts-part_id.
            ls_db_questions-question_id = ls_db_questions-question_id + 1.

            SPLIT lv_block AT cl_abap_char_utilities=>horizontal_tab INTO ls_db_questions-question ls_db_questions-explanation.

            APPEND ls_db_questions TO lt_db_questions.
            ls_db_variants-variant_id = 1.
          ELSE.
*          ls_db_variants-part_id     = ls_db_parts-part_id.
            ls_db_variants-question_id = ls_db_questions-question_id.

            SPLIT lv_block AT cl_abap_char_utilities=>horizontal_tab INTO ls_db_variants-variant ls_db_variants-correct.

            IF NOT ls_db_variants-correct IS INITIAL.
              ls_db_variants-correct = abap_true.
            ENDIF.

            APPEND ls_db_variants TO lt_db_variants.
            ls_db_variants-variant_id = ls_db_variants-variant_id + 1.
          ENDIF.

          CLEAR lv_block.
        ENDLOOP.

        CLEAR lt_block[].
        CLEAR ls_db_variants.

        CLEAR lv_line.
      ENDLOOP.
    ENDIF.

    IF NOT lt_db_questions[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_provider=>add
        EXPORTING
          iv_test_id      = lv_test_id
          iv_description  = lv_test_name
          iv_published    = abap_false
          it_db_parts     = lt_db_parts
          it_db_questions = lt_db_questions
          it_db_variants  = lt_db_variants
        IMPORTING
          ev_db_error     = DATA(lv_db_error)
          ev_do_commit    = DATA(lv_do_commit).

      IF NOT lv_db_error IS INITIAL.
        INSERT VALUE #(
          %msg = new_message_with_text( text = 'Error on adding questions'(002)
          severity = if_abap_behv_message=>severity-error )
        ) INTO TABLE reported-quiz.
      ELSE.
        INSERT VALUE #(
          %msg = new_message_with_text( text = 'Questions were added'(003)
          severity = if_abap_behv_message=>severity-information )
        ) INTO TABLE reported-quiz.
      ENDIF.
    ELSE.
      INSERT VALUE #(
        %msg = new_message_with_text( text = 'No questions were added'(004)
        severity = if_abap_behv_message=>severity-error )
      ) INTO TABLE reported-quiz.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Question DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Question RESULT result.

    METHODS pasteQuestion FOR MODIFY
      IMPORTING keys FOR ACTION Question~pasteQuestion.

ENDCLASS.

CLASS lhc_Question IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD pasteQuestion.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZNEPT_QZ_I_QUIZ_U DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZNEPT_QZ_I_QUIZ_U IMPLEMENTATION.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
