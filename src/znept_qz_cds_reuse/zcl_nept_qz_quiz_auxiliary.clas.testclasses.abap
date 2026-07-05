CLASS ltcl_mapping DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      all_in_one FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_mapping IMPLEMENTATION.

  METHOD all_in_one.
    TYPES:
      BEGIN OF check_line,
        msgid        TYPE symsgid,
        msgno        TYPE symsgno,
        is_dependend TYPE abap_bool,
        fail_cause   TYPE if_abap_behv=>t_fail_cause,
      END OF check_line,
      check_table TYPE STANDARD TABLE OF check_line WITH KEY msgid msgno.

    DATA: act TYPE check_table,
          exp TYPE check_table.

    exp = VALUE check_table(
        msgid        = 'ZNEPT_QZ_CDS'

        is_dependend = abap_true
          fail_cause = if_abap_behv=>cause-dependency
          ( msgno = '009' )
          ( msgno = '010' )
          ( msgno = '011' )

          fail_cause = if_abap_behv=>cause-locked
          ( msgno = '032'   )

          fail_cause = if_abap_behv=>cause-unauthorized
          ( msgno = '046'   )


        is_dependend = abap_false
          fail_cause = if_abap_behv=>cause-not_found
          ( msgno = '016' )
          ( msgno = '017' )
          ( msgno = '018' )
          ( msgno = '019' )

          fail_cause = if_abap_behv=>cause-locked
          ( msgno = '032'   )

          fail_cause = if_abap_behv=>cause-unauthorized
          ( msgno = '046'   )
      ).

    LOOP AT exp INTO DATA(test_case).
      APPEND VALUE check_line(
          msgid        = test_case-msgid
          msgno        = test_case-msgno
          is_dependend = test_case-is_dependend
          fail_cause   = zcl_nept_qz_quiz_auxiliary=>get_cause_from_message(
                           msgid        = test_case-msgid
                           msgno        = test_case-msgno
                           is_dependend = test_case-is_dependend
                         )
        ) TO act.
    ENDLOOP.

    cl_abap_unit_assert=>assert_equals(
        exp = exp
        act = act
      ).
  ENDMETHOD.

ENDCLASS.
