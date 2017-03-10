<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfsetting requesttimeout="800">

<link rel="stylesheet" href="../smg.css" type="text/css">

<head>
	<title>Add Charges to Account</title>
</head>

<style type="text/css">
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
</style>

<!--- Get Student info --->
<cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
	SELECT 
        smg_students.*, 
        smg_programs.startDate, 
        smg_programs.endDate, 
        smg_programs.blank, 
        smg_programs.hold, 
        smg_programs.programname, 
        CASE
        	WHEN smg_students.companyID = 14 THEN smg_regions.regionname
            ELSE placed_state.region_guarantee
            END AS regionname,
        placed_state.statename,
        CASE
            WHEN smg_students.state_guarantee = 0 AND smg_students.hostID != 0 THEN 
            	CASE
                	WHEN (smg_students.app_region_guarantee = 6 AND (SELECT region_guarantee FROM smg_states WHERE state = (SELECT state FROM smg_hosts WHERE hostID = smg_students.hostID) LIMIT 1) = "West") THEN "West"
                    WHEN (smg_students.app_region_guarantee = 7 AND (SELECT region_guarantee FROM smg_states WHERE state = (SELECT state FROM smg_hosts WHERE hostID = smg_students.hostID) LIMIT 1) = "Central") THEN "Central"
                    WHEN (smg_students.app_region_guarantee = 8 AND (SELECT region_guarantee FROM smg_states WHERE state = (SELECT state FROM smg_hosts WHERE hostID = smg_students.hostID) LIMIT 1) = "South") THEN "South"
                    WHEN (smg_students.app_region_guarantee = 9 AND (SELECT region_guarantee FROM smg_states WHERE state = (SELECT state FROM smg_hosts WHERE hostID = smg_students.hostID) LIMIT 1) = "East") THEN "East"
                  	END
            WHEN smg_students.hostID != 0 THEN state_guarantee.statename
            END AS guar_name,
        CASE
            WHEN smg_students.state_guarantee = 0 THEN region_guarantee.regional_guarantee
            ELSE state_guarantee.guarantee_fee
            END AS guar_fee,
       CASE
            WHEN smg_students.state_guarantee = 0 THEN CONCAT('Regional Guarantee: ',region_guarantee.regionname)
            ELSE CONCAT('State Guarantee: ',state_guarantee.statename)
            END AS guar_type     
    FROM smg_students
    INNER JOIN smg_programs ON smg_programs.programID = smg_students.programID
        AND smg_programs.startDate >= '09/01/2004'    
        AND smg_programs.blank = 0
    LEFT JOIN smg_regions ON smg_regions.regionID = smg_students.regionassigned
    LEFT JOIN smg_regions region_guarantee ON region_guarantee.regionID = smg_students.regionalGuarantee
    LEFT JOIN smg_states state_guarantee ON state_guarantee.id = smg_students.state_guarantee
    LEFT JOIN smg_states placed_state ON placed_state.state = (SELECT state FROM smg_hosts WHERE hostID = smg_students.hostID)
    WHERE smg_students.active = 1
    AND smg_students.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
    AND smg_students.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
</cfquery>

<!--- Get Agent info --->
<cfquery name="qGetUser" datasource="#APPLICATION.DSN#">
	SELECT
    	smg_users.accepts_sevis_fee,
        smg_users.insurance_typeid,
        <cfif VAL(qGetStudents.recordCount)>
			<cfif #DateDiff('M', qGetStudents.startdate, qGetStudents.enddate)# gt 6>
                smg_users.10_month_price as program_fee, 
                smg_insurance_type.ayp10 as insurance_charge
            <cfelse>
                smg_users.5_month_price as program_fee, 
                smg_insurance_type.ayp5 as insurance_charge
            </cfif>
		<cfelse>
			smg_users.10_month_price as program_fee, 
         	smg_insurance_type.ayp10 as insurance_charge
		</cfif>
  	FROM smg_users
    INNER JOIN smg_insurance_type ON smg_insurance_type.insutypeid = smg_users.insurance_typeid
    WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
</cfquery>

<cfquery name="charge_type" datasource="#APPLICATION.DSN#">
	SELECT type, description
	FROM smg_charge_type
</cfquery>

<cfoutput>

	<div class="application_section_header">Add Charges to Account</div>
    <br/>
    <b>></b>
    <u>Misc Charges, not necessarily tied to a student.</u>
    <br/><br/>

	<form method="post" action="insert_charge_query.cfm" enctype="multipart/form-data">
		<input type="hidden" name=agentid value="#url.userid#">
        Type:
        <select name="type">
			<cfloop query="charge_type">
				<option value="#type#">#type#</option>
			</cfloop>
		</select>
 		Description: <input type="text" name="description" size=25 value="">  
        Amount: <input type="text" name="amount" size=8 value="">
        <br/>
        <br/>
 		<div class="button"><input name="submit" type="image" src="../pics/update.gif" align="right" border=0></div>
    </form>
 
 	<br/>
    <br/>
 	<hr width="80%"/>
 	<br/>
 
</cfoutput>

<form method="post" action="insert_student_charge_query.cfm" enctype="multipart/form-data">

	<input type="hidden" name="agentid" value="<cfoutput>#url.userid#</cfoutput>" />

	<b>></b>
    <u>Students that need to have fees applied</u>
	<br/>
    
    <cfif qGetStudents.recordcount is 0>
    	
        This agent does not have any students currently active OR all students have had charges applied.
    
    <cfelse>
    
    	<table cellpadding = 4 cellspacing=0 border=0>
			
            <tr>
				<td valign="top" colspan=3><img src="../pics/arrow_left_down.gif" align=left><b>Select students to create charges for.</b></td>
			</tr>
			<tr>
                <td>&nbsp;</td>
                <td>Student</td>
                <td>Program</td>
			</tr>
             
            <cfoutput query="qGetStudents">          
        
        		<cfquery name="check_charges" datasource="#APPLICATION.DSN#">
                	SELECT type, description, amount
                    FROM smg_charges
                    WHERE stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentid#"> 
                    AND programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.programid#">
                    AND agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.intrep#">
                    AND active = 1
                    ORDER BY type
                </cfquery>
                
                <cfquery name="qGetStudentCharges" datasource="#APPLICATION.DSN#">
                	SELECT
                        smg_users.insurance_typeid
                        <cfif #DateDiff('M', qGetStudents.startdate, qGetStudents.enddate)# gt 10>
                        	,smg_users.12_month_price as program_fee 
                            ,smg_insurance_type.ayp12 as insurance_charge
						<cfelseif #DateDiff('M', qGetStudents.startdate, qGetStudents.enddate)# gt 6>
                            ,smg_users.10_month_price as program_fee 
                            ,smg_insurance_type.ayp10 as insurance_charge
                        <cfelse>
                            ,smg_users.5_month_price as program_fee
                            ,smg_insurance_type.ayp5 as insurance_charge
                        </cfif>
                    FROM smg_users
                    INNER JOIN smg_insurance_type ON smg_insurance_type.insutypeid = smg_users.insurance_typeid
                    WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#">
                </cfquery>
                
                <cfquery name="check_depositCharge" dbtype="query">
                    SELECT *
                    FROM check_charges
                    WHERE type = 'deposit'
                </cfquery>
                
                <cfif qGetStudents.hold eq 0 or (onhold_approved lte '5' and onhold_approved gte '7')>
                    
                    <tr bgcolor=<cfif (onhold_approved lte '5' and onhold_approved gte '7')>fee6d3<cfelse><cfif qGetStudents.currentrow mod 2>ededed<cfelse>ffffff</cfif></cfif>>
                        <td class="thin-border-left-bottom-top">
                            <input type="checkbox" name="studentid" value="#studentid#" 
                                <cfif 
                                    NOT (
                                        (hostid IS 0 AND check_charges.recordcount EQ 1) 
                                        OR LISTFIND("5,6,7",onhold_approved) 
                                        OR verification_received IS '' 
                                        OR CLIENT.companyid EQ 14 ) 
                                    AND NOT (qGetStudents.startdate LT '02/01/2005')>
                                    checked="checked"
                                </cfif>
                            >
                        </td>
                        <td class="thin-border-top">#firstname# #familylastname# (#studentid#
                         <cfif val(#nexits_id#)><em><font color="##ccc">N:#nexits_id#</font></em></cfif>)
					    </td>
                        <td class="thin-border-top">#qGetStudents.programname#</td>
                        <td class="thin-border-top">
                            <cfif verification_received is ''>
                                DS 2019 Verification Not Received
                            <cfelseif hostid is '' or hostid is 0>
                                Unplaced
                            <cfelse>
                                Placed
                            </cfif>
                            <cfif direct_placement is 1>
                                 - Direct
                            </cfif>
                            <cfif (onhold_approved gte '5' and onhold_approved lte '7')>
                                &nbsp;&nbsp;ON HOLD
                            </cfif>
                        </td> 
                        <td class="thin-border-top-right">District: #qGetStudents.regionname#</td>
                    </tr>
                    
                    <cfif NOT (onhold_approved gte '5' and onhold_approved lte '7')>
                    
                        <input type="hidden" name="#qGetStudents.studentid#direct_placement_guarantee_disc" value="">
                        <input type="hidden" name="#qGetStudents.studentid#guarantee_amount" value="">
                        <input type="hidden" name="#qGetStudents.studentid#programid" value="#programid#">
                    
                        <cfif check_depositCharge.recordcount is 0 AND NOT ListFind("13,15",CLIENT.companyID)>
                            <input type="hidden" name="#qGetStudents.studentid#deposit_type" value='deposit'>
                            <input type="hidden" name="#qGetStudents.studentid#insurance_amount" value="">
                            <input type="hidden" name="#qGetStudents.studentid#final_amount" value="">
                            <input type="hidden" name="#qGetStudents.studentid#sevis_amount" value="">
                            <input type="hidden" name="#qGetStudents.studentid#direct_placement" value="">
                            
                            <tr bgcolor="<cfif qGetStudents.currentrow mod 2>ededed<cfelse>ffffff</cfif>">
                                <td bgcolor="ffffff">&nbsp;</td>
                                <td class="thin-border-left-bottom">
                                    Type: Deposit
                                </td>
                                <td class="thin-border-bottom">
                                    Charge: <input type="text" name="#studentid#deposit_amount" value=750 size="6">
                                </td>
                                <td class="thin-border-bottom">
                                    Desc: <input type="text" size="14" name="#studentid#deposit_description" value='#qGetStudents.programname#'>
                                </td>
                                <td class="thin-border-right-bottom">&nbsp;</td>
                            </tr>
                            
                        <cfelse>
                            
                            <cfset charge_list =''>
                            <input type="hidden" name="#studentid#deposit_amount" value="">
                            <cfloop query="check_charges">
                                <tr>
                                    <Td bgcolor="ffffff"></Td>
                                    <td bgcolor="FFFF99" class="thin-border-left">#type#</td>
                                    <td bgcolor="FFFF99" >#description#</td>
                                    <Td bgcolor="FFFF99">#amount#</Td>
                                    <td bgcolor="FFFF99" class="thin-border-right">&nbsp;</td>
                                </tr>
                                <cfset charge_list = ListAppend(charge_list, '#type#')>
                            </cfloop>
                            
                            <!----Final Program Charge---->
                            <cfif ListContainsNoCase(charge_list, 'program fee')>
                                <input type="hidden" name="#studentid#final_amount" value="">
                            <cfelse>
                                <input type="hidden" name="#qGetStudents.studentid#final_type" value="program fee">
                                <tr>
                                    <td></td>
                                    <td class="thin-border-left">Type: Program Fee</td>
                                    <td>Charge: <input type="text" name="#qGetStudents.studentid#final_amount" value="#qGetStudentCharges.program_fee#" size="6"></td>
                                    <td> Desc: <input type="text" size="14" name="#qGetStudents.studentid#final_description" value='#qGetStudents.programname#'></td>
                                    <td class="thin-border-right"></td>
                                </tr>
                            </cfif>
                            
                            <!----Insurance Charge---->
                            <cfif ListContainsNoCase(charge_list, 'insurance')>
                                <input type="hidden" name="#qGetStudents.studentid#insurance_amount" value="">
                            <cfelse>
                                <cfif qGetUser.insurance_typeid EQ '1'> <!--- type 1 = none --->
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td colspan = 4 class="thin-border-left-right">
                                            Agent doesn't take insurance <input type="hidden" name="#qGetStudents.studentid#insurance_amount" value="">
                                        </td>
                                    </tr>
                                <cfelse>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td class="thin-border-left">Type: <input type="hidden" name="#qGetStudents.studentid#insurance_type" value='insurance'>Insurance</td>
                                        <td>Charge: <input type="text" name="#qGetStudents.studentid#insurance_amount" value="#qGetStudentCharges.insurance_charge#" size="6"></td>
                                        <td> Desc: <input type="text" size="14" name="#qGetStudents.studentid#insurance_description" value='#qGetStudents.programname#'></td>	
                                        <td class="thin-border-right">&nbsp;</td>							
                                    </tr>
                                </cfif>
                            </cfif>
                            
                            <!----Guarantee Charge---->
                            <cfif NOT ListContainsNoCase(charge_list, 'guarantee') AND ListFind('1,2,3,4',qGetStudents.host_fam_approved)>
                                <cfif qGetStudents.app_region_guarantee EQ 0 AND qGetStudents.state_guarantee EQ 0>
                                    <tr>
                                        <td></td>
                                        <td colspan = 5 class="thin-border-left-right">
                                            Student doesn't have a regional or state guarantee
                                        </td>
                                    </tr>
                                <cfelseif (qGetStudents.statename EQ qGetStudents.guar_name OR qGetStudents.regionname EQ qGetStudents.guar_name) AND qGetStudents.guar_name NEQ "">
                                    <tr>
                                        <td></td>
                                        <td class="thin-border-left">Type: <input type="hidden" name="#qGetStudents.studentid#guarantee_type" value='guarantee'>Guarantee</td>
                                        <td>Charge: <input type="text" name="#qGetStudents.studentid#guarantee_amount" value="#qGetStudents.guar_fee#" size="6"></td>
                                        <td> Desc: <input type="text" size="14" name="#qGetStudents.studentid#guarantee_description" value='#qGetStudents.guar_type#'></td>
                                        <td class="thin-border-right"></td>
                                    </tr>
                                    <cfif dateplaced lt '0001/01/01 00:00:00' or dateplaced gt '05/11/2005 01:00:00' or hostid is 0>
                                        <cfquery name="check_sts" datasource="#APPLICATION.DSN#">
                                            SELECT userID
                                            FROM smg_users
                                            WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
                                            AND businessname LIKE '%sts%'
                                        </cfquery>
                                        <cfif check_sts.recordcount gt 0>
                                            <cfset sts = 1>
                                        <cfelse> 
                                            <cfset sts = 0>
                                        </cfif>
                                        <cfif direct_placement IS '1' OR (jan_app IS '1' AND sts IS '0')>
                                            <cfif qGetStudents.guar_fee EQ ''>
                                                <cfset direct_placement_reg_guar = 'MISSING Guarantee Information'>
                                            <cfelse>
                                                <cfset direct_placement_reg_guar = qGetStudents.guar_fee * -1>
                                            </cfif>	
                                            <!--- there are few exceptions for state guarantee - set description to state or region guarantee --->
                                            <cfif state_guarantee EQ 0>
                                                <cfset desc_value = 'Free Regional Guarantee'>
                                            <cfelse>
                                                <cfset desc_value = 'Special Discount: Free State Guarantee'>
                                            </cfif>
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td class="thin-border-left">Type: <input type="hidden" name="#qGetStudents.studentid#direct_placement_guarantee_disc" value='guarantee'>Direct Placement Guarantee disc.</td>
                                                <td>Charge: <input type="left" name="#qGetStudents.studentid#direct_placement_guarantee_disc_amount" value="#direct_placement_reg_guar#" size="6"></td>
                                                <td> Desc: <input type="text" size="14" name="#qGetStudents.studentid#direct_placement_guarantee_disc_desc" value='#desc_value#'></td>
                                                <td class="thin-border-right">&nbsp;</td>
                                            </tr>
                                        </cfif>
                                    <cfelse>
                                        <input type="hidden" name="#qGetStudents.studentid#direct_placement_guarantee_disc" value=''>
                                    </cfif>
                                </cfif>
                            </cfif>
                            
                            <!----SEVIS Fee---->
                            <cfif ListContainsNoCase(charge_list, 'sevis')>
                                <input type="hidden" name="#qGetStudents.studentid#sevis_amount" value="">
                            <cfelse>
                                <cfif qGetUser.accepts_sevis_fee is 0>
                                    <input type="hidden" name="#qGetStudents.studentid#sevis_amount" value="">
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td colspan="4" class="thin-border-left-right">
                                            Agent doesn't accept SEVIS fee.
                                        </td>
                                    </tr>
                                <cfelse>
                                    <input type="hidden" name="#qGetStudents.studentid#sevis_type" value='sevis'>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td class="thin-border-left">Type: SEVIS</td>
                                        <td>Charge: <input type="text" name="#qGetStudents.studentid#sevis_amount" value="180.00" size="6"></td>
                                        <td>Desc: <input type="text" size="14" name="#qGetStudents.studentid#sevis_description" value='SEVIS Fee'></td>
                                        <td class="thin-border-right">&nbsp;</td>
                                    </tr>
                                </cfif>
                            </cfif>
                            
                            <!---- Direct Placement Discount---->
                            <cfif ListContainsNoCase(charge_list, 'direct placement') OR direct_placement NEQ 1 OR #qGetStudents.studentid# EQ 820>
                                <input type="hidden" name="#qGetStudents.studentid#direct_placement" value="">
                                <input type="hidden" name="#qGetStudents.studentid#direct_placement_reg_guarnatee" value="">
                                <input type="hidden" name="#qGetStudents.studentid#direct_placement_guarantee_disc" value="">
                            <cfelse>
                                <cfif dateplaced lt '0001-01-01 00:00:00' or dateplaced gt '04/27/2005 01:00:00' or hostid is 0  >
                                    <input type="hidden" name="#qGetStudents.studentid#direct_placement" value='direct placement'>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td class="thin-border-left">Type: Direct Placement</td>
                                        <td>Charge: <input type="text" name="#qGetStudents.studentid#direct_placement_amount" value="-200.00" size="6"></td>
                                        <td>Desc: <input type="text" size="14" name="#qGetStudents.studentid#direct_placement_description" value='Direct Placement Discount'></td>
                                        <td class="thin-border-right">&nbsp;</td>
                                    </tr>
                                <cfelse>
                                    <input type="hidden" name="#qGetStudents.studentid#direct_placement" value="">
                                </cfif>
                            </cfif>
                            
                        </cfif>
                    
                    </cfif>

                </cfif>
                <!----
                <tr>
                    <td>&nbsp;</td>
                    <td colspan=5 class="thin-border-top">&nbsp;</td>
                </tr>
                ---->
          	</cfoutput>
            
     	</table>
    
    </cfif>
    
    <div class="button"> <input name="submit" type="image" src="../pics/update.gif" align="right" border=0></div>

</form>