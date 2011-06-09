<link rel="stylesheet" href="../smg.css" type="text/css">
<Title>Host Family Information</title>

<script language="JavaScript">
<!--
function areYouSure() { 
   if(confirm("You are about to update this host family to PERMANENT. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
// -->
</script>


<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="check_cancel" datasource="mysql">
	select canceldate
	from smg_students
	where studentid = #client.studentid#
</cfquery>

<cfquery name="get_region_assigned" datasource="MySQL">
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

<cfoutput>

<table width="580" align="center">
	<tr><td><span class="application_section_header">Host Family</span></td></tr>
</table><br>

<div class="row">

<!--- CHECK CANCELED STUDENT --->
<cfif check_cancel.canceldate NEQ ''> 
	<table width="580" align="center">
		<tr><td><h3>This student was canceled on #DateFormat(canceldate, 'mmm dd, yyyy')#. &nbsp; You can not place them with a family</h3></td></tr>
		<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
	</table>
	<cfabort>
</cfif>

<!--- CHECK IF THERE'S A REGION ASSIGNED TO THE STUDENT --->
<cfif get_student_info.regionassigned EQ 0> 
	<table width="580" align="center">
		<tr><td>
			<div align="justify">The student must be assigned to a region before you can place them with a host family.<br><br>
			To assign the student a region, close this window and select the region from the drop down menu next to: 'Assigned to Region:' then click on 
			update.  You can then click on 'Host Family' and you will be able to select on of the familys in that region who is available to host a student.</div><br><br>
			<div align="center"><input type="image" value="close window" src="pics/close.gif" onClick="javascript:window.close()"></div>
			</td>
		</tr>
	</table>
	<cfabort>
</cfif>
		
<cfquery name="get_available_hosts" datasource="MySQL">
	SELECT hostid, familylastname, fatherfirstname, motherfirstname, fatherlastname, motherlastname
	FROM smg_hosts
	WHERE regionid = #get_student_info.regionassigned# AND active = '1'
	ORDER BY familylastname
</cfquery>

<cfif get_student_info.hostid EQ 0>
	<table width="580" align="center">
		<tr><td>	
			<div align="center">#get_student_info.firstname# has not been placed as of #DateFormat(now(), 'ddd. mmm. d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')# </div><br>
			The following families in the #get_region_assigned.regionname# are available to host a student: 
		</td></tr>
	</table>
	<cfform action="../querys/update_place_host.cfm?studentid=#client.studentid#&hostid=#get_student_info.hostid#" method="post">
	<table width="580" align="center">
		<tr><td colspan="2">				
				<cfselect name="available_families">
					<option value="0"></option>
					<cfloop query="get_Available_hosts">
					<option value=#hostid#>			
					<cfif fatherfirstname is not ''>#fatherfirstname# 
						<cfif fatherlastname is not familylastname>#fatherlastname#</cfif>
					</cfif>
					<cfif fatherfirstname is not '' and motherfirstname is not ''> and </cfif>
					<cfif motherfirstname is not ''>#motherfirstname#
							<cfif motherlastname is not familylastname>#motherlastname#</cfif> 
					</cfif>
					<cfif motherlastname is familylastname or fatherlastname is familylastname>#familylastname#</cfif>
					&nbsp; (###hostid#)
					</option>
					</cfloop>
				</cfselect>
			</td>
		</tr>
		<tr><td width="30%">Is this a Welcome Family?</td><td><cfinput type="radio" value="0" name="welcome_family" required="yes" message="Please answer both questions">No &nbsp;<cfinput type="radio" value="1" name="welcome_family" required="yes" message="Please answer both questions">Yes</td></tr>
	</table><br>
	<table width="580" align="center">
		<tr>
			<td align="right" width="50%"><br><input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;</td>
			<td align="left" width="50%"><br>&nbsp;&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
		</tr>
	</table>
	</cfform>
	<cfabort>
</cfif>

<cfquery name="host_info" datasource="MySQL">
	SELECT  hostid, familylastname, fatherfirstname, fatherlastname, motherfirstname, motherlastname, address, address2, 
	city, state, zip, phone, email 
	FROM smg_hosts 
	WHERE hostid = #get_student_info.hostid#
</cfquery>	
	
<cfif host_info.recordcount is '0'> <!--- there's no longer this host in the system --->
	<table width="580" align="center"><tr><td><font color="CC3300">Host Family (#get_student_info.hostid#) was not found in the system.</font></td></tr></table>
	<cfabort>
</cfif>

<table width="580" align="center">
	<!--- Welcome Family --->
	<cfif get_student_info.welcome_family EQ 1 AND client.usertype LTE 4>
		<tr><th>*** This is a WELCOME FAMILY ***</th></tr>
		<tr><td align="center"><a href="place_host_perm.cfm?studentid=#studentid#" onclick="return areYouSure(this);">Update this family to PERMANENT</a><br /><br /></td></tr>
	</cfif>	
	<tr>
		<td>
			#host_info.fatherfirstname# <cfif #host_info.motherlastname# is #host_info.fatherlastname#><cfelse>#host_info.fatherlastname#</cfif>
				and #host_info.motherfirstname#<cfif #host_info.motherlastname# is #host_info.fatherlastname#> #host_info.familylastname#<cfelse> #host_info.motherlastname#</cfif>&nbsp;(#host_info.hostid#) &nbsp;  
				<cfif client.usertype LTE 4>[ <A href="../index.cfm?curdoc=host_fam_info&hostid=#get_student_info.hostid#" target="_blank">edit</A> ]</cfif><br>
			#host_info.address#<br>
			<cfif #host_info.address2# is ''><cfelse>#host_info.address2#<br></cfif>
			#host_info.city# #host_info.state#, #host_info.zip#<br>
			#host_info.phone#<br>
			<a href="mailto:#host_info.email#">#host_info.email#</a><br>
			<font size=-1>#get_student_info.firstname# was placed on #DateFormat(get_student_info.dateplaced, 'ddd. mmm. d, yyyy')# at #TimeFormat(get_student_info.dateplaced, 'h:mm:ss tt')#</font>
		</td>
	</tr>
</table>

<!--- Check if student is active --->
<cfif VAL(get_student_info.active)>

    <cfform action="place_change_host.cfm?studentid=#client.studentid#"  method="post">
        <table width="580" align="center">
            <Tr>
                <td align="right" width="50%"><br>
                <CFIF client.usertype LTE 7><input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;</cfif></td>
                <td align="left" width="50%"><Br>&nbsp;&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
            </tr>
        </table><br>
    </cfform>

</cfif>
<!--- End of Check if student is active --->

<table width="580" align="center">
<tr>
	<td>
		<cfif #get_student_info.doc_full_host_app_date # is ''>
			<img src="../pics/redx.gif" width="25" height="23">
		<cfelse>
			<img src="../pics/green_check.gif" width="18" height="17">
		</cfif> Application Received
	</td>
	<Td>
		<cfif #get_student_info.doc_letter_rec_date# is ''>
			<img src="../pics/redx.gif" width="25" height="23">
		<cfelse>
			<img src="../pics/green_check.gif" width="18" height="17">
		</cfif> Letter Received</Td>
	<Td>
		<cfif #get_student_info.doc_photos_rec_date# is ''>
			<img src="../pics/redx.gif" width="25" height="23">
		<cfelse>
			<img src="../pics/green_check.gif" width="18" height="17">
		</cfif> Pictures Received
	</Td>
</tr>
</table></p>

<!--- HOST HISTORY --->
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
	<cfloop query="placement_history">
		<tr bgcolor="D5DCE5"><td colspan="3">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')#</td></tr>
			<tr><td width="175"><u>Host Fam.</u></td>
			<td width="230"><u>Reason</u></td>
			<td width="175"><u>Changed By</u></td></tr>
		<tr bgcolor="#iif(placement_history.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td>#familylastname# (#hostid#)</td>
			<td>#reason#</td>
			<td>#firstname# #lastname# (#userid#)</td></tr>
	</cfloop>
</table>
</cfif><br> <!--- HOST HISTORY IF --->
</div>

</cfoutput>