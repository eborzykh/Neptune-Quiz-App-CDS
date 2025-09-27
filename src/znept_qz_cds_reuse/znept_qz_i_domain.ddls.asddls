//
@EndUserText.label: 'Neptune Quiz App (CDS): Domain Values'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZNEPT_QZ_I_DOMAIN
  with parameters
    p_domain_name : sxco_ad_object_name --abap.char(30)
  as select from dd07t
{

  key domname    as domain_name,
  key valpos     as value_position,
  key ddlanguage as language,

      @UI.hidden
  key as4local   as As4local,
      @UI.hidden
  key as4vers    as As4vers,

      domvalue_l as Value,
      @Semantics.text: true
      ddtext     as Description

}
where
      domname        = $parameters.p_domain_name
  and dd07t.as4local = 'A'

// DDCDS_CUSTOMER_DOMAIN_VALUE and DDCDS_CUSTOMER_DOMAIN_VALUE_T
// https://community.sap.com/t5/technology-blogs-by-members/how-to-read-domain-values-using-abap-cds-entity-view/bc-p/13535561/highlight/true#M157709
