//
@EndUserText.label: 'Trivia Category (Visual Help)'
@ObjectModel: { query: { implementedBy: 'ABAP:ZCL_NEPT_QZ_TRIVIA_CATEG_QUERY' } }

define custom entity ZNEPT_QZ_I_TRIVIA_CAT_QUERY_VH
{
      @ObjectModel.text.element: ['CategoryText']
  key Category     : znept_qz_trivia_category_id_de;

      @Semantics.text: true
      CategoryText : znept_qz_trivia_catname_de;
}
