<link rel="stylesheet" href="../smg.css" type="text/css">
<Title>Placement Paperwork Log</title>

<cfif not IsDefined('url.historyid')>
	<Table width=380 cellpadding=3 cellspacing=0 align="left" class="history">
	<tr><td>	
		Sorry, it was not possible to load the paperwork log. Please try again.
	</td></tr>
	<tr><td align="left"><font size=-1><Br>&nbsp;&nbsp;
		<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
	</table>
	<cfabort>
</cfif>

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
	
<cfquery name="get_paperwork_log" datasource="MySql">
	SELECT * 
	FROM smg_hostdocshistory
	WHERE historyid = <cfqueryparam value="#url.historyid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_host_family" datasource="MySql">
	SELECT familylastname, hostid
	FROM smg_hosts
	WHERE hostid = <cfqueryparam value="#get_paperwork_log.hostid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="user_rights" datasource="MySql">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_arrival" datasource="MySql">
	SELECT DISTINCT 
    	dep_date
	FROM 
    	smg_flight_info
	WHERE 
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_paperwork_log.studentid#">
	AND 
    	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
	AND
		isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">  
	ORDER BY 
    	dep_date DESC
</cfquery>

<cfoutput query="get_paperwork_log">

<cfform action="../querys/update_check_history.cfm" name="form" method="post">
<input type="hidden" name="historyid" value="#url.historyid#">

<Table width=380 cellpadding="3" cellspacing=0 align="left">
	<tr><th colspan="4" bgcolor="D5DCE5"><u>Placement Paperwork History</u></th></tr>
	<cfif IsDefined('url.upd')>
	<tr><td colspan="4" align="center"><span class="get_Attention">Placement Paperwork History Updated</span></td></tr>
	</cfif>
	<tr><td colspan="5">Host Family: <u>#get_host_family.familylastname# &nbsp; (#get_host_family.hostid#)</u></td></tr>
	<tr> <!-- 0 - PLACEMENT INFORMATION SHEET --->
		<td width="5%"><Cfif date_pis_received EQ ''>
				<input type="checkbox" name="check_pis" OnClick="CheckDates('check_pis','date_pis_received');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_pis" OnClick="CheckDates('check_pis','date_pis_received');" checked <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td width="60%">Placement Information Sheet</td>
		<td align="left" width="35%">Date: &nbsp;<input type="text" name="date_pis_received" size=9 value="#DateFormat(date_pis_received, 'mm/dd/yyyy')#"></td>
	</tr>
	<tr> <!-- 1 - Host Application Received --->
		<td><Cfif #doc_full_host_app_date# EQ ''>
				<input type="checkbox" name="check_app" OnClick="CheckDates('check_app','doc_full_host_app_date');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_app" OnClick="CheckDates('check_app','doc_full_host_app_date');" checked <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Application Received</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_full_host_app_date" size=9 value="#DateFormat(doc_full_host_app_date, 'mm/dd/yyyy')#"></td>
	</tr>
	<tr> <!-- 2 - Host Family Letter --->
		<td><Cfif #doc_letter_rec_date# EQ ''>
				<input type="checkbox" name="check_let" OnClick="CheckDates('check_let','doc_letter_rec_date');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_let" OnClick="CheckDates('check_let','doc_letter_rec_date');" checked <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Family Letter Received</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_letter_rec_date" size=9 value="#DateFormat(doc_letter_rec_date, 'mm/dd/yyyy')#"></td>
	</tr>	
	<tr> <!-- 3 - Host Family Rules Form --->
		<td><Cfif #doc_rules_rec_date# EQ ''>
				<input type="checkbox" name="check_rul" OnClick="CheckDates('check_rul','doc_rules_rec_date');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_rul" OnClick="CheckDates('check_rul','doc_rules_rec_date');" checked <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Family Rules Form</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_rules_rec_date" size=9 value="#DateFormat(doc_rules_rec_date, 'mm/dd/yyyy')#"></td>
	</tr>	
	<tr> <!-- 4 - Host Family Photos --->
		<td><Cfif #doc_photos_rec_date# EQ ''>
				<input type="checkbox" name="check_photos" OnClick="CheckDates('check_photos','doc_photos_rec_date');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_photos" OnClick="CheckDates('check_photos','doc_photos_rec_date');" checked <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Family Photos</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_photos_rec_date" size=9 value="#DateFormat(doc_photos_rec_date, 'mm/dd/yyyy')#"></td>
	</tr>	
	<tr> <!-- 6 - SCHOOL AND COMMUNITY PROFILE --->
		<td><Cfif #doc_school_profile_rec# EQ ''>
				<input type="checkbox" name="check_profile" OnClick="CheckDates('check_profile','doc_school_profile_rec');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_profile" OnClick="CheckDates('check_profile','doc_school_profile_rec');" checked <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>School & Community Profile Form</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_school_profile_rec" size=9 value="#DateFormat(doc_school_profile_rec, 'mm/dd/yyyy')#"></td>
	</tr>	
	<tr> <!-- 7 - CONFIDENTIAL HOST FAMILY VISIT FORM --->
		<td><Cfif #doc_conf_host_rec# EQ ''>
				<input type="checkbox" name="check_confi" OnClick="CheckDates('check_confi','doc_conf_host_rec');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_confi" OnClick="CheckDates('check_confi','doc_conf_host_rec');" checked <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>Confidential Host Family Visit Form</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_conf_host_rec" size=9 value="#DateFormat(doc_conf_host_rec, 'mm/dd/yyyy')#"></td>
	</tr>
	<tr> <!-- 7 - VISIT DATE --->
		<td>&nbsp;</td>
		<td>Date of Visit</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_date_of_visit" size=9 value="#DateFormat(doc_date_of_visit, 'mm/dd/yyyy')#"></td>
	</tr>	
	
	<tr> <!-- 8 - REFERENCE FORM 1 --->
		<td><Cfif #doc_ref_form_1# EQ ''>
				<input type="checkbox" name="check_form1" OnClick="CheckDates('check_form1','doc_ref_form_1');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_form1" OnClick="CheckDates('check_form1','doc_ref_form_1');" checked <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>Reference Form 1</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_ref_form_1" size=9 value="#DateFormat(doc_ref_form_1, 'mm/dd/yyyy')#"></td>
	</tr>
	<tr> <!-- REFERENCE CHECK FORM 1 --->
		<td>&nbsp;</td>
		<td>Date of Reference Check 1</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_ref_check1" size=9 value="#DateFormat(doc_ref_check1, 'mm/dd/yyyy')#"></td>
	</tr>			
	<tr> <!-- 9 - REFERENCE FORM 2 --->
		<td><Cfif #doc_ref_form_2# EQ ''>
				<input type="checkbox" name="check_form2" OnClick="CheckDates('check_form2','doc_ref_form_2');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_form2" checked OnClick="CheckDates('check_form2','doc_ref_form_2');" <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>Reference Form 2</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_ref_form_2" size=9 value="#DateFormat(doc_ref_form_2, 'mm/dd/yyyy')#"></td>
	</tr>
	<tr> <!-- REFERENCE CHECK FORM 2 --->
		<td>&nbsp;</td>
		<td>Date of Reference Check 2</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_ref_check2" size=9 value="#DateFormat(doc_ref_check2, 'mm/dd/yyyy')#"></td>
	</tr>		
	<tr> <!-- 10 - Host Family Orientation --->
		<td><Cfif doc_host_orientation EQ ''>
				<input type="checkbox" name="check_orientation" OnClick="CheckDates('check_orientation','doc_host_orientation');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_orientation" checked OnClick="CheckDates('check_orientation','doc_host_orientation');" <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Family Orientation</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_host_orientation" size=9 value="#DateFormat(doc_host_orientation, 'mm/dd/yyyy')#"></td>
	</tr>	
	<tr><td colspan="4">&nbsp;</td></tr>
	
	<tr>
		<td colspan="2"><u>Arrival Date Compliance</u></td>
		<td bgcolor="##CCCCCC">Arrival: <b><cfif get_arrival.dep_date EQ ''>n/a<cfelse>#DateFormat(get_arrival.dep_date, 'mm/dd/yyyy')#</cfif></b></td>
	</tr>	
	<tr> <!-- 5 - SCHOOL ACCEPTANCE FORM --->
		<td><Cfif #doc_school_accept_date# EQ ''>
				<input type="checkbox" name="check_school" OnClick="CheckDates('check_school','doc_school_accept_date');" <cfif client.usertype GT 5>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_school" OnClick="CheckDates('check_school','doc_school_accept_date');" checked <cfif client.usertype GT 5>disabled</cfif>>		
			</cfif>
		</td>
		<td>School Acceptance Form</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_school_accept_date" size=9 value="#DateFormat(doc_school_accept_date, 'mm/dd/yyyy')#"></td>
	</tr>
	<tr> <!-- SCHOOL ACCEPTANCE SIGNATURE DATE --->
		<td>&nbsp;</td>
		<td>Date of Signature</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_school_sign_date" size=9 value="#DateFormat(doc_school_sign_date, 'mm/dd/yyyy')#"></td>
	</tr>	
	<tr><td colspan="4">&nbsp;</td></tr>

	<tr>
	<td colspan="4">
		<Table width="100%" cellspacing=0 cellpadding="0" border="0"> 
			<tr bgcolor="D5DCE5">
				<cfif user_rights.compliance EQ '1' OR client.usertype LTE 4>
					<td align="right" width="50%"><font size=-1><br>
					<input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;</form></td>
					<td align="left" width="50%">
						<font size=-1><Br>&nbsp;&nbsp;
						<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
					</td>
				<cfelse>
					<td align="center">
						<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
					</td>
				</cfif>
			</tr>
		</table>
	</td>
	</tr>
</table>
</cfform>
</cfoutput>