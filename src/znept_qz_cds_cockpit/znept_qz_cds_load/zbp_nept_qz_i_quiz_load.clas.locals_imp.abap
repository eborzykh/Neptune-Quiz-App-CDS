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
            SELECT MAX( test_id ) FROM znept_qz_tst INTO @DATA(lv_test_id). "#EC CI_NOWHERE
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

    METHODS trivia FOR MODIFY
      IMPORTING keys FOR ACTION quiz~trivia.

    METHODS unescape IMPORTING iv_str TYPE string RETURNING VALUE(rv_str) TYPE string.

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
          %msg = new_message_with_text( text = 'Error on adding questions'
          severity = if_abap_behv_message=>severity-error )
        ) INTO TABLE reported-quiz.
      ELSE.
        INSERT VALUE #(
          %msg = new_message_with_text( text = 'Questions were added'
          severity = if_abap_behv_message=>severity-information )
        ) INTO TABLE reported-quiz.
      ENDIF.
    ELSE.
      INSERT VALUE #(
        %msg = new_message_with_text( text = 'No questions were added'
        severity = if_abap_behv_message=>severity-error )
      ) INTO TABLE reported-quiz.
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
                                                                 ELSE if_abap_behv=>fc-o-disabled )
                               %features-%action-trivia = COND #( WHEN ls_quiz-part_count = 0 AND ls_quiz-question_count = 0
                                                                 THEN if_abap_behv=>fc-o-enabled
                                                                 ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.

  METHOD upload.
  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD trivia.

    TYPES:
      BEGIN OF ty_results,
        category          TYPE string,
        correct_answer    TYPE string,
        difficulty        TYPE string,
        incorrect_answers TYPE STANDARD TABLE OF string WITH NON-UNIQUE DEFAULT KEY,
        question          TYPE string,
        type              TYPE string,
      END OF ty_results,

      BEGIN OF ty_trivia,
        response_code TYPE string,
        results       TYPE STANDARD TABLE OF ty_results WITH NON-UNIQUE DEFAULT KEY,
      END OF ty_trivia.

    DATA: lt_db_parts        TYPE znept_qz_db_parts_t,
          lt_db_questions    TYPE znept_qz_db_questions_t,
          lt_db_variants     TYPE znept_qz_db_variants_t,
          lv_test_name       TYPE znept_qz_test_name_de,
          lv_test_id         TYPE znept_qz_test_id_de,
          lt_db_variants_app TYPE znept_qz_db_variants_t,
          lv_difficulty_url  TYPE string,
          lv_url_address     TYPE string,
          lv_response        TYPE string,
          lv_trivia          TYPE ty_trivia,
          lr_json_data       TYPE REF TO data,
          lv_message         TYPE string,
          lv_count           TYPE int2,
          lv_category        TYPE znept_qz_trivia_category_de,
          lv_difficulty      TYPE znept_qz_trivia_difficulty_de.

    LOOP AT keys INTO DATA(ls_keys).
      lv_count = ls_keys-%param-p_count.
      lv_category = ls_keys-%param-p_category.
      lv_difficulty = ls_keys-%param-p_difficulty.
      lv_test_id = ls_keys-testid.
      EXIT.
    ENDLOOP.

    CASE lv_difficulty.
      WHEN '1'.
        lv_difficulty_url = 'easy'.
      WHEN '2'.
        lv_difficulty_url = 'medium'.
      WHEN '3'.
        lv_difficulty_url = 'hard'.
      WHEN OTHERS.
        CLEAR lv_difficulty_url.
    ENDCASE.

    lv_url_address = |https://opentdb.com/api.php?amount={ lv_count }&category={ lv_category }|.

    IF NOT lv_difficulty_url IS INITIAL.
      CONCATENATE lv_url_address '&difficulty=' lv_difficulty_url INTO lv_url_address.
    ENDIF.

*    SELECT SINGLE persnumber INTO @DATA(lv_token_url) FROM v_username WHERE bname = @sy-uname.
*    IF sy-subrc = 0 AND NOT lv_token_url IS INITIAL.
*      CONCATENATE lv_url_address '&token=' lv_token_url INTO lv_url_address.
*    ENDIF.

    cl_http_client=>create_by_url( EXPORTING url = lv_url_address
                                   IMPORTING client = DATA(http_client)
                                   EXCEPTIONS argument_not_found = 1
                                              plugin_not_active  = 2
                                              internal_error     = 3
                                              OTHERS             = 4 ).
    IF sy-subrc = 0.
      http_client->send( ).
      http_client->receive( ).

      lv_response = http_client->response->get_cdata( ).
    ENDIF.

    IF NOT lv_response IS INITIAL.
      CALL METHOD /ui2/cl_json=>deserialize
        EXPORTING
          json         = lv_response
          pretty_name  = /ui2/cl_json=>pretty_mode-user
          assoc_arrays = abap_true
        CHANGING
          data         = lv_trivia.
    ENDIF.

* ----------------------------------------------------------------
* https://opentdb.com/api_config.php
* ----------------------------------------------------------------
* Code 0: Success Returned results successfully.
* Code 1: No Results Could not return results. The API doesn't have enough questions for your query. (Ex. Asking for 50 Questions in a Category that only has 20.)
* Code 2: Invalid Parameter Contains an invalid parameter. Arguements passed in aren't valid. (Ex. Amount = Five)
* Code 3: Token Not Found Session Token does not exist.
* Code 4: Token Empty Session Token has returned all possible questions for the specified query. Resetting the Token is necessary.
* Code 5: Rate Limit Too many requests have occurred. Each IP can only access the API once every 5 seconds.

    IF lv_trivia-response_code = '0'.

      LOOP AT lv_trivia-results ASSIGNING FIELD-SYMBOL(<fs_results>).

        APPEND INITIAL LINE TO lt_db_questions ASSIGNING FIELD-SYMBOL(<fs_db_questions>).
        <fs_db_questions>-question_id = sy-tabix.
        <fs_db_questions>-question = unescape( <fs_results>-question ).

        DATA(lr_rnd) = cl_abap_random_int=>create( seed = + sy-tabix min = 1 max = lines( <fs_results>-incorrect_answers ) ).

        APPEND INITIAL LINE TO lt_db_variants_app ASSIGNING FIELD-SYMBOL(<fs_db_variants_app>).
        <fs_db_variants_app>-variant = unescape( <fs_results>-correct_answer ).
        <fs_db_variants_app>-correct = abap_true.
        <fs_db_variants_app>-sort = lr_rnd->get_next( ).

        LOOP AT <fs_results>-incorrect_answers ASSIGNING FIELD-SYMBOL(<fs_incorrect_answers>).
          APPEND INITIAL LINE TO lt_db_variants_app ASSIGNING <fs_db_variants_app>.
          <fs_db_variants_app>-variant = unescape( <fs_incorrect_answers> ).
          <fs_db_variants_app>-sort = lr_rnd->get_next( ).
        ENDLOOP.

        SORT lt_db_variants_app BY sort.

        LOOP AT lt_db_variants_app ASSIGNING <fs_db_variants_app>.
          <fs_db_variants_app>-question_id = <fs_db_questions>-question_id.
          <fs_db_variants_app>-variant_id = sy-tabix.
          CLEAR <fs_db_variants_app>-sort.
          APPEND <fs_db_variants_app> TO lt_db_variants.
        ENDLOOP.

        IF lv_difficulty_url IS INITIAL.
          READ TABLE lt_db_parts ASSIGNING FIELD-SYMBOL(<fs_db_parts>) WITH KEY description = <fs_results>-difficulty.
          IF sy-subrc <> 0.
            APPEND INITIAL LINE TO lt_db_parts ASSIGNING <fs_db_parts>.
            <fs_db_parts>-part_id = lines( lt_db_parts ).
            <fs_db_parts>-description = <fs_results>-difficulty.
          ENDIF.
          <fs_db_questions>-part_id = <fs_db_parts>-part_id.
        ENDIF.

        CLEAR lt_db_variants_app.
      ENDLOOP.
    ELSE.
      CASE lv_trivia-response_code.
        WHEN '1'.
          lv_message = 'No Results Could not return results.'.
        WHEN '2'.
          lv_message = 'Invalid Parameter Contains an invalid parameter.'.
        WHEN '3'.
          lv_message = 'Token Not Found Session Token does not exist.'.
        WHEN '4'.
          lv_message = 'Token has returned all possible questions'.
        WHEN '5'.
          lv_message = 'Rate Limit Too many requests have occurred.'.
        WHEN OTHERS.
          lv_message = 'Unknown code (' && lv_trivia-response_code && ')'.
      ENDCASE.
    ENDIF.

    IF NOT lt_db_questions IS INITIAL.
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
          %msg = new_message_with_text( text = 'Error on adding questions'
          severity = if_abap_behv_message=>severity-error )
        ) INTO TABLE reported-quiz.
      ELSE.
        INSERT VALUE #(
          %msg = new_message_with_text( text = 'Questions were added'
          severity = if_abap_behv_message=>severity-information )
        ) INTO TABLE reported-quiz.
      ENDIF.
    ELSE.
      IF lv_message IS INITIAL.
        lv_message = 'No questions were identified'.
      ENDIF.
      INSERT VALUE #(
        %msg = new_message_with_text( text = lv_message
        severity = if_abap_behv_message=>severity-error )
      ) INTO TABLE reported-quiz.
    ENDIF.

  ENDMETHOD.

  METHOD unescape.

    rv_str = iv_str.

    REPLACE ALL OCCURRENCES OF '&quot;' IN rv_str WITH '"'.
    REPLACE ALL OCCURRENCES OF '&#039;' IN rv_str WITH '`'.
    REPLACE ALL OCCURRENCES OF '&amp;' IN rv_str WITH '&'.
    REPLACE ALL OCCURRENCES OF '&lt;' IN rv_str WITH '<'.
    REPLACE ALL OCCURRENCES OF '&gt;' IN rv_str WITH '>'.
    REPLACE ALL OCCURRENCES OF '&ldquo;' IN rv_str WITH '”'.
    REPLACE ALL OCCURRENCES OF '&rdquo;' IN rv_str WITH '“'.

  ENDMETHOD.

ENDCLASS.
