CLASS ltcl_quiz_d DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CONSTANTS: c_test_id_1 TYPE znept_qz_test_id_de VALUE '001',
               c_test_id_2 TYPE znept_qz_test_id_de VALUE '002'.

    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_quiz,
      cds_test_environment TYPE REF TO if_cds_test_environment,
      sql_test_environment TYPE REF TO if_osql_test_environment.

    CLASS-DATA:
      mock_data_quiz TYPE STANDARD TABLE OF znept_qz_i_quiz WITH EMPTY KEY.

    CLASS-METHODS:
      " Executed once before all tests of the class
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      "! Instantiate class under test and set up test double framework
      class_setup RAISING cx_static_check,

      " Executed once after all tests of the class
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      "! Destroy test environment and test double
      class_teardown.

    METHODS:
      " Executed before each execution of a test method of a test class
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      "! Reset test double
      setup RAISING cx_static_check,

      " Executed after each execution of a test method of a test class
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      "! Reset transactional buffer
      teardown.

    METHODS:
      "! Calls { @link ..ltcl_quiz_d.METH:get_instance_features }
      "! with all possible in- and outcomes.
      get_instance_features FOR TESTING RAISING cx_static_check,

      "! Checks that { @link ..ltcl_quiz_d.METH:get_instance_authorizations } returns initial values
      "! for <em>result</em> and <em>reported</em>.
      get_instance_authorizations FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_quiz_d IMPLEMENTATION.

  METHOD class_setup.
    " creating instances
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create( i_for_entity = 'ZNEPT_QZ_I_QUIZ_D' ).
    sql_test_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'ZNEPT_QZ_TST' ) ) ).

    " setting up test data for the whole lifetime
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  ENDMETHOD.

  METHOD setup.
    " prepare instance for next test
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    cds_test_environment->clear_doubles( ).
    sql_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    " revert before the next test
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ROLLBACK ENTITIES.                                 "#EC CI_ROLLBACK
  ENDMETHOD.

  METHOD class_teardown.
    cds_test_environment->destroy( ).
    sql_test_environment->destroy( ).
  ENDMETHOD.

  METHOD get_instance_authorizations.

    DATA:
      requested_authorizations TYPE STRUCTURE FOR AUTHORIZATION REQUEST znept_qz_i_quiz_d\\quiz,
      result_act               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_d\\quiz,
      result_exp               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_d\\quiz,
      reported                 TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_d,
      failed                   TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_d.

    mock_data_quiz = VALUE #(
      (
        testid      = c_test_id_1
        uploadon    = cl_abap_context_info=>get_system_date( )
        uploadat    = cl_abap_context_info=>get_system_time( )
        uploadby    = cl_abap_context_info=>get_user_technical_name( )
        published   = zcl_nept_qz_data_provider=>gc_quiz_private
        description = |Quiz Description { c_test_id_1 }|
      )
      (
        testid      = c_test_id_2
        uploadon    = cl_abap_context_info=>get_system_date( )
        uploadat    = cl_abap_context_info=>get_system_time( )
        uploadby    = '0123456789'
        published   = zcl_nept_qz_data_provider=>gc_quiz_private
        description = |Quiz Description { c_test_id_2 }|
      )
    ).
    cds_test_environment->insert_test_data( mock_data_quiz ).

    requested_authorizations-%action-pasteQuiz = if_abap_behv=>mk-on.

    result_exp = VALUE #(
      (
        testid = c_test_id_1
        %action-pasteQuiz = if_abap_behv=>auth-allowed
      )
      (
        testid = c_test_id_2
        %action-pasteQuiz = if_abap_behv=>auth-unauthorized
      )
    ).

    class_under_test->get_instance_authorizations(
      EXPORTING
        keys                     = CORRESPONDING #( mock_data_quiz )
        requested_authorizations = requested_authorizations
      CHANGING
        result                   = result_act
        failed                   = failed
        reported                 = reported
    ).

    cl_abap_unit_assert=>assert_initial( msg = 'Reported' act = reported ).
    cl_abap_unit_assert=>assert_initial( msg = 'Failed' act = failed ).

    SORT result_act BY %tky ASCENDING.
    SORT result_exp BY %tky ASCENDING.

    cl_abap_unit_assert=>assert_equals( msg = 'Result' exp = result_exp act = result_act ).

  ENDMETHOD.

  METHOD get_instance_features.

    DATA: failed     TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_d,
          reported   TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_d,
          requested  TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST znept_qz_i_quiz_d\\quiz,
          result_act TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_d\\quiz,
          result_exp TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_d\\quiz.

    mock_data_quiz = VALUE #(
      (
        testid         = c_test_id_1
        uploadon       = cl_abap_context_info=>get_system_date( )
        uploadat       = cl_abap_context_info=>get_system_time( )
        uploadby       = cl_abap_context_info=>get_user_technical_name( )
        published      = zcl_nept_qz_data_provider=>gc_quiz_private
        description    = |Quiz Description { c_test_id_1 }|
        question_count = 10
        part_count     = 2
      )
      (
        testid         = c_test_id_2
        uploadon       = cl_abap_context_info=>get_system_date( )
        uploadat       = cl_abap_context_info=>get_system_time( )
        uploadby       = cl_abap_context_info=>get_user_technical_name( )
        published      = zcl_nept_qz_data_provider=>gc_quiz_private
        description    = |Quiz Description { c_test_id_2 }|
        question_count = 0
        part_count     = 0
      )
    ).
    cds_test_environment->insert_test_data( mock_data_quiz ).

    requested = VALUE #(
      %action-pasteQuiz = if_abap_behv=>mk-on
    ).

    result_exp = VALUE #(
      (
        testid            = c_test_id_1
        %action-pasteQuiz   = if_abap_behv=>fc-o-disabled
      )
      (
        testid            = c_test_id_2
        %action-pasteQuiz = if_abap_behv=>fc-o-enabled
      )
    ).

    class_under_test->get_instance_features(
      EXPORTING
        keys               = CORRESPONDING #( mock_data_quiz )
        requested_features = requested
      CHANGING
        result             = result_act
        failed             = failed
        reported           = reported
    ).

    cl_abap_unit_assert=>assert_initial( msg = 'Reported' act = reported ).
    cl_abap_unit_assert=>assert_initial( msg = 'Failed' act = failed ).

    SORT result_act BY %tky ASCENDING.
    SORT result_exp BY %tky ASCENDING.

    cl_abap_unit_assert=>assert_equals( msg = 'Result' exp = result_exp act = result_act ).

  ENDMETHOD.

ENDCLASS.
