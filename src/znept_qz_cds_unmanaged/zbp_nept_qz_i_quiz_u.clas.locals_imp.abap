CLASS lhc_quiz DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES tt_quiz_failed    TYPE TABLE FOR FAILED   znept_qz_i_quiz_u.
    TYPES tt_quiz_reported  TYPE TABLE FOR REPORTED znept_qz_i_quiz_u.

    TYPES tt_part_failed    TYPE TABLE FOR FAILED   znept_qz_i_part_u.
    TYPES tt_part_reported  TYPE TABLE FOR REPORTED znept_qz_i_part_u.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR quiz RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE quiz.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE quiz.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE quiz.

    METHODS read FOR READ
      IMPORTING keys FOR READ quiz RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK quiz.

    METHODS rba_part FOR READ
      IMPORTING keys_rba FOR READ quiz\_part FULL result_requested RESULT result LINK association_links.

    METHODS rba_question FOR READ
      IMPORTING keys_rba FOR READ quiz\_question FULL result_requested RESULT result LINK association_links.

    METHODS cba_question FOR MODIFY
      IMPORTING entities_cba FOR CREATE quiz\_question.

    METHODS publish FOR MODIFY
      IMPORTING keys FOR ACTION quiz~publish.

    METHODS unpublish FOR MODIFY
      IMPORTING keys FOR ACTION quiz~unpublish.

    METHODS cba_part FOR MODIFY
      IMPORTING entities_cba FOR CREATE quiz\_part.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR quiz RESULT result.

    METHODS map_messages
      IMPORTING
        iv_cid          TYPE string         OPTIONAL
        iv_quiz_id      TYPE znept_qz_test_id_de OPTIONAL
        it_messages     TYPE symsg_tab
      EXPORTING
        ev_failed_added TYPE abap_bool
      CHANGING
        ct_failed       TYPE tt_quiz_failed
        ct_reported     TYPE tt_quiz_reported.

ENDCLASS.

CLASS lhc_quiz IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

**********************************************************************
*
* Create Quiz instances
*
**********************************************************************
  METHOD create.

    DATA: ls_db_quiz_in   TYPE znept_qz_db_tests_s,
          ls_db_quiz_out  TYPE znept_qz_db_tests_s,
          lt_messages     TYPE symsg_tab,
          lv_failed_added TYPE abap_bool.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_quiz_entities>).

      CLEAR ls_db_quiz_in.
      ls_db_quiz_in-description = <fs_quiz_entities>-description.

      CALL FUNCTION 'ZNEPT_QZ_QUIZ_CREATE'
        EXPORTING
          is_db_quiz  = ls_db_quiz_in
        IMPORTING
          es_db_quiz  = ls_db_quiz_out
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_quiz_entities>-%cid
            iv_quiz_id   = ls_db_quiz_out-test_id
            it_messages  = lt_messages
          IMPORTING
            ev_failed_added = lv_failed_added
          CHANGING
            ct_failed    = failed-quiz
            ct_reported  = reported-quiz ).

      IF lv_failed_added = abap_false.
        INSERT VALUE #( %cid     = <fs_quiz_entities>-%cid
                        testid   = ls_db_quiz_out-test_id )
          INTO TABLE mapped-quiz.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Update data of existing Quiz instances
*
**********************************************************************
  METHOD update.

    DATA: ls_db_quiz_in TYPE znept_qz_db_tests_s,
          lt_messages   TYPE symsg_tab.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_quiz_entities>).

      CLEAR ls_db_quiz_in.
      ls_db_quiz_in-test_id     = <fs_quiz_entities>-testid.

      " do not need to check for %control there is only one field to be updated
      ls_db_quiz_in-description = <fs_quiz_entities>-description.

      CALL FUNCTION 'ZNEPT_QZ_QUIZ_UPDATE'
        EXPORTING
          is_db_quiz  = ls_db_quiz_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_quiz_entities>-%cid_ref
            iv_quiz_id   = <fs_quiz_entities>-testid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-quiz
            ct_reported  = reported-quiz ).

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Delete of Quiz instances
*
**********************************************************************
  METHOD delete.

    DATA: ls_db_quiz_in TYPE znept_qz_db_tests_s,
          lt_messages   TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_quiz_keys>).

      CLEAR ls_db_quiz_in.
      ls_db_quiz_in-test_id = <fs_quiz_keys>-testid.

      CALL FUNCTION 'ZNEPT_QZ_QUIZ_DELETE'
        EXPORTING
          is_db_quiz  = ls_db_quiz_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_quiz_keys>-%cid_ref
            iv_quiz_id   = <fs_quiz_keys>-testid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-quiz
            ct_reported  = reported-quiz ).

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Read Quiz data
*
**********************************************************************
  METHOD read.

    DATA: ls_quiz_in      TYPE znept_qz_tst,
          ls_quiz_out     TYPE znept_qz_tst,
          lt_messages     TYPE symsg_tab,
          lv_failed_added TYPE abap_bool.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_quiz_to_read>)
      GROUP BY <fs_quiz_to_read>-%tky.

      CLEAR ls_quiz_in.
      ls_quiz_in-test_id = <fs_quiz_to_read>-testid.

      CALL FUNCTION 'ZNEPT_QZ_QUIZ_READ'
        EXPORTING
          is_db_quiz  = ls_quiz_in
        IMPORTING
          es_db_quiz  = ls_quiz_out
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_quiz_id   = <fs_quiz_to_read>-testid
            it_messages  = lt_messages
          IMPORTING
            ev_failed_added = lv_failed_added
          CHANGING
            ct_failed    = failed-quiz
            ct_reported  = reported-quiz ).

      IF lv_failed_added = abap_false.
        INSERT CORRESPONDING #( ls_quiz_out MAPPING TO ENTITY ) INTO TABLE result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_part.

  ENDMETHOD.

  METHOD rba_question.

  ENDMETHOD.

**********************************************************************
*
* Create new Question from the Quiz
*
**********************************************************************
  METHOD cba_question.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<fs_question_entities_cba>).
      LOOP AT <fs_question_entities_cba>-%target ASSIGNING FIELD-SYMBOL(<fs_target>).

        MODIFY ENTITIES OF znept_qz_c_quiz_u
          ENTITY question
            CREATE FIELDS ( question explanation )
            WITH VALUE #( ( %cid        = <fs_target>-%cid
                            testid      = <fs_question_entities_cba>-testid
                            partid      = <fs_target>-partid
                            question    = <fs_target>-question
                            explanation = <fs_target>-explanation ) )
         MAPPED   DATA(lt_mapped)
         FAILED   DATA(lt_failed)
         REPORTED DATA(lt_reported).

        MOVE-CORRESPONDING lt_mapped-question   TO mapped-question   KEEPING TARGET LINES.
        MOVE-CORRESPONDING lt_failed-question   TO failed-question   KEEPING TARGET LINES.
        MOVE-CORRESPONDING lt_reported-question TO reported-question KEEPING TARGET LINES.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Publish the Quiz
*
**********************************************************************
  METHOD publish.

    DATA: lt_messages     TYPE symsg_tab.

    READ TABLE keys INDEX 1 INTO DATA(ls_quiz_keys).
    IF sy-subrc = 0.
      DATA(ls_db_quiz_in) = VALUE znept_qz_db_tests_s( test_id   = ls_quiz_keys-testid
                                                       published = abap_true ).

      CALL FUNCTION 'ZNEPT_QZ_QUIZ_PUBLISH'
        EXPORTING
          is_db_quiz  = ls_db_quiz_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = ls_quiz_keys-%cid_ref
            iv_quiz_id   = ls_quiz_keys-testid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-quiz
            ct_reported  = reported-quiz ).
    ENDIF.

  ENDMETHOD.

**********************************************************************
*
* UnPublish the Quiz
*
**********************************************************************
  METHOD unpublish.

    DATA: lt_messages     TYPE symsg_tab.

    READ TABLE keys INDEX 1 INTO DATA(ls_quiz_keys).
    IF sy-subrc = 0.
      DATA(ls_db_quiz_in) = VALUE znept_qz_db_tests_s( test_id   = ls_quiz_keys-testid
                                                       published = abap_false ).

      CALL FUNCTION 'ZNEPT_QZ_QUIZ_PUBLISH'
        EXPORTING
          is_db_quiz  = ls_db_quiz_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = ls_quiz_keys-%cid_ref
            iv_quiz_id   = ls_quiz_keys-testid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-quiz
            ct_reported  = reported-quiz ).

    ENDIF.

  ENDMETHOD.

**********************************************************************
*
* Create new Part from the Quiz
*
**********************************************************************
  METHOD cba_part.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<fs_part_entities_cba>).
      LOOP AT <fs_part_entities_cba>-%target ASSIGNING FIELD-SYMBOL(<fs_target>).

        MODIFY ENTITIES OF znept_qz_c_quiz_u
          ENTITY part
            CREATE FIELDS ( description )
            WITH VALUE #( ( %cid        = <fs_target>-%cid
                            testid      = <fs_part_entities_cba>-testid
                            description = <fs_target>-description ) )
         MAPPED   DATA(lt_mapped)
         FAILED   DATA(lt_failed)
         REPORTED DATA(lt_reported).

        MOVE-CORRESPONDING lt_mapped-part   TO mapped-part   KEEPING TARGET LINES.
        MOVE-CORRESPONDING lt_failed-part   TO failed-part   KEEPING TARGET LINES.
        MOVE-CORRESPONDING lt_reported-part TO reported-part KEEPING TARGET LINES.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Map messages from legacy type to failed and reported for Quiz
*
**********************************************************************
  METHOD map_messages.

    ev_failed_added = abap_false.

    LOOP AT it_messages INTO DATA(ls_message).
      IF ls_message-msgty = 'E' OR ls_message-msgty = 'A'.
        APPEND VALUE #( %cid        = iv_cid
                        testid      = iv_quiz_id
                        %fail-cause = zcl_nept_qz_quiz_auxiliary=>get_cause_from_message(
                                        msgid = ls_message-msgid
                                        msgno = ls_message-msgno
                                      ) )
               TO ct_failed.
        ev_failed_added = abap_true.
      ENDIF.

      APPEND VALUE #( %msg          = new_message(
                                        id       = ls_message-msgid
                                        number   = ls_message-msgno
                                        severity = if_abap_behv_message=>severity-error
                                        v1       = ls_message-msgv1
                                        v2       = ls_message-msgv2
                                        v3       = ls_message-msgv3
                                        v4       = ls_message-msgv4 )
                      %cid        = iv_cid
                      testid      = iv_quiz_id )
             TO ct_reported.
    ENDLOOP.
  ENDMETHOD.

********************************************************************************
*
* Dynamic action handling for Quiz instances
*
********************************************************************************
  METHOD get_instance_features.

    READ ENTITIES OF znept_qz_i_quiz_u IN LOCAL MODE
      ENTITY quiz
        FIELDS ( published )
        WITH CORRESPONDING #( keys )
    RESULT DATA(lt_quiz_read_result).

    result = VALUE #(
      FOR ls_quiz_read_result IN lt_quiz_read_result (
        %tky                                = ls_quiz_read_result-%tky
        %features-%action-publish = COND #( WHEN ls_quiz_read_result-published = 'X'
                                                      THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
        %features-%action-unpublish = COND #( WHEN ls_quiz_read_result-published = ''
                                                      THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
      ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_part DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES tt_part_failed    TYPE TABLE FOR FAILED   znept_qz_i_part_u.
    TYPES tt_part_reported  TYPE TABLE FOR REPORTED znept_qz_i_part_u.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE part.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE part.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE part.

    METHODS read FOR READ
      IMPORTING keys FOR READ part RESULT result.

    METHODS rba_quiz FOR READ
      IMPORTING keys_rba FOR READ part\_quiz FULL result_requested RESULT result LINK association_links.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR part RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR part RESULT result.

    METHODS movepartdown FOR MODIFY
      IMPORTING keys FOR ACTION part~movepartdown.

    METHODS movepartfirst FOR MODIFY
      IMPORTING keys FOR ACTION part~movepartfirst.

    METHODS movepartlast FOR MODIFY
      IMPORTING keys FOR ACTION part~movepartlast.

    METHODS movepartup FOR MODIFY
      IMPORTING keys FOR ACTION part~movepartup.

    METHODS map_messages
      IMPORTING
        iv_cid          TYPE string         OPTIONAL
        iv_quiz_id      TYPE znept_qz_test_id_de OPTIONAL
        iv_part_id      TYPE znept_qz_part_id_de OPTIONAL
        it_messages     TYPE symsg_tab
      EXPORTING
        ev_failed_added TYPE abap_bool
      CHANGING
        ct_failed       TYPE tt_part_failed
        ct_reported     TYPE tt_part_reported.

ENDCLASS.

CLASS lhc_part IMPLEMENTATION.

**********************************************************************
*
* Update Part instances
*
**********************************************************************
  METHOD update.

    DATA: ls_db_part_in TYPE znept_qz_db_parts_s,
          lt_messages   TYPE symsg_tab.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_part_entities>).

      CLEAR ls_db_part_in.
      ls_db_part_in-test_id = <fs_part_entities>-testid.
      ls_db_part_in-part_id = <fs_part_entities>-partid.

      " do not need to check for %control there is only one field to be updated
      ls_db_part_in-description = <fs_part_entities>-description.

      CALL FUNCTION 'ZNEPT_QZ_PART_UPDATE'
        EXPORTING
          is_db_part  = ls_db_part_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_part_entities>-%cid_ref
            iv_quiz_id   = <fs_part_entities>-testid
            iv_part_id   = <fs_part_entities>-partid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-part
            ct_reported  = reported-part ).

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Delete Part instances
*
**********************************************************************
  METHOD delete.

    DATA: ls_db_part_in TYPE znept_qz_db_parts_s,
          lt_messages   TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_part_keys>).

      CLEAR ls_db_part_in.
      ls_db_part_in-test_id = <fs_part_keys>-testid.
      ls_db_part_in-part_id = <fs_part_keys>-partid.

      CALL FUNCTION 'ZNEPT_QZ_PART_DELETE'
        EXPORTING
          is_db_part  = ls_db_part_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_part_keys>-%cid_ref
            iv_quiz_id   = <fs_part_keys>-testid
            iv_part_id   = <fs_part_keys>-partid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-part
            ct_reported  = reported-part ).

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Read Part instances
*
**********************************************************************
  METHOD read.

    DATA: ls_part_in      TYPE znept_qz_prt,
          ls_part_out     TYPE znept_qz_prt,
          lt_messages     TYPE symsg_tab,
          lv_failed_added TYPE abap_bool.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_part_to_read>)
      GROUP BY <fs_part_to_read>-%tky.

      CLEAR ls_part_in.
      ls_part_in-test_id = <fs_part_to_read>-testid.
      ls_part_in-part_id = <fs_part_to_read>-partid.

      CALL FUNCTION 'ZNEPT_QZ_PART_READ'
        EXPORTING
          is_db_part  = ls_part_in
        IMPORTING
          es_db_part  = ls_part_out
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_quiz_id   = <fs_part_to_read>-testid
            iv_part_id   = <fs_part_to_read>-partid
            it_messages  = lt_messages
          IMPORTING
            ev_failed_added = lv_failed_added
          CHANGING
            ct_failed    = failed-part
            ct_reported  = reported-part ).

      IF lv_failed_added = abap_false.
        INSERT CORRESPONDING #( ls_part_out MAPPING TO ENTITY ) INTO TABLE result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD rba_quiz.

  ENDMETHOD.

**********************************************************************
*
* Create Part instances
*
**********************************************************************
  METHOD create.

    DATA: ls_db_part_in   TYPE znept_qz_db_parts_s,
          ls_db_part_out  TYPE znept_qz_db_parts_s,
          lt_messages     TYPE symsg_tab,
          lv_failed_added TYPE abap_bool.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_part_entities>).

      CLEAR ls_db_part_in.
      ls_db_part_in-test_id     = <fs_part_entities>-testid.
      ls_db_part_in-part_id     = <fs_part_entities>-partid.
      ls_db_part_in-description = <fs_part_entities>-description.

      CALL FUNCTION 'ZNEPT_QZ_PART_CREATE'
        EXPORTING
          is_db_part  = ls_db_part_in
        IMPORTING
          es_db_part  = ls_db_part_out
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_part_entities>-%cid
            iv_quiz_id   = <fs_part_entities>-testid
            iv_part_id   = ls_db_part_out-part_id
            it_messages  = lt_messages
          IMPORTING
            ev_failed_added = lv_failed_added
          CHANGING
            ct_failed    = failed-part
            ct_reported  = reported-part ).

      IF lv_failed_added = abap_false.
        INSERT VALUE #(
            %cid     = <fs_part_entities>-%cid
            testid = <fs_part_entities>-testid
            partid = ls_db_part_out-part_id )
          INTO TABLE mapped-part.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Map messages from legacy type to failed and reported for Part
*
**********************************************************************
  METHOD map_messages.

    ev_failed_added = abap_false.

    LOOP AT it_messages INTO DATA(ls_message).
      IF ls_message-msgty = 'E' OR ls_message-msgty = 'A'.
        APPEND VALUE #( %cid        = iv_cid
                        testid      = iv_quiz_id
                        partid      = iv_part_id
                        %fail-cause = zcl_nept_qz_quiz_auxiliary=>get_cause_from_message(
                                        msgid = ls_message-msgid
                                        msgno = ls_message-msgno
                                      ) )
               TO ct_failed.
        ev_failed_added = abap_true.
      ENDIF.

      APPEND VALUE #( %msg          = new_message(
                                        id       = ls_message-msgid
                                        number   = ls_message-msgno
                                        severity = if_abap_behv_message=>severity-error
                                        v1       = ls_message-msgv1
                                        v2       = ls_message-msgv2
                                        v3       = ls_message-msgv3
                                        v4       = ls_message-msgv4 )
                      %cid        = iv_cid
                      testid      = iv_quiz_id
                      partid      = iv_part_id )
             TO ct_reported.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    DATA: ls_db_part      TYPE znept_qz_prt,
          lv_ord_up       TYPE abap_bool,
          lv_ord_down     TYPE abap_bool,
          lv_failed_added TYPE abap_bool,
          lt_messages     TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_part>).

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result> IS ASSIGNED.
        <fs_result>-%tky = <fs_part>-%tky.

        CLEAR ls_db_part.
        ls_db_part-test_id = <fs_part>-testid.
        ls_db_part-part_id = <fs_part>-partid.

        CALL FUNCTION 'ZNEPT_QZ_PART_ORD_FEAT'
          EXPORTING
            is_db_part  = ls_db_part
          IMPORTING
            ev_ord_up   = lv_ord_up
            ev_ord_down = lv_ord_down
            et_messages = lt_messages.

        map_messages(
            EXPORTING
              iv_quiz_id  = <fs_part>-testid
              iv_part_id  = <fs_part>-partid
              it_messages = lt_messages
            IMPORTING
              ev_failed_added = lv_failed_added
            CHANGING
              ct_failed    = failed-part
              ct_reported  = reported-part ).

        IF lv_failed_added IS INITIAL.
          <fs_result>-%features-%action-movepartup = COND #( WHEN NOT lv_ord_up IS INITIAL
                                                             THEN if_abap_behv=>fc-o-enabled
                                                             ELSE if_abap_behv=>fc-o-disabled ).

          <fs_result>-%features-%action-movepartdown = COND #( WHEN NOT lv_ord_down IS INITIAL
                                                             THEN if_abap_behv=>fc-o-enabled
                                                             ELSE if_abap_behv=>fc-o-disabled ).

          <fs_result>-%features-%action-movepartfirst = <fs_result>-%features-%action-movepartup.
          <fs_result>-%features-%action-movepartlast = <fs_result>-%features-%action-movepartdown.
        ELSE.
          EXIT.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD movepartdown.

    DATA: ls_db_part_in TYPE znept_qz_db_parts_s,
          lt_messages   TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_part_keys>).

      CLEAR ls_db_part_in.
      ls_db_part_in-test_id = <fs_part_keys>-testid.
      ls_db_part_in-part_id = <fs_part_keys>-partid.

      CALL FUNCTION 'ZNEPT_QZ_PART_ORD_DOWN'
        EXPORTING
          is_db_part  = ls_db_part_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_part_keys>-%cid_ref
            iv_quiz_id   = <fs_part_keys>-testid
            iv_part_id   = <fs_part_keys>-partid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-part
            ct_reported  = reported-part ).

    ENDLOOP.

  ENDMETHOD.

  METHOD movepartfirst.

    DATA: ls_db_part_in TYPE znept_qz_db_parts_s,
          lt_messages   TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_part_keys>).

      CLEAR ls_db_part_in.
      ls_db_part_in-test_id = <fs_part_keys>-testid.
      ls_db_part_in-part_id = <fs_part_keys>-partid.

      CALL FUNCTION 'ZNEPT_QZ_PART_ORD_FIRST'
        EXPORTING
          is_db_part  = ls_db_part_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_part_keys>-%cid_ref
            iv_quiz_id   = <fs_part_keys>-testid
            iv_part_id   = <fs_part_keys>-partid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-part
            ct_reported  = reported-part ).

    ENDLOOP.

  ENDMETHOD.

  METHOD movepartlast.

    DATA: ls_db_part_in TYPE znept_qz_db_parts_s,
          lt_messages   TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_part_keys>).

      CLEAR ls_db_part_in.
      ls_db_part_in-test_id = <fs_part_keys>-testid.
      ls_db_part_in-part_id = <fs_part_keys>-partid.

      CALL FUNCTION 'ZNEPT_QZ_PART_ORD_LAST'
        EXPORTING
          is_db_part  = ls_db_part_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_part_keys>-%cid_ref
            iv_quiz_id   = <fs_part_keys>-testid
            iv_part_id   = <fs_part_keys>-partid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-part
            ct_reported  = reported-part ).

    ENDLOOP.

  ENDMETHOD.

  METHOD movepartup.

    DATA: ls_db_part_in TYPE znept_qz_db_parts_s,
          lt_messages   TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_part_keys>).

      CLEAR ls_db_part_in.
      ls_db_part_in-test_id = <fs_part_keys>-testid.
      ls_db_part_in-part_id = <fs_part_keys>-partid.

      CALL FUNCTION 'ZNEPT_QZ_PART_ORD_UP'
        EXPORTING
          is_db_part  = ls_db_part_in
        IMPORTING
          et_messages = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_part_keys>-%cid_ref
            iv_quiz_id   = <fs_part_keys>-testid
            iv_part_id   = <fs_part_keys>-partid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-part
            ct_reported  = reported-part ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_question DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES tt_question_failed    TYPE TABLE FOR FAILED   znept_qz_i_question_u.
    TYPES tt_question_reported  TYPE TABLE FOR REPORTED znept_qz_i_question_u.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE question.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE question.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE question.

    METHODS read FOR READ
      IMPORTING keys FOR READ question RESULT result.

    METHODS rba_quiz FOR READ
      IMPORTING keys_rba FOR READ question\_quiz FULL result_requested RESULT result LINK association_links.

    METHODS rba_variant FOR READ
      IMPORTING keys_rba FOR READ question\_variant FULL result_requested RESULT result LINK association_links.

    METHODS cba_variant FOR MODIFY
      IMPORTING entities_cba FOR CREATE question\_variant.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR question RESULT result.

    METHODS assignpart FOR MODIFY
      IMPORTING keys FOR ACTION question~assignpart.

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

    METHODS refreshquestion FOR MODIFY
      IMPORTING keys FOR ACTION question~refreshquestion.

    METHODS map_messages
      IMPORTING
        iv_cid          TYPE string         OPTIONAL
        iv_quiz_id      TYPE znept_qz_test_id_de OPTIONAL
        iv_question_id  TYPE znept_qz_question_id_de OPTIONAL
        it_messages     TYPE symsg_tab
      EXPORTING
        ev_failed_added TYPE abap_bool
      CHANGING
        ct_failed       TYPE tt_question_failed
        ct_reported     TYPE tt_question_reported.

ENDCLASS.

CLASS lhc_question IMPLEMENTATION.

**********************************************************************
*
* Create Question instances
*
**********************************************************************
  METHOD create.

    DATA: ls_db_question_in  TYPE znept_qz_db_questions_s,
          ls_db_question_out TYPE znept_qz_db_questions_s,
          lt_messages        TYPE symsg_tab,
          lv_failed_added    TYPE abap_bool.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_question_entities>).

      CLEAR ls_db_question_in.
      ls_db_question_in-test_id     = <fs_question_entities>-testid.
      ls_db_question_in-question_id = <fs_question_entities>-questionid.
      ls_db_question_in-part_id     = <fs_question_entities>-partid.
      ls_db_question_in-question    = <fs_question_entities>-question.
      ls_db_question_in-explanation = <fs_question_entities>-explanation.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_CREATE'
        EXPORTING
          is_db_question = ls_db_question_in
        IMPORTING
          es_db_question = ls_db_question_out
          et_messages    = lt_messages.

      map_messages(
          EXPORTING
            iv_cid         = <fs_question_entities>-%cid
            iv_quiz_id     = <fs_question_entities>-testid
            iv_question_id = ls_db_question_out-question_id
            it_messages    = lt_messages
          IMPORTING
            ev_failed_added = lv_failed_added
          CHANGING
            ct_failed    = failed-question
            ct_reported  = reported-question ).

      IF lv_failed_added = abap_false.
        INSERT VALUE #(
            %cid     = <fs_question_entities>-%cid
            testid = <fs_question_entities>-testid
            questionid = ls_db_question_out-question_id )
          INTO TABLE mapped-question.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Update Question instances
*
**********************************************************************
  METHOD update.

    DATA: ls_db_question     TYPE znept_qz_db_questions_s,
          ls_db_question_old TYPE znept_qz_db_questions_s,
          lt_messages        TYPE symsg_tab.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_question_entities>).

      CLEAR ls_db_question.
      ls_db_question-test_id     = <fs_question_entities>-testid.
      ls_db_question-question_id = <fs_question_entities>-questionid.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_READ'
        EXPORTING
          is_db_question = ls_db_question
        IMPORTING
          es_db_question = ls_db_question_old
          et_messages    = lt_messages.

      IF lt_messages[] IS INITIAL.

        ls_db_question-question = COND #( WHEN <fs_question_entities>-%control-question = if_abap_behv=>mk-on
                                          THEN <fs_question_entities>-question ELSE ls_db_question_old-question ).

        ls_db_question-explanation = COND #( WHEN <fs_question_entities>-%control-explanation = if_abap_behv=>mk-on
                                             THEN <fs_question_entities>-explanation ELSE ls_db_question_old-explanation ).

        CALL FUNCTION 'ZNEPT_QZ_QUESTION_UPDATE'
          EXPORTING
            is_db_question = ls_db_question
          IMPORTING
            et_messages    = lt_messages.

        map_messages(
            EXPORTING
              iv_cid         = <fs_question_entities>-%cid_ref
              iv_quiz_id     = <fs_question_entities>-testid
              iv_question_id = <fs_question_entities>-questionid
              it_messages    = lt_messages
            CHANGING
              ct_failed    = failed-question
              ct_reported  = reported-question ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Delete Question instances
*
**********************************************************************
  METHOD delete.

    DATA: ls_db_question_in TYPE znept_qz_db_questions_s,
          lt_messages       TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_question_keys>).

      CLEAR ls_db_question_in.
      ls_db_question_in-test_id = <fs_question_keys>-testid.
      ls_db_question_in-question_id = <fs_question_keys>-questionid.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_DELETE'
        EXPORTING
          is_db_question = ls_db_question_in
        IMPORTING
          et_messages    = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_question_keys>-%cid_ref
            iv_quiz_id   = <fs_question_keys>-testid
            iv_question_id   = <fs_question_keys>-questionid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-question
            ct_reported  = reported-question ).

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Read Question data
*
**********************************************************************
  METHOD read.

    DATA: ls_question_in  TYPE znept_qz_qst,
          ls_question_out TYPE znept_qz_qst,
          lv_failed_added TYPE abap_bool,
          lt_messages     TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_question_to_read>)
      GROUP BY <fs_question_to_read>-%tky.

      CLEAR ls_question_in.
      ls_question_in-test_id = <fs_question_to_read>-testid.
      ls_question_in-question_id = <fs_question_to_read>-questionid.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_READ'
        EXPORTING
          is_db_question = ls_question_in
        IMPORTING
          es_db_question = ls_question_out
          et_messages    = lt_messages.

      map_messages(
          EXPORTING
            iv_quiz_id   = <fs_question_to_read>-testid
            iv_question_id = <fs_question_to_read>-questionid
            it_messages  = lt_messages
          IMPORTING
            ev_failed_added = lv_failed_added
          CHANGING
            ct_failed    = failed-question
            ct_reported  = reported-question ).

      IF lv_failed_added = abap_false.
        INSERT CORRESPONDING #( ls_question_out MAPPING TO ENTITY ) INTO TABLE result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD rba_quiz.

  ENDMETHOD.

  METHOD rba_variant.

  ENDMETHOD.

**********************************************************************
*
* Create Variant via Question
*
**********************************************************************
  METHOD cba_variant.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<fs_variant_entities_cba>).
      LOOP AT <fs_variant_entities_cba>-%target ASSIGNING FIELD-SYMBOL(<fs_target>).

        MODIFY ENTITIES OF znept_qz_i_quiz_u IN LOCAL MODE
          ENTITY variant
            CREATE FIELDS ( variant correct )
            WITH VALUE #( ( %cid        = <fs_target>-%cid
                            testid      = <fs_variant_entities_cba>-testid
                            questionid  = <fs_variant_entities_cba>-questionid
                            variant     = <fs_target>-variant
                            correct     = <fs_target>-correct ) )
         MAPPED   DATA(lt_mapped)
         FAILED   DATA(lt_failed)
         REPORTED DATA(lt_reported).

        MOVE-CORRESPONDING lt_mapped-variant   TO mapped-variant   KEEPING TARGET LINES.
        MOVE-CORRESPONDING lt_failed-variant   TO failed-variant   KEEPING TARGET LINES.
        MOVE-CORRESPONDING lt_reported-variant TO reported-variant KEEPING TARGET LINES.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Map messages from legacy type to failed and reported for Question
*
**********************************************************************
  METHOD map_messages.

    ev_failed_added = abap_false.

    LOOP AT it_messages INTO DATA(ls_message).
      IF ls_message-msgty = 'E' OR ls_message-msgty = 'A'.
        APPEND VALUE #( %cid        = iv_cid
                        testid      = iv_quiz_id
                        questionid  = iv_question_id
                        %fail-cause = zcl_nept_qz_quiz_auxiliary=>get_cause_from_message(
                                        msgid = ls_message-msgid
                                        msgno = ls_message-msgno
                                      ) )
               TO ct_failed.
        ev_failed_added = abap_true.
      ENDIF.

      APPEND VALUE #( %msg          = new_message(
                                        id       = ls_message-msgid
                                        number   = ls_message-msgno
                                        severity = if_abap_behv_message=>severity-error
                                        v1       = ls_message-msgv1
                                        v2       = ls_message-msgv2
                                        v3       = ls_message-msgv3
                                        v4       = ls_message-msgv4 )
                      %cid        = iv_cid
                      testid      = iv_quiz_id
                      questionid  = iv_question_id )
             TO ct_reported.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

********************************************************************************
*
* Assign Question to a Part
*
********************************************************************************
  METHOD assignpart.

    DATA: ls_db_question_in TYPE znept_qz_db_questions_s,
          lv_new_part_id    TYPE znept_qz_db_questions_s-part_id,
          lv_failed_added   TYPE abap_bool,
          lt_messages       TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_question_keys>).

      CLEAR ls_db_question_in.
      ls_db_question_in-test_id     = <fs_question_keys>-testid.
      ls_db_question_in-question_id = <fs_question_keys>-questionid.

      lv_new_part_id = <fs_question_keys>-%param-new_part_id.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_ASSIGN'
        EXPORTING
          is_db_question = ls_db_question_in
          iv_new_part_id = lv_new_part_id
        IMPORTING
          et_messages    = lt_messages.

      map_messages(
          EXPORTING
            iv_cid         = <fs_question_keys>-%cid_ref
            iv_quiz_id     = <fs_question_keys>-testid
            iv_question_id = <fs_question_keys>-questionid
            it_messages    = lt_messages
          IMPORTING
            ev_failed_added = lv_failed_added
          CHANGING
            ct_failed      = failed-question
            ct_reported    = reported-question ).

      IF lv_failed_added = abap_false.
        MESSAGE i150(znept_qz_cds) INTO DATA(lv_message_text).
        INSERT VALUE #(
          %msg = new_message_with_text( text = lv_message_text
          severity = if_abap_behv_message=>severity-success )
        ) INTO TABLE reported-question.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

********************************************************************************
*
* Dynamic action handling for Question instances
*
********************************************************************************
  METHOD get_instance_features.

    DATA: ls_db_quiz      TYPE znept_qz_tst,
          ls_db_question  TYPE znept_qz_qst,
          lv_has_parts    TYPE abap_bool,
          lv_ord_up       TYPE abap_bool,
          lv_ord_down     TYPE abap_bool,
          lv_failed_added TYPE abap_bool,
          lt_messages     TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_question>).

      IF sy-index = 1.
        CLEAR ls_db_quiz.
        ls_db_quiz-test_id = <fs_question>-testid.

        CALL FUNCTION 'ZNEPT_QZ_QUIZ_HAS_PARTS'
          EXPORTING
            is_db_quiz   = ls_db_quiz
          IMPORTING
            ev_has_parts = lv_has_parts
            et_messages  = lt_messages.

        map_messages(
            EXPORTING
              iv_quiz_id   = <fs_question>-testid
              iv_question_id = <fs_question>-questionid
              it_messages  = lt_messages
            IMPORTING
              ev_failed_added = lv_failed_added
            CHANGING
              ct_failed    = failed-question
              ct_reported  = reported-question ).
        IF NOT lv_failed_added IS INITIAL.
          EXIT.
        ENDIF.
      ENDIF.

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result> IS ASSIGNED.
        <fs_result>-%tky = <fs_question>-%tky.
        <fs_result>-%features-%action-assignpart = COND #( WHEN NOT lv_has_parts IS INITIAL
                                                           THEN if_abap_behv=>fc-o-enabled
                                                           ELSE if_abap_behv=>fc-o-disabled ).

        CLEAR ls_db_question.
        ls_db_question-test_id = <fs_question>-testid.
        ls_db_question-question_id = <fs_question>-questionid.

        CALL FUNCTION 'ZNEPT_QZ_QUESTION_ORD_FEAT'
          EXPORTING
            is_db_question = ls_db_question
          IMPORTING
            ev_ord_up      = lv_ord_up
            ev_ord_down    = lv_ord_down
            et_messages    = lt_messages.

        map_messages(
            EXPORTING
              iv_quiz_id   = <fs_question>-testid
              iv_question_id = <fs_question>-questionid
              it_messages  = lt_messages
            IMPORTING
              ev_failed_added = lv_failed_added
            CHANGING
              ct_failed    = failed-question
              ct_reported  = reported-question ).

        IF lv_failed_added IS INITIAL.
          <fs_result>-%features-%action-movequestionup = COND #( WHEN NOT lv_ord_up IS INITIAL
                                                             THEN if_abap_behv=>fc-o-enabled
                                                             ELSE if_abap_behv=>fc-o-disabled ).

          <fs_result>-%features-%action-movequestiondown = COND #( WHEN NOT lv_ord_down IS INITIAL
                                                             THEN if_abap_behv=>fc-o-enabled
                                                             ELSE if_abap_behv=>fc-o-disabled ).

          <fs_result>-%features-%action-movequestionfirst = <fs_result>-%features-%action-movequestionup.
          <fs_result>-%features-%action-movequestionlast = <fs_result>-%features-%action-movequestiondown.
        ELSE.
          EXIT.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Question move down in order
*
**********************************************************************
  METHOD movequestiondown.

    DATA: ls_db_question_in TYPE znept_qz_db_questions_s,
          lt_messages       TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_question_keys>).

      CLEAR ls_db_question_in.
      ls_db_question_in-test_id = <fs_question_keys>-testid.
      ls_db_question_in-question_id = <fs_question_keys>-questionid.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_ORD_DOWN'
        EXPORTING
          is_db_question = ls_db_question_in
        IMPORTING
          et_messages    = lt_messages.

      map_messages(
          EXPORTING
            iv_cid         = <fs_question_keys>-%cid_ref
            iv_quiz_id     = <fs_question_keys>-testid
            iv_question_id = <fs_question_keys>-questionid
            it_messages    = lt_messages
          CHANGING
            ct_failed    = failed-question
            ct_reported  = reported-question ).

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Question move to the top in order
*
**********************************************************************
  METHOD movequestionfirst.

    DATA: ls_db_question_in TYPE znept_qz_db_questions_s,
          lt_messages       TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_question_keys>).

      CLEAR ls_db_question_in.
      ls_db_question_in-test_id = <fs_question_keys>-testid.
      ls_db_question_in-question_id = <fs_question_keys>-questionid.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_ORD_FIRST'
        EXPORTING
          is_db_question = ls_db_question_in
        IMPORTING
          et_messages    = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_question_keys>-%cid_ref
            iv_quiz_id   = <fs_question_keys>-testid
            iv_question_id   = <fs_question_keys>-questionid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-question
            ct_reported  = reported-question ).

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Question move to the bottom in order
*
**********************************************************************
  METHOD movequestionlast.

    DATA: ls_db_question_in TYPE znept_qz_db_questions_s,
          lt_messages       TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_question_keys>).

      CLEAR ls_db_question_in.
      ls_db_question_in-test_id = <fs_question_keys>-testid.
      ls_db_question_in-question_id = <fs_question_keys>-questionid.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_ORD_LAST'
        EXPORTING
          is_db_question = ls_db_question_in
        IMPORTING
          et_messages    = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_question_keys>-%cid_ref
            iv_quiz_id   = <fs_question_keys>-testid
            iv_question_id   = <fs_question_keys>-questionid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-question
            ct_reported  = reported-question ).

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Question move up in order
*
**********************************************************************
  METHOD movequestionup.

    DATA: ls_db_question_in TYPE znept_qz_db_questions_s,
          lt_messages       TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_question_keys>).

      CLEAR ls_db_question_in.
      ls_db_question_in-test_id = <fs_question_keys>-testid.
      ls_db_question_in-question_id = <fs_question_keys>-questionid.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_ORD_UP'
        EXPORTING
          is_db_question = ls_db_question_in
        IMPORTING
          et_messages    = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_question_keys>-%cid_ref
            iv_quiz_id   = <fs_question_keys>-testid
            iv_question_id   = <fs_question_keys>-questionid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-question
            ct_reported  = reported-question ).

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Question renew progress
*
**********************************************************************
  METHOD refreshquestion.

    DATA: ls_db_question_in TYPE znept_qz_db_questions_s,
          lt_messages       TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_question_keys>).

      CLEAR ls_db_question_in.
      ls_db_question_in-test_id = <fs_question_keys>-testid.
      ls_db_question_in-question_id = <fs_question_keys>-questionid.

      CALL FUNCTION 'ZNEPT_QZ_QUESTION_RENEW'
        EXPORTING
          is_db_question = ls_db_question_in
        IMPORTING
          et_messages    = lt_messages.

      map_messages(
          EXPORTING
            iv_cid         = <fs_question_keys>-%cid_ref
            iv_quiz_id     = <fs_question_keys>-testid
            iv_question_id = <fs_question_keys>-questionid
            it_messages    = lt_messages
          CHANGING
            ct_failed    = failed-question
            ct_reported  = reported-question ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_variant DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES tt_variant_failed    TYPE TABLE FOR FAILED   znept_qz_i_variant_u.
    TYPES tt_variant_reported  TYPE TABLE FOR REPORTED znept_qz_i_variant_u.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE variant.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE variant.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE variant.

    METHODS read FOR READ
      IMPORTING keys FOR READ variant RESULT result.

    METHODS rba_question FOR READ
      IMPORTING keys_rba FOR READ variant\_question FULL result_requested RESULT result LINK association_links.

    METHODS rba_quiz FOR READ
      IMPORTING keys_rba FOR READ variant\_quiz FULL result_requested RESULT result LINK association_links.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR variant RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR variant RESULT result.

    METHODS movevariantdown FOR MODIFY
      IMPORTING keys FOR ACTION variant~movevariantdown.

    METHODS movevariantfirst FOR MODIFY
      IMPORTING keys FOR ACTION variant~movevariantfirst.

    METHODS movevariantlast FOR MODIFY
      IMPORTING keys FOR ACTION variant~movevariantlast.

    METHODS movevariantup FOR MODIFY
      IMPORTING keys FOR ACTION variant~movevariantup.

    METHODS map_messages
      IMPORTING
        iv_cid          TYPE string         OPTIONAL
        iv_quiz_id      TYPE znept_qz_test_id_de OPTIONAL
        iv_part_id      TYPE znept_qz_part_id_de OPTIONAL
        iv_question_id  TYPE znept_qz_question_id_de OPTIONAL
        iv_variant_id   TYPE znept_qz_variant_id_de OPTIONAL
        it_messages     TYPE symsg_tab
      EXPORTING
        ev_failed_added TYPE abap_bool
      CHANGING
        ct_failed       TYPE tt_variant_failed
        ct_reported     TYPE tt_variant_reported.

ENDCLASS.

CLASS lhc_variant IMPLEMENTATION.

**********************************************************************
*
* Create Variant instances
*
**********************************************************************
  METHOD create.

    DATA: ls_db_variant_in  TYPE znept_qz_db_variants_s,
          ls_db_variant_out TYPE znept_qz_db_variants_s,
          lt_messages       TYPE symsg_tab,
          lv_failed_added   TYPE abap_bool.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_variant_entities>).

      CLEAR ls_db_variant_in.
      ls_db_variant_in-test_id     = <fs_variant_entities>-testid.
      ls_db_variant_in-question_id = <fs_variant_entities>-questionid.
      ls_db_variant_in-variant     = <fs_variant_entities>-variant.
      ls_db_variant_in-correct     = <fs_variant_entities>-correct.

      CALL FUNCTION 'ZNEPT_QZ_VARIANT_CREATE'
        EXPORTING
          is_db_variant = ls_db_variant_in
        IMPORTING
          es_db_variant = ls_db_variant_out
          et_messages   = lt_messages.

      map_messages(
          EXPORTING
            iv_cid         = <fs_variant_entities>-%cid
            iv_quiz_id     = <fs_variant_entities>-testid
            iv_question_id = <fs_variant_entities>-questionid
            iv_variant_id  = ls_db_variant_out-variant_id
            it_messages    = lt_messages
          IMPORTING
            ev_failed_added = lv_failed_added
          CHANGING
            ct_failed    = failed-variant
            ct_reported  = reported-variant ).

      IF lv_failed_added = abap_false.
        INSERT VALUE #(
            %cid       = <fs_variant_entities>-%cid
            testid     = <fs_variant_entities>-testid
            questionid = <fs_variant_entities>-questionid
            variantid  = ls_db_variant_out-variant_id )
          INTO TABLE mapped-variant.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Update Variant instances
*
**********************************************************************
  METHOD update.

    DATA: ls_db_variant     TYPE znept_qz_db_variants_s,
          ls_db_variant_old TYPE znept_qz_db_variants_s,
          lt_messages       TYPE symsg_tab.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_variant_entities>).

      CLEAR ls_db_variant.
      ls_db_variant-test_id     = <fs_variant_entities>-testid.
      ls_db_variant-question_id = <fs_variant_entities>-questionid.
      ls_db_variant-variant_id  = <fs_variant_entities>-variantid.

      CALL FUNCTION 'ZNEPT_QZ_VARIANT_READ'
        EXPORTING
          is_db_variant = ls_db_variant
        IMPORTING
          es_db_variant = ls_db_variant_old
          et_messages   = lt_messages.

      IF lt_messages[] IS INITIAL.

        ls_db_variant-variant = COND #( WHEN <fs_variant_entities>-%control-variant = if_abap_behv=>mk-on
                                          THEN <fs_variant_entities>-variant ELSE ls_db_variant_old-variant ).

        ls_db_variant-correct = COND #( WHEN <fs_variant_entities>-%control-correct = if_abap_behv=>mk-on
                                             THEN <fs_variant_entities>-correct ELSE ls_db_variant_old-correct ).

        CALL FUNCTION 'ZNEPT_QZ_VARIANT_UPDATE'
          EXPORTING
            is_db_variant = ls_db_variant
          IMPORTING
            et_messages   = lt_messages.

        map_messages(
            EXPORTING
              iv_cid         = <fs_variant_entities>-%cid_ref
              iv_quiz_id     = <fs_variant_entities>-testid
              iv_question_id = <fs_variant_entities>-questionid
              iv_variant_id  = <fs_variant_entities>-variantid
              it_messages    = lt_messages
            CHANGING
              ct_failed    = failed-variant
              ct_reported  = reported-variant ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
*
* Delete Variant instances
*
**********************************************************************
  METHOD delete.

    DATA: ls_db_variant_in TYPE znept_qz_db_variants_s,
          lt_messages      TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_variant_entities>).

      CLEAR ls_db_variant_in.
      ls_db_variant_in-test_id     = <fs_variant_entities>-testid.
      ls_db_variant_in-question_id = <fs_variant_entities>-questionid.
      ls_db_variant_in-variant_id  = <fs_variant_entities>-variantid.

      CALL FUNCTION 'ZNEPT_QZ_VARIANT_DELETE'
        EXPORTING
          is_db_variant = ls_db_variant_in
        IMPORTING
          et_messages   = lt_messages.

      map_messages(
          EXPORTING
            iv_cid         = <fs_variant_entities>-%cid_ref
            iv_quiz_id     = <fs_variant_entities>-testid
            iv_question_id = <fs_variant_entities>-questionid
            iv_variant_id  = <fs_variant_entities>-variantid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-variant
            ct_reported  = reported-variant ).

    ENDLOOP.

  ENDMETHOD.

  METHOD read.

  ENDMETHOD.

  METHOD rba_question.

  ENDMETHOD.

  METHOD rba_quiz.

  ENDMETHOD.

**********************************************************************
*
* Map messages from legacy type to failed and reported for Variant
*
**********************************************************************
  METHOD map_messages.

    ev_failed_added = abap_false.

    LOOP AT it_messages INTO DATA(ls_message).
      IF ls_message-msgty = 'E' OR ls_message-msgty = 'A'.
        APPEND VALUE #( %cid        = iv_cid
                        testid      = iv_quiz_id
                        questionid  = iv_question_id
                        variantid   = iv_variant_id
                        %fail-cause = zcl_nept_qz_quiz_auxiliary=>get_cause_from_message(
                                        msgid = ls_message-msgid
                                        msgno = ls_message-msgno
                                      ) )
               TO ct_failed.
        ev_failed_added = abap_true.
      ENDIF.

      APPEND VALUE #( %msg          = new_message(
                                        id       = ls_message-msgid
                                        number   = ls_message-msgno
                                        severity = if_abap_behv_message=>severity-error
                                        v1       = ls_message-msgv1
                                        v2       = ls_message-msgv2
                                        v3       = ls_message-msgv3
                                        v4       = ls_message-msgv4 )
                      %cid        = iv_cid
                      testid      = iv_quiz_id
                      questionid  = iv_question_id
                      variantid   = iv_variant_id )
             TO ct_reported.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    DATA: ls_db_variant   TYPE znept_qz_var,
          lv_ord_up       TYPE abap_bool,
          lv_ord_down     TYPE abap_bool,
          lv_failed_added TYPE abap_bool,
          lt_messages     TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_variant>).

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result> IS ASSIGNED.
        <fs_result>-%tky = <fs_variant>-%tky.

        CLEAR ls_db_variant.
        ls_db_variant-test_id = <fs_variant>-testid.
        ls_db_variant-question_id = <fs_variant>-questionid.
        ls_db_variant-variant_id = <fs_variant>-variantid.

        CALL FUNCTION 'ZNEPT_QZ_VARIANT_ORD_FEAT'
          EXPORTING
            is_db_variant = ls_db_variant
          IMPORTING
            ev_ord_up     = lv_ord_up
            ev_ord_down   = lv_ord_down
            et_messages   = lt_messages.

        map_messages(
            EXPORTING
              iv_quiz_id  = <fs_variant>-testid
              iv_question_id  = <fs_variant>-questionid
              iv_variant_id   = <fs_variant>-variantid
              it_messages = lt_messages
            IMPORTING
              ev_failed_added = lv_failed_added
            CHANGING
              ct_failed    = failed-variant
              ct_reported  = reported-variant ).

        IF lv_failed_added IS INITIAL.
          <fs_result>-%features-%action-movevariantup = COND #( WHEN NOT lv_ord_up IS INITIAL
                                                             THEN if_abap_behv=>fc-o-enabled
                                                             ELSE if_abap_behv=>fc-o-disabled ).

          <fs_result>-%features-%action-movevariantdown = COND #( WHEN NOT lv_ord_down IS INITIAL
                                                             THEN if_abap_behv=>fc-o-enabled
                                                             ELSE if_abap_behv=>fc-o-disabled ).

          <fs_result>-%features-%action-movevariantfirst = <fs_result>-%features-%action-movevariantup.
          <fs_result>-%features-%action-movevariantlast = <fs_result>-%features-%action-movevariantdown.
        ELSE.
          EXIT.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD movevariantdown.

    DATA: ls_db_variant_in TYPE znept_qz_db_variants_s,
          lt_messages      TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_variant_keys>).

      CLEAR ls_db_variant_in.
      ls_db_variant_in-test_id = <fs_variant_keys>-testid.
      ls_db_variant_in-question_id = <fs_variant_keys>-questionid.
      ls_db_variant_in-variant_id = <fs_variant_keys>-variantid.

      CALL FUNCTION 'ZNEPT_QZ_VARIANT_ORD_DOWN'
        EXPORTING
          is_db_variant = ls_db_variant_in
        IMPORTING
          et_messages   = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_variant_keys>-%cid_ref
            iv_quiz_id   = <fs_variant_keys>-testid
            iv_question_id   = <fs_variant_keys>-questionid
            iv_variant_id   = <fs_variant_keys>-variantid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-variant
            ct_reported  = reported-variant ).

    ENDLOOP.

  ENDMETHOD.

  METHOD movevariantfirst.

    DATA: ls_db_variant_in TYPE znept_qz_db_variants_s,
          lt_messages      TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_variant_keys>).

      CLEAR ls_db_variant_in.
      ls_db_variant_in-test_id = <fs_variant_keys>-testid.
      ls_db_variant_in-question_id = <fs_variant_keys>-questionid.
      ls_db_variant_in-variant_id = <fs_variant_keys>-variantid.

      CALL FUNCTION 'ZNEPT_QZ_VARIANT_ORD_FIRST'
        EXPORTING
          is_db_variant = ls_db_variant_in
        IMPORTING
          et_messages   = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_variant_keys>-%cid_ref
            iv_quiz_id   = <fs_variant_keys>-testid
            iv_question_id   = <fs_variant_keys>-questionid
            iv_variant_id   = <fs_variant_keys>-variantid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-variant
            ct_reported  = reported-variant ).

    ENDLOOP.

  ENDMETHOD.

  METHOD movevariantlast.

    DATA: ls_db_variant_in TYPE znept_qz_db_variants_s,
          lt_messages      TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_variant_keys>).

      CLEAR ls_db_variant_in.
      ls_db_variant_in-test_id = <fs_variant_keys>-testid.
      ls_db_variant_in-question_id = <fs_variant_keys>-questionid.
      ls_db_variant_in-variant_id = <fs_variant_keys>-variantid.

      CALL FUNCTION 'ZNEPT_QZ_VARIANT_ORD_LAST'
        EXPORTING
          is_db_variant = ls_db_variant_in
        IMPORTING
          et_messages   = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_variant_keys>-%cid_ref
            iv_quiz_id   = <fs_variant_keys>-testid
            iv_question_id   = <fs_variant_keys>-questionid
            iv_variant_id   = <fs_variant_keys>-variantid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-variant
            ct_reported  = reported-variant ).

    ENDLOOP.

  ENDMETHOD.

  METHOD movevariantup.

    DATA: ls_db_variant_in TYPE znept_qz_db_variants_s,
          lt_messages      TYPE symsg_tab.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_variant_keys>).

      CLEAR ls_db_variant_in.
      ls_db_variant_in-test_id = <fs_variant_keys>-testid.
      ls_db_variant_in-question_id = <fs_variant_keys>-questionid.
      ls_db_variant_in-variant_id = <fs_variant_keys>-variantid.

      CALL FUNCTION 'ZNEPT_QZ_VARIANT_ORD_UP'
        EXPORTING
          is_db_variant = ls_db_variant_in
        IMPORTING
          et_messages   = lt_messages.

      map_messages(
          EXPORTING
            iv_cid       = <fs_variant_keys>-%cid_ref
            iv_quiz_id   = <fs_variant_keys>-testid
            iv_question_id   = <fs_variant_keys>-questionid
            iv_variant_id   = <fs_variant_keys>-variantid
            it_messages  = lt_messages
          CHANGING
            ct_failed    = failed-variant
            ct_reported  = reported-variant ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_u DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_u IMPLEMENTATION.

  METHOD finalize.

  ENDMETHOD.

  METHOD check_before_save.

  ENDMETHOD.

  METHOD adjust_numbers.

  ENDMETHOD.

  METHOD save.

  ENDMETHOD.

  METHOD cleanup.

  ENDMETHOD.

  METHOD cleanup_finalize.

  ENDMETHOD.

ENDCLASS.
