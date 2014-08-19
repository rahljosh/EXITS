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
				vAdmissionsEmailLink = '<a href="mailto:bhause@iseusa.org">bhause@iseusa.org</a>';			
				vAdmissionsInfo = 'Brian Hause at <a href="mailto:bhause@iseusa.org">bhause@iseusa.org</a>';
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
		
			// Set SESSION.EMAIL
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
			var vUserListISE = '7657,9719,1'; // Thea Brewer | Bryan McCready | Josh Rahl
			
			// CASE
			var vUserListCASE = '11364'; // Stacy Brewer
			
			// ESI
			var vListESI = '11364,16761'; // Stacy Brewer | Stacy Brewer
			
			// Stores all IDs so we can check quickly and return a masked SSN
			var vAllowedIDList = '7657,9719,11364,16761,1';
			
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
    
    <!--- Get virtual folder documents --->
    <cffunction name="getVirtualFolderDocuments" access="public" returntype="query">
    	<cfargument name="documentType" default="0" required="no" hint="documentType is not required">
        <cfargument name="categoryID" default="0" required="no" hint="categoryID is not required">
        <cfargument name="hostID" default="0" required="no" hint="hostID is not required">
        <cfargument name="studentID" default="0" required="no" hint="studentID is not required">
        <cfargument name="userID" default="0" required="no" hint="userID is not required">
        
        <cfquery name="qGetVFDocuments" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM virtualFolder
            WHERE isDeleted = 0
            <cfif VAL(ARGUMENTS.documentType)>
            	AND fk_documentType = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.documentType#">
            </cfif>
            <cfif VAL(ARGUMENTS.categoryID)>
            	AND fk_categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.categoryID#">
            </cfif>
            <cfif VAL(ARGUMENTS.hostID)>
            	AND fk_hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
            </cfif>
            <cfif VAL(ARGUMENTS.studentID)>
            	AND fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
            </cfif>
            <cfif VAL(ARGUMENTS.userID)>
            	AND fk_userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
            </cfif>
        </cfquery>
        
        <cfreturn qGetVFDocuments>
        
    </cffunction>

    
    <!--- Insert pdf file to the internal virtual folder --->
    <cffunction name="insertInternalFile" access="public" returntype="string">
    	<cfargument name="filePath" type="string" required="yes" hint="The full path to the file that will be added">
        <cfargument name="fieldID" type="numeric" required="yes" hint="The type of document being uploaded (such as Flight Information or Welcome Letters)">
        <cfargument name="studentID" type="numeric" required="yes" hint="The ID of the student this file belongs to">
        <cfargument name="hostID" type="numeric" required="no" default="0" hint="Places the file into the hostID folder">
        <cfargument name="folder" type="string" default="" required="no" hint="folder name if needed.">
        
        <cfscript>
		
			// Get active placement history record
			qGetActivePlacement = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=ARGUMENTS.studentID);
			    
			// Get folder path
			if (ARGUMENTS.hostID NEQ 0) {
				currentDirectory = "#APPLICATION.PATH.onlineApp.virtualFolder##ARGUMENTS.studentid#/#ARGUMENTS.hostID#";
			} else {
				currentDirectory = "#APPLICATION.PATH.onlineApp.virtualFolder##ARGUMENTS.studentid#";
			}
			
			// Set to the flightInformation directory
			if (fieldID == 1) {
				currentDirectory = currentDirectory & "/#ARGUMENTS.folder#";	
			}
			
			// Make sure the folder Exists
        	createFolder(currentDirectory);
			
		</cfscript>
        
        <cffile action="move" source="#ARGUMENTS.filePath#" destination="#currentDirectory#" nameconflict="makeunique" mode="777">
        
        <cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">
        
 	</cffunction>
    
    
	<!--- Insert file information into the virtualfolder table. --->
    <cffunction name="insertIntoVirtualFolder" access="public" returntype="void" output="no">
    	<cfargument name="categoryID" type="numeric" default="0">
        <cfargument name="documentType" type="numeric" required="yes">
        <cfargument name="studentID" type="numeric" required="yes">
        <cfargument name="hostID" type="numeric" default="0">
        <cfargument name="fileDescription" type="string" default="">
        <cfargument name="fileName" type="string" default="">
        <cfargument name="filePath" type="string" default="" hint="if left blank will set to the student's virtual folder">
        <cfargument name="generatedHow" type="string" default="auto" hint="auto/manual">
        
        <cfif NOT LEN(ARGUMENTS.filePath)>
        	<cfset vPath = "uploadedfiles/virtualfolder/" & ARGUMENTS.studentID & "/">
            <cfif VAL(ARGUMENTS.hostID)>
            	<cfset vPath = vPath & ARGUMENTS.hostID & "/">
            </cfif>
        </cfif>
        
        <cfif NOT VAL(ARGUMENTS.categoryID)>
        	<cfquery name="qGetCategory" datasource="#APPLICATION.DSN#">
            	SELECT fk_category
                FROM virtualfolderdocuments
                WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.documentType#">
            </cfquery>
            <cfset ARGUMENTS.categoryID = qGetCategory.fk_category>
        </cfif>
        
        <cfquery datasource="#APPLICATION.DSN#">
        	INSERT INTO virtualFolder (
            	fk_categoryID,
                fk_documentType,
                fk_studentID,
                fk_hostID,
                fileDescription,
                fileName,
                filePath,
                generatedHow,
                dateAdded,
                uploadedBy )
          	VALUES (
           		<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.categoryID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.documentType)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fileDescription#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fileName#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#vPath#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.generatedHow#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#"> )
        </cfquery>
        
    </cffunction>
    
    <!--- Delete from virtual folder --->
    <cffunction name="deleteFromVirtualFolder" access="public" returntype="void">
    	<cfargument name="ID" required="yes" hint="ID is required">
        
        <cfquery datasource="#APPLICATION.DSN#">
        	UPDATE virtualFolder
            SET isDeleted = 1
            WHERE vfID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.ID)#">
        </cfquery>
        
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
            	<p>The following compliance issues need to be resolved for #ARGUMENTS.stuNameID#</p>
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
                    </cfif>                        
                </table>
          		<br>
            	<hr widht=75% align="center">
           		<br><br>
          		Regards-<br>
          		Compliance Department
            </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#email_to#">
            <cfinvokeargument name="email_replyto" value="#CLIENT.email#">
            <cfinvokeargument name="email_subject" value="Compliance Issues with Host Family">
            <cfinvokeargument name="email_message" value="#mailMessage#">
        </cfinvoke>
        
 	</cffunction>
    


 	<!--- Gnerate Auto Files and place in Virtual Folder --->
    <cffunction name="createAutoFiles" access="public" returntype="string">
    	<cfargument name="studentID" required="no" hint="student of id of placement">
    	<cfargument name="hostID"  required="no" hint="pass in name and id of student with problem">
        <cfargument name="uniqueID"  required="no" hint="unique ID for student">
        <cfargument name="folder" required="no" default="" hint="name of Folder in VF">
		<cfargument name="documentType" required="no" default="" hint="ID from virtualFolderDocuments">
		<cfargument name="category" required="no" default="" hint="ID from virtualFolderCategory">
		<cfargument name="fileDescription" required="no" default="" hint="Description of File">
		
        <!--- Kill Extra Output --->
		<cfsilent>
	
			<!--- Param URL Variables --->    
            <cfparam name="uniqueID" default="">
            <cfparam name="profileType" default="">
            <cfparam name="URL.studentID" default="0">
            <cfparam name="URL.historyID" default="0">
            <cfparam name="URL.printPage" default="0">
            <cfparam name="URL.closeModal" default="0">
            
            <!--- Param FORM Variables --->    
            <cfparam name="FORM.submitted" default="0">
            <cfparam name="FORM.report_mode" default="">
            <cfparam name="FORM.historyID" default="0">
            <cfparam name="FORM.emailTo" default="">
            <cfparam name="FORM.NewDatePlaced" default="">

			<cfscript>
                // Create Structure to store errors
                Errors = StructNew();
                // Create Array to store error messages
                Errors.Messages = ArrayNew(1);
                
                if ( NOT LEN(uniqueID) ) {
                    ArrayAppend(Errors.Messages, "You have not specified a valid studentID");
                }	
                
                // Get Student by uniqueID
                qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=uniqueID);
                
                if ( VAL(URL.historyID) ) {
                    FORM.historyID = URL.historyID;	
                }
                
                // Check if we are displaying current or history PIS
                if ( VAL(FORM.historyID) ) {
                    
                    // History PIS
                    qGetPlacementHistory = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=FORM.historyID);
                    
                } else {
                    
                    // Current PIS
                    qGetPlacementHistory = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID, isActive=1);
                    
                }
                
                // Get Region
                qGetRegion = APPLICATION.CFC.REGION.getRegions(regionID=qGetStudentInfo.regionassigned);
        
                // Get International Representative
                qIntlRep = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.intrep);
                
                // Get Company
                qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
                
                // Facilitator
                qGetFacilitator = APPLICATION.CFC.USER.getUsers(qGetRegion.regionfacilitator); 
        
                // Area Representative
                qGetAreaRep = APPLICATION.CFC.USER.getUserByID(userID=qGetPlacementHistory.areaRepID);
                
                // Host Family
                qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=VAL(qGetPlacementHistory.hostID));
                
                // Host Family Children
                qGetHostChildren = APPLICATION.CFC.HOST.getHostMemberByID(hostID=VAL(qGetPlacementHistory.hostID));
                
                // Host Family Pets
                qGetHostPets = APPLICATION.CFC.HOST.getHostPets(hostID=VAL(qGetPlacementHistory.hostID));
                
                // School
                qGetSchool = APPLICATION.CFC.SCHOOL.getSchools(schoolID=VAL(qGetPlacementHistory.schoolID));
                                
                // Get Host Interests
                qGetHostInterests = APPLICATION.CFC.LOOKUPTABLES.getInterest(interestID=qGetHostFamily.interests,limit=6);
                
                // set Interest List
                interestHostList = ValueList(qGetHostInterests.interest, "<br />");
                
                // FORM SUBMITTED
                if ( VAL(FORM.submitted) ) {
        
                    // Data Validation
                    if ( NOT IsValid("email", FORM.emailTo) ) {
                        ArrayAppend(Errors.Messages, "Please enter a valid email address");
                    }
        
                }
            </cfscript>
    
			<!--- Update Date Placed | Update on both tables students and smg_hostHistory --->
            <cfif IsDate(FORM.NewDatePlaced)>
                
                <cfscript>
                    // Update Date Placed
                    APPLICATION.CFC.STUDENT.updateDatePlaced(studentID=qGetStudentInfo.studentID, historyID=FORM.historyID, datePlaced=FORM.newDatePlaced);
                    
                    // Reload page
                    //location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
                </cfscript>
        
            </cfif>
    
            <cfquery name="qGetSchoolDates" datasource="#APPLICATION.DSN#">
                SELECT 
                    schooldateid, 
                    schoolid, 
                    smg_school_dates.seasonid, 
                    enrollment, 
                    year_begins, 
                    semester_ends, 
                    semester_begins, 
                    year_ends,
                    p.programid
                FROM 
                    smg_school_dates
                INNER JOIN 
                    smg_programs p ON p.seasonid = smg_school_dates.seasonid
                WHERE 
                    schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetPlacementHistory.schoolID)#">
                AND 
                    p.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.programid)#">
            </cfquery>
    
			<!---number kids at home---->
            <cfquery name="qGetHostChildrenAtHome" dbtype="query">
                SELECT 
                    count(childid)
                FROM 
                    qGetHostChildren
                WHERE
                    liveathome = 'yes'
            </cfquery>
    
			<cfscript>
                // Calculates how many family members
                vFather=0;
                vMother=0;
                
                if ( LEN(qGetHostFamily.fatherfirstname) ) {
                    vFather = 1;
                }
        
                if ( LEN(qGetHostFamily.motherfirstname) ) {
                    vMother = 1;
                }
                
                vTotalFamilyMembers = vMother + vFather + qGetHostChildrenAtHome.recordcount;
            </cfscript>
    
		</cfsilent>
        
        <!----Placement Information Sheet---->
		<cfoutput>
		
			<!----Save profile as variable---->
			<cfsavecontent variable="PlacementInfo">
	
                <link rel="stylesheet" href="https://ise.exitsapplication.com/nsmg/linked/css/student_profile.css" type="text/css">
                
                <table class="profileTable" align="center">
                    <tr>
                        <td>
                
                            <!--- Header --->
                            <table align="center">
                                <tr>
                                    <td class="bottom_center" width="800"  valign="top">
                                        <img src="https://ise.exitsapplication.com/nsmg/pics/#CLIENT.companyid#_short_profile_header.jpg" />
                                        <span class="title"><font size=+1>Placement Information for</font></span><font size=+1>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#</font><font size=+1> (###qGetStudentInfo.studentID#)</font><br />
                                        <span class="title">Facilitator:</span>  #qGetFacilitator.firstname# #qGetFacilitator.lastname# 
                                    </td>
                                </tr>	
                            </table>
                            
                            <cfif vTotalFamilyMembers eq 1>
                                <div class="alert" align="Center">
                                    <h3>Single Person Placement </h3>
                                </div>
                            </cfif>
                            
                            <cfif VAL(qGetPlacementHistory.doublePlacementID)>
                                <div class="alert" align="Center">
                                    <h3>Double Placement: Two exchange students will be living with this host family. </h3>
                                </div>
                            </cfif>
                            
                            <cfif qGetPlacementHistory.isWelcomeFamily EQ 1>	
                                <div class="alert" align="Center">
                                    <h3>This is a welcome family.  Permanent family information will be sent shortly.</h3>
                                </div>
                            </cfif>
                            
                            <cfif VAL(qGetPlacementHistory.isRelocation)>
                                <div class="alert" align="Center">
                                    <h3>This is a relocation. The student will be moving to this host family and/or school shortly.</h3>
                                </div>
                            </cfif>
                
                            <!--- Student Information #qGetStudentInfo.countryresident# --->
                            <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                                <tr>           
                                    <td colspan=5 align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/HFbanner.png" /></Td>
                                </tr>
                                <tr>
                                    <td valign="top">
                
                                        <!---Host Family Information---->
                                        <table>
                                        
                                            <cfif LEN(qGetHostFamily.fatherfirstname)>
                                                <tr>
                                                    <td width="100"><span class="title">Host Father:</span></td>
                                                    <td width="250">
                                                        #qGetHostFamily.fatherfirstname# #qGetHostFamily.fatherlastname#, 
                                                        <cfif IsDate(qGetHostFamily.fatherDOB)>
                                                            (#DateDiff('yyyy', qGetHostFamily.fatherDOB, now())#)
                                                        </cfif>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Occupation:</span></td>
                                                    <td>#qGetHostFamily.fatherworktype#</td>
                                                </tr>
                                                <tr><td>&nbsp;</td></tr>
                                            </cfif>
                                            
                                            <cfif LEN(qGetHostFamily.motherfirstname)>
                                                <tr>
                                                    <td width="100"><span class="title">Host Mother:</span></td>
                                                    <td width="250">
                                                        #qGetHostFamily.motherfirstname# #qGetHostFamily.motherlastname#, 
                                                        <cfif IsDate(qGetHostFamily.motherDOB)>
                                                            (#DateDiff('yyyy', qGetHostFamily.motherDOB, now())#)
                                                        </cfif>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><span class="title">Occupation:</span></td>
                                                    <td>#qGetHostFamily.motherworktype#</td>
                                                </tr>
                                            </cfif>
                                        </table>
                                
                                    </td>
                
                                    <td valign="top">
                                    
                                        <!----Address & Contact Info----> 
                                        <Table>
                                            <tr>
                                                <td width="100" valign="top"><span class="title">Address:</span></td>
                                                <td>
                                                    #qGetHostFamily.address#<br />
                                                    <a href="http://en.wikipedia.org/wiki/#qGetHostFamily.city#,_#qGetHostFamily.state#" target="_blank" class="wiki">#qGetHostFamily.city# #qGetHostFamily.state# </a>, #qGetHostFamily.zip#
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100" valign="top"><span class="title">Phone: </span></td>
                                                <td>#qGetHostFamily.phone#</td>
                                            </tr>
                                            <tr>
                                                <td width="100" valign="top"><span class="title">Email: </span></td>
                                                <td>#qGetHostFamily.email#</td>
                                            </tr>
                                           
                                            <tr>
                                                <td width="100" valign="top"><span class="title">Placed: </span></td>
                                                <td>#DateFormat(qGetPlacementHistory.datePlaced, 'mmmm d, yyyy')#</td>
                                            </tr>
                                            
                                        </table>
                
                                    </td>
                                </tr>                
                            </table>
                            
                            <!----Siblings and Pets---->
                            <table  align="center" border="0" cellpadding="4" cellspacing="0" width="800">
                                <tr>           
                                    <Td><img src="https://ise.exitsapplication.com/nsmg/pics/sib.png" /></Td>
                                    <td><img src="https://ise.exitsapplication.com/nsmg/pics/pets.png" /></td>
                                    <td><img src="https://ise.exitsapplication.com/nsmg/pics/interest.png" /></td>
                                </tr>
                                <tr>
                                    <td valign="top" width=40%>
                                
                                        <!---Siblings---->
                                        <table width="100%" align="Center">
                                            <tr>
                                                <td><span class="title">Name</span><br /></td>
                                                <td align="center"><span class="title">Age</span><br /></td>
                                                <td align="center"><span class="title">Sex</span><br /></td>
                                                <td align="center"><span class="title">At home</span><br /></td>
                                                <td align="center"><span class="title">Relation</span><br /></td>
                                            </tr>
                                            <cfloop query="qGetHostChildren">
                                                <tr>
                                                    <td>
                                                        <cfset maxwords = 1>
                                                        #REReplace(qGetHostChildren.name,"^(#RepeatString('[^ ]* ',maxwords)#).*","\1")#
                                                    </td>
                                                    <td align="center">
                                                        <cfif IsDate(qGetHostChildren.birthdate)>
                                                            #DateDiff('yyyy', qGetHostChildren.birthdate, now())#
                                                        <cfelse>
                                                            n/a
                                                        </cfif>
                                                    </td>
                                                    <td align="center">#qGetHostChildren.sex#</td>
                                                    <td align="center">#qGetHostChildren.liveathome#</td>
                                                    <td align="center">#qGetHostChildren.membertype#</td>
                                                </tr>
                                            </cfloop>
                                            
                                            <cfquery name="qGetShareChildren" datasource="#APPLICATION.DSN#">
                                                SELECT
                                                    name AS firstName,
                                                    'host sibling' AS relation                                        
                                                FROM
                                                    smg_host_children
                                                WHERE
                                                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetPlacementHistory.hostID)#">
                                                AND
                                                    roomShareWith = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
                                                
                                                UNION
                                               
                                                SELECT
                                                    s.firstName,
                                                    'foreign student' AS relation
                                                FROM
                                                    smg_students s
                                                WHERE
                                                    s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                                                AND
                                                    double_place_share = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
                                            </cfquery>
                                            
                                        </table>
                                    
                                        <cfif VAL(qGetShareChildren.recordCount)>
                                            <table width="100%" align="Center" style="margin-top:10px;">
                                                <tr>
                                                    <td>
                                                        #qGetStudentInfo.firstname# is sharing a room with #qGetShareChildren.relation# #qGetShareChildren.firstName#
                                                    </td>
                                                </tr>
                                            </table>                                       	
                                        </cfif>
            
                                    </td>
                
                                    <td valign="top">
                                    
                                        <!----Animals---->
                                        <Table align="Center">
                                        <tr>
                                            <td align="center"><span class="title">Type</span></td>
                                            <td align="center"><span class="title">Number</span></td>
                                            <td align="center"><span class="title">Indoor</span></td>
                                        </tr>
                                        <cfloop query="qGetHostPets">
                                            <tr>		
                                                <td>#qGetHostPets.animaltype#</td>
                                                <td align="center">
                                                    <cfif qGetHostPets.number EQ 11>
                                                        10+
                                                    <cfelse>
                                                        #qGetHostPets.number#
                                                    </cfif>
                                                </td>
                                                <td align="center">#qGetHostPets.indoor#</td>
                                            </tr>
                                        </cfloop>
                                        </table>
                
                                    </td>
            
                                    <td valign="top">
            
                                        <!----Interests---->
                                        <Table align="Center">
                                            <tr>
                                                <td>
                                                    #interestHostList#                                    
                                                </td>
                                            </tr>
                                        </table>
                
                                    </td>
                                </tr>                
                            </table>
                
                            <!--- Community Information --->
                            <table align="center" class="profileTable2" width="100%">
                                <tr bgcolor="##0854a0" align="center" ><img src="https://ise.exitsapplication.com/nsmg/pics/CIinfo.png" /></td></tr>     
                                <tr>
                                    <td>
                                        <cfif LEN(qGetHostFamily.community)>
                                            The community is #qGetHostFamily.community#
                                        </cfif>
                                            
                                        <cfif qGetHostFamily.community is 'small'>town</cfif>.
                                        
                                        <cfif LEN(qGetHostFamily.nearbigcity)>
                                            The nearest big city is <a href="http://en.wikipedia.org/wiki/#qGetHostFamily.nearbigcity#" target="_blank" class="wiki">#qGetHostFamily.nearbigcity# </a> is #qGetHostFamily.near_city_dist# miles away.
                                        </cfif>
                                        
                                        <cfif LEN(qGetHostFamily.major_air_code)>
                                            The Closest arrival airport is <a href="http://www.airnav.com/airport/K#qGetHostFamily.major_air_code#" target="_blank" class="airport">#qGetHostFamily.major_air_code#</A>
                                            <cfif LEN(qGetHostFamily.airport_city)>
                                                , in the city of  <a href="http://en.wikipedia.org/wiki/#qGetHostFamily.airport_city#" target="_blank" class="wiki">#qGetHostFamily.airport_city# </a> 
                                            </cfif>                            
                                        </cfif>
                                        
                                        <br /><br />
                                        
                                        <cfif LEN(qGetHostFamily.pert_info)>Points of interest in the community: #qGetHostFamily.pert_info#</cfif>
                                    </td>
                                </tr>
                            </table>
                
                            <table align="center" class="profileTable2" width="100%">
                                <tr bgcolor="##0854a0" align="center" ><img src="https://ise.exitsapplication.com/nsmg/pics/schoolinfo.png" /></td></tr>            
                                <tr>
                                    <td valign="top">
                                    
                                        <!---School Dates---->
                                        <table>
                                            <cfif LEN(qGetSchoolDates.enrollment)>
                                                <Tr>
                                                    <td><span class="title">Orientation</span></td>
                                                    <td>
                                                        <cfif IsDate(qGetSchoolDates.enrollment)>
                                                            #DateFormat(qGetSchoolDates.enrollment, 'mmmm d, yyyy')#**
                                                        <cfelse>
                                                            Not Available
                                                        </cfif>
                                                    </td>
                                                </Tr>
                                            </cfif>
                                            <Tr>
                                                <td><span class="title">1<sup>st</sup> Semester Begins:</span></td>
                                                <td>
                                                    <cfif IsDate(qGetSchoolDates.year_begins)>
                                                        #DateFormat(qGetSchoolDates.year_begins, 'mmmm d, yyyy')#**
                                                    <cfelse>
                                                        Not Available
                                                    </cfif>
                                                </td>
                                            </Tr>
                                            <Tr>
                                                <td><span class="title">1<sup>st</sup> Semester Ends:</span></td>
                                                <td>
                                                    <cfif IsDate(qGetSchoolDates.semester_ends)>
                                                        #DateFormat(qGetSchoolDates.semester_ends, 'mmmm d, yyyy')#**
                                                    <cfelse>
                                                        Not Available
                                                    </cfif>                                    
                                                </td>
                                            </Tr>
                                            <Tr>
                                                <td><span class="title">2<sup>nd</sup> Semester Begins:</span></td>
                                                <td>
                                                    <cfif IsDate(qGetSchoolDates.semester_begins)>
                                                        #DateFormat(qGetSchoolDates.semester_begins, 'mmmm d, yyyy')#**
                                                    <cfelse>
                                                        Not Available
                                                    </cfif>
                                                </td>
                                            </Tr>
                                            <Tr>
                                                <td><span class="title">Year Ends:</span></td>
                                                <td>
                                                    <cfif IsDate(qGetSchoolDates.year_ends)>
                                                        #DateFormat(qGetSchoolDates.year_ends, 'mmmm d, yyyy')#**
                                                    <cfelse>
                                                        Not Available
                                                    </cfif>
                                                </td>
                                            </Tr>
                                        </table>
                                        
                                    </td>
                                    <td valign="top">
                                    
                                        <!---- School Address & Contact Info---->
                                        <Table>
                                            <Tr>
                                            
                                            <tr>
                                                <td valign="top"><span class="title">Name:</span></td>
                                                <td><a href="#qGetSchool.url#">#qGetSchool.schoolname#</a></td>
                                            </tr>
                                            <tr>
                                                <td width="100" valign="top"><span class="title">Address:</span></td>
                                                <td>
                                                    #qGetSchool.address#
                                                    <cfif LEN(qGetSchool.address2)>
                                                        <br />#qGetSchool.address2#
                                                    </cfif>
                                            
                                                    <a href="http://en.wikipedia.org/wiki/#qGetSchool.city#,_#qGetSchool.state#" target="_blank" class="wiki">
                                                        #qGetSchool.city#, #qGetSchool.state# 
                                                    </a>, 
                                                    
                                                    #qGetSchool.zip#
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100" valign="top"><span class="title">Phone: </span></td>
                                                <td>#qGetSchool.phone#</td>
                                            </tr>
                                            <tr>
                                                <td width="100" valign="top"><span class="title">Contact: </span></td>
                                                <td><a href="#qGetSchool.url#">#qGetSchool.principal#</a></td>
                                            </tr>
                                        </table>
                
                                    </td>
                                </tr>
                                
                                <cfif LEN(qGetHostFamily.schoolcosts)>
                                    <Tr>
                                        <Td colspan=2>The student is responsible for the following expenses: #qGetHostFamily.schoolcosts#</Td>
                                    </Tr>
                                </cfif>
                                <tr>
                                    <td colspan=2>
                                    	<i>
                                        	** These school dates are preliminary and subject to change due to school schedule changes, weather-related school closures and other factors.  Flights booked based on these dates will need to be changed if the schedule changes.
                                      	</i>
                                	</td>
                                </tr>
                            </table>
                
                            <table width="800">
                                <Tr>
                                    <Td width="100%" valign="top">
                                        
                                        <!--- Area Representative --->
                                        <table align="center" width="100%">
                                            <tr bgcolor="##0854a0"><td colspan=10 align="center" ><img src="https://ise.exitsapplication.com/nsmg/pics/ARbanner.png" /></td></tr>     
                                            <tr>
                                                <td valign="top"><span class="title">Name:</span></td>
                                                <Td valign="top">#qGetAreaRep.firstname# #qGetAreaRep.lastname#</Td>
                                                <td  valign="top"><span class="title">Address:</span></td>
                                                <Td valign="top">
                                                    #qGetAreaRep.address#<br />
                                                    <Cfif LEN(qGetAreaRep.address2)>#qGetAreaRep.address2#<br /></Cfif>
                                                    #qGetAreaRep.city# #qGetAreaRep.state#, #qGetAreaRep.zip#
                                                </Td>
                                                <td  valign="top"><span class="title">Phone:</span></td>
                                                <Td valign="top">#qGetAreaRep.phone#</Td>
                                            </tr>
                                            <tr>
                                            <td colspan="4"></td>
                                            <td  valign="top"><span class="title">Email:</span></td>
                                            <td  valign="top">#qGetAreaRep.email#</td>
                                        </table>
               
                                    </Td>
                                </Tr>
                                
                                <tr>
                                    <td  valign="top">
                                    
                                        <table align="center" width="100%"  >
                                            <tr bgcolor="##0854a0"><td colspan=10 align="center" ><img src="https://ise.exitsapplication.com/nsmg/pics/addinfo.png" /></td></tr>     
                                            <tr>
                                                <td>
                                                    <cfif LEN(qGetStudentInfo.placement_notes) AND NOT VAL(FORM.historyID)>
                                                        #qGetStudentInfo.placement_notes#<br /><br />
                                                    </cfif>		
                                                    
                                                    <cfif NOT VAL(qGetPlacementHistory.isRelocation)>
                                                        The student should plan to arrive within five days from start of school. Please advise us of 
                                                        #qGetStudentInfo.firstname#'s arrival information as soon as possible. Please upload flight information through EXITS.
                                                    </cfif><br />
                                                    
                                                </td>
                                            </tr>
                                        </table>
                
                                    </td>
                                </tr>
                            </table>
                            
                        </td>
                    </tr>
                </table>
                
            </cfsavecontent>
            
		</cfoutput>
      
	  	<cfset fileName="placementInformationSheet_#qGetStudentInfo.studentID#_#DateFormat(NOW(),'mm-dd-yyyy')#-#TimeFormat(NOW(),'hh-mm')#">
		<cfoutput>
            <cfdocument format="pdf" filename="#fileName#.pdf" overwrite="yes" orientation="landscape" name="uploadFile">
                #PlacementInfo#
            </cfdocument>
        </cfoutput>
        <cfscript>
            //fullPath='#APPLICATION.PATH.onlineApp.virtualFolder#//#qGetStudentInfo.studentid#';
            fullPath=GetDirectoryFromPath(GetCurrentTemplatePath()) & fileName & '.pdf';
            APPLICATION.CFC.UDF.insertInternalFile(filePath=fullPath,fieldID=1,studentID=qGetStudentInfo.studentID,hostID=qGetStudentInfo.hostID);
        </cfscript>
     	<cfquery name="insertFileDetails" datasource="#application.dsn#">
   			INSERT INTO  virtualFolder (
            	fk_categoryID, 
                fk_documentType, 
                fileDescription,
                fileName, 
                filePath, 
                fk_studentID,
                fk_hostid,
                dateAdded,
                generatedHow,
                uploadedBy)
         	VALUES(
            	2,
                3,
                'PIS',
                '#fileName#.pdf', 
                'uploadedfiles/virtualFolder/#qGetStudentInfo.studentID#/#qGetStudentInfo.hostID#/',
                #qGetStudentInfo.studentID#,
                #qGetHostFamily.hostID#,
                #now()#,
                'auto',
                #client.userid#)
		</cfquery>
        
		<!----Host Welcome Letter---->          
        <!-----Company Information----->
        <!-----Company Information----->
<Cfquery name="companyshort" datasource="#APPLICATION.DSN#">
	select *
	from smg_companies
	where companyid = '#client.companyid#'
</Cfquery>


	<cfquery name="qGetStudent" datasource="#APPLICATION.DSN#">
        SELECT s.studentid, s.hostid, s.familylastname as lastname, s.firstname, s.arearepid, s.regionassigned, s.dateplaced,
            h.familylastname, h.address, h.address2, h.city, h.state, h.zip, 
            c.countryname
        FROM smg_students s
        LEFT JOIN smg_hosts h ON h.hostid = s.hostid
        INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
        WHERE s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.studentid#">
    </cfquery>


<cfquery name="program_info" datasource="#APPLICATION.DSN#">
	select programname, startdate, enddate
	from smg_programs 
	left join smg_students on smg_programs.programid = smg_students.programid 
	where smg_students.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.studentid#">
</cfquery>

<cfsavecontent variable="letter">

	<cfoutput>

        <table width=650 align="center" border=0 bgcolor="FFFFFF">
            <tr>
            <td><img src="https://ise.exitsapplication.com/nsmg/pics/logos/#client.companyid#.gif"  alt="" border="0" align="left"></td>	
            <td valign="top" align="right"> 
                <div align="right"><span id="titleleft">
                #companyshort.companyname#<br>
                #companyshort.address#<br>
                #companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
                <cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
                <cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
                <cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
            </td></tr>		
        </table>
        
        <br>
        <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr><td><hr width=90% align="center"></td></tr>
        </table>
        <br>
        
        <table width=650 align="center" border=0 bgcolor="FFFFFF">
            <tr>
                <td align="left">The #qGetStudent.familylastname# Family<br>
                    #qGetStudent.address#<br>
                    <Cfif qGetStudent.address2 is ''><cfelse>#qGetStudent.address2#<br></Cfif>
                    #qGetStudent.city#, #qGetStudent.state# #qGetStudent.zip#
                </td>
                <td align="right">
                    Program: #program_info.programname#<br>
                    From: #DateFormat(program_info.startdate,'mmm. d, yyyy')# thru #DateFormat(program_info.enddate,'mmm. d, yyyy')#<br><br>
                </td>
            </tr>
        <tr><td align="right" colspan="2">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td></tr>
        </table>
        <br>
        
        <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr><td><div align="justify">
        Dear #qGetStudent.familylastname# Family,
        
        <p>On behalf of everyone at #companyshort.companyshort_nocolor#, we would like to thank you for opening up your heart and
        home for #qGetStudent.firstname# #qGetStudent.lastname# from #qGetStudent.countryname#.</p>
        
        <p>We know that this experience will be a wonderful one for you and your family. By sharing
        your life with a young international student, you are giving your student the opportunity of a
        lifetime. Many students dream about living with an American family. It is only through
        families such as yours that this dream can become a reality.</p>
    
        <Cfquery name="rep_info" datasource='#APPLICATION.DSN#'>
        SELECT userid, firstname, lastname, phone
        FROM smg_users WHERE userid = '#qGetStudent.arearepid#'
        </cfquery>
        
        <cfquery name="rd" datasource="#APPLICATION.DSN#">
        SELECT smg_users.userid, firstname, lastname, phone
        FROM smg_users
        INNER JOIN user_access_rights ON smg_users.userid = user_access_rights.userid
        WHERE user_access_rights.regionid = '#qGetStudent.regionassigned#' and user_access_rights.usertype = '5'
        </cfquery>
        
        <p>
        #companyshort.companyshort_nocolor# provides you with full support throughout #qGetStudent.firstname#'<cfif #right(qGetStudent.firstname, 1)# is 's'><cfelse>s</cfif> stay. 
        Your supervising Area Representative is #rep_info.firstname# #rep_info.lastname#, Phone Number: #rep_info.phone#.
        The Regional Director is #rd.firstname# #rd.lastname#, Phone Number: #rd.phone#.
        </p>
        
        <p>
        #qGetStudent.firstname# has already received the insurance information package containing an Insurance ID Card, 
        claim forms and instructions on how to use them. At any time you can also contact #rep_info.firstname# #rep_info.lastname#
        for information regarding the student's insurance, in case the student needs any assistance.
        </p>
        
        <p>
        #rep_info.firstname# #rep_info.lastname# will make monthly contact with #qGetStudent.firstname# and is always available to you should
        you have any concerns during the program. Enclosed is a host family handbook, student and HF evaluation packets and information 
        regarding the student's insurance. Please be sure to read and review all the information contained in the
        handbook. Please also encourage #qGetStudent.firstname# to read and understand the guidelines in the student
        handbook. Sometime before #qGetStudent.firstname#'<cfif #right(qGetStudent.firstname, 1)# is 's'><cfelse>s</cfif>  
        arrival, you will be contacted by your Area Representative for an
        orientation. At this meeting your Area Representative will review the
        handbook with you and will answer any questions you and your family might have.
        </p>
        
        <p>
        Again, we thank you for sharing in our mission of making the world a little smaller, one
        student at a time.
        </p>
        
        <p>
        Very truly yours,<br><br>
        #companyshort.lettersig#<br>
        #companyshort.companyname#<br>
        </p></div></td></tr>
        </table>
        
    </cfoutput>

</cfsavecontent>            
            
                <cfset fileName="hostWelcomeLetter_#qGetStudentInfo.studentID#_#DateFormat(NOW(),'mm-dd-yyyy')#-#TimeFormat(NOW(),'hh-mm')#">
         <cfoutput>
            <cfdocument format="pdf" filename="#fileName#.pdf" overwrite="yes" orientation="landscape" name="uploadFile">
            	#letter#
           	</cfdocument>
        </cfoutput>    
			<cfscript>
				//fullPath='#APPLICATION.PATH.onlineApp.virtualFolder#//#qGetStudentInfo.studentid#';
				fullPath=GetDirectoryFromPath(GetCurrentTemplatePath()) & fileName & '.pdf';
				APPLICATION.CFC.UDF.insertInternalFile(filePath=fullPath,fieldID=1,studentID=qGetStudentInfo.studentID,hostID=qGetStudentInfo.hostID);
			</cfscript>
            <cfquery name="insertFileDetails" datasource="#application.dsn#">
            insert into  virtualFolder (fk_categoryID, 
            							fk_documentType, 
                                        fileDescription,
                                        fileName, 
                                        filePath, 
                                        fk_studentID,
                                        fk_hostid,
                                        dateAdded,
                                        generatedHow,
                                        uploadedBy)
            				     values(2,
                                 		23,
                                        'Welcome Letter',
                                        '#fileName#.pdf', 
                                        'uploadedfiles/virtualFolder/#qGetStudentInfo.studentID#/#qGetStudentInfo.hostID#/',
                                        #qGetStudentInfo.studentID#,
                                        #qGetHostFamily.hostID#,
                                        #now()#,
                                        'auto',
                                        #client.userid#)
            </cfquery> 
     
     
 <!----School Letter---->
 <!--- If set to save will save this report to the internal virtual folder --->
<cfparam name="URL.save" default="">



<!--- Get this history record, if none was sent in get the current information --->

	<cfquery name="get_letter_info" datasource="#application.dsn#">
		SELECT stu.studentid, stu.familylastname AS lastName, stu.firstname, stu.arearepid, stu.regionassigned, stu.hostid, 
			stu.schoolid, stu.grades, stu.countryresident, stu.sex, stu.dateplaced, stu.regionassigned,
			h.hostid, h.familylastname, h.address, h.address2, h.city, h.state, h.zip, h.phone,
			sc.schoolid, sc.schoolname, sc.principal, sc.address AS sc_address, sc.address2 AS sc_address2, sc.city AS sc_city, sc.state AS sc_state, sc.zip AS sc_zip, sc.phone AS sc_phone,
			ar.userid, ar.lastname AS ar_lastname, ar.firstname AS ar_firstname, ar.address AS ar_address, ar.address2 AS ar_address2, ar.city AS ar_city, 
			ar.state AS ar_state, ar.zip AS ar_zip, ar.phone AS ar_phone, ar.email AS ar_email, r.regionname,
			c.countryname
		FROM smg_students stu
		INNER JOIN smg_regions r on stu.regionassigned = r.regionid
		INNER JOIN smg_hosts h ON stu.hostid = h.hostid
		INNER JOIN smg_schools sc ON stu.schoolid = sc.schoolid
		INNER JOIN smg_users ar ON stu.arearepid = ar.userid
		INNER JOIN smg_countrylist c ON c.countryid = stu.countryresident
		WHERE stu.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.studentid#">
	</cfquery>

<cfsavecontent variable="schoolLetter">

	<cfoutput>
    <!--- letter header --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr>
            <td>
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td><img src="https://ise.exitsapplication.com/nsmg/pics/logos/#client.companyid#.gif"  alt="" border="0" align="left" height=110></td>
                    </tr>
                    <tr>
                        <td><font size=-1> #DateFormat(now(), 'mmmm dd, yyyy')#</font></td>
                    </tr>
                </table>
            </td>	
        	<td valign="top" align="right"> 
                <font size=-1>
                	<div align="right">
                		<span id="titleleft">
                			#companyshort.companyname#<br>
                			#companyshort.address#<br>
                			#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
                			<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
                			<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
                			<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif>
                			<cfif companyshort.generalContactEmail is ''><cfelse> Email: #companyshort.generalContactEmail#<br></cfif>
                      	</span>
                  	</div>
                </font>
        	</td>
     	</tr>		
    </table>
    
    <!--- line --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
    	<tr>
        	<td><hr width=90% align="center"></td>
      	</tr>
    </table>
    
    <!--- School info --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr>
            <td align="left">
                #get_letter_info.principal#<br>
                #get_letter_info.schoolname#<br>
                #get_letter_info.sc_address#<br>
                <Cfif get_letter_info.sc_address2 is ''><cfelse>#get_letter_info.sc_address2#<br></cfif>
                #get_letter_info.sc_city#, #get_letter_info.sc_state# #get_letter_info.sc_zip#<br>
            </td>
            <td align="right" valign="top">
                Program: #program_info.programname#<br>
                From: #DateFormat(program_info.startdate, 'mmm dd, yyyy')# to #DateFormat(program_info.enddate, 'mmm dd, yyyy')#	
            </td>
        </tr>
        <tr>
        	<td align="right" colspan="2"></td>
     	</tr>
    </table>
    
    <!--- student info --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
    	<tr>
        	<td><b>Student: #get_letter_info.firstname# #get_letter_info.lastName# from #get_letter_info.countryname#</b></td>
      	</tr>
    </table>
    <br>
    <!--- host family + Area Rep --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
        <tr>
            <td align="left" valign="top">
                <b>Host Family:</b><br>
                #get_letter_info.familyLastName# Family<br>
                #get_letter_info.address#<br>
                <Cfif get_letter_info.address2 is ''><cfelse>#get_letter_info.address2#<br></Cfif>
                #get_letter_info.city#, #get_letter_info.state# #get_letter_info.zip#<br>
                <Cfif get_letter_info.phone is ''><cfelse>Phone: &nbsp; #get_letter_info.phone#<br></Cfif>
            </td>
            <td align="left"><div align="justify">
                <b>Area Representative:</b><br>
                #get_letter_info.ar_firstname# #get_letter_info.ar_lastname#<br>
                #get_letter_info.ar_address#<br>
                <Cfif get_letter_info.ar_address2 is ''><cfelse>#get_letter_info.ar_address2#<br></Cfif>
                #get_letter_info.ar_city#, #get_letter_info.ar_state# #get_letter_info.ar_zip#
             </div>
            </td>
            <td>
            <b>Rep. Contact Information:</b><br>
                <Cfif get_letter_info.regionname is not ''>Region: #get_letter_info.regionname#<br></Cfif>
                <Cfif get_letter_info.ar_phone is ''><cfelse>Phone: &nbsp; #get_letter_info.ar_phone#<br></Cfif>
                <Cfif get_letter_info.ar_email is ''><cfelse>Email: &nbsp; #get_letter_info.ar_email#<br></Cfif>
            </div></td>
        </tr>
    </table>
    <br />
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
    <tr>
    	<td>
        	<div align="justify">
                <p>
                #companyshort.companyname# would like to thank you for allowing #get_letter_info.firstname# #get_letter_info.lastName#
                to attend your school. <cfif client.companyid NEQ 14>#companyshort.companyshort_nocolor# has issued a #CLIENT.DSFormName# for #get_letter_info.firstname# and 
                #get_letter_info.firstname# is now in the process of securing a J1 visa. Upon arrival #get_letter_info.firstname# will have 
                received a visa from the US consulate.</cfif>
                </p>
    
                <p>
                We have asked the #get_letter_info.familylastname# family to help #get_letter_info.firstname# in enrolling and registering
                in your school.
                </p>
    
                <p>
                We wish to let you know that #get_letter_info.firstname# is being supervised by #get_letter_info.ar_firstname# 
                #get_letter_info.ar_lastname#, an #companyshort.companyshort_nocolor# Area Representative. 
                #companyshort.companyshort_nocolor# Area Representatives act as a counselor to assist the student, school and host family should there be any
                concerns during #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> stay in the US.
                </p>
                
                <p>
                Please feel free to contact #get_letter_info.ar_firstname# #get_letter_info.ar_lastname# anytime you feel it would be appropriate.
                In addition, the #companyshort.companyshort_nocolor# Student Services Department, at #companyshort.toll_free#, is available to your school,
                host family and student should there ever be a serious concern with the host family, student or area representative.
                </p>
    
				<!--- GRADUATE STUDENTS - COUNTRY 49 = COLOMBIA / COUNTRY 237 = VENEZUELA --->
                <cfif get_letter_info.grades EQ 12 OR (get_letter_info.grades EQ 11 AND (get_letter_info.countryresident EQ '49' OR get_letter_info.countryresident EQ '237'))>
                <p>
                We hope that #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
                help to increase global understanding and friendship in your school and community. We would like to note that #get_letter_info.firstname#
                will have completed secondary school in <cfif get_letter_info.sex EQ 'male'>his<cfelse>her</cfif> native country upon arrival. Please let us know if we can assist you at 
                any time during #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
                </p>
                <cfelse>
                <p>
                We hope that #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> school experience will 
                help to increase global understanding and friendship in your school and community. Please let us know if we can assist you at 
                any time during #get_letter_info.firstname#'<cfif #right(get_letter_info.firstname, 1)# is 's'><cfelse>s</cfif> enrollment in your school.
                </p>
                </cfif>
    
    
                <p>
                Very truly yours,<br><br>
                #companyshort.lettersig#<br>
                #companyshort.companyname#<br>
    			</p></div>
          	</td>
      	</tr>
    </table>
    <Cfif client.companyid NEQ 14>
    <!--- line --->
    <table width=650 align="center" border=0 bgcolor="FFFFFF">
    	<tr><td><hr width=90% align="center"></td></tr>
    </table>
    <table width=100%>
        <tr>
            <td align="center"><font color="##999999"><font size=-2>U.S. Department of State &middot; 2200 C St. NW &middot; Washington D.C. 20037 &middot; 866.283.9090 &middot; jvisas@state.gov</font></font></td>
        </tr>
    </table>
    </Cfif>
    </cfoutput>
    
</cfsavecontent>

      <cfset fileName="schoolWelcomeLetter_#qGetStudentInfo.studentID#_#DateFormat(NOW(),'mm-dd-yyyy')#-#TimeFormat(NOW(),'hh-mm')#">
         <cfoutput>
            <cfdocument format="pdf" filename="#fileName#.pdf" overwrite="yes" orientation="landscape" name="uploadFile">
            	#schoolLetter#
           	</cfdocument>
        </cfoutput>    
			<cfscript>
				//fullPath='#APPLICATION.PATH.onlineApp.virtualFolder#//#qGetStudentInfo.studentid#';
				fullPath=GetDirectoryFromPath(GetCurrentTemplatePath()) & fileName & '.pdf';
				APPLICATION.CFC.UDF.insertInternalFile(filePath=fullPath,fieldID=1,studentID=qGetStudentInfo.studentID,hostID=qGetStudentInfo.hostID);
			</cfscript>
            <cfquery name="insertFileDetails" datasource="#application.dsn#">
            insert into  virtualFolder (fk_categoryID, 
                    fk_documentType, 
                    fileDescription,
                    fileName, 
                    filePath, 
                    fk_studentID,
                    fk_hostid,
                    dateAdded,
                    generatedHow,
                    uploadedBy)
             values(2,
                    24,
                    'School Welcome Letter',
                    '#fileName#.pdf', 
                    'uploadedfiles/virtualFolder/#qGetStudentInfo.studentID#/#qGetStudentInfo.hostID#/',
                    #qGetStudentInfo.studentID#,
                    #qGetHostFamily.hostID#,
                    #now()#,
                    'auto',
                    #client.userid#)
            </cfquery> 
  <!----Student ID Card--->
  <!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Form Variables --->
    <cfparam name="URL.studentID" default="">
    <cfparam name="URL.uniqueID" default="">
    <cfparam name="FORM.date1" default="">
    <cfparam name="FORM.date2" default="">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.insurance_typeID" default="0">

    <cfscript>
		// Set variables 
		col = 0;
		pageBreak = 0;
	</cfscript>

	<!--- Get names, addresses from our database --->
    <cfquery name="qGetStudents" datasource="#application.dsn#"> 
        SELECT 	
        	s.studentid, 
            s.familylastname, 
            s.firstname, 
            s.dateapplication, 
            s.programid, 
            s.regionassigned, 
            s.regionalguarantee,
            s.active, 
            s.ds2019_no, 
            s.hostid AS s_hostid, 
            s.regionassigned, 
            s.arearepid,
            p.programname, 
            p.programid,
            p.seasonID,
            u.businessname, 
            u.insurance_typeID,
            c.companyname, 
            c.address AS c_address, 
            c.city AS c_city, 
            c.state AS c_state, 
            c.zip AS c_zip, 
            c.toll_free as c_tollfree, 
            c.phone as c_phone, 
            c.iap_auth, 
            c.emergencyPhone, 
            c.companyid, 
            c.url_ref,
            r.regionid, 
            r.regionname,
            h.familylastname AS h_lastname, 
            h.address AS h_address, 
            h.address2 AS h_address2, 
            h.city AS h_city,
            h.mother_cell, 
            h.father_cell,
            h.state AS h_state, 
            h.zip AS h_zip, 
            h.phone AS h_phone				
        FROM
        	smg_students s 
        INNER JOIN 
        	smg_users u ON s.intrep = u.userid
        INNER JOIN 
        	smg_programs p ON s.programid = p.programid
        INNER JOIN
        	smg_companies c ON s.companyid = c.companyid
        LEFT OUTER JOIN 
        	smg_regions r ON s.regionassigned = r.regionid
        LEFT OUTER JOIN
        	smg_hosts h ON s.hostid = h.hostid			
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            
      
			AND 
            	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.studentID)#">
     
       
        ORDER BY
            u.businessname, 
            s.firstname,
            s.familyLastName,
            s.studentID   
    </cfquery>
    <cfquery name="qGetProgram" datasource="#APPLICATION.DSN#">
        select programname, startdate, enddate
        from smg_programs 
        left join smg_students on smg_programs.programid = smg_students.programid 
        where smg_students.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.studentid#">
    </cfquery>
	
	<cfquery name="qGetRegion" datasource="#APPLICATION.DSN#">
     SELECT
					r.regionID,
                    r.active,
                    r.regionName,
                    r.subOfRegion,
                    r.regionFacilitator,
                    r.company,
                    r.masterRegion,
                    r.regional_guarantee,
                    c.team_id,
                    c.companyName,
                    c.companyShort,
                    CAST( CONCAT(u.firstName, ' ', u.lastName, ' (##', u.userID, ')' ) AS CHAR) AS facilitatorName
                FROM 
                    smg_regions r
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = r.company
                LEFT OUTER JOIN
                	smg_users u ON u.userID = r.regionFacilitator
                WHERE
                	1 = 1
				
         
                	AND
                    	r.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.regionassigned#">
             
                
	</cfquery>
	<cfquery name="qGetRegionGuaranteed" datasource="#APPLICATION.DSN#">
         SELECT
					r.regionID,
                    r.active,
                    r.regionName,
                    r.subOfRegion,
                    r.regionFacilitator,
                    r.company,
                    r.masterRegion,
                    r.regional_guarantee,
                    c.team_id,
                    c.companyName,
                    c.companyShort,
                    CAST( CONCAT(u.firstName, ' ', u.lastName, ' (##', u.userID, ')' ) AS CHAR) AS facilitatorName
                FROM 
                    smg_regions r
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = r.company
                LEFT OUTER JOIN
                	smg_users u ON u.userID = r.regionFacilitator
                WHERE 
                	r.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.regionalguarantee#">
    </cfquery>
	
</cfsilent>

<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.4in 0.4in 0.46in;
		/* margin:'0.3in' '0.3in' '0.46in' '0.3in'; */

	}
	
	div.Section1 {		
		page:Section1;
		font-family:"Arial";
	}

	div.fullCol {
		width:100%;
		clear:both;
		padding:0px;
		display:block;
	}

	div.leftCol {
		width:45%;
		float:left;
		padding:0px;
	}
	
	div.rightCol {
		width:55%;
		float:right;
		padding:0px;
	}

	td.label {
		width:255.0pt; /* width:254.0pt; */
		height:142.0pt;
	}
	
	p {
		margin:0px, 5.3pt, 0px, 5.3pt; 
		mso-pagination:widow-orphan;
		font-size:10.0pt;
		font-family:"Arial";
	}
	h1 {padding:0;}
	.style1 {font-size: 6pt;}  /* company address */
	.style2 {font-size: 7pt;}  /* host + rep info */
	.style3 {font-size: 8pt;}  /* student's name */
	.style4 {font-size: 10pt; font-weight:bold; padding-top:5px; } /* company name */
	.style5 {font-size: 5pt;} 
</style>
							
<!--- Height = 5cm = 142 pixels = 1.96in / Width = 9cm = 255 pixels = 3.54in --->
					
<!---
	The table consists has two columns, two labels.
	To identify where to place each, we need to maintain a column counter.	
--->

<cfsavecontent variable="IDCard">


<div class="Section1">
	
    <cfloop query="qGetStudents">
    	
		<!----Student Picture ---->
		<cfdirectory directory="#APPLICATION.PATH.onlineApp.picture#" name="studentPicture" filter="#studentID#.*">
       
		<!--- get regional manager --->
        <cfquery name="qRegionalManager" datasource="#application.dsn#">
            SELECT 	
                firstname, 
                lastname, 
                businessphone, 
                phone,
                cell_phone
            FROM 	
                smg_users
            INNER JOIN 
                user_access_rights uar ON uar.userid = smg_users.userid
            WHERE	
                uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
            AND 
                uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.regionassigned#">
        </cfquery>

        <!--- get rep who will follow the student --->
        <cfquery name="qLocalContact" datasource="#application.dsn#">
            SELECT 	
                firstname, 
                lastname, 
                businessphone,
                phone,
                cell_phone
            FROM 	
                smg_users
            WHERE	
                userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudents.arearepid)#">
        </cfquery>			

        <cfquery name="qGetInsuranceInfo" datasource="#application.dsn#">
            SELECT 
                it.type, 
                ic.policycode
            FROM 
                smg_insurance_type it
            INNER JOIN
                smg_insurance_codes ic ON ic.insuTypeID =  it.insuTypeID
                    AND	
                        ic.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudents.seasonID)#"> 
                
					<!--- Combine ISE Companies --->  
                    <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISE, CLIENT.companyID)>
                        AND
                            ic.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    <cfelse>
                        AND
                            ic.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudents.companyID)#">
                    </cfif>
                    
					<!--- ESI - Elite Only --->
                    <cfif CLIENT.companyID EQ 14>
                        AND
                            ic.insuTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="11">                           
                    <cfelse>
                        AND
                            ic.insuTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudents.insurance_typeID)#">                           
                    </cfif>
        </cfquery>
			  <style>      
                   @charset "utf-8";
            /* CSS Document */
            
            .profileTable {
                width:800px;
                border-left: 1px solid #999;
                border-right: 1px solid #999;;
                border-bottom: 1px solid #999;;
                border-top: 1px solid #999;;
                /**padding: 6px 8px 6px 8px;**/
                margin-bottom:10px;
                background-color:#FFF;
                font-family:Arial, Helvetica, sans-serif;
                font-size:14px;
            }
            .inner_profileTable {
                
                background-color:#FFF;
                font-family:Arial, Helvetica, sans-serif;
                font-size:14px;
            }
            .profileTable2 {
                width:800px;
                border-left: 0px solid #999;
                border-right: 0px solid #999;;
                border-bottom: 0px solid #999;;
                border-top: 0px solid #999;;
                /***padding: 6px 8px 6px 8px;***/
                margin-bottom:10px;
                background-color:#FFF;
                font-family:Arial, Helvetica, sans-serif;
                font-size:14px;
            }
            .bottom_center{
                vertical-align:bottom;
                text-align:center;
            }
            .bottom_right{
                vertical-align:bottom;
                text-align:right;
            }
            .titleLeft {
                width:200px;
                vertical-align:top;
            }
            
            .titleCenter {
                vertical-align:top;
                text-align:center;
            }
            
            .titleRight {
                vertical-align:top;
            }
            
            .profileTitleSection{
                width:100%;
                margin-bottom:5px;
                text-transform: uppercase;
                letter-spacing: 5px;	
                background: #0854a1;
                text-align:center;
                color:#FFF;
                font-size:12px;
                font-weight:bold;
                display:block;
                padding: 2px 0px 2px 0px;
            }
            
            .title {
                color:#999;
                padding:0px 3px 3px 0px;
            }
            
            .comments {
                text-align:justify;
                display:block;
            }
            
            div#test {
                background-image:  url(../../pics/activateNot.png);
                background-repeat: no-repeat;
                height: 500px;
                width: 380px;
            
            }
            
            a.googlemaps{color: #0854a0;
                text-decoration:none;
                background:url('https://ise.exitsapplication.com/nsmg/pics/Google-Maps-icon.png') center right no-repeat;
                padding-right: 16px;
            }
            a.wiki{color: #0854a0;
                text-decoration:none;
                background:url('https://ise.exitsapplication.com/nsmg/pics/Wikipedia-globe-icon.png') center right no-repeat;
                padding-right: 16px;
            }
            a.airport{color: #0854a0;
                text-decoration:none;
                background:url('https://ise.exitsapplication.com/nsmg/pics/Airport-icon.png') center right no-repeat;
                padding-right: 16px;
            }
            a{color: #0454a0;
                text-decoration:none;
            }
            
            .alert{
                width:800;
                height:25px;
                border:#666;
                background-color:#FF9797;
                text-align:center;
                -moz-border-radius: 15px;
                border-radius: 15px;
                vertical-align:center;
                
            }
            </style>
     <cfoutput>   
        <!--- Header --->
        <table align="center" class="profileTable" width="750" border="0">
            <tr>
                <td class="titleRight">
               
                    <img src="https://ise.exitsapplication.com/nsmg/pics/logos/#client.companyid#.gif" align="right"  width="110px"> <!--- Image is 144x144 --->
               
                	
                </td>
                <td class="titleCenter" valign="center">
                    <h1>#companyname#</h1>      
                    
                    <table width=100% border=0>
                        <Tr>
                            <td width=100></td>
                            <td valign="top">
                                #c_address#<br />
                                #c_city# #c_state#<br />
                                #c_zip#<Br />
                            </td>
                            <Td valign="top">
                                Local Number: #c_phone#<br />
                                Toll Free: #c_tollfree#<br />          
                                Emergency Phone:  #emergencyPhone#</h3>
                            </Td>
                        </Tr>
                    </table>
                    
                </td>
            </tr>	
        </table>
        
        <!--- Student Information --->
        <table  align="center" class="profileTable" width="750" border="0">
            <tr>
                <td valign="top" width="140px" align="Center">
                    <div align="center">
                    <!-------->
						<cfif studentPicture.recordcount>
                            <img src="https://ise.exitsapplication.com/nsmg/uploadedfiles/web-students/#studentPicture.name#" height="155" align="Center"/>
                        <cfelse>
                            <img src="https://ise.exitsapplication.com/nsmg/pics/no_stupicture.jpg" width="135">
                        </cfif>
						
                        <br />
                    </div>
                </td>
                <td valign="top">
                    <span class="profileTitleSection">STUDENT IDENTIFICATION</span>
                    
                    <table cellpadding="2" cellspacing="2" border="0" width=100%>
                        <tr>
                            <td valign="top" width="330">
                                <table cellpadding="2" cellspacing="2" border="0" width=100%>
                                    <tr>
                                        <td><span class="title">Name</span></td>
                                        <td><b>#Firstname# #familylastname#</b></td>
                                    </tr>	
                                    <tr>
                                        <td><span class="title">ID</span></td>
                                        <td>###studentid#</td>
                                    </tr>
                                   <cfif CLIENT.companyid neq 14>
                                    <tr>
                                        <td><span class="title">#CLIENT.DSFormName#</span></td>
                                        <td>#ds2019_no#</td>
                                    </tr>
                                    </cfif>
                                    <tr>
                                        <td><span class="title">Program</span></td>
                                        <td>#qGetProgram.programname#</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Region</span></td>
                                        <td>#qGetRegion.regionname# #qGetRegionGuaranteed.regionname# </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" width="330">
        
                                <table cellpadding="2" cellspacing="2" border="0" width=100%>
                                    <tr>
                                        <td><span class="title">Hosts</span></td>
                                        <td>The #h_lastname# Family</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Address</span></td>
                                        <td>#h_address# #h_address2#</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">City State, Zip</span></td>
                                        <td>#h_city# #h_state#, &nbsp; #h_zip# </td>
                                    </tr>
                                    <tr>
                                        <td valign="top"><span class="title">Phone</span></td>
                                        <td>#h_phone#</td>
                                    </tr>
                                    <tr>
                                        <td><em><span class="title"><font size=-1>Alt. Phones</font></span></em></td>
                                        <td>
                                        	<em><font size=-1>
												<cfif mother_cell is '' and father_cell is ''>
                                                    No alt. phone numbers on file.
                                                <cfelse>
                                                    #mother_cell#
                                                    <cfif mother_cell is not ''>;</cfif>
                                                    #father_cell#
                                                </cfif>
                                            </font></em>
                                        </td>
                                    </tr>
                                </table>
                           
                            </td>
                        </tr>                        
                    </table>
        
                </td>
            </tr>                
        </table>
        
        <table align="center" class="profileTable" width=750>
            <tr>
                <td valign="top" colspan=10 >
        
                    <table cellpadding="2" cellspacing="2" border="0" width=100%>
                        <tr>
                            <td valign="top" width="50%">
                                <span class="profileTitleSection">REGIONAL CONTACT</span>
                                
                                <table cellpadding="2" cellspacing="2" border="0">
                                    <tr>
                                        <td><span class="title">Regional Contact</span></td>
                                        <td>#qRegionalManager.firstname# #qRegionalManager.lastname#&nbsp;</td>
	                                </tr>	
	                                <tr>
                                        <td><span class="title">Primary Phone</span></td>
                                        <td>
                                            <cfif LEN(qRegionalManager.businessphone)>
                                                #qLocalContact.firstname##qRegionalManager.businessphone#
                                            <cfelse>
                                                #qRegionalManager.phone#
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Cell Phone</span></td>
                                        <td> #qRegionalManager.cell_phone#</td>
                                    </tr>
                                </table>
        
                            </td>
        					<td valign="top" width="50%">
                                <span class="profileTitleSection">LOCAL CONTACT</span>
        
                                <table cellpadding="2" cellspacing="2" border="0">
                                    <tr>
                                        <td><span class="title">Local Contact</span></td>
                                        <td>
											<cfif qLocalContact.recordCount>
                                                #qLocalContact.firstname# #qLocalContact.lastname#
                                            <cfelse>
                                                <span class="title"><em>Information not available</em></span>
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Primary Phone</span></td>
                                        <td>
											<cfif LEN(qLocalContact.businessphone)>
                                                #qLocalContact.businessphone#
                                            <cfelse>
                                                #qLocalContact.phone#
                                            </cfif>
                                        </td>
                                    </tr>     
                                    <tr>
                                        <td><span class="title">Cell Phone</span></td>
                                        <td>#qLocalContact.cell_phone#</td>
                                    </tr>       
                                </table>
        
                            </td>
                        </tr> 
                        <Tr>
                            <td valign="top" width="100%" colspan="2">
                            	<span class="profileTitleSection">INSURANCE</span>
                                
                                <table cellpadding="2" cellspacing="2" border="0" width="100%">
                                    <tr>
                                        <td>#qGetInsuranceInfo.type#</td>
                                        <td>&middot;</td>
                                        <td>Policy: #qGetInsuranceInfo.policycode#</td>
                                        <td>&middot;</td>
                                        <td>1-800-251-1712</td>
                                        <td>&middot;</td>
                                        <td>www.esecutive.com/MyInsurance</td>
                                    </tr>
                                </table>
            
                            </td>
                        </Tr> 
                        <cfif CLIENT.companyid NEQ 14>    
                        <Tr>
                            <td valign="top" width="100%" colspan=2>
                                <span class="profileTitleSection">DEPARTMENT OF STATE</span>
                            
                                <table cellpadding="2" cellspacing="2" border="0">
                                    <tr>
                                        <td >U.S. Department of State</td>
                                        <td>&middot;</td>
                                        <td>2200 C St. NW</td>
                                        <td>&middot;</td>
                                        <td>Washington, D.C. 20037</td>
                                        <td>&middot;</td>
                                        <td>
                                        	1-866-283-9090<br />
                                        	1-202-203-5096
                                        </td>
                                        <td>&middot;</td>
                                        <td>jvisas@state.gov</td>
                                    </tr>
                                </table>
            
                            </td>
                        </Tr>                       
                        </cfif>
                	</table> 
                    
				</td>
			</tr>
		</table>            	                                    
        
        <br />
      </cfoutput>               
    </cfloop>
   
</div>


  
</cfsavecontent> 
       <cfset fileName="studentID Card_#qGetStudentInfo.studentID#_#DateFormat(NOW(),'mm-dd-yyyy')#-#TimeFormat(NOW(),'hh-mm')#">
         <cfoutput>
            <cfdocument format="pdf" filename="#fileName#.pdf" overwrite="yes" orientation="landscape" name="uploadFile">
            	#IDCard#
           	</cfdocument>
        </cfoutput>    
			<cfscript>
				//fullPath='#APPLICATION.PATH.onlineApp.virtualFolder#//#qGetStudentInfo.studentid#';
				fullPath=GetDirectoryFromPath(GetCurrentTemplatePath()) & fileName & '.pdf';
				APPLICATION.CFC.UDF.insertInternalFile(filePath=fullPath,fieldID=1,studentID=qGetStudentInfo.studentID,hostID=qGetStudentInfo.hostID);
			</cfscript>
            <cfquery name="insertFileDetails" datasource="#application.dsn#">
            insert into  virtualFolder (fk_categoryID, 
                    fk_documentType, 
                    fileDescription,
                    fileName, 
                    filePath, 
                    fk_studentID,
                    fk_hostid,
                    dateAdded,
                    generatedHow,
                    uploadedBy)
             values(2,
                    25,
                    'Student ID Card',
                    '#fileName#.pdf', 
                    'uploadedfiles/virtualFolder/#qGetStudentInfo.studentID#/#qGetStudentInfo.hostID#/',
                    #qGetStudentInfo.studentID#,
                    #qGetHostFamily.hostID#,
                    #now()#,
                    'auto',
                    #client.userid#)
            </cfquery> 
     
            
 	</cffunction>
    
    <!--- Function to check new host family data against host family data already stored --->
    <cffunction name="checkHostFamilyExists" access="remote" returnFormat="json" output="false">
        <cfargument name="address" type="string" hint="address is required">
        <cfargument name="zip" type="string" hint="zip is required">
        <cfargument name="email" type="string" default="" hint="email is not required">
        <cfargument name="fatherFirstName" type="string" default="" hint="fatherFirstName is not required">
        <cfargument name="fatherLastName" type="string" default="" hint="fatherLastName is not required">
        <cfargument name="motherFirstName" type="string" default="" hint="motherFirstName is not required">
        <cfargument name="motherLastName" type="string" default="" hint="motherFirstName is not required">
        <cfargument name="fatherSSN" type="string" default="" hint="fatherSSN is not required">
        <cfargument name="motherSSN" type="string" default="" hint="motherSSN is not required">
        
        <cfscript>
			// Return structure
			stResult = structNew();
			// Returns 0 if no family is found, 1 if the family definately exists, and 2 if the family might exist
			stResult.status = 0;
			// 0 if they do not exist, 1 if they do
			stResult.address = 0;
			stResult.zip = 0;
			stResult.email = 0;
			stResult.fatherFirstName = 0;
			stResult.fatherLastName = 0;
			stResult.motherFirstName = 0;
			stResult.motherLastName = 0;
			stResult.fatherSSN = 0;
			stResult.motherSSN = 0;
			
			stResult.hostID = 0;
			stResult.familyLastName = "";
			
			// Each SSN is checked against both the fatherSSN and the motherSSN and must be encrypted
			vSSNfather = "";
			vSSNmother = "";
			if (LEN(ARGUMENTS.fatherSSN)) {
				vSSNfather = encryptVariable(ARGUMENTS.fatherSSN);	
			}
			if (LEN(ARGUMENTS.motherSSN)) {
				vSSNmother = encryptVariable(ARGUMENTS.motherSSN);	
			}
		</cfscript>
        
        <cfquery name="qGetResultByAddress" datasource="#APPLICATION.DSN#">
        	SELECT hostID, familyLastName
            FROM smg_hosts
            WHERE address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.address#">
            AND zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.zip#">
      	</cfquery>
        <cfquery name="qGetResultByEmail" datasource="#APPLICATION.DSN#">
            SELECT hostID, familyLastName
            FROM smg_hosts
            WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.email#">
        </cfquery>
        <cfquery name="qGetResultByFather" datasource="#APPLICATION.DSN#">
            SELECT hostID, familyLastName
            FROM smg_hosts
            WHERE fatherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fatherFirstName#">
            AND fatherLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.fatherLastName#">
        </cfquery>
        <cfquery name="qGetResultByMother" datasource="#APPLICATION.DSN#">
            SELECT hostID, familyLastName
            FROM smg_hosts
            WHERE motherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.motherFirstName#">
            AND motherLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.motherLastName#">
        </cfquery>
        <cfquery name="qGetResultByFatherSSN" datasource="#APPLICATION.DSN#">
            SELECT hostID, familyLastName
            FROM smg_hosts
            WHERE fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vSSNFather#">
            OR motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vSSNFather#">
        </cfquery>
        <cfquery name="qGetResultByMotherSSN" datasource="#APPLICATION.DSN#">
            SELECT hostID, familyLastName
            FROM smg_hosts
            WHERE fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vSSNMother#">
            OR motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vSSNMother#">
        </cfquery>
        
        <cfscript>
			if (VAL(qGetResultByAddress.recordCount)) {
				if (stResult.status NEQ 1) {
					stResult.status = 2;
				}
				stResult.address = 1;
				stResult.zip = 1;
				stResult.hostID = qGetResultByAddress.hostID;
				stResult.familyLastName = qGetResultByAddress.familyLastName;
			}
			if (VAL(qGetResultByFather.recordCount) AND LEN(ARGUMENTS.fatherFirstName)) {
				if (stResult.status NEQ 1) {
					stResult.status = 2;
				}
				stResult.fatherFirstName = 1;
				stResult.fatherLastName = 1;
				stResult.hostID = qGetResultByFather.hostID;
				stResult.familyLastName = qGetResultByFather.familyLastName;
			}
			if (VAL(qGetResultByMother.recordCount) AND LEN(ARGUMENTS.motherFirstName)) {
				if (stResult.status NEQ 1) {
					stResult.status = 2;
				}
				stResult.motherFirstName = 1;
				stResult.motherLastName = 1;
				stResult.hostID = qGetResultByMother.hostID;
				stResult.familyLastName = qGetResultByMother.familyLastName;
			}
			if (VAL(qGetResultByEmail.recordCount) AND LEN(ARGUMENTS.email)) {
				stResult.status = 1;
				stResult.email = 1;
				stResult.hostID = qGetResultByEmail.hostID;
				stResult.familyLastName = qGetResultByEmail.familyLastName;
			}
			if (VAL(qGetResultByFatherSSN.recordCount) AND LEN(ARGUMENTS.fatherSSN)) {
				stResult.status = 1;
				stResult.fatherSSN = 1;
				stResult.hostID = qGetResultByFatherSSN.hostID;
				stResult.familyLastName = qGetResultByFatherSSN.familyLastName;
			}
			if (VAL(qGetResultByMotherSSN.recordCount) AND LEN(ARGUMENTS.motherSSN)) {
				stResult.status = 1;
				stResult.motherSSN = 1;
				stResult.hostID = qGetResultByMotherSSN.hostID;
				stResult.familyLastName = qGetResultByMotherSSN.familyLastName;
			}
			
			return stResult;
		</cfscript>
        
	</cffunction>
    
    <!--- Function to add business days to a specified date --->
    <cffunction name="addBusinessDays" access="public" returntype="date" output="no" hint="Returns a date the specified number of business days after a specified date">
        <cfargument name="inputDate" type="date" required="yes">
        <cfargument name="numDays" type="numeric" required="yes">
        
        <cfscript>
            vNewDate = inputDate;
            x = numDays;
            while(x GT 0) {
                vNewDate = DateAdd('d',1,vNewDate);
                vBusinessDay = 1;
                
                // Don't count Saturday, Sunday, or holidays
                if (
                    ListFind('1,7',DayOfWeek(vNewDate)) // Saturday and Sunday
                    OR (MONTH(vNewDate) EQ 1 AND DAY(vNewDate) EQ 1) // New Years Day
                    OR (MONTH(vNewDate) EQ 1 AND DayOfWeek(vNewDate) EQ 2 AND DAY(vNewDate) GTE 15) // MLK Day
                    OR (MONTH(vNewDate) EQ 2 AND DayOfWeek(vNewDate) EQ 2 AND DAY(vNewDate) GTE 15) // President's Day
                    OR (MONTH(vNewDate) EQ 5 AND DayOfWeek(vNewDate) EQ 2 AND DAY(vNewDate) GTE 25) // Memorial Day
                    OR (MONTH(vNewDate) EQ 7 AND DAY(vNewDate) EQ 4) // Independence Day
                    OR (MONTH(vNewDate) EQ 9 AND DayOfWeek(vNewDate) EQ 2 AND DAY(vNewDate) LTE 7) // Labor Day
                    OR (MONTH(vNewDate) EQ 10 AND DayOfWeek(vNewDate) EQ 2 AND DAY(vNewDate) GTE 8) // Columbus Day
                    OR (MONTH(vNewDate) EQ 11 AND DAY(vNewDate) EQ 11) // Veteren's Day
                    OR (MONTH(vNewDate) EQ 11 AND DayOfWeek(vNewDate) EQ 5 AND DAY(vNewDate) GTE 22) // Thanksgiving
                    OR (MONTH(vNewDate) EQ 12 AND ListFind('24,25,31',DAY(vNewDate))) // Christmas Eve, Christmas, and New Years Eve
                    ) {
                    vBusinessDay = 0;	
                }
                
                // Count down the day if it is a business Day
                if (vBusinessDay) {
                    x--;
                }
            }
            return vNewDate;
        </cfscript>
        
    </cffunction>
    
</cfcomponent>