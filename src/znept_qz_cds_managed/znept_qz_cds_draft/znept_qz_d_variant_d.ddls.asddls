@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Neptune Quiz App (CDS): Variants (Draft)'

define view entity ZNEPT_QZ_D_VARIANT_D
  as select from znept_qz_var_d as Variant
{
  key testid                        as Testid,
  key questionid                    as Questionid,
  key variantid                     as Variantid,
  key draftuuid                     as Draftuuid,
      parentdraftuuid               as Parentdraftuuid,
      sort                          as Sort,
      correct                       as Correct,
      correcttext                   as Correcttext,
      variant                       as Variant,
      version                       as Version,
      quizdraftuuid                 as Quizdraftuuid,
      draftentitycreationdatetime   as Draftentitycreationdatetime,
      draftentitylastchangedatetime as Draftentitylastchangedatetime,
      draftadministrativedatauuid   as Draftadministrativedatauuid,
      draftentityoperationcode      as Draftentityoperationcode,
      hasactiveentity               as Hasactiveentity,
      draftfieldchanges             as Draftfieldchanges
}
