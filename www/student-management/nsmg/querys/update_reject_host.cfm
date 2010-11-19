<link rel="stylesheet" href="../smg.css" type="text/css">

<cfinclude template="../querys/get_student_info.cfm">
<cfinclude template = "../forms/placement_reject_header.cfm">

<!--- GETS THE PLACE REP --->
<cfquery name="get_rep_name" datasource="MySQL">
	SELECT firstname, lastname, email
	FROM smg_users
	WHERE userid = #get_student_info.placerepid#
</cfquery>
<!--- GETS THE REG DIR --->
<cfquery name="get_regDir" datasource="MySQL">
	SELECT firstname, lastname, email
	FROM smg_users
	WHERE usertype = '5' AND regions = #get_student_info.regionassigned#
</cfquery>

<cfset rep = "#get_rep_name.firstname# #get_rep_name.lastname#">
<cfset mailto = "#get_rep_name.email#">


<!-- cfmail to ="#james@student-management.com#" cc="#get_regDir.email#" from=#client.email# subject="Placement Rejected"-->
<cfmail to="#get_rep_name.email#" cc="#get_regDir.email#" FROM="""SMG Support"" <support@student-management.com>" subject="Placement Rejected" >
#rep#,

The placement for #get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#) has been rejected.  
Below are the items that need to be addressed before #get_student_info.firstname# can be placed:

#form.reason#

A copy of this message has also be sent to regional director:  #get_regDir.firstname# #get_regDir.lastname#


</cfmail>
<cfoutput>
		<table width="580" align="center">
			<tr><td>Your message has been sent to #rep# at #get_rep_name.email#.</td></tr>
			<tr><td>An email has also been sent to regional director: #get_regDir.firstname# #get_regDir.lastname# @ #get_regDir.email#</td></tr>
							 
			<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onclick ="window.close()"></td></tr>
		</table><br>			  

</cfoutput>
<cfquery name="host_history" datasource="MySQL"> 
					INSERT INTO smg_hosthistory	(hostid, 
												studentid, 
												reason, 
												dateofchange, 
												arearepid, 
												placerepid, 
												schoolid, 
												changedby)
										VALUES
											('#get_student_info.hostid#', 
											'#get_student_info.studentid#', 
											'#form.reason#',
					 						#CreateODBCDateTime(now())#, 
											'#get_student_info.arearepid#', 
											'#get_student_info.placerepid#', 
											'#get_student_info.schoolid#', 
											'#client.userid#')
</cfquery>

<cfquery name ="update_host_fam_approved" datasource ="MySQL">
					UPDATE smg_students 
					SET  host_fam_approved ='99'
					WHERE studentid = '#get_student_info.studentid#' 
					LIMIT 1
</cfquery> 		 

		
<cfquery name="placement_history" datasource="MySQL">
	SELECT history.hostid, history.reason, history.studentid, history.dateofchange,	history.arearepid, history.placerepid,
			history.changedby,
			h.familylastname, h.hostid,
			u.firstname, u.lastname, u.userid
	FROM smg_hosthistory history
	INNER JOIN smg_hosts h ON h.hostid = history.hostid
	INNER JOIN smg_users u ON u.userid = history.changedby
	WHERE history.studentid = '#client.studentid#' AND history.schoolid = 0 AND history.arearepid = 0 AND history.placerepid = 0
	ORDER BY history.dateofchange desc
</cfquery>

<!--- HOST HISTORY IF --->
<Cfif placement_history.recordcount is not 0> 
<Table width=580 cellpadding=3 cellspacing=0 align="center" class="history">
	<tr><td colspan="3" align="center"><font color="a8a8a8">H O S T &nbsp; H I S T O R Y </font><br><br></td></tr>
	
	<cfoutput query="placement_history">
		<tr bgcolor="D5DCE5"><td colspan="3">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')#</td></tr>
			<tr><td width="175"><u>Host Fam.</u></td>
			<td width="230"><u>Reason</u></td>
			<td width="175"><u>Changed By</u></td></tr>
		<tr bgcolor="#iif(placement_history.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td>#familylastname# (#hostid#)</td>
			<td>#form.reason#</td>
			<td>#firstname# #lastname# (#userid#)</td></tr>
	</cfoutput>
</table>
</cfif><br> 
<!--- HOST HISTORY IF --->
	