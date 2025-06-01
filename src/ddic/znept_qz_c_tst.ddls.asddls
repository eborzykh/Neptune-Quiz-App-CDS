@AbapCatalog.sqlViewName: 'ZNEPT_QZ_V_C_TST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Quiz (Consumption)'

@Metadata.allowExtensions: true

define root view ZNEPT_QZ_C_TST
  as select from ZNEPT_QZ_I_TST as _Quiz

  composition [0..*] of ZNEPT_QZ_C_PRT as _Parts

  association [0..*] to ZNEPT_QZ_C_QST as _Questions on $projection.Test_ID = _Questions.Test_ID

{
  key _Quiz.Test_ID         as Test_ID,

      _Quiz.Upload_On       as Upload_On,
      _Quiz.Upload_At       as Upload_At,
      _Quiz.Upload_By       as Upload_By,
      _Quiz.Published       as Published,
      _Quiz.Description     as Description,

      _Quiz.Parts_Count     as Parts_Count,
      _Quiz.Questions_Count as Questions_Count,

      _Quiz.Upload_By_Name  as Upload_By_Name,

      case
        when _Quiz.Parts_Count > 0 then '' else 'X'
      end                    as UI_Hide_Parts,

      case
        when _Quiz.Parts_Count > 0 then 'X' else ''
      end                    as UI_Hide_Questions,

      case
        when _Quiz.Published is initial then 'Private'
        else 'Published'
      end                    as UI_Published,

      /* Associations */

      _Parts,
      _Questions

}

