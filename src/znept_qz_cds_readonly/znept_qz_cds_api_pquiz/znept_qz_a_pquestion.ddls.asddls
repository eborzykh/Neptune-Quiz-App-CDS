//
@EndUserText.label: 'Personalised Questions (Basic)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.lifecycle.contract.type: #PUBLIC_REMOTE_API
@VDM.viewType: #CONSUMPTION

define view entity ZNEPT_QZ_A_PQUESTION
  as projection on ZNEPT_QZ_I_PQUESTION as _Question

{
  key TestId,
  key QuestionId,

      PartId,
      Part_Description,
      Question,
      Explanation,
      Sort,
      Part_Sort,
      SyncId,
      Progress,
      No_Progress,

      /* Associations */

      _Quiz    : redirected to parent ZNEPT_QZ_A_PQUIZ,
      _Variant : redirected to composition child ZNEPT_QZ_A_PVARIANT,
      _Part
}
