CLASS lhc_Quiz DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS AIQuizClone FOR MODIFY
      IMPORTING keys FOR ACTION Quiz~AIQuizClone.

    METHODS AIQuizCreate FOR MODIFY
      IMPORTING keys FOR ACTION Quiz~AIQuizCreate RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Quiz RESULT result.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR Quiz RESULT result.

    METHODS GetDfltsFor_AIQuizClone FOR READ
      IMPORTING keys FOR FUNCTION Quiz~GetDfltsFor_AIQuizClone RESULT result.

    METHODS GetDfltsFor_AIQuizCreate FOR READ
      IMPORTING keys FOR FUNCTION Quiz~GetDfltsFor_AIQuizCreate RESULT result.

ENDCLASS.

CLASS lhc_Quiz IMPLEMENTATION.

  METHOD get_global_features.

    IF requested_features-%action-AIQuizCreate = if_abap_behv=>mk-on.

      result = VALUE #( %action-AIQuizCreate = COND #( WHEN NOT zcl_nept_qz_src_ai=>check_availability(  ) IS INITIAL
                                                       THEN if_abap_behv=>fc-o-enabled
                                                       ELSE if_abap_behv=>fc-o-disabled ) ).
    ENDIF.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        FIELDS ( question_count )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_quiz).

    IF requested_features-%action-AIQuizClone = if_abap_behv=>mk-on.

      LOOP AT lt_quiz ASSIGNING FIELD-SYMBOL(<fs_quiz>).
        IF <fs_quiz>-question_count > 0.
          DATA(lv_api_available) = zcl_nept_qz_src_ai=>check_availability( ).
          EXIT.
        ENDIF.
      ENDLOOP.

      result = VALUE #(
        FOR ls_quiz IN lt_quiz ( %tky = ls_quiz-%tky
                                 %features-%action-AIQuizClone = COND #( WHEN ( lv_api_available = abap_true AND ls_quiz-question_count > 0 )
                                                                         THEN if_abap_behv=>fc-o-enabled
                                                                         ELSE if_abap_behv=>fc-o-disabled ) ) ).
    ENDIF.

  ENDMETHOD.

  METHOD AIQuizClone.

    READ TABLE keys INDEX 1 INTO DATA(ls_keys).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(ls_db_quiz_ref) = VALUE znept_qz_db_tests_s( test_id = ls_keys-testid ).

    TRY.
        zcl_nept_qz_src_ai=>get_quiz_clone( EXPORTING is_db_tests = ls_db_quiz_ref
                                                      iv_descriptiopn = ls_keys-%param-p_Name
                                                      iv_progress = ls_keys-%param-p_Progress
                                                      iv_difficulty = ls_keys-%param-p_difficulty
                                                      iv_count = ls_keys-%param-p_count
                                                      iv_api_key = zcl_nept_qz_src_util_api_key=>utilize( iv_value = ls_keys-%param-p_Key )
                                                      iv_model = ls_keys-%param-p_Model
*                                                      iv_max_token = ls_keys-%param-p_MaxToken
                                            IMPORTING et_db_parts = DATA(lt_db_parts)
                                                      et_db_questions = DATA(lt_db_questions)
                                                      et_db_variants = DATA(lt_db_variants)
                                                      es_usage = DATA(ls_usage) ).

      CATCH zcx_nept_qz_src_ai_api INTO DATA(lr_ai_api).

        cl_message_helper=>set_msg_vars_for_if_t100_msg( lr_ai_api ).

        APPEND INITIAL LINE TO reported-quiz ASSIGNING FIELD-SYMBOL(<fs_reported_quiz>).
        <fs_reported_quiz>-%tky = ls_keys-%tky.
        <fs_reported_quiz>-%msg = new_message( id = sy-msgid
                                               number = sy-msgno
                                               v1 = sy-msgv1
                                               v2 = sy-msgv2
                                               v3 = sy-msgv3
                                               v4 = sy-msgv4
                                               severity = if_abap_behv_message=>severity-error ).
        <fs_reported_quiz>-%op-%action-AIQuizClone = if_abap_behv=>mk-on.
        RETURN.
    ENDTRY.

    IF lt_db_questions IS INITIAL OR lt_db_variants IS INITIAL.
      APPEND INITIAL LINE TO reported-quiz ASSIGNING <fs_reported_quiz>.
      <fs_reported_quiz>-%cid = ls_keys-%cid.
      <fs_reported_quiz>-%msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text = 'No data received to create new quiz' ).
      <fs_reported_quiz>-%op-%action-AIQuizClone = if_abap_behv=>mk-on.
      RETURN.
    ENDIF.

**********************************************************************
    IF lines( lt_db_variants ) > 99.
      APPEND INITIAL LINE TO reported-quiz ASSIGNING <fs_reported_quiz>.
      <fs_reported_quiz>-%tky = ls_keys-%tky.
      <fs_reported_quiz>-%msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text = 'Limit on variants (must be < 99)' ).
      <fs_reported_quiz>-%op-%action-AIQuizClone = if_abap_behv=>mk-on.
      RETURN.
    ENDIF.
**********************************************************************

* Convert to EML structures

    DATA lt_quiz_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\\Quiz.
    DATA lt_part_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\\Quiz\_Part.
    DATA lt_question_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\\Quiz\_Question.
    DATA lt_variant_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\\Question\_Variant.

* Quiz

    APPEND INITIAL LINE TO lt_quiz_create ASSIGNING FIELD-SYMBOL(<fs_quiz_create>).
    <fs_quiz_create>-%cid = ls_keys-%cid.
    <fs_quiz_create>-%data-Description = ls_keys-%param-p_Name.
    <fs_quiz_create>-%data-Published = zcl_nept_qz_data_provider=>gc_quiz_private.
    <fs_quiz_create>-%control-Description = if_abap_behv=>mk-on.
    <fs_quiz_create>-%control-Published = if_abap_behv=>mk-on.

* Parts

    LOOP AT lt_db_parts INTO DATA(ls_db_parts).
      APPEND INITIAL LINE TO lt_part_create ASSIGNING FIELD-SYMBOL(<fs_part_create>).
      <fs_part_create>-%cid_ref = ls_keys-%cid.
      APPEND INITIAL LINE TO <fs_part_create>-%target ASSIGNING FIELD-SYMBOL(<fs_part_target>).
      <fs_part_target>-%cid = 'P' && ls_db_parts-part_id.
      <fs_part_target>-%data-Description = ls_db_parts-description.
      <fs_part_target>-%control-Description = if_abap_behv=>mk-on.
    ENDLOOP.

* Questions

    LOOP AT lt_db_questions INTO DATA(ls_db_quesions).
      APPEND INITIAL LINE TO lt_question_create ASSIGNING FIELD-SYMBOL(<fs_question_create>).
      <fs_question_create>-%cid_ref = ls_keys-%cid.
      APPEND INITIAL LINE TO <fs_question_create>-%target ASSIGNING FIELD-SYMBOL(<fs_question_target>).
      <fs_question_target>-%cid = 'Q' && ls_db_quesions-question_id.
      <fs_question_target>-%data-PartId = ls_db_quesions-part_id.
      <fs_question_target>-%data-Question = ls_db_quesions-question.
      <fs_question_target>-%data-Explanation = ls_db_quesions-explanation.
      <fs_question_target>-%control-PartId = if_abap_behv=>mk-on.
      <fs_question_target>-%control-Question = if_abap_behv=>mk-on.
      <fs_question_target>-%control-Explanation = if_abap_behv=>mk-on.
    ENDLOOP.

* Variants

    LOOP AT lt_db_variants INTO DATA(ls_db_variants).
      APPEND INITIAL LINE TO lt_variant_create ASSIGNING FIELD-SYMBOL(<fs_variant_create>).
      <fs_variant_create>-%cid_ref = 'Q' && ls_db_variants-question_id.
      APPEND INITIAL LINE TO <fs_variant_create>-%target ASSIGNING FIELD-SYMBOL(<fs_variant_target>).
      <fs_variant_target>-%cid = 'V' && ls_db_variants-question_id && ls_db_variants-variant_id.
      <fs_variant_target>-%data-Variant = ls_db_variants-variant.
      <fs_variant_target>-%data-Correct = ls_db_variants-correct.
      <fs_variant_target>-%control-Variant = if_abap_behv=>mk-on.
      <fs_variant_target>-%control-Correct = if_abap_behv=>mk-on.
    ENDLOOP.

**********************************************************************
*  some limitation with EML here when creating grand child entities
*  Variants will be created with all unique VariantIds
*  it limits the total number of Variants per Quiz up to max = 99.
*  Domain for VariantId shall be expanded 2 -> 4 if this will not be resolved
*  METHOD Adjust_Numbers receives all blank keys
**********************************************************************

    MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY Quiz
        CREATE FROM lt_quiz_create
      ENTITY Quiz
        CREATE BY \_Part
          FROM lt_part_create
      ENTITY Quiz
        CREATE BY \_Question
          FROM lt_question_create
      ENTITY Question
        CREATE BY \_Variant
          FROM lt_variant_create
      FAILED failed
      MAPPED mapped
      REPORTED reported.

* display toast like message
    IF failed IS INITIAL.
      reported-quiz = VALUE #( ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                               text = |Created with AI. Tokens used { ls_usage-total_tokens }| )
                                 %op-%action-AIQuizClone = if_abap_behv=>mk-on
                                 %cid = ls_keys-%cid ) ).
    ENDIF.

  ENDMETHOD.

  METHOD AIQuizCreate.

    READ TABLE keys INDEX 1 INTO DATA(ls_keys).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    TRY.
        zcl_nept_qz_src_ai=>get_quiz_create( EXPORTING iv_descriptiopn = ls_keys-%param-p_Name
                                                       iv_topic = ls_keys-%param-p_Topic
                                                       iv_count = ls_keys-%param-p_count
                                                       iv_api_key = zcl_nept_qz_src_util_api_key=>utilize( iv_value = ls_keys-%param-p_Key )
                                                       iv_model = ls_keys-%param-p_Model
*                                                       iv_max_token = ls_keys-%param-p_MaxToken
                                            IMPORTING et_db_parts = DATA(lt_db_parts)
                                                      et_db_questions = DATA(lt_db_questions)
                                                      et_db_variants = DATA(lt_db_variants)
                                                      es_usage = DATA(ls_usage) ).

      CATCH zcx_nept_qz_src_ai_api INTO DATA(lr_ai_api).

        cl_message_helper=>set_msg_vars_for_if_t100_msg( lr_ai_api ).

        APPEND INITIAL LINE TO reported-quiz ASSIGNING FIELD-SYMBOL(<fs_reported_quiz>).
        <fs_reported_quiz>-%cid = ls_keys-%cid.
        <fs_reported_quiz>-%msg = new_message( id = sy-msgid
                                               number = sy-msgno
                                               v1 = sy-msgv1
                                               v2 = sy-msgv2
                                               v3 = sy-msgv3
                                               v4 = sy-msgv4
                                               severity = if_abap_behv_message=>severity-error ).
        <fs_reported_quiz>-%op-%action-AIQuizCreate = if_abap_behv=>mk-on.
        RETURN.
    ENDTRY.

    IF lt_db_questions IS INITIAL OR lt_db_variants IS INITIAL.
      APPEND INITIAL LINE TO reported-quiz ASSIGNING <fs_reported_quiz>.
      <fs_reported_quiz>-%cid = ls_keys-%cid.
      <fs_reported_quiz>-%msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text = 'No data received to create new quiz' ).
      <fs_reported_quiz>-%op-%action-AIQuizCreate = if_abap_behv=>mk-on.
      RETURN.
    ENDIF.

**********************************************************************
    IF lines( lt_db_variants ) > 99.
      APPEND INITIAL LINE TO reported-quiz ASSIGNING <fs_reported_quiz>.
      <fs_reported_quiz>-%cid = ls_keys-%cid.
      <fs_reported_quiz>-%msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                         text = 'Limit on variants (must be < 99)' ).
      <fs_reported_quiz>-%op-%action-AIQuizCreate = if_abap_behv=>mk-on.
      RETURN.
    ENDIF.
**********************************************************************

* Convert to EML structures

    DATA lt_quiz_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\\Quiz.
    DATA lt_part_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\\Quiz\_Part.
    DATA lt_question_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\\Quiz\_Question.
    DATA lt_variant_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\\Question\_Variant.

* Quiz

    APPEND INITIAL LINE TO lt_quiz_create ASSIGNING FIELD-SYMBOL(<fs_quiz_create>).
    <fs_quiz_create>-%cid = ls_keys-%cid.
    <fs_quiz_create>-%data-Description = ls_keys-%param-p_Name.
    <fs_quiz_create>-%data-Published = zcl_nept_qz_data_provider=>gc_quiz_private.
    <fs_quiz_create>-%control-Description = if_abap_behv=>mk-on.
    <fs_quiz_create>-%control-Published = if_abap_behv=>mk-on.

* Parts

    LOOP AT lt_db_parts INTO DATA(ls_db_parts).
      APPEND INITIAL LINE TO lt_part_create ASSIGNING FIELD-SYMBOL(<fs_part_create>).
      <fs_part_create>-%cid_ref = ls_keys-%cid.
      APPEND INITIAL LINE TO <fs_part_create>-%target ASSIGNING FIELD-SYMBOL(<fs_part_target>).
      <fs_part_target>-%cid = 'P' && ls_db_parts-part_id.
      <fs_part_target>-%data-Description = ls_db_parts-description.
      <fs_part_target>-%control-Description = if_abap_behv=>mk-on.
    ENDLOOP.

* Questions

    LOOP AT lt_db_questions INTO DATA(ls_db_quesions).
      APPEND INITIAL LINE TO lt_question_create ASSIGNING FIELD-SYMBOL(<fs_question_create>).
      <fs_question_create>-%cid_ref = ls_keys-%cid.
      APPEND INITIAL LINE TO <fs_question_create>-%target ASSIGNING FIELD-SYMBOL(<fs_question_target>).
      <fs_question_target>-%cid = 'Q' && ls_db_quesions-question_id.
      <fs_question_target>-%data-PartId = ls_db_quesions-part_id.
      <fs_question_target>-%data-Question = ls_db_quesions-question.
      <fs_question_target>-%data-Explanation = ls_db_quesions-explanation.
      <fs_question_target>-%control-PartId = if_abap_behv=>mk-on.
      <fs_question_target>-%control-Question = if_abap_behv=>mk-on.
      <fs_question_target>-%control-Explanation = if_abap_behv=>mk-on.
    ENDLOOP.

* Variants

    LOOP AT lt_db_variants INTO DATA(ls_db_variants).
      APPEND INITIAL LINE TO lt_variant_create ASSIGNING FIELD-SYMBOL(<fs_variant_create>).
      <fs_variant_create>-%cid_ref = 'Q' && ls_db_variants-question_id.
      APPEND INITIAL LINE TO <fs_variant_create>-%target ASSIGNING FIELD-SYMBOL(<fs_variant_target>).
      <fs_variant_target>-%cid = 'V' && ls_db_variants-question_id && ls_db_variants-variant_id.
      <fs_variant_target>-%data-Variant = ls_db_variants-variant.
      <fs_variant_target>-%data-Correct = ls_db_variants-correct.
      <fs_variant_target>-%control-Variant = if_abap_behv=>mk-on.
      <fs_variant_target>-%control-Correct = if_abap_behv=>mk-on.
    ENDLOOP.

**********************************************************************
*  some limitation with EML here when creating grand child entities
*  Variants will be created with all unique VariantIds
*  it limits the total number of Variants per Quiz up to max = 99.
*  Domain for VariantId shall be expanded 2 -> 4 if this will not be resolved
*  METHOD Adjust_Numbers receives all blank keys
**********************************************************************

    MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY Quiz
        CREATE FROM lt_quiz_create
      ENTITY Quiz
        CREATE BY \_Part
          FROM lt_part_create
      ENTITY Quiz
        CREATE BY \_Question
          FROM lt_question_create
      ENTITY Question
        CREATE BY \_Variant
          FROM lt_variant_create
      FAILED failed
      MAPPED mapped
      REPORTED reported.

* display toast like message

    IF failed IS INITIAL.
      reported-quiz = VALUE #( ( %cid = ls_keys-%cid
                                 %msg = new_message_with_text( text = |Created with AI. Tokens used { ls_usage-total_tokens }|
                                                               severity = if_abap_behv_message=>severity-success )
                                 %op-%action-AIQuizCreate = if_abap_behv=>mk-on ) ).
    ENDIF.

* read changed data for action result (does not work without it in _O4)

    SELECT MAX( testid ) FROM znept_qz_i_quiz_m INTO @DATA(lv_next_test_id).

    result = VALUE #( ( %cid = ls_keys-%cid %param-TestId = lv_next_test_id + 1 ) ).

  ENDMETHOD.

  METHOD GetDfltsFor_AIQuizClone.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        FIELDS ( Description )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_quiz).

    LOOP AT keys INTO DATA(ls_key).

      READ TABLE lt_quiz WITH KEY %key = ls_key-%key INTO DATA(ls_quiz_ref) ##PRIMKEY[ENTITY].
      IF sy-subrc = 0.
        CONCATENATE ls_quiz_ref-Description '(AI Clone)' INTO DATA(lv_description) SEPARATED BY space.
      ENDIF.

      INSERT VALUE #( %tky = ls_key-%tky ) INTO TABLE result REFERENCE INTO DATA(lr_result).
      lr_result->%param-p_Count = zcl_nept_qz_src_ai=>gc_def_questions.
      lr_result->%param-p_Name = lv_description.
      lr_result->%param-p_Model = 'amazon.nova-lite-v1:0'.
      lr_result->%param-p_Key = zcl_nept_qz_src_util_api_key=>mask(  ).
    ENDLOOP.

  ENDMETHOD.

  METHOD GetDfltsFor_AIQuizCreate.

    LOOP AT keys INTO DATA(key).
      INSERT INITIAL LINE INTO TABLE result REFERENCE INTO DATA(lr_result).
      lr_result->%param-p_Count = zcl_nept_qz_src_ai=>gc_def_questions.
      lr_result->%param-p_Name = 'AI Quiz'.
      lr_result->%param-p_Topic = 'Create a simple quiz about Istanbul.'.
      lr_result->%param-p_Model = 'amazon.nova-lite-v1:0'.
      lr_result->%param-p_Key = zcl_nept_qz_src_util_api_key=>mask(  ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
