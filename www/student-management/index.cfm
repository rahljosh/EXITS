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
	
<!--- Redirect to Login Page --->
<cflocation url="login.cfm" addtoken="no">