
<!--- CHECK INVOICE RIGHTS ---> 
<cfinclude template="check_rights.cfm">

<cfsetting requesttimeout="800">

<link rel="stylesheet" href="../smg.css" type="text/css">

<!--- <cfif #client.companyid# NEQ 1>
    <h1 align="center" style="padding-top:3cm">Trainee Program is not part of this company.</h1>
  <cfabort>
</cfif> --->

<!--- get work and travel candidates that:
1. Are active;
2. Have no charges created;
3. Have charges created but changed programs;
4. Have charges created but under the wrong agent;
5. Don't have all standard fees charged (ex: program price AND insurance fee AND placement fee AND sevis fee
6. Have had standard charges canceled
7. Have been canceled and reactivated afterwards --->
<cfquery name="getTraineeCand" datasource="MySQL">
SELECT e.candidateid, e.firstname, e.lastname, e.programid, e.companyid, sp.programname, sp.type
FROM extra_candidates e
INNER JOIN smg_users su ON su.userid = e.intrep
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND (sp.type = 7 OR sp.type = 8 OR sp.type = 9)
AND e.status != 'canceled'
AND e.entrydate > '2009-07-21' <!--- before this date, trainee invoices are manual --->
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND (sp.type = 7 OR sp.type = 8 OR sp.type = 9)
                        AND sc.programid = e.programid
                        AND sc.type = 'Program price'
                        AND sc.active = 1)
UNION
SELECT e.candidateid, e.firstname, e.lastname, e.programid, e.companyid, sp.programname, sp.type
FROM extra_candidates e
INNER JOIN smg_users su ON su.userid = e.intrep
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND (sp.type = 7 OR sp.type = 8 OR sp.type = 9)
AND e.status != 'canceled'
AND e.entrydate > '2009-07-21' <!---  before this date, trainee invoices are manual --->
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND (sp.type = 7 OR sp.type = 8 OR sp.type = 9)
                        AND sc.programid = e.programid
                        AND sc.type = 'Insurance fee'
                        AND sc.active = 1) 
UNION
SELECT e.candidateid, e.firstname, e.lastname, e.programid, e.companyid, sp.programname, sp.type
FROM extra_candidates e
INNER JOIN smg_users su ON su.userid = e.intrep
INNER JOIN smg_programs sp ON sp.programid = e.programid
WHERE e.intrep = #url.userid#
AND (sp.type = 7 OR sp.type = 8 OR sp.type = 9)
AND e.status != 'canceled'
AND e.entrydate > '2009-07-21' <!---  before this date, trainee invoices are manual --->
AND e.candidateid NOT IN (SELECT sc.stuid
                        FROM smg_charges sc
                        INNER JOIN smg_programs sp ON sp.programid = sc.programid
                        INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                        WHERE sc.agentid = e.intrep
                        AND (sp.type = 7 OR sp.type = 8 OR sp.type = 9)
                        AND sc.programid = e.programid
                        AND sc.type = 'Sevis fee'
                        AND sc.active = 1)
ORDER BY candidateid                                                                            
</cfquery>

<cfif getTraineeCand.recordCount EQ 0>
	<h1 align="center" style="padding-top:3cm">There are no candidates to be invoiced at this time.</h1>
  <cfabort>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Trainee Charges</title>
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

<cfset arrayStuId = ArrayNew(1)>
<cfloop query="getTraineeCand">
	<cfset aStuId = #arrayAppend(arrayStuId, "#getTraineeCand.candidateid#")#>
</cfloop>
<cfset qtStud = #getTraineeCand.recordCount#>

<cfoutput>
	<script type="text/javascript">
		var #toScript(arrayStuId, "jsArrayStuId")#;
		var #toScript(qtStud, "qtStud")#;
		var jsCounter = qtStud;
		
		function enabDisabCharge() {
			for (var i=0; i<=jsCounter-1; i++) {
				if(document.getElementById("typeSevisFee"+jsArrayStuId[i]).checked == true) {
					document.getElementById("sevisFee"+jsArrayStuId[i]).disabled = "";
					document.getElementById("sevisAmount"+jsArrayStuId[i]).disabled = "";
				}
				else {
					document.getElementById("sevisFee"+jsArrayStuId[i]).disabled = "disabled";
					document.getElementById("sevisAmount"+jsArrayStuId[i]).disabled = "disabled";			
				}
			}
		}
				
	</script>
</cfoutput>
</head>

<body>

<br/><br/>

<cfform name="workCharges" method="post" action="m_insertCharges.cfm?userid=#url.userid#&compid=#client.companyid#">

    <table align="center">
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
        <tr>
            <td colspan="4"></td>
        </tr>
    </table> 
    
    <cfoutput query="getTraineeCand">
	
		<cfinput type="hidden" name="agentId#getTraineeCand.candidateid#" value="#url.userid#">
		<cfinput type="hidden" name="programId#getTraineeCand.candidateid#" value="#getTraineeCand.programid#">
		<cfinput type="hidden" name="programName#getTraineeCand.candidateid#" value="#getTraineeCand.programname#">
		<cfinput type="hidden" name="companyId#getTraineeCand.candidateid#" value="#getTraineeCand.companyid#">
    
        <table class="frame" width="500">            
            <!--- default values for form variables to execute INSERT SQL --->
            <cfinput type="hidden" name="#getTraineeCand.candidateid#typeProgramFee" value="">
            <cfinput type="hidden" name="#getTraineeCand.candidateid#typeInsurance" value=""> 
            <cfinput type="hidden" name="#getTraineeCand.candidateid#typePlacementFee" value="">
            <cfinput type="hidden" name="#getTraineeCand.candidateid#typeSevisFee" value="">
         
            <!--- rules trainee charges --->
            <!--- set insurance & program fee for trainee --->
            <!--- new program fees entered on 01/20/2011 (Sergei's e-mail from 01/20/2011) --->
            <cfswitch expression="#getTraineeCand.programid#">
            	<cfcase value="194">
                	<cfset insuranceCost = 210>
                    <cfset programFee = 1650>
                </cfcase>
            	<cfcase value="195">
                	<cfset insuranceCost = 210>
                    <cfset programFee = 885>
                </cfcase>
            	<cfcase value="196">
                	<cfset insuranceCost = 420>
                    <cfset programFee = 1890>
                </cfcase>
            	<cfcase value="197">
                	<cfset insuranceCost = 420>
                    <cfset programFee = 1065>
                </cfcase>
            	<cfcase value="198">
                	<cfset insuranceCost = 630>
                    <cfset programFee = 2105>
                </cfcase>
            	<cfcase value="199">
                	<cfset insuranceCost = 630>
                    <cfset programFee = 1315>
                </cfcase>
            </cfswitch>
            
            <!--- queries to select charges to show in the form --->
            <cfquery name="chargeProgramPrice" datasource="MySQL">
            SELECT e.candidateid
            FROM extra_candidates e
            WHERE e.candidateid = #getTraineeCand.candidateid#
            AND e.candidateid NOT IN (SELECT sc.stuid
                                    FROM smg_charges sc
                                    INNER JOIN smg_programs sp ON sp.programid = sc.programid
                                    INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                                    WHERE sc.agentid = e.intrep
                                    AND (sp.type = 7 OR sp.type = 8 OR sp.type = 9)
                                    AND sc.programid = e.programid
                                    AND sc.type = 'Program price'
                                    AND sc.active = 1)
            </cfquery>
            
            <cfquery name="chargeInsuranceFee" datasource="MySQL">
            SELECT e.candidateid
            FROM extra_candidates e
            WHERE e.candidateid = #getTraineeCand.candidateid#
            AND e.candidateid NOT IN (SELECT sc.stuid
                                    FROM smg_charges sc
                                    INNER JOIN smg_programs sp ON sp.programid = sc.programid
                                    INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                                    WHERE sc.agentid = e.intrep
                                    AND (sp.type = 7 OR sp.type = 8 OR sp.type = 9)
                                    AND sc.programid = e.programid
                                    AND sc.type = 'Insurance fee'
                                    AND sc.active = 1)        
            </cfquery>
            
            <cfquery name="chargeSevisFee" datasource="MySQL">
            SELECT e.candidateid
            FROM extra_candidates e
            WHERE e.candidateid = #getTraineeCand.candidateid#
            AND e.candidateid NOT IN (SELECT sc.stuid
                                    FROM smg_charges sc
                                    INNER JOIN smg_programs sp ON sp.programid = sc.programid
                                    INNER JOIN extra_candidates e ON e.candidateid = sc.stuid
                                    WHERE sc.agentid = e.intrep
                                    AND (sp.type = 7 OR sp.type = 8 OR sp.type = 9)
                                    AND sc.programid = e.programid
                                    AND sc.type = 'Sevis fee'
                                    AND sc.active = 1)        
            </cfquery>
              
              <tr class="darkBlue" height="10">
                <td>
                <cfinput type="checkbox" name="candidateId" value="#getTraineeCand.candidateid#" checked="true">
                </td>
                <td>
                <strong><font color="##FFFFFF">#getTraineeCand.firstname# #getTraineeCand.lastname# (#getTraineeCand.candidateid#)</font></strong>
                </td>
                <td>
                <strong><font color="##FFFFFF">#getTraineeCand.programname#</font></strong>
                </td>
                <td>
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
                <cfinput type="text" name="#candidateId#programFeeAmount" value="#variables.programFee#">
                </td>
                <td>
                </td>            
             </tr>
             </cfif>
             <cfif chargeInsuranceFee.recordCount NEQ 0>
             <tr>
                <td>
                </td> 
                <td>
                <cfinput type="text" name="#candidateId#typeInsurance" id="insurance" value="Insurance fee">
                </td>
                <td>
                <cfinput type="text" name="#candidateId#insuranceAmount" id="insurance" value="#variables.insuranceCost#">
                </td>
                <td>
                </td>                       
             </tr>
             </cfif>
             <cfif chargeSevisFee.recordCount NEQ 0>
                 <tr>
                    <td>
                        <cfinput type="checkbox" name="typeSevisFee#candidateId#" value="Sevis fee" checked="no" onClick="javaScript:enabDisabCharge();">
                    </td>
                    <td>
                        <cfinput type="text" name="sevisFee#candidateId#" value="Sevis fee" disabled="disabled">
                    </td> 
                    <td>
                        <cfinput type="text" name="sevisAmount#candidateId#" value="180" disabled="disabled">
                    </td>
                    <td>
                    </td>
                 </tr>
             </cfif>
             <tr height="5">
                <td colspan="4"></td>
             </tr>
        </table>         
        <!--- end of trainee form --->
        <table>
            <tr height="20">
                <td colspan="4"></td>
            </tr>
        </table>
    
    </cfoutput>

</cfform>
</body>
</html>
