//
@EndUserText.label: 'Variants (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_VARIANT
  as select from znept_qz_var as _Variant
{
  key _Variant.test_id     as TestId,
  key _Variant.question_id as QuestionId,
  key _Variant.variant_id  as VariantId,

      _Variant.correct     as Correct,
      _Variant.variant     as Variant,
      _Variant.version     as Vesrion, // to be replaced with hash-key

      case
        when _Variant.sort is initial then _Variant.variant_id
        else _Variant.sort
      end                  as Sort
}
