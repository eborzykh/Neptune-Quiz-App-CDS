//
@EndUserText.label: 'AI Models (Visual Help)'
@ObjectModel: { query: { implementedBy: 'ABAP:ZCL_NEPT_QZ_AI_MODEL_QUERY' } }

@ObjectModel.resultSet.sizeCategory: #XS

define custom entity ZZNEPT_QZ_I_AI_MODEL_VH
{
      //      @ObjectModel.text.element: ['ModelText']
      @ObjectModel.text.element: ['Model']
      @Semantics.text: true
  key Model     : znept_qz_ai_model_de;

      //      @Semantics.text: true
      @UI.hidden: true
      ModelText : znept_qz_ai_model_name_de;
}
