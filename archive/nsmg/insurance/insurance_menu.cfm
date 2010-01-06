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

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_intl_rep.cfm">

<cfinclude template="../querys/insurance_policies.cfm">

<cfquery name="get_caremed_total" datasource="MySql">
	SELECT s.insurance, count(s.studentid) as total
	FROM smg_students s
	WHERE s.companyid = '#client.companyid#' 
		AND s.insurance IS NOT NULL AND s.active = '1'
	GROUP BY  s.insurance <!---s.sevis_batchid--->
	ORDER BY  s.insurance <!---s.sevis_batchid--->
</cfquery>

<cfquery name="get_regions" datasource="MySQL">
	select regionid, regionname,
		   companyshort
	from smg_regions
	INNER JOIN smg_companies ON company = companyid
	where 1 = 1
	<cfif client.companyid NEQ 5>
		and company = '#client.companyid#'</cfif>
	<cfif client.usertype GT 4>
		and regionid like '#client.regions#'</cfif>
	order by companyshort, regionname
</cfquery>

<cfquery name="get_batches" datasource="MySql">
	SELECT batchid, datecreated
	FROM smg_sevis
	WHERE type = 'new' 
		<cfif client.companyid NEQ 5>AND companyid = '#client.companyid#'</cfif> 
	ORDER BY batchid DESC
</cfquery>

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Caremed Insurance - Excel files and Reports</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>
	<!--- NEW TRANSACTION HEADER --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> New Transaction</th></tr>
	<tr><td colspan="2" align="center"><font size="-2">According to SEVIS Batches - Verification report must have been received</font></td></tr>
	</table>
		
	<!--- NEW TRANSACTION - FIRST ROW - 2 REPORTS --->
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/new_transaction_batchid" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">New Transaction - Batch ID &nbsp; - &nbsp; No update is required</th></tr>
				<tr><td colspan="2" bgcolor="e2efc7" align="center">Students never been insured.</td></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=0>All Programs</option>			
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select></td></tr>
				<tr><td>Batch ID :</td>
					<td><select name="batchid" multiple  size="5">
						<cfloop query="get_batches"><option value="#batchid#">#batchid# &nbsp; &nbsp; #DateFormat(datecreated, 'mm/dd/yyyy')# &nbsp; </option></cfloop></select></td></tr>
				<tr><td colspan="2"><cfinput type="checkbox" name="flight"> Only students with flight arrival</td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/new_transaction_dates" method="POST">
			<Table class="nav_bar"  cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">New Transaction per period &nbsp; - &nbsp; Update is required</th></tr>
				<tr><td colspan="2" bgcolor="e2efc7" align="center">Students never been insured.</td></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date" required="yes"> mm-dd-yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date" required="yes"> mm-dd-yyyy</td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	<!--- NEW TRANSACTION ROW 2 UDPATE--->
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/new_transaction" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">New Transaction with Insurance Dates &nbsp; - &nbsp; Update is required</th></tr>
				<tr><td colspan="2" bgcolor="e2efc7" align="center">Students never been insured.</td></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="5" multiple>
						<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select>
					</td></tr>
				<tr><td align="right"><input type="checkbox" name="usa"></input></td><td>Only American Citizen Students</td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/new_transaction_update" method="POST">	
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="right" width="100%">
			<tr><th colspan="2" bgcolor="e2efc7">Update New Transaction Records</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=00></option>
							<option value=0>All Programs</option>			
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select>
					</td></tr>
				<tr><TD colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/update.gif" align="center" border=0 onClick="return areYouSure(this);"></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	<!--- NEW TRANSACTION ROW 3  - WARNING --->
	<tr>
		<td valign="top" colspan="2">
			<Table class="nav_bar" cellpadding=3 cellspacing="0" align="left" width="100%">
				<tr><th bgcolor="##CC0000"> <font color="white">Warning</font></th></tr>
				<tr align="left">
					<td bgcolor="e2efc7">
						<div align="justify">
						If you've Viewed the students on the list above and saved it as an Excel spreadsheet click on the update button.<br>
						<b>Note:</b> Before you proceed make sure you selected the same program you used to View the list.
						 <font color="##CC0000">This can not be undone.</font><Br>
						You will update the records and those students will not show up again on the same report.<br>
						</div></td></tr>
			</table>		
		</td>
	</tr>
	</table><br><br>
	
	<!--- CORRECTION HEADER ---> <!--- CORRECTION - FIRST ROW --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr></tr><th colspan="2" bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> INSURANCE MANAGEMENT SCREEN</th></tr>
	</table><br>
	
	<!--- CORRECTION HEADER ---> <!--- CORRECTION - FIRST ROW --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr></tr><th colspan="2" bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> New Transaction</th></tr>
	</table>
	
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/new_transaction_manual" method="POST">	
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="right" width="100%">
			<tr><th colspan="2" bgcolor="e2efc7">New Transaction</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=00></option>
							<option value=0>All Programs</option>			
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select>
					</td></tr>
				<tr><TD colspan="2" align="center">&nbsp;</td></tr>			
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>			
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/new_manual_update" method="POST">
			<Table class="nav_bar"  cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Update New Transactions</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=1></option>
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select></td></tr>
				<tr><TD colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/update.gif" align="center" border=0 onClick="return areYouSure(this);"></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	</table><br><br>

	<!--- CORRECTION HEADER ---> <!--- CORRECTION - FIRST ROW --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr></tr><th colspan="2" bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> Correction</th></tr>
	</table>
	
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/correction" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Correction</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select>
					</td></tr>
				<tr><TD colspan="2" align="center">&nbsp;</td></tr>			
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>			
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/correction_update" method="POST">
			<Table class="nav_bar"  cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Update Correction Records</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=1></option>
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select></td></tr>
				<tr><TD colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/update.gif" align="center" border=0 onClick="return areYouSure(this);"></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	</table><br><br>

	<!--- EARLY RETURN HEADER ---><!--- EARLY RETURN - FIRST ROW --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr></tr><th colspan="2" bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> Early Return</th></tr>
	<tr><td colspan="2" align="center"><font size="-2">According to Flight Departure Info</font></td></tr>
	</table>
	
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
		<cfform action="?curdoc=insurance/early_return" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Early Return</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select>
					</td></tr>
				<tr><TD colspan="2" align="center">&nbsp;</td></tr>					
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>			
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
		<cfform action="?curdoc=insurance/early_return_update" method="POST"> 
			<Table class="nav_bar"  cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Update Early Return Records</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=1></option>
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select></td></tr>
				<tr><TD colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/update.gif" align="center" border=0 onClick="return areYouSure(this);"></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	</table><br><br>

	
	<!--- EXTENSION HEADER ---><!--- EXTENSION - FIRST ROW --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr></tr><th colspan="2" bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> Extension</th></tr>
	</table>
	
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/extension" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Extension</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select></td></tr>
				<tr><TD colspan="2" align="center">&nbsp;</td></tr>					
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>			
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/extension_update" method="POST">
			<Table class="nav_bar"  cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Update Extension Records</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=1></option>
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select></td></tr>
				<tr><TD colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/update.gif" align="center" border=0 onClick="return areYouSure(this);"></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	</table><br><br>
	
	<!--- CANCELATION HEADER ---> <!--- CANCELATION - FIRST ROW --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr></tr><th colspan="2" bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> Cancelation</th></tr>
	<tr><td colspan="2" align="center"><font size="-2">Students must be inactive (canceled) and must have insurance info (insured date)</font></td></tr>
	</table>
	
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/cancelation" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Cancelation</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value=1></option>
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select></td></tr>
				<tr><TD colspan="2" align="center">&nbsp;</td></tr>					
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>			
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/cancelation_update" method="POST">
			<Table class="nav_bar"  cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Update Cancelation Records</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" size="1">
							<option value='zero'></option>
							<option value=0>All Programs</option>			
							<!--- <option value=0></option> --->
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</select></td></tr>
				<tr><TD colspan="2" align="center"><font color="##CC0000"><b>* See Warning</b></font></td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/update.gif" align="center" border=0 onClick="return areYouSure(this);"></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	</table><br><br>
	
	<!--- CREATE EXTENSION / EARLY RETURN ACCORDING TO FLIGHT  --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr></tr><th colspan="2" bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> Extensions / Early Returns According to Flight Info.</th></tr>
	</table>
	
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/upd_corrections" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Create Corrections According to Flight</th></tr>
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
			<cfform action="?curdoc=insurance/upd_extensions" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Create Extensions / New Transactions / Early Returns Data</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><cfselect name="programid" size="5" multiple required="yes" message="Please select a program.">
							<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td><cfinput type="checkbox" name="manual"> Extension Date:</td><td><cfinput name="extensiondate" size="7" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>
				<tr><TD colspan="2" align="center">Use an extension date for kids with no flight information.</td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>			
			</table>
			</cfform>
		</td>
	</tr>
	</table><br><br>
	
	<Table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="7" bgcolor="e2efc7">
		<span class="get_attention"><b>::</b></span> New Transaction Insurance History &nbsp; &nbsp;
		<Cfif url.text is 'no'>
			<a href="index.cfm?curdoc=insurance/insurance_menu&text=yes">(show list)</a>
		<cfelseif url.text is 'yes'>
			<a href="index.cfm?curdoc=insurance/insurance_menu&text=no">(hide list)</a>
		</Cfif>
	</th></tr>
	<cfif url.text is 'no'><cfelse>
		<tr bgcolor="e2efc7">
			<td width="20%" align="left"><b>Date Insured</b></td>
			<td width="20%" align="center"><b>Total of Students</b></td>
			<td width="20%" align="center"><b>Batch ID</b></td>			
			<td width="20%" align="center"><b>Excel File</b></td>
		</tr>
		<cfloop query="get_caremed_total">
			<cfquery name="get_batches" datasource="MySql">
				SELECT s.sevis_batchid, sevis.datecreated
				FROM smg_students s
				LEFT JOIN smg_sevis sevis ON s.sevis_batchid = sevis.batchid
				WHERE s.insurance = #CreateODBCDate(insurance)# 
					AND s.companyid = '#client.companyid#'
				GROUP BY s.sevis_batchid
				ORDER BY s.sevis_batchid
			</cfquery>
			<tr bgcolor="#iif(get_caremed_total.currentrow MOD 2 ,DE("white") ,DE("ededed"))#">
				<td align="left"><a href="insurance/insurance_list.cfm?insudate=#DateFormat(insurance, 'yyyy-mm-dd')#" target="_blank">#DateFormat(insurance, 'mm/dd/yyyy')#</a></td>
				<td align="center"><a href="insurance/insurance_list.cfm?insudate=#DateFormat(insurance, 'yyyy-mm-dd')#" target="_blank">#total#</a></td>
				<td align="center"><cfloop query="get_batches">#sevis_batchid# - #DateFormat(datecreated, 'mm-dd-yy')# &nbsp; &nbsp;</cfloop></td>
				<td align="center"><a href="insurance/insurance_excel_list.cfm?insudate=#DateFormat(insurance, 'yyyy-mm-dd')#" target="_blank"><img src="pics/excelico.jpg" border="0"></a></td>
			</tr>
		</cfloop>
		<tr><td colspan="4">* Click in the link(s) above to see the list of students.</td></tr>  
	</cfif>
	</table><br>

<cfif client.usertype EQ '1'>
	<table cellpadding=6 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="?curdoc=insurance/upd_corrections_no_flight" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Update Insurance Dates</th></tr>
				<tr><td colspan="2">Update all students that do not have flight arrival information</td></tr>
					<tr align="left">
						<td>Program :</td>
						<td><cfselect name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ 5>#get_program.companyshort# - </cfif>#programname#</option></cfloop></cfselect></td></tr>
					<tr align="left">
						<td>New Start Date :</td><td><cfinput type="text" size="7" name="newdate" required="yes" message="You must enter a date" validate="date"></td>
					</tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>	
		</td>
		
		<td width="50%" valign="top">&nbsp;
					
		</td>
	</tr>
	</table>
</cfif>

</td></tr>
</table>

</cfoutput>
<cfinclude template="../table_footer.cfm">