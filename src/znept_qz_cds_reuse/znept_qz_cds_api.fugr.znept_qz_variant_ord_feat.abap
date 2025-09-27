FUNCTION znept_qz_variant_ord_feat.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_DB_VARIANT) TYPE  ZNEPT_QZ_DB_VARIANTS_S
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  SYMSG_TAB
*"     REFERENCE(EV_ORD_UP) TYPE  ABAP_BOOL
*"     REFERENCE(EV_ORD_DOWN) TYPE  ABAP_BOOL
*"----------------------------------------------------------------------

  DATA: lt_messages TYPE zif_nept_qz_quiz_const=>tt_if_t100_message.

  CLEAR: ev_ord_up, ev_ord_down.

  CALL METHOD zcl_nept_qz_data_cds=>variant_ord_features
    EXPORTING
      is_db_variant = is_db_variant
    IMPORTING
      ev_ord_up     = ev_ord_up
      ev_ord_down   = ev_ord_down
      et_messages   = lt_messages.

  CALL METHOD zcl_nept_qz_data_cds=>convert_messages
    EXPORTING
      it_messages = lt_messages
    IMPORTING
      et_messages = et_messages.

ENDFUNCTION.
