<!--- ------------------------------------------------------------------------- ----
	
	File:		adminTool.cfc
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		This holds the functions needed for the adminTool

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="adminTool"
	output="false" 
	hint="A collection of functions for the Online Application module">


	<!--- Return the initialized adminTool object --->
	<cffunction name="Init" access="public" returntype="adminTool" output="No" hint="Returns the initialized adminTool object">

		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>

	</cffunction>


	<!--- Login --->
	<cffunction name="doLogin" access="public" returntype="void" hint="Logs in a user">
		<cfargument name="userID" type="numeric" default="0">
		
        <cfscript>
			// Set User Session Variables  (userID / firstName / lastname / lastLoggedInDate / myUploadFolder )
			APPLICATION.CFC.USER.setUserSession(
				ID=ARGUMENTS.userID,
				updateDateLastLoggedIn=1
			);
			
			// Record last logged in date
			APPLICATION.CFC.USER.updateLoggedInDate(ID=ARGUMENTS.userID);
		</cfscript>
        
	</cffunction>


	<!--- Current Logged In --->
	<cffunction name="isCurrentUserLoggedIn" output="false" access="public" returntype="boolean"  description="Returns whether or not user is logged in">
		
        <cfscript>
			 if ( structkeyexists(SESSION,"USER") AND VAL(SESSION.USER.ID) ) {
				return true;
			 } else {
				return false;				 
			 }
		</cfscript>
        	
	</cffunction>
	
    
	<!--- Logout --->
	<cffunction name="doLogout" access="public" returntype="void" hint="Logs out a user from the Online Application">

		<cfscript>
			// Re-set customer session variables 
			SESSION.USER.ID = 0;
		</cfscript>
        
	</cffunction>

</cfcomponent>