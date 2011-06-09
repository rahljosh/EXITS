<link rel="stylesheet" href="../smg.css" type="text/css">
<Title>High School Information</title>

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="check_cancel" datasource="mysql">
	select canceldate
	from smg_students
	where studentid = #client.studentid#
</cfquery>

<style type="text/css">
<!--
.history {color: #7B848A}
-->
</style>

<!--- include template page header --->
<cfinclude template="placement_status_header.cfm">

<table width="580" align="center">
<tr><td><span class="application_section_header">High School</span></td></tr>
</table><br>

<div class="row">
<!--- CHECK CANCELED STUDENT --->
<cfif #check_Cancel.canceldate# is not ''> 
	<table width="580" align="center">
	<tr><td>	
	<cfoutput query="check_Cancel">
		<h3>This student was canceled on #DateFormat(canceldate, 'mmm dd, yyyy')#. &nbsp; You can not place them with a school.</h3>
	</td></tr>
	<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp;
					<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
	</table>
	</cfoutput>
	<cfabort>
</cfif>

<cfif #get_student_info.hostid# is 0>
	<cfoutput>
	<table width="580" align="center">
	<tr><td align="center"><h3>There is no host family assigned to this student.</h3></td></tr>
	<tr><td align="center"><h3>You cannot add a school without a host family. Please add a host family first.</h3></td></tr>
	</table>
	<br>
	<table width="580" align="center">
	<tr><td align="center">
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
		</td></tr>
	</table>
	</cfoutput>

<cfelse>  <!--- unplaced --->

	<cfquery name="get_host_state" datasource="MySql">
	SELECT state
	FROM smg_hosts
	WHERE hostid = '#get_student_info.hostid#'
	</cfquery>
	
	<cfquery name="get_available_schools" datasource="MySQL">
	SELECT *
	FROM smg_schools
	WHERE state = '#get_host_state.state#'
	ORDER BY schoolname
	</cfquery>
	
	<cfif #get_student_info.schoolID# is 0> <!--- PLACE A SCHOOL --->
		<table width="580" align="center">
		<tr><td>	
		<cfoutput>The following schools in the state of #get_host_state.state# are available for this student:</cfoutput>
		</td></tr>
		</table>
		<cfform action="../querys/update_place_school.cfm?studentid=#client.studentid#" method="post">
			<table width="580" align="center">
			<tr><td>				
			<cfselect name="schoolID">
				<option value="0"></option>
				<cfoutput query="get_available_schools">
				<option value=#schoolID#>#schoolname# (#schoolID#) </option>
				</cfoutput>
			</cfselect>
			</td></tr>
			</table><br>
			<table width="580" align="center">
				<tr>
				<td align="right" width="50%"><br>
				<input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;</td><td align="left" width="50%"><br>&nbsp;&nbsp;
				<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
				</tr>
			</table>
		</cfform>
	
	<cfelse> <!--- STUDENT HAS ALREADY A SCHOOL --->
		<cfquery name="school_info" datasource="MySQL">
			SELECT  schoolID, schoolname, address, address2, city, state, zip, phone, principal, email, begins, semesterends, semesterbegins, ends
			FROM smg_schools
			WHERE schoolID = #get_student_info.schoolID#
		</cfquery>
		<cfoutput>
			<cfif school_info.recordcount is '0'>	
				<table width="580" align="center"><tr><td><font color="CC3300">School (#get_student_info.schoolID#) was not found in the system.</font></td></tr></table>
			<cfelse>
				<table width="580" align="center">
				<tr><td>			
				School: #school_info.schoolname# (#school_info.schoolID#) &nbsp; <cfif client.usertype LTE 4> [ <A href="../index.cfm?curdoc=forms/school_form&schoolID=#get_student_info.schoolID#" target="_blank">edit</A> ] </cfif><br>
				#school_info.address#<br>
				<cfif #school_info.address2# is ''><cfelse>#school_info.address2#<br></cfif>
				#school_info.city# #school_info.state#, #school_info.zip#<br>
				#school_info.phone#<br>
				Principal: #school_info.principal#<br>
				<a href="mailto:#school_info.email#">#school_info.email#</a><br>
				year beg: #DateFormat(school_info.begins, 'mm/dd/yy')# sem end: #DateFormat(school_info.semesterends, 'mm/dd/yy')# sem start:#DateFormat(school_info.semesterbegins, 'mm/dd/yy')#  year end: #DateFormat(school_info.ends, 'mm/dd/yy')#
				</td></tr>
				</table>
			</cfif>
		</cfoutput>
        
		<!--- Check if student is active --->
        <cfif VAL(get_student_info.active)>

            <cfform action="place_change_school.cfm?studentid=#client.studentid#"  method="post">
                <table width="580" align="center">
                <Tr>
                    <td align="right" width="50%"><br>
                        <input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;
                    </td>
                    <td align="left" width="50%"><Br>&nbsp;&nbsp;
                        <input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
                    </td>
                </tr>
                </table><br>
            </cfform>
		
        </cfif>   
		<!--- End of Check if student is active --->
        
	</cfif> <!--- #get_student_info.school# is 0 --->

</cfif> <!--- unplaced --->

<!--- SCHOOL HISTORY --->
<cfquery name="school_history" datasource="MySQL">
	SELECT hostid, reason, studentid, dateofchange,	arearepid, placerepid, changedby,
		sc.schoolname, sc.city, sc.state, sc.schoolID as school,
		u.firstname, u.lastname, u.userid
	FROM smg_hosthistory
	INNER JOIN smg_schools sc ON sc.schoolID = smg_hosthistory.schoolID
	INNER JOIN smg_users u ON u.userid = changedby
	WHERE studentid = '#client.studentid#' AND hostid = 0 AND arearepid = 0 AND placerepid = 0
	ORDER BY dateofchange desc
</cfquery>
	
<!--- SCHOOL HISTORY IF --->
<Cfif school_history.recordcount is not 0> 
	<Table width=580 cellpadding=3 cellspacing=0 align="center" class="history">
		<tr><td colspan="3" align="center"><font color="a8a8a8">S C H O O L &nbsp; H I S T O R Y</font><br><br></td></tr>
	<cfoutput query="school_history">
		<tr bgcolor="D5DCE5"><td colspan="3">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')#</td></tr>
		<tr><td width="175"><u>High School</u></td>
			<td width="230"><u>Reason</u></td>
			<td width="175"><u>Changed By</u></td></tr>
		<tr bgcolor="#iif(school_history.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td>#schoolname# (#school#)</td>
			<td>#reason#</td>
			<td>#firstname# #lastname# (#userid#)</td></tr>		
	</cfoutput>
	</table>
</cfif><br> <!--- SCHOOL HISTORY IF --->
</div>