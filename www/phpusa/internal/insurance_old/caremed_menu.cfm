<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Caremed Menu</title>
</head>

<body>

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
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid C4CDE7; }
</style>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_intl_reps.cfm">

<cfset form.provider = 'caremed'>
<cfinclude template="../querys/get_insurance_policies.cfm">

<cfquery name="get_pending" datasource="MySql">
	SELECT i.transtype, count(i.studentid) as total
	FROM smg_insurance i
	LEFT JOIN smg_insurance_codes codes ON codes.policycode = i.policy_code
	WHERE i.sent_to_caremed IS NULL
		AND i.companyid = '6'
	GROUP BY i.studentid
	ORDER BY i.studentid
</cfquery>

<cfquery name="check_cancel_insurance" datasource="MySql">
	SELECT count(i.studentid) as total, type.type, php.programid
	FROM smg_insurance i 
	INNER JOIN php_students_in_program php ON php.studentid = i.studentid
	INNER JOIN smg_students s ON s.studentid = i.studentid
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = php.programid
	INNER JOIN smg_insurance_type type ON u.php_insurance_typeid = type.insutypeid
	WHERE php.canceldate IS NOT NULL
		AND type.provider = 'caremed'
		AND php.insurancedate IS NOT NULL
		AND php.insurancecanceldate IS NULL
		AND p.enddate >= NOW()
		AND i.sent_to_caremed IS NOT NULL
		AND i.companyid = '6'
		<!--- AND NOT EXISTS (SELECT studentid FROM smg_insurance WHERE sent_to_caremed IS NOT NULL AND (transtype = 'early return' OR i.transtype = 'cancellation')) --->
	GROUP BY type
	ORDER BY type
</cfquery>

<cfquery name="get_history" datasource="MySql">
	SELECT i.transtype, i.sent_to_caremed, count(i.studentid) as total, type.insutypeid, type.type 
	FROM smg_insurance i
	INNER JOIN smg_students s ON s.studentid = i.studentid
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_insurance_type type ON u.php_insurance_typeid = type.insutypeid
	WHERE type.provider = 'caremed'
		AND i.sent_to_caremed IS NOT NULL
		AND i.companyid = '6'
	GROUP BY type.insutypeid, sent_to_caremed, transtype
	ORDER BY sent_to_caremed DESC, transtype
</cfquery>

<cfoutput>

<br />
<Table class="nav_bar" cellpadding=3 cellspacing="0" width="90%" align="center">
	<tr><th bgcolor="##C4CDE7">CAREMED INSURANCE - EXCEL FILES AND REPORTS</th></tr>
</table><br />

<table border=0 cellpadding=0 cellspacing=0 width="90%" align="center">
<tr><td>

<!--- NEW TRANSACTION HEADER --->
<table cellpadding=3 cellspacing="0" align="center" width="100%">
	<tr><th bgcolor="##C4CDE7">:: &nbsp; NEW TRANSACTION</th></tr>
</table><br />
		
<table cellpadding=3 cellspacing="0" align="center" width="100%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/caremed_new_programid" method="POST">
			<Table cellpadding=3 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="C4CDE7">Caremed New Transaction</th></tr>
				<tr><td colspan="2" bgcolor="C4CDE7" align="center">Students never been insured.</td></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="5" multiple>
						<cfloop query="get_programs"><option value="#ProgramID#">#programname# &nbsp; &nbsp;</option></cfloop>
						</select>
					</td>
				</tr>
				<tr><th colspan="2">Current Policy Code: 07709020-401</th></tr>
				<tr><TD colspan="2" align="center" bgcolor="C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
		</td>
	</tr>
</table>


<!--- MANUAL TRANSACTIONS --->
<table cellpadding=3 cellspacing="0" align="center" width="100%">
	<tr></tr><th colspan="2" bgcolor="C4CDE7">:: &nbsp; INSURANCE MANAGEMENT SCREEN - MANUAL TRANSACTIONS</th></tr>
</table><br>
<table cellpadding=3 cellspacing="0" align="center" width="100%">
	<tr>
		<td width="50%" valign="top">
			<Table cellpadding=3 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="C4CDE7">Pending Manual Transaction(s)</th></tr>
				<tr><td align="center"><b>Transaction</b></td><td align="center"><b>Total of Students</b></td></tr>
				<cfloop query="get_pending">
					<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("e9ecf1") )#">
						<<td align="center">#transtype#</td>
						<td align="center">#total#</td>
					</tr>
				</cfloop>
				<cfif get_pending.recordcount EQ 0>
					<tr bgcolor="##e9ecf1"><td colspan="3">There are no pending transactions.</td></tr>
				</cfif>	
				<tr><td colspan="3" bgcolor="C4CDE7">* Need to create and send the excel spreadsheet to VSC.</td></tr>
			</table>
		</td>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/caremed_manual_transaction" method="POST">
			<Table cellpadding=3 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="C4CDE7">Manual Transaction - Excel Spreadsheet</th></tr>
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
				<tr><td colspan="2">If for any reason you did not save the excel spreadsheet please use the history to retrieve it.</td></tr>
				<tr><Td colspan="2" align="center" bgcolor="C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0 onClick="return areYouSure(this);"></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
</table><br>			

<!--- CHECK CANCELED STUDENTS WITH ACTIVE INSURANCE --->
<table cellpadding=3 cellspacing="0" align="center" width="100%">
	<tr></tr><th colspan="2" bgcolor="C4CDE7">:: &nbsp; CHECK CANCELLED STUDENTS</th></tr>
</table><br>
<table cellpadding=3 cellspacing="0" align="center" width="100%">
	<tr>
		<td width="50%" valign="top">
			<Table cellpadding=3 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="C4CDE7">Canceled Students with Active Insurance</th></tr>
				<tr><td align="center"><b>Insurance Type</b></td><td align="center"><b>Total of Students</b></td></tr>	
				<cfloop query="check_cancel_insurance">
					<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("e9ecf1") )#">
						<td align="center"><a href="insurance/caremed_students_canceled_list.cfm" target="_blank">#type#</a></td>
						<td align="center"><a href="insurance/caremed_students_canceled_list.cfm" target="_blank">#total#</a></td>
					</tr>
				</cfloop>
				<cfif check_cancel_insurance.recordcount EQ 0>
					<tr bgcolor="C4CDE7"><td colspan="2">no records found.</td></tr>
				</cfif>					
				<tr><td colspan="2" bgcolor="C4CDE7">* Need to create an early return/cancelation transaction on the insurance mgmt screen.</td></tr>
			</table>				
		</td>
		<td width="50%" valign="top">&nbsp;
			
		</td>
	</tr>
</table><br>

<table cellpadding=3 cellspacing="0" align="center" width="100%">
	<tr></tr><th colspan="2" bgcolor="C4CDE7">:: &nbsp; CHECK CANCELLED STUDENTS</th></tr>
</table><br>
<table cellpadding=3 cellspacing="0" align="center" width="100%">
	<tr>
		<td width="100%" valign="top">
			<Table cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr>
					<td width="33%"><b>Transaction Type</b></td>
					<th width="33%">Filled Date</th>
					<th width="33%">Total of Students</th>
				</tr>
				<cfloop query="get_history"> 
				<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("e9ecf1") )#">
					<td><a href="insurance/caremed_open_history.cfm?transtype=#URLEncodedFormat(transtype)#date=#DateFormat(sent_to_caremed, 'yyyy/mm/dd')#">#transtype#</a></td>
					<td align="center"><a href="insurance/caremed_open_history.cfm?transtype=#URLEncodedFormat(transtype)#&date=#DateFormat(sent_to_caremed, 'yyyy/mm/dd')#">#DateFormat(sent_to_caremed, 'mm/dd/yyyy')#</a></td>
					<td align="center"><a href="insurance/caremed_open_history.cfm?transtype=#URLEncodedFormat(transtype)#&date=#DateFormat(sent_to_caremed, 'yyyy/mm/dd')#">#total#</a></td>
				</tr>
				</cfloop>
			</table>
		</td>
	</tr>
</table><br>

</td></tr>
</table><br>

</cfoutput>

</body>
</html>
