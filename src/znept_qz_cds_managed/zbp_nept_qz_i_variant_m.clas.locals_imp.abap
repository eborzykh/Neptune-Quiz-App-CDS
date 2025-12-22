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

    DATA(lt_keys) = keys.
    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      CLEAR <fs_keys>-%pid.
    ENDLOOP.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        FIELDS ( version )
          WITH CORRESPONDING #( lt_keys )
        RESULT DATA(lt_quiz)
      ENTITY question
        FIELDS ( version )
          WITH CORRESPONDING #( lt_keys )
        RESULT DATA(lt_question).

    LOOP AT lt_quiz INTO DATA(ls_quis).
      DATA(lv_version) = ls_quis-version + 1.

      LOOP AT lt_question INTO DATA(ls_question) WHERE %tky-testid = ls_quis-%tky-testid.
        LOOP AT lt_variant INTO DATA(ls_variant) WHERE %tky-testid     = ls_question-%tky-testid
                                                   AND %tky-questionid = ls_question-%tky-questionid.

          MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
            ENTITY variant
              UPDATE FIELDS ( version )
                WITH VALUE #( ( %tky = ls_variant-%tky version = lv_version ) ).

        ENDLOOP.
      ENDLOOP.

      MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
        ENTITY quiz
          UPDATE FIELDS ( version )
            WITH VALUE #( ( %tky = ls_quis-%tky version = lv_version ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY variant
        FIELDS ( sort )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_variant).

    LOOP AT lt_variant ASSIGNING FIELD-SYMBOL(<fs_variant>).

      AT FIRST.
        SELECT MIN( sort ) AS sort_top, MAX( sort ) AS sort_bottom
          INTO @DATA(ls_sort) FROM znept_qz_i_variant_m
          WHERE testid     = @<fs_variant>-testid
            AND questionid = @<fs_variant>-questionid.
      ENDAT.

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result> IS ASSIGNED.
        <fs_result>-%tky = <fs_variant>-%tky.

        <fs_result>-%features-%action-movevariantup = COND #( WHEN <fs_variant>-sort = ls_sort-sort_top
                                                              THEN if_abap_behv=>fc-o-disabled
                                                              ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movevariantdown = COND #( WHEN <fs_variant>-sort = ls_sort-sort_bottom
                                                                THEN if_abap_behv=>fc-o-disabled
                                                                ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movevariantfirst = <fs_result>-%features-%action-movevariantup.
        <fs_result>-%features-%action-movevariantlast = <fs_result>-%features-%action-movevariantdown.
      ENDIF.
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

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD movevariant.
    DATA lt_variant_update TYPE TABLE FOR UPDATE znept_qz_i_quiz_m\\variant.

    LOOP AT it_keys INTO DATA(ls_keys).

      SELECT * FROM znept_qz_i_variant_m INTO TABLE @DATA(lt_variant_all)
        WHERE testid     = @ls_keys-testid
          AND questionid = @ls_keys-questionid.

      IF sy-subrc = 0.
        READ TABLE lt_variant_all WITH KEY variant = ls_keys-variantid INTO DATA(ls_variant_a).
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

              CLEAR lt_variant_update.

              DATA(lv_sort_a) = ls_variant_a-sort.
              DATA(lv_sort_b) = ls_variant_b-sort.

              IF lv_sort_a = ls_variant_b-variantid.
                CLEAR lv_sort_a.
              ENDIF.

              IF lv_sort_b = ls_variant_a-variantid.
                CLEAR lv_sort_b.
              ENDIF.

              APPEND VALUE #( testid = ls_variant_a-testid variantid = ls_variant_a-variantid sort = lv_sort_b ) TO lt_variant_update.
              APPEND VALUE #( testid = ls_variant_b-testid variantid = ls_variant_b-variantid sort = lv_sort_a ) TO lt_variant_update.

              MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
                ENTITY variant
                  UPDATE FIELDS ( sort )
                  WITH lt_variant_update.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
