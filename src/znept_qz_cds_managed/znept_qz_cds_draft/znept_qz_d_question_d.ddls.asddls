@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Neptune Quiz App (CDS): Question (Draft)'

define view entity ZNEPT_QZ_D_QUESTION_D
  as select from znept_qz_qst_d as Question
{
  key testid                        as Testid,
  key questionid                    as Questionid,
  key draftuuid                     as Draftuuid,
      parentdraftuuid               as Parentdraftuuid,
      sort                          as Sort,
      partid                        as Partid,
      question                      as Question,
      explanation                   as Explanation,
      version                       as Version,
      draftentitycreationdatetime   as Draftentitycreationdatetime,
      draftentitylastchangedatetime as Draftentitylastchangedatetime,
      draftadministrativedatauuid   as Draftadministrativedatauuid,
      draftentityoperationcode      as Draftentityoperationcode,
      hasactiveentity               as Hasactiveentity,
      draftfieldchanges             as Draftfieldchanges
}
