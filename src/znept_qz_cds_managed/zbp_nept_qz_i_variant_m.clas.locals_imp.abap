CLASS lhc_variant DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    TYPES tt_variant_keys TYPE TABLE FOR KEY OF znept_qz_i_quiz_m\\variant.

    METHODS setversion FOR DETERMINE ON SAVE
      IMPORTING keys FOR variant~setversion.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR variant RESULT result.

    METHODS movevariantdown FOR MODIFY
      IMPORTING keys FOR ACTION variant~movevariantdown.

    METHODS movevariantfirst FOR MODIFY
      IMPORTING keys FOR ACTION variant~movevariantfirst.

    METHODS movevariantlast FOR MODIFY
      IMPORTING keys FOR ACTION variant~movevariantlast.

    METHODS movevariantup FOR MODIFY
      IMPORTING keys FOR ACTION variant~movevariantup.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR variant RESULT result.
    METHODS setsort FOR DETERMINE ON SAVE
      IMPORTING keys FOR variant~setsort.

    METHODS movevariant
      IMPORTING
        it_keys   TYPE tt_variant_keys
        iv_down   TYPE abap_bool
        iv_bottom TYPE abap_bool.

ENDCLASS.

CLASS lhc_variant IMPLEMENTATION.

  METHOD setversion.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY variant
        FIELDS ( version )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_variant).

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        FIELDS ( version )
          WITH VALUE #( FOR variant IN lt_variant ( %key = variant-%key-testid ) )
        RESULT DATA(lt_quiz).

    LOOP AT lt_quiz ASSIGNING FIELD-SYMBOL(<fs_quiz>).
      <fs_quiz>-version += 1.
      LOOP AT lt_variant ASSIGNING FIELD-SYMBOL(<fs_variant>) WHERE %key-testid = <fs_quiz>-%key-testid.
        <fs_variant>-version = <fs_quiz>-version.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        UPDATE FIELDS ( version )
          WITH VALUE #( FOR quiz IN lt_quiz ( %tky = quiz-%tky version = quiz-version ) )
      ENTITY variant
        UPDATE FIELDS ( version )
          WITH VALUE #( FOR variant IN lt_variant ( %tky = variant-%tky version = variant-version ) ).

  ENDMETHOD.

  METHOD get_instance_features.

    TYPES: BEGIN OF tt_variant_sort,
             testid      TYPE znept_qz_test_id_de,
             questionid  TYPE znept_qz_question_id_de,
             sort_top    TYPE znept_qz_variant_ord_de,
             sort_bottom TYPE znept_qz_variant_ord_de,
           END OF tt_variant_sort.

    DATA lt_variant_sort TYPE TABLE OF tt_variant_sort.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY variant
        FIELDS ( sort )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_variant).

    LOOP AT lt_variant ASSIGNING FIELD-SYMBOL(<fs_variant>).

      READ TABLE lt_variant_sort WITH KEY testid     = <fs_variant>-testid
                                          questionid = <fs_variant>-questionid ASSIGNING FIELD-SYMBOL(<fs_variant_sort>).
      IF sy-subrc <> 0 OR <fs_variant_sort> IS NOT ASSIGNED.
        APPEND INITIAL LINE TO lt_variant_sort ASSIGNING <fs_variant_sort>.
        IF <fs_variant_sort> IS ASSIGNED.
          MOVE-CORRESPONDING <fs_variant> TO <fs_variant_sort>.
          SELECT MIN( sort ) AS sort_top, MAX( sort ) AS sort_bottom
            INTO ( @<fs_variant_sort>-sort_top, @<fs_variant_sort>-sort_bottom )
            FROM znept_qz_i_variant_m
            WHERE testid     = @<fs_variant>-testid
              AND questionid = @<fs_variant>-questionid.
        ENDIF.
      ENDIF.

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result> IS ASSIGNED.
        <fs_result>-%tky = <fs_variant>-%tky.

        <fs_result>-%features-%action-movevariantup = COND #( WHEN <fs_variant>-sort = <fs_variant_sort>-sort_top
                                                              THEN if_abap_behv=>fc-o-disabled
                                                              ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movevariantdown = COND #( WHEN <fs_variant>-sort = <fs_variant_sort>-sort_bottom
                                                                THEN if_abap_behv=>fc-o-disabled
                                                                ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movevariantfirst = <fs_result>-%features-%action-movevariantup.
        <fs_result>-%features-%action-movevariantlast = <fs_result>-%features-%action-movevariantdown.
      ENDIF.

      UNASSIGN: <fs_variant_sort>, <fs_result>.
    ENDLOOP.

  ENDMETHOD.

  METHOD movevariantdown.

    movevariant( EXPORTING it_keys   = CORRESPONDING tt_variant_keys( keys )
                           iv_down   = abap_true
                           iv_bottom = abap_false ).
  ENDMETHOD.

  METHOD movevariantfirst.

    movevariant( EXPORTING it_keys   = CORRESPONDING tt_variant_keys( keys )
                           iv_down   = abap_false
                           iv_bottom = abap_true ).
  ENDMETHOD.

  METHOD movevariantlast.

    movevariant( EXPORTING it_keys   = CORRESPONDING tt_variant_keys( keys )
                           iv_down   = abap_true
                           iv_bottom = abap_true ).
  ENDMETHOD.

  METHOD movevariantup.

    movevariant( EXPORTING it_keys   = CORRESPONDING tt_variant_keys( keys )
                           iv_down   = abap_false
                           iv_bottom = abap_false ).
  ENDMETHOD.

  METHOD movevariant.

    LOOP AT it_keys INTO DATA(ls_keys).

      SELECT * FROM znept_qz_i_variant_m INTO TABLE @DATA(lt_variant_all)
        WHERE testid     = @ls_keys-testid
          AND questionid = @ls_keys-questionid.

      IF sy-subrc = 0.
        READ TABLE lt_variant_all WITH KEY testid     = ls_keys-testid
                                           questionid = ls_keys-questionid
                                           variantid  = ls_keys-variantid INTO DATA(ls_variant_a).
        IF sy-subrc = 0.

          IF iv_down = abap_true.
            IF iv_bottom = abap_true.
              SORT lt_variant_all BY sort DESCENDING.
            ELSE.
              SORT lt_variant_all BY sort ASCENDING.
              DELETE lt_variant_all WHERE sort <= ls_variant_a-sort.
            ENDIF.
          ELSE.
            IF iv_bottom = abap_true.
              SORT lt_variant_all BY sort ASCENDING.
            ELSE.
              SORT lt_variant_all BY sort DESCENDING.
              DELETE lt_variant_all WHERE sort >= ls_variant_a-sort.
            ENDIF.
          ENDIF.

          IF NOT lt_variant_all[] IS INITIAL.
            READ TABLE lt_variant_all INDEX 1 INTO DATA(ls_variant_b).
            IF sy-subrc = 0 AND ls_variant_b-variantid <> ls_variant_a-variantid.

              MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
                ENTITY variant
                  UPDATE FIELDS ( sort )
                    WITH VALUE #( ( testid     = ls_variant_a-testid
                                    questionid = ls_variant_a-questionid
                                    variantid  = ls_variant_a-variantid
                                    sort       = ls_variant_b-sort )
                                  ( testid     = ls_variant_b-testid
                                    questionid = ls_variant_b-questionid
                                    variantid  = ls_variant_b-variantid
                                    sort       = ls_variant_a-sort ) ).
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD setsort.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY variant
        FIELDS ( sort )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_variant).

    LOOP AT lt_variant INTO DATA(ls_variant) WHERE sort IS NOT INITIAL.
      IF ls_variant-sort = ls_variant-variantid.
        MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
          ENTITY variant
            UPDATE FIELDS ( sort )
              WITH VALUE #( ( %key = ls_variant-%key ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
