*
CLASS lhc_quiz DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS settestetag FOR DETERMINE ON MODIFY
      IMPORTING keys FOR quiz~settestetag.

    METHODS setversion FOR DETERMINE ON SAVE
      IMPORTING keys FOR quiz~setversion.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR quiz RESULT result.

    METHODS publish FOR MODIFY
      IMPORTING keys FOR ACTION quiz~publish.

    METHODS unpublish FOR MODIFY
      IMPORTING keys FOR ACTION quiz~unpublish.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR quiz RESULT result.

ENDCLASS.

CLASS lhc_quiz IMPLEMENTATION.

  METHOD settestetag.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
     ENTITY quiz
       FIELDS ( uploadby uploadon uploadat )
         WITH CORRESPONDING #( keys )
       RESULT DATA(quizzes).

    DELETE quizzes WHERE uploadby IS NOT INITIAL OR uploadon IS NOT INITIAL OR uploadat IS NOT INITIAL.
    CHECK quizzes IS NOT INITIAL.

    MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        UPDATE FIELDS ( uploadby uploadon uploadat )
          WITH VALUE #( FOR quiz IN quizzes ( %tky     = quiz-%tky
                                              uploadby = sy-uname
                                              uploadon = sy-datum
                                              uploadat = sy-timlo ) ).
  ENDMETHOD.

  METHOD setversion.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
     ENTITY quiz
       FIELDS ( version )
         WITH CORRESPONDING #( keys )
       RESULT DATA(lt_quiz).

    LOOP AT lt_quiz INTO DATA(ls_quiz).
      DATA(lv_version) = ls_quiz-version + 1.

      MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
        ENTITY quiz
          UPDATE FIELDS ( version )
            WITH VALUE #( ( %tky = ls_quiz-%tky version = lv_version ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        FIELDS ( published )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_quiz).

    result = VALUE #(
      FOR ls_quiz IN lt_quiz ( %tky = ls_quiz-%tky
                               %features-%action-publish = COND #( WHEN ls_quiz-published = 'X'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )
                               %features-%action-unpublish = COND #( WHEN ls_quiz-published = ''
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD publish.

    LOOP AT keys INTO DATA(ls_keys).
      MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
        ENTITY quiz
          UPDATE FIELDS ( published )
            WITH VALUE #( ( %tky = ls_keys-%tky published = 'X' ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD unpublish.

    LOOP AT keys INTO DATA(ls_keys).
      MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
        ENTITY quiz
          UPDATE FIELDS ( published )
            WITH VALUE #( ( %tky = ls_keys-%tky published = '' ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_m DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_m IMPLEMENTATION.

**********************************************************************
* POINT OF NO RETURN
**********************************************************************

**********************************************************************
* calculate IDs
**********************************************************************
  METHOD adjust_numbers.

    " Quiz

    DATA(lt_create_quiz) = mapped-quiz.
    DELETE lt_create_quiz WHERE testid IS NOT INITIAL.

    IF lt_create_quiz IS NOT INITIAL.
      LOOP AT lt_create_quiz ASSIGNING FIELD-SYMBOL(<fs_create_quiz>).
        AT FIRST.
          SELECT MAX( test_id ) FROM znept_qz_tst INTO @DATA(lv_test_id).
          IF sy-subrc <> 0.
            CLEAR lv_test_id.
          ENDIF.
        ENDAT.

        READ TABLE mapped-quiz WITH KEY %pid = <fs_create_quiz>-%pid ASSIGNING FIELD-SYMBOL(<fs_mapped_quiz>) BINARY SEARCH.
        IF sy-subrc = 0 AND <fs_mapped_quiz> IS ASSIGNED.
          lv_test_id += 1.
          <fs_mapped_quiz>-testid = lv_test_id.
          UNASSIGN <fs_mapped_quiz>.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " Part

    DATA(lt_create_part) = mapped-part.
    DELETE lt_create_part WHERE partid IS NOT INITIAL.

    IF lt_create_part IS NOT INITIAL.
      SORT lt_create_part BY %tmp-testid.

      LOOP AT lt_create_part ASSIGNING FIELD-SYMBOL(<fs_part>).
        AT NEW %tmp-testid.
          SELECT MAX( part_id ) FROM znept_qz_prt INTO @DATA(lv_part_id)
            WHERE test_id = @<fs_part>-%tmp-testid.
          IF sy-subrc <> 0.
            CLEAR lv_part_id.
          ENDIF.
        ENDAT.

        READ TABLE mapped-part WITH KEY %pid = <fs_part>-%pid ASSIGNING FIELD-SYMBOL(<fs_mapped_part>) BINARY SEARCH.
        IF sy-subrc = 0 AND <fs_mapped_part> IS ASSIGNED.
          <fs_mapped_part>-testid = <fs_mapped_part>-%tmp-testid.
          lv_part_id += 1.
          <fs_mapped_part>-partid = lv_part_id.
          UNASSIGN <fs_mapped_part>.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " Question

    DATA(lt_create_question) = mapped-question.
    DELETE lt_create_question WHERE questionid IS NOT INITIAL.

    IF lt_create_question IS NOT INITIAL.
      SORT lt_create_question BY %tmp-testid.

      LOOP AT lt_create_question ASSIGNING FIELD-SYMBOL(<fs_create_question>).
        AT NEW %tmp-testid.
          SELECT MAX( question_id ) FROM znept_qz_qst INTO @DATA(lv_question_id)
            WHERE test_id = @<fs_create_question>-%tmp-testid.
          IF sy-subrc <> 0.
            CLEAR lv_question_id.
          ENDIF.
        ENDAT.

        READ TABLE mapped-question WITH KEY %pid = <fs_create_question>-%pid ASSIGNING FIELD-SYMBOL(<fs_mapped_question>) BINARY SEARCH.
        IF sy-subrc = 0 AND <fs_mapped_question> IS ASSIGNED.
          <fs_mapped_question>-testid = <fs_mapped_question>-%tmp-testid.
          lv_question_id += 1.
          <fs_mapped_question>-questionid = lv_question_id.
          UNASSIGN <fs_mapped_question>.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " Variant

    DATA(lt_create_variant) = mapped-variant.
    DELETE lt_create_variant WHERE variantid IS NOT INITIAL.

    IF lt_create_variant IS NOT INITIAL.
      SORT lt_create_variant BY %tmp-testid %tmp-questionid.

      LOOP AT lt_create_variant ASSIGNING FIELD-SYMBOL(<fs_create_variant>).
        AT NEW %tmp-questionid.
          SELECT MAX( variant_id ) FROM znept_qz_var INTO @DATA(lv_variant_id)
            WHERE test_id = @<fs_create_variant>-%tmp-testid
              AND question_id = @<fs_create_variant>-%tmp-questionid.
          IF sy-subrc <> 0.
            CLEAR lv_variant_id.
          ENDIF.
        ENDAT.

        READ TABLE mapped-variant WITH KEY %pid = <fs_create_variant>-%pid ASSIGNING FIELD-SYMBOL(<fs_mapped_variant>) BINARY SEARCH.
        IF sy-subrc = 0 AND <fs_mapped_variant> IS ASSIGNED.
          <fs_mapped_variant>-testid = <fs_mapped_variant>-%tmp-testid.
          <fs_mapped_variant>-questionid = <fs_mapped_variant>-%tmp-questionid.
          lv_variant_id += 1.
          <fs_mapped_variant>-variantid = lv_variant_id.
          UNASSIGN <fs_mapped_variant>.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

**********************************************************************
* save external data
**********************************************************************
  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
