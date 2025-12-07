*
CLASS lhc_part DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setversion FOR DETERMINE ON SAVE
      IMPORTING keys FOR part~setversion.

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

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
