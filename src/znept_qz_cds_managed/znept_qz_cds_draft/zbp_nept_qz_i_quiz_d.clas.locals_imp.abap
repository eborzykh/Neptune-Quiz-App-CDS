*
CLASS ltcl_quiz_d DEFINITION DEFERRED FOR TESTING.

CLASS lhc_quiz DEFINITION INHERITING FROM cl_abap_behavior_handler
  FRIENDS ltcl_quiz_d.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR quiz RESULT result.

    METHODS setversion FOR DETERMINE ON SAVE
      IMPORTING keys FOR quiz~setversion.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR quiz RESULT result.

    METHODS publish FOR MODIFY
      IMPORTING keys FOR ACTION quiz~publish RESULT result.

    METHODS unpublish FOR MODIFY
      IMPORTING keys FOR ACTION quiz~unpublish RESULT result.

    METHODS settestetag FOR DETERMINE ON MODIFY
      IMPORTING keys FOR quiz~settestetag.

    METHODS fordescription FOR VALIDATE ON SAVE
      IMPORTING keys FOR quiz~fordescription.

    METHODS trivia FOR MODIFY
      IMPORTING keys FOR ACTION quiz~trivia RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR quiz RESULT result.

ENDCLASS.

CLASS lhc_quiz IMPLEMENTATION.

  METHOD get_instance_authorizations.

    IF requested_authorizations-%update = if_abap_behv=>mk-on
    OR requested_authorizations-%delete = if_abap_behv=>mk-on
    OR requested_authorizations-%action-publish = if_abap_behv=>mk-on
    OR requested_authorizations-%action-unpublish = if_abap_behv=>mk-on
    OR requested_authorizations-%action-trivia = if_abap_behv=>mk-on.

      READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
        ENTITY quiz
          FIELDS ( uploadby )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_quiz).

      LOOP AT lt_quiz INTO DATA(ls_quiz).

        DATA(lv_auth_change) = COND #( WHEN ls_quiz-uploadby = sy-uname THEN if_abap_behv=>auth-allowed
                                                                        ELSE if_abap_behv=>auth-unauthorized ).

        APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
        <fs_result>-%key = ls_quiz-%key.

        <fs_result>-%update = lv_auth_change.
        <fs_result>-%delete = lv_auth_change.
        <fs_result>-%action-publish = lv_auth_change.
        <fs_result>-%action-unpublish = lv_auth_change.
        <fs_result>-%action-trivia = lv_auth_change.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD setversion.

    READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
     ENTITY quiz
       FIELDS ( version )
         WITH CORRESPONDING #( keys )
       RESULT DATA(lt_quiz).

    LOOP AT lt_quiz ASSIGNING FIELD-SYMBOL(<fs_quiz>).
      <fs_quiz>-version += 1.
    ENDLOOP.

    MODIFY ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
      ENTITY quiz
        UPDATE FIELDS ( version )
          WITH VALUE #( FOR quiz IN lt_quiz ( %tky = quiz-%tky version = quiz-version ) ).

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
      ENTITY quiz
        FIELDS ( description published )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_quiz).

* don`t call API more often than we need
    IF requested_features-%action-trivia = if_abap_behv=>mk-on.
      LOOP AT lt_quiz ASSIGNING FIELD-SYMBOL(<fs_quiz>).
        IF <fs_quiz>-description CS zcl_nept_qz_src_trivia=>gc_src_name AND <fs_quiz>-question_count = 0 AND <fs_quiz>-part_count = 0.

          TRY.
              zcl_nept_qz_src_trivia=>get_count_overall( IMPORTING ev_questions = DATA(lv_trivia_total) ).
            CATCH zcx_nept_qz_src_trivia_api.
              CLEAR lv_trivia_total.
          ENDTRY.

          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

    result = VALUE #(
      FOR ls_quiz IN lt_quiz ( %tky = ls_quiz-%tky

                               %features-%action-publish = COND #( WHEN ls_quiz-published = zcl_nept_qz_data_provider=>gc_quiz_published
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )

                               %features-%action-unpublish = COND #( WHEN ls_quiz-published = zcl_nept_qz_data_provider=>gc_quiz_private
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_abap_behv=>fc-o-enabled )

                               %features-%action-trivia = COND #( WHEN ( lv_trivia_total > 0 AND ls_quiz-description CS zcl_nept_qz_src_trivia=>gc_src_name
                                                                                             AND ls_quiz-question_count = 0
                                                                                             AND ls_quiz-part_count = 0 )
                                                                     THEN if_abap_behv=>fc-o-enabled
                                                                     ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD publish.

    MODIFY ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
      ENTITY quiz
        UPDATE FIELDS ( published )
        WITH VALUE #( FOR key IN keys ( %tky      = key-%tky
                                        published = zcl_nept_qz_data_provider=>gc_quiz_published ) ).

* read changed data for action result (does not work without it in _O4)

    READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
      ENTITY quiz
        ALL FIELDS WITH
        CORRESPONDING #( keys )
      RESULT DATA(lt_quiz).

    result = VALUE #( FOR ls_quiz IN lt_quiz ( %tky = ls_quiz-%tky %param = ls_quiz ) ).

* display toast like message

    reported-quiz = VALUE #( FOR ls_quiz IN lt_quiz ( %tky = ls_quiz-%tky
                                                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                                                    text = 'Published'(003) )
                                                      %element-published = if_abap_behv=>mk-on
                                                      %op-%action-publish = if_abap_behv=>mk-on ) ).
  ENDMETHOD.

  METHOD unpublish.

    MODIFY ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
      ENTITY quiz
        UPDATE FIELDS ( published )
        WITH VALUE #( FOR key IN keys ( %tky      = key-%tky
                                        published = zcl_nept_qz_data_provider=>gc_quiz_private ) ).

* read changed data for action result (does not work without it in _O4)

    READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
      ENTITY quiz
        ALL FIELDS WITH
        CORRESPONDING #( keys )
      RESULT DATA(lt_quiz).

    result = VALUE #( FOR ls_quiz IN lt_quiz ( %tky = ls_quiz-%tky %param = ls_quiz ) ).

* display toast like message

    reported-quiz = VALUE #( FOR ls_quiz IN lt_quiz ( %tky = ls_quiz-%tky
                                                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                                                    text = 'Unpublished'(002) )
                                                      %element-published = if_abap_behv=>mk-on
                                                      %op-%action-unpublish = if_abap_behv=>mk-on ) ).

  ENDMETHOD.

  METHOD settestetag.

    READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
     ENTITY quiz
       FIELDS ( uploadby uploadon uploadat )
         WITH CORRESPONDING #( keys )
       RESULT DATA(lt_quizzes).

    DELETE lt_quizzes WHERE uploadby IS NOT INITIAL OR uploadon IS NOT INITIAL OR uploadat IS NOT INITIAL.
    CHECK lt_quizzes IS NOT INITIAL.

    MODIFY ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
      ENTITY quiz
        UPDATE FIELDS ( uploadby uploadon uploadat )
          WITH VALUE #( FOR quiz IN lt_quizzes ( %tky     = quiz-%tky
                                                 uploadby = sy-uname
                                                 uploadon = sy-datum
                                                 uploadat = sy-timlo ) ).
  ENDMETHOD.

  METHOD fordescription.

    READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
      ENTITY quiz
        FIELDS ( description )
        WITH CORRESPONDING #( keys )
      RESULT DATA(quiz).

    LOOP AT quiz INTO DATA(ls_quiz).
      IF ls_quiz-description IS INITIAL.
        APPEND INITIAL LINE TO failed-quiz ASSIGNING FIELD-SYMBOL(<fs_failed_quiz>).
        <fs_failed_quiz>-%tky = ls_quiz-%tky.

        APPEND INITIAL LINE TO reported-quiz ASSIGNING FIELD-SYMBOL(<fs_reported_quiz>).
        <fs_reported_quiz>-%tky = ls_quiz-%tky.
        <fs_reported_quiz>-%msg = new_message( id = 'ZNEPT_QZ_CDS'
                                               number = '180'
                                               severity = if_abap_behv_message=>severity-error ).
        <fs_reported_quiz>-%element-description = if_abap_behv=>mk-on.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD trivia.

**********************************************************************
*
*                TO DO: to be replaced with EML
*
**********************************************************************

    DATA: lt_messages     TYPE symsg_tab.

    READ TABLE keys INDEX 1 INTO DATA(ls_keys).
    IF sy-subrc = 0.
      DATA(ls_db_quiz_in) = VALUE znept_qz_db_tests_s( test_id = ls_keys-testid ).

      CALL FUNCTION 'ZNEPT_QZ_QUIZ_TRIVIA'
        EXPORTING
          is_db_quiz    = ls_db_quiz_in
          iv_category   = ls_keys-%param-p_category
          iv_difficulty = ls_keys-%param-p_difficulty
          iv_count      = ls_keys-%param-p_count
        IMPORTING
          et_messages   = lt_messages.

      IF lt_messages IS NOT INITIAL.
        APPEND INITIAL LINE TO failed-quiz ASSIGNING FIELD-SYMBOL(<fs_failed_quiz>).
        <fs_failed_quiz>-%tky = ls_keys-%tky.

        LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<fs_messages>).
          APPEND INITIAL LINE TO reported-quiz ASSIGNING FIELD-SYMBOL(<fs_reported_quiz>).
          <fs_reported_quiz>-%tky = ls_keys-%tky.
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
        reported-quiz = VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky
                                                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                                                    text = 'Created with Trivia'(001) )
                                                      %op-%action-trivia = if_abap_behv=>mk-on ) ).
      ENDIF.

* read changed data for action result (does not work without it in _O4)

      READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
        ENTITY quiz
          ALL FIELDS WITH
          CORRESPONDING #( keys )
        RESULT DATA(lt_quiz).

      result = VALUE #( FOR ls_quiz IN lt_quiz ( %tky = ls_quiz-%tky %param = ls_quiz ) ).

    ENDIF.

  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_d DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_d IMPLEMENTATION.

**********************************************************************
* POINT OF NO RETURN
**********************************************************************

**********************************************************************
* calculate IDs for new items
**********************************************************************
  METHOD adjust_numbers.

    " Quiz

    DATA lv_quiz_id TYPE znept_qz_test_id_de. " to keep the latest Quiz ID

    DATA(lt_create_quiz) = mapped-quiz.
    DELETE lt_create_quiz WHERE testid IS NOT INITIAL.

    IF lt_create_quiz IS NOT INITIAL.
      LOOP AT lt_create_quiz ASSIGNING FIELD-SYMBOL(<fs_create_quiz>).
        READ TABLE mapped-quiz WITH KEY %pid = <fs_create_quiz>-%pid ASSIGNING FIELD-SYMBOL(<fs_mapped_quiz>) BINARY SEARCH.
        IF sy-subrc = 0 AND <fs_mapped_quiz> IS ASSIGNED.
          IF lv_quiz_id IS INITIAL.
            SELECT MAX( test_id ) FROM znept_qz_tst INTO @DATA(lv_test_id).
            IF sy-subrc <> 0.
              CLEAR lv_test_id.
            ENDIF.
          ENDIF.
          lv_test_id += 1.
          <fs_mapped_quiz>-testid = lv_test_id.
          UNASSIGN <fs_mapped_quiz>.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " Part

    TYPES: BEGIN OF tt_part_id,
             testid TYPE znept_qz_test_id_de,
             partid TYPE znept_qz_part_id_de,
           END OF tt_part_id.

    DATA lt_part_id TYPE TABLE OF tt_part_id. " to keep the latest Part ID

    DATA(lt_create_part) = mapped-part.
    DELETE lt_create_part WHERE partid IS NOT INITIAL.

    IF lt_create_part IS NOT INITIAL.
      SORT lt_create_part BY %tmp-testid.

      LOOP AT lt_create_part ASSIGNING FIELD-SYMBOL(<fs_create_part>).
        READ TABLE mapped-part WITH KEY %pid = <fs_create_part>-%pid ASSIGNING FIELD-SYMBOL(<fs_mapped_part>) BINARY SEARCH.
        IF sy-subrc = 0 AND <fs_mapped_part> IS ASSIGNED.

          READ TABLE lt_part_id WITH KEY testid = <fs_create_part>-%tmp-testid ASSIGNING FIELD-SYMBOL(<fs_part_id>).
          IF sy-subrc <> 0 OR <fs_part_id> IS NOT ASSIGNED.
            APPEND INITIAL LINE TO lt_part_id ASSIGNING <fs_part_id>.
            IF <fs_part_id> IS ASSIGNED.
              MOVE-CORRESPONDING <fs_mapped_part>-%tmp TO <fs_part_id>.

              SELECT MAX( part_id ) FROM znept_qz_prt INTO @<fs_part_id>-partid
                WHERE test_id = @<fs_part_id>-testid.
              IF sy-subrc <> 0.
                CLEAR <fs_part_id>-partid.
              ENDIF.
            ENDIF.
          ENDIF.
          <fs_part_id>-partid += 1.
          MOVE-CORRESPONDING <fs_part_id> TO <fs_mapped_part>.
          UNASSIGN: <fs_mapped_part>, <fs_part_id>.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " Question

    TYPES: BEGIN OF tt_question_id,
             testid     TYPE znept_qz_test_id_de,
             questionid TYPE znept_qz_variant_id_de,
           END OF tt_question_id.

    DATA lt_question_id TYPE TABLE OF tt_question_id. " to keep the latest Question ID

    DATA(lt_create_question) = mapped-question.
    DELETE lt_create_question WHERE questionid IS NOT INITIAL.

    IF lt_create_question IS NOT INITIAL.
      SORT lt_create_question BY %tmp-testid.

      LOOP AT lt_create_question ASSIGNING FIELD-SYMBOL(<fs_create_question>).
        READ TABLE mapped-question WITH KEY %pid = <fs_create_question>-%pid ASSIGNING FIELD-SYMBOL(<fs_mapped_question>) BINARY SEARCH.
        IF sy-subrc = 0 AND <fs_mapped_question> IS ASSIGNED.

          READ TABLE lt_question_id WITH KEY testid = <fs_mapped_question>-%tmp-testid ASSIGNING FIELD-SYMBOL(<fs_question_id>).
          IF sy-subrc <> 0 OR <fs_question_id> IS NOT ASSIGNED.
            APPEND INITIAL LINE TO lt_question_id ASSIGNING <fs_question_id>.
            IF <fs_question_id> IS ASSIGNED.
              MOVE-CORRESPONDING <fs_mapped_question>-%tmp TO <fs_question_id>.

              SELECT MAX( question_id ) FROM znept_qz_qst INTO @<fs_question_id>-questionid
                WHERE test_id = @<fs_question_id>-testid.
              IF sy-subrc <> 0.
                CLEAR <fs_question_id>-questionid.
              ENDIF.
            ENDIF.
          ENDIF.
          <fs_question_id>-questionid += 1.
          MOVE-CORRESPONDING <fs_question_id> TO <fs_mapped_question>.
          UNASSIGN: <fs_mapped_question>, <fs_question_id>.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " Variant

    DATA(lt_create_variant) = mapped-variant.
    DELETE lt_create_variant WHERE variantid IS NOT INITIAL.

    TYPES: BEGIN OF tt_variant_id,
             testid     TYPE znept_qz_test_id_de,
             questionid TYPE znept_qz_question_id_de,
             variantid  TYPE znept_qz_variant_id_de,
           END OF tt_variant_id.

    DATA lt_variant_id TYPE TABLE OF tt_variant_id. " to keep the latest Variant ID

    IF lt_create_variant IS NOT INITIAL.
      SORT lt_create_variant BY %tmp-testid %tmp-questionid.

      LOOP AT lt_create_variant ASSIGNING FIELD-SYMBOL(<fs_create_variant>).
        READ TABLE mapped-variant WITH KEY %pid = <fs_create_variant>-%pid ASSIGNING FIELD-SYMBOL(<fs_mapped_variant>) BINARY SEARCH.
        IF sy-subrc = 0 AND <fs_mapped_variant> IS ASSIGNED.

          READ TABLE lt_variant_id WITH KEY testid     = <fs_create_variant>-%tmp-testid
                                            questionid = <fs_create_variant>-%tmp-questionid ASSIGNING FIELD-SYMBOL(<fs_variant_id>).
          IF sy-subrc <> 0 OR <fs_variant_id> IS NOT ASSIGNED.
            APPEND INITIAL LINE TO lt_variant_id ASSIGNING <fs_variant_id>.
            IF <fs_variant_id> IS ASSIGNED.
              MOVE-CORRESPONDING <fs_create_variant>-%tmp TO <fs_variant_id>.

              SELECT MAX( variant_id ) FROM znept_qz_var INTO @<fs_variant_id>-variantid
                WHERE test_id     = @<fs_variant_id>-testid
                  AND question_id = @<fs_variant_id>-questionid.
              IF sy-subrc <> 0.
                CLEAR <fs_variant_id>-variantid.
              ENDIF.
            ENDIF.
          ENDIF.
          <fs_variant_id>-variantid += 1.
          MOVE-CORRESPONDING <fs_variant_id> TO <fs_mapped_variant>.
          UNASSIGN: <fs_mapped_variant>, <fs_variant_id>.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
