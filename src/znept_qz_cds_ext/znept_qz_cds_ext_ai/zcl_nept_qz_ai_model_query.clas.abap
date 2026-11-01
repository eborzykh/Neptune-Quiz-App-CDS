
CLASS zcl_nept_qz_ai_model_query DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

ENDCLASS.



CLASS zcl_nept_qz_ai_model_query IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_model_query_vh TYPE STANDARD TABLE OF zznept_qz_i_ai_model_vh WITH EMPTY KEY.
    DATA: lt_ai_model TYPE znept_qz_ai_model_t.

    TRY.
        zcl_nept_qz_src_ai=>get_models( IMPORTING et_model = lt_ai_model ).
      CATCH zcx_nept_qz_src_ai_api.
        RAISE EXCEPTION TYPE zcx_nept_qz_ai_model_q_pro.
    ENDTRY.

    LOOP AT lt_ai_model ASSIGNING FIELD-SYMBOL(<fs_ai_model>).
      APPEND INITIAL LINE TO lt_model_query_vh ASSIGNING FIELD-SYMBOL(<fs_model_query_vh>).
      <fs_model_query_vh>-Model = <fs_ai_model>-model.
      <fs_model_query_vh>-ModelText = <fs_ai_model>-model_name.
    ENDLOOP.

    DATA(ld_all_entries) = lines( lt_model_query_vh ).
    NEW zcl_nept_qz_cds_bs_adjust_data( )->adjust_via_request( EXPORTING io_request = io_request
                                                               CHANGING  ct_data    = lt_model_query_vh ).

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_model_query_vh ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( lt_model_query_vh ) ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
