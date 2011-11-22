<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		June 16, 2011
	Desc:		Index File to relocate to login screen when running on development
	
	Updates:	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
</cfsilent>
	
<!--- Relocate to Login Page if we are not at www.student-management.com --->
<cfif CGI.HTTP_HOST NEQ 'www.student-management.com'>

	<!--- Redirect to Login Page --->
    <cflocation url="login.cfm" addtoken="no">

</cfif>    