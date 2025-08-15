//
@EndUserText.label: 'Questions (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_QUESTION_U
  as projection on ZNEPT_QZ_I_QUESTION_U
{
  key TestId,
  key QuestionId,

      SortQuestion,
      
      SortPart,

      //      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Agency_StdVH', element: 'AgencyID'  }, useForValidation: true }]
      @Consumption.valueHelpDefinition: [
        { entity: {name: 'ZNEPT_QZ_I_QUESTION_ASSIGN_VH', element: 'PartId' },
          additionalBinding: [ { localElement: 'TestId',    element: 'TestId',    usage: #FILTER} ],
          useForValidation: true }
       ]
      @ObjectModel.text.element: ['PartDescription']
      PartId,

      _Part.Description as PartDescription,

      Question,
      Explanation,

      /* Associations */

      _Quiz    : redirected to parent ZNEPT_QZ_C_QUIZ_U,
      _Part    : redirected to ZNEPT_QZ_C_PART_U,
      _Variant : redirected to composition child ZNEPT_QZ_C_VARIANT_U

      //      , _Part_VH

}
