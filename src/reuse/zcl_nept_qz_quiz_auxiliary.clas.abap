CLASS zcl_nept_qz_quiz_auxiliary DEFINITION
  PUBLIC
  INHERITING FROM cl_abap_behv
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Calculates the <em>fail_cause</em> according to the message class and ID.  If the the message is raised in a dependent
    "! like <em>Create by Association</em> this is also taken in account.
    "!
    "! @parameter msgid | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter msgno | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter is_dependend | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter fail_cause | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS get_cause_from_message
      IMPORTING
        !msgid            TYPE symsgid
        !msgno            TYPE symsgno
        !is_dependend     TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(fail_cause) TYPE if_abap_behv=>t_fail_cause .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_nept_qz_quiz_auxiliary IMPLEMENTATION.


  METHOD get_cause_from_message.

    fail_cause = if_abap_behv=>cause-unspecific.

    IF msgid = 'ZNEPT_QZ_CDS'.

      CASE msgno.
        WHEN '009'  "Quiz Key initial
          OR '009'  "Part Key initial
          OR '010'  "Question Key initial
          OR '011'  "Variant Key initial
"
          OR '016'  "Quiz does not exist
          OR '017'  "Part does not exist
          OR '018'  "Question does not exist
          OR '019'. "Variant does not exist
          "
          IF is_dependend = abap_true.
            fail_cause = if_abap_behv=>cause-dependency.
          ELSE.
            fail_cause = if_abap_behv=>cause-not_found.
          ENDIF.

        WHEN '032'. "Quiz is locked by
          fail_cause = if_abap_behv=>cause-locked.

        WHEN '046'. "You are not authorized
          fail_cause = if_abap_behv=>cause-unauthorized.

      ENDCASE.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
