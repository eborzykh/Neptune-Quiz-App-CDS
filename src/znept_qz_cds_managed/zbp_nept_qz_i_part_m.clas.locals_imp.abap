*
CLASS lhc_part DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    TYPES tt_part_keys TYPE TABLE FOR KEY OF znept_qz_i_quiz_m\\part.

    METHODS setversion FOR DETERMINE ON SAVE
      IMPORTING keys FOR part~setversion.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR part RESULT result.

    METHODS movepartdown FOR MODIFY
      IMPORTING keys FOR ACTION part~movepartdown.

    METHODS movepartfirst FOR MODIFY
      IMPORTING keys FOR ACTION part~movepartfirst.

    METHODS movepartlast FOR MODIFY
      IMPORTING keys FOR ACTION part~movepartlast.

    METHODS movepartup FOR MODIFY
      IMPORTING keys FOR ACTION part~movepartup.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR part RESULT result.

    METHODS movepart
      IMPORTING
        it_keys   TYPE tt_part_keys
        iv_down   TYPE abap_bool
        iv_bottom TYPE abap_bool.

ENDCLASS.

CLASS lhc_part IMPLEMENTATION.

  METHOD setversion.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY part
        FIELDS ( version )
          WITH CORRESPONDING #( keys )
     RESULT DATA(lt_part).

    DATA(lt_keys) = keys.
    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      CLEAR <fs_keys>-%pid.
    ENDLOOP.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY quiz
        FIELDS ( version )
          WITH CORRESPONDING #( lt_keys )
        RESULT DATA(lt_quiz).

    LOOP AT lt_quiz INTO DATA(ls_quis).
      DATA(lv_version) = ls_quis-version + 1.

      LOOP AT lt_part INTO DATA(ls_part) WHERE %tky-testid = ls_quis-%tky-testid.

        MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
          ENTITY part
            UPDATE FIELDS ( version )
              WITH VALUE #( ( %tky = ls_part-%tky version = lv_version ) ).

      ENDLOOP.

      MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
        ENTITY quiz
          UPDATE FIELDS ( version )
            WITH VALUE #( ( %tky = ls_quis-%tky version = lv_version ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY part
        FIELDS ( sort )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_part).

    LOOP AT lt_part ASSIGNING FIELD-SYMBOL(<fs_part>).
      AT FIRST.
        SELECT MIN( sort ) AS sort_top, MAX( sort ) AS sort_bottom
          INTO @DATA(ls_sort) FROM znept_qz_i_part_m
          WHERE testid = @<fs_part>-testid.
      ENDAT.

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result> IS ASSIGNED.
        <fs_result>-%tky = <fs_part>-%tky.

        <fs_result>-%features-%action-movepartup = COND #( WHEN <fs_part>-sort = ls_sort-sort_top
                                                           THEN if_abap_behv=>fc-o-disabled
                                                           ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movepartdown = COND #( WHEN <fs_part>-sort = ls_sort-sort_bottom
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movepartfirst = <fs_result>-%features-%action-movepartup.
        <fs_result>-%features-%action-movepartlast = <fs_result>-%features-%action-movepartdown.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD movepartdown.
    movepart( EXPORTING it_keys   = CORRESPONDING tt_part_keys( keys )
                        iv_down   = abap_true
                        iv_bottom = abap_false ).
  ENDMETHOD.

  METHOD movepartfirst.
    movepart( EXPORTING it_keys   = CORRESPONDING tt_part_keys( keys )
                        iv_down   = abap_false
                        iv_bottom = abap_true ).
  ENDMETHOD.

  METHOD movepartlast.
    movepart( EXPORTING it_keys   = CORRESPONDING tt_part_keys( keys )
                        iv_down   = abap_true
                        iv_bottom = abap_true ).
  ENDMETHOD.

  METHOD movepartup.
    movepart( EXPORTING it_keys   = CORRESPONDING tt_part_keys( keys )
                        iv_down   = abap_false
                        iv_bottom = abap_false ).
  ENDMETHOD.

  METHOD movepart.
    DATA lt_part_update TYPE TABLE FOR UPDATE znept_qz_i_quiz_m\\part.

    LOOP AT it_keys INTO DATA(ls_keys).

      SELECT * FROM znept_qz_i_part_m INTO TABLE @DATA(lt_part_all)
        WHERE testid = @ls_keys-testid.

      IF sy-subrc = 0.
        READ TABLE lt_part_all WITH KEY partid = ls_keys-partid INTO DATA(ls_part_a).
        IF sy-subrc = 0.

          IF iv_down = abap_true.
            IF iv_bottom = abap_true.
              SORT lt_part_all BY sort DESCENDING.
            ELSE.
              SORT lt_part_all BY sort ASCENDING.
              DELETE lt_part_all WHERE sort <= ls_part_a-sort.
            ENDIF.
          ELSE.
            IF iv_bottom = abap_true.
              SORT lt_part_all BY sort ASCENDING.
            ELSE.
              SORT lt_part_all BY sort DESCENDING.
              DELETE lt_part_all WHERE sort >= ls_part_a-sort.
            ENDIF.
          ENDIF.

          IF NOT lt_part_all[] IS INITIAL.
            READ TABLE lt_part_all INDEX 1 INTO DATA(ls_part_b).
            IF sy-subrc = 0 AND ls_part_b-partid <> ls_part_a-partid.

              CLEAR lt_part_update.

              DATA(lv_sort_a) = ls_part_a-sort.
              DATA(lv_sort_b) = ls_part_b-sort.

              IF lv_sort_a = ls_part_b-partid.
                CLEAR lv_sort_a.
              ENDIF.

              IF lv_sort_b = ls_part_a-partid.
                CLEAR lv_sort_b.
              ENDIF.

              APPEND VALUE #( testid = ls_part_a-testid partid = ls_part_a-partid sort = lv_sort_b ) TO lt_part_update.
              APPEND VALUE #( testid = ls_part_b-testid partid = ls_part_b-partid sort = lv_sort_a ) TO lt_part_update.

              MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
                ENTITY part
                  UPDATE FIELDS ( sort )
                  WITH lt_part_update.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
