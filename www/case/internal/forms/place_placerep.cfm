<link rel="stylesheet" href="../smg.css" type="text/css">
<Title>Placing Representative Information</title>

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="check_cancel" datasource="caseusa">
	select canceldate
	from smg_students
	where studentid = #client.studentid#
</cfquery>

<cfquery name="get_region_assigned" datasource="caseusa">
	SELECT regionname
	FROM smg_regions
	WHERE regionid = #get_student_info.regionassigned#
</cfquery>

<style type="text/css">
<!--
.history {color: #7B848A}
-->
</style>

<!--- include template page header --->
<cfinclude template="placement_status_header.cfm">

<table width="580" align="center">
<tr><td><span class="application_section_header">Placing Representative</span></td></tr>
</table><br>

<div class="row">
<!--- CHECK CANCELED STUDENT --->
<cfif #check_Cancel.canceldate# is not ''> 
	<table width="580" align="center">
	<tr><td>	
	<cfoutput query="check_Cancel">
		<h3>This student was canceled on #DateFormat(canceldate, 'mmm dd, yyyy')#. &nbsp; You can not supervise them.</h3>
	</td></tr>
	<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp;
					<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
	</table>
	</cfoutput>
	<cfabort>
</cfif>


<cfif #get_student_info.hostid# is 0 or #get_student_info.schoolid# is 0>
	<cfoutput>
	<table width="580" align="center">
	<tr><td align="center"><h3>There is no host family and / or School assigned to this student.</h3></td></tr>
	<tr><td align="center"><h3>You cannot add a Placing Rep without these information. Please make sure that the HF and school were entered.</h3></td></tr>
	</table>
	<br>
	<table width="580" align="center">
	<tr><td align="center">
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
		</td></tr>
	</table>
	</cfoutput>	

<cfelse>  <!--- unplaced --->
	
	<!--- get reps for students region --->
	<cfinclude template="../querys/get_available_reps.cfm">
	
	<cfif #get_student_info.placerepid# is 0> <!--- PLACE REP --->
		<table width="580" align="center">
		<tr><td>	
		<cfoutput>The following Reps in #get_region_assigned.regionname# region are available for this student:</cfoutput>
		</td></tr>
		</table>
		
		<cfform action="../querys/update_place_placerep.cfm?studentid=#client.studentid#" method="post">
			<table width="580" align="center">
			<tr><td>				
			<cfselect name="placerepid">
				<option value="0"></option>
				<cfoutput query="get_available_reps">
						<option value=#userid#>#firstname# #lastname# (#userid#)</option>
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
	<cfelse> <!--- STUDENT HAS ALREADY A PLACING REP --->	
			<cfquery name="rep_info" datasource="caseusa">
			SELECT  userid, firstname, lastname, address, address2, city, state, zip, phone, email
			FROM smg_users
			WHERE userid = #get_student_info.placerepid#
		</cfquery>
		<cfoutput>
			<cfif rep_info.recordcount is '0'>
				<table width="580" align="center"><tr><td><font color="CC3300">Placing Rep. (#get_student_info.placerepid#) was not found in the system.</font></td></tr></table>
			<cfelse>
				<table width="580" align="center">
				<tr><td>			
				Rep who made the placement:<br>
				#rep_info.firstname# #rep_info.lastname# (#rep_info.userid#) &nbsp; [edit]<br>
				#rep_info.address#<br>
				<cfif #rep_info.address2# is ''><cfelse>#rep_info.address2#<br></cfif>
				#rep_info.city# #rep_info.state#, #rep_info.zip#<br>
				#rep_info.phone#<br>
				<a href="mailto:#rep_info.email#">#rep_info.email#</a><br>
				</td></tr>
				</table>
			</cfif>
		</cfoutput>
		<cfform action="place_change_placerep.cfm?studentid=#client.studentid#"  method="post">
			<table width="580" align="center">
			<Tr>
				<td align="right" width="50%"><font size=-1><br>
					<input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;</td>
				<td align="left" width="50%"><font size=-1><Br>&nbsp;&nbsp;
					<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
			</tr>
			</table><br>
		</cfform>
	</cfif> <!--- Supervising REP --->
</cfif> <!--- UNPLACED --->

<!--- PLACING HISTORY --->
<cfquery name="placing_history" datasource="caseusa">
	SELECT hostid, reason, studentid, dateofchange, arearepid, placerepid,
		user.firstname, user.lastname, user.city, user.userid,
		u.firstname as changefirstname, u.lastname as changelastname, u.userid as changeid
	FROM smg_hosthistory
	INNER JOIN smg_users user ON user.userid = placerepid
	INNER JOIN smg_users u ON u.userid = changedby
	WHERE studentid = '#client.studentid#' AND hostid = 0 AND schoolid = 0 AND arearepid = 0
	ORDER BY dateofchange desc	
</cfquery>
	
<!--- PLACE HISTORY IF --->
<Cfif placing_history.recordcount is not 0> 
	<Table width=580 cellpadding=3 cellspacing=0 align="center" class="history">
		<tr><td colspan="3" align="center"><font color="a8a8a8">P L A C I N G &nbsp; H I S T O R Y </font><br><br></td></tr>
	<cfoutput query="placing_history">
		<tr bgcolor="D5DCE5"><td colspan="3">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')#</td></tr>
		<tr><td width="175"><u>Placing Rep.</u></td>
			<td width="230"><u>Reason</u></td>
			<td width="175"><u>Changed By</u></td></tr>
		<tr bgcolor="#iif(placing_history.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td>#firstname# #lastname# (#userid#)</td>
			<td>#reason#</td>
			<td>#changefirstname# #changelastname# (#changeid#)</td></tr>		
	</cfoutput>
	</table>
</cfif><br> <!--- PLACE HISTORY IF --->
</div>