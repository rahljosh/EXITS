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
				FindNoCase("dev.student-management.com", CGI.http_host) OR 
				FindNoCase("developer", server.ColdFusion.ProductLevel)
			){
				return(true);
			} else {
				return(false);
			}
		</cfscript>
	</cffunction>


	<cffunction name="removeAccent" access="public" returntype="string" output="false" hint="Remove foreign acccents from a string">
    	<cfargument name="varString" hint="String">

		<cfscript>
			// Declare Lists
 		    var list1 = "�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,�,S,Z,�,�,�,',�,�,�,�";
			var list2 = "A,A,A,A,A,a,a,a,a,a,E,E,e,e,I,I,i,i,O,O,O,O,o,o,o,o,U,U,U,u,u,u,C,c,N,n,S,Z,O,o,a, ,e,A,s,S";

			// Remove Accent - replaceList
			var newString = replaceList(ARGUMENTS.varString, list1, list2) ; 
	
			// Return String
			return(newString);
        </cfscript>
		   
	</cffunction>


</cfcomponent>