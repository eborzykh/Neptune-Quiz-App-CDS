CLASS zcl_nept_qz_trivia_categ_query DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

ENDCLASS.


CLASS zcl_nept_qz_trivia_categ_query IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA: lt_cat_query_vh TYPE STANDARD TABLE OF znept_qz_i_trivia_cat_query_vh WITH EMPTY KEY.
    DATA: lt_trivia_category TYPE znept_qz_trivia_categ_t.

    zcl_nept_qz_src_trivia=>get_categories( IMPORTING et_category = lt_trivia_category ).

    LOOP AT lt_trivia_category ASSIGNING FIELD-SYMBOL(<fs_trivia_category>).
      APPEND INITIAL LINE TO lt_cat_query_vh ASSIGNING FIELD-SYMBOL(<fs_cat_query_vh>).
      <fs_cat_query_vh>-category = <fs_trivia_category>-category_id.
      <fs_cat_query_vh>-categorytext = <fs_trivia_category>-category_name.
    ENDLOOP.

    DATA(ld_all_entries) = lines( lt_cat_query_vh ).
    NEW zcl_nept_qz_cds_bs_adjust_data( )->adjust_via_request( EXPORTING io_request = io_request
                                                               CHANGING  ct_data    = lt_cat_query_vh ).

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_cat_query_vh ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( lt_cat_query_vh ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
