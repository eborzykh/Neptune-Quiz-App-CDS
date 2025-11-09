CLASS lhc_quiz DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR quiz RESULT result.

    METHODS settestid FOR DETERMINE ON MODIFY IMPORTING keys FOR quiz~settestid.

*    METHODS settestid FOR DETERMINE ON SAVE IMPORTING keys FOR quiz~settestid.

ENDCLASS.

CLASS lhc_quiz IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD settestid.
*
*    READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
*    ENTITY quiz
*    FIELDS ( testid )
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(quizzes).
*
*    DELETE quizzes WHERE testid IS NOT INITIAL.
*    CHECK quizzes IS NOT INITIAL.
*
*    "Get max ID
*    SELECT SINGLE FROM znept_qz_i_quiz_d FIELDS MAX( testid ) INTO @DATA(max_testid).
*
*    MODIFY ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
*      ENTITY quiz
*        UPDATE FIELDS ( testid )
*        WITH VALUE #( FOR quize IN quizzes INDEX INTO i (
*                           %tky     = quize-%tky
*                           testid   = max_testid + i ) ).
**                           uploadby = sy-uname
**                           uploadon = sy-datlo
**                           uploadat = sy-timlo ) ).
*
*
**    READ ENTITIES OF /DMO/R_Travel_D IN LOCAL MODE
**      ENTITY Travel
**        FIELDS ( TravelID )
**        WITH CORRESPONDING #( keys )
**      RESULT DATA(travels).
**
**    DELETE travels WHERE TravelID IS NOT INITIAL.
**    CHECK travels IS NOT INITIAL.
**
**    "Get max travelID
**    SELECT SINGLE FROM /dmo/a_travel_d FIELDS MAX( travel_id ) INTO @DATA(max_travelid).
**
**    "update involved instances
**    MODIFY ENTITIES OF /DMO/R_Travel_D IN LOCAL MODE
**      ENTITY Travel
**        UPDATE FIELDS ( TravelID )
**        WITH VALUE #( FOR travel IN travels INDEX INTO i (
**                           %tky      = travel-%tky
**                           TravelID  = max_travelid + i ) ).
*
*  ENDMETHOD.

  METHOD setTestId.

*    READ ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
*    ENTITY quiz
*    FIELDS ( testid )
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(quizzes).
*
*    DELETE quizzes WHERE testid IS NOT INITIAL.
*    CHECK quizzes IS NOT INITIAL.
*
*    "Get max ID
*    SELECT SINGLE FROM znept_qz_i_quiz_d FIELDS MAX( testid ) INTO @DATA(max_testid).
*
*    MODIFY ENTITIES OF znept_qz_i_quiz_d IN LOCAL MODE
*      ENTITY quiz
*        UPDATE FIELDS ( testid )
*        WITH VALUE #( FOR quize IN quizzes INDEX INTO i (
*                           %tky     = quize-%tky
*                           testid   = max_testid + i ) ).
**                           uploadby = sy-uname
**                           uploadon = sy-datlo
**                           uploadat = sy-timlo ) ).


  ENDMETHOD.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_d DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_znept_qz_i_quiz_d IMPLEMENTATION.

  METHOD adjust_numbers.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
