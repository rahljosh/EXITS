<cfif not isDefined('url.text')>
<cfset url.text = 'no'>
</cfif>

<!--- Confirm box for update students --->
<script>
function areYouSure() { 
   if(confirm("You're about to update the records, this can not be undone, are you sure?")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>		

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfinclude template="../querys/get_company_short.cfm">

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_intl_rep.cfm">

<cfquery name="insurance_policies" datasource="MySql">
	SELECT insutypeid, type 
	FROM smg_insurance_type 
	WHERE provider = 'vsc'
</cfquery>

<cfquery name="get_batches" datasource="MySql">
	SELECT batchid, datecreated
	FROM smg_sevis
	WHERE type = 'new'
		<cfif client.companyid NEQ 5>AND companyid = '#client.companyid#'<cfelse>AND companyid <= '5'</cfif>
	ORDER BY batchid DESC
</cfquery>

<cfquery name="get_pending" datasource="MySql">
	SELECT i.transtype, count(i.studentid) as total, type.type, transtype 
	FROM smg_insurance i
	LEFT JOIN smg_insurance_type type ON type.insutypeid = i.policy_code
	WHERE type.provider = 'vsc'
		AND i.sent_to_caremed IS NULL
		<cfif client.companyid NEQ 5>AND i.companyid = '#client.companyid#'<cfelse>AND i.companyid <= '5'</cfif>
	GROUP BY type, transtype
	ORDER BY transtype
</cfquery>

<cfquery name="check_cancel_insurance" datasource="MySql">
	SELECT count(i.studentid) as total, type.type
	FROM smg_insurance i 
	INNER JOIN smg_students s ON s.studentid = i.studentid
	INNER JOIN smg_programs p ON p.programid = s.programid
	INNER JOIN smg_insurance_type type ON type.insutypeid = i.policy_code
	WHERE s.canceldate IS NOT NULL
		AND type.provider = 'vsc'
		AND s.insurance IS NOT NULL
		AND s.cancelinsurancedate IS NULL
		AND p.enddate >= NOW()
		AND i.sent_to_caremed IS NOT NULL
		<cfif client.companyid NEQ 5>AND i.companyid = '#client.companyid#'<cfelse>AND i.companyid <= '5'</cfif>
		<!--- AND NOT EXISTS (SELECT studentid FROM smg_insurance WHERE sent_to_caremed IS NOT NULL AND (transtype = 'early return' OR i.transtype = 'cancellation')) --->
	GROUP BY type
	ORDER BY type
</cfquery>

<cfquery name="get_history" datasource="MySql">
	SELECT i.transtype, i.sent_to_caremed, count(i.studentid) as total, type.insutypeid, type.type 
	FROM smg_insurance i
	LEFT JOIN smg_insurance_type type ON type.insutypeid = i.policy_code
	WHERE type.provider = 'vsc'
		AND i.sent_to_caremed IS NOT NULL
		<cfif client.companyid NEQ 5>AND i.companyid = '#client.companyid#'<cfelse>AND i.companyid <= '5'</cfif>
	GROUP BY type.insutypeid, sent_to_caremed, transtype
	ORDER BY sent_to_caremed DESC, transtype
</cfquery>

<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>VSC Insurance - Excel files</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>

	<!--- NEW TRANSACTION HEADER --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
		<th bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> New Transaction</th>
		<tr><td align="center"><font size="-2">According to SEVIS Batches - Verification report must have been received</font></td></tr>
	</table>
	
	<!--- VSC NEW REGISTRATION --->
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
		<tr>
			<td width="50%" valign="top">
				<cfform action="insurance/vsc_new_programid.cfm" method="POST">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">VSC New Registration - Program ID</th></tr>
					<tr><td colspan="2" bgcolor="e2efc7" align="center">First Registration Insurance</td></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><select name="programid" size="5" multiple>
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td>Insurance <br> Type:</td>
						<td><cfselect name="insurance_typeid">
							<cfloop query="insurance_policies">
								<option value="#insutypeid#">#type#</option>
							</cfloop>
							</cfselect>
						</td>
					</tr>
					<tr><td align="right"><input type="checkbox" name="flight"></input></td><td>Only Students with Flight Information</td></tr>
					<tr><td align="right"><input type="checkbox" name="usa"></input></td><td>Only American Citizen Students</td></tr>
					<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>			
			</td>
			<td width="50%" valign="top">
				<cfform action="insurance/vsc_new_batchid.cfm" method="POST">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="right" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">VSC New Registration - Batch ID</th></tr>
					<tr><td colspan="2" bgcolor="e2efc7" align="center">First Registration Insurance</td></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><select name="programid" size="1">
								<option value=0>All Programs</option>			
								<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
							</select>
						</td>
					</tr>
					<tr><td>Batch ID :</td>
						<td><select name="batchid" multiple  size="5">
							<cfloop query="get_batches"><option value="#batchid#">#batchid# &nbsp; &nbsp; #DateFormat(datecreated, 'mm/dd/yyyy')# &nbsp; </option></cfloop></select></td></tr>
					<tr>
						<td>Insurance <br> Type:</td>
						<td><cfselect name="insurance_typeid">
							<cfloop query="insurance_policies">
								<option value="#insutypeid#">#type#</option>
							</cfloop>
							</cfselect>
						</td>
					</tr>
					<tr><td align="right"><input type="checkbox" name="flight"></input></td><td>Only Students with Flight Information</td></tr>
					<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>						
			</td>
		</tr>
	</table><br /><br />

	<!--- INSURANCE MANAGEMENT SCREEN --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
		<th bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> #companyshort.companyshort# -  INSURANCE MANAGEMENT SCREEN - MANUAL TRANSACTIONS</th>
	</table><br>

	<table cellpadding=6 cellspacing="0" align="center" width="96%">
		<tr>
			<td width="50%" valign="top">
				<!--- PENDING STUDENTS --->
				<Table class="nav_bar"  cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="3" bgcolor="e2efc7">Pending Manual Transaction(s)</th></tr>
					<tr><th>Transaction</th><th>Insurance Type</th><th>Total of Students</th></tr>	
					<cfloop query="get_pending">
						<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#">
							<td align="center">#transtype#</td>
							<td align="center">#type#</td>
							<td align="center">#total#</td>
						</tr>
					</cfloop>
					<cfif get_pending.recordcount EQ 0>
						<tr bgcolor="e2efc7"><td colspan="3" class="style1">There are no pending transactions.</td></tr>
					</cfif>	
					<tr><td colspan="3" bgcolor="e2efc7">* Need to create and send the excel spreadsheet to VSC.</td></tr>
				</table>				
			</td>
			<td width="50%" valign="top">
				<cfform name="manual_transaction" action="?curdoc=insurance/vsc_manual_transaction" method="post">
				<Table class="nav_bar"  cellpadding=6 cellspacing="0" align="right" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Manual transaction - Excel Spreadsheet</th></tr>
					<tr>
						<td>Transaction Type :</td>
						<td>
							<cfselect name="transtype">
								<option value="0"></option>
								<option value="new">New App</option>
								<option value="correction">Correction</option>
								<option value="early return">Early Return</option>
								<option value="cancellation">Cancellation</option>
								<option value="extension">Extension</option>
							</cfselect>
						</td>
					</tr>																	
					<tr>
						<td>Insurance <br> Type:</td>
						<td><cfselect name="insurance_typeid">
								<option value="0"></option>
								<cfloop query="insurance_policies">
									<option value="#insutypeid#">#type#</option>
								</cfloop>
							</cfselect>
						</td>
					</tr>				
					<tr><td colspan="2">If for any reason you did not save the excel spreadsheet please use the history to retrieve it.</td></tr>
					<tr><Td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0 onClick="return areYouSure(this);"></td></tr>
				</table>
				</cfform>
			</td>
		</tr>
	</table><br><br>

	<!--- CANCELED STUDENTS - ACTIVE INSURANCE --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
		<th bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> #companyshort.companyshort# -  CHECK CANCELED STUDENTS</th>
	</table><br>
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
		<tr>
			<td width="50%" valign="top">
				
				<Table class="nav_bar"  cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Canceled Students with Active Insurance</th></tr>
					<tr><th>Insurance Type</th><th>Total of Students</th></tr>	
					<cfloop query="check_cancel_insurance">
						<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#">
							<td align="center"><a href="insurance/vsc_students_canceled_list.cfm" target="_blank">#type#</a></td>
							<td align="center"><a href="insurance/vsc_students_canceled_list.cfm" target="_blank">#total#</a></td>
						</tr>
					</cfloop>
					<cfif check_cancel_insurance.recordcount EQ 0>
						<tr bgcolor="e2efc7"><td colspan="2" class="style1">no records found.</td></tr>
					</cfif>					
					<tr><td colspan="2" bgcolor="e2efc7">* Need to create an early return/cancelation transaction on the insurance mgmt screen.</td></tr>
				</table>				
			</td>
			<td width="50%" valign="top">&nbsp;
				
			</td>
		</tr>
	</table><br><br>

	<!--- CREATE EXTENSION / EARLY RETURN ACCORDING TO FLIGHT  --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
		<th bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> Extensions / Early Returns According to Flight Info.</th>
	</table>
	
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
		<tr>
			<td width="50%" valign="top">
				<cfform action="?curdoc=insurance/vsc_create_corrections" method="POST">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Create Corrections According to Arrival Flight</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD><cfselect name="programid" size="5" multiple required="yes" message="Please select a program.">
								<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>			
				</table>
				</cfform>		
			</td>
			<td width="50%" valign="top">
				<!--- available --->
			</td>
		</tr>
	</table><br><br>


	<!--- INSURANCE HISTORY - EXCEL FILES --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
		<th bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> #companyshort.companyshort# - INSURANCE HISTORY - EXCEL FILES</th>
	</table>
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
		<tr>
			<td width="100%" valign="top">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
					<tr>
						<td width="25%"><b>Transaction Type</b></td>
						<td width="25%"><b>Insurance Type</b></td>
						<th width="25%">Filled Date</th>
						<th width="25%">Total of Students</th>
					</tr>
					<cfloop query="get_history"> 
					<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#">
						<td><a href="insurance/vsc_open_history.cfm?transtype=#URLEncodedFormat(transtype)#&policytype=#insutypeid#&date=#DateFormat(sent_to_caremed, 'yyyy/mm/dd')#">#transtype#</a></td>
						<td><a href="insurance/vsc_open_history.cfm?transtype=#URLEncodedFormat(transtype)#&policytype=#insutypeid#&date=#DateFormat(sent_to_caremed, 'yyyy/mm/dd')#">#type#</a></td>
						<td align="center"><a href="insurance/vsc_open_history.cfm?transtype=#URLEncodedFormat(transtype)#&policytype=#insutypeid#&date=#DateFormat(sent_to_caremed, 'yyyy/mm/dd')#">#DateFormat(sent_to_caremed, 'mm/dd/yyyy')#</a></td>
						<td align="center"><a href="insurance/vsc_open_history.cfm?transtype=#URLEncodedFormat(transtype)#&policytype=#insutypeid#&date=#DateFormat(sent_to_caremed, 'yyyy/mm/dd')#">#total#</a></td>
					</tr>
					</cfloop>
				</table>
			</td>
		</tr>
	</table><br><br>
</td></tr>
</table>

</cfoutput>
<cfinclude template="../table_footer.cfm">

<!--- UPDATE GROUP TO THE INSURANCE HISTORY TABLE --->

<!---
<cfoutput>
<cfquery name="insurance" datasource="MySql">
	SELECT insuranceid, studentid, new_date, policy_code
	FROM smg_insurance
	WHERE policy_code BETWEEN 7 AND 10 
</cfquery>

<cfloop query="insurance">
	<cfquery name="get_group" datasource="MySql">
		SELECT groupid, insutypeid, vsc_group
		FROM smg_insurance_vsc_group
		WHERE insutypeid = 	'#insurance.policy_code#'
			AND MONTH(startdate) = #DateFormat(new_date, 'mm')#
			AND YEAR(startdate) = #DateFormat(new_date, 'yyyy')#
	</cfquery>
	<cfquery name="update" datasource="MySql">
		UPDATE smg_insurance
		SET vsc_group = '#get_group.vsc_group#'
		WHERE insuranceid = '#insuranceid#'
		LIMIT 1
	</cfquery>

	POLICY = #policy_code# / Start Date #DateFormat(new_date, 'mm/dd/yyyy')# / GROUP = #get_group.vsc_group#<br />
</cfloop>
</cfoutput>
--->