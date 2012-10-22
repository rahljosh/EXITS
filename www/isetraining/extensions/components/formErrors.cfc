<!--- ------------------------------------------------------------------------- ----
	
	File:		FormErrors.cfc
	Author:		Marcus Melo
	Date:		June 25, 2010
	Desc:		This object implements the message queue interface for form errors.

	Example Code:
		
		<!-- Create the form error object -->
		<cfset FormErrors = CreateObject("component", "inc_config.cfc.FormErrors").Init() />

		<!-- Check for valid data and add error messages -->
		<cfif NOT Len(name)>
			<cfset FormErrors.Add("Please enter your full name") />
		</cfif>
		
		<!--- Check if any errors occured --->
		<cfif NOT FormErrors.GetLength()>
			....
		</cfif>

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="FormErrors" 
	extends="messageQueue" 
	output="no"
	hint="Handles form errors">
	
	
</cfcomponent>