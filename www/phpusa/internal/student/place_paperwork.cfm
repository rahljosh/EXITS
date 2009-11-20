<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../phpusa.css" rel="stylesheet" type="text/css">
<title>Placement Management - Paperwork</title>
</head>

<body>

<script language="JavaScript"> 
<!--// 
var currentTime = new Date()
var month = currentTime.getMonth() + 1
var day = currentTime.getDate()
var year = currentTime.getFullYear()
if (day < 10) 
	day = "0"+day;
if (month < 10) 
	month = "0"+month;

function CheckDates(ckname, frname) {
	if (document.form.elements[ckname].checked) {
		document.form.elements[frname].value = (month + "/" + day + "/" + year);
		}
	else { 
		document.form.elements[frname].value = '';  
	}
}	
//-->
</script>

<cftry>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- get student info by uniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfif client.usertype GT 4>
	<cfparam name="edit" default="no">
<cfelse>
	<cfparam name="edit" default="yes">
</cfif>

<cfform action="qr_place_paperwork.cfm?unqid=#get_student_unqid.uniqueid#" name="form" method="post">
<cfinput type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">

<cfoutput query="get_student_unqid">

<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 bgcolor="##e9ecf1"> 
<tr><td>

<!--- include template page header --->
<cfinclude template="place_menu_header.cfm">

<cfif get_student_unqid.schoolid EQ 0>
	<Table width="500" align="center" cellpadding=4 cellspacing="0">
		<tr><td align="center"><h3>There is no high school assigned to this student.</h3></td></tr>
		<tr><td align="center"><h3>You cannot check placement paperworks without a school. In order to continue please add a school.</h3></td></tr>
		<tr><td align="center">
				<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
			</td></tr>
	</table>
	<cfabort>	
</cfif>

<Table width="580" align="center" cellpadding=2 cellspacing="0">
	<tr>
		<td colspan=3><u>Paperwork Received</u></td>
	</tr>
	<tr>
		<td width="5%">
			<Cfif school_acceptance EQ ''>
				<input type="checkbox" name="school_acceptance_box" onClick="CheckDates('school_acceptance_box', 'school_acceptance')" <cfif edit EQ 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="school_acceptance_box" onClick="CheckDates('school_acceptance_box', 'school_acceptance')" checked <cfif edit EQ 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td width="30%">School Acceptance</td>
		<td align="left" width="40%">Date: &nbsp;<input type="text" name="school_acceptance" size=8 value="#DateFormat(school_acceptance, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
	</tr>
	<tr>
		<td width="5%">
			<Cfif sevis_fee_paid EQ ''>
				<input type="checkbox" name="sevis_fee_paid_box" onClick="CheckDates('sevis_fee_paid_box', 'sevis_fee_paid')" <cfif edit EQ 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="sevis_fee_paid_box" onClick="CheckDates('sevis_fee_paid_box', 'sevis_fee_paid')" checked <cfif edit EQ 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td width="30%">Sevis Fee Paid</td>
		<td align="left" width="40%">Date: &nbsp;<input type="text" name="sevis_fee_paid" size=8 value="#DateFormat(sevis_fee_paid, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
	</tr>	
	<tr>
		<td>
			<Cfif i20received EQ ''>
				<input type="checkbox" name="i20received_box" onClick="CheckDates('i20received_box', 'i20received')" <cfif edit EQ 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="i20received_box" onClick="CheckDates('i20received_box', 'i20received')" checked <cfif edit EQ 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>I-20 Received</td>
		<td align="left" width="40%">Date: &nbsp;<input type="text" name="i20received" size=8 value="#DateFormat(i20received, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
	</tr>
	<tr>
		<td>
			<Cfif hf_placement EQ ''>
				<input type="checkbox" name="hf_placement_box" onClick="CheckDates('hf_placement_box', 'hf_placement')" <cfif edit EQ 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="hf_placement_box" onClick="CheckDates('hf_placement_box', 'hf_placement')" checked <cfif edit EQ 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Family Placement</td>
		<td align="left" width="40%">Date: &nbsp;<input type="text" name="hf_placement" size=8 value="#DateFormat(hf_placement, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
	</tr>	
	<tr>
		<td>
			<Cfif hf_application EQ ''>
				<input type="checkbox" name="hf_application_box" onClick="CheckDates('hf_application_box', 'hf_application')" <cfif edit EQ 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="hf_application_box" onClick="CheckDates('hf_application_box', 'hf_application')" checked <cfif edit EQ 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Family Application</td>
		<td align="left" width="40%">Date: &nbsp;<input type="text" name="hf_application" size=8 value="#DateFormat(hf_application, 'mm/dd/yyyy')#" <cfif edit EQ 'no'>readonly</cfif>></td>
	</tr>
</table><br>

<Table width="580" align="center" cellpadding=2 cellspacing="0">
	<cfif client.usertype GT 4>
	<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
	<cfelse>
	<tr>	
		<td align="right" width="50%"><font size=-1><br>
			<input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp; 
		</td>
		<td align="left" width="50%">
			<font size=-1><Br>&nbsp;&nbsp;
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
		</td>
	</tr>
	</cfif>
</table>

</td></tr>
</table>

</cfoutput>

</cfform>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>