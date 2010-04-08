<link rel="stylesheet" href="../smg.css" type="text/css">

<cfoutput>
	<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	function CheckDates(ckname, frname) {
		if (document.form.elements[ckname].checked) {
			document.form.elements[frname].value = '#DateFormat(now(), 'mm/dd/yyyy')#';
			}
		else { 
			document.form.elements[frname].value = '';  
		}
	}	
	//  End -->
	</script>
</cfoutput>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="double_student" datasource="caseusa">
	SELECT firstname, middlename, familylastname, studentid, countryresident,
		countryname
	FROM smg_students
	INNER JOIN smg_countrylist ON countryresident = countryid
	WHERE studentid = '#get_student_info.doubleplace#'
</cfquery>

<cfoutput>

<Title>Double Placement Document Tracking</title>

<div id="information_window">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>Double Placement - Document Tracking</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfif get_student_info.doubleplace EQ 0>
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><h2>#get_student_info.studentid# - #get_student_info.firstname# #get_student_info.familylastname#</h2></td></tr>
		<tr><td align="center"><h3>There is no double placement assigned to this student.</h3></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
		<tr><td align="center" width="50%"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
<cfelse>
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td align="center" colspan="3"><h2>#get_student_info.studentid# - #get_student_info.firstname# #get_student_info.familylastname#</h2></td></tr>
		<tr><td colspan="3">
			<cfif client.usertype GTE 5>
				<cfparam name="edit" default="no">
			<cfelse>
				<cfif #cgi.http_referer# NEQ ''><div align="center"><span class="get_Attention">Double Place Docs Updated</span></div></cfif>
				<cfparam name="edit" default="yes">
				<form method="post" name="form" action="../querys/update_double_place_docs.cfm">
			</cfif>
		</td></tr>
		<tr><td align="center" colspan="3"><div align="justify">Please Checkmark the documents which have been received / processed.</div></td></tr>
		<tr> <!-- 1 - Student --->
			<td><Cfif get_student_info.dblplace_doc_stu EQ ''>
					<input type="checkbox" name="check_stu" OnClick="CheckDates('check_stu', 'dblplace_doc_stu');" <cfif edit is 'no'>disabled</cfif>>
				<cfelse>
					<input type="checkbox" name="check_stu" OnClick="CheckDates('check_stu', 'dblplace_doc_stu');" checked <cfif edit is 'no'>disabled</cfif>>		
				</cfif>
			</td>
			<td>Student &nbsp; OK</td>
			<td>Date: &nbsp;<input type="text" name="dblplace_doc_stu" size=8 value="#DateFormat(get_student_info.dblplace_doc_stu, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
		</tr>
		<tr> <!-- 2 - Natural Family ---> 
			<td><Cfif get_student_info.dblplace_doc_fam EQ ''>
					<input type="checkbox" name="check_fam" OnClick="CheckDates('check_fam', 'dblplace_doc_fam');" <cfif edit is 'no'>disabled</cfif>>
				<cfelse>
					<input type="checkbox" name="check_fam" OnClick="CheckDates('check_fam', 'dblplace_doc_fam');" checked <cfif edit is 'no'>disabled</cfif>>		
				</cfif>
			</td>
			<td>Natural Family &nbsp; OK</td>
			<td>Date: &nbsp;<input type="text" name="dblplace_doc_fam" size=8 value="#DateFormat(get_student_info.dblplace_doc_fam, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
		</tr>
		<tr> <!-- 3 - Host Family --->
			<td><Cfif get_student_info.dblplace_doc_host EQ ''>
					<input type="checkbox" name="check_host" OnClick="CheckDates('check_host', 'dblplace_doc_host');" <cfif edit is 'no'>disabled</cfif>>
				<cfelse>
					<input type="checkbox" name="check_host" OnClick="CheckDates('check_host', 'dblplace_doc_host');" checked <cfif edit is 'no'>disabled</cfif>>		
				</cfif>
			</td>
			<td>Host Family &nbsp; OK</td>
			<td>Date: &nbsp;<input type="text" name="dblplace_doc_host" size=8 value="#DateFormat(get_student_info.dblplace_doc_host, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
		</tr>
		<tr> <!-- 4 - School --->
			<td><Cfif get_student_info.dblplace_doc_school EQ ''>
					<input type="checkbox" name="check_school" OnClick="CheckDates('check_school', 'dblplace_doc_school');" <cfif edit is 'no'>disabled</cfif>>
				<cfelse>
					<input type="checkbox" name="check_school" OnClick="CheckDates('check_school', 'dblplace_doc_school');" checked <cfif edit is 'no'>disabled</cfif>>		
				</cfif>
			</td>
			<td>School &nbsp; OK</td>
			<td>Date: &nbsp;<input type="text" name="dblplace_doc_school" size=8 value="#DateFormat(get_student_info.dblplace_doc_school, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
		</tr>
		<tr> <!-- 5 - Department of State --->
			<td><Cfif get_student_info.dblplace_doc_dpt EQ ''>
					<input type="checkbox" name="check_dpt" OnClick="CheckDates('check_dpt', 'dblplace_doc_dpt');" <cfif edit is 'no'>disabled</cfif>>
				<cfelse>
					<input type="checkbox" name="check_dpt" OnClick="CheckDates('check_dpt', 'dblplace_doc_dpt');" checked <cfif edit is 'no'>disabled</cfif>>		
				</cfif>
			</td>
			<td>Department of State &nbsp; OK</td>
			<td>Date: &nbsp;<input type="text" name="dblplace_doc_dpt" size=8 value="#DateFormat(get_student_info.dblplace_doc_dpt, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
		</tr>
		<tr><td colspan="3"><font color="3333CC">Stays with student: &nbsp; #double_student.firstname# #double_student.familylastname# (###double_student.studentid#) from #double_student.countryname#</font></td></tr>
	</table>
		
	<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
		<tr>
			<cfif client.usertype LTE '4'>
				<td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
			</cfif>
			<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		</form>
	</table>
</cfif>

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
<Table width=100% cellpadding=3 cellspacing=0 align="center" class="section">
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
<!--- DOUBLE PLACEMENT DOCS --->

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif"></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>

</cfoutput>
</div>