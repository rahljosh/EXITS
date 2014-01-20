<!--- ------------------------------------------------------------------------- ----
	
	File:		udf.cfc
	Author:		Marcus Melo
	Date:		June, 14 2010
	Desc:		This holds the User Defined Functions

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="udf"
	output="false" 
	hint="A collection of user defined functions">


	<!--- Return the initialized UDF object --->
	<cffunction name="Init" access="public" returntype="udf" output="No" hint="Returns the initialized UDF object">

		<cfscript>
			// Return this initialized instance
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
				FindNoCase("host.local", CGI.http_host) OR
				FindNoCase("developer", server.ColdFusion.ProductLevel)
			){
				return(true);
			} else {
				return(false);
			}
		</cfscript>
	</cffunction>


	<cffunction name="buildLeftMenu" access="public" returntype="struct" output="No" hint="Build the Left Menu Items based on current status and user logged in">
        <cfargument name="currentSection" default="login" hint="">

		<cfscript>
			// Get Host Family Information
			qGetHostFamilyInfo = APPLICATION.CFC.HOST.getCompleteHostInfo(hostID=APPLICATION.CFC.SESSION.getHostSession().ID);

			// Get UserType Access Level
			vCurrentUserType = getUserAccessLevel(userID=APPLICATION.CFC.SESSION.getHostSession().userID, regionID=qGetHostFamilyInfo.regionID);

			// This returns the approval fields for the logged in user
			stCurrentUserFieldSet = getApprovalFieldNames(usertype=vCurrentUserType);

			// Get One Level Up User
			stUserOneLevelUpInfo = getUserOneLevelUpInfo(currentUserType=vCurrentUserType, regionalAdvisorID=qGetHostFamilyInfo.regionalAdvisorID);
		
			// This returns the fields that need to be checked
			stOneLevelUpFieldSet = getApprovalFieldNames(userType=stUserOneLevelUpInfo.userType);
			
			// Create MENU structure
			stBuildMenu = StructNew();
			
			// Set the ID Section
			stBuildMenu.IDSection = arrayNew(1);
			
			// Set Menu Link Section
			stBuildMenu.linkSection = arrayNew(1);
			
			// Set Menu Display Section
			stBuildMenu.displaySection = arrayNew(1);
			
			// Set Menu Color Section
			stBuildMenu.colorSection = arrayNew(1);
			
			// Store blocked sections here | hide submit button
			stBuildMenu.blockedSections = "";

			// Build Menu with only 1 item - Specific Section 
			if ( APPLICATION.CFC.SESSION.getHostSession().isExitsLogin AND NOT ListFind("login,overview", ARGUMENTS.currentSection) ) {
				// Get Specific Section Approval History
				qGetMenuHistory = APPLICATION.CFC.HOST.getMenuHistory(section=ARGUMENTS.currentSection);
			} else {
			  // Get Sections Approval History
				qGetMenuHistory = APPLICATION.CFC.HOST.getMenuHistory();
			}

			// These items are always available - they should never be grayed out
			vAllowedItems = "overview,checklist,logout";

			// Populate Menu
			for ( i=1; i LTE qGetMenuHistory.recordCount; i++ ) {
				
				// Link Section
				stBuildMenu.linkSection[i] = qGetMenuHistory.section[i];
				
				// ID Section
				stBuildMenu.IDSection[i] = qGetMenuHistory.ID[i];
				
				/*** 
					Remove link for approved sections (approved by current usertype or denied by one level up user) 
					PS: If and elseif are doing the same thing, they were kept separate for better reading
				***/				
				
				// HF logged In - If application submitted = Grey Out Links
				if ( NOT APPLICATION.CFC.SESSION.getHostSession().isExitsLogin AND NOT ListFindNoCase(vAllowedItems,qGetMenuHistory.section[i]) AND APPLICATION.CFC.SESSION.getHostSession().applicationStatus LTE 7 ) {
					
					// Grey Out Section - Remove Link
					stBuildMenu.displaySection[i] = '<span class="greyLinks">#qGetMenuHistory.description[i]#</span>';
					stBuildMenu.blockedSections = ListAppend(stBuildMenu.blockedSections, qGetMenuHistory.section[i]);
					
				// EXITS User Logged In - If section approved = Grey Out Links
				} else if ( APPLICATION.CFC.SESSION.getHostSession().isExitsLogin AND NOT ListFindNoCase(vAllowedItems,qGetMenuHistory.section[i]) AND NOT listFind("1,2,3,4", vCurrentUserType) AND ( qGetMenuHistory[stCurrentUserFieldSet.statusFieldName][i] EQ 'approved' OR qGetMenuHistory[stOneLevelUpFieldSet.statusFieldName][i] EQ 'approved' ) ) {
					
					// Grey Out Section - Remove Link
					stBuildMenu.displaySection[i] = '<span class="greyLinks">#qGetMenuHistory.description[i]#</span>';
					stBuildMenu.blockedSections = ListAppend(stBuildMenu.blockedSections, qGetMenuHistory.section[i]);
				
				} else {
					
					// Display Section
					stBuildMenu.displaySection[i] = '<a href="index.cfm?section=#qGetMenuHistory.section[i]#" class="whiteLinks">#qGetMenuHistory.description[i]#</a>';
					
				}

				// Color Section
				stBuildMenu.colorSection[i] = qGetMenuHistory.appMenuColor[i];
				
			}
			
        	return stBuildMenu;
        </cfscript>
        
	</cffunction>


	<cffunction name="getUserAccessLevel" access="public" returntype="numeric" output="false" hint="Returns user access level">
        <cfargument name="userID" default="0" hint="User ID">
        <cfargument name="regionID" default="0" hint="Region ID">

		<!--- Check if is an office user | Office user does not have region specific --->
        <cfquery 
			name="qCheckForOfficeAccessLevel" 
			datasource="#APPLICATION.DSN.Source#">
				SELECT
                	userType
                FROM
                	user_access_rights
                WHERE
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
               	AND
                	userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> )
		        <!--- ISE --->
				<cfif SESSION.COMPANY.ID EQ 1>
                	AND
                    	companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,12" list="yes"> )
                <!--- CASE --->
				<cfelse>
                	AND
                    	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAl(SESSION.COMPANY.ID)#">
                </cfif>            
        </cfquery>
        
        <cfif qCheckForOfficeAccessLevel.recordCount>
        
			<cfscript>
                return VAL(qCheckForOfficeAccessLevel.userType);       	
           	</cfscript>
        
        <cfelse>
        	
            <!--- Field User --->
            <cfquery 
                name="qGetAccessLevel" 
                datasource="#APPLICATION.DSN.Source#">
                    SELECT
                        userType
                    FROM
                        user_access_rights
                    WHERE
                        userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.userID)#">
                   AND
                        regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
            </cfquery>

			<cfscript>
                return VAL(qGetAccessLevel.userType);       	
           	</cfscript>

		</cfif>
       
	</cffunction>


	<cffunction name="getApprovalFieldNames" access="public" returntype="struct" output="false" hint="Returns the fields used in the approval process based on the logged in user">
        <cfargument name="userType" default="#CLIENT.userType#" hint="userType">
        
        <cfscript>
			var stFieldSet = StructNew();
			
            // Set Field Names
            switch ( ARGUMENTS.usertype ) {
                
                // Area Representative
                case 7: 
                    stFieldSet.statusFieldName = "areaRepStatus";
                    stFieldSet.dateFieldName = "areaRepDateStatus";
                    stFieldSet.notesFieldName = "areaRepNotes";
                break;
                
                // Regional Advisor
                case 6: 
                    stFieldSet.statusFieldName = "regionalAdvisorStatus";
                    stFieldSet.dateFieldName = "regionalAdvisorDateStatus";
                    stFieldSet.notesFieldName = "regionalAdvisorNotes";
                break;
                
                // Regional Manager
                case 5:
                    stFieldSet.statusFieldName = "regionalManagerStatus";
                    stFieldSet.dateFieldName = "regionalManagerDateStatus";
                    stFieldSet.notesFieldName = "regionalManagerNotes";
				break;
                
                // Office Users
                case 4: 
                case 3:
                case 2:
                case 1: 
                    stFieldSet.statusFieldName = "facilitatorStatus";
                    stFieldSet.dateFieldName = "facilitatorDateStatus";
                    stFieldSet.notesFieldName = "facilitatorNotes";
                break;
                
                // User Not Found - Default to lowest level
                default: 
                    stFieldSet.statusFieldName = "areaRepStatus";
                    stFieldSet.dateFieldName = "areaRepDateStatus";
                    stFieldSet.notesFieldName = "areaRepNotes";
				break;
            }	 
            
            return stFieldSet;       
       </cfscript>
       
	</cffunction>


	<cffunction name="getUserOneLevelUpInfo" access="public" returntype="struct" output="false" hint="Returns the next level up user, eg. RA next level is RM">
    	<cfargument name="currentUserType" type="string" default="">
    	<cfargument name="regionalAdvisorID" type="string" default="">
        
        <cfscript>
			// new structure
			var stFieldSet = StructNew();
			
            // Set Field Names
            switch ( ARGUMENTS.currentUserType ) {
                
                // Area Representative
                case 7: 
					
					// Next Level Regional Advisor
					if ( VAL(ARGUMENTS.regionalAdvisorID) ) {
						stFieldSet.userType = 6;
						stFieldSet.description = "Regional Advisor";
					// Next Level Regional Manager
					} else  {
						stFieldSet.userType = 5;
						stFieldSet.description = "Regional Manager";
					}

				break;
				
				// Regional Advisor
				case 6:
					// Next Level Regional Manager
					stFieldSet.userType = 5;
					stFieldSet.description = "Regional Manager";
				break;

				// Regional Manager
				case 5:
				case 4:
				case 3:
				case 2:
				case 1:
					// Next Level Regional Manager
					stFieldSet.userType = 4;
					stFieldSet.description = "Headquarters";
				break;

                // User Not Found - Default to lowest level
                default: 
					// Default Values - Lowest user type
					stFieldSet.userType = 7;
					stFieldSet.description = "Area Representative";
				break;
	
			}
			
			return stFieldSet;
		</cfscript>
		
	</cffunction>    
        

	<!--- Check if Password is valid --->
	<cffunction name="IsValidPassword" access="public" returntype="struct" hint="Determines if the password is of valid format">
		<cfargument name="Password" type="string" required="Yes" />

        <cfscript>
			/* Password Policy
			   Must have at least 8 characters in length
			   Must have at least 1 number
			   Must have at least 1 uppercase letter
			   Must have at least 1 lower case letter */

			var stResults = StructNew();			
			stResults.isValidPassword = true;
			stResults.Errors = '';
			
			// Check Minimum Characters
			if ( LEN(ARGUMENTS.password) LT 8 ) {
				stResults.isValidPassword = false;
				stResults.Errors = stResults.Errors & 'The minimum password lenght is 8 characters. <br />';		
			}

			// Check Maximum Characters
			if ( LEN(ARGUMENTS.password) GT 20 ) {
				stResults.isValidPassword = false;
				stResults.Errors = stResults.Errors & 'The maximum password lenght is 20 characters. <br />';					
			}
			
			// Check for valid characters
			if (REFindNoCase("[^0-9a-zA-Z\~\!\@\$\$\%\^\&\*]{1,}", ARGUMENTS.Password)){
				stResults.isValidPassword = false;
				stResults.Errors = stResults.Errors & 'Password contains an invalid character. <br />';					
			}
			
			return stResults;
		</cfscript>
               
	</cffunction>
	

    <!--- Generates a Password --->
	<cffunction name="generatePassword" access="public" returntype="string" hint="Generates a password">
		
        <cfscript>
			/***  ***/
			/* Password Policy
			   Must have at least 8 characters in length
			   Must have at least 1 number
			   Must have at least 1 uppercase letter
			   Must have at least 1 lower case letter */
		
			// Set up available lower case values.
			//strLowerCaseAlpha = "abcdefghijklmnopqrstuvwxyz";
			strLowerCaseAlpha = "abcdefghjkmnpqrstuvwxyz";
			
			// Set up available upper case values
			strUpperCaseAlpha = UCase( strLowerCaseAlpha );
			
			// Set up available numbers
			//strNumbers = "0123456789";
			strNumbers = "23456789";
	
			// Set up additional valid password chars
			strOtherChars = "~!@##$%^&*";
			
			// Concatenate all the previous valid character sets
			strAllValidChars = ( strLowerCaseAlpha & strUpperCaseAlpha & strNumbers & strOtherChars );
			
			// Create an array to contain the password ( think of a string as an array of character).
			arrPassword = ArrayNew( 1 );
			
			// Select the random number from our number set.
			arrPassword[ 1 ] = Mid(strNumbers, RandRange( 1, Len( strNumbers ) ), 1);	

			// Select the random letter from our lower case set.
			arrPassword[ 2 ] = Mid( strLowerCaseAlpha, RandRange( 1, Len( strLowerCaseAlpha ) ), 1 );
			
			// Select the random letter from our upper case set.
			arrPassword[ 3 ] = Mid( strUpperCaseAlpha, RandRange( 1, Len( strUpperCaseAlpha ) ), 1 );	
			
			//Create rest of the password
			For (i=(ArrayLen( arrPassword ) + 1);i LTE 8; i=i+1) {
				arrPassword[ i ] = Mid( strAllValidChars, RandRange( 1, Len( strAllValidChars ) ), 1 );
			}
			
			// Java Collections utility class to shuffle this array into a "random" order
			CreateObject( "java", "java.util.Collections" ).Shuffle(arrPassword);
			
			// converting the array to a list and then just providing no delimiters (empty string delimiter).
			strPassword = ArrayToList(arrPassword, "" );
			
			return strPassword;
    	</cfscript>
    
    </cffunction>


	<!--- Set Page Navigation --->
	<cffunction name="setPageNavigation" access="public" returntype="string" output="false" hint="Sets the next page navigation after submitting a form, returns a string">
    	<cfargument name="section" default="overview" hint="section is required">

		<cfscript>
			// Set Default Navigation to the same page
			var vSetNavigation = "index.cfm?section=#ARGUMENTS.section#";

			// Section Locked - Set default page message
			if ( NOT ListFind("login,overview", ARGUMENTS.section) AND APPLICATION.CFC.SESSION.getHostSession().isSectionLocked ) {
	
				// Set Page Message
				SESSION.pageMessages.Add("Page has been updated");

			// If menu is not hidden we need to navigate to the next section
			} else {
				
				// Navigate to next section
				switch(ARGUMENTS.section) { 
					
					case "contactInfo":
						vSetNavigation = "index.cfm?section=familyMembers";
						break; 
						
					case "familyMembers":
						vSetNavigation = "index.cfm?section=cbcAuthorization";
						break; 
						
					case "cbcAuthorization":
						vSetNavigation = "index.cfm?section=personalDescription";
						break; 

					case "personalDescription":
						vSetNavigation = "index.cfm?section=hostingEnvironment";
						break; 

					case "hostingEnvironment":
						vSetNavigation = "index.cfm?section=religiousPreference";
						break; 

					case "religiousPreference":
						vSetNavigation = "index.cfm?section=familyRules";
						break; 

					case "familyRules":
						vSetNavigation = "index.cfm?section=familyAlbum";
						break; 

					case "familyAlbum":
						vSetNavigation = "index.cfm?section=schoolInfo";
						break; 

					case "schoolInfo":
						vSetNavigation = "index.cfm?section=communityProfile";
						break; 

					case "communityProfile":
						vSetNavigation = "index.cfm?section=confidentialData";
						break; 
						
					case "confidentialData":
						vSetNavigation = "index.cfm?section=references";
						break; 
						
					case "references":
						vSetNavigation = "index.cfm?section=checklist";
						break; 

				} 
				//end switch
				
			}	
			
			return vSetNavigation;
        </cfscript>
		   
	</cffunction>


	<cffunction name="allowFormSubmission" access="public" returntype="boolean" output="false" hint="Returns true/false if form submission is allowed">
    	<cfargument name="section" default="overview" hint="section is required">
		
        <cfscript>
			// Form submission is alllowed if section is not listed in the blockedSections variable
			if ( NOT ListFindNoCase(SESSION.LEFTMENU.blockedSections, ARGUMENTS.section) ) {
				return true;
			} else {
				return false;
			}		
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
    

    <!--- Display Social Security Number --->
	<cffunction name="displaySSN" access="public" returntype="string" output="false" hint="returns a masked SSN">
    	<cfargument name="varString" hint="String">
		<cfargument name="displayType" default="" hint="user / hostFamily">
        
		<cfscript>
			// Declare Variables		
			if ( LEN(ARGUMENTS.varString) ) {
			
				// Decrypt SSN
				var vDecryptedSSN = decryptVariable(ARGUMENTS.varString);
	
				// SET return masked SSN as default
				vReturnSSN = "XXX-XX-" & Right(vDecryptedSSN, 4);
			
			} else {
				
				// Return Blank
				vReturnSSN = '';
				
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
			var sbText = CreateObject("java", "java.lang.StringBuffer").init();
			
			// Make sure that it is a block element with bottom margin
			sbText.append("<div>");
			sbText.append(Replace(ARGUMENTS.Text, (Chr(13) & Chr(10)), "<br />", "ALL"));
			sbText.append("</div><br />	");
			
			// Return the text and convert to string
			return(sbText.toString());
		</cfscript>
	</cffunction>


	<!---
		Adds line breaks from a textarea input. All "paragraph data is outputted with a bottom margin.
	--->
	<cffunction name="TextAreaTripOutput" access="public" returntype="string" output="No" hint="Outputs text from a textarea input">
		<cfargument name="Text" type="string" required="Yes" />
		<cfargument name="companyName" default="ISE" hint="Replaces text with company name" />
        
		<cfscript>
			// Set up local variables
			var sbText = CreateObject("java", "java.lang.StringBuffer").init();
			
			// Replace Company Name
			vNewText = Replace(ARGUMENTS.Text, ("!company!"), ARGUMENTS.companyName, "ALL");
			
			// Replace Carriage Return
			sbText.append(Replace(vNewText, (Chr(13) & Chr(10)), "<br />", "ALL"));

			// Return the text and convert to string
			return(sbText.toString());
		</cfscript>
	</cffunction>


	<!--- Rerturns a formatted phone number --->
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
	<cffunction name="breakDownPhoneNumber" access="public" returntype="struct" output="no" hint="Returns a formatted phone number">
		<cfargument name="number" type="string" default="" />
		
        <cfscript>
			var phoneNumber = StructNew();
			phoneNumber.countryCode = '';
			phoneNumber.areaCode = '';
			phoneNumber.prefix = '';
			phoneNumber.number = '';
			listFields = VAL(ListLen(ARGUMENTS.number, '-'));
			
			// Phone number can have a total of 4 groups of numbers
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

</cfcomponent>