//
@EndUserText.label: 'Parts (Basic Reuse)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_PART 
  as select from znept_qz_prt as _Part
{
  key _Part.test_id     as TestId,
  key _Part.part_id     as PartId,

      _Part.description as Description,
      _Part.version     as Version, // to be replaced with hash-key

      case
        when _Part.sort is initial then _Part.part_id
        else _Part.sort
      end               as Sort
}
