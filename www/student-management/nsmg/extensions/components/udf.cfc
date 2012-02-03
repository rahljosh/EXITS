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
		Determines if the site is local or if the site is live. This is
		determined by checking the server name. 
	--->
	<cffunction name="IsServerLocal" access="public" returntype="boolean" output="No" hint="Determines if the current server is local">
		<cfscript>
			// Check for local servers
			if (	
				FindNoCase("dev.student-management.com", CGI.http_host) OR 
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
			return(newString);
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

	
	<cffunction name="calculateAddressDistance" access="public" returntype="string">
    	<cfargument name="origin" type="string" required="yes" hint="origin is required" />
        <cfargument name="destination" type="string" required="yes" hint="destination is required" />

        <cfscript>
			// Replace blank space with a +
			ARGUMENTS.origin = ReplaceNoCase(ARGUMENTS.origin, " ", "+", "ALL");
			ARGUMENTS.destination = ReplaceNoCase(ARGUMENTS.destination, " ", "+", "ALL");
		</cfscript>

        <!--- 
			Geolocation
			<cfhttp url="https://maps.google.com/maps/geo?q=#ARGUMENTS.origin#&output=xml&oe=utf8\&sensor=false&key=#APPLICATION.KEY.googleMapsAPI#" delimiter="," resolveurl="yes" />
		--->

		<!--- Driving Directions --->        
        <cfhttp url="http://maps.googleapis.com/maps/api/directions/xml?origin=#ARGUMENTS.origin#&destination=#ARGUMENTS.destination#&sensor=false" delimiter="," resolveurl="yes" />
        
        <cfscript>
			var vMeterValue = 0.000621371192;
			var vDistanceInMiles = '';
			// meters --> vResponseXML.DirectionsResponse.route.leg.distance.value.XmlText
			// miles --> vResponseXML.DirectionsResponse.route.leg.distance.text.XmlText

			try {
				
				// Parse XML we received back to a variable
				vResponseXML = XmlParse(cfhttp.filecontent);		
				
				try {
					
					vDistanceInMiles = ReplaceNoCase(vResponseXML.DirectionsResponse.route.leg.distance.text.XmlText, " mi", "", "ALL");
					
					return vDistanceInMiles;
					
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
    
    
		<!---Check if paperwork is complete for a specific user for a specific season to be allowed access---->
	<cffunction name="paperworkCompleted" access="public" returntype="query">
    	<cfargument name="season" type="numeric" required="yes" default=9 hint="This should be what ever season you want to check on." />
        <cfargument name="userid" type="numeric" required="yes" default="" hint="Pass in user id you want to check on">
        
        <!----check CBC has been approved---->
        <cfquery name="cbcCheck" datasource="#APPLICATION.DSN#">
            SELECT 
            	date_approved
            FROM 
            	smg_users_cbc
            WHERE 
            	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userid)#">
            AND 
            	seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.season)#">
        </cfquery>
        
    	<!----Check Agreement---->
        <cfquery name="checkAgreement" datasource="#APPLICATION.DSN#">
            SELECT 
            	ar_cbc_auth_form, 
                ar_agreement,
                ar_ref_quest1,ar_ref_quest2
            FROM 
            	smg_users_paperwork
            WHERE 
            	userid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userid)#">
            AND 
            	seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.season)#">
        </cfquery>
        
        <!----Check Refrences---->
        <cfquery name="checkReferences" datasource="#APPLICATION.DSN#">
            SELECT 
            	*
            FROM 
            	smg_user_references
            WHERE 
            	referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userid)#">
        </cfquery>
        
        <!----Check Employmenthistory---->
        <cfquery name="employHistory" datasource="#APPLICATION.DSN#">
            SELECT 
            	*
            FROM 
            	smg_users_employment_history
            WHERE 
            	fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userid)#">
        </cfquery>  
        
        <cfquery name="prevExperience" datasource="#APPLICATION.DSN#">
            SELECT 
                prevOrgAffiliation, 
                prevAffiliationName
            FROM 
                smg_users
            WHERE 
                userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userid)#">
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
	<cffunction name="allpaperworkCompleted" access="public" returntype="query">
        <cfargument name="userid" type="numeric" required="yes" default="" hint="Pass in user id you want to check on">
        <cfargument name="seasonid" type="numeric" required="no" default="0" hint="if you want just of a specific season not passed in returns all seasons">
       
    	<!----Check Agreement---->
        <cfquery name="checkAgreement" datasource="#APPLICATION.DSN#">
			SELECT 
            	p.paperworkid, 
                p.userid, 
                p.seasonid, 
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
        	LEFT JOIN 
            	smg_seasons s ON s.seasonid = p.seasonid
        	WHERE 
            	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userid)#">
                
				<cfif CLIENT.companyid eq 10>
                    AND
                        fk_companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="10">
                <cfelse>
                    AND
                        fk_companyid != <cfqueryparam cfsqltype="cf_sql_integer" value="10"> 
                </cfif>
            
				<cfif val(ARGUMENTS.seasonid)>
                    AND p.seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonid)#">
                </cfif>
                
            ORDER BY 
                p.seasonid DESC
        </cfquery>
     
		<cfscript>
			// This is the query that is returned
			qAllPaperWork = QueryNew("paperworkid,userid,seasonid,ar_info_sheet,ar_ref_quest1,ar_ref_quest2,ar_cbcAuthReview,ar_cbc_auth_form,ar_agreement,ar_training,secondVisit,agreeSig,cbcSig, season");
        </cfscript>
     
		<cfloop query="checkAgreement">

			<!----check CBC has been approved---->
            <cfquery name="cbcCheck" datasource="#APPLICATION.DSN#">
                SELECT 
                	date_approved, 
                    seasonid
                FROM 
                	smg_users_cbc
                WHERE 
                	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userid)#">
                AND 
                	seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkAgreement.seasonid#">
            </cfquery>
	 	
			<cfscript>
                 // Insert blank first row
                QueryAddRow(qAllPaperWork);
                QuerySetCell(qAllPaperWork, "paperworkid", checkAgreement.paperworkid);
                QuerySetCell(qAllPaperWork, "userid", checkAgreement.userid);
                QuerySetCell(qAllPaperWork, "seasonid", checkAgreement.seasonid);
                QuerySetCell(qAllPaperWork, "ar_info_sheet", checkAgreement.ar_info_sheet);
                QuerySetCell(qAllPaperWork, "ar_ref_quest1", checkAgreement.ar_ref_quest1);
                QuerySetCell(qAllPaperWork, "ar_ref_quest2", checkAgreement.ar_ref_quest2);
                QuerySetCell(qAllPaperWork, "ar_cbcAuthReview", cbcCheck.date_approved);
                QuerySetCell(qAllPaperWork, "ar_cbc_auth_form", checkAgreement.ar_cbc_auth_form);
                QuerySetCell(qAllPaperWork, "ar_agreement", checkAgreement.ar_agreement);
                QuerySetCell(qAllPaperWork, "ar_training", checkAgreement.ar_training);
                QuerySetCell(qAllPaperWork, "secondVisit", checkAgreement.secondVisit);
                QuerySetCell(qAllPaperWork, "agreeSig", checkAgreement.agreeSig);
                QuerySetCell(qAllPaperWork, "cbcSig", checkAgreement.cbcSig);
                QuerySetCell(qAllPaperWork, "season", checkAgreement.season);
            </cfscript>	
            	
		</cfloop>   
         	
		<cfscript>
            return qAllPaperWork;
        </cfscript>	
        
    </cffunction>
    
</cfcomponent>