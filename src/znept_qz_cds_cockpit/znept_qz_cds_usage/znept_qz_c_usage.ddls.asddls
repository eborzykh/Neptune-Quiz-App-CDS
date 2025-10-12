//
@EndUserText.label: 'Usage Data (Consumption)'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

define root view entity ZNEPT_QZ_C_USAGE
  provider contract transactional_query
  as projection on ZNEPT_QZ_I_USAGE
{

  key     SyncId,

          SyncBy,
          TestId,
          UploadOn,
          UploadAt,

          Description,

          Total,
          Progress,

          Progress as Progress_Percent,
          Progress as Progress_Number,

          Correct,
          Improved,
          Incorrect,
          Unanswered,

          FirstOn,
          LastOn,
          UseDays,
          LastOnDays,

          CriticalityCode,

          TextTitle,
          TextDescription,

          /* Associations */
 
          _Usage_Details : redirected to composition child ZNEPT_QZ_C_USAGE_DETAILS
}
