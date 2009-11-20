<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Placement Management - Supervising Representative</title>
</head>

<body>

<style type="text/css">
<!--
.history {color: #7B848A}
-->
</style>

<!--- <cftry> --->

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- get student info by uniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfquery name="get_available_reps" datasource="mysql">
	SELECT DISTINCT u.userid, u.firstname, u.lastname
	FROM smg_users u
	INNER JOIN user_access_rights uar ON uar.userid = u.userid
	WHERE u.active = '1' 
		AND uar.companyid = '#client.companyid#'
		AND uar.usertype = '7'
	ORDER BY u.lastname
</cfquery>

<cfquery name="rep_info" datasource="mysql">
	SELECT userid, firstname, lastname, address, address2, city, state, zip, phone, email
	FROM smg_users
	WHERE userid = '#get_student_unqid.arearepid#'
</cfquery>

<cfoutput>

<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 bgcolor="##e9ecf1"> 
<tr><td>

<!--- include template page header --->
<cfinclude template="place_menu_header.cfm">

<!--- CHECK CANCELED STUDENT --->
<cfif get_student_unqid.canceldate NEQ ''> 
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center"><b>High School</b></td></tr>
		<tr><td><h3>This student was canceled on #DateFormat(get_student_unqid.canceldate, 'mmm dd, yyyy')#. &nbsp; You can not place them with a school.</h3></td></tr>
		<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp; <input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></font></td></tr>
	</table><br><br>
	<cfabort>
</cfif>

<cfif get_student_unqid.schoolid EQ 0>
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center"><b>Supervising Representative</b></td></tr>
		<tr><td>#get_student_unqid.firstname# #get_student_unqid.familylastname# is not assigned to a school. Please select a school first in order to continue.</td></tr>
		<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp; <input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></font></td></tr>
	</table><br><br>
	<cfabort>
</cfif>

<!---  SELECT SUPERVISING REPRESENTATIVE --->
<cfif NOT IsDefined('url.change')>
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center" colspan="2"><b>Supervising Representative</b></td></tr>
		<!--- SELECT A SUPERVISING REPRESENTATIVE --->
		<cfif get_student_unqid.arearepid EQ 0>
			<cfform action="qr_place_superep.cfm?unqid=#get_student_unqid.uniqueid#" method="post">
			<cfinput type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">
			<tr><td colspan="2">The following Supervising Representatives are available for this student:</td></tr>
			<tr><td>				
			<cfselect name="arearepid">
				<option value="0"></option>
				<cfloop query="get_available_reps">
					<option value="#userid#">#firstname# #lastname# (#userid#)</option>			
				</cfloop>
			</cfselect>
			</td></tr>
			<Tr>
				<td align="center" width="50%"><input name="submit" type="image" src="../pics/update.gif" align="right" border=0></td>
				<td align="center" width="50%"><input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></td>
			</tr>
			</cfform>
		<!--- STUDENT IS ASSIGNED TO A SUPERVISING REPRESENTATIVE --->
		<cfelse>
			<cfif rep_info.recordcount is '0'>	
				<tr><td colspan="2">Supervising Representative (#get_student_unqid.placerepid#) was not found in the system.</td></tr>
			<cfelse>
				<tr><td colspan="2">
					#rep_info.firstname# #rep_info.lastname# (###rep_info.userid#)
					#rep_info.address#<br>
					<cfif rep_info.address2 NEQ ''>#rep_info.address2#<br></cfif>
					#rep_info.city# #rep_info.state#, #rep_info.zip#<br>
					Phone: #rep_info.phone#<br>
					Email: <a href="mailto:#rep_info.email#">#rep_info.email#</a><br>
				</td></tr>
			</cfif>
			<cfform action="place_superep.cfm?unqid=#get_student_unqid.uniqueid#&change=yes"  method="post">
			<Tr>
				<td align="center" width="50%"><input name="submit" type="image" src="../pics/update.gif" align="right" border=0></td>
				<td align="center" width="50%"><input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></td>
			</tr>
			</cfform>
		</cfif>
	</table><br><br>

<!--- UPDATE/CHANGE CURRENT REP --->
<cfelse>
<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
<cfquery name="rep_info" datasource="MySQL">
			SELECT  smg_users.userid, smg_users.firstname, smg_users.lastname, smg_users.address, smg_users.address2, smg_users.city, smg_users.state, smg_users.zip, smg_users.phone, smg_users.email, smg_states.state as statename
			FROM smg_users
			left join smg_states on smg_states.id = smg_users.state
			WHERE userid = #get_student_unqid.arearepid#
		</cfquery>
		<cfoutput>
			<cfif rep_info.recordcount is '0'>
			<tr><td><font color="CC3300">Placing Rep. (#get_student_info.placerepid#) was not found in the system.</font></td></tr>
			<cfelse>
			
				<tr><td>			
				Rep who is supervising:<br>
				#rep_info.firstname# #rep_info.lastname# (#rep_info.userid#) &nbsp; [edit]<br>
				#rep_info.address#<br>
				<cfif #rep_info.address2# is ''><cfelse>#rep_info.address2#<br></cfif>
				#rep_info.city# #rep_info.statename#, #rep_info.zip#<br>
				#rep_info.phone#<br>
				<a href="mailto:#rep_info.email#">#rep_info.email#</a><br>
				</td></tr>
			
			</cfif>
		</cfoutput>
		<cfform action="place_change_superep.cfm?unqid=#url.unqid#"  method="post">
			<table width="580" align="center">
			<Tr>
				<td align="right" width="50%"><font size=-1><br>
					<input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;</td>
				<td align="left" width="50%"><font size=-1><Br>&nbsp;&nbsp;
					<input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></td>
			</tr>
			</table><br>
		</cfform>


	
	</table><br><br>


		
</cfif>

</td></tr>
</table>

</cfoutput>

<!--- <cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
 --->

</body>
</html>
