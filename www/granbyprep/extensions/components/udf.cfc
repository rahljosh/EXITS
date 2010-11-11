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
				FindNoCase("dev.granbyprep.com", CGI.http_host) OR 
				FindNoCase("developer", server.ColdFusion.ProductLevel)
			){
				return(true);
			} else {
				return(false);
			}
		</cfscript>
	</cffunction>


	<!--- This hashes the given ID for security reasons --->
	<cffunction name="generateHashID" access="public" returntype="string" output="no" hint="Hashes the given ID for security reasons">
		<cfargument name="ID" type="numeric" required="yes" />
		
		<!--- Return hash --->
		<cfreturn (
			((ARGUMENTS.ID * 64) MOD 29) & 
			Chr(Right(ARGUMENTS.ID, 1) + 65) & 
			(ARGUMENTS.ID MOD 4)
			) />
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
			strLowerCaseAlpha = "abcdefghijklmnopqrstuvwxyz";
			
			// Set up available upper case values
			strUpperCaseAlpha = UCase( strLowerCaseAlpha );
			
			// Set up available numbers
			strNumbers = "0123456789";
	
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

	
    <!--- Return School Address --->
	<cffunction name="getSchoolAddress" access="public" returntype="string" output="false" hint="Returns the school address">
		
        <cfoutput>
            <cfsavecontent variable="schoolAddress">
                #APPLICATION.SCHOOL.name# <br />
                #APPLICATION.SCHOOL.address# <br />
                #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                Phone: #APPLICATION.SCHOOL.phone# <br />
                Toll Free: #APPLICATION.SCHOOL.tollFree# <br />                    
            </cfsavecontent>
		</cfoutput>
                
		<cfscript>
			// Return String
			return(schoolAddress);
        </cfscript>
		   
	</cffunction>


	<!--- This removes foreign accents from online application fields --->
	<cffunction name="removeAccent" access="public" returntype="string" output="false" hint="Remove foreign acccents from a string">
    	<cfargument name="varString" hint="String">

		<cfscript>
			// Declare Lists
 		    var list1 = "Â,Á,À,Ã,Ä,â,á,à,ã,ä,É,Ê,é,ê,Í,Ì,í,ì,Ô,Ó,Õ,Ö,ô,ó,õ,ö,Ú,Ü,Û,ú,ü,û,Ç,ç,Ñ,ñ,S,Z,Ø,ø,å,',æ,Å,ß,Š,î,ý,ë,è,ï,ò";
			var list2 = "A,A,A,A,A,a,a,a,a,a,E,E,e,e,I,I,i,i,O,O,O,O,o,o,o,o,U,U,U,u,u,u,C,c,N,n,S,Z,O,o,a, ,e,A,s,S,i,y,e,e,i,o";

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
			sbText.append("</div><br />");		
			
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


</cfcomponent>