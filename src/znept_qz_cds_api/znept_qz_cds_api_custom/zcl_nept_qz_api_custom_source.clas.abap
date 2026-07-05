CLASS zcl_nept_qz_api_custom_source DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_nept_qz_api_custom_source IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA: lt_query_quiz TYPE TABLE OF znept_qz_i_cquiz.

* Needs to be called even if not using because of error:
* Query not fully covered by implementation: Call to method if_rap_query_request~get_paging missing
    DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
    DATA(lv_top) = io_request->get_paging( )->get_page_size( ).

*    DATA(lv_where) = io_request->get_filter( )->get_as_sql_string( ).
    TRY.
        DATA(lv_where) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.

    DATA(lv_entity_id) = io_request->get_entity_id( ).

    IF lv_entity_id = 'ZNEPT_QZ_I_CQUIZ'.

      SELECT testid AS test_id,
             uploadon AS upload_on,
             uploadat AS upload_at,
             uploadby AS upload_by,
             published,
             description,
             progress,
             percentage,
             part_count,
             question_count,
             no_sync_data,
             upload_by_name
        FROM znept_qz_a_pquiz
        ORDER BY as_owner DESCENDING, uploadtstmp
        INTO TABLE @DATA(lt_qz_a_pquiz).

      IF sy-subrc <> 0.
        CLEAR lt_qz_a_pquiz.
      ENDIF.

      lt_query_quiz = CORRESPONDING #( lt_qz_a_pquiz ).

      io_response->set_total_number_of_records( lines( lt_query_quiz ) ).
      io_response->set_data( lt_query_quiz ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
