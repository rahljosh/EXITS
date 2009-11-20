<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Placement Management - High School</title>
</head>

<body>

<style type="text/css">
<!--
.history {color: #7B848A}
-->
</style>

<cftry>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- get student info by uniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfoutput>

<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 bgcolor="##e9ecf1"> 
<tr><td>

<!--- include template page header --->
<cfinclude template="place_menu_header.cfm">

<!--- CHECK CANCELED STUDENT --->
<cfif get_student_unqid.canceldate NEQ ''> 
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center"><b>High School</b></td></tr>
		<tr><td>#get_student_unqid.firstname# #get_student_unqid.familylastname# was canceled on #DateFormat(get_student_unqid.canceldate, 'mmm dd, yyyy')#. &nbsp; You can not place them with a school.</td></tr>
		<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp; <input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></font></td></tr>
	</table><br><br>
	<cfabort>
</cfif>

<cfquery name="get_available_schools" datasource="mysql">
	SELECT schoolid, schoolname, boarding_school
	FROM php_schools
	ORDER BY schoolname
</cfquery>

<cfquery name="school_info" datasource="mysql">
	SELECT  schoolid, schoolname, address, address2, city, state, zip, phone, contact, email, boarding_school
	FROM php_schools
	WHERE schoolid = '#get_student_unqid.schoolid#'
</cfquery>

<!---  SELECT NEW SCHOOL --->
<cfif NOT IsDefined('url.change')>
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center" colspan="2"><b>High School</b></td></tr>
		<cfif get_student_unqid.schoolid EQ 0> <!--- PLACE A SCHOOL --->
			<cfform action="qr_place_school.cfm?unqid=#get_student_unqid.uniqueid#" method="post">
			<cfinput type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">
			<tr><td>The following schools are available for this student:</td></tr>
			<tr><td>				
			<cfselect name="schoolid">
				<option value="0"></option>
				<cfloop query="get_available_schools">
				<option value=#schoolid#>#schoolname# (###schoolid#)</option>
				</cfloop>
			</cfselect>
			</td></tr>
			<Tr>
				<td align="center" width="50%"><input name="submit" type="image" src="../pics/update.gif" align="right" border=0></td>
				<td align="center" width="50%"><input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></td>
			</tr>
			</cfform>
		<!--- STUDENT IS ASSIGNED TO A SCHOOL --->
		<cfelse> 
			<cfif school_info.recordcount is '0'>	
				<tr><td colspan="2">School (#get_student_unqid.schoolid#) was not found in the system.</td></tr>
			<cfelse>
				<tr><td colspan="2">			
					School: #school_info.schoolname# (###school_info.schoolid#) &nbsp; [ <A href="../index.cfm?curdoc=forms/view_school&sc=#school_info.schoolid#" target="_blank">edit</A> ]<br>
					#school_info.address#<br>
					<cfif #school_info.address2# is ''><cfelse>#school_info.address2#<br></cfif>
					#school_info.city# #school_info.state#, #school_info.zip#<br>
					#school_info.phone#<br>
					Principal: #school_info.contact#<br>
					Boarding: <cfif school_info.boarding_school eq 1>
								The school is a boarding school, no host family needed.
							<cfelseif school_info.boarding_school eq 0>
								The school is not a boarding school student needs to be placed with a host family.
							<cfelseif school_info.boarding_school eq 2>
								Both
							<cfelse>
								School has not been verified if it is or is not a boarding schoool. Please check school record.
							</cfif><br>
					<a href="mailto:#school_info.email#">#school_info.email#</a><br>
					year beg: <!--- #DateFormat(school_info.begins, 'mm/dd/yy')# ---> sem end:  sem start:  year end: 
				</td></tr>
			</cfif>
			<cfform action="place_school.cfm?unqid=#get_student_unqid.uniqueid#&change=yes" method="post">
			<Tr>
				<td align="center" width="50%"><input name="submit" type="image" src="../pics/update.gif" align="right" border=0></td>
				<td align="center" width="50%"><input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></td>
			</tr>
			</cfform>
		</cfif>
	</table><br><br>

<!--- UPDATE/CHANGE CURRENT SCHOOL --->
<cfelse>

	<cfform action="qr_place_school.cfm?unqid=#get_student_unqid.uniqueid#&change=yes" method="post">
	<cfinput type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center" colspan="2"><b>Change High School</b></td></tr>
		<tr><td>The following schools are available for this student:</td></tr>
		<tr><td><cfselect name="schoolid">
					<option value="0">Set to unplaced</option>
					<cfloop query="get_available_schools">
					<option value="#schoolid#">#schoolname# (###schoolid#)</option>
					</cfloop>
				</cfselect>
		</td></tr>
		<tr><td>Please indicate why you are changing the school:<br>
				<textarea cols=50 rows=7 name="reason"></textarea>
		</td></tr>
		<Tr>
			<td colspan="2" align="center" width="100%"><input name="submit" type="image" src="../pics/update.gif" border=0> 
			&nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; 
			<input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></td>
		</tr>
	</table><br><br>
	</cfform>
	
</cfif>

<!--- SCHOOL HISTORY --->
<cfquery name="school_history" datasource="mysql">
	SELECT hostid, reason, studentid, dateofchange,	arearepid, placerepid, changedby,
		sc.schoolname, sc.city, sc.state, sc.schoolid as school,
		u.firstname, u.lastname, u.userid
	FROM smg_hosthistory
	INNER JOIN php_schools sc ON sc.schoolid = smg_hosthistory.schoolid
	LEFT JOIN smg_users u ON u.userid = changedby
	WHERE studentid = '#get_student_unqid.studentid#' 
		AND hostid = '0' 
		AND arearepid = '0' 
		AND placerepid = '0'
	ORDER BY dateofchange desc
</cfquery>
	
<Cfif school_history.recordcount is not 0> 
	<Table width=580 cellpadding=3 cellspacing=0 align="center" class="history">
		<tr><td colspan="3" align="center"><font color="a8a8a8">S C H O O L &nbsp; H I S T O R Y</font><br><br></td></tr>
	<cfloop query="school_history">
		<tr bgcolor="D5DCE5"><td colspan="3">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')#</td></tr>
		<tr><td width="175"><u>High School</u></td>
			<td width="230"><u>Reason</u></td>
			<td width="175"><u>Changed By</u></td></tr>
		<tr bgcolor="#iif(school_history.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td>#schoolname# (#school#)</td>
			<td>#reason#</td>
			<td>#firstname# #lastname# (#userid#)</td></tr>		
	</cfloop>
	</table><br><br>
</cfif>

</td></tr>
</table>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>