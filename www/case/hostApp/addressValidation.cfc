<!----
<cfset application.AVkey = 'h9inEbK8pjfu9cW8'>
<cfset application.AVpassword = 'xqGg5Fr8UCGsi8LB8YpxF7TNL'>
<cfset application.AVaccount = '510087240'>
<cfset application.AVmeter = '118521870'>



<cffunction name="AddressValidation" access="remote" returntype="string">
  <cfargument name="CompanyName" type="string" required="no" default="">
  <cfargument name="StreetLine1" type="string" required="yes">
  <cfargument name="StreetLine2" type="string" required="no" default="">
  <cfargument name="City"    type="string" required="yes">
  <cfargument name="State"    type="string" required="yes">
  <cfargument name="PostalCode" type="string" required="yes">
  <cfargument name="FatalList" type="string" required="No" default="BOX_NUMBER_REQUIRED,RR_OR_HC_BOX_NUMBER_NEEDED,UNABLE_TO_APPEND_NON_ADDRESS_DATA,INSUFFICIENT_DATA,HOUSE_OR_BOX_NUMBER_NOT_FOUND,POSTAL_CODE_NOT_FOUND,SERVICE_UNAVAILABLE_FOR_ADDRESS">
 <cftry>
 <cfsavecontent variable="avresults.XMLPacket"><cfoutput>
 <ns:AddressValidationRequest
  xsi:schemaLocation="http://www.fedex.com/templates/components/apps/wpor/secure/downloads/xml/Aug09/Advanced/AddressValidationService_v2.xsd"
  xmlns:ns ="http://fedex.com/ws/addressvalidation/v2"
  xmlns:xsi ="http://www.w3.org/2001/XMLSchema-instance">
  <ns:WebAuthenticationDetail>
  <ns:UserCredential>
     <ns:Key>#application.AVkey#</ns:Key>
     <ns:Password>#application.AVpassword#</ns:Password>
  </ns:UserCredential>
  </ns:WebAuthenticationDetail>
  <ns:ClientDetail>
  <ns:AccountNumber>#application.AVaccount#</ns:AccountNumber>
  <ns:MeterNumber>#application.AVmeter#</ns:MeterNumber>
  </ns:ClientDetail>
  <ns:Version>
  <ns:ServiceId>aval</ns:ServiceId>
  <ns:Major>2</ns:Major>
  <ns:Intermediate>0</ns:Intermediate>
  <ns:Minor>0</ns:Minor>
  </ns:Version>
  <ns:RequestTimestamp>#dateformat(now(),"yyyy-mm-dd")#T#TimeFormat(now(),"HH:mm:ss")#</ns:RequestTimestamp>
  <ns:Options>
  <ns:CheckResidentialStatus>1</ns:CheckResidentialStatus>
  <ns:MaximumNumberOfMatches>5</ns:MaximumNumberOfMatches>
  <ns:StreetAccuracy>MEDIUM</ns:StreetAccuracy>
  <ns:DirectionalAccuracy>MEDIUM</ns:DirectionalAccuracy>
  <ns:CompanyNameAccuracy>MEDIUM</ns:CompanyNameAccuracy>
  <ns:ConvertToUpperCase>1</ns:ConvertToUpperCase>
  <ns:RecognizeAlternateCityNames>1</ns:RecognizeAlternateCityNames>
  <ns:ReturnParsedElements>1</ns:ReturnParsedElements>
  </ns:Options>
  <ns:AddressesToValidate>
  <ns:AddressId>1</ns:AddressId>
  <cfif len(arguments.CompanyName)><ns:CompanyName>#arguments.CompanyName#</ns:CompanyName></cfif>
  <ns:Address>
     <ns:StreetLines>#trim(arguments.StreetLine1)#</ns:StreetLines>
     <cfif len(arguments.StreetLine2)><ns:StreetLines>#trim(arguments.StreetLine2)#</ns:StreetLines></cfif>
     <ns:City>#arguments.City#</ns:City>
     <ns:StateOrProvinceCode>#arguments.State#</ns:StateOrProvinceCode>
     <ns:PostalCode>#arguments.PostalCode#</ns:PostalCode>
     <ns:CountryCode>US</ns:CountryCode>
  </ns:Address>
  </ns:AddressesToValidate>
 </ns:AddressValidationRequest>
 </cfoutput></cfsavecontent>
  <cfhttp url="#application.AVserver#" port="443" method ="POST" throwonerror="yes">
     <cfhttpparam name="name" type="XML" value="#avresults.XMLPacket#">
  </cfhttp>
 
  <cfset vari    = XMLParse(CFHTTP.FileContent)>
 
  <cfset avresults.msg    = "">
  <cfset avresults.changed    = "">
  <cfset vari = vari.AddressValidationReply.AddressResults.ProposedAddressDetails>
  <!--- ************************************************************************** --->
  <!--- check fatal error                                                         --->
  <!--- ************************************************************************** --->
  <cfloop from="1" to="#ArrayLen(vari.XmlChildren)#" index="i">
     <cfif listlast(vari.XmlChildren[i].XmlName,':') eq 'Changes'>
     <cfif listfind(arguments.FatalList,vari.XmlChildren[i].XmlText)>
      <cfset avresults.msg = 'False'>
     </cfif>
     </cfif>
  </cfloop>
 
  <!--- ************************************************************************** --->
  <!--- Post box address                                                            --->
  <!--- ************************************************************************** --->

  <cfif IsDefined('vari.ParsedAddress.ParsedStreetLine.Elements.Name.XmlText') and vari.ParsedAddress.ParsedStreetLine.Elements.Name.XmlText eq 'postOfficeBoxNumber'>
     <cfif not len(avresults.msg)>
     <cfset avresults.msg = "FedEx cannot deliver to P.O. boxes">
     </cfif>
  </cfif>
  <!--- ************************************************************************** --->
  <!--- check if address changed                                                    --->
  <!--- ************************************************************************** --->
  <cfif not len(avresults.msg)>
     <cfloop from="1" to="#ArrayLen(vari.ParsedAddress.ParsedStreetLine.XmlChildren)#" index="i">
     <cfif vari.ParsedAddress.ParsedStreetLine.Elements[i].Changes.XmlText neq 'NO_CHANGES'>
      <cfset avresults.changed = "1">
     </cfif>
     </cfloop>
     <cfif vari.ParsedAddress.ParsedCity.Elements.Changes.XmlText neq 'NO_CHANGES'>
     <cfset avresults.changed = "1">
     </cfif>
     <cfif vari.ParsedAddress.ParsedStateOrProvinceCode.Elements.Changes.XmlText neq 'NO_CHANGES'>
     <cfset avresults.changed = "1">
     </cfif>
     <cfif vari.ParsedAddress.ParsedStateOrProvinceCode.Elements.Changes.XmlText neq 'NO_CHANGES'>
     <cfset avresults.changed = "1">
     </cfif>
     <cfif vari.ParsedAddress.ParsedPostalCode.Elements.Changes.XmlText neq 'NO_CHANGES'>
     <cfset avresults.changed = "1">
     </cfif>
  </cfif>
  <!--- ************************************************************************** --->
  <!--- Fedex Retrun Same Address . a Workaround                                 --->
  <!--- ************************************************************************** --->
  <cfset avresults.match = 0>
  <cfset avresults.StreetLines = trim(replace('#arguments.StreetLine1# #arguments.StreetLine2#',' ',' ','all'))>
  <cfif avresults.StreetLines eq vari.Address.StreetLines.XmlText>
     <cfset avresults.match = avresults.match+1>
  </cfif>
  <cfif trim(arguments.City) eq vari.Address.City.XmlText>
     <cfset avresults.match = avresults.match+1>
  </cfif>
  <cfif trim(arguments.State) eq vari.Address.StateOrProvinceCode.XmlText>
     <cfset avresults.match = avresults.match+1>
  </cfif>
  <cfif trim(listfirst(arguments.PostalCode,'-')) eq listfirst(vari.Address.PostalCode.XmlText,'-')>
     <cfset avresults.match = avresults.match+1>
  </cfif>
 
  <!--- ************************************************************************** --->
  <!--- get the new address                                                        --->
  <!--- ************************************************************************** --->
  <cfif val(avresults.changed) and avresults.match neq 4>
     <cfset ProposedAddress = ArrayNew(1)>
     <cfloop from="1" to="#ArrayLen(vari.Address.XmlChildren)#" index="i">
     <cfset ArrayAppend(ProposedAddress,vari.Address.XmlChildren[i].XmlText)>
     </cfloop>
     <cfset avresults.ProposedAddress = ArrayToList(ProposedAddress,'<br />')>
  <cfelse>
     <cfset avresults.ProposedAddress = "">
  </cfif>
 
  <cfset avresults.out = "#avresults.msg##avresults.ProposedAddress#">
  <cfcatch>
  <cfset avresults.out = "FedEx cannot verify Your address at this time. Please try again.">
  </cfcatch>
 </cftry>
  <cfreturn trim(avresults.out)>
  </cffunction>


<cfinvoke component="AddressValidation" method="AddressValidation">
 <!----
   <cfinvokeargument name="address" value="408 NE 6th St">
   <cfinvokeargument name="city" value="Ft Lauderdale">
   <cfinvokeargument name="state" value="ID">
	<cfinvokeargument name="zip" value="3">
	---->
  
  <cfinvokeargument name="StreetLine1" value="408 NE 6th">
  <cfinvokeargument name="StreetLine2" value= "Unit 638">
  <cfinvokeargument name="City"   value="Ft Lauderdale" >
  <cfinvokeargument name="State"    value = "FL">
  <cfinvokeargument name="PostalCode"  value="83204">
</cfinvoke>
---->


  <cffunction name="AddressVerification" access="remote" returntype="struct" output="true">
   <cfargument name="address"    type="string" required="yes">
  <cfargument name="city"    type="string" required="yes">
  <cfargument name="state"    type="string" required="yes">
  <cfargument name="zip"    type="string" required="yes">
  <cfargument name="country"    type="string" required="No" default="US">
  <cfargument name="License"    type="string" required="No" default="CC6D646D5DDC5CA8">
  <cfargument name="UserId"    type="string" required="No" default="rahljosh">
  <cfargument name="Password" type="string" required="No" default="raul4387">
  <cfargument name="Request"    type="string" required="No" default="3">
  
 <cfset var local = StructNew()>

  <cfsavecontent variable="avresults.reqxml"><cfoutput>
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
     <RequestAction>AV</RequestAction>
     <RequestOption>#arguments.Request#</RequestOption>
   </Request>
      <AddressKeyFormat>
       <AddressLine>#arguments.address#</AddressLine>
       <PoliticalDivision2>#arguments.city#</PoliticalDivision2>
       <PoliticalDivision1>#arguments.state#</PoliticalDivision1>
       <PostcodePrimaryLow>#arguments.zip#</PostcodePrimaryLow>
       <CountryCode>#arguments.country#</CountryCode>
       </AddressKeyFormat>
    </AddressValidationRequest>
    </cfoutput></cfsavecontent>
    <cfset avresults.out    = StructNew()>
    <cfset avresults.out.validation = "">
    <cfset avresults.out.address = "">
    <cfset avresults.out.city    = "">
    <cfset avresults.out.state    = "">
    <cfset avresults.out.zip    = "">
    <cfset avresults.out.country = "">
   
    <cftry>
    <cfhttp url="https://wwwcie.ups.com/ups.app/xml/XAV" method="post" result="result">
    <cfhttpparam type="xml" name="data" value="#avresults.reqxml#">
    </cfhttp>
    <cfset avresults.results = XMLParse(result.Filecontent)>
    <cfcatch>
       <cfset avresults.out.validation    = "False">
       <cfset avresults.out.type    = "Failure">
       <cfset avresults.out.ErrorDescription = "Connection Failure">
    </cfcatch>
    </cftry>
   
    <cfif IsDefined('avresults.results.AddressValidationResponse.AddressClassification.Description.XmlText')>
    <cfset avresults.out.type = avresults.results.AddressValidationResponse.AddressClassification.Description.XmlText>
    <cfif not IsDefined('avresults.results.AddressValidationResponse.AddressKeyFormat')>
       <cfset avresults.out.validation = "False">
    <cfelse>
       <cfset avresults.out.validation = "True">
       <cfif not avresults.results.AddressValidationResponse.AddressKeyFormat.AddressLine.XmlText eq trim(arguments.address) or
       not avresults.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision2.XmlText eq trim(arguments.city) or
       not avresults.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision1.XmlText eq trim(arguments.state) or
       not avresults.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText eq trim(listfirst(arguments.zip,'-'))>
       <cfif IsDefined('avresults.results.AddressValidationResponse.AddressKeyFormat.AddressLine.XmlText')>
        <cfset avresults.out.address = avresults.results.AddressValidationResponse.AddressKeyFormat.AddressLine.XmlText>
       </cfif>
       <cfif IsDefined('avresults.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision2.XmlText')>
        <cfset avresults.out.city = avresults.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision2.XmlText>
       </cfif>
       <cfif IsDefined('avresults.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision1.XmlText')>
        <cfset avresults.out.state = avresults.results.AddressValidationResponse.AddressKeyFormat.PoliticalDivision1.XmlText>
       </cfif>
       <cfif IsDefined('avresults.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText')>
        <cfset avresults.out.zip = avresults.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText>
       </cfif>
       <cfif IsDefined('avresults.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText')>
        <cfset avresults.out.zip = avresults.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText>
        <cfif IsDefined('avresults.results.AddressValidationResponse.AddressKeyFormat.PostcodeExtendedLow.XmlText')>
        <cfset avresults.out.zip = '#avresults.results.AddressValidationResponse.AddressKeyFormat.PostcodePrimaryLow.XmlText#-#avresults.results.AddressValidationResponse.AddressKeyFormat.PostcodeExtendedLow.XmlText#'>
        </cfif>
       </cfif>
       <cfif IsDefined('avresults.results.AddressValidationResponse.AddressKeyFormat.AddressLine.XmlText')>
        <cfset avresults.out.country = avresults.results.AddressValidationResponse.AddressKeyFormat.CountryCode.XmlText>
       </cfif>
       </cfif>
    </cfif>
    <cfelse>
    <cfset avresults.out.validation    = "False">
    <cfset avresults.out.type    = "Failure">
    <cfif IsDefined('avresults.results.AddressValidationResponse.Response.Error.ErrorDescription.XmlText')>
       <cfset avresults.out.ErrorDescription = avresults.results.AddressValidationResponse.Response.Error.ErrorDescription.XmlText>
    <cfelse>
       <cfset avresults.out.ErrorDescription = "">
   </cfif>
   </cfif>
  
   <cfreturn avresults.out>

  </cffunction>


<cfoutput>
#AddressVerification(address='408 NE 6th', city='Ft Lauderdale', state='FL', zip='33304')
</cfoutput>
