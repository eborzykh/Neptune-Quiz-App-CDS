CLASS lsc_ZNEPT_QZ_I_QUIZ_M DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZNEPT_QZ_I_QUIZ_M IMPLEMENTATION.

  METHOD adjust_numbers.

    " Attachment

    DATA(lt_create_attachment) = mapped-zz_attachment.
    DELETE lt_create_attachment WHERE questionid IS NOT INITIAL.

    IF lt_create_attachment IS NOT INITIAL.
      SORT lt_create_attachment BY %tmp-testid.

      LOOP AT lt_create_attachment ASSIGNING FIELD-SYMBOL(<fs_create_attachment>).
        <fs_create_attachment>-TestId = <fs_create_attachment>-%tmp-TestId.
        <fs_create_attachment>-QuestionId = <fs_create_attachment>-%tmp-QuestionId.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
