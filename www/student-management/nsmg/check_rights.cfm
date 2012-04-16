<!--- CHECK RIGHTS - included on user_info.cfm, forms/user_form.cfm, forms/access_rights_form.cfm, forms/edit_family_members.cfm, and other user forms? --->

<cfset grant_access = 0>

<cfif ListFind("1,2,3,4,5", CLIENT.usertype) OR CLIENT.userid EQ url.userid OR CLIENT.userType EQ 27>
	<cfset grant_access = 1>
</cfif>

<cfif listFind("5,6", CLIENT.usertype) AND NOT VAL(grant_access)>	
        
    <!--- CHECK IF CURRENT USER IS A MANAGER OR ADVISOR OF URL.USER --->
    <cfquery name="get_user_regions" datasource="#application.dsn#">
        SELECT user_access_rights.regionid
        FROM user_access_rights 
        INNER JOIN smg_companies ON user_access_rights.companyid = smg_companies.companyid
        WHERE smg_companies.website = <cfif CLIENT.companyshort is 'CASE'>'CASE'<cfelse>'SMG'</cfif>
        AND user_access_rights.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
        AND user_access_rights.usertype > <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
		AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
        <cfif CLIENT.usertype EQ 6>
            AND user_access_rights.advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
        </cfif>
    </cfquery>
   
    <cfif get_user_regions.recordcount>
        <cfset grant_access = 1>
    </cfif>

</cfif>

<cfif grant_access EQ 0>	
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