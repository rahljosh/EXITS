<link rel="stylesheet" href="../smg.css" type="text/css">
<Title>Double Placement Information</title>

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfif not IsDefined('url.update')>
	<cfset url.update = 'no'>
</cfif>

<cfquery name="get_double_place_students" datasource="caseusa">
	SELECT studentid, familylastname, firstname
	FROM smg_students
	WHERE regionassigned = '#get_student_info.regionassigned#' and companyid = '#client.companyid#' and active = '1'
	ORDER BY firstname, familylastname
</cfquery>

<!--- include template page header --->
<cfinclude template="placement_status_header.cfm">

<cfoutput>

<table width="580" align="center">
<tr><td><span class="application_section_header">Double Placement</span></td></tr>
</table><br>

<div class="row">
<cfif get_student_info.hostid is 0>
	<table width="580" align="center">
		<tr><td align="center"><h3>There is no host family assigned to this student.</h3></td></tr>
		<tr><td align="center"><h3>You cannot add a double place without a host family. Please add a host family first.</h3></td></tr>
	</table>
	<br>
	<table width="580" align="center">
		<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
	</table>
	<cfabort>
</cfif>

<cfif get_student_info.doubleplace EQ '0' OR url.update EQ 'yes'>
	<cfform action="../querys/update_place_double.cfm" method="post">
	<cfinput type="hidden" name="studentid" value="#get_student_info.studentid#">
	<table width="580" align="center">
		<tr>
			<td>
			Double Placement with Student:<br>
			<cfselect name="double_place">
				<option value="none"></option>
				<option value="0">Not a Double Placement</option>
				<cfloop query="get_double_place_students">
				<option value="#studentid#">#firstname# #familylastname# (#studentid#)</option>
				</cfloop>		
			</cfselect>
			</td>
		</tr>
		<cfif get_student_info.doubleplace NEQ 0>
			<tr><td>Reason for changing double placement:</td></tr>
			<tr><td><textarea name="reason" cols="40" rows="5"></textarea></td></tr>
		</cfif>
	</table>
	<br><br>
	<table width="580" align="center">
		<Tr>
			<td align="right" width="50%">
			<input name="submit" type="image" src="../pics/update.gif" align="right" border=0></cfform></td>
			<td align="left" width="50%">
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
		</tr>
	</table>
<cfelse>
	<cfquery name="get_double" datasource="caseusa">
		SELECT studentid, firstname, familylastname, countryresident,
		countryname
		FROM smg_students
		LEFT JOIN smg_countrylist ON countryresident = countryid
		WHERE studentid = '#get_student_info.doubleplace#'
	</cfquery>
	
	<cfloop query="get_double">
	<table width="580" align="center">
		<tr><td><h3>Double Placement with student : </h3></td></tr>
		<tr><td><h3>#firstname# #familylastname# (#studentid#)  &nbsp; -  &nbsp; from #countryname#</h3></td></tr>
	</table>
	<br>
	<table width="580" align="center">				
		<Tr>
		<cfform action="place_double.cfm?studentid=#client.studentid#&update=yes" method="post">
		<td align="right" width="50%"><br>
		<input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;</td>
		</cfform>
		<td align="left" width="50%"><Br>&nbsp;&nbsp;
		<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
		</tr>
	</table>
	</cfloop>
</cfif>
<br /><br />

<!--- DOUBLE DOC HISTORY --->
<cfquery name="get_history" datasource="caseusa">
	SELECT hist.studentid, doubleplaceid, hist.userid, date_change, reason, doc_student, doc_naturalfamily, doc_hostfamily, doc_school, doc_dpt,	
		s.firstname as stufirstname, s.familylastname as stulastname,
		doublestu.firstname as doublefirstname, doublestu.familylastname as doublelastname,
		u.firstname as userfirstname, u.lastname as userlastname
	FROM smg_doubleplace_history hist
	LEFT JOIN smg_students s ON s.studentid = hist.studentid
	LEFT JOIN smg_students doublestu ON doublestu.studentid = hist.doubleplaceid
	LEFT JOIN smg_users u ON u.userid = hist.userid
	WHERE hist.studentid = '#get_student_info.studentid#' 
		OR doubleplaceid = '#get_student_info.studentid#'
	ORDER BY double_historyid DESC
</cfquery>

<Cfif get_history.recordcount NEQ 0>
	<Table width=580 cellpadding=3 cellspacing=0 align="center" class="history">
		<tr><td colspan="6" align="center" bgcolor="##e2efc7">D O U B L E &nbsp; P L A C E M E N T &nbsp; L O G <br><br></td></tr>
		<tr>
			<td width="24%"><u>Double Placement with</u></td>
			<td width="23%"><u>Reason</u></td>
			<td width="23%"><u>Changed By</u></td>
			<td width="30%"><u>Double Placement Docs</u></td>
		</tr>	
		<cfloop query="get_history">								
		<tr bgcolor="D5DCE5"><td colspan="6">Date : &nbsp; #DateFormat(date_change, 'mm/dd/yyyy')#</td></tr>
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td valign="top">#doublefirstname# #doublelastname# (###doubleplaceid#)</td>
			<td valign="top">#reason#</td>
			<td valign="top">#userfirstname# #userlastname# (###userid#)</td>
			<td valign="top">Student &nbsp; <cfif doc_student NEQ ''>#DateFormat(doc_student, 'mm/dd/yy')#<cfelse>n/a</cfif> <br />
				Natural Family &nbsp; <cfif doc_naturalfamily NEQ ''>#DateFormat(doc_naturalfamily, 'mm/dd/yy')#<cfelse>n/a</cfif><br />
				Host Family &nbsp; <cfif doc_hostfamily NEQ ''>#DateFormat(doc_hostfamily, 'mm/dd/yy')#<cfelse>n/a</cfif><br />
				School &nbsp; <cfif doc_school NEQ ''>#DateFormat(doc_school, 'mm/dd/yy')#<cfelse>n/a</cfif><br />
				Deparment of State &nbsp; <cfif doc_dpt NEQ ''>#DateFormat(doc_dpt, 'mm/dd/yy')#<cfelse>n/a</cfif> <br />
			</td>						
		</tr>
		</cfloop>
	</table>
</cfif>
<br>

</cfoutput>

</div>