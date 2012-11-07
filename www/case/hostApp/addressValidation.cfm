 <cffunction name="AddressValidation" access="remote" returntype="string">
  <cfargument name="CompanyName" type="string" required="no" default="">
  <cfargument name="StreetLine1" type="string" required="yes">
  <cfargument name="StreetLine2" type="string" required="no" default="">
  <cfargument name="City"    type="string" required="yes">
  <cfargument name="State"    type="string" required="yes">
  <cfargument name="PostalCode" type="string" required="yes">
  <cfargument name="FatalList" type="string" required="No" default="BOX_NUMBER_REQUIRED,RR_OR_HC_BOX_NUMBER_NEEDED,UNABLE_TO_APPEND_NON_ADDRESS_DATA,INSUFFICIENT_DATA,HOUSE_OR_BOX_NUMBER_NOT_FOUND,POSTAL_CODE_NOT_FOUND,SERVICE_UNAVAILABLE_FOR_ADDRESS">
 <cftry>
 <cfsavecontent variable="local.XMLPacket"><cfoutput>
 <ns:AddressValidationRequest
  xsi:schemaLocation="http://www.fedex.com/templates/components/apps/wpor/secure/downloads/xml/Aug09/Advanced/AddressValidationService_v2.xsd"
  xmlns:ns ="http://fedex.com/ws/addressvalidation/v2"
  xmlns:xsi ="http://www.w3.org/2001/XMLSchema-instance">
  <ns:WebAuthenticationDetail>
  <ns:UserCredential>
     <ns:Key>h9inEbK8pjfu9cW8</ns:Key>
     <ns:Password>xqGg5Fr8UCGsi8LB8YpxF7TNL</ns:Password>
  </ns:UserCredential>
  </ns:WebAuthenticationDetail>
  <ns:ClientDetail>
  <ns:AccountNumber>510087240</ns:AccountNumber>
  <ns:MeterNumber>118521870</ns:MeterNumber>
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
  <ns:MaximumNumberOfMatches>10</ns:MaximumNumberOfMatches>
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
  <cfhttp url="https://gatewaybetawsbeta.fedex.com" port="443" method ="POST" throwonerror="yes">
     <cfhttpparam name="name" type="XML" value="#local.XMLPacket#">
  </cfhttp>
 
  <cfset vari    = XMLParse(CFHTTP.FileContent)>
 
  <cfset local.msg    = "">
  <cfset local.changed    = "">
  <cfset vari = vari.AddressValidationReply.AddressResults.ProposedAddressDetails>
  <!--- ************************************************************************** --->
  <!--- check fatal error                                                         --->
  <!--- ************************************************************************** --->
  <cfloop from="1" to="#ArrayLen(vari.XmlChildren)#" index="i">
     <cfif listlast(vari.XmlChildren[i].XmlName,':') eq 'Changes'>
     <cfif listfind(arguments.FatalList,vari.XmlChildren[i].XmlText)>
      <cfset local.msg = 'False'>
     </cfif>
     </cfif>
  </cfloop>
 
  <!--- ************************************************************************** --->
  <!--- Post box address                                                            --->
  <!--- ************************************************************************** --->
  <cfif IsDefined('vari.ParsedAddress.ParsedStreetLine.Elements.Name.XmlText') and vari.ParsedAddress.ParsedStreetLine.Elements.Name.XmlText eq 'postOfficeBoxNumber'>
     <cfif not len(local.msg)>
     <cfset local.msg = "FedEx cannot deliver to P.O. boxes">
     </cfif>
  </cfif>
  <!--- ************************************************************************** --->
  <!--- check if address changed                                                    --->
  <!--- ************************************************************************** --->
  <cfif not len(local.msg)>
     <cfloop from="1" to="#ArrayLen(vari.ParsedAddress.ParsedStreetLine.XmlChildren)#" index="i">
     <cfif vari.ParsedAddress.ParsedStreetLine.Elements[i].Changes.XmlText neq 'NO_CHANGES'>
      <cfset local.changed = "1">
     </cfif>
     </cfloop>
     <cfif vari.ParsedAddress.ParsedCity.Elements.Changes.XmlText neq 'NO_CHANGES'>
     <cfset local.changed = "1">
     </cfif>
     <cfif vari.ParsedAddress.ParsedStateOrProvinceCode.Elements.Changes.XmlText neq 'NO_CHANGES'>
     <cfset local.changed = "1">
     </cfif>
     <cfif vari.ParsedAddress.ParsedStateOrProvinceCode.Elements.Changes.XmlText neq 'NO_CHANGES'>
     <cfset local.changed = "1">
     </cfif>
     <cfif vari.ParsedAddress.ParsedPostalCode.Elements.Changes.XmlText neq 'NO_CHANGES'>
     <cfset local.changed = "1">
     </cfif>
  </cfif>
  <!--- ************************************************************************** --->
  <!--- Fedex Retrun Same Address . a Workaround                                 --->
  <!--- ************************************************************************** --->
  <cfset local.match = 0>
  <cfset local.StreetLines = trim(replace('#arguments.StreetLine1# #arguments.StreetLine2#',' ',' ','all'))>
  <cfif local.StreetLines eq vari.Address.StreetLines.XmlText>
     <cfset local.match = local.match+1>
  </cfif>
  <cfif trim(arguments.City) eq vari.Address.City.XmlText>
     <cfset local.match = local.match+1>
  </cfif>
  <cfif trim(arguments.State) eq vari.Address.StateOrProvinceCode.XmlText>
     <cfset local.match = local.match+1>
  </cfif>
  <cfif trim(listfirst(arguments.PostalCode,'-')) eq listfirst(vari.Address.PostalCode.XmlText,'-')>
     <cfset local.match = local.match+1>
  </cfif>
 
  <!--- ************************************************************************** --->
  <!--- get the new address                                                        --->
  <!--- ************************************************************************** --->
  <cfif val(local.changed) and local.match neq 4>
     <cfset ProposedAddress = ArrayNew(1)>
     <cfloop from="1" to="#ArrayLen(vari.Address.XmlChildren)#" index="i">
     <cfset ArrayAppend(ProposedAddress,vari.Address.XmlChildren[i].XmlText)>
     </cfloop>
     <cfset local.ProposedAddress = ArrayToList(ProposedAddress,'<br />')>
  <cfelse>
     <cfset local.ProposedAddress = "">
  </cfif>
 
  <cfset local.out = "#local.msg##local.ProposedAddress#">
  <cfcatch>
  <cfset local.out = "FedEx cannot verify Your address at this time. Please try again.">
  </cfcatch>
 </cftry>
  <cfreturn trim(local.out)>
  </cffunction>

<cfoutput>
#AddressValidation(StreetLine1='PO Box 123', StreetLine2='Unit 638', City='Ft Lauderdale', State='FL', PostalCode='33304')#
</cfoutput>
