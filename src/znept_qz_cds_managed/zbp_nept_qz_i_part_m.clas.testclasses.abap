CLASS ltcl_part_m DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CONSTANTS: c_test_id_1 TYPE znept_qz_test_id_de VALUE '001',
               c_test_id_2 TYPE znept_qz_test_id_de VALUE '002'.

    CONSTANTS: c_part_id_1 TYPE znept_qz_part_id_de VALUE '01',
               c_part_id_2 TYPE znept_qz_part_id_de VALUE '02',
               c_part_id_3 TYPE znept_qz_part_id_de VALUE '03'.

    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_part,
      cds_test_environment TYPE REF TO if_cds_test_environment,
      sql_test_environment TYPE REF TO if_osql_test_environment.

    CLASS-DATA:
      mock_data_part TYPE STANDARD TABLE OF znept_qz_i_part WITH EMPTY KEY,
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
      "! Calls { @link ..ltcl_part_m.METH:get_instance_features }
      "! with all possible in- and outcomes.
      get_instance_features FOR TESTING RAISING cx_static_check,

      "! Checks that { @link ..ltcl_part_m.METH:get_instance_authorizations } returns initial values
      "! for <em>result</em> and <em>reported</em>.
      get_instance_authorizations FOR TESTING RAISING cx_static_check,

      "! Checks that { @link ..ltcl_part_m.METH:setversion } returns values
      "! for <em>result</em> and <em>reported</em>.
      setversion FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_part_m IMPLEMENTATION.

  METHOD class_setup.
    " creating instances
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
      VALUE #( ( i_for_entity = 'ZNEPT_QZ_I_QUIZ_M' )
               ( i_for_entity = 'ZNEPT_QZ_I_PART_M' )
      )
    ).
    sql_test_environment = cl_osql_test_environment=>create(
      VALUE #( ( 'ZNEPT_QZ_TST' )
               ( 'ZNEPT_QZ_PRT' )
      )
    ).

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
      requested_authorizations TYPE STRUCTURE FOR AUTHORIZATION REQUEST znept_qz_i_quiz_m\\part,
      result_act               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_m\\part,
      result_exp               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_m\\part,
      reported                 TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_m,
      failed                   TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_m.

    mock_data_quiz = VALUE #(
      (
        testid      = c_test_id_1
        uploadby    = cl_abap_context_info=>get_user_technical_name( )
      )
      (
        testid      = c_test_id_2
        uploadby    = '0123456789'
      )
    ).
    cds_test_environment->insert_test_data( mock_data_quiz ).

    mock_data_part = VALUE #(
      (
        testid      = c_test_id_1
        partid      = c_part_id_1
      )
      (
        testid      = c_test_id_2
        partid      = c_part_id_1
      )
    ).
    cds_test_environment->insert_test_data( mock_data_part ).

    requested_authorizations-%action-movepartfirst = if_abap_behv=>mk-on.
    requested_authorizations-%action-movepartup    = if_abap_behv=>mk-on.
    requested_authorizations-%action-movepartdown  = if_abap_behv=>mk-on.
    requested_authorizations-%action-movepartlast  = if_abap_behv=>mk-on.

    result_exp = VALUE #(
      (
        testid = c_test_id_1
        partid = c_part_id_1
        %action-movepartfirst = if_abap_behv=>auth-allowed
        %action-movepartup    = if_abap_behv=>auth-allowed
        %action-movepartdown  = if_abap_behv=>auth-allowed
        %action-movepartlast  = if_abap_behv=>auth-allowed
      )
      (
        testid = c_test_id_2
        partid = c_part_id_1
        %action-movepartfirst = if_abap_behv=>auth-unauthorized
        %action-movepartup    = if_abap_behv=>auth-unauthorized
        %action-movepartdown  = if_abap_behv=>auth-unauthorized
        %action-movepartlast  = if_abap_behv=>auth-unauthorized
      )
    ).

    class_under_test->get_instance_authorizations(
      EXPORTING
        keys                     = CORRESPONDING #( mock_data_part )
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

    DATA: failed     TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_m,
          reported   TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_m,
          requested  TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST znept_qz_i_quiz_m\\part,
          result_act TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_m\\part,
          result_exp TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_m\\part.

    mock_data_part = VALUE #(
      (
        testid      = c_test_id_1
        partid      = c_part_id_1
        sort        = c_part_id_1
      )
      (
        testid      = c_test_id_1
        partid      = c_part_id_2
        sort        = c_part_id_2
      )
      (
        testid      = c_test_id_1
        partid      = c_part_id_3
        sort        = c_part_id_3
      )
    ).
    cds_test_environment->insert_test_data( mock_data_part ).

    requested = VALUE #(
      %action-movepartfirst = if_abap_behv=>mk-on
      %action-movepartup    = if_abap_behv=>mk-on
      %action-movepartdown  = if_abap_behv=>mk-on
      %action-movepartlast  = if_abap_behv=>mk-on
    ).

    result_exp = VALUE #(
      (
        testid                = c_test_id_1
        partid                = c_part_id_1
        %action-movepartfirst = if_abap_behv=>fc-o-disabled
        %action-movepartup    = if_abap_behv=>fc-o-disabled
        %action-movepartdown  = if_abap_behv=>fc-o-enabled
        %action-movepartlast  = if_abap_behv=>fc-o-enabled
      )
      (
        testid                = c_test_id_1
        partid                = c_part_id_2
        %action-movepartfirst = if_abap_behv=>fc-o-enabled
        %action-movepartup    = if_abap_behv=>fc-o-enabled
        %action-movepartdown  = if_abap_behv=>fc-o-enabled
        %action-movepartlast  = if_abap_behv=>fc-o-enabled
      )
      (
        testid                = c_test_id_1
        partid                = c_part_id_3
        %action-movepartfirst = if_abap_behv=>fc-o-enabled
        %action-movepartup    = if_abap_behv=>fc-o-enabled
        %action-movepartdown  = if_abap_behv=>fc-o-disabled
        %action-movepartlast  = if_abap_behv=>fc-o-disabled
      )
    ).

    class_under_test->get_instance_features(
      EXPORTING
        keys               = CORRESPONDING #( mock_data_part )
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

  METHOD setversion.

    DATA: reported        TYPE RESPONSE FOR REPORTED LATE znept_qz_i_quiz_m,
          result_act_quiz TYPE TABLE FOR READ RESULT znept_qz_i_quiz_m\\quiz,
          result_exp_quiz TYPE TABLE FOR READ RESULT znept_qz_i_quiz_m\\quiz,
          result_act_part TYPE TABLE FOR READ RESULT znept_qz_i_quiz_m\\part,
          result_exp_part TYPE TABLE FOR READ RESULT znept_qz_i_quiz_m\\part.

    mock_data_quiz = VALUE #(
      (
        testid = c_test_id_1
      )
    ).
    cds_test_environment->insert_test_data( mock_data_quiz ).

    mock_data_part = VALUE #(
      (
        testid = c_test_id_1
        partid = c_part_id_1
      )
    ).
    cds_test_environment->insert_test_data( mock_data_part ).

    class_under_test->setversion(
        EXPORTING
          keys     = CORRESPONDING #( mock_data_part )
        CHANGING
          reported = reported
    ).

    cl_abap_unit_assert=>assert_initial( reported ).

    READ ENTITIES OF znept_qz_i_quiz_m
      ENTITY quiz
        FIELDS ( testid version )
        WITH CORRESPONDING #( mock_data_quiz )
        RESULT result_act_quiz
      ENTITY part
        FIELDS ( testid partid version )
        WITH CORRESPONDING #( mock_data_part )
        RESULT result_act_part.

    result_exp_quiz = VALUE #(
      (
        testid = c_test_id_1
        version = +1
      )
    ).

    SORT result_act_quiz BY %tky ASCENDING.
    SORT result_exp_quiz BY %tky ASCENDING.

    cl_abap_unit_assert=>assert_equals( exp = result_exp_quiz act = result_act_quiz ).

    result_exp_part = VALUE #(
      (
        testid = c_test_id_1
        partid = c_part_id_1
        version = +1
      )
    ).

    SORT result_act_part BY %tky ASCENDING.
    SORT result_exp_part BY %tky ASCENDING.

    cl_abap_unit_assert=>assert_equals( exp = result_exp_part act = result_act_part ).

  ENDMETHOD.

ENDCLASS.
