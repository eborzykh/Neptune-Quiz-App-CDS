CLASS zcl_nept_qz_exit_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_nept_qz_exit_calc IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    TYPES:
      BEGIN OF ty_select,
        upload_on      TYPE znept_qz_upload_date_de,
        upload_at      TYPE znept_qz_upload_time_de,
        test_id        TYPE znept_qz_test_id_de,
        upload_by      TYPE znept_qz_upload_user_de,
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
      WHERE upload_on = lt_calc_data-upload_on
        AND upload_at = lt_calc_data-upload_at
        AND test_id   = lt_calc_data-test_id.

    IF sy-subrc = 0.

      LOOP AT lt_calc_data ASSIGNING FIELD-SYMBOL(<fs_calc_data>).

        READ TABLE lt_select INTO ls_select WITH KEY
              upload_on = <fs_calc_data>-upload_on
        upload_at = <fs_calc_data>-upload_at
        test_id   = <fs_calc_data>-test_id.

        IF sy-subrc = 0.

          CALL FUNCTION 'SUSR_USER_ADDRESS_READ'
            EXPORTING
              user_name              = ls_select-upload_by
            IMPORTING
              user_address           = ls_user_address
            EXCEPTIONS
              user_address_not_found = 1
              OTHERS                 = 2.

          IF sy-subrc = 0.
            <fs_calc_data>-upload_by_name = ls_user_address-name_text.
          ELSE.
            <fs_calc_data>-upload_by_name = ls_select-upload_by.
          ENDIF.
        ENDIF.
      ENDLOOP.

      MOVE-CORRESPONDING lt_calc_data[] TO ct_calculated_data[].
    ENDIF.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.

ENDCLASS.
