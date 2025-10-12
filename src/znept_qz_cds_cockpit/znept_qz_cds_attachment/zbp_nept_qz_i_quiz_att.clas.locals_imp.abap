CLASS lhc__attachment DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR _attachment RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ _attachment RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK _attachment.

    METHODS upload FOR MODIFY
      IMPORTING keys FOR ACTION _attachment~upload.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE _attachment.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE _attachment.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE _attachment.

ENDCLASS.

CLASS lhc__attachment IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD upload.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_att DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_att IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
