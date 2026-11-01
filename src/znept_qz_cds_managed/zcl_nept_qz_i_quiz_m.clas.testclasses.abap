"!@testing ZNEPT_QZ_I_QUIZ_M
CLASS ltc_znept_qz_i_quiz_m DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA environment TYPE REF TO if_cds_test_environment.

    DATA td_znept_qz_i_quiz TYPE STANDARD TABLE OF znept_qz_i_quiz WITH EMPTY KEY.
    DATA act_results TYPE STANDARD TABLE OF znept_qz_i_quiz_m WITH EMPTY KEY.
    DATA exp_results TYPE STANDARD TABLE OF znept_qz_i_quiz_m WITH EMPTY KEY.

    "! In CLASS_SETUP, corresponding doubles and clone(s) for the CDS view under test and its dependencies are created.
    CLASS-METHODS class_setup RAISING cx_static_check.
    "! In CLASS_TEARDOWN, Generated database entities (doubles & clones) should be deleted at the end of test class execution.
    CLASS-METHODS class_teardown.

    "! SETUP method creates a common start state for each test method,
    "! clear_doubles clears the test data for all the doubles used in the test method before each test method execution.
    METHODS setup RAISING cx_static_check.

    "! In this method test data is inserted into the generated double(s) for test case
    "! "Test ZNEPT_QZ_I_QUIZ_M."
    METHODS td_test_cds_view.

    "! <strong>Test Case:</strong> Test ZNEPT_QZ_I_QUIZ_M. <br><br>
    "! Test CDS View as a whole.
    "! <br><br> The results should be asserted with the actuals.
    METHODS test_cds_view FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_ZNEPT_QZ_I_QUIZ_M IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create( i_for_entity = 'ZNEPT_QZ_I_QUIZ_M' ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.

  METHOD test_cds_view.
    td_test_cds_view( ).
    SELECT * FROM znept_qz_i_quiz_m INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
  ENDMETHOD.

  METHOD td_test_cds_view.
    " Prepare test data for 'znept_qz_i_quiz'
    td_znept_qz_i_quiz = VALUE #(
      (
        testid = '1234'
        published = 'X'
      ) ).
    environment->insert_test_data( i_data = td_znept_qz_i_quiz ).

    " Prepare test data for 'znept_qz_i_quiz_m'
    exp_results = VALUE #(
      (
           testid = '1234'
           published = 'X'
      ) ).
  ENDMETHOD.

ENDCLASS.
