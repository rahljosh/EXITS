<!--- ------------------------------------------------------------------------- ----
	
	File:		udf.cfc
	Author:		Marcus Melo
	Date:		October, 09 2009
	Desc:		This holds the User Defined Functions

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="udf"
	output="false" 
	hint="A collection of user defined functions">


	<!--- Return the initialized UDF object --->
	<cffunction name="Init" access="public" returntype="udf" output="No" hint="Returns the initialized UDF object">

		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>

	</cffunction>


	<!---
		Determines if the site is local or if the site is live. This is
		determined by checking the server name. 
	--->
	<cffunction name="IsServerLocal" access="public" returntype="boolean" output="No" hint="Determines if the current server is local">
		<cfscript>
			// Check for local servers
			if (	
				FindNoCase("dev.extra.exitsApplication.com", CGI.http_host) OR 
				FindNoCase("extra.exitsdev.com", CGI.http_host) OR 
				FindNoCase("developer", server.ColdFusion.ProductLevel) OR
				FindNoCase("119cooper", CGI.http_host) OR
				FindNoCase("111cooper", CGI.http_host)
			){
				return(true);
			} else {
				return(false);
			}
		</cfscript>
	</cffunction>

	<!--- Create Folder if it does not exist --->
	<cffunction name="createFolder" access="public" returntype="void" output="no" hint="Check if folder exits, if it does not, it creates it">
        <cfargument name="fullPath" type="string" required="yes" hint="Full Path is required" />
        
		<cftry>
        
			<!--- Make sure the directories are set up correctly --->
            <cfif NOT directoryExists(ARGUMENTS.fullPath)>
                
                <cfdirectory 
                	action="create" 
                    directory="#ARGUMENTS.fullPath#" 
					mode="777"
                	/>
            
            </cfif>
		
            <cfcatch type="any">
            	<!--- Error Handler --->
				
            </cfcatch>
               
        </cftry>
        
	</cffunction>


	<cffunction name="buildSortURL" access="public" returntype="string" hint="Builds sorting URL">
        <cfargument name="columnName" hint="columnName is required">
        <cfargument name="sortBy" hint="sortBy is required">
        <cfargument name="sortOrder" hint="sortOrder is required">
        
        <cfscript>
			// rebuilt QueryString and remove sortBy and sortOrder
			var	vNewQueryString = CGI.QUERY_STRING;

			// make sure we have a valid sortOrder value
			if ( NOT ListFind("ASC,DESC", ARGUMENTS.sortOrder) ) {
				ARGUMENTS.sortOrder = "ASC";				  
			}
			
			// Clean Up sortBy URL
			if ( ListContainsNoCase(vNewQueryString, "sortBy", "&") ) {
				vNewQueryString = ListDeleteAt(vNewQueryString, ListContainsNoCase(vNewQueryString, "sortBy", "&"), "&");
			}
			
			// Clean Up sortORder URL
			if ( ListContainsNoCase(vNewQueryString, "sortOrder", "&") ) {
				vNewQueryString = ListDeleteAt(vNewQueryString, ListContainsNoCase(vNewQueryString, "sortOrder", "&"), "&");
			}
		
			// New sortOrder value
			var vSortOrderVal = '&sortOrder=ASC';
		
			if (ARGUMENTS.columnName EQ ARGUMENTS.sortBy AND ARGUMENTS.sortOrder EQ 'ASC') {
				vSortOrderVal = "&sortOrder=DESC";	
			} 
			
			// Build URL
			return CGI.SCRIPT_NAME & "?" & vNewQueryString & "&sortBy=" & ARGUMENTS.columnName & vSortOrderVal;
		</cfscript>
    	
    </cffunction>


	<!--- Encrypt Variable --->
	<cffunction name="encryptVariable" access="public" returntype="string" output="false" hint="Encrypts a variable">
    	<cfargument name="varString" hint="String">

		<cfscript>			
			// Declare Key
			var encryptKey = "BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR";
			var resultKey = '';
			
			try {
				// Encrypt Variable
				resultKey = Encrypt(TRIM(ARGUMENTS.varString), encryptKey, "desede", "hex");
			} catch (Any e) {
				// Set Encrypt Value to ''
				resultKey = '';
			}
	
			// Return Encrypted Variable
			return(resultKey);
        </cfscript>
		   
	</cffunction>

	
    <!--- Decrypt Variable --->
	<cffunction name="decryptVariable" access="public" returntype="string" output="false" hint="Decrypts a variable">
    	<cfargument name="varString" hint="String">

		<cfscript>
			// Declare Key
			var decryptKey = "BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR";
			var resultKey = '';
			
			try {
				// Decrypt Variable
				resultKey = Decrypt(ARGUMENTS.varString, decryptKey, "desede", "hex");
			} catch (Any e) {
				// Set Decrypt Value to ''
				resultKey = '';
			}
	
			// Return Decrypted Variable
			return(resultKey);
        </cfscript>
		   
	</cffunction>


	<cffunction name="displaySSN" access="public" returntype="string" output="false" hint="Decrypts a variable">
    	<cfargument name="varString" hint="String">
        <cfargument name="isMaskedSSN" default="1" hint="Set to 1 to return SSN in ***-**-9999 format">
		
		<cfscript>
			// Declare Variables
			var vDecryptedSSN = decryptVariable(ARGUMENTS.varString);
			var returnSSN = '';
			
			// Format SSN Display
			if ( LEN(vDecryptedSSN) ) {
				
				// Mask	
				returnSSN = "XXX-XX-" & Right(vDecryptedSSN, 4);

			}
			
			// Return Encrypted Variable
			return(returnSSN);
        </cfscript>
		   
	</cffunction>


	<!--- This removes foreign accents from online application fields --->
	<cffunction name="removeAccent" access="public" returntype="string" output="false" hint="Remove foreign acccents from a string">
    	<cfargument name="varString" hint="String">

		<cfscript>
			// Declare Lists
 		    var list1 = "Â,Á,À,Ã,Ä,â,á,à,ã,ä,É,Ê,é,ê,Í,Ì,í,ì,Ô,Ó,Õ,Ö,ô,ó,õ,ö,Ú,Ü,Û,ú,ü,û,Ç,ç,Ñ,ñ,S,Z,Ø,ø,å,æ,Å,ß,Š,î,ý,ë,è,ï,ò";
			var list2 = "A,A,A,A,Ae,a,a,a,a,ae,E,E,e,e,I,I,i,i,O,O,O,OE,o,o,o,oe,U,UE,U,u,ue,u,C,c,N,n,S,Z,O,o,a,e,A,ss,S,i,y,e,e,i,o";

			// Remove Accent - replaceList
			var newString = replaceList(ARGUMENTS.varString, list1, list2) ; 
	
			// Return String
			return(newString);
        </cfscript>
		   
	</cffunction>


	<!--- This converts text to standard case --->
	<cffunction name="ProperCase" access="public" returntype="string" output="No" hint="Converts a string to proper case - first letters capital">
		<cfargument name="Text" type="string" required="Yes" />
		
		<cfscript>
			return(REReplace(LCase(ARGUMENTS.Text), "(\b[a-z]{1,1})", "\U\1", "ALL"));
		</cfscript>
	</cffunction>


    <cffunction name="displayFileSize" access="public" output="false" returntype="string">
        <cfargument name="size" default="0" required="yes">
        
		<cfif (NOT IsNumeric(arguments.size)) OR (arguments.size LTE 0)>
            <cfset outText = "Size Unknown">
        <cfelseif arguments.size LT 1024>
			<cfset outText = "#arguments.size# bytes">
        <cfelseif arguments.size LT 1048576>
            <cfset outText = "#NumberFormat(arguments.size/1024, "_")# Kb">
        <cfelseif arguments.size LT 1073741824>
            <cfset outText = "#DecimalFormat(arguments.size/1048576)# Mb">
        <cfelse>
            <cfset outText = "#DecimalFormat(arguments.size/1073741824)# Gb">
        </cfif>
        
        <cfreturn outText>
    </cffunction>

	
	<cffunction name="SafeJavascript" access="public" returntype="string" output="No" hint="Escapes double and single quotes for javascript strings">
		<cfargument name="Text" type="string" required="Yes" />
		
		<cfscript>
			// Remove Foreign Accents
			ARGUMENTS.text = removeAccent(ARGUMENTS.text);
			
			// Escape backslashes so they are not, in themselves, espace characters
			ARGUMENTS.Text = Replace(ARGUMENTS.Text, "\", "\\", "ALL");
			
			// Remove Blank Spaces
			ARGUMENTS.Text = Replace(ARGUMENTS.Text, " ", "", "ALL");

			// Pound Sign
			ARGUMENTS.Text = Replace(ARGUMENTS.Text, Chr(35), "", "ALL");

			// Single quotes
			ARGUMENTS.Text = Replace(ARGUMENTS.Text, Chr(39), ("\" & Chr(39)), "ALL");
			ARGUMENTS.Text = Replace(ARGUMENTS.Text, "&##39;", ("\" & Chr(39)), "ALL");
			
			// Double quotes
			ARGUMENTS.Text = Replace(ARGUMENTS.Text, Chr(34), ("\" & Chr(34)), "ALL");
			ARGUMENTS.Text = Replace(ARGUMENTS.Text, "&##34;", ("\" & Chr(34)), "ALL");
						
			return(ARGUMENTS.Text);
		</cfscript>
	</cffunction>


	<cffunction name="escapeQuotes" access="public" returntype="string" output="No" hint="Escapes double and single quotes">
		<cfargument name="Text" type="string" required="Yes" />
		
		<cfscript>
			// Remove Foreign Accents
			ARGUMENTS.text = removeAccent(ARGUMENTS.text);

			// Single quotes
			ARGUMENTS.Text = Replace(ARGUMENTS.TEXT, Chr(39), "&apos;", "ALL");
			
			// Double quotes
			ARGUMENTS.Text = Replace(ARGUMENTS.TEXT, Chr(34), "&quot;", "ALL");
						
			return(ARGUMENTS.Text);
		</cfscript>
	</cffunction>

    
	<!--- Deletes the right N characters of a string --->
	<cffunction name="RightDelete" access="public" returntype="string" output="No" hint="Deletes the right N characters of a string">
		<cfargument name="Text" type="string" required="Yes" />
		<cfargument name="Count" type="numeric" required="Yes" />
		
		<!--- Make sure that count is greater than or equal zero --->
		<cfif (ARGUMENTS.Count LTE 0)>
			<!--- Bad argument so throw error --->
			<cfthrow 
				message="Parameter 2 of function LeftDelete which is now #ARGUMENTS.Count# must be a non-negative integer" 
				type="EXCEPTION"
				/>
		</cfif>
		
		<!--- Check to make sure that the count is not larger than the string --->
		<cfif (ARGUMENTS.Count GTE Len(ARGUMENTS.Text))>
			
			<!--- We are taking off too much so just return the null string --->
			<cfreturn "" />
			
		<cfelse>
		
			<!--- Return the Left of the rest of the string --->
			<cfreturn Left(ARGUMENTS.Text, (Len(ARGUMENTS.Text) - ARGUMENTS.Count)) />
			
		</cfif>
	</cffunction>


	<!--- Gets the current page, without the page or ext, that the user is currently on --->
	<cffunction name="GetCurrentPageFromPath" access="public" returntype="string" output="No" hint="Gets the current page, without the page or ext, that the user is currently on">
		<cfargument name="Path" type="string" required="Yes" />
		
		<cfscript>
			// Return the last list element without the ext
			return LCase(ListFirst(GetFileFromPath(ARGUMENTS.Path), "."));
		</cfscript>
	</cffunction>


	<!--- Gets the name of the current directory --->
	<cffunction name="GetCurrentDirectoryFromPath" access="public" returntype="string" output="no" hint="Gets the current directory">
		<cfargument name="Path" type="string" required="yes" />
		
        <cfscript>
			return LCase(GetFileFromPath(RightDelete(GetDirectoryFromPath(ARGUMENTS.Path),1)));
		</cfscript>
        
	</cffunction>

	
    <!---
		Query to Struct
	--->
    <cffunction name="QueryToStruct" returntype="struct" output="false">
        <cfargument name="query" type="query" required="true">
        
        <cfscript>
			s = StructNew();
		</cfscript>
		
        <cfloop index="i" list="#ARGUMENTS.query.ColumnList#">
        	<cfset StructInsert (s, i, ARGUMENTS.query[i])>
        </cfloop>
        
        <cfreturn s>
    </cffunction>

	
    <!--- Merge Two Arrays --->
    <cffunction name="arrayMerge" access="public" returntype="array" output="false">
        <cfargument name="array1" required="true" type="array">
        <cfargument name="array2" required="true" type="array">
        
        <cfscript>
			var mergedArray = ARGUMENTS.array1;
			
			mergedArray.addAll(ARGUMENTS.array2);
			
			return mergedArray;
		</cfscript>
        
    </cffunction>


	<!---
		Outputs text that we think came from the rich editor. Since it may have 
		Paragraph tags, the last one is really the most important. Check to see if 
		there is a P tag as the final element. If not, then we need to add the proper
		spacing at the end for bottom margin. 
	--->
	<cffunction name="RichTextOutput" access="public" returntype="string" output="No" hint="Returns text that was formatted with a rich text editor">
		<cfargument name="Text" type="string" required="Yes" />
		
		<cfscript>
			// Set up local variables 
			var sbText = CreateObject("java", "java.lang.StringBuffer").init();
		
			// Trim text since the last thing we want is the tag
			ARGUMENTS.Text = Trim(ARGUMENTS.Text);
			
			// Make sure that it is a block element.
			sbText.append("<div>");
			sbText.append(ARGUMENTS.Text);
			sbText.append("</div>");
			
			// Check to see if final element is p tag
			if (CompareNoCase(Right(ARGUMENTS.Text, 4), "</p>")){
				// Last element is NOT p tag, so add BR for bottom margin
				sbText.append("<br />");
			}
			
			// Return the rich formatted text as string
			return(sbText.toString());
		</cfscript>
	</cffunction>


	<!---
		Adds line breaks from a textarea input. All "paragraph data is outputted with a bottom margin.
	--->
	<cffunction name="TextAreaOutput" access="public" returntype="string" output="No" hint="Outputs text from a textarea input">
		<cfargument name="Text" type="string" required="Yes" />
		
		<cfscript>
			// Set up local variables
			var returnText = ARGUMENTS.text;

			returnText = ReplaceNoCase(returnText, chr(10), "<br />", "ALL");
			returnText = ReplaceNoCase(returnText, chr(13), "<br />", "ALL");
			
			// Return text
			return(returnText);

			// Set up local variables
			//var sbText = CreateObject("java", "java.lang.StringBuffer").init();
			
			// Make sure that it is a block element with bottom margin
			//sbText.append("<div>");
			//sbText.append(Replace(ARGUMENTS.Text, (Chr(13) & Chr(10)), "<br />", "ALL"));
			//sbText.append("</div><br />");		
			
			// Return the text and convert to string
			//return(sbText.toString());
		</cfscript>
	</cffunction>


	<!---
		Adds line breaks from a textarea input. All "paragraph data is outputted with a bottom margin.
	--->
	<cffunction name="displayTextArea" access="public" returntype="string" output="No" hint="Displays correct format on text area inputs">
		<cfargument name="Text" type="string" required="Yes" />
		
		<cfscript>
			// Set up local variables
			var returnText = ARGUMENTS.text;
			
			returnText = ReplaceNoCase(returnText, "<br />", chr(10), "ALL");
			returnText = ReplaceNoCase(returnText, "<br>", chr(10), "ALL");
			
			// Return text
			return(returnText);
		</cfscript>
	</cffunction>


	<!--- Returns a formatted SSN number --->
	<cffunction name="formatSSN" access="public" returntype="string" output="no" hint="Returns a formatted SSN">
		<cfargument name="areaNumber" type="string" default="The first three digits" />
        <cfargument name="groupNumber" type="string" default="The group numbers range from 01 to 99. However, they are not assigned in consecutive order." />
        <cfargument name="serialNumber" type="string" default="They represent a straight numerical sequence of digits from 0001-9999 within the group." />
		
        <cfscript>
			var formattedSSN = '';
			
			// Make sure we have only numbers	
			if ( LEN(ARGUMENTS.serialNumber) ) {
				formattedSSN = ListPrepend(formattedSSN, ReplaceNoCase(ARGUMENTS.serialNumber, '-', ''), "-"); 
			}

			if ( LEN(ARGUMENTS.groupNumber) ) {
				formattedSSN = ListPrepend(formattedSSN, ReplaceNoCase(ARGUMENTS.groupNumber, '-', ''), "-"); 
			}

			if ( LEN(ARGUMENTS.areaNumber) ) {
				formattedSSN = ListPrepend(formattedSSN, ReplaceNoCase(ARGUMENTS.areaNumber, '-', ''), "-"); 
			}
			
			return formattedSSN;
		</cfscript>
        
	</cffunction>


	<!--- Break down a SSN --->
	<cffunction name="breakDownSSN" access="public" returntype="struct" output="no" hint="Break down a SSN in 3 fields">
		<cfargument name="varString" type="string" default="" />
		
        <cfscript>
			var SSN = StructNew();
			SSN.areaNumber = '';
			SSN.groupNumber = '';
			SSN.serialNumber = '';
			listFields = VAL(ListLen(ARGUMENTS.varString, '-'));
			
			// SSN has a total of 3 groups of numbers
			for (i=1; i LTE listFields; i=i+1) {
				
				// PS: Using a CASE statement throws an error if the list does not contain an element.
				// serialNumber
				if (i EQ 1) {
					SSN.serialNumber = ListGetAt(ARGUMENTS.varString, listFields, '-' ); // ListLast(ARGUMENTS.number, '-');
				// groupNumber
				} else if (i EQ 2) {
					SSN.groupNumber = ListGetAt(ARGUMENTS.varString, (listFields-1), '-' );
				// areaNumber
				} else if (i EQ 3) {
					SSN.areaNumber = ListGetAt(ARGUMENTS.varString, (listFields-2), '-' );
				}
			
			}			
			
			return SSN;
		</cfscript>
        
	</cffunction>


	<!--- Returns a formatted phone number --->
	<cffunction name="formatPhoneNumber" access="public" returntype="string" output="no" hint="Returns a formatted phone number">
		<cfargument name="countryCode" type="string" default="" />
        <cfargument name="areaCode" type="string" default="" />
        <cfargument name="prefix" type="string" default="" />
        <cfargument name="number" type="string" default="" />
		
        <cfscript>
			var phoneNumber = '';
			
			// Remove dashes entered by the user since we use them to define the groups
			
			if ( LEN(ARGUMENTS.number) ) {
				phoneNumber = ListPrepend(phoneNumber, ReplaceNoCase(ARGUMENTS.number, '-', ''), "-"); 
			}
			
			if ( LEN(ARGUMENTS.prefix) ) {
				phoneNumber = ListPrepend(phoneNumber, ReplaceNoCase(ARGUMENTS.prefix, '-', ''), "-"); 
			}

			if ( LEN(ARGUMENTS.areaCode) ) {
				phoneNumber = ListPrepend(phoneNumber, ReplaceNoCase(ARGUMENTS.areaCode, '-', ''), "-"); 
			}

			if ( LEN(ARGUMENTS.countryCode) ) {
				phoneNumber = ListPrepend(phoneNumber, ReplaceNoCase(ARGUMENTS.countryCode, '-', ''), "-"); 
			}
			
			return phoneNumber;
		</cfscript>
        
	</cffunction>


	<!--- Breaks down a phone number --->
	<cffunction name="breakDownPhoneNumber" access="public" returntype="struct" output="no" hint="Break down a phone number in 4 fields">
		<cfargument name="number" type="string" default="" />
		
        <cfscript>
			var phoneNumber = StructNew();
			phoneNumber.countryCode = '';
			phoneNumber.areaCode = '';
			phoneNumber.prefix = '';
			phoneNumber.number = '';
			listFields = VAL(ListLen(ARGUMENTS.number, '-'));
			
			// Phone number has a total of 4 groups of numbers
			for (i=1; i LTE listFields; i=i+1) {
				
				// PS: Using a CASE statement throws an error if the list does not contain an element.
				// Number
				if (i EQ 1) {
					phoneNumber.number = ListGetAt(ARGUMENTS.number, listFields, '-' ); // ListLast(ARGUMENTS.number, '-');
				// Prefix 
				} else if (i EQ 2) {
					phoneNumber.prefix = ListGetAt(ARGUMENTS.number, (listFields-1), '-' );
				// Area Code
				} else if (i EQ 3) {
					phoneNumber.areaCode = ListGetAt(ARGUMENTS.number, (listFields-2), '-' );
				// Country Code
				} else if (i EQ 4) {
					phoneNumber.countryCode = ListGetAt(ARGUMENTS.number, (listFields-3), '-' );
				}
			
			}			
			
			return phoneNumber;
		</cfscript>
        
	</cffunction>


    <cffunction name="addressLookup" access="remote" returnFormat="json" output="false" hint="empty for no accurate match">
		<cfargument name="address" type="string" required="yes">
        <cfargument name="city" type="string" required="yes">
        <cfargument name="state" type="string" required="yes">
        <cfargument name="zip" type="string" required="yes">
        <cfargument name="country" type="string" required="yes">
        
        <cfscript>
			vGetStateAbbr = APPLICATION.CFC.LookupTables.getState(ID=ARGUMENTS.state).state;
			vGetCountryCode = APPLICATION.CFC.LookupTables.getCountry(countryID=ARGUMENTS.country).countryCode;
		</cfscript>
        
        <cfhttp result="geo" url="https://maps.google.com/maps/geo?q=#address#%20#city#%20#vGetStateAbbr#%20#zip#%20#vGetCountryCode#&output=xml&oe=utf8\&sensor=false&key=#APPLICATION.KEY.googleMapsAPI#" resolveurl="yes" />
       	
		<cfscript>
			// Set return structure that will store query + verify information
			stResult = StructNew();
			stResult.isVerified = 0;
			stResult.inputState = vGetStateAbbr;
      	</cfscript>
        
        <cftry>
        	<cfscript>
			
				locationXML = xmlParse(geo.filecontent);
				stResult.inputCountry = vGetCountryCode;
				stResult.verifiedStateID = APPLICATION.CFC.LookupTables.getState(shortState=locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.AdministrativeAreaName.XmlText).ID;
				stResult.address = "";
				stResult.state = "";
				stResult.city = "";
				stResult.zip = "";
				stResult.country = "";
				
				if ( locationXML.kml.Response.Status.code.XmlText EQ 200 AND listFind("8,9", locationXML.kml.Response.Placemark.AddressDetails.XmlAttributes.Accuracy) ) {
				
					stResult.isVerified = 1;
					
					stResult.address = ListGetAt(locationXML.kml.Response.Placemark.address.XmlText, 1);
					stResult.country = locationXML.kml.Response.Placemark.AddressDetails.Country.CountryNameCode.XmlText;
					stResult.state = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.AdministrativeAreaName.XmlText;
					
					if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea, "SubAdministrativeArea") ) {
						if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea, "Locality") ) {
							stResult.city = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.LocalityName.XmlText;
							if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality, "DependentLocality") ) {
								stResult.zip = "zip=" & locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.DependentLocality.PostalCode.PostalCodeNumber.XmlText;
							} else {
								stResult.zip = "zip=" & locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.PostalCode.PostalCodeNumber.XmlText;
							}
						} else if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea, "DependentLocality") ) {
							stResult.city = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.DependentLocality.DependentLocalityName.XmlText;
							stResult.zip = "zip=" & locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.DependentLocality.PostalCode.PostalCodeNumber.XmlText;
						} else {
							stResult.isVerified = 0;
						}
					} else {
						if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea, "Locality") ) {
							stResult.city = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.Locality.LocalityName.XmlText;
							if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.Locality, "DependentLocality") ) {
								stResult.zip = "zip=" & locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.Locality.DependentLocality.PostalCode.PostalCodeNumber.XmlText;
							} else {
								stResult.zip = "zip=" & locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.Locality.PostalCode.PostalCodeNumber.XmlText;
							}
						} else if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea, "DependentLocality") ) {
							stResult.city = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.DependentLocality.DependentLocalityName.XmlText;
							stResult.zip = "zip=" & locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.DependentLocality.PostalCode.PostalCodeNumber.XmlText;
						} else {
							stResult.isVerified = 0;
						}
					}
				} else {
					stResult.isVerified = 0;
				}
			</cfscript>
            <cfcatch type="any">
                <cfscript>
                    stResult.isVerified = 0;
                </cfscript>
            </cfcatch>
        </cftry>
        <cfscript>            
			return stResult;
	   	</cfscript>
            
	</cffunction>

</cfcomponent>
