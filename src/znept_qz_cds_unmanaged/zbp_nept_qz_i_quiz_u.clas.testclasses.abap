
CLASS ltcl_quiz_u DEFINITION FINAL FOR TESTING
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
      "! Calls { @link ..ltcl_quiz_u.METH:get_instance_features }
      "! with all possible in- and outcomes.
      get_instance_features FOR TESTING RAISING cx_static_check,

      "! Checks that { @link ..ltcl_quiz_u.METH:get_instance_authorizations } returns initial values
      "! for <em>result</em> and <em>reported</em>.
      get_instance_authorizations FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_quiz_u IMPLEMENTATION.

  METHOD class_setup.
    " creating instances
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create( i_for_entity = 'ZNEPT_QZ_I_QUIZ_U' ).
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
      requested_authorizations TYPE STRUCTURE FOR AUTHORIZATION REQUEST znept_qz_i_quiz_u\\quiz,
      result_act               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_u\\quiz,
      result_exp               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_u\\quiz,
      reported                 TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_u,
      failed                   TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_u.

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

    requested_authorizations-%delete = if_abap_behv=>mk-on.
    requested_authorizations-%update = if_abap_behv=>mk-on.
    requested_authorizations-%action-publish = if_abap_behv=>mk-on.
    requested_authorizations-%action-unpublish = if_abap_behv=>mk-on.
    requested_authorizations-%action-trivia = if_abap_behv=>mk-on.

    result_exp = VALUE #(
      (
        testid = c_test_id_1
        %delete = if_abap_behv=>auth-allowed
        %update = if_abap_behv=>auth-allowed
        %action-publish = if_abap_behv=>auth-allowed
        %action-unpublish = if_abap_behv=>auth-allowed
        %action-trivia = if_abap_behv=>auth-allowed
      )
      (
        testid = c_test_id_2
        %delete = if_abap_behv=>auth-unauthorized
        %update = if_abap_behv=>auth-unauthorized
        %action-publish = if_abap_behv=>auth-unauthorized
        %action-unpublish = if_abap_behv=>auth-unauthorized
        %action-trivia = if_abap_behv=>auth-unauthorized
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

    DATA: failed     TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_u,
          reported   TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_u,
          requested  TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST znept_qz_i_quiz_u\\quiz,
          result_act TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_u\\quiz,
          result_exp TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_u\\quiz.

    mock_data_quiz = VALUE #(
      (
        testid      = c_test_id_1
        uploadon    = cl_abap_context_info=>get_system_date( )
        uploadat    = cl_abap_context_info=>get_system_time( )
        uploadby    = cl_abap_context_info=>get_user_technical_name( )
        published   = zcl_nept_qz_data_provider=>gc_quiz_private
        description = |Quiz Description { c_test_id_1 }|
        question_count = 10
        part_count = 2
      )
      (
        testid      = c_test_id_2
        uploadon    = cl_abap_context_info=>get_system_date( )
        uploadat    = cl_abap_context_info=>get_system_time( )
        uploadby    = cl_abap_context_info=>get_user_technical_name( )
        published   = zcl_nept_qz_data_provider=>gc_quiz_published
        description = |Quiz TRIVIA|
        question_count = 0
        part_count = 0
      )
    ).
    cds_test_environment->insert_test_data( mock_data_quiz ).

    requested = VALUE #(
      %action-publish   = if_abap_behv=>mk-on
      %action-unpublish = if_abap_behv=>mk-on
      %action-trivia    = if_abap_behv=>mk-on
    ).

    result_exp = VALUE #(
      (
        testid = c_test_id_1
        %action-publish = if_abap_behv=>fc-o-enabled
        %action-unpublish = if_abap_behv=>fc-o-disabled
        %action-trivia = if_abap_behv=>fc-o-disabled
      )
      (
        testid = c_test_id_2
        %action-publish = if_abap_behv=>fc-o-disabled
        %action-unpublish = if_abap_behv=>fc-o-enabled
        %action-trivia = if_abap_behv=>fc-o-enabled
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

CLASS ltcl_part_u DEFINITION FINAL FOR TESTING
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
      get_instance_authorizations FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_part_u IMPLEMENTATION.

  METHOD class_setup.
    " creating instances
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
      VALUE #( ( i_for_entity = 'ZNEPT_QZ_I_QUIZ_U' )
               ( i_for_entity = 'ZNEPT_QZ_I_PART_U' )
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
      requested_authorizations TYPE STRUCTURE FOR AUTHORIZATION REQUEST znept_qz_i_quiz_u\\part,
      result_act               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_u\\part,
      result_exp               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_u\\part,
      reported                 TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_u,
      failed                   TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_u.

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

    DATA: failed     TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_u,
          reported   TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_u,
          requested  TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST znept_qz_i_quiz_u\\part,
          result_act TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_u\\part,
          result_exp TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_u\\part.

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

ENDCLASS.

CLASS ltcl_question_u DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CONSTANTS: c_test_id_1 TYPE znept_qz_test_id_de VALUE '001',
               c_test_id_2 TYPE znept_qz_test_id_de VALUE '002'.

    CONSTANTS: c_part_id_1 TYPE znept_qz_part_id_de VALUE '01',
               c_part_id_2 TYPE znept_qz_part_id_de VALUE '02',
               c_part_id_3 TYPE znept_qz_part_id_de VALUE '03'.

    CONSTANTS: c_question_id_1 TYPE znept_qz_question_id_de VALUE '0001',
               c_question_id_2 TYPE znept_qz_question_id_de VALUE '0002',
               c_question_id_3 TYPE znept_qz_question_id_de VALUE '0003'.

    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_question,
      cds_test_environment TYPE REF TO if_cds_test_environment,
      sql_test_environment TYPE REF TO if_osql_test_environment.

    CLASS-DATA:
      mock_data_quiz     TYPE STANDARD TABLE OF znept_qz_i_quiz WITH EMPTY KEY,
      mock_data_question TYPE STANDARD TABLE OF znept_qz_i_question WITH EMPTY KEY.

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
      "! Calls { @link ..ltcl_question_m.METH:get_instance_features }
      "! with all possible in- and outcomes.
      get_instance_features FOR TESTING RAISING cx_static_check,

      "! Checks that { @link ..ltcl_question_m.METH:get_instance_authorizations } returns initial values
      "! for <em>result</em> and <em>reported</em>.
      get_instance_authorizations FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_question_u IMPLEMENTATION.

  METHOD class_setup.
    " creating instances
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
      VALUE #( ( i_for_entity = 'ZNEPT_QZ_I_QUIZ_U' )
               ( i_for_entity = 'ZNEPT_QZ_I_QUESTION_U' )
      )
    ).
    sql_test_environment = cl_osql_test_environment=>create(
      VALUE #( ( 'ZNEPT_QZ_TST' )
               ( 'ZNEPT_QZ_QST' )
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
      requested_authorizations TYPE STRUCTURE FOR AUTHORIZATION REQUEST znept_qz_i_quiz_u\\question,
      result_act               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_u\\question,
      result_exp               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_u\\question,
      reported                 TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_u,
      failed                   TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_u.

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

    mock_data_question = VALUE #(
      (
        testid     = c_test_id_1
        questionid = c_question_id_1
      )
      (
        testid     = c_test_id_2
        questionid = c_question_id_1
      )
    ).
    cds_test_environment->insert_test_data( mock_data_question ).

    requested_authorizations-%action-movequestionfirst = if_abap_behv=>mk-on.
    requested_authorizations-%action-movequestionup    = if_abap_behv=>mk-on.
    requested_authorizations-%action-movequestiondown  = if_abap_behv=>mk-on.
    requested_authorizations-%action-movequestionlast  = if_abap_behv=>mk-on.
    requested_authorizations-%action-assignpart        = if_abap_behv=>mk-on.
    requested_authorizations-%action-refreshquestion   = if_abap_behv=>mk-on.

    result_exp = VALUE #(
      (
        testid                    = c_test_id_1
        questionid                = c_question_id_1
        %action-movequestionfirst = if_abap_behv=>auth-allowed
        %action-movequestionup    = if_abap_behv=>auth-allowed
        %action-movequestiondown  = if_abap_behv=>auth-allowed
        %action-movequestionlast  = if_abap_behv=>auth-allowed
        %action-assignpart        = if_abap_behv=>auth-allowed
        %action-refreshquestion   = if_abap_behv=>auth-allowed
      )
      (
        testid                    = c_test_id_2
        questionid                = c_question_id_1
        %action-movequestionfirst = if_abap_behv=>auth-unauthorized
        %action-movequestionup    = if_abap_behv=>auth-unauthorized
        %action-movequestiondown  = if_abap_behv=>auth-unauthorized
        %action-movequestionlast  = if_abap_behv=>auth-unauthorized
        %action-assignpart        = if_abap_behv=>auth-unauthorized
        %action-refreshquestion   = if_abap_behv=>auth-unauthorized
      )
    ).

    class_under_test->get_instance_authorizations(
      EXPORTING
        keys                     = CORRESPONDING #( mock_data_question )
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

    DATA: failed     TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_u,
          reported   TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_u,
          requested  TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST znept_qz_i_quiz_u\\question,
          result_act TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_u\\question,
          result_exp TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_u\\question.

    mock_data_question = VALUE #(
      (
        testid      = c_test_id_1
        partid      = c_part_id_1
        questionid  = c_question_id_1
        sort        = c_question_id_1
      )
      (
        testid      = c_test_id_1
        partid      = c_part_id_1
        questionid  = c_question_id_2
        sort        = c_question_id_2
      )
      (
        testid      = c_test_id_1
        partid      = c_part_id_1
        questionid  = c_question_id_3
        sort        = c_question_id_3
      )
    ).
    cds_test_environment->insert_test_data( mock_data_question ).

    requested = VALUE #(
      %action-movequestionfirst = if_abap_behv=>mk-on
      %action-movequestionup    = if_abap_behv=>mk-on
      %action-movequestiondown  = if_abap_behv=>mk-on
      %action-movequestionlast  = if_abap_behv=>mk-on
      %action-assignpart        = if_abap_behv=>mk-on
      %action-refreshquestion   = if_abap_behv=>mk-on
    ).

    result_exp = VALUE #(
      (
        testid                    = c_test_id_1
        questionid                = c_question_id_1
        %action-movequestionfirst = if_abap_behv=>fc-o-disabled
        %action-movequestionup    = if_abap_behv=>fc-o-disabled
        %action-movequestiondown  = if_abap_behv=>fc-o-enabled
        %action-movequestionlast  = if_abap_behv=>fc-o-enabled
        %action-assignpart        = if_abap_behv=>fc-o-enabled
        %action-refreshquestion   = if_abap_behv=>fc-o-enabled
      )
      (
        testid                    = c_test_id_1
        questionid                = c_question_id_2
        %action-movequestionfirst = if_abap_behv=>fc-o-enabled
        %action-movequestionup    = if_abap_behv=>fc-o-enabled
        %action-movequestiondown  = if_abap_behv=>fc-o-enabled
        %action-movequestionlast  = if_abap_behv=>fc-o-enabled
        %action-assignpart        = if_abap_behv=>fc-o-enabled
        %action-refreshquestion   = if_abap_behv=>fc-o-enabled
      )
      (
        testid                    = c_test_id_1
        questionid                = c_question_id_3
        %action-movequestionfirst = if_abap_behv=>fc-o-enabled
        %action-movequestionup    = if_abap_behv=>fc-o-enabled
        %action-movequestiondown  = if_abap_behv=>fc-o-disabled
        %action-movequestionlast  = if_abap_behv=>fc-o-disabled
        %action-assignpart        = if_abap_behv=>fc-o-enabled
        %action-refreshquestion   = if_abap_behv=>fc-o-enabled
      )
    ).

    class_under_test->get_instance_features(
      EXPORTING
        keys               = CORRESPONDING #( mock_data_question )
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

CLASS ltcl_variant_u DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CONSTANTS: c_test_id_1 TYPE znept_qz_test_id_de VALUE '001',
               c_test_id_2 TYPE znept_qz_test_id_de VALUE '002'.

    CONSTANTS: c_question_id_1 TYPE znept_qz_question_id_de VALUE '0001',
               c_question_id_2 TYPE znept_qz_question_id_de VALUE '0002'.

    CONSTANTS: c_variant_id_1 TYPE znept_qz_variant_id_de VALUE '01',
               c_variant_id_2 TYPE znept_qz_variant_id_de VALUE '02',
               c_variant_id_3 TYPE znept_qz_variant_id_de VALUE '03'.

    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_variant,
      cds_test_environment TYPE REF TO if_cds_test_environment,
      sql_test_environment TYPE REF TO if_osql_test_environment.

    CLASS-DATA:
      mock_data_quiz    TYPE STANDARD TABLE OF znept_qz_i_quiz WITH EMPTY KEY,
      mock_data_variant TYPE STANDARD TABLE OF znept_qz_i_variant WITH EMPTY KEY.

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
      "! Calls { @link ..ltcl_variant_m.METH:get_instance_features }
      "! with all possible in- and outcomes.
      get_instance_features FOR TESTING RAISING cx_static_check,

      "! Checks that { @link ..ltcl_variant_m.METH:get_instance_authorizations } returns initial values
      "! for <em>result</em> and <em>reported</em>.
      get_instance_authorizations FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_variant_u IMPLEMENTATION.

  METHOD class_setup.
    " creating instances
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
      VALUE #( ( i_for_entity = 'ZNEPT_QZ_I_QUIZ_U' )
               ( i_for_entity = 'ZNEPT_QZ_I_VARIANT_U' )
      )
    ).
    sql_test_environment = cl_osql_test_environment=>create(
      VALUE #( ( 'ZNEPT_QZ_TST' )
               ( 'ZNEPT_QZ_VAR' )
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
      requested_authorizations TYPE STRUCTURE FOR AUTHORIZATION REQUEST znept_qz_i_quiz_u\\variant,
      result_act               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_u\\variant,
      result_exp               TYPE TABLE FOR AUTHORIZATION RESULT znept_qz_i_quiz_u\\variant,
      reported                 TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_u,
      failed                   TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_u.

    mock_data_quiz = VALUE #(
      (
        testid   = c_test_id_1
        uploadby = cl_abap_context_info=>get_user_technical_name( )
      )
      (
        testid   = c_test_id_2
        uploadby = '0123456789'
      )
    ).
    cds_test_environment->insert_test_data( mock_data_quiz ).

    mock_data_variant = VALUE #(
      (
        testid     = c_test_id_1
        questionid = c_question_id_1
        variantid  = c_variant_id_1
      )
      (
        testid     = c_test_id_2
        questionid = c_question_id_1
        variantid  = c_variant_id_1
      )
    ).
    cds_test_environment->insert_test_data( mock_data_variant ).

    requested_authorizations-%action-movevariantfirst = if_abap_behv=>mk-on.
    requested_authorizations-%action-movevariantup    = if_abap_behv=>mk-on.
    requested_authorizations-%action-movevariantdown  = if_abap_behv=>mk-on.
    requested_authorizations-%action-movevariantlast  = if_abap_behv=>mk-on.

    result_exp = VALUE #(
      (
        testid                   = c_test_id_1
        questionid               = c_question_id_1
        variantid                = c_variant_id_1
        %action-movevariantfirst = if_abap_behv=>auth-allowed
        %action-movevariantup    = if_abap_behv=>auth-allowed
        %action-movevariantdown  = if_abap_behv=>auth-allowed
        %action-movevariantlast  = if_abap_behv=>auth-allowed
      )
      (
        testid                   = c_test_id_2
        questionid               = c_question_id_1
        variantid                = c_variant_id_1
        %action-movevariantfirst = if_abap_behv=>auth-unauthorized
        %action-movevariantup    = if_abap_behv=>auth-unauthorized
        %action-movevariantdown  = if_abap_behv=>auth-unauthorized
        %action-movevariantlast  = if_abap_behv=>auth-unauthorized
      )
    ).

    class_under_test->get_instance_authorizations(
      EXPORTING
        keys                     = CORRESPONDING #( mock_data_variant )
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

    DATA: failed     TYPE RESPONSE FOR FAILED EARLY znept_qz_i_quiz_u,
          reported   TYPE RESPONSE FOR REPORTED EARLY znept_qz_i_quiz_u,
          requested  TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST znept_qz_i_quiz_u\\variant,
          result_act TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_u\\variant,
          result_exp TYPE TABLE FOR INSTANCE FEATURES RESULT znept_qz_i_quiz_u\\variant.

    mock_data_variant = VALUE #(
      (
        testid     = c_test_id_1
        questionid = c_question_id_1
        variantid  = c_variant_id_1
        sort       = c_variant_id_1
      )
      (
        testid     = c_test_id_1
        questionid = c_question_id_1
        variantid  = c_variant_id_2
        sort       = c_variant_id_2
      )
      (
        testid     = c_test_id_1
        questionid = c_question_id_1
        variantid  = c_variant_id_3
        sort       = c_variant_id_3
      )
    ).
    cds_test_environment->insert_test_data( mock_data_variant ).

    requested = VALUE #(
      %action-movevariantfirst = if_abap_behv=>mk-on
      %action-movevariantup    = if_abap_behv=>mk-on
      %action-movevariantdown  = if_abap_behv=>mk-on
      %action-movevariantlast  = if_abap_behv=>mk-on
    ).

    result_exp = VALUE #(
      (
        testid                   = c_test_id_1
        questionid               = c_question_id_1
        variantid                = c_variant_id_1
        %action-movevariantfirst = if_abap_behv=>fc-o-disabled
        %action-movevariantup    = if_abap_behv=>fc-o-disabled
        %action-movevariantdown  = if_abap_behv=>fc-o-enabled
        %action-movevariantlast  = if_abap_behv=>fc-o-enabled
      )
      (
        testid                   = c_test_id_1
        questionid               = c_question_id_1
        variantid                = c_variant_id_2
        %action-movevariantfirst = if_abap_behv=>fc-o-enabled
        %action-movevariantup    = if_abap_behv=>fc-o-enabled
        %action-movevariantdown  = if_abap_behv=>fc-o-enabled
        %action-movevariantlast  = if_abap_behv=>fc-o-enabled
      )
      (
        testid                   = c_test_id_1
        questionid               = c_question_id_1
        variantid                = c_variant_id_3
        %action-movevariantfirst = if_abap_behv=>fc-o-enabled
        %action-movevariantup    = if_abap_behv=>fc-o-enabled
        %action-movevariantdown  = if_abap_behv=>fc-o-disabled
        %action-movevariantlast  = if_abap_behv=>fc-o-disabled
      )
    ).

    class_under_test->get_instance_features(
      EXPORTING
        keys               = CORRESPONDING #( mock_data_variant )
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
