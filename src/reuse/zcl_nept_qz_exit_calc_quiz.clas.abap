class ZCL_NEPT_QZ_EXIT_CALC_QUIZ definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_NEPT_QZ_EXIT_CALC_QUIZ IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    TYPES:
      BEGIN OF ty_select,
        uploadon       TYPE znept_qz_upload_date_de,
        uploadat       TYPE znept_qz_upload_time_de,
        testid         TYPE znept_qz_test_id_de,
        uploadby       TYPE znept_qz_upload_user_de,
        upload_by_name TYPE znept_qz_upload_name_de,
      END OF ty_select.

    CONSTANTS:
      BEGIN OF cs_calc_element,
        type_code_text TYPE sadl_entity_element VALUE 'UPLOAD_BY_NAME',
      END OF cs_calc_element.

    DATA:
      lt_calc_key     TYPE TABLE OF znept_qz_db_tests_key_s,
      lt_calc_data    TYPE STANDARD TABLE OF ty_select,
      lt_select       TYPE STANDARD TABLE OF ty_select,
      ls_select       TYPE ty_select,
      ls_user_address TYPE addr3_val.

    CHECK NOT it_original_data IS INITIAL.
    CHECK line_exists( it_requested_calc_elements[ table_line = cs_calc_element-type_code_text ] ).

    MOVE-CORRESPONDING it_original_data[] TO lt_calc_data[].

    SELECT upload_on upload_at test_id upload_by INTO TABLE lt_select
      FROM znept_qz_tst FOR ALL ENTRIES IN lt_calc_data
      WHERE upload_on = lt_calc_data-uploadon
        AND upload_at = lt_calc_data-uploadat
        AND test_id   = lt_calc_data-testid.

    IF sy-subrc = 0.

      LOOP AT lt_calc_data ASSIGNING FIELD-SYMBOL(<fs_calc_data>).

        READ TABLE lt_select INTO ls_select WITH KEY
              uploadon = <fs_calc_data>-uploadon
        uploadat = <fs_calc_data>-uploadat
        testid   = <fs_calc_data>-testid.

        IF sy-subrc = 0.

          CALL FUNCTION 'SUSR_USER_ADDRESS_READ'
            EXPORTING
              user_name              = ls_select-uploadby
            IMPORTING
              user_address           = ls_user_address
            EXCEPTIONS
              user_address_not_found = 1
              OTHERS                 = 2.

          IF sy-subrc = 0.
            <fs_calc_data>-upload_by_name = ls_user_address-name_text.
          ELSE.
            <fs_calc_data>-upload_by_name = ls_select-uploadby.
          ENDIF.
        ENDIF.
      ENDLOOP.

      MOVE-CORRESPONDING lt_calc_data[] TO ct_calculated_data[].
    ENDIF.

  ENDMETHOD.


  METHOD IF_SADL_EXIT_CALC_ELEMENT_READ~GET_CALCULATION_INFO.
  ENDMETHOD.
ENDCLASS.
