CLASS lhc_question DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    TYPES tt_question_keys TYPE TABLE FOR KEY OF znept_qz_i_quiz_m\\question.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR question RESULT result.

    METHODS movequestiondown FOR MODIFY
      IMPORTING keys FOR ACTION question~movequestiondown.

    METHODS movequestionfirst FOR MODIFY
      IMPORTING keys FOR ACTION question~movequestionfirst.

    METHODS movequestionlast FOR MODIFY
      IMPORTING keys FOR ACTION question~movequestionlast.

    METHODS movequestionup FOR MODIFY
      IMPORTING keys FOR ACTION question~movequestionup.

    METHODS assignpart FOR MODIFY
      IMPORTING keys FOR ACTION question~assignpart.

    METHODS refreshquestion FOR MODIFY
      IMPORTING keys FOR ACTION question~refreshquestion.

    METHODS setversion FOR DETERMINE ON SAVE
      IMPORTING keys FOR question~setversion.

    METHODS setsort FOR DETERMINE ON SAVE
      IMPORTING keys FOR question~setsort.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR question RESULT result.

    METHODS movequestion
      IMPORTING
        it_keys   TYPE tt_question_keys
        iv_down   TYPE abap_bool
        iv_bottom TYPE abap_bool.

ENDCLASS.

CLASS lhc_question IMPLEMENTATION.

  METHOD setversion.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY question
        FIELDS ( version )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_question).

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        FIELDS ( version )
          WITH VALUE #( FOR question IN lt_question ( %key = question-%key-testid ) )
        RESULT DATA(lt_quiz).

    LOOP AT lt_quiz ASSIGNING FIELD-SYMBOL(<fs_quiz>).
      <fs_quiz>-version += 1.
      LOOP AT lt_question ASSIGNING FIELD-SYMBOL(<fs_question>) WHERE %key-testid = <fs_quiz>-%key-testid.
        <fs_question>-version = <fs_quiz>-version.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        UPDATE FIELDS ( version )
          WITH VALUE #( FOR quiz IN lt_quiz ( %tky = quiz-%tky version = quiz-version ) )
      ENTITY question
        UPDATE FIELDS ( version )
          WITH VALUE #( FOR question IN lt_question ( %tky = question-%tky version = question-version ) ).

  ENDMETHOD.

  METHOD get_instance_features.

    TYPES: BEGIN OF tt_question_sort,
             testid      TYPE znept_qz_test_id_de,
             partid      TYPE znept_qz_part_id_de,
             sort_top    TYPE znept_qz_question_ord_de,
             sort_bottom TYPE znept_qz_question_ord_de,
           END OF tt_question_sort.

    DATA lt_question_sort TYPE TABLE OF tt_question_sort.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY question
        FIELDS ( partid sort )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_question).

    LOOP AT lt_question ASSIGNING FIELD-SYMBOL(<fs_question>).

      READ TABLE lt_question_sort WITH KEY testid = <fs_question>-testid partid = <fs_question>-partid
        ASSIGNING FIELD-SYMBOL(<fs_question_sort>).
      IF sy-subrc <> 0 OR <fs_question_sort> IS NOT ASSIGNED.
        APPEND INITIAL LINE TO lt_question_sort ASSIGNING <fs_question_sort>.
        IF <fs_question_sort> IS ASSIGNED.
          MOVE-CORRESPONDING <fs_question> TO <fs_question_sort>.
          SELECT MIN( sort ) AS sort_top, MAX( sort ) AS sort_bottom
            INTO ( @<fs_question_sort>-sort_top, @<fs_question_sort>-sort_bottom )
            FROM znept_qz_i_question_m
            WHERE testid = @<fs_question>-testid
              AND partid = @<fs_question>-partid.
        ENDIF.
      ENDIF.

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result> IS ASSIGNED.
        <fs_result>-%tky = <fs_question>-%tky.

        <fs_result>-%features-%action-movequestionup = COND #( WHEN <fs_question>-sort = <fs_question_sort>-sort_top
                                                               THEN if_abap_behv=>fc-o-disabled
                                                               ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movequestiondown = COND #( WHEN <fs_question>-sort = <fs_question_sort>-sort_bottom
                                                                 THEN if_abap_behv=>fc-o-disabled
                                                                 ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movequestionfirst = <fs_result>-%features-%action-movequestionup.
        <fs_result>-%features-%action-movequestionlast = <fs_result>-%features-%action-movequestiondown.
      ENDIF.

      UNASSIGN: <fs_question_sort>, <fs_result>.
    ENDLOOP.

  ENDMETHOD.

  METHOD movequestiondown.

    movequestion( EXPORTING it_keys   = CORRESPONDING tt_question_keys( keys )
                            iv_down   = abap_true
                            iv_bottom = abap_false ).
  ENDMETHOD.

  METHOD movequestionfirst.

    movequestion( EXPORTING it_keys   = CORRESPONDING tt_question_keys( keys )
                            iv_down   = abap_false
                            iv_bottom = abap_true ).
  ENDMETHOD.

  METHOD movequestionlast.

    movequestion( EXPORTING it_keys   = CORRESPONDING tt_question_keys( keys )
                            iv_down   = abap_true
                            iv_bottom = abap_true ).
  ENDMETHOD.

  METHOD movequestionup.

    movequestion( EXPORTING it_keys   = CORRESPONDING tt_question_keys( keys )
                            iv_down   = abap_false
                            iv_bottom = abap_false ).
  ENDMETHOD.

  METHOD movequestion.

    LOOP AT it_keys INTO DATA(ls_keys).

      SELECT * FROM znept_qz_i_question_m INTO TABLE @DATA(lt_question_all)
        WHERE testid = @ls_keys-testid.

      IF sy-subrc = 0.
        READ TABLE lt_question_all WITH KEY questionid = ls_keys-questionid INTO DATA(ls_question_a).
        IF sy-subrc = 0.

          DELETE lt_question_all WHERE partid <> ls_question_a-partid.

          IF iv_down = abap_true.
            IF iv_bottom = abap_true.
              SORT lt_question_all BY sort DESCENDING.
            ELSE.
              SORT lt_question_all BY sort ASCENDING.
              DELETE lt_question_all WHERE sort <= ls_question_a-sort.
            ENDIF.
          ELSE.
            IF iv_bottom = abap_true.
              SORT lt_question_all BY sort ASCENDING.
            ELSE.
              SORT lt_question_all BY sort DESCENDING.
              DELETE lt_question_all WHERE sort >= ls_question_a-sort.
            ENDIF.
          ENDIF.

          IF NOT lt_question_all[] IS INITIAL.
            READ TABLE lt_question_all INDEX 1 INTO DATA(ls_question_b).
            IF sy-subrc = 0 AND ls_question_b-questionid <> ls_question_a-questionid.

              MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
                ENTITY question
                  UPDATE FIELDS ( sort )
                    WITH VALUE #( ( testid     = ls_question_a-testid
                                    questionid = ls_question_a-questionid
                                    sort       = ls_question_b-sort )
                                  ( testid     = ls_question_b-testid
                                    questionid = ls_question_b-questionid
                                    sort       = ls_question_a-sort ) ).
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD assignpart.

    MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY question
        UPDATE FIELDS ( partid )
          WITH VALUE #( FOR ls_keys IN keys ( %key     = ls_keys-%key
                                              partid   = ls_keys-%param-new_part_id ) ).
  ENDMETHOD.

  METHOD refreshquestion.

    TYPES: BEGIN OF tt_question_id,
             testid     TYPE znept_qz_test_id_de,
             questionid TYPE znept_qz_variant_id_de,
           END OF tt_question_id.

    DATA lt_question_id TYPE TABLE OF tt_question_id. " to keep predictive Question ID

    DATA lt_question_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\_question.
    DATA lt_variant_create TYPE TABLE FOR CREATE znept_qz_i_quiz_m\\question\_variant.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY question
        ALL FIELDS
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_question_copy)
      ENTITY question BY \_variant
        ALL FIELDS
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_variant_copy).

    SORT lt_question_copy BY %key-testid.
    LOOP AT lt_question_copy INTO DATA(ls_question_copy).

      READ TABLE lt_question_id WITH KEY testid = ls_question_copy-%key-testid
        ASSIGNING FIELD-SYMBOL(<fs_question_id>).
      IF sy-subrc <> 0 OR <fs_question_id> IS NOT ASSIGNED.
        APPEND INITIAL LINE TO lt_question_id ASSIGNING <fs_question_id>.
        IF <fs_question_id> IS ASSIGNED.
          MOVE-CORRESPONDING ls_question_copy-%key TO <fs_question_id>.

          SELECT MAX( question_id ) FROM znept_qz_qst INTO @<fs_question_id>-questionid
            WHERE test_id = @<fs_question_id>-testid.
          IF sy-subrc <> 0.
            CLEAR <fs_question_id>-questionid.
          ENDIF.
        ENDIF.
      ENDIF.
      <fs_question_id>-questionid += 1.

      APPEND INITIAL LINE TO lt_question_create ASSIGNING FIELD-SYMBOL(<fs_question_create>).
      <fs_question_create>-%key-testid = ls_question_copy-%key-testid.

      APPEND INITIAL LINE TO <fs_question_create>-%target ASSIGNING FIELD-SYMBOL(<fs_question_target>).
      <fs_question_target>-%cid = 'Q_' && <fs_question_id>-questionid.

      MOVE-CORRESPONDING ls_question_copy-%data TO <fs_question_target>-%data.

* << to pass further question_id to -> adjust_numbers
      <fs_question_target>-%data-questionid = <fs_question_id>-questionid.
      <fs_question_target>-%control-questionid  = if_abap_behv=>mk-on.
* >>

      <fs_question_target>-%control-sort        = if_abap_behv=>mk-on.
      <fs_question_target>-%control-partid      = if_abap_behv=>mk-on.
      <fs_question_target>-%control-question    = if_abap_behv=>mk-on.
      <fs_question_target>-%control-explanation = if_abap_behv=>mk-on.

      APPEND INITIAL LINE TO lt_variant_create ASSIGNING FIELD-SYMBOL(<fs_variant_create>).
      <fs_variant_create>-%key-testid     = <fs_question_create>-%key-testid.
      <fs_variant_create>-%key-questionid = <fs_question_id>-questionid.
      <fs_variant_create>-%cid_ref        = <fs_question_target>-%cid.

      LOOP AT lt_variant_copy INTO DATA(ls_variant_copy).
        APPEND INITIAL LINE TO <fs_variant_create>-%target ASSIGNING FIELD-SYMBOL(<fs_variant_target>).
        <fs_variant_target>-%cid = 'V_' && ls_variant_copy-%key-variantid.

        MOVE-CORRESPONDING ls_variant_copy-%data TO <fs_variant_target>-%data.
        <fs_variant_target>-%control-sort    = if_abap_behv=>mk-on.
        <fs_variant_target>-%control-correct = if_abap_behv=>mk-on.
        <fs_variant_target>-%control-variant = if_abap_behv=>mk-on.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        CREATE BY \_question
          FROM lt_question_create
      ENTITY question
        CREATE BY \_variant
          FROM lt_variant_create
      ENTITY question
        DELETE FROM
          VALUE #( FOR question IN lt_question_copy ( %tky = question-%tky ) ).

  ENDMETHOD.

  METHOD setsort.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY question
        FIELDS ( sort )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_question).

    LOOP AT lt_question INTO DATA(ls_question) WHERE sort IS NOT INITIAL.
      IF ls_question-sort = ls_question-questionid.
        MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
          ENTITY question
            UPDATE FIELDS ( sort )
              WITH VALUE #( ( %key = ls_question-%key ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
