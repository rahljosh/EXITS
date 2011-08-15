<cfcomponent>
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