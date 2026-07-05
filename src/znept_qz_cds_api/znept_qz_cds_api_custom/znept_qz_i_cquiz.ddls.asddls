@EndUserText.label: 'Quiz List (Custom Entity)'
@ObjectModel: { query: { implementedBy: 'ABAP:ZCL_NEPT_QZ_API_CUSTOM_SOURCE' } }

// Does not support Metadata Extensions
// Does not support Root View Entity on
// Does not support Projection on

define custom entity ZNEPT_QZ_I_CQUIZ
{
  key test_id        : znept_qz_test_id_de;

      upload_on      : znept_qz_upload_date_de;
      upload_at      : znept_qz_upload_time_de;
      upload_by      : znept_qz_upload_user_de;
      published      : znept_qz_published_de;
      description    : znept_qz_test_name_de;

      @EndUserText.label: 'Correct'
      @EndUserText.quickInfo: 'Correct answers'
      progress       : abap.int2; // znept_qz_count_correct_de;

      @EndUserText.label: 'Percentage'
      @EndUserText.quickInfo: 'Percentage of correct answers'
      percentage     : abap.dec( 5, 2 ); // znept_qz_percent_correct_de;
      
      part_count     : znept_qz_count_parts_de;
      question_count : znept_qz_count_questions_de;

      @EndUserText.label: 'Not synced'
      @EndUserText.quickInfo: 'Has no sync data available'
      no_sync_data   : abap.char( 1 ); // znept_qz_no_sync_de;

      upload_by_name : znept_qz_upload_name_de;
}
