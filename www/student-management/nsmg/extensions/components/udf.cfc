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
			var vListESI = '11364'; // Stacy Brewer
			
			// Stores all IDs so we can check quickly and return a masked SSN
			var vAllowedIDList = '7657,9719,11364';
			
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
            <cfset strAllValidChars = (
                strLowerCaseAlpha &
                strUpperCaseAlpha &
                strNumbers &
                strOtherChars
                ) />
         
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
         
            <!--- Select the random number from our number set. --->
            <cfset arrPassword[ 1 ] = Mid(
            strNumbers,
            RandRange( 1, Len( strNumbers ) ),
            1
            ) />
             
            <!--- Select the random letter from our lower case set. --->
            <cfset arrPassword[ 2 ] = Mid(
            strLowerCaseAlpha,
            RandRange( 1, Len( strLowerCaseAlpha ) ),
            1
            ) />
             
            <!--- Select the random letter from our upper case set. --->
            <cfset arrPassword[ 3 ] = Mid(
            strUpperCaseAlpha,
            RandRange( 1, Len( strUpperCaseAlpha ) ),
            1
            ) />
            
            <!--- Select the random letter from our upper case set. --->
            <cfset arrPassword[ 4 ] = Mid(
            strOtherChars,
            RandRange( 1, Len( strOtherChars ) ),
            1
            ) />
         
			<!--- We have 4 of the arguments.length needed to satisfy the requirements, create rest of the password. --->
            <cfloop index="intChar" from="#(ArrayLen( arrPassword ) + 1)#" to="#ARGUMENTS.length#" step="1">
             
            
                <cfset arrPassword[ intChar ] = Mid(
                strAllValidChars,
                RandRange( 1, Len( strAllValidChars ) ),
                1
                ) />
             
            </cfloop>
         
			<!---
            Jumble up the password. 
            --->
            <cfset CreateObject( "java", "java.util.Collections" ).Shuffle(
            arrPassword
            ) />
         
			<!---
            We now have a randomly shuffled array. Now, we just need
            to join all the characters into a single string. We can
            do this by converting the array to a list and then just
            providing no delimiters (empty string delimiter).
            --->
            <cfset strPassword = ArrayToList(
            arrPassword,
            ""
            ) />
	</cffunction>

</cfcomponent>