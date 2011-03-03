
<cffunction name="AddressVerification" access="remote" returntype="struct" output="true">
  <cfargument name="address"    type="string" required="yes">
  <cfargument name="city"    type="string" required="yes">
  <cfargument name="state"    type="string" required="yes">
  <cfargument name="zip"    type="string" required="yes">
  <cfargument name="country"    type="string" required="No" default="US">
  <cfargument name="License"    type="string" required="No" default="CC6D646D5DDC5CA8">
  <cfargument name="UserId"    type="string" required="No" default="rahljosh">
  <cfargument name="Password" type="string" required="No" default="raul43">
  <cfargument name="Request"    type="string" required="No" default="3">
 
  <cfset var local = StructNew()>
 
  <cfsavecontent variable="local.reqxml"><cfoutput>
  <?xml version="1.0"?>
  <AccessRequest xml:lang="en-US">
     <AccessLicenseNumber>#arguments.License#</AccessLicenseNumber>
     <UserId>#arguments.UserId#</UserId>
     <Password>#arguments.Password#</Password>
  </AccessRequest>
  <?xml version="1.0"?>
  <AddressValidationRequest xml:lang="en-US">
     <Request>
     <TransactionReference>
      <CustomerContext>Address Varification</CustomerContext>
      <XpciVersion>1.0</XpciVersion>
     </TransactionReference>
     <RequestAction>XAV</RequestAction>
     <RequestOption>#arguments.Request#</RequestOption>
     </Request>
     <AddressKeyFormat>
     <AddressLine>408 NE 6th St</AddressLine>
     <PoliticalDivision2>Ft Lauderdale</PoliticalDivision2>
     <PoliticalDivision1>FL</PoliticalDivision1>
     <PostcodePrimaryLow>83204</PostcodePrimaryLow>
     <CountryCode>US</CountryCode>
     </AddressKeyFormat>
  </AddressValidationRequest>
  </cfoutput></cfsavecontent>
  <cfset local.out    = StructNew()>
  <cfset local.out.validation = "">
  <cfset local.out.address = "">
  <cfset local.out.city    = "">
  <cfset local.out.state    = "">
  <cfset local.out.zip    = "">
  <cfset local.out.country = "">
 
  <cftry>
  <cfhttp url="https://wwwcie.ups.com/ups.app1/xml/XAV" method="post" result="result">
  <cfhttpparam type="xml" name="data" value="#local.reqxml#">
  </cfhttp>
  <cfset local.results = XMLParse(result.Filecontent)>
  <cfcatch>
     <cfset local.out.validation    = "False">
     <cfset local.out.type    = "Failure">
     <cfset local.out.ErrorDescription = "Connection Failure">
  </cfcatch>
  </cftry>
 
  <cfif IsDefined('local.results.AddressValidationResponse.AddressClassification.Description.XmlText')>
  <cfset local.out.type = local.results.AddressValidationResponse.AddressClassification.Description.XmlText>
  <cfif not IsDefined('local.results.AddressValidationResponse.AddressKeyFormat')>
     <cfset local.out.validation = "False">
  <cfelse>
     <cfset local.out.validation = "True">
     <cfif not local.results.AddressValidationResponse.AddressKeyFormat.AddressLine.XmlText eq trim(arguments.address) or
     not local.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision2.XmlText eq trim(arguments.city) or
     not local.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision1.XmlText eq trim(arguments.state) or
     not local.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText eq trim(listfirst(arguments.zip,'-'))>
     <cfif IsDefined('local.results.AddressValidationResponse.AddressKeyFormat.AddressLine.XmlText')>
      <cfset local.out.address = local.results.AddressValidationResponse.AddressKeyFormat.AddressLine.XmlText>
     </cfif>
     <cfif IsDefined('local.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision2.XmlText')>
      <cfset local.out.city = local.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision2.XmlText>
     </cfif>
     <cfif IsDefined('local.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision1.XmlText')>
      <cfset local.out.state = local.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision1.XmlText>
     </cfif>
     <cfif IsDefined('local.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText')>
      <cfset local.out.zip = local.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText>
     </cfif>
     <cfif IsDefined('local.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText')>
      <cfset local.out.zip = local.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText>
      <cfif IsDefined('local.results.AddressValidationResponse.AddressKeyFormat.PostcodeExtendedLow.XmlText')>
      <cfset local.out.zip = '#local.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText#-#local.results.AddressValidationResponse.AddressKeyFormat.PostcodeExtendedLow.XmlText#'>
      </cfif>
     </cfif>
     <cfif IsDefined('local.results.AddressValidationResponse.AddressKeyFormat.AddressLine.XmlText')>
      <cfset local.out.country = local.results.AddressValidationResponse.AddressKeyFormat.CountryCode.XmlText>
     </cfif>
     </cfif>
  </cfif>
  <cfelse>
  <cfset local.out.validation    = "False">
  <cfset local.out.type    = "Failure">
  <cfif IsDefined('local.results.AddressValidationResponse.Response.Error.ErrorDescription.XmlText')>
     <cfset local.out.ErrorDescription = local.results.AddressValidationResponse.Response.Error.ErrorDescription.XmlText>
  <cfelse>
     <cfset local.out.ErrorDescription = "">
  </cfif>
  </cfif>
 
  <cfreturn local.out>
 </cffunction>

<cfoutput>

</cfoutput>

