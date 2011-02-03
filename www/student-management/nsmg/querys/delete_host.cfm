<!--- revised by Marcus Melo on 08/19/2005 --->
<cfoutput>
<cfif not IsDefined('url.hostid')>
	<cfinclude template="../forms/error_message.cfm">
<cfelse>
	<cfquery name="check_students" datasource="MySql">
		SELECT studentid, firstname, familylastname, smg_students.companyid, companyshort
		FROM smg_students
		INNER JOIN smg_companies ON smg_students.companyid = smg_companies.companyid
		WHERE smg_students.hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
		ORDER BY companyshort, familylastname
	</cfquery>
	
	<cfquery name="check_cbcs" datasource="MySql">
		SELECT cbcfamid, hostid
		FROM smg_hosts_cbc
		WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="get_host" datasource="MySql">
		SELECT familylastname, hostid
		FROM smg_hosts
		WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif check_students.recordcount NEQ '0' OR check_cbcs.recordcount NEQ '0'>  <!--- THERE ARE STUDENTS ASSIGNED TO THIS SCHOOL --->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/deletex.gif"></td>
				<td background="pics/header_background.gif"><h2>Delete - Error </h2></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<cfif check_students.recordcount NEQ '0'>
		<tr><td align="center"><div align="justify"><h3>
							<p>In order to delete a host family it must not be assigned to any student.</p>
							<p>The host family you are trying to delete has been assigned to #check_students.recordcount# student(s).</p></h3></div></td></tr>
		<tr bgcolor="e2efc7"><td colspan="2">
			<cfloop query="check_students">
			&nbsp; &nbsp; &nbsp; &nbsp; #firstname# #familylastname# (#studentid#) - #companyshort#<br>
			</cfloop>
		</td></tr>	
		<tr bgcolor="e2efc7"><td colspan="2">If for any reason you would like to delete this family, please move the student(s) above to another family.</td></tr>
		</cfif>
		<cfif check_cbcs.recordcount NEQ '0'>
		<tr><td align="center"><div align="justify"><h3>
							<p>There are CBCs for this family.</p>
							<p>You cannot delete this host family.</p></h3></div></td></tr>
		<tr bgcolor="e2efc7"><td colspan="2">Please if you wish to delete this host family contact your system administrator</td></tr>
		</cfif>		
		<tr><td align="center"><input type="image" value=" back " src="pics/back.gif" onClick="javascript:history.go(-1)"></a></td></tr>
		</table>
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
				<td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
		</table>
		<cfabort>
	</cfif>
	
<!--- none students are assigned to the HOST, - set host to inactive HOST --->
 		<cfquery name="delete_host" datasource="MySql">
			update smg_hosts
            set active = 0
			WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
			LIMIT 1
		</cfquery>
        <!----
		<cfquery name="delete_host_children" datasource="MySql">
			DELETE 
			FROM smg_host_children
			WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfquery name="delete_host_animals" datasource="MySql">
			DELETE 
			FROM smg_host_animals
			WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
		</cfquery>
		---->
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/deletex.gif"></td>
				<td background="pics/header_background.gif"><h2>Host Family Deleted Successfully </h2></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td align="center"><h3>The host family #get_host.familylastname# (#get_host.hostid#) was successfully deleted from the system.</h3></div></td></tr>
		<tr><td align="center"><a href="?curdoc=host_fam"><img src="pics/back.gif" border="0"></img></a></td></tr>
		</table>
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
				<td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
		</table>
</cfif>
</cfoutput>