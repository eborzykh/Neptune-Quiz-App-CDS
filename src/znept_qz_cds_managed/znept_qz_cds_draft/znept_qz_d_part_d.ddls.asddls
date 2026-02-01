@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Neptune Quiz App (CDS): Parts (Draft)'

define view entity ZNEPT_QZ_D_PART_D
  as select from znept_qz_prt_d as Part
{
  key testid                        as Testid,
  key partid                        as Partid,
  key draftuuid                     as Draftuuid,
      parentdraftuuid               as Parentdraftuuid,
      sort                          as Sort,
      description                   as Description,
      version                       as Version,
      draftentitycreationdatetime   as Draftentitycreationdatetime,
      draftentitylastchangedatetime as Draftentitylastchangedatetime,
      draftadministrativedatauuid   as Draftadministrativedatauuid,
      draftentityoperationcode      as Draftentityoperationcode,
      hasactiveentity               as Hasactiveentity,
      draftfieldchanges             as Draftfieldchanges
}
