//
@EndUserText.label: 'Quiz (ValueHelp)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE
@Search.searchable: true

define root view entity ZNEPT_QZ_I_QUIZ_VH
  as select from ZNEPT_QZ_I_QUIZ as _Quiz

{
  key _Quiz.TestId         as TestId,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      _Quiz.Description    as Description,

      _Quiz.UploadOn       as UploadOn,
      _Quiz.UploadAt       as UploadAt,
      _Quiz.UploadBy       as UploadBy,
      _Quiz.Upload_By_Name as Upload_By_Name,

      _Quiz.PublishedText  as UI_Published
}
