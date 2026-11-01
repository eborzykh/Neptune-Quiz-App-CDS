CLASS zcx_nept_qz_ai_cds DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .

    CONSTANTS gc_msgid TYPE symsgid VALUE 'ZNEPT_QZ_AI_CDS' ##NO_TEXT.

    CONSTANTS:
      BEGIN OF quiz_no_context,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_no_context.

    CONSTANTS:
      BEGIN OF quiz_not_exist_ref,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '016',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_not_exist_ref.

    CONSTANTS:
      BEGIN OF quiz_is_locked_by,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '032',
        attr1 TYPE scx_attrname VALUE 'MV_QUIZ_ID',
        attr2 TYPE scx_attrname VALUE 'MV_UNAME',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_is_locked_by .

    CONSTANTS:
      BEGIN OF not_authorized,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '046',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_authorized .

    CONSTANTS:
      BEGIN OF quiz_create_error,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '100',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_create_error .

    CONSTANTS:
      BEGIN OF quiz_clone_error,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '101',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_clone_error .

    DATA mv_uname TYPE syuname .
    DATA mv_quiz_id TYPE znept_qz_test_id_de .
    DATA mv_part_id TYPE znept_qz_part_id_de .
    DATA mv_question_id TYPE znept_qz_question_id_de .
    DATA mv_variant_id TYPE znept_qz_variant_id_de .

    METHODS constructor
      IMPORTING
        !textid         LIKE if_t100_message=>t100key OPTIONAL
        !previous       LIKE previous OPTIONAL
        !mv_uname       TYPE syuname OPTIONAL
        !mv_quiz_id     TYPE znept_qz_test_id_de OPTIONAL
        !mv_part_id     TYPE znept_qz_part_id_de OPTIONAL
        !mv_question_id TYPE znept_qz_question_id_de OPTIONAL
        !mv_variant_id  TYPE znept_qz_variant_id_de OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_nept_qz_ai_cds IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    me->mv_uname = mv_uname .
    me->mv_quiz_id = mv_quiz_id .
    me->mv_part_id = mv_part_id .
    me->mv_question_id = mv_question_id .
    me->mv_variant_id = mv_variant_id .
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
