FUNCTION ZNEPT_QZ_QUESTION_ASSIGN.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_DB_QUESTION) TYPE  ZNEPT_QZ_DB_QUESTIONS_S
*"     REFERENCE(IV_NEW_PART_ID) TYPE  ZNEPT_QZ_PART_ID_DE
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"----------------------------------------------------------------------

  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CALL METHOD zcl_nept_qz_data_cds=>question_assign
    EXPORTING
      is_db_question = is_db_question
      iv_new_part_id = iv_new_part_id
    IMPORTING
      et_messages    = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
