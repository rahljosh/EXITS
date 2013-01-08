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


	<!--- Gets the current page, without the page or ext, that the user is currently on --->
	<cffunction name="getCurrentPageFromPath" access="public" returntype="string" output="No" hint="Gets the current page, without the page or ext, that the user is currently on">
		<cfargument name="Path" type="string" required="Yes" />
		
		<cfscript>
			// Return the last list element without the ext
			return LCase(ListFirst(GetFileFromPath(ARGUMENTS.Path), "."));
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


    <!--- Detect Browser --->
	<cffunction name="browserDetect" access="public" returntype="string" output="false" hint="Returns the client's browser">
		
        <cfscript>
			/**
			 * Detects 130+ browsers.
			 * v2 by Daniel Harvey, adds Flock/Chrome and Safari fix.         
			 * v5 fix by RCamden based on bug found by Jeff Mayer
			 * 
			 * @param UserAgent      User agent string to parse. Defaults to cgi.http_user_agent. (Optional)
			 * @return Returns a string. 
			 * @author John Bartlett (jbartlett@strangejourney.net) 
			 * @version 5, October 10, 2011 
			 */
            // Default User Agent to the CGI browser string
            var UserAgent=CGI.HTTP_USER_AGENT;
            
            // Regex to parse out version numbers
            var VerNo="/?v?_? ?v?[\(?]?([A-Z0-9]*\.){0,9}[A-Z0-9\-.]*(?=[^A-Z0-9])";
            
            // List of browser names
            var BrowserList="";
            
            // Identified browser info
            var BrowserName="";
            var BrowserVer="";
            
            // Working variables
            var Browser="";
            var tmp="";
            var tmp2="";
            var x=0;
            
            // If a value was passed to the function, use it as the User Agent
            if (ArrayLen(Arguments) EQ 1) UserAgent=Arguments[1];
            
            // Allow regex to match on EOL and instring
            UserAgent=UserAgent & " ";
            
            // Browser List (Allows regex - see BlackBerry for example)
            BrowserList="1X|Amaya|Ubuntu APT-HTTP|AmigaVoyager|Android|Arachne|Amiga-AWeb|Arora|Bison|Bluefish|Browsex|Camino|Check&Get|Chimera|Chrome|Contiki|cURL|Democracy|" &
                        "Dillo|DocZilla|edbrowse|ELinks|Emacs-W3|Epiphany|Galeon|Minefield|Firebird|Phoenix|Flock|IceApe|IceWeasel|IceCat|Gnuzilla|" &
                        "Google|Google-Sitemaps|HTTPClient|HP Web PrintSmart|IBrowse|iCab|ICE Browser|Kazehakase|KKman|K-Meleon|Konqueror|Links|Lobo|Lynx|Mosaic|SeaMonkey|" &
                        "muCommander|NetPositive|Navigator|NetSurf|OmniWeb|Acorn Browse|Oregano|Prism|retawq|Shiira Safari|Shiretoko|Sleipnir|Songbird|Strata|Sylera|" &
                        "ThunderBrowse|W3CLineMode|WebCapture|WebTV|w3m|Wget|Xenu_Link_Sleuth|Oregano|xChaos_Arachne|WDG_Validator|W3C_Validator|" &
                        "Jigsaw|PLAYSTATION 3|PlayStation Portable|IPD|" &
                        "AvantGo|DoCoMo|UP.Browser|Vodafone|J-PHONE|PDXGW|ASTEL|EudoraWeb|Minimo|PLink|NetFront|Xiino|";
                        // Mobile strings
                        BrowserList=BrowserList & "iPhone|Vodafone|J-PHONE|DDIPocket|EudoraWeb|Minimo|PLink|Plucker|NetFront|PIE|Xiino|" &
                        "Opera Mini|IEMobile|portalmmm|OpVer|MobileExplorer|Blazer|MobileExplorer|Opera Mobi|BlackBerry\d*[A-Za-z]?|" &
                        "PPC|PalmOS|Smartphone|Netscape|Opera|Safari|Firefox|MSIE|HP iPAQ|LGE|MOT-[A-Z0-9\-]*|Nokia|";
            
                        // No browser version given
                        BrowserList=BrowserList & "AlphaServer|Charon|Fetch|Hv3|IIgs|Mothra|Netmath|OffByOne|pango-text|Avant Browser|midori|Smart Bro|Swiftfox";
            
                        // Identify browser and version
            Browser=REMatchNoCase("(#BrowserList#)/?#VerNo#",UserAgent);
            
            if (ArrayLen(Browser) GT 0) {
            
                if (ArrayLen(Browser) GT 1) {
            
                    // If multiple browsers detected, delete the common "spoofed" browsers
                    if (Browser[1] EQ "MSIE 6.0" AND Browser[2] EQ "MSIE 7.0") ArrayDeleteAt(Browser,1);
                    if (Browser[1] EQ "MSIE 7.0" AND Browser[2] EQ "MSIE 6.0") ArrayDeleteAt(Browser,2);
                    tmp2=Browser[ArrayLen(Browser)];
            
                    for (x=ArrayLen(Browser); x GTE 1; x=x-1) {
                        tmp=Rematchnocase("[A-Za-z0-9.]*",Browser[x]);
                        if (ListFindNoCase("Navigator,Netscape,Opera,Safari,Firefox,MSIE,PalmOS,PPC",tmp[1]) GT 0) ArrayDeleteAt(Browser,x);
                    }
            
                    if (ArrayLen(Browser) EQ 0) Browser[1]=tmp2;
                }
            
                // Seperate out browser name and version number
                tmp=Rematchnocase("[A-Za-z0-9. _\-&]*",Browser[1]);
        
                Browser=tmp[1];
            
                if (ArrayLen(tmp) EQ 2) BrowserVer=tmp[2];
            
                // Handle "Version" in browser string
                tmp=REMatchNoCase("Version/?#VerNo#",UserAgent);
                if (ArrayLen(tmp) EQ 1) {
                    tmp=Rematchnocase("[A-Za-z0-9.]*",tmp[1]);
                    //hack added by Camden to try better handle weird UAs
                    if(arrayLen(tmp) eq 2) BrowserVer=tmp[2];
                    else browserVer=tmp[1];
                }
            
                // Handle multiple BlackBerry browser strings
                if (Left(Browser,10) EQ "BlackBerry") Browser="BlackBerry";
            
                // Return result
                return Browser & " " & BrowserVer;
            
            }
            
            // Unable to identify browser
            return "Unknown";
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
	<cffunction name="formatPhoneNumber" access="public" returntype="string" output="no" hint="Returns a formatted phone number xxx-xxx-xxxx">
		<cfargument name="phoneNumber" type="string" default="">
		
        <cfscript>
			// First lets ditch all non numeric values
			ARGUMENTS.phoneNumber = ReReplaceNoCase(ARGUMENTS.phoneNumber,"[^0-9]","","ALL");
			
			vNumber = Right(ARGUMENTS.phoneNumber,4);
			
			vPrefix = Left(Right(ARGUMENTS.phoneNumber,7),3);
			
			vAreaCode = Left(Right(ARGUMENTS.phoneNumber,10),3);
			
			return vAreaCode & "-" & vPrefix & "-" & vNumber;
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

    
    <!-----Update the ToDoList, and if user is a Facilitor or Office person, update paperwork as well.---->
	<cffunction name="updateHostAppToDoList" access="public" returntype="string">
        <cfargument name="hostid" type="numeric" required="yes" default="" hint="Pass in host id you are updating">
        <cfargument name="studentid" type="numeric" required="no" default="0" hint="student id of student assigned to host">
        <Cfargument name="itemID" type="numeric" required="yes" default="0" hint="Item that is being approved">
        <cfargument name="userType" type="numeric" required="yes" default="0" hint="the user type updating, so we know what date to insert.">
        <cfargument name="denyApp" type="numeric" required="no" default="0" hint="the user type updating, so we know what date to insert.">
        
        
        <!----Check if there is a record on file for this host.  First we check if any record exits for current student.  If not student is assigned, make sure only one non-studet assigned exits, we don't need multiple non-assigned records for any given host family.---->
        
        <cfquery name="checkRecord" datasource="#APPLICATION.DSN#">
            SELECT
             id, fk_studentid, fk_hostid
            FROM
                smg_ToDoListDates
            WHERE 
                fk_HostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostid)#">
            AND
            	itemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.itemID)#">
            <!----<cfif #VAL(ARGUMENTS.studentid)#>
            AND
                fk_StudentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentid)#">
            </cfif>
			---->
           
        </cfquery>
       
        
        <Cfif checkRecord.recordcount gt 1>
			<cfset status = 'Multiple records with out a student assigned.  Please contact IT.'>
             <cfscript>
                return(status);
            </cfscript>
        <Cfelseif checkRecord.recordcount eq 1>
        	<Cfquery name="updateToDoList" datasource="#application.dsn#">
        	update smg_ToDoListDates
				set  
                <Cfif val(ARGUMENTS.studentid)>
                	fk_StudentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">,
                </Cfif>
                <cfif ARGUMENTS.denyApp eq 1>
                	<Cfif ARGUMENTS.userType eq 7>
                    	areaRepDenial 
                    <cfelseif ARGUMENTS.userType eq 6>
                    	regionalAdvisorDenial 
                    <cfelseif ARGUMENTS.userType eq 5>
                    	regionalDirectorDenial 
                    <cfelseif ARGUMENTS.userType lte 4>
                    	facDenial 
                    </Cfif>
                     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.denyReason#">,
                <Cfelse>
                	<Cfif ARGUMENTS.userType eq 7>
                    	areaRepDenial 
                    <cfelseif ARGUMENTS.userType eq 6>
                    	regionalAdvisorDenial 
                    <cfelseif ARGUMENTS.userType eq 5>
                    	regionalDirectorDenial 
                    <cfelseif ARGUMENTS.userType lte 4>
                    	facDenial 
                    </Cfif>
                     = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                </cfif>
                	<Cfif ARGUMENTS.userType eq 7>
                    	areaRepApproval 
                    <cfelseif ARGUMENTS.userType eq 6>
                    	regionalAdvisorApproval
                    <cfelseif ARGUMENTS.userType eq 5>
                    	regionalDirectorApproval
                    <cfelseif ARGUMENTS.userType lte 4>
                    	facApproval
                    </Cfif>
               
                       =   <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">     
                
             WHERE id =  <cfqueryparam cfsqltype="cf_sql_integer" value="#checkRecord.id# ">   
            </Cfquery>
            <cfset status = 'Information Updated'>
        <Cfelse>
        	<Cfquery name="updateToDoList" datasource="#application.dsn#">
        	insert into smg_ToDoListDates (
				<Cfif ARGUMENTS.userType eq 7>
                    	areaRepApproval 
                    <cfelseif ARGUMENTS.userType eq 6>
                    	regionalAdvisorApproval
                    <cfelseif ARGUMENTS.userType eq 5>
                    	regionalDirectorApproval
                    <cfelseif ARGUMENTS.userType lte 4>
                    	facApproval
                    </Cfif>, itemID, fk_hostid, fk_studentid,
                    
						<Cfif ARGUMENTS.userType eq 7>
                            areaRepDenial 
                        <cfelseif ARGUMENTS.userType eq 6>
                            regionalAdvisorDenial 
                        <cfelseif ARGUMENTS.userType eq 5>
                            regionalDirectorDenial 
                        <cfelseif ARGUMENTS.userType lte 4>
                            facDenial 
                        </Cfif>
                    
               
                    )
      values(<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.itemid# ">,
      			       <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostid# ">, <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentid# ">, <cfif ARGUMENTS.denyApp eq 1><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.denyReason#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value=""></cfif>)     
      
            </Cfquery>
            <cfset status = 'Record Updated'>  
        </Cfif>
        
        <cfif ARGUMENTS.userType LTE 4>
        	<!----need t update final paperwork screen---->
        </cfif>
         	
		<cfscript>
            return status;
        </cfscript>	
        
    </cffunction>
    
    <!--- Insert pdf file to the internal virtual folder --->
    <cffunction name="insertInternalFile" access="public" returntype="string">
    	<cfargument name="filePath" type="string" required="yes" hint="The full path to the file that will be added">
        <cfargument name="fieldID" type="numeric" required="yes" hint="The type of document being uploaded (such as Flight Information or Welcome Letters)">
        <cfargument name="studentID" type="numeric" required="yes" hint="The ID of the student this file belongs to">
        
        <cfscript>
		
			// Get active placement history record
			qGetActivePlacement = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=ARGUMENTS.studentID);
			    
			// Get folder path 
			currentDirectory = "#APPLICATION.PATH.onlineApp.internalVirtualFolder##ARGUMENTS.studentid#/#qGetActivePlacement.historyID#";
			
			// Set to the flightInformation directory
			if (fieldID == 1) {
				currentDirectory = currentDirectory & "/flightInformation";	
			}
			
			// Make sure the folder Exists
        	createFolder(currentDirectory);
			
		</cfscript>
        
        <cffile action="move" source="#ARGUMENTS.filePath#" destination="#currentDirectory#" nameconflict="makeunique" mode="777">
        
        <cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">
        
 	</cffunction>
    
     <!--- Send Compliance Log Email --->
    <cffunction name="sendComplianceLog" access="public" returntype="string">
        
    	<cfargument name="email_to" type="string" required="yes" hint="pass in list of emails to sent to">
    	<cfargument name="stuNameID" type="string" required="yes" hint="pass in name and id of student with problem">
        <cfargument name="historyID" type="string" required="yes" hint="pass in historyID">
        <cfargument name="foreignTable" type="string" required="yes" hint="pass in historyID">
    	<cfscript>
       // Get Compliance Log
		qGetComplianceHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
			applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,																				   
			foreignTable=ARGUMENTS.foreignTable,
			foreignID=ARGUMENTS.historyID,
			isResolved = 0
		);
    	</cfscript>
    <cfsavecontent variable="mailMessage">                      
		<cfoutput>
        The following compliance issues need to be resolved for #ARGUMENTS.stuNameID#
        
        <br><br>
      			 <table width="90%" cellpadding="2" cellspacing="0"align="center">       
                 		<Tr bgcolor="##666666">
                        	<td></td><td><font color="white">Date</td><td><font color="white">Issue</td><td><font color="white">Recorded By</td>
                           
                        </Tr>     
                        <cfif qGetComplianceHistory.recordcount eq 0>
                        <tr>
                        	<Td colspan=4>Ooops.  No unresolved issues found in the compliance log.</Td>
                        </tr>
                        <cfelse>             
                            <cfloop query="qGetComplianceHistory">                    
                                <tr <cfif qGetComplianceHistory.currentrow mod 2>bgcolor="##ccc"</cfif>> 
                                    <td width="5%">&nbsp;</td>
                                    <td width="20%">#DateFormat(qGetComplianceHistory.dateCreated, 'mm/dd/yy')# at #TimeFormat(qGetComplianceHistory.dateCreated, 'hh:mm tt')# EST</td>
                                    <td width="50%">#qGetComplianceHistory.actions#</td>
                                    <td width="15%">#qGetComplianceHistory.enteredBy#</td>
                                    
                                </tr>
                            </cfloop>
                        </cfelse>                        
                    </table>
      <br>
      	<hr widht=75% align="center">
       <br><br>
      Regards-<br>
      Compliance Department
		</cfoutput>
    </cfsavecontent>
      <cfinvoke component="nsmg.cfc.email" method="send_mail">
      			<!----
                <cfinvokeargument name="email_to" value="#get_user.email#">
				---->
                <cfinvokeargument name="email_to" value="#email_to#">
                <cfinvokeargument name="email_replyto" value="#CLIENT.email#">
                <cfinvokeargument name="email_subject" value="Compliance Issues with Host Family">
                <cfinvokeargument name="email_message" value="#mailMessage#">
                
       </cfinvoke>
	 
    
         
        
 	</cffunction>
</cfcomponent>