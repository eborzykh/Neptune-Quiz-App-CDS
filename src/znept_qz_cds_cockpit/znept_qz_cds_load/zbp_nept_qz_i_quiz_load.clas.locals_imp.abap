CLASS lsc_znept_qz_i_quiz_load DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_load IMPLEMENTATION.

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

  ENDMETHOD.

ENDCLASS.

CLASS lhc_quiz DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR quiz RESULT result.

    METHODS paste FOR MODIFY
      IMPORTING keys FOR ACTION quiz~paste.

    METHODS settestetag FOR DETERMINE ON MODIFY
      IMPORTING keys FOR quiz~settestetag.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR quiz RESULT result.
    METHODS upload FOR MODIFY
      IMPORTING keys FOR ACTION quiz~upload.

ENDCLASS.

CLASS lhc_quiz IMPLEMENTATION.

  METHOD paste.

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

    LOOP AT keys INTO DATA(ls_keys).
      lv_content = ls_keys-%param-streamtext.
      lv_test_id = ls_keys-testid.
      EXIT.
    ENDLOOP.

    CHECK: NOT lv_content IS INITIAL,
           NOT lv_test_id IS INITIAL.

    SPLIT lv_content AT cl_abap_char_utilities=>newline INTO TABLE lt_file.

    lv_total_lines = lines( lt_file ).

    LOOP AT lt_file INTO lv_line.                          "#EC INTO_OK
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

      LOOP AT lt_block INTO lv_block.                      "#EC INTO_OK

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

    IF lt_db_questions[] IS INITIAL.
      RETURN.
    ENDIF.

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

    ENDIF.

  ENDMETHOD.

  METHOD settestetag.

    READ ENTITIES OF znept_qz_i_quiz_load IN LOCAL MODE
     ENTITY quiz
       FIELDS ( uploadby uploadon uploadat )
         WITH CORRESPONDING #( keys )
       RESULT DATA(lt_quizzes).

    DELETE lt_quizzes WHERE uploadby IS NOT INITIAL OR uploadon IS NOT INITIAL OR uploadat IS NOT INITIAL.
    CHECK lt_quizzes IS NOT INITIAL.

    MODIFY ENTITIES OF znept_qz_i_quiz_load IN LOCAL MODE
      ENTITY quiz
        UPDATE FIELDS ( uploadby uploadon uploadat )
          WITH VALUE #( FOR quiz IN lt_quizzes ( %tky     = quiz-%tky
                                                 uploadby = sy-uname
                                                 uploadon = sy-datum
                                                 uploadat = sy-timlo ) ).

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF znept_qz_i_quiz_load IN LOCAL MODE
      ENTITY quiz
        FIELDS ( part_count question_count  )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_quiz).

    result = VALUE #(
      FOR ls_quiz IN lt_quiz ( %tky = ls_quiz-%tky
                               %features-%action-paste = COND #( WHEN ls_quiz-part_count = 0 AND ls_quiz-question_count = 0
                                                                 THEN if_abap_behv=>fc-o-enabled
                                                                 ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD upload.
  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

ENDCLASS.
