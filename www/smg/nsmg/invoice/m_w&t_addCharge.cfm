
<!--- CHECK INVOICE RIGHTS 
<cfinclude template="check_rights.cfm">---->

<cfsetting requesttimeout="800">

<link rel="stylesheet" href="../smg.css" type="text/css">

<cfif #client.companyid# NEQ 2>
    <h1 align="center" style="padding-top:3cm">Work and Travel Program is not part of this company.</h1>
  <cfabort>
</cfif>

<cfset todaysDate = DateFormat(Now(), 'yyyy/mm/dd')>

<!--- get work and travel candidates that:
1. Are active;
2. Have no charges created;
3. Have charges created but changed programs;
4. Have charges created but under the wrong agent;
5. Don't have all standard fees charged (ex: program price AND insurance fee AND placement fee AND sevis fee
6. Have had standard charges canceled
7. Have been canceled and reactivated afterwards --->
<cfquery name="getWorkCandidates" datasource="MySQL">
SELECT e.candidateid, IFNULL(e.verification_received, ' ') AS verification_received
FROM extra_candidates e
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND sp.type = 11
AND sp.enddate >= '#variables.todaysDate#'
AND e.status = 1
AND e.verification_received NOT LIKE ' '
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND sp.type = 11
                        AND sc.programid = e.programid
                        AND sc.type = 'Program price'
                        AND sc.active = 1)
UNION                                
SELECT e.candidateid, IFNULL(e.verification_received, ' ') AS verification_received
FROM extra_candidates e
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND sp.type = 11
AND sp.enddate >= '#variables.todaysDate#'
AND e.status = 1
AND e.verification_received NOT LIKE ' '
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND sp.type = 11
                        AND sc.programid = e.programid
                        AND sc.type = 'Insurance fee'
                        AND sc.active = 1)
UNION
SELECT e.candidateid, IFNULL(e.verification_received, ' ') AS verification_received
FROM extra_candidates e
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND sp.type = 11
AND sp.enddate >= '#variables.todaysDate#'
AND e.status = 1
AND e.verification_received NOT LIKE ' '
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND sp.type = 11
                        AND sc.programid = e.programid
                        AND sc.type = 'Placement fee'
                        AND sc.active = 1)
UNION
SELECT e.candidateid, IFNULL(e.verification_received, ' ') AS verification_received
FROM extra_candidates e
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND sp.type = 11
AND sp.enddate >= '#variables.todaysDate#'
AND e.status = 1
AND e.verification_received NOT LIKE ' '
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND sp.type = 11
                        AND sc.programid = e.programid
                        AND sc.type = 'Sevis fee'
                        AND sc.active = 1)                                       
ORDER BY verification_received
</cfquery>

<cfif getWorkCandidates.recordCount EQ 0>
	<h1 align="center" style="padding-top:3cm">There are no candidates to be invoiced at this time.</h1>
  <cfabort>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Work & Travel Charges</title>

<style type="text/css">
<!--
	table.frame 
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFE1;
	}
	
	tr.darkBlue
	{
	background-color:#0052A4;
	}
.style1 {color: #004080}
-->
</style>
</head>

<body>

<div class="application_section_header">Add Work and Travel Charges to Account</div><br><br>

<cfform name="form1">
    <table>
        <tr>
            <td>
            </td>
            <td> 
            <select name="dsVerRepDateRec" onChange="javaScript:this.form.submit();">
                <option></option>                                                   
                <cfoutput query="getWorkCandidates" group="verification_received">
                <option>#verification_received#</option>
                </cfoutput>                         
            </select>
            </td>
            <td>
            Select Verification Report <em>"Date Received"</em>
            </td>
        </tr>
        <tr height="20">
        </tr>
    </table>
</cfform>

<cfif NOT ISDEFINED('form.dsVerRepDateRec')>
    <cfabort>
</cfif>
    
<!--- gets work candidates with the chosen "ds verification report date received" --->
<cfquery name="getWorkCand" datasource="MySQL">
SELECT e.candidateid, e.firstname, e.lastname, e.wat_placement, e.programid, e.startdate, e.enddate, e.companyid, su.extra_insurance_typeid, su.extra_accepts_sevis_fee, sp.programname
FROM extra_candidates e
INNER JOIN smg_users su ON su.userid = e.intrep
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND sp.type = 11
AND e.verification_received = '#form.dsVerRepDateRec#'
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND sp.type = 11
                        AND sc.programid = e.programid
                        AND sc.type = 'Program price'
                        AND sc.active = 1)
UNION
SELECT e.candidateid, e.firstname, e.lastname, e.wat_placement, e.programid, e.startdate, e.enddate, e.companyid, su.extra_insurance_typeid, su.extra_accepts_sevis_fee, sp.programname
FROM extra_candidates e
INNER JOIN smg_users su ON su.userid = e.intrep
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND sp.type = 11
AND e.verification_received = '#form.dsVerRepDateRec#'
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND sp.type = 11
                        AND sc.programid = e.programid
                        AND sc.type = 'Insurance fee'
                        AND sc.active = 1) 
UNION
SELECT e.candidateid, e.firstname, e.lastname, e.wat_placement, e.programid, e.startdate, e.enddate, e.companyid, su.extra_insurance_typeid, su.extra_accepts_sevis_fee, sp.programname
FROM extra_candidates e
INNER JOIN smg_users su ON su.userid = e.intrep
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND sp.type = 11
AND e.verification_received = '#form.dsVerRepDateRec#'
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND sp.type = 11
                        AND sc.programid = e.programid
                        AND sc.type = 'Placement fee'
                        AND sc.active = 1)
UNION
SELECT e.candidateid, e.firstname, e.lastname, e.wat_placement, e.programid, e.startdate, e.enddate, e.companyid, su.extra_insurance_typeid, su.extra_accepts_sevis_fee, sp.programname
FROM extra_candidates e
INNER JOIN smg_users su ON su.userid = e.intrep
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND sp.type = 11
AND e.verification_received = '#form.dsVerRepDateRec#'
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND sp.type = 11
                        AND sc.programid = e.programid
                        AND sc.type = 'Sevis fee'
                        AND sc.active = 1)
ORDER BY candidateid                                                                            
</cfquery>

<cfform name="workCharges" method="post" action="m_insertCharges.cfm?userid=#url.userid#&compid=#client.companyid#">
      	<table>
        	<tr>
            	<td colspan="4"></td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                <cfinput type="image" name="submit"  src="../pics/update.gif">
                </td>
                <td colspan="2"></td>
            </tr>
            <tr height="12">
            	<td>
                </td>
                <td>
                <cfif ISDEFINED('form.dsVerRepDateRec')>
					<cfoutput>
                       <strong><span class="style1">Displaying now #getWorkCand.recordCount# candidates</span><br>
                       <span class="style1">DS Verification Report Received on #form.dsVerRepDateRec#</span></strong>                    </cfoutput>
                </cfif>
                </td>
            	<td colspan="2"></td>
            </tr>
            <tr>
            	<td colspan="4"></td>
            </tr>
        </table>    

<cfoutput query="getWorkCand">

	<cfinput type="hidden" name="agentId#getWorkCand.candidateid#" value="#url.userid#">
	<cfinput type="hidden" name="programId#getWorkCand.candidateid#" value="#getWorkCand.programid#">
	<cfinput type="hidden" name="programName#getWorkCand.candidateid#" value="#getWorkCand.programname#">
	<cfinput type="hidden" name="companyId#getWorkCand.candidateid#" value="#getWorkCand.companyid#">
    
    <table class="frame" width="500">            
        <!--- default values for form variables to execute INSERT SQL --->
        <cfinput type="hidden" name="#getWorkCand.candidateid#typeProgramFee" value="">
        <cfinput type="hidden" name="#getWorkCand.candidateid#typeInsurance" value=""> 
        <cfinput type="hidden" name="#getWorkCand.candidateid#typePlacementFee" value="">
        <cfinput type="hidden" name="#getWorkCand.candidateid#typeSevisFee" value="">
     
        <!--- rules for work and travel charges --->
		<!--- calculates insurance cost for work and travel --->
        <cfparam name="programLength" default="">
		<cfparam name="insuranceCost" default="1">
		<cfif #getWorkCand.extra_insurance_typeid# EQ 14 AND ISDATE(getWorkCand.startdate) AND ISDATE(getWorkCand.enddate)>
			<cfset progLengTest1 = #DateDiff("d",getWorkCand.startdate,getWorkCand.enddate)#>
            <cfset progLengTest2 = #progLengTest1# / 7><!--- length in weeks --->
            <cfset progLengTest = #progLengTest2# - #Int(progLengTest2)#>
            <cfif progLengTest EQ 0><!--- it means the length is an integer --->
				<cfset programLength = #progLengTest2#>
                <cfelse>
                	<cfset programLength = #Int(progLengTest2)# + 1>
            </cfif>
            <cfset insuranceCostPerWeek = 23 / 4>
            <cfset insuranceCost = Round(#insuranceCostPerWeek# * #programLength#)>
        </cfif>
        
        <!--- queries to select charges to show in the form --->
        <cfquery name="chargeProgramPrice" datasource="MySQL">
        SELECT e.candidateid
        FROM extra_candidates e
        WHERE e.candidateid = #getWorkCand.candidateid#
        AND e.candidateid NOT IN (SELECT sc.stuid
                                FROM smg_charges sc
                                INNER JOIN smg_programs sp ON sp.programid = sc.programid
                                INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                                WHERE sc.agentid = e.intrep
                                AND sp.type = 11
                                AND sc.programid = e.programid
                                AND sc.type = 'Program price'
                                AND sc.active = 1)
       	</cfquery>
        
        <cfquery name="chargeInsuranceFee" datasource="MySQL">
        SELECT e.candidateid
        FROM extra_candidates e
        WHERE e.candidateid = #getWorkCand.candidateid#
        AND e.candidateid NOT IN (SELECT sc.stuid
                                FROM smg_charges sc
                                INNER JOIN smg_programs sp ON sp.programid = sc.programid
                                INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                                WHERE sc.agentid = e.intrep
                                AND sp.type = 11
                                AND sc.programid = e.programid
                                AND sc.type = 'Insurance fee'
                                AND sc.active = 1)        
        </cfquery>
        
        <cfquery name="chargePlacementFee" datasource="MySQL">
        SELECT e.candidateid
        FROM extra_candidates e
        WHERE e.candidateid = #getWorkCand.candidateid#
        AND e.candidateid NOT IN (SELECT sc.stuid
                                FROM smg_charges sc
                                INNER JOIN smg_programs sp ON sp.programid = sc.programid
                                INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                                WHERE sc.agentid = e.intrep
                                AND sp.type = 11
                                AND sc.programid = e.programid
                                AND sc.type = 'Placement fee'
                                AND sc.active = 1)        
        </cfquery>
        
        <cfquery name="chargeSevisFee" datasource="MySQL">
        SELECT e.candidateid
        FROM extra_candidates e
        WHERE e.candidateid = #getWorkCand.candidateid#
        AND e.candidateid NOT IN (SELECT sc.stuid
                                FROM smg_charges sc
                                INNER JOIN smg_programs sp ON sp.programid = sc.programid
                                INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                                WHERE sc.agentid = e.intrep
                                AND sp.type = 11
                                AND sc.programid = e.programid
                                AND sc.type = 'Sevis fee'
                                AND sc.active = 1)        
        </cfquery>
          
          <tr class="darkBlue" height="10">
            <td>
            <cfinput type="checkbox" name="candidateId" value="#getWorkCand.candidateid#" checked="true">
            </td>
            <td>
            <strong><font color="##FFFFFF">#getWorkCand.firstname# #getWorkCand.lastname# (#getWorkCand.candidateid#)</font></strong>
            </td>
            <td>
            <strong><font color="##FFFFFF">#getWorkCand.programname#</font></strong>
            </td>
            <td>
            <strong><font color="##FFFFFF">#programLength# <cfif #programLength# IS NOT ''> weeks</cfif></font></strong>
            </td>
         </tr> 
    	 <tr height="5">
         	<td colspan="4"></td>
         </tr>                    
		<!--- display work and travel form --->  
         <cfif chargeProgramPrice.recordCount NEQ 0>
         <tr>
            <td>
            </td> 
            <td>
            <cfinput type="text" name="#candidateId#typeProgramFee" value="Program price">
            </td> 
            <td>
            <cfinput type="text" name="#candidateId#programFeeAmount" value="400">
            </td>
            <td>
            </td>            
         </tr>
         </cfif>
         <cfif chargeInsuranceFee.recordCount NEQ 0>
         <tr>
            <td>
            </td>
			<cfif #insuranceCost# NEQ 1> 
                <td>
                <cfinput type="text" name="#candidateId#typeInsurance" id="insurance" value="Insurance fee">
                </td>
                <td>
                <cfinput type="text" name="#candidateId#insuranceAmount" id="insurance" value="#insuranceCost#">
                </td>                
                    <cfelse>
                    <td>
                    Agent does not take insurance
                    </td>
                    <td>
                    </td>				                                                        
            </cfif>             
            <td>
            </td>                       
         </tr>
         </cfif>
         <cfif chargePlacementFee.recordCount NEQ 0>
         <tr>
            <td>
            </td>
            <cfif #getWorkCand.wat_placement# IS "INTO-Placement">
                <td>
                <cfinput type="text" name="#candidateId#typePlacementFee" value="Placement fee">
                </td> 
                <td>
                <cfinput type="text" name="#candidateId#placementFeeAmount" value="200">
                </td>
                    <cfelse>
                    <td>
                    Candidate is Self-Placement
                    </td>
                    <td>
                    </td>
            </cfif>
            <td>
            </td>
         </tr>
         </cfif>
         <cfif chargeSevisFee.recordCount NEQ 0>
         <tr>
            <td>
            </td>
            <cfif #getWorkCand.extra_accepts_sevis_fee# EQ 1>
                <td>
                    <cfinput type="text" name="#candidateId#typeSevisFee" value="Sevis fee">
                </td> 
                <td>
                    <cfinput type="text" name="#candidateId#sevisAmount" value="35">
                </td>
                <cfelse>
                    <td>
                    Agent does not accept sevis fee
                    </td>
                    <td>
                    </td>
            </cfif>
            <td>
            </td>
         </tr>
         </cfif>
         <tr height="5">
         	<td colspan="4"></td>
         </tr>
    </table>         
	<!--- end of work and travel form --->
    <table>
    	<tr height="20">
        	<td colspan="4"></td>
        </tr>
    </table>      
</cfoutput>
    
</cfform>

</body>

</html>

