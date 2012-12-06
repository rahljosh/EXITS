<cfsilent>
<cfapplication name="registryClientVariablePurger" clientmanagement="no" setclientcookies="No">
<!---#### Check for the current version of ColdFusion and create a variable for the correct registry branch. ####--->
<cfparam name="Request.keyPath" default="Macromedia">
<cfparam name="Request.flushCtrl" default="true" type="boolean">
<cflock scope="server" timeout="5" type="readonly">
	<cfif left(server.ColdFusion.ProductVersion, 1) LTE 5>
		<cfset Request.keyPath = "Allaire">
	</cfif>
	<cfif left(server.ColdFusion.ProductVersion, 1) EQ 4>
		<cfset Request.flushCtrl = false>
	</cfif>
</cflock>
</cfsilent>