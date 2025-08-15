class ZCL_NEPT_QZ_DATA_CDS definition
  public
  final
  create public .

public section.

  class-methods PART_READ
    importing
      !IS_DB_PART type ZNEPT_QZ_DB_PARTS_S
    exporting
      !ES_DB_PART type ZNEPT_QZ_DB_PARTS_S
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUESTION_READ
    importing
      !IS_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
    exporting
      !ET_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_T
      !ES_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUIZ_CREATE
    importing
      !IS_DB_QUIZ type ZNEPT_QZ_DB_TESTS_S
    exporting
      !ES_DB_QUIZ type ZNEPT_QZ_DB_TESTS_S
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUIZ_HAS_PARTS
    importing
      !IS_DB_QUIZ type ZNEPT_QZ_DB_TESTS_S
    exporting
      !EV_HAS_PARTS type ABAP_BOOL
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUIZ_READ
    importing
      !IS_DB_QUIZ type ZNEPT_QZ_DB_TESTS_S
    exporting
      !ES_DB_QUIZ type ZNEPT_QZ_DB_TESTS_S
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods VARIANT_READ
    importing
      !IS_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_S
    exporting
      !ES_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_S
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUIZ_UPDATE
    importing
      !IS_DB_QUIZ type ZNEPT_QZ_DB_TESTS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUIZ_DELETE
    importing
      !IS_DB_QUIZ type ZNEPT_QZ_DB_TESTS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUIZ_PUBLISH
    importing
      !IS_DB_QUIZ type ZNEPT_QZ_DB_TESTS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods PART_CREATE
    importing
      !IS_DB_PART type ZNEPT_QZ_DB_PARTS_S
    exporting
      !ES_DB_PART type ZNEPT_QZ_DB_PARTS_S
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods PART_UPDATE
    importing
      !IS_DB_PART type ZNEPT_QZ_DB_PARTS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods PART_DELETE
    importing
      !IS_DB_PART type ZNEPT_QZ_DB_PARTS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUESTION_CREATE
    importing
      !IS_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
      !IT_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_T optional
    exporting
      !ES_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
      !ET_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_T
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUESTION_ASSIGN
    importing
      !IS_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
      !IV_NEW_PART_ID type ZNEPT_QZ_PART_ID_DE
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUESTION_RENEW
    importing
      !IS_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUESTION_UPDATE
    importing
      !IS_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUESTION_DELETE
    importing
      !IS_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUESTION_ORD_FEATURES
    importing
      !IS_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
    exporting
      !EV_ORD_UP type ABAP_BOOL
      !EV_ORD_DOWN type ABAP_BOOL
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods PART_ORD_FEATURES
    importing
      !IS_DB_PART type ZNEPT_QZ_DB_PARTS_S
    exporting
      !EV_ORD_UP type ABAP_BOOL
      !EV_ORD_DOWN type ABAP_BOOL
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods VARIANT_ORD_FEATURES
    importing
      !IS_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_S
    exporting
      !EV_ORD_UP type ABAP_BOOL
      !EV_ORD_DOWN type ABAP_BOOL
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods VARIANT_CREATE
    importing
      !IS_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_S
    exporting
      !ES_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_S
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods VARIANT_UPDATE
    importing
      !IS_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods VARIANT_DELETE
    importing
      !IS_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_S
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUESTION_ORD_UPDATE
    importing
      !IS_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
      !IV_DOWN type ABAP_BOOL
      !IV_BOTTOM type ABAP_BOOL
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods PART_ORD_UPDATE
    importing
      !IS_DB_PART type ZNEPT_QZ_DB_PARTS_S
      !IV_DOWN type ABAP_BOOL
      !IV_BOTTOM type ABAP_BOOL
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods VARIANT_ORD_UPDATE
    importing
      !IS_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_S
      !IV_DOWN type ABAP_BOOL
      !IV_BOTTOM type ABAP_BOOL
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods CONVERT_MESSAGES
    importing
      !IT_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE
    exporting
      !ET_MESSAGES type SYMSG_TAB .
  PROTECTED SECTION.
private section.

  class-methods VARIANT_SET_CHANGE
    importing
      !IS_DB_VARIANT type ZNEPT_QZ_DB_VARIANTS_S
      !IV_DELETED type ABAP_BOOL optional
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods PART_SET_CHANGE
    importing
      !IS_DB_PART type ZNEPT_QZ_DB_PARTS_S
      !IV_DELETED type ABAP_BOOL optional
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUESTION_SET_CHANGE
    importing
      !IS_DB_QUESTION type ZNEPT_QZ_DB_QUESTIONS_S
      !IV_DELETED type ABAP_BOOL optional
    exporting
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods QUIZ_SET_CHANGE
    importing
      !IS_DB_QUIZ_KEY type ZNEPT_QZ_DB_TESTS_KEY_S
    exporting
      !EV_VERSION type ZNEPT_QZ_COUNT_VERSION_DE
      !ET_MESSAGES type ZIF_NEPT_QZ_QUIZ_CONST=>TT_IF_T100_MESSAGE .
  class-methods _RESOLVE_ATTRIBUTE
    importing
      !IV_ATTRNAME type SCX_ATTRNAME
      !IX type ref to ZCX_NEPT_QZ_CDS
    returning
      value(RV_SYMSGV) type SYMSGV .
ENDCLASS.



CLASS ZCL_NEPT_QZ_DATA_CDS IMPLEMENTATION.


  METHOD part_create.

    DATA: ls_db_part TYPE znept_qz_db_parts_s.

    REFRESH et_messages.

    CLEAR es_db_part.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR ls_db_part.
    ls_db_part-test_id     = is_db_part-test_id.
    ls_db_part-description = is_db_part-description.
    ls_db_part-sort        = is_db_part-sort.

    SELECT MAX( part_id ) FROM znept_qz_prt INTO ls_db_part-test_id
      WHERE test_id = ls_db_part-test_id.

    IF sy-subrc <> 0.
      ls_db_part-part_id = 0.
    ENDIF.

    ls_db_part-part_id = ls_db_part-part_id + 1.

*    DO.
*      ls_db_part-part_id = ls_db_part-part_id + 1.
*      SELECT part_id UP TO 1 ROWS FROM znept_qz_prt INTO ls_db_part-part_id
*        WHERE test_id = ls_db_part-test_id
*          AND part_id = ls_db_part-part_id.
*      ENDSELECT.
*      IF sy-subrc <> 0.
*        EXIT.
*      ENDIF.
*    ENDDO.

    IF ls_db_part-sort = ls_db_part-part_id.
      CLEAR ls_db_part-sort.
    ENDIF.

    INSERT znept_qz_prt FROM ls_db_part.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_create_error ) TO et_messages.
      RETURN.
    ENDIF.

* Begin of: to be replaced on sync with hash method or other

    CALL METHOD zcl_nept_qz_data_cds=>part_set_change
      EXPORTING
        is_db_part  = ls_db_part
      IMPORTING
        et_messages = et_messages.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

* End of: to be replaced on sync with hash method or other

    es_db_part = ls_db_part.

  ENDMETHOD.


  METHOD part_delete.

    DATA: ls_db_part     TYPE znept_qz_db_parts_s,
          ls_db_question TYPE znept_qz_db_questions_s,
          ls_db_variant  TYPE znept_qz_db_variants_s.

    REFRESH et_messages.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_part-part_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_prt INTO ls_db_part
      WHERE test_id = is_db_part-test_id
        AND part_id = is_db_part-part_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_not_exist ) TO et_messages.
      RETURN.
    ENDIF.

    SELECT SINGLE * INTO ls_db_question FROM znept_qz_qst
      WHERE test_id = is_db_part-test_id
        AND part_id = is_db_part-part_id.

    IF sy-subrc = 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_is_used ) TO et_messages.
      RETURN.
    ENDIF.

    DELETE FROM znept_qz_prt WHERE test_id = is_db_part-test_id
                               AND part_id = is_db_part-part_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_delete_error ) TO et_messages.
    ENDIF.

* Begin of: to be replaced on sync with hash method or other

    IF et_messages[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_cds=>part_set_change
        EXPORTING
          is_db_part  = is_db_part
          iv_deleted  = abap_true
        IMPORTING
          et_messages = et_messages.

    ENDIF.

* End of: to be replaced on sync with hash method or other

*      IF et_messages IS INITIAL.
*        SELECT SINGLE * INTO ls_db_question FROM znept_qz_qst
*          WHERE test_id = is_db_part-test_id
*            AND part_id = is_db_part-part_id.
*        IF sy-subrc = 0.
*
*          DELETE FROM znept_qz_qst WHERE test_id = is_db_part-test_id
*                                     AND part_id = is_db_part-part_id.
*          IF sy-subrc <> 0.
*            APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_delete_error ) TO et_messages.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*
*      IF et_messages IS INITIAL.
*        SELECT SINGLE * INTO ls_db_variant FROM znept_qz_var
*          WHERE test_id = is_db_part-test_id.
*        IF sy-subrc = 0.
*          DELETE FROM znept_qz_var WHERE test_id = is_db_part-test_id.
*          IF sy-subrc <> 0.
*            APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_delete_error ) TO et_messages.
*          ENDIF.
*        ENDIF.
*      ENDIF.

  ENDMETHOD.


  METHOD part_update.

    REFRESH et_messages.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_part-part_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    UPDATE znept_qz_prt
      SET   description = is_db_part-description
      WHERE test_id     = is_db_part-test_id
        AND part_id     = is_db_part-part_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_update_error ) TO et_messages.
    ENDIF.


* Begin of: to be replaced on sync with hash method or other

    IF et_messages[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_cds=>part_set_change
        EXPORTING
          is_db_part  = is_db_part
        IMPORTING
          et_messages = et_messages.

    ENDIF.

* End of: to be replaced on sync with hash method or other

  ENDMETHOD.


  METHOD question_create.

    DATA: ls_db_question TYPE znept_qz_db_questions_s,
          lt_db_variant  TYPE znept_qz_db_variants_t,
          ls_db_variant  TYPE znept_qz_db_variants_s.

    REFRESH et_messages.

    CLEAR es_db_question.
    REFRESH et_db_variant.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR ls_db_question.
    ls_db_question-test_id     = is_db_question-test_id.
    ls_db_question-part_id     = is_db_question-part_id.
    ls_db_question-question    = is_db_question-question.
    ls_db_question-explanation = is_db_question-explanation.
    ls_db_question-sort        = is_db_question-sort.

    SELECT MAX( question_id ) FROM znept_qz_qst INTO ls_db_question-question_id
      WHERE test_id = ls_db_question-test_id.

    IF sy-subrc <> 0.
      ls_db_question-question_id = 0.
    ENDIF.

    ls_db_question-question_id = ls_db_question-question_id + 1.

*    DO.
*      ls_db_question-question_id = ls_db_question-question_id + 1.
*      SELECT question_id UP TO 1 ROWS FROM znept_qz_qst INTO ls_db_question-question_id
*        WHERE test_id     = ls_db_question-test_id
*          AND question_id = ls_db_question-question_id.
*      ENDSELECT.
*      IF sy-subrc <> 0.
*        EXIT.
*      ENDIF.
*    ENDDO.

    IF ls_db_question-sort = ls_db_question-question_id.
      CLEAR ls_db_question-sort.
    ENDIF.

    INSERT znept_qz_qst FROM ls_db_question.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_create_error ) TO et_messages.
      RETURN.
    ENDIF.

    IF NOT it_db_variant[] IS INITIAL.
      LOOP AT it_db_variant INTO ls_db_variant.
        ls_db_variant-test_id     = ls_db_question-test_id.
        ls_db_variant-question_id = ls_db_question-question_id.
        APPEND ls_db_variant TO lt_db_variant.
        CLEAR ls_db_variant.
      ENDLOOP.

      INSERT znept_qz_var FROM TABLE lt_db_variant.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_create_error ) TO et_messages.
        RETURN.
      ENDIF.
    ENDIF.

* Begin of: to be replaced on sync with hash method or other

    IF et_messages[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_cds=>question_set_change
        EXPORTING
          is_db_question = ls_db_question
        IMPORTING
          et_messages    = et_messages.

      IF NOT et_messages[] IS INITIAL.
        RETURN.
      ENDIF.

      LOOP AT lt_db_variant INTO ls_db_variant.

        CALL METHOD zcl_nept_qz_data_cds=>variant_set_change
          EXPORTING
            is_db_variant = ls_db_variant
          IMPORTING
            et_messages   = et_messages.

        IF NOT et_messages[] IS INITIAL.
          RETURN.
        ENDIF.

        CLEAR ls_db_variant.
      ENDLOOP.

    ENDIF.

* End of: to be replaced on sync with hash method or other

    es_db_question = ls_db_question.
    et_db_variant[] = lt_db_variant[].

  ENDMETHOD.


  METHOD question_delete.

    DATA: ls_db_question TYPE znept_qz_qst,
          lv_dummy       TYPE i.

    REFRESH et_messages.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_question-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_qst INTO ls_db_question
      WHERE test_id     = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_not_exist ) TO et_messages.
      RETURN.
    ENDIF.

    DELETE FROM znept_qz_qst WHERE test_id     = is_db_question-test_id
                               AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_delete_error ) TO et_messages.
      RETURN.
    ENDIF.

    SELECT COUNT( * ) FROM znept_qz_var INTO lv_dummy
      WHERE test_id     = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc = 0.

      DELETE FROM znept_qz_var WHERE test_id     = is_db_question-test_id
                                 AND question_id = is_db_question-question_id.
      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_delete_error ) TO et_messages.
      ENDIF.

    ENDIF.

* Begin of: to be replaced on sync with hash method or other

    IF et_messages[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_cds=>question_set_change
        EXPORTING
          is_db_question = ls_db_question
          iv_deleted     = abap_true
        IMPORTING
          et_messages    = et_messages.

    ENDIF.

* End of: to be replaced on sync with hash method or other

  ENDMETHOD.


  METHOD question_update.

    DATA: ls_db_question TYPE znept_qz_qst.

    REFRESH et_messages.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_question-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_qst INTO ls_db_question
      WHERE test_id     = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_not_exist ) TO et_messages.
      RETURN.
    ENDIF.

    UPDATE znept_qz_qst
      SET   question    = is_db_question-question
            explanation = is_db_question-explanation
      WHERE test_id     = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_update_error ) TO et_messages.
    ENDIF.

* Begin of: to be replaced on sync with hash method or other

    IF et_messages[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_cds=>question_set_change
        EXPORTING
          is_db_question = ls_db_question
        IMPORTING
          et_messages    = et_messages.

    ENDIF.

* End of: to be replaced on sync with hash method or other

  ENDMETHOD.


  METHOD quiz_create.

    DATA: lt_db_parts     TYPE znept_qz_db_parts_t,
          lt_db_questions TYPE znept_qz_db_questions_t,
          lt_db_variants  TYPE znept_qz_db_variants_t,
          lv_db_error     TYPE abap_bool,
          lv_do_commit    TYPE abap_bool.

    REFRESH et_messages.

    CLEAR es_db_quiz.

    CALL METHOD zcl_nept_qz_data_provider=>add
      EXPORTING
        iv_description  = is_db_quiz-description
        iv_published    = abap_false
        it_db_parts     = lt_db_parts
        it_db_questions = lt_db_questions
        it_db_variants  = lt_db_variants
      IMPORTING
        es_db_tests     = es_db_quiz
        ev_db_error     = lv_db_error
        ev_do_commit    = lv_do_commit.

    IF lv_db_error = abap_true OR lv_do_commit = abap_false.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_create_error ) TO et_messages.
    ENDIF.

  ENDMETHOD.


  METHOD quiz_delete.

    DATA: ls_db_tests_key TYPE znept_qz_db_tests_key_s,
          lv_db_error     TYPE abap_bool,
          lv_do_commit    TYPE abap_bool.

    REFRESH et_messages.

    IF is_db_quiz-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR ls_db_tests_key.
    ls_db_tests_key-test_id = is_db_quiz-test_id.

    CALL METHOD zcl_nept_qz_data_provider=>delete
      EXPORTING
        is_db_tests_key = ls_db_tests_key
      IMPORTING
        ev_db_error     = lv_db_error
        ev_do_commit    = lv_do_commit.

    IF lv_db_error = abap_true OR lv_do_commit = abap_false.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_delete_error ) TO et_messages.
    ENDIF.

  ENDMETHOD.


  METHOD quiz_update.

    DATA: ls_db_tests_key TYPE znept_qz_db_tests_key_s,
          lv_description  TYPE znept_qz_test_name_de,
          lv_db_error     TYPE abap_bool,
          lv_do_commit    TYPE abap_bool.

    REFRESH et_messages.

    IF is_db_quiz-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    ls_db_tests_key-test_id = is_db_quiz-test_id.
    lv_description = is_db_quiz-description.

    CALL METHOD zcl_nept_qz_data_provider=>rename
      EXPORTING
        is_db_tests_key = ls_db_tests_key
        iv_description  = lv_description
      IMPORTING
        ev_db_error     = lv_db_error
        ev_do_commit    = lv_do_commit.

    IF lv_db_error = abap_true OR lv_do_commit = abap_false.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_update_error ) TO et_messages.
    ENDIF.

  ENDMETHOD.


  METHOD variant_create.

    DATA: ls_db_variant TYPE znept_qz_db_variants_s.

    REFRESH et_messages.

    CLEAR es_db_variant.

    IF is_db_variant-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    ls_db_variant-test_id     = is_db_variant-test_id.
    ls_db_variant-question_id = is_db_variant-question_id.
    ls_db_variant-variant     = is_db_variant-variant.
    ls_db_variant-correct     = is_db_variant-correct.
    ls_db_variant-sort        = is_db_variant-sort.

    SELECT MAX( variant_id ) FROM znept_qz_var INTO ls_db_variant-variant_id
      WHERE test_id     = ls_db_variant-test_id
        AND question_id = ls_db_variant-question_id.

    IF sy-subrc <> 0.
      ls_db_variant-variant_id = 0.
    ENDIF.

    ls_db_variant-variant_id = ls_db_variant-variant_id + 1.

*    DO.
*      ls_db_variant-variant_id = ls_db_variant-variant_id + 1.
*      SELECT variant_id UP TO 1 ROWS FROM znept_qz_var INTO ls_db_variant-variant_id
*        WHERE test_id     = ls_db_variant-test_id
*          AND question_id = ls_db_variant-question_id
*          AND variant_id  = ls_db_variant-variant_id.
*      ENDSELECT.
*      IF sy-subrc <> 0.
*        EXIT.
*      ENDIF.
*    ENDDO.

    IF ls_db_variant-sort = ls_db_variant-variant_id.
      CLEAR ls_db_variant-sort.
    ENDIF.

    INSERT znept_qz_var FROM ls_db_variant.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_create_error ) TO et_messages.
      RETURN.
    ENDIF.

* Begin of: to be replaced on sync with hash method or other

    CALL METHOD zcl_nept_qz_data_cds=>variant_set_change
      EXPORTING
        is_db_variant = ls_db_variant
      IMPORTING
        et_messages   = et_messages.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

* End of: to be replaced on sync with hash method or other

    es_db_variant = ls_db_variant.

  ENDMETHOD.


  METHOD variant_delete.

    REFRESH et_messages.

    IF is_db_variant-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-variant_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    DELETE FROM znept_qz_var
      WHERE test_id     = is_db_variant-test_id
        AND question_id = is_db_variant-question_id
        AND variant_id  = is_db_variant-variant_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_delete_error ) TO et_messages.
    ENDIF.

* Begin of: to be replaced on sync with hash method or other

    IF et_messages[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_cds=>variant_set_change
        EXPORTING
          is_db_variant = is_db_variant
          iv_deleted    = abap_true
        IMPORTING
          et_messages   = et_messages.

    ENDIF.

* End of: to be replaced on sync with hash method or other

  ENDMETHOD.


  METHOD variant_update.

    REFRESH et_messages.

    IF is_db_variant-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-variant_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    UPDATE znept_qz_var
      SET variant = is_db_variant-variant
          correct = is_db_variant-correct
      WHERE test_id     = is_db_variant-test_id
        AND question_id = is_db_variant-question_id
        AND variant_id  = is_db_variant-variant_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_update_error ) TO et_messages.
    ENDIF.

* Begin of: to be replaced on sync with hash method or other

    IF et_messages[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_cds=>variant_set_change
        EXPORTING
          is_db_variant = is_db_variant
        IMPORTING
          et_messages   = et_messages.

    ENDIF.

* End of: to be replaced on sync with hash method or other

  ENDMETHOD.


  METHOD convert_messages.

    DATA ls_message TYPE symsg.

    REFRESH et_messages.

    LOOP AT it_messages INTO DATA(lr_error).
      CLEAR ls_message.
      ls_message-msgty = 'E'.
      ls_message-msgid = lr_error->t100key-msgid.
      ls_message-msgno = lr_error->t100key-msgno.
      IF lr_error IS INSTANCE OF zcx_nept_qz_cds.
        DATA(lx) = CAST zcx_nept_qz_cds( lr_error ).
        ls_message-msgv1 = _resolve_attribute( iv_attrname = lr_error->t100key-attr1  ix = lx ).
        ls_message-msgv2 = _resolve_attribute( iv_attrname = lr_error->t100key-attr2  ix = lx ).
        ls_message-msgv3 = _resolve_attribute( iv_attrname = lr_error->t100key-attr3  ix = lx ).
        ls_message-msgv4 = _resolve_attribute( iv_attrname = lr_error->t100key-attr4  ix = lx ).
      ENDIF.
      APPEND ls_message TO et_messages.
    ENDLOOP.

  ENDMETHOD.


  METHOD quiz_publish.

    DATA: ls_db_tests_key TYPE znept_qz_db_tests_key_s,
          lv_published    TYPE abap_bool,
          lv_db_error     TYPE abap_bool,
          lv_do_commit    TYPE abap_bool.

    REFRESH et_messages.

    IF is_db_quiz-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR ls_db_tests_key.
    ls_db_tests_key-test_id = is_db_quiz-test_id.
    lv_published = is_db_quiz-published.

    CALL METHOD zcl_nept_qz_data_provider=>publish
      EXPORTING
        is_db_tests_key = ls_db_tests_key
        iv_published    = lv_published
      IMPORTING
        ev_db_error     = lv_db_error
        ev_do_commit    = lv_do_commit.

    IF lv_db_error = abap_true OR lv_do_commit = abap_false.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_publish_error ) TO et_messages.
    ENDIF.

  ENDMETHOD.


  METHOD _resolve_attribute.

    CLEAR rv_symsgv.

    CASE iv_attrname.
      WHEN ''.
        rv_symsgv = ''.
      WHEN 'MV_QUIZ_ID'.
        rv_symsgv = |{ ix->mv_quiz_id ALPHA = OUT }|.
      WHEN 'MV_PART_ID'.
        rv_symsgv = |{ ix->mv_part_id ALPHA = OUT }|.
      WHEN 'MV_QUESTION_ID'.
        rv_symsgv = |{ ix->mv_question_id ALPHA = OUT }|.
      WHEN 'MV_VARIANT_ID'.
        rv_symsgv = |{ ix->mv_variant_id ALPHA = OUT }|.
      WHEN 'MV_UNAME'.
        rv_symsgv = ix->mv_uname.
      WHEN OTHERS.
        ASSERT 1 = 2.
    ENDCASE.

  ENDMETHOD.


  METHOD quiz_read.

    REFRESH et_messages.

    CLEAR es_db_quiz.

    IF is_db_quiz-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_tst INTO es_db_quiz
      WHERE test_id = is_db_quiz-test_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_not_exist ) TO et_messages.
    ENDIF.

  ENDMETHOD.


  METHOD part_read.

    REFRESH et_messages.

    CLEAR es_db_part.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_part-part_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_prt INTO es_db_part
      WHERE test_id = is_db_part-test_id
        AND part_id = is_db_part-part_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_not_exist ) TO et_messages.
    ENDIF.

    IF es_db_part-sort IS INITIAL.
      es_db_part-sort = es_db_part-part_id.
    ENDIF.

  ENDMETHOD.


  METHOD question_read.

    REFRESH et_messages.

    CLEAR es_db_question.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_question-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_qst INTO es_db_question
      WHERE test_id     = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_not_exist ) TO et_messages.
      RETURN.
    ENDIF.

    IF es_db_question-sort IS INITIAL.
      es_db_question-sort = es_db_question-question_id.
    ENDIF.

    SELECT * FROM znept_qz_var INTO TABLE et_db_variant
      WHERE test_id     = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      REFRESH et_db_variant.
    ENDIF.

  ENDMETHOD.


  METHOD variant_read.

    REFRESH et_messages.

    CLEAR es_db_variant.

    IF is_db_variant-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-variant_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_var INTO es_db_variant
      WHERE test_id     = is_db_variant-test_id
        AND question_id = is_db_variant-question_id
        AND variant_id  = is_db_variant-variant_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_not_exist ) TO et_messages.
    ENDIF.

    IF es_db_variant-sort IS INITIAL.
      es_db_variant-sort = es_db_variant-variant_id.
    ENDIF.

  ENDMETHOD.


  METHOD quiz_has_parts.

    DATA: ls_db_quiz TYPE znept_qz_tst,
          ls_db_part TYPE znept_qz_prt.

    REFRESH et_messages.

    CLEAR ev_has_parts.

    IF is_db_quiz-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_tst INTO ls_db_quiz
      WHERE test_id = is_db_quiz-test_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_not_exist ) TO et_messages.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_prt INTO ls_db_part
      WHERE test_id = is_db_quiz-test_id.

    IF sy-subrc = 0.
      ev_has_parts = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD question_assign.

    DATA: ls_db_question TYPE znept_qz_qst,
          ls_db_part     TYPE znept_qz_prt.

    REFRESH et_messages.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_question-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_qst INTO ls_db_question
      WHERE test_id     = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_not_exist ) TO et_messages.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_prt INTO ls_db_part
      WHERE test_id = is_db_question-test_id
        AND part_id = iv_new_part_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_not_exist ) TO et_messages.
      RETURN.
    ENDIF.

    UPDATE znept_qz_qst
      SET part_id = iv_new_part_id
      WHERE test_id     = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_update_error ) TO et_messages.
    ENDIF.

* Begin of: to be replaced on sync with hash method or other

    IF et_messages[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_cds=>question_set_change
        EXPORTING
          is_db_question = ls_db_question
        IMPORTING
          et_messages    = et_messages.

    ENDIF.

* End of: to be replaced on sync with hash method or other

  ENDMETHOD.


  METHOD question_ord_features.

    DATA: lt_db_question TYPE znept_qz_db_questions_t,
          lv_part_id     TYPE znept_qz_part_id_de.

    REFRESH et_messages.

    CLEAR: ev_ord_up, ev_ord_down.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_question-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE part_id FROM znept_qz_qst INTO lv_part_id
      WHERE test_id = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc = 0.

      SELECT * FROM znept_qz_qst INTO TABLE lt_db_question
        WHERE test_id = is_db_question-test_id
          AND part_id = lv_part_id.

      IF sy-subrc = 0.
        LOOP AT lt_db_question ASSIGNING FIELD-SYMBOL(<fs_db_question>).
          IF <fs_db_question>-sort IS INITIAL.
            <fs_db_question>-sort = <fs_db_question>-question_id.
          ENDIF.
        ENDLOOP.

        SORT lt_db_question BY sort ASCENDING.
        READ TABLE lt_db_question INDEX 1 ASSIGNING <fs_db_question>.
        IF sy-subrc = 0 AND <fs_db_question> IS ASSIGNED.
          IF <fs_db_question>-question_id <> is_db_question-question_id.
            ev_ord_up = abap_true.
          ENDIF.
        ENDIF.

        SORT lt_db_question BY sort DESCENDING.
        READ TABLE lt_db_question INDEX 1 ASSIGNING <fs_db_question>.
        IF sy-subrc = 0 AND <fs_db_question> IS ASSIGNED.
          IF <fs_db_question>-question_id <> is_db_question-question_id.
            ev_ord_down = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD part_ord_features.

    DATA: lt_db_part TYPE znept_qz_db_parts_t.

    REFRESH et_messages.

    CLEAR: ev_ord_up, ev_ord_down.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_part-part_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM znept_qz_prt INTO TABLE lt_db_part
      WHERE test_id = is_db_part-test_id.

    IF sy-subrc = 0.

      LOOP AT lt_db_part ASSIGNING FIELD-SYMBOL(<fs_db_part>).
        IF <fs_db_part>-sort IS INITIAL.
          <fs_db_part>-sort = <fs_db_part>-part_id.
        ENDIF.
      ENDLOOP.

      SORT lt_db_part BY sort ASCENDING.
      READ TABLE lt_db_part INDEX 1 ASSIGNING <fs_db_part>.
      IF sy-subrc = 0 AND <fs_db_part> IS ASSIGNED.
        IF <fs_db_part>-part_id <> is_db_part-part_id.
          ev_ord_up = abap_true.
        ENDIF.
      ENDIF.

      SORT lt_db_part BY sort DESCENDING.
      READ TABLE lt_db_part INDEX 1 ASSIGNING <fs_db_part>.
      IF sy-subrc = 0 AND <fs_db_part> IS ASSIGNED.
        IF <fs_db_part>-part_id <> is_db_part-part_id.
          ev_ord_down = abap_true.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD part_ord_update.

    DATA: ls_db_part_a TYPE znept_qz_db_parts_s,
          ls_db_part_b TYPE znept_qz_db_parts_s,
          lt_db_part   TYPE znept_qz_db_parts_t,
          lv_sort_a    TYPE znept_qz_part_ord_de,
          lv_sort_b    TYPE znept_qz_part_ord_de.

    REFRESH et_messages.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_part-part_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CALL METHOD zcl_nept_qz_data_cds=>part_read
      EXPORTING
        is_db_part  = is_db_part
      IMPORTING
        es_db_part  = ls_db_part_a
        et_messages = et_messages.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM znept_qz_prt INTO TABLE lt_db_part
      WHERE test_id = is_db_part-test_id.

    IF sy-subrc = 0.

      LOOP AT lt_db_part ASSIGNING FIELD-SYMBOL(<fs_db_part>).
        IF <fs_db_part>-sort IS INITIAL.
          <fs_db_part>-sort = <fs_db_part>-part_id.
        ENDIF.
      ENDLOOP.

      IF iv_down = abap_true.
        IF iv_bottom = abap_true.
          SORT lt_db_part BY sort DESCENDING.
        ELSE.
          SORT lt_db_part BY sort ASCENDING.
          DELETE lt_db_part WHERE sort <= ls_db_part_a-sort.
        ENDIF.
      ELSE.
        IF iv_bottom = abap_true.
          SORT lt_db_part BY sort ASCENDING.
        ELSE.
          SORT lt_db_part BY sort DESCENDING.
          DELETE lt_db_part WHERE sort >= ls_db_part_a-sort.
        ENDIF.
      ENDIF.

      IF NOT lt_db_part[] IS INITIAL.
        READ TABLE lt_db_part INDEX 1 INTO ls_db_part_b.
        IF sy-subrc = 0 AND ls_db_part_a-part_id <> ls_db_part_b-part_id.

          lv_sort_a = ls_db_part_a-sort.
          lv_sort_b = ls_db_part_b-sort.

          IF ls_db_part_a-part_id = lv_sort_b.
            CLEAR ls_db_part_a-sort.
          ELSE.
            ls_db_part_a-sort = lv_sort_b.
          ENDIF.

          IF ls_db_part_b-part_id = lv_sort_a.
            CLEAR ls_db_part_b-sort.
          ELSE.
            ls_db_part_b-sort = lv_sort_a.
          ENDIF.

          UPDATE znept_qz_prt
            SET sort = ls_db_part_a-sort
            WHERE test_id = ls_db_part_a-test_id
              AND part_id = ls_db_part_a-part_id.

          IF sy-subrc <> 0.
            APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_update_error ) TO et_messages.
            RETURN.
          ENDIF.

          UPDATE znept_qz_prt
            SET sort = ls_db_part_b-sort
            WHERE test_id = ls_db_part_b-test_id
              AND part_id = ls_db_part_b-part_id.

          IF sy-subrc <> 0.
            APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_update_error ) TO et_messages.
          ENDIF.

* Begin of: to be replaced on sync with hash method or other

          CALL METHOD zcl_nept_qz_data_cds=>part_set_change
            EXPORTING
              is_db_part  = ls_db_part_a
            IMPORTING
              et_messages = et_messages.

          IF et_messages[] IS INITIAL.

            CALL METHOD zcl_nept_qz_data_cds=>part_set_change
              EXPORTING
                is_db_part  = ls_db_part_b
              IMPORTING
                et_messages = et_messages.

          ENDIF.

* End of: to be replaced on sync with hash method or other

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD question_ord_update.

    DATA: ls_db_question_a TYPE znept_qz_db_questions_s,
          ls_db_question_b TYPE znept_qz_db_questions_s,
          lt_db_question   TYPE znept_qz_db_questions_t,
          lv_sort_a        TYPE znept_qz_question_ord_de,
          lv_sort_b        TYPE znept_qz_question_ord_de.

    REFRESH et_messages.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_question-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CALL METHOD zcl_nept_qz_data_cds=>question_read
      EXPORTING
        is_db_question = is_db_question
      IMPORTING
        es_db_question = ls_db_question_a
        et_messages    = et_messages.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM znept_qz_qst INTO TABLE lt_db_question
      WHERE test_id = is_db_question-test_id
        AND part_id = ls_db_question_a-part_id.

    IF sy-subrc = 0.

      LOOP AT lt_db_question ASSIGNING FIELD-SYMBOL(<fs_db_question>).
        IF <fs_db_question>-sort IS INITIAL.
          <fs_db_question>-sort = <fs_db_question>-question_id.
        ENDIF.
      ENDLOOP.

      IF iv_down = abap_true.
        IF iv_bottom = abap_true.
          SORT lt_db_question BY sort DESCENDING.
        ELSE.
          SORT lt_db_question BY sort ASCENDING.
          DELETE lt_db_question WHERE sort <= ls_db_question_a-sort.
        ENDIF.
      ELSE.
        IF iv_bottom = abap_true.
          SORT lt_db_question BY sort ASCENDING.
        ELSE.
          SORT lt_db_question BY sort DESCENDING.
          DELETE lt_db_question WHERE sort >= ls_db_question_a-sort.
        ENDIF.
      ENDIF.

      IF NOT lt_db_question[] IS INITIAL.
        READ TABLE lt_db_question INDEX 1 INTO ls_db_question_b.
        IF sy-subrc = 0 AND ls_db_question_a-question_id <> ls_db_question_b-question_id.

          lv_sort_a = ls_db_question_a-sort.
          lv_sort_b = ls_db_question_b-sort.

          IF ls_db_question_a-question_id = lv_sort_b.
            CLEAR ls_db_question_a-sort.
          ELSE.
            ls_db_question_a-sort = lv_sort_b.
          ENDIF.

          IF ls_db_question_b-question_id = lv_sort_a.
            CLEAR ls_db_question_b-sort.
          ELSE.
            ls_db_question_b-sort = lv_sort_a.
          ENDIF.

          UPDATE znept_qz_qst
            SET sort = ls_db_question_a-sort
            WHERE test_id     = ls_db_question_a-test_id
              AND question_id = ls_db_question_a-question_id.

          IF sy-subrc <> 0.
            APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_update_error ) TO et_messages.
            RETURN.
          ENDIF.

          UPDATE znept_qz_qst
            SET sort = ls_db_question_b-sort
            WHERE test_id     = ls_db_question_b-test_id
              AND question_id = ls_db_question_b-question_id.

          IF sy-subrc <> 0.
            APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_update_error ) TO et_messages.
            RETURN.
          ENDIF.

* Begin of: to be replaced on sync with hash method or other

          CALL METHOD zcl_nept_qz_data_cds=>question_set_change
            EXPORTING
              is_db_question = ls_db_question_a
            IMPORTING
              et_messages    = et_messages.

          IF et_messages[] IS INITIAL.

            CALL METHOD zcl_nept_qz_data_cds=>question_set_change
              EXPORTING
                is_db_question = ls_db_question_b
              IMPORTING
                et_messages    = et_messages.

          ENDIF.

* End of: to be replaced on sync with hash method or other

        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD variant_ord_features.

    DATA: lt_db_variant TYPE znept_qz_db_variants_t.

    REFRESH et_messages.

    CLEAR: ev_ord_up, ev_ord_down.

    IF is_db_variant-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-variant_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM znept_qz_var INTO TABLE lt_db_variant
      WHERE test_id = is_db_variant-test_id
        AND question_id = is_db_variant-question_id.

    IF sy-subrc = 0.

      LOOP AT lt_db_variant ASSIGNING FIELD-SYMBOL(<fs_db_variant>).
        IF <fs_db_variant>-sort IS INITIAL.
          <fs_db_variant>-sort = <fs_db_variant>-variant_id.
        ENDIF.
      ENDLOOP.

      SORT lt_db_variant BY sort ASCENDING.
      READ TABLE lt_db_variant INDEX 1 ASSIGNING <fs_db_variant>.
      IF sy-subrc = 0 AND <fs_db_variant> IS ASSIGNED.
        IF <fs_db_variant>-variant_id <> is_db_variant-variant_id.
          ev_ord_up = abap_true.
        ENDIF.
      ENDIF.

      SORT lt_db_variant BY sort DESCENDING.
      READ TABLE lt_db_variant INDEX 1 ASSIGNING <fs_db_variant>.
      IF sy-subrc = 0 AND <fs_db_variant> IS ASSIGNED.
        IF <fs_db_variant>-variant_id <> is_db_variant-variant_id.
          ev_ord_down = abap_true.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD variant_ord_update.

    DATA: ls_db_variant_a TYPE znept_qz_db_variants_s,
          ls_db_variant_b TYPE znept_qz_db_variants_s,
          lt_db_variant   TYPE znept_qz_db_variants_t,
          lv_sort_a       TYPE znept_qz_variant_ord_de,
          lv_sort_b       TYPE znept_qz_variant_ord_de.

    REFRESH et_messages.

    IF is_db_variant-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-variant_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CALL METHOD zcl_nept_qz_data_cds=>variant_read
      EXPORTING
        is_db_variant = is_db_variant
      IMPORTING
        es_db_variant = ls_db_variant_a
        et_messages   = et_messages.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM znept_qz_var INTO TABLE lt_db_variant
      WHERE test_id = is_db_variant-test_id
        AND question_id = is_db_variant-question_id.

    IF sy-subrc = 0.

      LOOP AT lt_db_variant ASSIGNING FIELD-SYMBOL(<fs_db_variant>).
        IF <fs_db_variant>-sort IS INITIAL.
          <fs_db_variant>-sort = <fs_db_variant>-variant_id.
        ENDIF.
      ENDLOOP.

      IF iv_down = abap_true.
        IF iv_bottom = abap_true.
          SORT lt_db_variant BY sort DESCENDING.
        ELSE.
          SORT lt_db_variant BY sort ASCENDING.
          DELETE lt_db_variant WHERE sort <= ls_db_variant_a-sort.
        ENDIF.
      ELSE.
        IF iv_bottom = abap_true.
          SORT lt_db_variant BY sort ASCENDING.
        ELSE.
          SORT lt_db_variant BY sort DESCENDING.
          DELETE lt_db_variant WHERE sort >= ls_db_variant_a-sort.
        ENDIF.
      ENDIF.

      IF NOT lt_db_variant[] IS INITIAL.
        READ TABLE lt_db_variant INDEX 1 INTO ls_db_variant_b.
        IF sy-subrc = 0 AND ls_db_variant_a-variant_id <> ls_db_variant_b-variant_id.

          lv_sort_a = ls_db_variant_a-sort.
          lv_sort_b = ls_db_variant_b-sort.

          IF ls_db_variant_a-variant_id = lv_sort_b.
            CLEAR ls_db_variant_a-sort.
          ELSE.
            ls_db_variant_a-sort = lv_sort_b.
          ENDIF.

          IF ls_db_variant_b-variant_id = lv_sort_a.
            CLEAR ls_db_variant_b-sort.
          ELSE.
            ls_db_variant_b-sort = lv_sort_a.
          ENDIF.

          UPDATE znept_qz_var
            SET sort = ls_db_variant_a-sort
            WHERE test_id     = ls_db_variant_a-test_id
              AND question_id = ls_db_variant_a-question_id
              AND variant_id  = ls_db_variant_a-variant_id.

          IF sy-subrc <> 0.
            APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_update_error ) TO et_messages.
            RETURN.
          ENDIF.

          UPDATE znept_qz_var
            SET sort = ls_db_variant_b-sort
            WHERE test_id     = ls_db_variant_b-test_id
              AND question_id = ls_db_variant_b-question_id
              AND variant_id  = ls_db_variant_b-variant_id.

          IF sy-subrc <> 0.
            APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_update_error ) TO et_messages.
          ENDIF.

* Begin of: to be replaced on sync with hash method or other

          CALL METHOD zcl_nept_qz_data_cds=>variant_set_change
            EXPORTING
              is_db_variant = ls_db_variant_a
            IMPORTING
              et_messages   = et_messages.

          IF et_messages[] IS INITIAL.

            CALL METHOD zcl_nept_qz_data_cds=>variant_set_change
              EXPORTING
                is_db_variant = ls_db_variant_b
              IMPORTING
                et_messages   = et_messages.

          ENDIF.

* End of: to be replaced on sync with hash method or other

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD question_renew.

    DATA: ls_db_question TYPE znept_qz_db_questions_s,
          lt_db_variant  TYPE znept_qz_db_variants_t.

    REFRESH et_messages.

    CALL METHOD zcl_nept_qz_data_cds=>question_read
      EXPORTING
        is_db_question = is_db_question
      IMPORTING
        es_db_question = ls_db_question
        et_db_variant  = lt_db_variant
        et_messages    = et_messages.

    IF et_messages[] IS INITIAL.

      CALL METHOD zcl_nept_qz_data_cds=>question_create
        EXPORTING
          is_db_question = ls_db_question
          it_db_variant  = lt_db_variant
        IMPORTING
          et_messages    = et_messages.

      IF et_messages[] IS INITIAL.

        CALL METHOD zcl_nept_qz_data_cds=>question_delete
          EXPORTING
            is_db_question = is_db_question
          IMPORTING
            et_messages    = et_messages.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD question_set_change.

* to be replaced on sync with hash method or other

    DATA: ls_db_quiz_key TYPE znept_qz_db_tests_key_s,
          ls_db_question TYPE znept_qz_db_questions_s,
          lv_version     TYPE znept_qz_count_version_de.

    REFRESH et_messages.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_question-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR ls_db_quiz_key.
    ls_db_quiz_key-test_id = is_db_question-test_id.

    CALL METHOD zcl_nept_qz_data_cds=>quiz_set_change
      EXPORTING
        is_db_quiz_key = ls_db_quiz_key
      IMPORTING
        ev_version     = lv_version
        et_messages    = et_messages.

    IF et_messages[] IS INITIAL AND iv_deleted IS INITIAL.

      SELECT SINGLE * FROM znept_qz_qst INTO ls_db_question
        WHERE test_id     = is_db_question-test_id
          AND question_id = is_db_question-question_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_not_exist ) TO et_messages.
        RETURN.
      ENDIF.

      UPDATE znept_qz_qst
        SET   version     = lv_version
        WHERE test_id     = is_db_question-test_id
          AND question_id = is_db_question-question_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_update_error ) TO et_messages.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD part_set_change.

* to be replaced on sync with hash method or other

    DATA: ls_db_quiz_key TYPE znept_qz_db_tests_key_s,
          ls_db_part     TYPE znept_qz_db_parts_s,
          lv_version     TYPE znept_qz_count_version_de.

    REFRESH et_messages.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_part-part_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR ls_db_quiz_key.
    ls_db_quiz_key-test_id = is_db_part-test_id.

    CALL METHOD zcl_nept_qz_data_cds=>quiz_set_change
      EXPORTING
        is_db_quiz_key = ls_db_quiz_key
      IMPORTING
        ev_version     = lv_version
        et_messages    = et_messages.

    IF et_messages[] IS INITIAL AND iv_deleted IS INITIAL.

      SELECT SINGLE * FROM znept_qz_prt INTO ls_db_part
        WHERE test_id     = is_db_part-test_id
          AND part_id = is_db_part-part_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_not_exist ) TO et_messages.
        RETURN.
      ENDIF.

      UPDATE znept_qz_prt
        SET   version = lv_version
        WHERE test_id = is_db_part-test_id
          AND part_id = is_db_part-part_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_update_error ) TO et_messages.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD quiz_set_change.

* to be replaced on sync with hash method or other

    DATA: lv_version      TYPE znept_qz_count_version_de.

    REFRESH et_messages.

    CLEAR ev_version.

    IF is_db_quiz_key-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE version FROM znept_qz_tst INTO lv_version
      WHERE test_id = is_db_quiz_key-test_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_not_exist ) TO et_messages.
    ENDIF.

    IF et_messages[] IS INITIAL.

      lv_version = lv_version + 1.

      UPDATE znept_qz_tst
        SET version = lv_version
        WHERE test_id = is_db_quiz_key-test_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_update_error ) TO et_messages.
      ENDIF.

    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    ev_version = lv_version.

  ENDMETHOD.


  METHOD variant_set_change.

* to be replaced on sync with hash method or other

    DATA: ls_db_quiz_key TYPE znept_qz_db_tests_key_s,
          ls_db_variant  TYPE znept_qz_db_variants_s,
          lv_version     TYPE znept_qz_count_version_de.

    REFRESH et_messages.

    IF is_db_variant-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-variant_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_key_initial ) TO et_messages.
    ENDIF.

    IF NOT et_messages[] IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR ls_db_quiz_key.
    ls_db_quiz_key-test_id = is_db_variant-test_id.

    CALL METHOD zcl_nept_qz_data_cds=>quiz_set_change
      EXPORTING
        is_db_quiz_key = ls_db_quiz_key
      IMPORTING
        ev_version     = lv_version
        et_messages    = et_messages.

    IF et_messages[] IS INITIAL AND iv_deleted IS INITIAL.

      SELECT SINGLE * FROM znept_qz_var INTO ls_db_variant
        WHERE test_id     = is_db_variant-test_id
          AND question_id = is_db_variant-question_id
          AND variant_id  = is_db_variant-variant_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_not_exist ) TO et_messages.
        RETURN.
      ENDIF.

      UPDATE znept_qz_var
        SET   version = lv_version
        WHERE test_id     = is_db_variant-test_id
          AND question_id = is_db_variant-question_id
          AND variant_id  = is_db_variant-variant_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_update_error ) TO et_messages.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
