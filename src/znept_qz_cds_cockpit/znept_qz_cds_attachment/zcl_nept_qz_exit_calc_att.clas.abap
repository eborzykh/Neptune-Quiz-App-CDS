class ZCL_NEPT_QZ_EXIT_CALC_ATT definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF cs_calc_element,
        streamfilename TYPE sadl_entity_element VALUE 'STREAMFILENAME',
        streammimetype TYPE sadl_entity_element VALUE 'STREAMMIMETYPE',
        streamfile     TYPE sadl_entity_element VALUE 'STREAMFILE',
      END OF cs_calc_element.
ENDCLASS.



CLASS ZCL_NEPT_QZ_EXIT_CALC_ATT IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    TYPES:
      BEGIN OF ty_calc_data,
        testid         TYPE znept_qz_test_id_de,
        uploadon       TYPE znept_qz_upload_date_de,
        uploadat       TYPE znept_qz_upload_time_de,
        description    TYPE znept_qz_test_name_de,
        streamfile     TYPE string,
        streamfilename TYPE char128,
        streammimetype TYPE char128,
      END OF ty_calc_data.

    DATA:
      lt_calc_key     TYPE TABLE OF znept_qz_db_tests_key_s,
      lt_calc_data    TYPE STANDARD TABLE OF ty_calc_data,
      lt_select       TYPE STANDARD TABLE OF ty_calc_data,
      ls_select       TYPE ty_calc_data,
      ls_db_tests_key TYPE znept_qz_db_tests_key_s,
      lt_db_parts     TYPE znept_qz_db_parts_t,
      ls_db_parts     TYPE znept_qz_db_parts_s,
      lt_db_questions TYPE znept_qz_db_questions_t,
      lt_db_variants  TYPE znept_qz_db_variants_t,
      ls_db_questions TYPE znept_qz_db_questions_s,
      ls_db_variants  TYPE znept_qz_db_variants_s,
      lv_db_error     TYPE abap_bool,
      lv_sbuf         TYPE string,
      lv_xstring      TYPE xstring.

    CHECK NOT it_original_data IS INITIAL.

    MOVE-CORRESPONDING it_original_data[] TO lt_calc_data[].

    LOOP AT lt_calc_data ASSIGNING FIELD-SYMBOL(<fs_calc_data>).

      CONCATENATE <fs_calc_data>-testid '.txt' INTO <fs_calc_data>-streamfilename.

      <fs_calc_data>-streammimetype = 'text/plain'.

      CLEAR ls_db_tests_key.
      ls_db_tests_key-test_id = <fs_calc_data>-testid.
      ls_db_tests_key-upload_on = <fs_calc_data>-uploadon.
      ls_db_tests_key-upload_at = <fs_calc_data>-uploadat.

      CALL METHOD zcl_nept_qz_data_provider=>get
        EXPORTING
          is_db_tests_key = ls_db_tests_key
          iv_version      = -1
        IMPORTING
          et_db_parts     = lt_db_parts
          et_db_questions = lt_db_questions
          et_db_variants  = lt_db_variants
          ev_db_error     = lv_db_error.

      IF lv_db_error IS INITIAL.

        IF NOT lt_db_parts[] IS INITIAL.
          LOOP AT lt_db_parts INTO ls_db_parts.
            CONCATENATE lv_sbuf
                        ls_db_parts-description cl_abap_char_utilities=>cr_lf
               INTO lv_sbuf.
            CONCATENATE lv_sbuf cl_abap_char_utilities=>cr_lf INTO lv_sbuf.

            LOOP AT lt_db_questions INTO ls_db_questions WHERE part_id = ls_db_parts-part_id.
              CONCATENATE lv_sbuf
                          ls_db_questions-question cl_abap_char_utilities=>horizontal_tab
                          ls_db_questions-explanation cl_abap_char_utilities=>cr_lf
                 INTO lv_sbuf.

              LOOP AT lt_db_variants INTO ls_db_variants WHERE question_id = ls_db_questions-question_id.
                CONCATENATE lv_sbuf
                            ls_db_variants-variant cl_abap_char_utilities=>horizontal_tab
                            ls_db_variants-correct cl_abap_char_utilities=>cr_lf
                  INTO lv_sbuf.
              ENDLOOP.
              CONCATENATE lv_sbuf cl_abap_char_utilities=>cr_lf INTO lv_sbuf.
            ENDLOOP.
          ENDLOOP.
        ELSE.
          LOOP AT lt_db_questions INTO ls_db_questions.
            CONCATENATE lv_sbuf
                        ls_db_questions-question cl_abap_char_utilities=>horizontal_tab
                        ls_db_questions-explanation cl_abap_char_utilities=>cr_lf
               INTO lv_sbuf.

            LOOP AT lt_db_variants INTO ls_db_variants WHERE question_id = ls_db_questions-question_id.
              CONCATENATE lv_sbuf
                          ls_db_variants-variant cl_abap_char_utilities=>horizontal_tab
                          ls_db_variants-correct cl_abap_char_utilities=>cr_lf
                INTO lv_sbuf.
            ENDLOOP.
            CONCATENATE lv_sbuf cl_abap_char_utilities=>cr_lf INTO lv_sbuf.
          ENDLOOP.
        ENDIF.

        CALL FUNCTION 'ECATT_CONV_STRING_TO_XSTRING'
          EXPORTING
            im_string   = lv_sbuf
            im_encoding = 'UTF-8'
          IMPORTING
            ex_xstring  = lv_xstring.

        <fs_calc_data>-streamfile = lv_xstring.

        CLEAR: lv_sbuf, lv_xstring.
      ENDIF.
    ENDLOOP.

    MOVE-CORRESPONDING lt_calc_data[] TO ct_calculated_data[].

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

*    IF line_exists( it_requested_calc_elements[ table_line = cs_calc_element-item_gross_total ] ).
*      INSERT |ID| INTO TABLE et_requested_orig_elements.
*    ENDIF.

*STREAMFILE
*STREAMFILENAME
*STREAMMIMETYPE

*    INSERT |TESTID| INTO TABLE et_requested_orig_elements.

  ENDMETHOD.
ENDCLASS.
