CLASS lhc_question DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    TYPES tt_question_keys TYPE TABLE FOR KEY OF znept_qz_i_quiz_m\\question.

    METHODS setversion FOR DETERMINE ON SAVE
      IMPORTING keys FOR question~setversion.

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

      LOOP AT lt_question INTO DATA(ls_question) WHERE %tky-testid = ls_quis-%tky-testid.

        MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
          ENTITY question
            UPDATE FIELDS ( version )
              WITH VALUE #( ( %tky = ls_question-%tky version = lv_version ) ).

      ENDLOOP.

      MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
        ENTITY quiz
          UPDATE FIELDS ( version )
            WITH VALUE #( ( %tky = ls_quis-%tky version = lv_version ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
      ENTITY question
        FIELDS ( partid sort )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_question).

    LOOP AT lt_question ASSIGNING FIELD-SYMBOL(<fs_question>).

      AT NEW partid.
        SELECT MIN( sort ) AS sort_top, MAX( sort ) AS sort_bottom
          INTO @DATA(ls_sort) FROM znept_qz_i_question_m
          WHERE testid = @<fs_question>-testid
            AND partid = @<fs_question>-partid.
      ENDAT.

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result> IS ASSIGNED.
        <fs_result>-%tky = <fs_question>-%tky.

        <fs_result>-%features-%action-movequestionup = COND #( WHEN <fs_question>-sort = ls_sort-sort_top
                                                               THEN if_abap_behv=>fc-o-disabled
                                                               ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movequestiondown = COND #( WHEN <fs_question>-sort = ls_sort-sort_bottom
                                                                 THEN if_abap_behv=>fc-o-disabled
                                                                 ELSE if_abap_behv=>fc-o-enabled ).

        <fs_result>-%features-%action-movequestionfirst = <fs_result>-%features-%action-movequestionup.
        <fs_result>-%features-%action-movequestionlast = <fs_result>-%features-%action-movequestiondown.
      ENDIF.
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

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD movequestion.
    DATA lt_question_update TYPE TABLE FOR UPDATE znept_qz_i_quiz_m\\question.

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

              CLEAR lt_question_update.

              DATA(lv_sort_a) = ls_question_a-sort.
              DATA(lv_sort_b) = ls_question_b-sort.

              IF lv_sort_a = ls_question_b-questionid.
                CLEAR lv_sort_a.
              ENDIF.

              IF lv_sort_b = ls_question_a-questionid.
                CLEAR lv_sort_b.
              ENDIF.

              APPEND VALUE #( testid = ls_question_a-testid questionid = ls_question_a-questionid sort = lv_sort_b ) TO lt_question_update.
              APPEND VALUE #( testid = ls_question_b-testid questionid = ls_question_b-questionid sort = lv_sort_a ) TO lt_question_update.

              MODIFY ENTITIES OF znept_qz_i_quiz_m IN LOCAL MODE
                ENTITY question
                  UPDATE FIELDS ( sort )
                  WITH lt_question_update.

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
