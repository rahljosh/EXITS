<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfif not isDefined('url.text')><cfset url.text = 'no'></cfif>

<cfif not isDefined('url.all')><cfset url.all = 'no'></cfif>

<cfinclude template="../querys/get_active_programs.cfm">

<cfquery name="get_batches" datasource="MySql">
	SELECT batchid, datecreated
	FROM smg_sevis
	WHERE companyid = '#client.companyid#' AND type = 'new'
	ORDER BY batchid DESC
</cfquery>

<cfquery name="get_fee_history" datasource="MySql">
	SELECT s.bulkid, s.companyid, s.createdby, s.datecreated, s.totalstudents, 
			c.companyshort,
			u.firstname, u.lastname
	FROM smg_sevisfee s
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	INNER JOIN smg_users u ON u.userid = s.createdby
	WHERE 1 = 1
	<cfif url.all is 'no'>AND s.companyid = #client.companyid#</cfif>
	ORDER BY s.companyid, datecreated DESC
</cfquery>

<span class="application_section_header">SEVIS I-901 BATCH INTERFACE SYSTEM</span><br>

<table class="nav_bar" cellpadding=4 cellspacing="0" align="center" width="96%">
<tr><th bgcolor="ededed">&nbsp; &nbsp; &nbsp; &nbsp; S E V I S  &nbsp; I 9 0 1 &nbsp; F E E </th>
	<td width="15%" align="right" bgcolor="ededed"><a href="" onClick="javascript: win=window.open('sevis/xml_list_files.cfm?type=fee', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Virtual Folder</a>&nbsp; - &nbsp;<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/menu"><img src="pics/sevis_menu.gif" border="0"></a></td>
</table><br>

<table width="96%" cellpadding="0" cellspacing="0" align="center">
<tr><td width="48%" valign="top">
	<cfform action="sevis/fee_xml_batchid.cfm" method="POST" target="blank">
	<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="100%">
		<tr><th colspan="2" bgcolor="#ededed">Create I-901 Fee Collection (Up to 2000)</th></tr>
		<tr><td colspan="2" bgcolor="#ededed" align="center">Please, DO NOT Create Files Unnecessarily.</td>
		<tr><td>Batch ID :</td>
			<td align="left"><select name="batchid" multiple size="8">
				<cfoutput query="get_batches"><option value="#batchid#">#batchid# &nbsp; #DateFormat(datecreated,'mm/dd/yy')# &nbsp;</option></cfoutput></select></td>
		</tr>
		<tr>
			<td colspan="2" align="center" bgcolor="#ededed"><input type="image" src="pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td>
		</tr>
	</table><br>
	</cfform>
	</td>
<td width="2%">&nbsp;</td>
<td width="48%" valign="top">
	<cfform action="sevis/fee_xml_programid.cfm" method="POST" target="blank">
	<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="100%">
		<tr><th colspan="2" bgcolor="#ededed">Create I-901 Fee Collection (Up to 2000)</th></tr>
		<tr><td colspan="2" bgcolor="#ededed" align="center">Please, DO NOT Create Files Unnecessarily.</td>
		<tr align="left">
			<TD width="15%">Program :</td>
			<TD>
			<select name="programid"  multiple size="8">			
			<!--- <option value=0>All Programs</option> --->
			<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>
			</select>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center" bgcolor="#ededed"><input type="image" src="pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td>
		</tr>
	</table><br>
	</cfform>
</td></tr>
</table>

<cfset fontcolor = '3333CC'>
<Table class="nav_bar" cellpadding=3 cellspacing="0" align="center" width="96%">
<tr><th colspan="5" bgcolor="#ededed">
	<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/fee_menu&text=yes&all=yes">(all companies)</a> &nbsp; &nbsp;
	XML Files History &nbsp; &nbsp;
	<Cfif url.text is 'no'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/fee_menu&text=yes">(show list)</a>
	<cfelseif url.text is 'yes'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/fee_menu&text=no">(hide list)</a>
	</Cfif>
</th></tr>
<cfif url.text is 'no'><cfelse>
	<tr bgcolor="#ededed">
		<td width="11%" align="center"><b>Bulk ID</b></td>
		<td width="10%" align="center"><b>Company</b></td>
		<td width="18%" align="center"><b>Date Created</b></td>
		<td width="18%" align="center"><b>Total Students</b></td>
		<td width="20%" align="center"><b>Created By</b></td>				
	</tr>
	<cfoutput query="get_fee_history">
	<tr bgcolor="#iif(get_fee_history.currentrow MOD 2 ,DE("white") ,DE("ededed"))#">
		<td align="center"><font color="#fontcolor#"><a href="sevis/fee_list.cfm?bulkid=#bulkid#" target="_blank">0#bulkid#</font></a></td>
		<td align="center"><font color="#fontcolor#"><a href="sevis/fee_list.cfm?bulkid=#bulkid#" target="_blank">#companyshort#</a></font></td>
		<td align="center"><font color="#fontcolor#">#DateFormat(datecreated, 'mm/dd/yyyy')#</font></td>
		<td align="center"><font color="#fontcolor#">#totalstudents#</font></td>
		<td align="center"><font color="#fontcolor#">#firstname# #lastname#</font></td>				
	</tr>
	</cfoutput>
	<tr><td colspan="2"><font size="-1" color="FF0000">* Pending Bulk Files</font></td>
	<td colspan="3" align="right">* Click in the link(s) above to see the list of students.</td></tr>
</cfif>
</table>
<br>