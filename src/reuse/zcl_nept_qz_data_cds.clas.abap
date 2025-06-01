CLASS zcl_nept_qz_data_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS part_read
      IMPORTING
        !is_db_part  TYPE znept_qz_db_parts_s
      EXPORTING
        !es_db_part  TYPE znept_qz_db_parts_s
        !et_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS question_read
      IMPORTING
        !is_db_question TYPE znept_qz_db_questions_s
      EXPORTING
        !es_db_question TYPE znept_qz_db_questions_s
        !et_messages    TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS quiz_create
      IMPORTING
        !is_db_quiz  TYPE znept_qz_db_tests_s
      EXPORTING
        !es_db_quiz  TYPE znept_qz_db_tests_s
        !et_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS quiz_has_parts
      IMPORTING
        !is_db_quiz   TYPE znept_qz_db_tests_s
      EXPORTING
        !ev_has_parts TYPE abap_bool
        !et_messages  TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS quiz_read
      IMPORTING
        !is_db_quiz  TYPE znept_qz_db_tests_s
      EXPORTING
        !es_db_quiz  TYPE znept_qz_db_tests_s
        !et_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS variant_read
      IMPORTING
        !is_db_variant TYPE znept_qz_db_variants_s
      EXPORTING
        !es_db_variant TYPE znept_qz_db_variants_s
        !et_messages   TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS quiz_update
      IMPORTING
        !is_db_quiz  TYPE znept_qz_db_tests_s
      EXPORTING
        !et_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS quiz_delete
      IMPORTING
        !is_db_quiz  TYPE znept_qz_db_tests_s
      EXPORTING
        !et_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS quiz_publish
      IMPORTING
        !is_db_quiz  TYPE znept_qz_db_tests_s
      EXPORTING
        !et_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS part_create
      IMPORTING
        !is_db_part  TYPE znept_qz_db_parts_s
      EXPORTING
        !es_db_part  TYPE znept_qz_db_parts_s
        !et_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS part_update
      IMPORTING
        !is_db_part  TYPE znept_qz_db_parts_s
      EXPORTING
        !et_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS part_delete
      IMPORTING
        !is_db_part  TYPE znept_qz_db_parts_s
      EXPORTING
        !et_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS question_create
      IMPORTING
        !is_db_question TYPE znept_qz_db_questions_s
      EXPORTING
        !es_db_question TYPE znept_qz_db_questions_s
        !et_messages    TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS question_assign
      IMPORTING
        !is_db_question TYPE znept_qz_db_questions_s
        !iv_new_part_id TYPE znept_qz_part_id_de
      EXPORTING
        !et_messages    TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS question_update
      IMPORTING
        !is_db_question TYPE znept_qz_db_questions_s
      EXPORTING
        !et_messages    TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS question_delete
      IMPORTING
        !is_db_question TYPE znept_qz_db_questions_s
      EXPORTING
        !et_messages    TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS variant_create
      IMPORTING
        !is_db_variant TYPE znept_qz_db_variants_s
      EXPORTING
        !es_db_variant TYPE znept_qz_db_variants_s
        !et_messages   TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS variant_update
      IMPORTING
        !is_db_variant TYPE znept_qz_db_variants_s
      EXPORTING
        !et_messages   TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS variant_delete
      IMPORTING
        !is_db_variant TYPE znept_qz_db_variants_s
      EXPORTING
        !et_messages   TYPE zif_nept_qz_quiz_const=>tt_if_t100_message .
    CLASS-METHODS convert_messages
      IMPORTING
        !it_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message
      EXPORTING
        !et_messages TYPE symsg_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-METHODS _resolve_attribute
      IMPORTING
        !iv_attrname     TYPE scx_attrname
        !ix              TYPE REF TO zcx_nept_qz_cds
      RETURNING
        VALUE(rv_symsgv) TYPE symsgv .
ENDCLASS.



CLASS ZCL_NEPT_QZ_DATA_CDS IMPLEMENTATION.


  METHOD part_create.

    DATA: ls_db_part TYPE znept_qz_db_parts_s.

    REFRESH et_messages.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    CLEAR es_db_part.

    IF et_messages IS INITIAL.
      ls_db_part-test_id     = is_db_part-test_id.
      ls_db_part-description = is_db_part-description.

      DO.
        ls_db_part-part_id = ls_db_part-part_id + 1.
        SELECT part_id UP TO 1 ROWS FROM znept_qz_prt INTO ls_db_part-part_id
          WHERE test_id = ls_db_part-test_id
            AND part_id = ls_db_part-part_id.
        ENDSELECT.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
      ENDDO.

      INSERT znept_qz_prt FROM ls_db_part.
      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_create_error ) TO et_messages.
      ENDIF.
    ENDIF.

    IF et_messages IS INITIAL.
      es_db_part = ls_db_part.
    ENDIF.

  ENDMETHOD.


  METHOD part_delete.

    DATA: ls_db_question TYPE znept_qz_db_questions_s,
          ls_db_variant  TYPE znept_qz_db_variants_s.

    REFRESH et_messages.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_part-part_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_key_initial ) TO et_messages.
    ENDIF.

    IF et_messages IS INITIAL.

      DELETE FROM znept_qz_prt WHERE test_id = is_db_part-test_id
                                 AND part_id = is_db_part-part_id.
      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_delete_error ) TO et_messages.
      ENDIF.

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

    ENDIF.

  ENDMETHOD.


  METHOD part_update.


    REFRESH et_messages.

    IF is_db_part-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_part-part_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_key_initial ) TO et_messages.
    ENDIF.

    IF et_messages IS INITIAL.

      UPDATE znept_qz_prt
        SET   description = is_db_part-description
        WHERE test_id     = is_db_part-test_id
          AND part_id     = is_db_part-part_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_update_error ) TO et_messages.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD question_create.

    DATA: ls_db_question TYPE znept_qz_db_questions_s.

    REFRESH et_messages.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    CLEAR es_db_question.

    IF et_messages IS INITIAL.
      ls_db_question-test_id     = is_db_question-test_id.
      ls_db_question-part_id     = is_db_question-part_id.
      ls_db_question-question    = is_db_question-question.
      ls_db_question-explanation = is_db_question-explanation.

      DO.
        ls_db_question-question_id = ls_db_question-question_id + 1.
        SELECT question_id UP TO 1 ROWS FROM znept_qz_qst INTO ls_db_question-question_id
          WHERE test_id     = ls_db_question-test_id
            AND part_id     = ls_db_question-part_id
            AND question_id = ls_db_question-question_id.
        ENDSELECT.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
      ENDDO.

      INSERT znept_qz_qst FROM ls_db_question.
      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_create_error ) TO et_messages.
      ENDIF.
    ENDIF.

    IF et_messages IS INITIAL.
      es_db_question = ls_db_question.
    ENDIF.

  ENDMETHOD.


  METHOD question_delete.

    DATA: ls_db_question TYPE znept_qz_qst.

    REFRESH et_messages.

    IF is_db_question-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_question-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    SELECT SINGLE * FROM znept_qz_qst INTO ls_db_question
      WHERE test_id     = is_db_question-test_id
        AND part_id     = is_db_question-part_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_not_exist ) TO et_messages.
    ENDIF.

    IF et_messages IS INITIAL.

      DELETE FROM znept_qz_qst WHERE test_id     = is_db_question-test_id
                                 AND part_id     = is_db_question-part_id
                                 AND question_id = is_db_question-question_id.
      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_delete_error ) TO et_messages.
      ENDIF.

      IF et_messages IS INITIAL.
        DELETE FROM znept_qz_var WHERE test_id     = is_db_question-test_id
                                   AND question_id = is_db_question-question_id.
        IF sy-subrc = 0.
          APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_delete_error ) TO et_messages.
        ENDIF.
      ENDIF.

    ENDIF.


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

    SELECT SINGLE * FROM znept_qz_qst INTO ls_db_question
      WHERE test_id     = is_db_question-test_id
        AND part_id     = is_db_question-part_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_not_exist ) TO et_messages.
    ENDIF.

    IF et_messages IS INITIAL.

      UPDATE znept_qz_qst
        SET   question    = is_db_question-question
              explanation = is_db_question-explanation
        WHERE test_id     = is_db_question-test_id
          AND part_id     = is_db_question-part_id
          AND question_id = is_db_question-question_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_update_error ) TO et_messages.
      ENDIF.

    ENDIF.

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

    IF et_messages[] IS INITIAL.
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

    IF et_messages IS INITIAL.
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
    ENDIF.

  ENDMETHOD.


  METHOD variant_create.

    DATA: ls_db_variant TYPE znept_qz_db_variants_s.

    REFRESH et_messages.

    IF is_db_variant-test_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_key_initial ) TO et_messages.
    ENDIF.

    IF is_db_variant-question_id IS INITIAL.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_key_initial ) TO et_messages.
    ENDIF.

    CLEAR es_db_variant.

    IF et_messages IS INITIAL.
      ls_db_variant-test_id     = is_db_variant-test_id.
      ls_db_variant-question_id = is_db_variant-question_id.
      ls_db_variant-variant     = is_db_variant-variant.
      ls_db_variant-correct     = is_db_variant-correct.

      DO.
        ls_db_variant-variant_id = ls_db_variant-variant_id + 1.
        SELECT variant_id UP TO 1 ROWS FROM znept_qz_var INTO ls_db_variant-variant_id
          WHERE test_id     = ls_db_variant-test_id
            AND question_id = ls_db_variant-question_id
            AND variant_id  = ls_db_variant-variant_id.
        ENDSELECT.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
      ENDDO.

      INSERT znept_qz_var FROM ls_db_variant.
      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_create_error ) TO et_messages.
      ENDIF.
    ENDIF.

    IF et_messages IS INITIAL.
      es_db_variant = ls_db_variant.
    ENDIF.

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

    IF et_messages IS INITIAL.

      DELETE FROM znept_qz_var WHERE test_id     = is_db_variant-test_id
                                 AND question_id = is_db_variant-question_id
                                 AND variant_id  = is_db_variant-variant_id.
      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_delete_error ) TO et_messages.
      ENDIF.

    ENDIF.

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

    IF et_messages IS INITIAL.

      UPDATE znept_qz_var
        SET   variant = is_db_variant-variant
              correct = is_db_variant-correct
        WHERE test_id     = is_db_variant-test_id
          AND question_id = is_db_variant-question_id
          AND variant_id  = is_db_variant-variant_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_update_error ) TO et_messages.
      ENDIF.

    ENDIF.

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

    IF et_messages IS INITIAL.
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

    SELECT SINGLE * FROM znept_qz_tst INTO es_db_quiz
      WHERE test_id = is_db_quiz-test_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_not_exist ) TO et_messages.
    ENDIF.

  ENDMETHOD.


  METHOD part_read.

    REFRESH et_messages.

    CLEAR es_db_part.

    SELECT SINGLE * FROM znept_qz_prt INTO es_db_part
      WHERE test_id = is_db_part-test_id
        AND part_id = is_db_part-part_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_not_exist ) TO et_messages.
    ENDIF.

  ENDMETHOD.


  METHOD question_read.

    REFRESH et_messages.

    CLEAR es_db_question.

    SELECT SINGLE * FROM znept_qz_qst INTO es_db_question
      WHERE test_id     = is_db_question-test_id
        AND part_id     = is_db_question-part_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_not_exist ) TO et_messages.
    ENDIF.

  ENDMETHOD.


  METHOD variant_read.

    REFRESH et_messages.

    CLEAR es_db_variant.

    SELECT SINGLE * FROM znept_qz_var INTO es_db_variant
      WHERE test_id     = is_db_variant-test_id
        AND question_id = is_db_variant-question_id
        AND variant_id  = is_db_variant-variant_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>variant_not_exist ) TO et_messages.
    ENDIF.

  ENDMETHOD.


  METHOD quiz_has_parts.

    DATA: ls_db_quiz TYPE znept_qz_tst,
          ls_db_part TYPE znept_qz_prt.

    REFRESH et_messages.

    CLEAR ev_has_parts.

    SELECT SINGLE * FROM znept_qz_tst INTO ls_db_quiz
      WHERE test_id = is_db_quiz-test_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>quiz_not_exist ) TO et_messages.
    ENDIF.

    IF et_messages[] IS INITIAL.

      SELECT SINGLE * FROM znept_qz_prt INTO ls_db_part
        WHERE test_id = is_db_quiz-test_id.
      IF sy-subrc = 0.
        ev_has_parts = abap_true.
      ENDIF.

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

    SELECT SINGLE * FROM znept_qz_qst INTO ls_db_question
      WHERE test_id     = is_db_question-test_id
        AND question_id = is_db_question-question_id.

    IF sy-subrc <> 0.
      APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_not_exist ) TO et_messages.
    ENDIF.

    IF et_messages IS INITIAL.

      SELECT SINGLE * FROM znept_qz_prt INTO ls_db_part
        WHERE test_id     = is_db_question-test_id
          AND part_id     = iv_new_part_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>part_not_exist ) TO et_messages.
      ENDIF.
    ENDIF.

    IF et_messages IS INITIAL.

      UPDATE znept_qz_qst SET part_id = iv_new_part_id WHERE test_id = is_db_question-test_id
       AND question_id = is_db_question-question_id.

      IF sy-subrc <> 0.
        APPEND NEW zcx_nept_qz_cds( textid = zcx_nept_qz_cds=>question_update_error ) TO et_messages.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
