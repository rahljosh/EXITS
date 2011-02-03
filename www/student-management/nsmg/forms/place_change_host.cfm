<link rel="stylesheet" href="smg.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_region_assigned" datasource="MySQL">
	SELECT regionname
	FROM smg_regions
	WHERE regionid = #get_student_info.regionassigned#
</cfquery>

<cfquery name="get_Available_hosts" datasource="MySQL">
	select hostid, familylastname, fatherfirstname, motherfirstname, fatherlastname, motherlastname
	from smg_hosts
	where regionid = #get_student_info.regionassigned#  AND active = '1'
	ORDER BY Familylastname
</cfquery>

<!--- include template page header --->
<cfinclude template="placement_status_header.cfm">

<cfoutput>
<table width="580" align="center">
	<tr><td><span class="application_section_header">Change Host Family</span></td></tr>
</table>

<div class="row">
<cfform action="../querys/update_change_host.cfm?studentid=#client.studentid#" method="post">
<table width="580" align="center" cellpadding="4">
	<tr><td colspan="2">The following families in the #get_region_assigned.regionname# are available to host a student:</td></tr>
	<tr><td colspan="2">	
			<select name="available_families">
				<option value=0>Change to unplaced</option>
				<cfloop query="get_Available_hosts">
					<option value="#hostid#">			
					<cfif fatherfirstname NEQ ''>#fatherfirstname# 
						<cfif fatherlastname NEQ familylastname>#fatherlastname#</cfif>
					</cfif>
					<cfif fatherfirstname NEQ '' and motherfirstname NEQ ''> and </cfif>
					<cfif motherfirstname NEQ ''>#motherfirstname#
							<cfif motherlastname NEQ familylastname>#motherlastname#</cfif> 
					</cfif>
					<cfif motherlastname is familylastname or fatherlastname is familylastname>#familylastname#</cfif>
					&nbsp; (###hostid#)
					</option>	
				</cfloop>
			</select>
		</td>
	</tr>
	<tr><td colspan="2">Please indicate why you are changing the host family:</td></tr>
	<tr><td colspan="2">	
			<cfselect name="reason">
				<option value="0">Select a Reason</option>
				<option value="Incompatibility with host family">Incompatibility with host family</option>
				<option value="Conflict with host sibling">Conflict with host sibling</option>
				<option value="Incompatibility with school">Incompatibility with school</option>
				<option value="Host family change of situation (e.g., move, illness, etc.)">Host family change of situation (e.g., move, illness, etc.)</option>
				<option value="Move from welcome family to permanent family">Move from welcome family to permanent family</option>
                <option value="Paperwork was not submitted in a timely fashion">Paperwork was not submitted in a timely fashion</option>
                
				<option value="Other">Other</option>				
			</cfselect>
		</td>
	</tr>
	<tr><td width="30%">Is this a Welcome Family? </td><td><cfinput type="radio" value="0" name="welcome_family" required="yes" message="Please answer both questions">No &nbsp;<cfinput type="radio" value="1" name="welcome_family" required="yes" message="Please answer both questions">Yes</td></tr>
	<tr><td>Is this a Relocation? </td><td><cfinput type="radio" value="no" name="relocation" required="yes" message="Please answer both questions">No &nbsp;<cfinput type="radio" value="yes" name="relocation" required="yes" message="Please answer both questions">Yes</td></tr>
</table><br>

<table width="580" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td align="right" width="50%"><input name="submit" type="image" src="../pics/update.gif" align="right" border=0> &nbsp; &nbsp;</td>
		<td align="left" width="50%">&nbsp; &nbsp; <input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
</cfform>
</div>
</cfoutput>