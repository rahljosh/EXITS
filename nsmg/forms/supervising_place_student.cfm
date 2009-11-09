<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.form.get_placeid.options[document.form.get_placeid.selectedIndex].value;
window.location.href = URL;
}
function formHandler2(form){
var URL = document.form.get_superid.options[document.form.get_superid.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<cfif not IsDefined('url.studentid') AND not IsDefined('form.studentid')>
	<cfinclude template="error_message.cfm">
</cfif>

<cfif IsDefined('form.studentid')>
	<cfset url.studentid = '#form.studentid#'>
</cfif>

<cfquery name="payment_super_type" datasource="MySQL">
	SELECT type, id
	FROM smg_payment_types 
	WHERE active = '1' AND (paymenttype = 'Supervision' or paymenttype = '')
</cfquery>

<cfquery name="payment_place_type" datasource="MySQL">
	SELECT type, id
	FROM smg_payment_types 
	WHERE active = '1' AND (paymenttype = 'Placement' or paymenttype = '')
</cfquery>

<cfquery name="get_student_info" datasource="MySql">
	SELECT s.studentid, s.firstname, s.familylastname, s.arearepid, s.placerepid, s.programid
	FROM smg_students s
	WHERE s.studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_previous_place" datasource="MySql">
	SELECT u.userid, u.firstname, u.lastname
	FROM smg_users u
	WHERE u.userid = '#get_student_info.placerepid#'
	UNION
	SELECT host.placerepid, u.firstname, u.lastname
	FROM smg_hosthistory host
	INNER JOIN smg_users u ON u.userid = host.placerepid
	WHERE host.studentid = '#get_student_info.studentid#' and host.placerepid != '0'
	GROUP BY host.placerepid
</cfquery>

<cfquery name="get_previous_area" datasource="MySql">
	SELECT u.userid, u.firstname, u.lastname
	FROM smg_users u
	WHERE u.userid = '#get_student_info.arearepid#'
	UNION
	SELECT host.arearepid, u.firstname, u.lastname
	FROM smg_hosthistory host
	INNER JOIN smg_users u ON u.userid = host.arearepid
	WHERE host.studentid = '#get_student_info.studentid#' and host.arearepid != '0'
	GROUP BY host.arearepid
</cfquery>

<cfif not isDefined("url.placeid")><cfset url.placeid = #get_previous_place.userid#></cfif>
<cfif not isDefined("url.superid")><cfset url.superid = #get_previous_area.userid#></cfif>

<cfoutput>
<h2>Student: <a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#get_student_info.studentid#', 'Settings', 'height=350, width=750, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
				#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</a></h2>
<Br>Current Representative(s) assigned to this student:<br>

<cfform name="form" action="?curdoc=querys/insert_supervising_place_student" method="post">
<input type="hidden" name="studentid" value="#get_student_info.studentid#">
<table width=90% cellpadding=4 cellspacing=0>
	<tr><td bgcolor="010066" colspan=5><font color="white"><strong>Supervised by</strong></font></td></tr>	
	<tr bgcolor="CCCCCC"><td>Rep</td><td>Type</td><td>Amount</td><td>Comment</td></tr>
	<Cfif get_student_info.arearepid is 0>
	<tr><td colspan=5 align="center">No supervising representative was found.</td></tr>
	<tr><td colspan=5 align="right"><img src="pics/back.gif" border="0" onClick="javascript:history.back()"></td></tr>
	<cfelse>
	<tr>
		<td><select name="get_superid" onChange="javascript:formHandler2()">
				<cfloop query="get_previous_area">
				<option value="?curdoc=forms/supervising_place_student&studentid=#url.studentid#&superid=#userid#&placeid=#url.placeid#" <cfif url.superid is userid>selected</cfif>>#firstname# #lastname# (#userid#)</option>
				</cfloop></select>
			<input type="hidden" name="superid" value="#url.superid#">
			&nbsp; <span class="get_attention"><b>::</b></span>
			<a href="" onClick="javascript: win=window.open('forms/supervising_history.cfm?userid=#url.superid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Payment History</a>			
			<!--- check what have already been paid for the selected rep and student --->
			<Cfquery name="check_super_charges" datasource="MySQL">
				SELECT spt.type, spt.id, rep.agentid, rep.studentid, rep.transtype
				FROM smg_rep_payments rep
				INNER JOIN smg_payment_types spt ON rep.paymenttype = spt.id
				WHERE rep.studentid = '#get_student_info.studentid#' 
					AND rep.paymenttype != '10' 
					AND programid = '#get_student_info.programid#' 
			</Cfquery>
			<cfset super_charges = ''>
			<cfset super_charges = ValueList(check_super_charges.id)>
		</td>
		<Td><cfselect name="supervising_type">
			<option value=""></option>
			<Cfloop query="payment_super_type">
				<cfif NOT ListFind(super_charges, id)>
					<option value="#id#">#type#</option>
				</cfif>	
			</Cfloop>
			</cfselect></Td> 
		<td><input type="text" name="supervising_amount" size="6"></td>
		<td><input type="text" name="supervising_comment" size="20"></td>
	</tr>
	<tr>
		<td colspan=5 align="right"><input name="submit" type="image" src="pics/submit.gif" align="right" border=0 alt="submit"></td>
	</tr>
	</cfif>
	
	<tr><td>&nbsp;</td></tr>

	<tr>
		<td bgcolor="010066" colspan=5><font color="white"><strong>Placed by</strong></font></td>
	</tr>
	<tr bgcolor="CCCCCC">
		<td>Rep</td><td>Type</td><td>Amount</td><td>Comment</td>
	</tr>
	<Cfif get_student_info.placerepid is 0>
	<tr><td colspan=5 align="center">No placing representative was found.</td></tr>
	<tr><td colspan=5 align="right"><img src="pics/back.gif" border="0" onClick="javascript:history.back()"></td></tr>
	<cfelse>
	<tr><Td><select name="get_placeid" onChange="javascript:formHandler()">
				<cfloop query="get_previous_place">
				<option value="?curdoc=forms/supervising_place_student&studentid=#url.studentid#&placeid=#userid#&superid=#url.superid#" <cfif url.placeid is userid>selected</cfif>>#firstname# #lastname# (#userid#)</option>
				</cfloop></select> 
			<input type="hidden" name="placeid" value="#url.placeid#">
			&nbsp; <span class="get_attention"><b>::</b></span>
			<a href="" onClick="javascript: win=window.open('forms/supervising_history.cfm?userid=#url.placeid#', 'Settings', 'height=300, width=650, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Payment History</a>			
			<!--- check what have already been paid for the selected rep and student --->
			<Cfquery name="check_place_charges" datasource="MySQL">
				SELECT spt.type, spt.id, rep.agentid, rep.studentid, rep.transtype
				FROM smg_rep_payments rep
				INNER JOIN smg_payment_types spt ON rep.paymenttype = spt.id
				WHERE rep.studentid = '#get_student_info.studentid#'
					AND rep.paymenttype != '10'  
					AND programid = '#get_student_info.programid#'
			</Cfquery>
			<cfset place_charges = ''>
			<cfset place_charges = ValueList(check_place_charges.id)>
		</td>
		<Td><cfselect name="placing_type">
			<option value=""></option>
			<Cfloop query="payment_place_type">
				<cfif NOT ListFind(place_charges, id)>
					<option value="#id#">#type#</option>
				</cfif>	
			</Cfloop>
			</cfselect></Td>  
		<td><cfinput type="text" name="placing_amount" size="6"></td>
		<td><cfinput type="text" name="placing_comment" size="20"></td>
	</tr>
	<tr>
		<td colspan=5 align="right"><cfinput name="submit" type="image" src="pics/submit.gif" align="right" border=0 alt="submit"></td>
	</tr>
	</cfif>
</table><br>
</cfform>
</cfoutput>