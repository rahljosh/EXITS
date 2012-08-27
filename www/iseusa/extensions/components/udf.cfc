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

	
	<!--- Displays Admission Information for ISE/Case --->
	<cffunction name="displayAdmissionsInformation" access="public" returntype="string" output="no" hint="Displays Admissions Information Depending on the company">
        <cfargument name="displayInfo" type="string" default="Info" hint="Info, Name, Email, EmailLink" />
        
        <cfscript>
			var vAdmissionsName = '';
			var vAdmissionsEmail = '';
			var vAdmissionsEmailLink = '';
			var vAdmissionsInfo = '';
		
			if ( CLIENT.companyID EQ 10 ) {
				// CASE
				vAdmissionsName = 'Jana De Fillipps';
				vAdmissionsEmail = 'jana@case-usa.org';
				vAdmissionsEmailLink = '<a href="mailto:jana@case-usa.org">jana@case-usa.org</a>';			
				vAdmissionsInfo = 'Jana De Fillipps at <a href="mailto:jana@case-usa.org">jana@case-usa.org</a>';
			} else if ( CLIENT.companyID EQ 14 ) {
				// ESI
				vAdmissionsName = 'Stacy Brewer';
				vAdmissionsEmail = 'info@exchange-serivce.org';
				vAdmissionsEmailLink = '<a href="mailto:info@exchange-serivce.org">info@exchange-serivce.org</a>';			
				vAdmissionsInfo = 'Stacy Brewer at <a href="mailto:info@exchange-serivce.org">info@exchange-serivce.org</a>';
			} else {
				// ISE
				vAdmissionsName = 'Brian Hause';
				vAdmissionsEmail = 'bhause@iseusa.com';
				vAdmissionsEmailLink = '<a href="mailto:bhause@iseusa.com">bhause@iseusa.com</a>';			
				vAdmissionsInfo = 'Brian Hause at <a href="mailto:bhause@iseusa.com">bhause@iseusa.com</a>';
			}
			
			switch(ARGUMENTS.displayInfo) {
				  
				case "Info": {
					 return vAdmissionsInfo;
					 break;
				}

				case "name": {
					 return vAdmissionsName;
					 break;
				}

				case "email": {
					 return vAdmissionsEmail;
					 break;
				}

				case "emailLink": {
					 return vAdmissionsEmailLink;
					 break;
				}

			 }			
		</cfscript>
        
	</cffunction>


	<cffunction name="setSessionEmailVariables" access="public" returntype="void" output="false" hint="Set SESSION email variables">
              
        <cfscript>
			// Get Company Information
			qGetCompanyInfo = APPLICATION.CFC.COMPANY.getCompanies(httpHost=CGI.http_host);
		
			// Set SESSION.ROLES
			SESSION.EMAIL = StructNew();
			
			// Set Email Support According to Company
			if ( VAL(qGetCompanyInfo.recordCount) ) {
				SESSION.EMAIL.support = qGetCompanyInfo.support_email;
			} else {
				SESSION.EMAIL.support = 'support@student-management.com';
			}
		</cfscript>
		
	</cffunction>
    
    
	<cffunction name="getSessionEmail" access="public" returntype="string" output="false" hint="Gets session email">
    	<cfargument name="emailType" type="string" hint="emailType is required">
		
        <cfscript>
			try {
				// Check if emails do not exist
				if ( StructIsEmpty(SESSION.EMAIL) ) {
					// Set Emails
					setSessionEmailVariables();
				}
			} catch (Any e) {
				// Set Emails
				setSessionEmailVariables();
			}
			
			try {
				// Get Email Access
				return SESSION.EMAIL[ARGUMENTS.emailType];
			} catch (Any e) {
				// Error
				return 'support@student-management.com';
			}
		</cfscript>
		
	</cffunction>


	<!--- This hashes the given ID for security reasons --->
	<cffunction name="HashID" access="public" returntype="string" output="no" hint="Hashes the given ID for security reasons. To be used for documents only.">
		<cfargument name="ID" type="numeric" required="yes" />
		
		<!--- Return hash --->
		<cfreturn (
			((ARGUMENTS.ID * 64) MOD 29) & 
			Chr(Right(ARGUMENTS.ID, 1) + 65) & 
			(ARGUMENTS.ID MOD 4)
			) />
	</cffunction>


	<!---
		Determines if the site is local or if the site is live. This is determined by checking the server name. 
	--->
	<cffunction name="IsServerLocal" access="public" returntype="boolean" output="No" hint="Determines if the current server is local">
		
		<cfscript>
			// Check for local servers
			if (	
				FindNoCase("dev.student-management.com", CGI.http_host) 
			OR 
				FindNoCase("developer", server.ColdFusion.ProductLevel) 
			OR
				FindNoCase("119cooper", CGI.http_host) 
			OR
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

	
    <!--- Display Social Security Number --->
	<cffunction name="displaySSN" access="public" returntype="string" output="false" hint="Decrypts a variable">
    	<cfargument name="varString" hint="String">
        <cfargument name="isMaskedSSN" default="1" hint="Set to 1 to return SSN in ***-**-9999 format">
		<cfargument name="displayType" default="" hint="user / hostFamily">
        
		<cfscript>
			/*** Display SSN Rules
				ISE
					- Host Family - No one is allowed to view full SSN
					- User - Thea Brewer and Bryan McCready are allowed to view full SSN
				CASE
					- Host Family - No one is allowed to view full SSN
					- User - Stacy Brewer is allowed to view full SSN
				ESI
					- Host Family - Stacy Brewer is allowed to view full SSN
					- User - Stacy Brewer is allowed to view full SSN
			***/
		
			// Declare Variables		
			
			// ISE
			var vUserListISE = '7657,9719'; // Thea Brewer | Bryan McCready 
			
			// CASE
			var vUserListCASE = '11364'; // Stacy Brewer
			
			// ESI
			var vListESI = '11364,16761'; // Stacy Brewer | Stacy Brewer
			
			// Stores all IDs so we can check quickly and return a masked SSN
			var vAllowedIDList = '7657,9719,11364,16761';
			
			// Stores the return variable
			var vReturnSSN = '';
			
			// Decrypt SSN
			var vDecryptedSSN = decryptVariable(ARGUMENTS.varString);

			// Format SSN Display
			if ( LEN(vDecryptedSSN) AND ListFind(vAllowedIDList, CLIENT.userID) ) {

				// ISE - SHOW ONLY FOR USER 
				if ( ListFind(vUserListISE, CLIENT.userID) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) AND ARGUMENTS.displayType EQ 'user' ) {
					// return full SSN
					vReturnSSN = vDecryptedSSN;
				}
				
				// CASE - SHOW ONLY FOR USER
				if ( ListFind(vUserListCASE, CLIENT.userID) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.CASExchange, CLIENT.companyID) AND ARGUMENTS.displayType EQ 'user' ) {
					// return full SSN
					vReturnSSN = vDecryptedSSN;
				}
					
				// ESI - SHOW FOR HOST FAMILY AND USER
				if ( ListFind(vListESI, CLIENT.userID) AND ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID) AND listFind("user,hostFamily", ARGUMENTS.displayType) ) {
					// return full SSN
					vReturnSSN = vDecryptedSSN;
				}
				
			} else if ( LEN(vDecryptedSSN) ) {

				// SET return masked SSN as default
				vReturnSSN = "XXX-XX-" & Right(vDecryptedSSN, 4);

			}	
			
			// Return Encrypted Variable
			return(vReturnSSN);
        </cfscript>
		   
	</cffunction>


	<!--- Returns a formatted phone number --->
	<cffunction name="formatPhoneNumber" access="public" returntype="string" output="no" hint="Returns a formatted phone number">
		<cfargument name="countryCode" type="string" default="" />
        <cfargument name="areaCode" type="string" default="" />
        <cfargument name="prefix" type="string" default="" />
        <cfargument name="number" type="string" default="" />
		
        <cfscript>
			var vPhoneNumber = '';
			
			// Remove dashes entered by the user since we use them to define the groups
			
			if ( LEN(ARGUMENTS.number) ) {
				vPhoneNumber = ListPrepend(vPhoneNumber, ReplaceNoCase(ARGUMENTS.number, '-', ''), "-"); 
			}
			
			if ( LEN(ARGUMENTS.prefix) ) {
				vPhoneNumber = ListPrepend(vPhoneNumber, ReplaceNoCase(ARGUMENTS.prefix, '-', ''), "-"); 
			}

			if ( LEN(ARGUMENTS.areaCode) ) {
				vPhoneNumber = ListPrepend(vPhoneNumber, ReplaceNoCase(ARGUMENTS.areaCode, '-', ''), "-"); 
			}

			if ( LEN(ARGUMENTS.countryCode) ) {
				vPhoneNumber = ListPrepend(vPhoneNumber, ReplaceNoCase(ARGUMENTS.countryCode, '-', ''), "-"); 
			}
			
			return vPhoneNumber;
		</cfscript>

			<!---
			Code:
			<cfset phone= "1-612.555.1212">
			<!--- First lets ditch the dashes --->
			<cfset phone = REReplace(phone,"\D","","ALL")>
			<cfoutput>Dashless number: #phone#<BR></cfoutput>
			<cfset four = Right(phone,4)>
			<cfset prefix = Left(Right(phone,7),3)>
			<cfset areacode = Left(Right(phone,10),3)>
			<cfoutput>Number Nice: (#areacode#) #prefix#-#four#</cfoutput>
			Yields:
			Dashless number: 16125551212
			Number Nice: (612) 555-1212
			--->			
	</cffunction>


	<!--- This removes foreign accents FROM online application fields --->
	<cffunction name="removeAccent" access="public" returntype="string" output="false" hint="Remove foreign acccents FROM a string">
    	<cfargument name="varString" hint="String">

		<cfscript>
			// Declare Lists
 		    var list1 = "Â,Á,À,Ã,Ä,â,á,à,ã,ä,É,Ê,é,ê,Í,Ì,í,ì,Ô,Ó,Õ,Ö,ô,ó,õ,ö,Ú,Ü,Û,ú,ü,û,Ç,ç,Ñ,ñ,S,Z,Ø,ø,å,æ,Å,ß,Š,î,ý,ë,è,ï,ò";
			var list2 = "A,A,A,A,Ae,a,a,a,a,ae,E,E,e,e,I,I,i,i,O,O,O,OE,o,o,o,oe,U,UE,U,u,ue,u,C,c,N,n,S,Z,O,o,a,e,A,ss,S,i,y,e,e,i,o";

			// Remove Accent - replaceList
			var newString = replaceList(ARGUMENTS.varString, list1, list2) ; 
	
			// Return String
			return(TRIM(newString));
        </cfscript>
		   
	</cffunction>


	<!--- Converts a number to ordinal --->
	<cffunction name="convertToOrdinal" access="public" returntype="string" output="false" hint="Converts a number to ordinal">
    	<cfargument name="num" hint="Numeric">

		<cfscript>
			/**
			 * Returns the 2 character english text ordinal for numbers.
			**/
			
			// if the right 2 digits are 11, 12, or 13, set num to them.
			// Otherwise we just want the digit in the one's place.
			var two = Right(VAL(ARGUMENTS.num),2);
			var ordinal="";
			
			/*
			switch(two) {
				case "11": 
				case "12": 
				case "13": { 
					num = two; 
					break; 
				}
				default: { 
					num = Right(num,1); 
					break; 
				}
			}
			*/

			// 1st, 2nd, 3rd, everything else is "th"
			switch( num ) {
				case "1":
				case "21":
				case "31": { 
					ordinal = num & "st"; 
					break; 
				}
				case "2":
				case "22":
				case "32": { 
					ordinal = num & "nd"; 
					break; 
				}
				case "3":
				case "23":
				case "33": { 
					ordinal = num & "rd"; 
					break; 
				}
				default: { 
					ordinal = num & "th"; 
					break; 
				}
			}
			
			// return the text.
			return ordinal;
        </cfscript>
		   
	</cffunction>


	<!--- 
		The entity name must immediately follow the '&' in the entity reference. 
		Use &amp; instead of & in XML (and in XHTML). 
	--->
    <cffunction name="safeXML" returntype="string">
		<cfargument name="Text" type="string" required="Yes" />
		
		<cfscript>
			return(Replace(ARGUMENTS.Text, "&", "&amp;", "ALL"));
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


	<!---Generate a random passowrd.   Pass in the length that you want the password to be. ---->
	<cffunction name="randomPassword" access="public" returntype="string">
    	<cfargument name="length" type="numeric" required="yes" default=8 hint="Password HAS to be at least 4" />
		
 			<!---not using the letters i,o,l and numbers 0,1 to avoid any confusion--->
			<!--- Set up available lower case values. --->
            <cfset strLowerCaseAlpha = "abcdefghjkmnpqrstuvwxyz" />
            <!--- Set up available lower case values. --->
            <cfset strUpperCaseAlpha = UCase( strLowerCaseAlpha ) />
            <!--- Set up available numbers. --->
            <cfset strNumbers = "23456789" />
            <!--- Set up additional valid password chars. --->
            <cfset strOtherChars = "~!@##$%^&*" />
            <!----Make one string of available chars.---->
            <cfset strAllValidChars = ( strLowerCaseAlpha & strUpperCaseAlpha & strNumbers & strOtherChars ) />
         
            <!---Create an array to contain the password --->
            <cfset arrPassword = ArrayNew( 1 ) />
         
			<!---
			Rules that are followed
			- must be exactly 8 characters in length
			- must have at least 1 number
			- must have at least 1 uppercase letter
			- must have at least 1 lower case letter
			- must have at least 1 non-alphanumeric char.
			--->
         
            <!--- Select the random number FROM our number set. --->
            <cfset arrPassword[ 1 ] = Mid( strNumbers, RandRange( 1, Len( strNumbers ) ), 1 ) />
             
            <!--- Select the random letter FROM our lower case set. --->
            <cfset arrPassword[ 2 ] = Mid( strLowerCaseAlpha, RandRange( 1, Len( strLowerCaseAlpha ) ), 1 ) />
             
            <!--- Select the random letter FROM our upper case set. --->
            <cfset arrPassword[ 3 ] = Mid( strUpperCaseAlpha, RandRange( 1, Len( strUpperCaseAlpha ) ), 1 ) />
            
            <!--- Select the random letter FROM our upper case set. --->
            <cfset arrPassword[ 4 ] = Mid( strOtherChars, RandRange( 1, Len( strOtherChars ) ), 1 ) />
         
			<!--- We have 4 of the arguments.length needed to satisfy the requirements, create rest of the password. --->
            <cfloop index="intChar" FROM="#(ArrayLen( arrPassword ) + 1)#" to="#ARGUMENTS.length#" step="1">
            
                <cfset arrPassword[ intChar ] = Mid( strAllValidChars, RandRange( 1, Len( strAllValidChars ) ), 1 ) />
             
            </cfloop>
         
			<!---
			Jumble up the password. 
			--->
            <cfset CreateObject( "java", "java.util.Collections" ).Shuffle( arrPassword ) />
         
			<!---
			We now have a randomly shuffled array. Now, we just need
			to join all the characters into a single string. We can
			do this by converting the array to a list and then just
			providing no delimiters (empty string delimiter).
			--->
		<cfscript>
            strPassword = ArrayToList(arrPassword,"");
            
            return(strPassword);
        </cfscript>

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


	<cffunction name="calculateTimePassed" access="public" hint="Returns time passed in a day and hours format. eg: 60 d 22 h" returntype="string">
    	<cfargument name="dateStarted" hint="dateStarted is required">
        <cfargument name="dateEnded" hint="dateEnded is required">
        <cfargument name="onlyBusinessDays" default="0" hint="Set to 1 to calculate only business day">
        
		<cfscript>
			var vDaysPassed = 0;
			var vHoursPassed = 0;
			var vTimePassed = 'n/a';
			
			
			if ( isDate(ARGUMENTS.dateStarted) AND isDate(ARGUMENTS.dateEnded) ) {
				
				
				if ( NOT VAL(onlyBusinessDays) ) {
				
					// Calculates the number of days between 2 dates.
					vDaysPassed = Abs(DateDiff("d", ARGUMENTS.dateEnded, ARGUMENTS.dateStarted));
				
				} else {
					
					// Calculates the number of business days between 2 dates.
					while ( ARGUMENTS.dateStarted LTE ARGUMENTS.dateEnded ) {
						if ( dayOfWeek(ARGUMENTS.dateStarted) GTE 2 AND dayOfWeek(ARGUMENTS.dateStarted) LTE 6) {
							vDaysPassed = incrementValue(vDaysPassed);
						}
						ARGUMENTS.dateStarted = dateAdd("d",1,ARGUMENTS.dateStarted);
					}
				
				}
					
				if ( datepart('h', now()) LT 12 OR vDaysPassed EQ 1 ) {
					h = 'h';								
				} else {
					h = 'H';
				}
				
				// Get Hours
				vHoursPassed = TimeFormat(ARGUMENTS.dateEnded-ARGUMENTS.dateStarted, h);
			
				vTimePassed = vDaysPassed & "d " & vHoursPassed &  "h";

			}
			
			return vTimePassed; 
        </cfscript>
    	
    </cffunction>

	
	<cffunction name="calculateAddressDistance" access="public" returntype="string">
    	<cfargument name="origin" type="string" required="yes" hint="origin is required" />
        <cfargument name="destination" type="string" required="yes" hint="destination is required" />

        <cfscript>
			// Remove Pound Sign
			ARGUMENTS.origin = ReplaceNoCase(ARGUMENTS.origin, "##", "", "ALL");
			ARGUMENTS.destination = ReplaceNoCase(ARGUMENTS.destination, "##", "", "ALL");

			// Replace blank space with a +
			ARGUMENTS.origin = ReplaceNoCase(ARGUMENTS.origin, " ", "+", "ALL");
			ARGUMENTS.destination = ReplaceNoCase(ARGUMENTS.destination, " ", "+", "ALL");
		</cfscript>

        <!--- 
			Geolocation
			<cfhttp url="https://maps.google.com/maps/geo?q=#ARGUMENTS.origin#&output=xml&oe=utf8\&sensor=false&key=#APPLICATION.KEY.googleMapsAPI#" delimiter="," resolveurl="yes" />
			alternatives=true to get multiple routes and find the shortest one | multiples <routes>
		--->
		
		<!--- Driving Directions --->        
        <cfhttp url="http://maps.googleapis.com/maps/api/directions/xml?sensor=false&alternatives=true&origin=#ARGUMENTS.origin#&destination=#ARGUMENTS.destination#" delimiter="," resolveurl="yes" />
        
        <cfscript>
			//var vMeterValue = 0.000621371192;
			var vFootValue = 0.000189393939;
			var vReturnValue = '';			
			var vGetShortestDistance = '';
			// meters --> vResponseXML.DirectionsResponse.route.leg.distance.value.XmlText
			// miles --> vResponseXML.DirectionsResponse.route.leg.distance.text.XmlText

			try {
				
				// Parse XML we received back to a variable
				vResponseXML = XmlParse(cfhttp.filecontent);		

				try {
					
					// Results could be in ft or mi format
					vReturnValue = vResponseXML.DirectionsResponse.route.leg.distance.text.XmlText;
					
					// Loop through routes to get the shortest distance
					for ( i=1; i LTE ArrayLen(vResponseXML.DirectionsResponse.route); i=i+1 ) {
						
						// Distance from route [i]
						vReturnValue = vResponseXML.DirectionsResponse.route[i].leg.distance.text.XmlText;
						
						if ( Right(vReturnValue, 2) EQ 'ft' ) {
							
							// Feet Value Returned
							vReturnValue = ReplaceNoCase(vReturnValue, " ft", "", "ALL");	
							
							// Set Up Default Values
							if ( vReturnValue LTE 1000 ) {
								vReturnValue = 0.1;
							} else {
								vReturnValue = DecimalFormat(ReplaceNoCase(vReturnValue, " ft", "", "ALL") * vFootValue);	
							}
							
						} else {
							// Miles Value Returned
							vReturnValue = ReplaceNoCase(vReturnValue, " mi", "", "ALL");
						}
						
						// Check if is the shortest distance
						if ( NOT LEN(vGetShortestDistance) OR vReturnValue LT vGetShortestDistance ) {
							vGetShortestDistance = vReturnValue;
						}
	
					}
	
					return vGetShortestDistance;
					
				} catch( any error ) {
					
					try {
					
						return vResponseXML.DirectionsResponse.status;
					
					} catch( any error ) {
						
						return 'Error';
						// return 0;
					
					}
						
				}
			
			} catch( any error ) {

				return 'Error';
				// return 0;

			}
		</cfscript>
        
    </cffunction>


	<cffunction name="addressLookup" access="remote" returnFormat="json" output="false" hint="empty for no accurate match">
		<cfargument name="address" type="string" required="yes">
        <cfargument name="city" type="string" required="yes">
        <cfargument name="state" type="string" required="yes">
        <cfargument name="zip" type="string" required="yes">
        <cfargument name="country" type="string" required="yes">
        
        <cfscript>
			vGetCountryCode = APPLICATION.CFC.LookupTables.getCountry(countryID=ARGUMENTS.country).countryCode;
		</cfscript>
        
        <cfhttp result="geo" url="https://maps.google.com/maps/geo?q=#address#%20#city#%20#state#%20#zip#%20#vGetCountryCode#&output=xml&oe=utf8\&sensor=false&key=#APPLICATION.KEY.googleMapsAPI#" resolveurl="yes" />
       	
		<cfscript>
			// Set return structure that will store query + verify information
			stResult = StructNew();
			stResult.isVerified = 0;
			stResult.inputState = state;
      	</cfscript>
        
        <cftry>
        	<cfscript>
			
				locationXML = xmlParse(geo.filecontent);
				stResult.inputCountry = vGetCountryCode;
				stResult.verifiedStateID = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.AdministrativeAreaName.XmlText;
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
    

    <cffunction name="zipCodeLookUp" access="remote" returnFormat="json" output="false" hint="empty for no accurate match">
        <cfargument name="zip" type="string" required="yes">
        
        <cfhttp result="geo" url="https://maps.google.com/maps/geo?q=#zip#&output=xml&oe=utf8\&sensor=false&key=#APPLICATION.KEY.googleMapsAPI#" resolveurl="yes" />
       	
		<cfscript>
            locationXML = xmlParse(geo.filecontent);
			
			// Set return structure that will store query + verify information
			stResult = StructNew();
			
			stResult.isVerified = 0;
			stResult.city = "";
			stResult.state = "";
			stResult.zip = "";
			
			// Wrap it up with a try/catch just in case we haven't account for all possibilities
			try {

				if ( locationXML.kml.Response.Status.code.XmlText EQ 200 AND listFind("5", locationXML.kml.Response.Placemark.AddressDetails.XmlAttributes.Accuracy) ) {
					
					stResult.isVerified = 1;
					stResult.state = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.AdministrativeAreaName.XmlText;
					// Json is returning 7734 for zip 07734
					// stResult.zip = zip;
					stResult.zip = "zip=" & zip;
					
					if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea, "SubAdministrativeArea") ) {
						
						if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea, "Locality") ) {
							stResult.city = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.LocalityName.XmlText;
						} else if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea, "DependentLocality") ) {
							stResult.city = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.DependentLocality.DependentLocalityName.XmlText;
						} else {
							stResult.isVerified = 0;
						}
						
					} else {
						
						if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea, "Locality") ) {
							stResult.city = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.Locality.LocalityName.XmlText;
						} else if ( StructKeyExists(locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea, "DependentLocality") ) {
							stResult.city = locationXML.kml.Response.Placemark.AddressDetails.Country.AdministrativeArea.DependentLocality.DependentLocalityName.XmlText;
						} else {
							stResult.isVerified = 0;
						}
						
					}
				}

			} catch( Any e ) {
				stResult.isVerified = 0;
			}        

			return stResult;
        </cfscript>
            
	</cffunction>


	<!---Check if paperwork is complete for a specific user for a specific season to be allowed access---->
	<cffunction name="paperworkCompleted" access="public" returntype="query">
    	<cfargument name="season" type="numeric" required="yes" default=9 hint="This should be what ever season you want to check on." />
        <cfargument name="userID" type="numeric" required="yes" default="" hint="Pass in user id you want to check on">
        
    	<!----Check Agreement---->
        <cfquery name="checkAgreement" datasource="mysql">
            SELECT 
            	ar_cbc_auth_form, 
                ar_agreement,
                ar_ref_quest1,ar_ref_quest2
            FROM 
            	smg_users_paperwork
            WHERE 
            	userID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
            AND 
            	seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.season)#">
        </cfquery>
        
        <!----Check Refrences---->
        <cfquery name="checkReferences" datasource="mysql">
            SELECT 
            	*
            FROM 
            	smg_user_references
            WHERE 
            	referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
        </cfquery>
        
        <!----Check Employmenthistory---->
        <cfquery name="employHistory" datasource="mysql">
            SELECT 
            	*
            FROM 
            	smg_users_employment_history
            WHERE 
            	fk_userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
        </cfquery>  
        
        <cfquery name="prevExperience" datasource="mysql">
            SELECT 
                prevOrgAffiliation, 
                prevAffiliationName
            FROM 
                smg_users
            WHERE 
                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
        </cfquery>
        
        <!----Check AR Training Sign off Form---->
        
        <!----Check AR Information Sheet---->
        
        <!----Check CBC Approved----->
        
        <cfquery name="prevExperience" datasource="mysql">
            SELECT 
                prevOrgAffiliation, 
                prevAffiliationName
            FROM 
                smg_users
            WHERE 
                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
        </cfquery>
        
		<cfif employHistory.recordcount GTE 1 AND (prevExperience.prevOrgAffiliation EQ 0 OR (prevExperience.prevOrgAffiliation EQ 1 AND prevExperience.prevAffiliationName NEQ '') )>
	        <cfset previousExperience = 1>
        <cfelse>
    	    <cfset previousExperience = 0>
        </cfif> 
        
    	<cfif CLIENT.usertype eq 15>
        	<cfset checkAgreement.prevExperience = 'Not Required for Usertype'>
            <cfset checkAgreement.ref1 = 'Not Required for Usertype'>
            <cfset checkAgreement.ref2 = 'Not Required for Usertype'>
            <cfset checkAgreement.numberRef = '6'>
        </cfif>
        
		<cfif checkAgreement.ar_cbc_auth_form NEQ '' AND checkAgreement.ar_agreement NEQ '' AND checkAgreement.ar_ref_quest1 NEQ '' AND checkAgreement.ar_ref_quest2 NEQ '' AND checkReferences.recordcount EQ 4 AND previousExperience EQ 1>
            <cfset isComplete = 1>
		<cfelse>
            <cfset isComplete = 0>
        </cfif>
     
	 	<cfscript>
			// This is the query that is returned
			qPaperWork = QueryNew("Complete, prevExperience,arAgreement,cbcAuth,ref1,ref2,numberRef");
			
			 // Insert blank first row
			QueryAddRow(qPaperWork);
			QuerySetCell(qPaperWork, "Complete", isComplete);
			QuerySetCell(qPaperWork, "prevExperience", previousExperience);
			QuerySetCell(qPaperWork, "arAgreement", checkAgreement.ar_agreement);
			QuerySetCell(qPaperWork, "cbcAuth", checkAgreement.ar_cbc_auth_form);
			QuerySetCell(qPaperWork, "ref1", checkAgreement.ar_ref_quest1);
			QuerySetCell(qPaperWork, "ref2", checkAgreement.ar_ref_quest2);
			QuerySetCell(qPaperWork, "numberRef", checkReferences.recordcount);
			
			return qPaperWork;
		</cfscript>		
    		
    </cffunction>
    
    
  	<!---Get paperwork  for a specific user for all  seasons on record ---->
	<cffunction name="allPaperworkCompleted" access="public" returntype="query">
        <cfargument name="userID" type="numeric" required="yes" default="" hint="Pass in user id you want to check on">
        <cfargument name="seasonID" type="numeric" required="no" default="0" hint="if you want just of a specific season not passed in returns current season">
        
        <cfscript>
			// Season ID not passed, get current season
			if ( NOT VAL(ARGUMENTS.seasonID) ) {
				ARGUMENTS.seasonID = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
			}
		</cfscript>
        
    	<!--- Get Paperwork --->
        <cfquery name="qGetPaperwork" datasource="mysql">
			SELECT 
            	p.paperworkid, 
                p.userID, 
                p.seasonID, 
                p.ar_info_sheet, 
                p.ar_ref_quest1, 
                p.ar_ref_quest2, 
                p.ar_cbc_auth_form, 
                p.ar_agreement, 
                p.ar_training, 	
                p.secondVisit, 
                p.agreeSig,
            	s.season, 
                p.cbcSig
        	FROM 
        		smg_users_paperwork p
        	LEFT OUTER JOIN 
            	smg_seasons s ON s.seasonID = p.seasonID
        	WHERE 
            	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
            AND 
                p.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">
            
            <cfif CLIENT.companyid eq 10>
                AND
                    fk_companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="10">
            <cfelse>
                AND
                    fk_companyid != <cfqueryparam cfsqltype="cf_sql_integer" value="10"> 
            </cfif>
                
            ORDER BY 
                p.seasonID DESC
        </cfquery>

		<!--- Get Active CBC - Will be checking if CBC has been approved --->
        <cfquery name="qGetCBC" datasource="mysql">
            SELECT 
                date_approved, 
                seasonID
            FROM 
                smg_users_cbc
            WHERE 
                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
            AND 
                date_expired >= CURRENT_DATE()
        </cfquery>
    
		<cfscript>
			// Set Initial values
        	secondVisitRepOk = 0;
			areaRepOk = 0;
			reviewAcct = 0;
			secondRepReviewAcct = 0;
        </cfscript>
        	
        <!----check to see if this account is active for second visit reps: agreement, cbcauthrization and approval, info sheet need to be on file.---->
        <cfif IsDate(qGetPaperwork.ar_info_sheet) 
            AND IsDate(qGetPaperwork.ar_cbc_auth_form) 
            AND IsDate(qGetCBC.date_approved)
            AND IsDate(qGetPaperwork.ar_agreement)
            AND LEN(qGetPaperwork.cbcSig)
            AND LEN(qGetPaperwork.agreeSig)>
            <cfset secondVisitRepOk = 1>
        </cfif>
       
        <!----check to see if this account is active for area reps: agreement, cbcauthrization and approval, info sheet need to be on file, 2 references check and AR training completed.---->
        <cfif IsDate(qGetPaperwork.ar_info_sheet) 
            AND IsDate(qGetPaperwork.ar_cbc_auth_form) 
            AND IsDate(qGetCBC.date_approved)
            AND IsDate(qGetPaperwork.ar_agreement)
            AND IsDate(qGetPaperwork.ar_ref_quest1)
            AND IsDate(qGetPaperwork.ar_ref_quest2)>
           <cfset areaRepOk = 1>
        </cfif>
        
        <!--- set if area rep account needs to be reviewed---->
         <cfif IsDate(qGetPaperwork.ar_info_sheet) 
            AND IsDate(qGetPaperwork.ar_cbc_auth_form) 
            AND NOT IsDate(qGetCBC.date_approved)
            AND IsDate(qGetPaperwork.ar_agreement)
            AND IsDate(qGetPaperwork.ar_ref_quest1)
            AND IsDate(qGetPaperwork.ar_ref_quest2)>
           <cfset reviewAcct = 1>
        </cfif>       
             
        <!----set if second visit rep needs to be reviewed---->
        <cfif IsDate(qGetPaperwork.ar_info_sheet) 
            AND IsDate(qGetPaperwork.ar_cbc_auth_form) 
            AND NOT IsDate(qGetCBC.date_approved)
            AND IsDate(qGetPaperwork.ar_agreement)>
            <cfset secondRepReviewAcct = 1>
        </cfif>
            	
		<cfscript>
			// This is the query that is returned
			qAllPaperWork = QueryNew("paperworkid,userID,seasonID,ar_info_sheet,ar_ref_quest1,ar_ref_quest2,ar_cbcAuthReview,ar_cbc_auth_form,ar_agreement,ar_training,secondVisit,agreeSig,cbcSig, season, secondVisitRepOK, areaRepOK, reviewAcct, secondRepReviewAcct");
        	
			 // Insert blank first row
			QueryAddRow(qAllPaperWork);
			QuerySetCell(qAllPaperWork, "paperworkid", qGetPaperwork.paperworkid);
			QuerySetCell(qAllPaperWork, "userID", qGetPaperwork.userID);
			QuerySetCell(qAllPaperWork, "seasonID", qGetPaperwork.seasonID);
			QuerySetCell(qAllPaperWork, "ar_info_sheet", qGetPaperwork.ar_info_sheet);
			QuerySetCell(qAllPaperWork, "ar_ref_quest1", qGetPaperwork.ar_ref_quest1);
			QuerySetCell(qAllPaperWork, "ar_ref_quest2", qGetPaperwork.ar_ref_quest2);
			QuerySetCell(qAllPaperWork, "ar_cbcAuthReview", qGetCBC.date_approved);
			QuerySetCell(qAllPaperWork, "ar_cbc_auth_form", qGetPaperwork.ar_cbc_auth_form);
			QuerySetCell(qAllPaperWork, "ar_agreement", qGetPaperwork.ar_agreement);
			QuerySetCell(qAllPaperWork, "ar_training", qGetPaperwork.ar_training);
			QuerySetCell(qAllPaperWork, "secondVisit", qGetPaperwork.secondVisit);
			QuerySetCell(qAllPaperWork, "agreeSig", qGetPaperwork.agreeSig);
			QuerySetCell(qAllPaperWork, "cbcSig", qGetPaperwork.cbcSig);
			QuerySetCell(qAllPaperWork, "season", qGetPaperwork.season);
			QuerySetCell(qAllPaperWork, "secondVisitRepOK", secondVisitRepOk);
			QuerySetCell(qAllPaperWork, "areaRepOk", areaRepOk);
			QuerySetCell(qAllPaperWork, "reviewAcct", reviewAcct);
			QuerySetCell(qAllPaperWork, "secondRepReviewAcct", reviewAcct);
			
			// Return Query
            return qAllPaperWork;
        </cfscript>	
        
    </cffunction>
    
</cfcomponent>