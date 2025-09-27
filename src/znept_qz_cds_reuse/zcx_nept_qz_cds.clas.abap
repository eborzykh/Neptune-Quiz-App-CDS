class ZCX_NEPT_QZ_CDS definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  constants:
    BEGIN OF quiz_key_initial,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_key_initial .
  constants:
    BEGIN OF part_key_initial,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF part_key_initial .
  constants:
    BEGIN OF question_key_initial,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF question_key_initial .
  constants:
    BEGIN OF variant_key_initial,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF variant_key_initial .
  constants:
    BEGIN OF quiz_not_exist,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '016',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_not_exist .
  constants:
    BEGIN OF part_not_exist,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '017',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF part_not_exist .
  constants:
    BEGIN OF question_not_exist,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '018',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF question_not_exist .
  constants:
    BEGIN OF variant_not_exist,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '019',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF variant_not_exist .
  constants:
*032 Quiz is locked by
    begin of QUIZ_IS_LOCKED,
      msgid type symsgid value 'ZNEPT_QZ_CDS',
      msgno type symsgno value '032',
      attr1 type scx_attrname value 'MV_QUIZ_ID',
      attr2 type scx_attrname value 'MV_UNAME',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of QUIZ_IS_LOCKED .
  constants:
    BEGIN OF not_authorized,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '046',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_authorized .
  constants:
    BEGIN OF quiz_create_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '100',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_create_error .
  constants:
    BEGIN OF quiz_update_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '101',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_update_error .
  constants:
    BEGIN OF quiz_delete_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '102',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_delete_error .
  constants:
    BEGIN OF quiz_publish_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '103',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF quiz_publish_error .
  constants:
    BEGIN OF part_create_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '104',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF part_create_error .
  constants:
    BEGIN OF part_update_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '105',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF part_update_error .
  constants:
    BEGIN OF part_delete_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '106',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF part_delete_error .
  constants:
    BEGIN OF question_create_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '107',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF question_create_error .
  constants:
    BEGIN OF question_update_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '108',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF question_update_error .
  constants:
    BEGIN OF question_delete_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '109',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF question_delete_error .
  constants:
    BEGIN OF variant_create_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '110',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF variant_create_error .
  constants:
    BEGIN OF variant_update_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '111',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF variant_update_error .
  constants:
    BEGIN OF variant_delete_error,
        msgid TYPE symsgid VALUE 'ZNEPT_QZ_CDS',
        msgno TYPE symsgno VALUE '112',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF variant_delete_error .
  constants:
    begin of PART_IS_USED,
      msgid type symsgid value 'ZNEPT_QZ_CDS',
      msgno type symsgno value '170',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of PART_IS_USED .
  constants GC_MSGID type SYMSGID value 'ZNEPT_QZ_CDS' ##NO_TEXT.
  data MV_UNAME type SYUNAME .
  data MV_QUIZ_ID type ZNEPT_QZ_TEST_ID_DE .
  data MV_PART_ID type ZNEPT_QZ_PART_ID_DE .
  data MV_QUESTION_ID type ZNEPT_QZ_QUESTION_ID_DE .
  data MV_VARIANT_ID type ZNEPT_QZ_VARIANT_ID_DE .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MV_UNAME type SYUNAME optional
      !MV_QUIZ_ID type ZNEPT_QZ_TEST_ID_DE optional
      !MV_PART_ID type ZNEPT_QZ_PART_ID_DE optional
      !MV_QUESTION_ID type ZNEPT_QZ_QUESTION_ID_DE optional
      !MV_VARIANT_ID type ZNEPT_QZ_VARIANT_ID_DE optional .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_NEPT_QZ_CDS IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MV_UNAME = MV_UNAME .
me->MV_QUIZ_ID = MV_QUIZ_ID .
me->MV_PART_ID = MV_PART_ID .
me->MV_QUESTION_ID = MV_QUESTION_ID .
me->MV_VARIANT_ID = MV_VARIANT_ID .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
