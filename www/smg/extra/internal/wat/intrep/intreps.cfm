<!--- Kill Extra Output --->
<cfsilent>

    <cfquery name="qGetIntlReps" datasource="MySql">
        SELECT 
        	userid, 
            firstname, 
            lastname, 
            businessname, 
            uniqueid,
            smg_countrylist.countryname
        FROM 
        	smg_users
        LEFT JOIN 
        	smg_countrylist ON country = smg_countrylist.countryid
        WHERE 
        	usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        ORDER BY 
			<cfif IsDefined('url.order')>
            	#url.order#
			<cfelse>
            	businessname
			</cfif>
    </cfquery>

</cfsilent>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
	<tr>
		<td>

            <table width=95% cellpadding=0 cellspacing=0 border="0" align="center">
                <tr valign="middle" height="24" bgcolor="##E4E4E4">
                    <td width="57%" valign="middle" class="title1">&nbsp;International Representative</td>
                    <td width="42%" align="right" valign="top" class="style1">#qGetIntlReps.recordcount# International Representative(s) found</td>
                    <td width="2%" bgcolor="##E4E4E4">&nbsp;</td>
                </tr>
            </table>
            
            <br>
            
            <table border="0" cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
                <tr bgcolor="##4F8EA4">
                    <td width="6%"><a href="?curdoc=intrep/intreps&order=userid&active=1" class="style2">ID</a></td>
                    <td width="30%"><a href="?curdoc=intrep/intreps&order=businessname&active=1" class="style2">International Rep.</a></td>
                    <td width="22%"><a href="?curdoc=intrep/intreps&order=firstname&active=1" class="style2">First Name</a></td>
                    <td width="22%"><a href="?curdoc=intrep/intreps&order=lastname&active=1" class="style2">Last Name</a></td>
                    <td width="20%"><a href="?curdoc=intrep/intreps&order=countryname&active=1" class="style2">Country</a></td>
                </tr>
                <cfloop query="qGetIntlReps">
                    <tr bgcolor="###iif(qGetIntlReps.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                        <td class="style4"><a href="?curdoc=intrep/intrep_info&uniqueid=#uniqueid#" class="style4">#userid#</a></td>
                        <td class="style4"><a href="?curdoc=intrep/intrep_info&uniqueid=#uniqueid#" class="style4">#businessname#</a></td>
                        <td class="style5">#firstname#</td>
                        <td class="style5">#lastname#</td>
                        <td class="style5">#countryname#</td>
                    </tr>
                </cfloop>
            </table>
            
            <br>

            <div align="center">
          		<a href="index.cfm?curdoc=intrep/new_intrep"><img src="../pics/add-intrep.gif" border="0" align="middle" alt="Add a Intl. Rep."></a></div>
            <br>
            
		</td>
	</tr>
</table>

</cfoutput>