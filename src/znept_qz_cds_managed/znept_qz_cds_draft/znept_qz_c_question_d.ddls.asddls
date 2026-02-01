//
@EndUserText.label: 'Questions (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZNEPT_QZ_C_QUESTION_D
  as projection on ZNEPT_QZ_I_QUESTION_D 
{
  key TestId,
  key QuestionId,

      Sort,

      @Consumption.valueHelpDefinition: [ { entity: {name: 'ZNEPT_QZ_I_QUESTION_ASSIGN_VH', element: 'PartId' },
                                            additionalBinding: [ { localElement: 'TestId', element: 'TestId', usage: #FILTER} ],
                                            useForValidation: true } ]
      @ObjectModel.text.element: ['PartDescription']
      PartId,
      _Part.Description as PartDescription,

      Question,
      Explanation,

      Version,

      _Part.Sort        as SortPart,

      /* Associations */

      _Quiz    : redirected to parent ZNEPT_QZ_C_QUIZ_D,
      _Part    : redirected to ZNEPT_QZ_C_PART_D,
      _Variant : redirected to composition child ZNEPT_QZ_C_VARIANT_D
}
