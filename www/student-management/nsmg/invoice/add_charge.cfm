<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<link rel="stylesheet" href="../smg.css" type="text/css">
<head>
<title>Add Charges to Account</title>

<cfsetting requesttimeout="800">

<body onLoad="opener.location.reload()"> 

<body>
</head>
<style type="text/css">
<!--
.style1 {font-size: 12px}

.thin-border{ border: 1px solid #000000;}
.thin-border-right{ border-right: 1px solid #000000;}
.thin-border-left{ border-left: 1px solid #000000;}
.thin-border-left-right{ border-left: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-right-bottom{ border-right: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
.thin-border-top{  border-top: 1px solid #000000;}
.thin-border-left-bottom{ border-left: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-right-bottom-top{ border-right: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-top{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-right{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-left-top-right{ border-left: 1px solid #000000; border-top: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-top-right{  border-top: 1px solid #000000; border-right: 1px solid #000000;}

-->
</style>

<cfquery name="charge_type" datasource="MySQL">
select type, description
from smg_charge_type
</cfquery>

<!----Sevis Charge---->
<cfquery name="check_for_sevis" datasource="MySQL">
select accepts_sevis_fee, insurance_typeid
from smg_users
where userid = #url.userid#
</cfquery>

<cfoutput> 
<form method="post" action="insert_charge_query.cfm" enctype="multipart/form-data">

<div class="application_section_header">Add Charges to Account</div><br><br>
<input type="hidden" name=agentid value=#url.userid#>
</cfoutput>
<!----Misc Charges---->
<span class="get_attention"><b>></b></span><u>Misc Charges, not necessarily tied to a student.</u>
<br>
<br>
<cfparam name="stuid" default=0>
<cfoutput>
Type: 	<select name="type">
		<cfloop query="charge_type">
		<option value="#type#">#type#</option>
		</cfloop>
		</select>
 Description: <input type="text" name="description" size=25 value='Description'>  Amount: <input type="text" name="amount" size=8 value='amount'>
 <br><br>
 <div class="button"> <input name="submit" type="image" src="../pics/update.gif" align="right" border=0></div>
 </form>
 <br><br>
 <hr width=40%>
 <br>
 </cfoutput>

<form method="post" action="insert_student_charge_query.cfm" enctype="multipart/form-data">
<cfoutput>
<input type="hidden" name=agentid value=#url.userid#>
</cfoutput>
<!----List of Students that need charges---->
<span class="get_attention"><b>></b></span><u>Students that need to have fees applied</u>
<br>

<!----Retrieve students under the rep that have not had both deposit and final charges applied---->
<cfquery name="students_under_rep_not_charged" datasource="MySQL">
	select s.studentid, s.intrep, s.firstname, s.familylastname, s.programid, s.hostid, s.direct_placement, s.dateplaced, s.jan_app, s.state_guarantee, s.onhold_approved, s.verification_received
	from smg_students s
	where s.intrep = #url.userid#
    and s.companyid = #client.companyid#
    and s.active = 1
</cfquery>

<Cfif students_under_rep_not_charged.recordcount is 0>
This agent does not have any students currently active OR all students have had charges applied.
<Cfelse>

<table cellpadding = 4 cellspacing=0 border=0>
	<tr>
		<td valign="top" colspan=3><img src="../pics/arrow_left_down.gif" align=left><b>Select students to create charges for.</b></td>
	</tr>
	<tr>
		<td></td><td>Student</td><td>Program</td>
	</tr>
		<cfoutput query="students_under_rep_not_charged">
        
        	<cfquery name="check_depositCharge" datasource="MySQL">
				select type
				from smg_charges
				where stuid = #studentid# 
                and type = 'deposit'
                and programid = #students_under_rep_not_charged.programid#
                and agentid = #students_under_rep_not_charged.intrep#
                and active = 1
				order by type
			</cfquery>
            
			<cfquery name="check_charges" datasource="MySQL">
				select amount, chargeid, invoiceid, type, description
				from smg_charges
				where stuid = #studentid# 
                and active = 1
                and programid = #students_under_rep_not_charged.programid#
                and agentid = #students_under_rep_not_charged.intrep#
				order by type
			</cfquery>
			<cfquery name="program_name_charge" datasource="MySQL">
				select smg_programs.programname, smg_programs.type, startdate, enddate, blank, hold
				from smg_programs
				where programid = #students_under_rep_not_charged.programid#
			</cfquery>
            
            <!-- Checks District Name for ESI students -->
            <cfquery name="qcheck_district" datasource="MySQL">
            select studentID, regionassigned, regionname
            from smg_students ss
            left join smg_regions sr on regionid = ss.regionassigned
            where studentID = #studentid#
            </cfquery>
	
		<Cfif program_name_charge.startdate lt '09/01/2004' or program_name_charge.blank is 1>
		<cfelse>
			<cfif program_name_charge.hold eq 0 or (onhold_approved lte '5' and onhold_approved gte '7')>
				<tr bgcolor=<cfif (onhold_approved lte '5' and onhold_approved gte '7')>fee6d3<cfelse><cfif students_under_rep_not_charged.currentrow mod 2>ededed<cfelse>ffffff</cfif></cfif>>
				<td class="thin-border-left-bottom-top">
					<input type="checkbox" name="studentid" value="#studentid#" <Cfif hostid is 0 and check_charges.recordcount eq 1 or (onhold_approved gte '5' and onhold_approved lte '7') or verification_received is '' or client.companyid EQ 14><Cfelseif program_name_charge.startdate lt '02/01/2005'><cfelse>checked</cfif>></td><td class="thin-border-top"> #firstname# #familylastname# (#studentid#)</td><Td class="thin-border-top">#program_name_charge.programname#</Td><td class="thin-border-top"><cfif verification_received is ''>Not Verified<Cfelseif hostid is '' or hostid is 0>Unplaced<cfelse>Placed</Cfif><Cfif direct_placement is 1> - Direct</Cfif><cfif (onhold_approved gte '5' and onhold_approved lte '7')>&nbsp;&nbsp;ON HOLD</cfif></td> 
                    <td class="thin-border-top-right">District: #qcheck_district.regionname#</td>
				</tr>
			<cfif (onhold_approved gte '5' and onhold_approved lte '7')>
			<cfelse>
				<cfif check_depositCharge.recordcount is 0 AND NOT ListFind("13,15",CLIENT.companyID)>
							<tr bgcolor=<cfif students_under_rep_not_charged.currentrow mod 2>ededed<cfelse>ffffff</cfif>>
								<td bgcolor="ffffff"></td>
                                <td class="thin-border-left-bottom">Type: 
								<input type="hidden" name=#students_under_rep_not_charged.studentid#deposit_type value='deposit'>Deposit</td>
                                <td class="thin-border-bottom">Charge: <input type=text name="#studentid#deposit_amount" value=500 size=6></td>
                                <td class="thin-border-bottom"> Desc: <input type="text" size="14" name="#studentid#deposit_description" value='#program_name_charge.programname#'>
								<input type=hidden name="#students_under_rep_not_charged.studentid#guarantee_amount" value="" size=6>
								<input type=hidden name="#students_under_rep_not_charged.studentid#insurance_amount" value="" size=6>
								<input type=hidden name="#students_under_rep_not_charged.studentid#final_amount" value="" size=6>
								<input type=hidden name="#students_under_rep_not_charged.studentid#sevis_amount" value="" size=6>
								<input type=hidden name="#students_under_rep_not_charged.studentid#direct_placement" value="" size=6>
								<input type=hidden name="#students_under_rep_not_charged.studentid#direct_placement_guarantee_disc" value="" size=6>
								<input type="hidden" name="#students_under_rep_not_charged.studentid#programid" value="#programid#">
								</td>
                                <td class="thin-border-right-bottom"></td>
							</tr>
					<cfelse>
						<cfset charge_list =''>
							<input type="hidden" name="#students_under_rep_not_charged.studentid#programid" value="#programid#">
							<cfloop query="check_charges">
							<tr >
								<Td bgcolor="ffffff"></Td>
                                <td bgcolor="FFFF99" class="thin-border-left">#type#</td>
                                <td bgcolor="FFFF99" >#description#</td>
                                <Td bgcolor="FFFF99">#amount#</Td>
                                <td bgcolor="FFFF99" class="thin-border-right"></td>
							</tr>
							<cfset charge_list = ListAppend(charge_list, '#type#')>
							</cfloop>
							
							<cfquery name="program_charges" datasource="#APPLICATION.DSN#">
								SELECT 
									<cfif #DateDiff('M', program_name_charge.startdate, program_name_charge.enddate)# gt 6>
										u.10_month_price as program_fee, i.ayp10 as insurance_charge
									<cfelse>
										u.5_month_price as program_fee, i.ayp5 as insurance_charge
									</cfif>
								FROM smg_users u
                                INNER JOIN smg_insurance_type i ON i.insutypeid = u.insurance_typeid
								WHERE u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(url.userid)#">
							</cfquery>
							
											<cfquery name="student_charges" datasource="#APPLICATION.DSN#">
												select regionguar, regionalguarantee, state_guarantee
												from smg_students
												where studentid = #students_under_rep_not_charged.studentid#
											</cfquery>
							<!----Final Program Charge---->
							<cfif ListContainsNoCase(charge_list, 'program fee')>
							<input type=hidden name="#studentid#deposit_amount" value=''>
							<input type=hidden name="#studentid#final_amount" value=''>
							<cfelse>
							
							<Tr>
								<td><input type=hidden name="#studentid#deposit_amount" value=''></td>
								<td class="thin-border-left">Type: <input type="hidden" name=#students_under_rep_not_charged.studentid#final_type value='program fee'>Program Fee</td>
								<td>Charge: <input type=text name="#students_under_rep_not_charged.studentid#final_amount" value="#program_charges.program_fee#" size=6></td>
								<td> Desc: <input type="text" size="14" name="#students_under_rep_not_charged.studentid#final_description" value='#program_name_charge.programname#'></td>
                                <td class="thin-border-right"></td>
							</Tr>
							</cfif>
							<!----Insurance Charge---->
							<cfif ListContainsNoCase(charge_list, 'insurance')>
							<input type=hidden name="#students_under_rep_not_charged.studentid#insurance_amount" value="" size=6>
							<cfelse>
								<cfif check_for_sevis.insurance_typeid EQ '1'> <!--- type 1 = none --->
								<Tr>
								<td></td><td colspan = 4 class="thin-border-left-right">Agent doesn't take insurance <input type=hidden name="#students_under_rep_not_charged.studentid#insurance_amount" value="" size=6></td>
								</Tr>
								<cfelse>
								<Tr>
								<td></td>
									<td class="thin-border-left">Type: <input type="hidden" name=#students_under_rep_not_charged.studentid#insurance_type value='insurance'>Insurance</td>
									<td>Charge: <input type=text name="#students_under_rep_not_charged.studentid#insurance_amount" value="#program_charges.insurance_charge#" size=6></td>
									<td> Desc: <input type="text" size="14" name="#students_under_rep_not_charged.studentid#insurance_description" value='#program_name_charge.programname#'></td>	
                                    <td class="thin-border-right"></td>							
								</Tr>
								</cfif>
							</cfif>
		
							<!----Guarantee Charge---->
							<cfif ListContainsNoCase(charge_list, 'guarantee')>
							<input type=hidden name="#students_under_rep_not_charged.studentid#guarantee_amount" value="" size=6>
							<input type="hidden" name=#students_under_rep_not_charged.studentid#direct_placement_guarantee_disc value=''>
							<cfelse>
								<cfif student_charges.regionguar is 'no' AND student_charges.state_guarantee EQ 0>
									<Tr>
									<td></td><td colspan = 5 class="thin-border-left-right">Student doesn't have a regional or state guarantee <input type="hidden" name=#students_under_rep_not_charged.studentid#direct_placement_guarantee_disc value=''><input type=hidden name="#students_under_rep_not_charged.studentid#guarantee_amount" value="" size=6></td>
									</Tr>
								<cfelse>
								<!----Determine which type of guarantee student has---->
								<cfquery name="determine_guarantee" datasource="MySQL">
									select smg_students.state_guarantee, smg_students.regionalguarantee
									from smg_students
									where studentid = #students_under_rep_not_charged.studentid#
								</cfquery>
								<!---- get state or region guarantee price --->
								<cfif determine_guarantee.state_guarantee eq 0>
									<cfquery name="guarantee_info" datasource="MySQL">
										select regionname as guar_name, regional_guarantee as guar_fee
										from smg_regions
										where regionid = #determine_guarantee.regionalguarantee#
									</cfquery> 
									<cfset guar_type = 'Regional Guarantee: #guarantee_info.guar_name#'>
								<cfelse>
									<cfquery name="guarantee_info" datasource="MySQL">
										select statename as guar_name, guarantee_fee as guar_fee
										from smg_states
										where id = #determine_guarantee.state_guarantee#
									</cfquery> 
									<cfset guar_type = 'State Guarantee: #guarantee_info.guar_name#'>
								</cfif>
								<Tr>
									<td></td>
									<td class="thin-border-left">Type: <input type="hidden" name="#students_under_rep_not_charged.studentid#guarantee_type" value='guarantee'>Guarantee</td>
									<td>Charge: <input type=text name="#students_under_rep_not_charged.studentid#guarantee_amount" value="#guarantee_info.guar_fee#" size=6></td>
									<td> Desc: <input type="text" size="14" name="#students_under_rep_not_charged.studentid#guarantee_description" value='#guar_type#'></td>
                                    <td class="thin-border-right"></td>
								</Tr>
									<cfif dateplaced lt '0001/01/01 00:00:00' or dateplaced gt '05/11/2005 01:00:00' or hostid is 0>
									<cfquery name="check_sts" datasource="MySQL">
									select userid from smg_users 
									where userid = #url.userid# and businessname like '%sts%'
									</cfquery>
									<cfif check_sts.recordcount gt 0>
										<cfset sts = 1>
									<cfelse> 
										<cfset sts = 0>
									</cfif>
										<cfif direct_placement IS '1' OR (jan_app IS '1' AND sts IS '0')>
											<cfif guarantee_info.guar_fee EQ ''>
												<cfset direct_placement_reg_guar = 'MISSING Guarantee Information'>
											<cfelse>
												<cfset direct_placement_reg_guar = guarantee_info.guar_fee * -1>
											</cfif>	
											<!--- there are few exceptions for state guarantee - set description to state or region guarantee --->
											<cfif state_guarantee EQ 0>
												<cfset desc_value = 'Free Regional Guarantee'>
											<cfelse>value='Free Regional Guarantee'>
												<cfset desc_value = 'Special Discount: Free State Guarantee'>
											</cfif>
											<Tr>
												<td></td>
												<td class="thin-border-left">Type: <input type="hidden" name="#students_under_rep_not_charged.studentid#direct_placement_guarantee_disc" value='guarantee'>Direct Placement Guarantee disc.</td>
												<td>Charge: <input type="left" name="#students_under_rep_not_charged.studentid#direct_placement_guarantee_disc_amount" value="#direct_placement_reg_guar#" size=6></td>
												<td> Desc: <input type="text" size="14" name="#students_under_rep_not_charged.studentid#direct_placement_guarantee_disc_desc" value='#desc_value#'></td>
                                                <td class="thin-border-right"></td>
											</Tr>
										</cfif>
									<cfelse>
									<input type="hidden" name="#students_under_rep_not_charged.studentid#direct_placement_guarantee_disc" value=''>
									</cfif>
								</cfif>
							</cfif>
							
							<!----SEVIS FEE---->
							
							<cfif ListContainsNoCase(charge_list, 'sevis')>
							<input type=hidden name="#students_under_rep_not_charged.studentid#sevis_amount" value="" size=6>
							<cfelse>
								
								<cfif check_for_sevis.accepts_sevis_fee is 0>
								<Tr>
								<td></td><td colspan = 4 class="thin-border-left-right">Agent doesn't accept SEVIS fee.<input type=hidden name="#students_under_rep_not_charged.studentid#sevis_amount" value="" size=6></td>
								</Tr>
								<cfelse>
								
								<Tr>
								<td></td><td class="thin-border-left">Type: <input type="hidden" name=#students_under_rep_not_charged.studentid#sevis_type value='sevis'>SEVIS</td><td>Charge: <input type=text name="#students_under_rep_not_charged.studentid#sevis_amount" value="180.00" size=6></td>
                                <td> Desc: <input type="text" size="14" name="#students_under_rep_not_charged.studentid#sevis_description" value='SEVIS Fee'></td>
                                <td class="thin-border-right"></td>
								</Tr>
								</cfif>
								
							</cfif>
							
							<!---- Direct Placement Discount---->
							<cfif ListContainsNoCase(charge_list, 'direct placement')>
							<input type=hidden name="#students_under_rep_not_charged.studentid#direct_placement" value="" size=6>
							<input type=hidden name="#students_under_rep_not_charged.studentid#direct_placement_reg_guarnatee" value="" size=6>
							<input type="hidden" name=#students_under_rep_not_charged.studentid#direct_placement_guarantee_disc value=''>
							<cfelse>
								<cfif direct_placement NEQ 1 or #students_under_rep_not_charged.studentid# eq 820>
								<input type=hidden name="#students_under_rep_not_charged.studentid#direct_placement" value="" size=6>
								<input type=hidden name="#students_under_rep_not_charged.studentid#direct_placement_reg_guarnatee" value="" size=6>
								<input type="hidden" name=#students_under_rep_not_charged.studentid#direct_placement_guarantee_disc value=''>
								<cfelse>
									<cfif dateplaced lt '0001-01-01 00:00:00' or dateplaced gt '04/27/2005 01:00:00' or hostid is 0  >
									<Tr>
									<td></td><td class="thin-border-left">Type: <input type="hidden" name=#students_under_rep_not_charged.studentid#direct_placement value='direct placement'>Direct Placement</td><td>Charge: <input type=text name="#students_under_rep_not_charged.studentid#direct_placement_amount" value="-200.00" size=6></td
                                    ><td> Desc: <input type="text" size="14" name="#students_under_rep_not_charged.studentid#direct_placement_description" value='Direct Placement Discount'></td>
                                    <td class="thin-border-right"></td>
									</Tr>
									<cfelse>
									<input type=hidden name="#students_under_rep_not_charged.studentid#direct_placement" value="" size=6>
									</cfif>
								</cfif>

							</cfif>
							
					</cfif>
					</cfif>
				</cfif>
							<tr>
								<td></td><td colspan=5 class="thin-border-top">&nbsp;</td>
							</tr>
			</cfif>
		
		</cfoutput>
	
</table>
</cfif>
 <div class="button"> <input name="submit" type="image" src="../pics/update.gif" align="right" border=0></div>
</form>
