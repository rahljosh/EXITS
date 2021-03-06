<!--- CHECK RIGHTS - included on user_info.cfm, forms/user_form.cfm, forms/access_rights_form.cfm, forms/edit_family_members.cfm, and other user forms? --->
<cfset vGrantAccess = 0>

<!--- Office or User viewing his own information --->
<cfif ListFind("1,2,3,4", CLIENT.usertype) OR CLIENT.userid EQ URL.userid OR CLIENT.userType EQ 27>
	
	<cfset vGrantAccess = 1>
    
<cfelseif listFind("5,6", CLIENT.usertype) AND NOT VAL(vGrantAccess)>	
        
    <!--- CHECK IF CURRENT USER IS A MANAGER OR ADVISOR OF URL.USER --->
    <cfquery name="qCheckUserRegion" datasource="#application.dsn#">
        SELECT 
        	uar.regionid
        FROM 
        	user_access_rights uar
        WHERE 
        	uar.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
        AND 
        	uar.usertype > <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
		AND 
        	uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
        <cfif CLIENT.usertype EQ 6>
            AND 
            	uar.advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
        </cfif>
    </cfquery>
   
    <cfif qCheckUserRegion.recordcount>
        <cfset vGrantAccess = 1>
    </cfif>

</cfif>

<cfif vGrantAccess EQ 0>	
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
			<td background="pics/header_background.gif"><h2>Error</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
		<tr><td align="center" valign="top">
				<img src="pics/error_exclamation.gif" width="37" height="44"> I am sorry but you do not have the rights to see this page.
			</td>
		</tr>
		<tr><td align="center">If you think this is a mistake please contact <cfoutput>#APPLICATION.EMAIL.support#</cfoutput></td></tr>
		<tr><td align="center">You can view your account by clicking <a href="?curdoc=user_info&userid=<cfoutput>#CLIENT.userid#</cfoutput>">here<a/>.<br /><br /></td></tr>			
	</table>
	<cfinclude template="table_footer.cfm">
	<cfabort>
</cfif>