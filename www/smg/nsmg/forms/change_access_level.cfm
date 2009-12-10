<!--- change level was selected --->
<cfif isDefined("form.change_level")>
    
    <cfquery name="get_access" datasource="#application.dsn#">
        SELECT *
        FROM user_access_rights
    	WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.change_level#">
    </cfquery>
        
	<cfset client.companyid = get_access.companyid>
    <cfset client.usertype = get_access.usertype>
    <cfset client.regions = get_access.regionid>
    <cfset client.regionid = get_access.regionid>

    <cfquery name="get_company" datasource="#application.dsn#">
        SELECT companyname, team_id
        FROM smg_companies
        WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    </cfquery>
    <cfset client.companyname = get_company.companyname>
    <cfset client.programmanager = get_company.team_id>
    
    <cfquery name="get_usertype" datasource="#application.dsn#">
        SELECT usertype
        FROM smg_usertype
        WHERE usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
    </cfquery>
    <cfset client.accesslevelname = get_usertype.usertype>
    <cfif client.regionid NEQ ''>
        <cfquery name="get_region" datasource="#application.dsn#">
            SELECT regionname
            FROM smg_regions
            WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
        </cfquery>
        <cfset client.accesslevelname = "#client.accesslevelname# in #get_region.regionname#">
    </cfif>

	<cflocation url="#form.http_referer#" addtoken="no">

</cfif>

<!--- this table is so the form is not 100% width. --->
<table align="center">
  <tr>
    <td>

<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/user.gif"></td>
	<td background="pics/header_background.gif"><h2>Change Access Level</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<cfquery name="get_access" datasource="#application.dsn#">
    SELECT uar.id, uar.companyid, uar.regionid, uar.usertype, r.regionname, c.companyshort, c.team_id, ut.usertype AS usertypename
    FROM user_access_rights uar
    LEFT JOIN smg_regions r ON uar.regionid = r.regionid
    INNER JOIN smg_companies c ON uar.companyid = c.companyid
    INNER JOIN smg_usertype ut ON uar.usertype = ut.usertypeid
    WHERE c.website = '#client.company_submitting#'
    AND uar.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    ORDER BY uar.companyid, uar.regionid, uar.usertype
</cfquery>

<cfif client.usertype LTE 4>

    You have access to the following Program Manager & Regional Access levels.
    Please choose which one you would like to view.
    Your current level is displayed in bold.<br /><br />
    
    <table border=0 cellpadding=4 cellspacing=0 align="center">
        <tr align="center" valign="top">
        <cfoutput query="get_access" group="companyid">
            <td>
                <strong>#team_id#</strong><br /><br />
                <table cellspacing="0" cellpadding="2">
                    <tr align="center">
                        <td nowrap="nowrap"><u>Region / Access Level</u></td>
                    </tr>
                    <cfoutput>
                        <tr align="center">
                        <td>
                            <cfif get_access.companyid EQ client.companyid AND get_access.regionid EQ client.regionid AND get_access.usertype EQ client.usertype>
                                <strong>#get_access.regionname# (#get_access.regionid#) / #get_access.usertypename#</strong>
                            <cfelse>
                                <form action="index.cfm?curdoc=forms/change_access_level" method="post" name="theForm_#get_access.id#" id="theForm_#get_access.id#">
                                <input type="hidden" name="change_level" value="#get_access.id#">
                                <input type="hidden" name="http_referer" value="#cgi.http_referer#">
                                </form>
                                <a href="javascript:document.theForm_#get_access.id#.submit();">#get_access.regionname# (#get_access.regionid#) / #get_access.usertypename#</a>
                            </cfif>
                        </td>
                        </tr>                                    
                    </cfoutput>
                </table>
            </td>
        </cfoutput>
        </tr>
    </table>

<cfelse>

    You have access to the following Regional Access levels.
    Please choose which one you would like to view.
    Your current level is displayed in bold.<br /><br />
                
    <table cellspacing="0" cellpadding="2" align="center">
        <tr align="center">
            <td nowrap="nowrap"><u>Region / Access Level</u></td>
        </tr>
        <cfoutput query="get_access">
            <tr align="center">
            <td>
                <cfif get_access.companyid EQ client.companyid AND get_access.regionid EQ client.regionid AND get_access.usertype EQ client.usertype>
                    <strong>#get_access.regionname# (#get_access.regionid#) / #get_access.usertypename#</strong>
                <cfelse>
                    <form action="index.cfm?curdoc=forms/change_access_level" method="post" name="theForm_#get_access.id#" id="theForm_#get_access.id#">
                    <input type="hidden" name="change_level" value="#get_access.id#">
                    <input type="hidden" name="http_referer" value="#cgi.http_referer#">
                    </form>
                    <a href="javascript:document.theForm_#get_access.id#.submit();">#get_access.regionname# (#get_access.regionid#) / #get_access.usertypename#</a>
                </cfif>
            </td>
            </tr>                                    
        </cfoutput>
    </table>
     
</cfif>

	</td>
	</tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

    </td>
  </tr>
</table>
<!--- this table is so the form is not 100% width. --->
