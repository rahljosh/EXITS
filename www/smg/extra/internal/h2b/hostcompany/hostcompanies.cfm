<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Host Companies List</title>
</body>
<link href="http://dev.student-management.com/extra/style.css" rel="stylesheet" type="text/css">

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" bgcolor="#FFFFFF">
  <tr>
    <td bordercolor="#FFFFFF">
		<!---<cftry>--->

<!--- 
<cfquery name="students" datasource="mysql">
		SELECT s.firstname, s.familylastname, s.sex, s.country, s.studentid, s.uniqueid,
			s.programid, smg_countrylist.countryname, smg_programs.programname,
			u.businessname,
			sc.schoolname
		FROM smg_students s
		LEFT JOIN smg_countrylist ON smg_countrylist.countryid = s.country  
		LEFT JOIN smg_programs ON smg_programs.programid = s.programid 
		LEFT JOIN smg_users u on u.userid = s.intrep 
		LEFT JOIN php_schools sc ON sc.schoolid = s.schoolid
		WHERE s.companyid = '#client.companyid#' 
			<cfif url.status EQ 'active'>
				AND s.active = '1'
			<cfelseif url.status EQ 'inactive'>
				AND s.active = '0' 
				AND s.canceldate IS NULL
			<cfelseif url.status EQ 'cancelled'>
				AND s.active = '0' 
				AND s.canceldate IS NOT NULL
			</cfif>
			<cfif url.placed EQ 'no'>
				AND s.hostid = '0'
			<cfelseif url.placed EQ 'yes'>
				AND s.hostid != '0'	
			</cfif>
		ORDER BY '#url.order#' 
</cfquery>
 --->


<cfquery name="hostcompanies" datasource="MySql">
	SELECT extra_hostcompany.hostcompanyid, extra_hostcompany.name, extra_hostcompany.phone, extra_hostcompany.supervisor, extra_hostcompany.city, extra_hostcompany.state, extra_hostcompany.business_typeid, extra_typebusiness.business_type as typebusiness, smg_states.state as s

	FROM extra_hostcompany
    LEFT JOIN smg_states ON smg_states.id = extra_hostcompany.state
    LEFT JOIN extra_typebusiness ON extra_typebusiness.business_typeid = extra_hostcompany.business_typeid
	WHERE companyid = #client.companyid#
	ORDER BY #url.order# 
</cfquery>


<cfoutput>
<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;Host Companies </td>
		<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">#hostcompanies.recordcount# host companies found</td>
		<td width="1%"></td>
	</tr>
</table>
<br>
<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
	<tr>
		<th width=106 align="left"  bgcolor="4F8EA4"><a href="?curdoc=hostcompany/hostcompanies&order=hostcompanyid" class="style2">ID</a></th>
		<th width=165 align="left" bgcolor="4F8EA4"><a href="?curdoc=hostcompany/hostcompanies&order=name" class="style2">Company Name</a></th>
		<th width=144 align="left"  bgcolor="4F8EA4"><a href="?curdoc=hostcompany/hostcompanies&order=phone" class="style2">Phone</th>
		<th width=144 align="left"  bgcolor="4F8EA4"><a href="?curdoc=hostcompany/hostcompanies&order=supervisor" class="style2">Contact</th>
		<th width=144 align="left"  bgcolor="4F8EA4"><a href="?curdoc=hostcompany/hostcompanies&order=city" class="style2">City</a></th>
		<th width=60 align="left"  bgcolor="4F8EA4"><a href="?curdoc=hostcompany/hostcompanies&order=state" class="style2">State</a></th>
		<th width=112 align="left"  bgcolor="4F8EA4"><a href="?curdoc=hostcompany/hostcompanies&order=typebusiness" class="style2">Business</a></th>
		</tr>
<cfloop query="hostcompanies">
	<tr bgcolor="#iif(hostcompanies.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
		<td bgcolor="#iif(hostcompanies.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#"><a href="?curdoc=hostcompany/hostcompany_info&hostcompanyid=#hostcompanyid#" class="style4">
		  <div align="left">#hostcompanyid#</div></a></td>
		<td bgcolor="#iif(hostcompanies.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#"><a href="?curdoc=hostcompany/hostcompany_profile&hostcompanyid=#hostcompanyid#" class="style4">
		  <div align="left">#name#</div></a></td>
		<td bgcolor="#iif(hostcompanies.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style1"><div align="left">#phone#</td>
		<td bgcolor="#iif(hostcompanies.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style1"><div align="left">#supervisor#</td>
		<td bgcolor="#iif(hostcompanies.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style1">
		  <div align="left">#city#</div></a></td>
		<td bgcolor="#iif(hostcompanies.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style1"><a href="?curdoc=hostcompany/hostcompany_info&hostcompanyid=#hostcompanyid#" class="style4"><div align="left">#s#</div></a></td>
		<td bgcolor="#iif(hostcompanies.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style1"><a href="?curdoc=hostcompany/hostcompany_info&hostcompanyid=#hostcompanyid#" class="style4"><div align="left">
		<cfif #business_typeid# EQ 0> n/a <cfelse> #typebusiness# </cfif></div>
		</a></td>
		</tr>
</cfloop>
</table>
<br><br>
</cfoutput>
<div align="center">
<a href="index.cfm?curdoc=hostcompany/new_hostcompany"><img src="../pics/add-company.gif" border="0" align="middle" alt="Add a Host Company"></img></a></div>
<br>

<!--- <cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry> --->		</td>
  </tr>
</table>
</html>