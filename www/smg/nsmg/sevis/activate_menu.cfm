<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfif not isDefined('url.text')><cfset url.text = 'no'></cfif>

<cfif not isDefined('url.all')><cfset url.all = 'no'></cfif>

<cfinclude template="../querys/get_active_programs.cfm">

<cfset batch_type = 'activate'>

<!-----Company Information----->
<Cfquery name="get_company" datasource="MySQL">
	select companyid, companyname, companyshort, sevis_userid, iap_auth
	from smg_companies
	where companyid = #client.companyid#
</Cfquery>

<cfquery name="get_sevis_history" datasource="MySql">
	SELECT s.batchid, s.companyid, s.createdby, s.datecreated, s.totalstudents, s.totalprint, s.received, 
			c.companyshort,
			u.firstname, u.lastname
	FROM smg_sevis s
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	INNER JOIN smg_users u ON u.userid = s.createdby
	WHERE type = 'activate'
	<cfif url.all is 'no'>AND s.companyid = #client.companyid#</cfif>
	ORDER BY c.companyshort, datecreated DESC
</cfquery>

<span class="application_section_header">SEVIS BATCH INTERFACE SYSTEM - Version 5.0</span><br>

<cfoutput>
<table class="nav_bar" cellpadding=4 cellspacing="0" align="center" width="96%">
<tr><th bgcolor="ededed">&nbsp; &nbsp; &nbsp; &nbsp; A C T I V A T E &nbsp; S T U D E N T S</th>
	<td width="15%" align="right" bgcolor="ededed"><a href="" onClick="javascript: win=window.open('sevis/xml_list_files.cfm?type=activate', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Virtual Folder</a>&nbsp; - &nbsp;<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/menu"><img src="pics/sevis_menu.gif" border="0"></a></td></tr>
</table><br>

<!--- ACTIVATE STUDENTS THAT HAVE ALREADY ARRIVED IN THE USA --->
<cfform action="sevis/activate_xml_arrived.cfm" method="POST" target="blank">
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr><th colspan="2" bgcolor="ededed">Active students that have already arrived in the USA according to flight info received - (Up to 250 students)</th></tr>
	<tr align="left">
		<TD width="15%">Program :</td>
		<TD><select name="programid" multiple  size="5">			
			<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
			</select></td></tr>
	<tr align="left">
		<TD width="15%">Pre-AYP :</td>
		<TD><input type="checkbox" name="pre_ayp">Only Pre-AYP students</td></tr>
	<tr align="left">
		<TD width="15%">Arrival Date : </td>
		<TD><cfinput type="text" name="arrival_date" size="8" value="#DateFormat(now(), 'mm/dd/yyyy')#" validate="date" required="yes" message="You must include an arrival date" maxlength="10"></td></tr>
	<tr><td colspan="2" align="center" bgcolor="ededed"><input type="image" src="pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td></tr>
</table><br>
</cfform>

<!--- ACTIVATE STUDENTS --->
<cfform action="sevis/activate_xml.cfm" method="POST" target="blank">
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr><th colspan="2" bgcolor="ededed">Active Students Forms (Up to 250 students)</th></tr>
	<tr align="left">
		<TD width="15%">Program :</td>
		<TD><select name="programid" multiple  size="5">			
			<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
			</select></td></tr>
	<tr align="left">
		<TD width="15%">Pre-AYP :</td>
		<TD><input type="checkbox" name="pre_ayp">Only Pre-AYP students</td></tr>
	<tr><td colspan="2" align="center" bgcolor="ededed"><input type="image" src="pics/view.gif" align="center" border=0 <cfif client.usertype is not '1'>disabled</cfif>></td></tr>
</table><br>
</cfform>

<!--- XML EXTRACT DATA --->
<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="96%">
	<th align="center" bgcolor="ededed">SEVIS Batch Activation XML Results Extractor</th></tr>
	<tr><td bgcolor="ededed"><cfform method="post" action="?curdoc=sevis/activate_results" enctype="multipart/form-data">
		File Name &nbsp; : &nbsp; <input type="text" name="filename" size="50">
		<div align="center"><input type="submit" value="Update DS 2019"></div>
		</cfform></td></tr>
</table><br>
</cfoutput>

<cfinclude template="ds_forms.cfm">

<Table class="nav_bar" cellpadding=3 cellspacing="0" align="center" width="96%">
<tr><th colspan="7" bgcolor="ededed">
	<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/activate_menu&text=yes&all=yes">(all companies)</a> &nbsp; &nbsp;
	XML Files History &nbsp; &nbsp;
	<Cfif url.text is 'no'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/activate_menu&text=yes">(show list)</a>
	<cfelseif url.text is 'yes'>
		<a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/activate_menu&text=no">(hide list)</a>
	</Cfif>
</th></tr>
<cfif url.text NEQ 'no'>
	<tr bgcolor="ededed">
		<td width="11%" align="center"><b>Batch ID</b></td>
		<td width="10%" align="center"><b>Company</b></td>
		<td width="18%" align="center"><b>Date Created</b></td>
		<td width="18%" align="center"><b>Total Students</b></td>
		<td width="18%" align="center"><b>Total Created</b></td>
		<td width="5%" align="center"><b>Errors</b></td>
		<td width="20%" align="center"><b>Created By</b></td>				
	</tr>
	<cfoutput query="get_sevis_history">
	<cfif totalprint is 0 and received is 'no'><cfset toterrors = 'n/a'><cfelse><cfset toterrors = (#totalstudents# - #totalprint#)></cfif>
	<cfif received is 'yes'><cfset fontcolor = '3333CC'><cfelse><cfset fontcolor = 'FF0000'></cfif>
	<tr bgcolor="#iif(get_sevis_history.currentrow MOD 2 ,DE("white") ,DE("ededed"))#">
		<td align="center"><font color="#fontcolor#"><a href="sevis/activate_list.cfm?batchid=#batchid#" target="_blank">0#batchid#</font></a></td>
		<td align="center"><font color="#fontcolor#"><a href="sevis/activate_list.cfm?batchid=#batchid#" target="_blank">#companyshort#</a></font></td>
		<td align="center"><font color="#fontcolor#"><a href="sevis/activate_list.cfm?batchid=#batchid#" target="_blank">#DateFormat(datecreated, 'mm-dd-yyyy')#</font></a></td>
		<td align="center"><font color="#fontcolor#">#totalstudents#</font></td>
		<td align="center"><font color="#fontcolor#">#totalprint#</font></td>
		<td align="center"><cfif toterrors GT 0><font color="FF0000"><cfelse><font color="3333CC"></cfif>#toterrors#</font></td>
		<td align="center"><font color="#fontcolor#">#firstname# #lastname#</font></td>				
	</tr>
	</cfoutput>
	<tr><td colspan="3"><font size="-1" color="FF0000">* Pending Batch Files</font></td>
	<td colspan="4">* Click in the link(s) above to see the list of students.</td></tr>
</cfif>
</table><br>