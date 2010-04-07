<!--- CHECK INVOICE RIGHTS  --->
<cfinclude template="check_rights.cfm">

<cfsetting requesttimeout="800">

<link rel="stylesheet" href="../smg.css" type="text/css">
<style type="text/css">
<!--
.style1 {
	color: #004080;
	font-weight: bold;
}
.style4 {color: #FFFFFF; font-weight: bold; }
.style9 {color: #FF0000}
-->
</style>

<script type="text/javascript">
	function openerReload() {
		opener.location.reload();
	}
</script>

<div class="application_section_header">MISCELLANEOUS CHARGES</div></br></br>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Miscellaneous Charges</title>

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
	
	td.right
	{
	border-right-style:solid;
	border-right-width:thin;
	border-right-color:#004080;
	border-right-collapse:collapse;
	padding:4px;
	}
	
	.box
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFFF;
	}
	
	tr.darkBlue
	{
	background-color:#0052A4;
	}
.style5 {color: #FFFFFF}
.style6 {
	color: #FF0000;
	font-weight: bold;
}
.style7 {
	font-size: 10px;
	font-style: italic;
}
.style8 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
</head>

<body>

<cfoutput> 
<form method="post" action="m_processCancellation.cfm?userid=#url.userid#" onsubmit="javaScript:openerReload();">

<input type="hidden" name="agentid" value="#url.userid#">
</cfoutput>
<!----Miscellaneous charges NOT related to a student---->
<span class="get_attention"><b>></b></span><u><span class="style8">Miscellaneous charges NOT tied to a </span><strong>student.</strong></u>
<br>
<br>
<cfparam name="stuid" default=0>
<cfoutput>
<table>
	<tr>
    	<td>Description: </td>
        <td><input type="text" name="description" size=25 value='Description'></td>
    	<td>Amount: </td>
        <td><input type="text" name="amount" size=8 value='amount'></td>
	</tr>
    <tr>
    	<td/>
        <td>
		<input name="submit" type="image" src="../pics/update.gif" align="left" border=0>
        </td>
	</tr>
</table>
</form>
<br/><br/>
<hr width=40%>
<br/>

</cfoutput>

<!--- Miscellaneous charges related to a student --->
<br/><br/>
<span class="get_attention"><b>></b></span><u><span class="style8">Miscellaneous charges TIED to a </span><strong>student.</strong></u>
<cfform>
	<cfinput type="hidden" name="submitted" value="1">
<table style="padding-top:0.5cm">
    <tr>
        <td colspan="2">
        </td>
        <td>
        Choose Program type:
        </td>
        <td>
        <select name="chooseProgram">
            <option>High School</option>
            <option>Work Program</option>
        </select>    
        </td>
    </tr>         
    <tr>
        <td colspan="2"></td>
        <td>
        Enter student ID number or invoice number:
        </td>
        <td>
        <cfinput type="text" name="studId" size="50"><br/>
        <span class="style7">"You can enter as many student IDs as you want (<span class="style6">SEPARATED BY SINGLE SPACE</span>)"</span></td>
        <td></td>
    </tr> 
    <tr>
    	<td colspan="2"/>
        <td/>
        <td><cfinput type="image" name="submit3"  src="../pics/update.gif"></td>
        <td/>
    </tr> 
</table>
</cfform>

<cfparam name="form.studId" default="0">

<cfif NOT ISDEFINED('form.submitted')>
	<cfabort>
</cfif>

<cfif form.studId IS "">
    <h1 align="center" style="padding-top:3cm">You need to enter a student ID number!</h1>
    <cfabort>
</cfif>

<cfswitch expression="#form.chooseProgram#">
    <cfcase value="High School">
        <cfquery name="getSmgChargesCredit" datasource="MySQL">
        SELECT s.chargeid, s.agentid, s.invoiceid, s.amount_due, s.stuid, s.companyid, s.programid, s.active, s.type AS charge_type, sp.type, sp.programname, su.accepts_sevis_fee, sc.creditid AS creditid, sc.amount AS amount, sc.description AS description, sc.type AS creditType
        FROM smg_charges s
        LEFT JOIN smg_credit sc ON s.chargeid = sc.chargeid
        INNER JOIN smg_programs sp ON sp.programid = s.programid
        INNER JOIN smg_users su ON su.userid = s.agentid
        WHERE s.agentid =#url.userid#
        AND (<cfloop index="students" list="#form.studId#" delimiters=" ">
        		s.stuid =#students#
                <cfif students NEQ #listLast(form.studId, " ")#>
                	OR
                </cfif>
             </cfloop>) 
        AND s.companyid =#client.companyid#
        AND (sp.type !=7
            AND sp.type !=8
            AND sp.type !=9
            AND sp.type !=11
            AND sp.type !=22
            AND sp.type !=23)
        </cfquery> 
	</cfcase>
    <cfcase value="Work Program">
        <cfquery name="getSmgChargesCredit" datasource="MySQL">
        SELECT s.chargeid, s.agentid, s.invoiceid, s.amount_due, s.stuid, s.companyid, s.programid, s.active, s.type AS charge_type, sp.type, sp.programname, e.firstname, e.lastname, e.active AS stud_active, sc.creditid creditid, sc.amount AS amount, sc.description AS description, sc.type AS creditType, su.extra_accepts_sevis_fee
        FROM  `smg_charges` s
        LEFT JOIN smg_credit sc ON s.chargeid = sc.chargeid
        INNER JOIN smg_programs sp ON sp.programid = s.programid
        INNER JOIN extra_candidates e ON e.candidateid = s.stuid
        INNER JOIN smg_users su ON su.userid = s.agentid
        WHERE s.agentid =#url.userid#
        AND (<cfloop index="students" list="#form.studId#" delimiters=" ">
        		s.stuid =#students#
                <cfif students NEQ #listLast(form.studId, " ")#>
                	OR
                </cfif>
             </cfloop>)
        AND s.companyid =#client.companyid#
        AND (sp.type =7
            OR sp.type =8
            OR sp.type =9
            OR sp.type =11
            OR sp.type =22
            OR sp.type =23)
        </cfquery>
    </cfcase>
</cfswitch>

<cfset arrayStuId = listToArray(form.studId, " ")>
<cfset qtStud = listLen(form.studId, " ")>

<cfoutput>
	<script type="text/javascript">
		var #toScript(arrayStuId, "jsArrayStuId")#;
		var #toScript(qtStud, "qtStud")#;
		var jsCounter = qtStud;
		
		function enabDisabCharge() {
			for (var i=0; i<=jsCounter-1; i++) {
				for (var x=0; x<=4; x++) {                
					if(document.getElementById("charge"+x+jsArrayStuId[i]) != undefined) {
						if(document.getElementById("charge"+x+jsArrayStuId[i]).checked == true) {
							document.getElementById("type"+x+jsArrayStuId[i]).disabled = "";
							document.getElementById("amount"+x+jsArrayStuId[i]).disabled = "";
						}
						else {
							document.getElementById("type"+x+jsArrayStuId[i]).disabled = "disabled";
							document.getElementById("amount"+x+jsArrayStuId[i]).disabled = "disabled";			
						}		
					}
				}
			}
		}
				
	</script>
</cfoutput>

<br/><br/><br/>

<cfform name="header" method="post" action="m_processCancellation.cfm?userid=#url.userid#">
<table align="center">
    <tr align="center">
      <td align="center"><cfinput type="image" name="submit2"  src="../pics/update.gif"> <br/>
      <em><strong>(<span class="style9">Press to process charges</span>)</strong></em></td>
    </tr>
</table>


<cfloop index="student" list="#form.studId#" delimiters=", ">

    <cfswitch expression="#form.chooseProgram#">
        <cfcase value="High School">
            <cfquery name="getStudents" datasource="MySQL">
            SELECT DISTINCT(s.stuid) AS stuid
            FROM smg_charges s
            INNER JOIN smg_programs sp ON sp.programid = s.programid
            WHERE s.stuid =#student#
            AND s.agentid =#url.userid#
            AND s.companyid =#client.companyid#
            AND (sp.type !=7
                AND sp.type !=8
                AND sp.type !=9
                AND sp.type !=11
                AND sp.type !=22
                AND sp.type !=23)
            </cfquery>
        </cfcase>
        <cfcase value="Work Program">
            <cfquery name="getStudents" datasource="MySQL">
            SELECT DISTINCT(s.stuid) AS stuid
            FROM smg_charges s
            INNER JOIN smg_programs sp ON sp.programid = s.programid
            WHERE s.stuid =#student#
            AND s.agentid =#url.userid#
            <!--- AND s.companyid =#client.companyid# --->
            AND (sp.type =7
                OR sp.type =8
                OR sp.type =9
                OR sp.type =11
                OR sp.type =22
                OR sp.type =23)
            </cfquery>    
        </cfcase>
    </cfswitch>
    
    <cfif getStudents.recordCount EQ 0>
    
        <cfswitch expression="#form.chooseProgram#">
            <cfcase value="High School">
                <cfquery name="getStudName" datasource="MySQL">
                SELECT s.studentid, s.firstname, s.familylastname AS lastname, s.intrep, s.companyid, su.businessname
                FROM smg_students s
                INNER JOIN smg_users su ON su.userid = s.intrep
                WHERE s.studentid = #student#
                </cfquery> 
            </cfcase>
            <cfcase value="Work Program">
                <cfquery name="getStudName" datasource="MySQL">
                SELECT e.candidateid AS studentid, e.firstname, e.lastname, e.intrep, e.companyid, su.businessname
                FROM extra_candidates e
                INNER JOIN smg_users su ON su.userid = e.intrep
                WHERE e.candidateid = #student#
                </cfquery>    
            </cfcase>
        </cfswitch>
        
        <cfif getStudName.recordCount NEQ 0>
            <cfoutput>
            	<cfif getStudName.intrep NEQ url.userid>
                    <h1 align="center" style="padding-top:3cm">Student #getStudName.firstname# #getStudName.lastname# (#student#) belongs to #getStudName.businessname#
					<cfif getStudName.companyid LT 5>
                    	under 
                        <cfswitch expression="#getStudName.companyid#">
                            <cfcase value="1">ISE</cfcase>
                            <cfcase value="2">INTOEDVENTURES</cfcase>
                            <cfcase value="3">ASAI</cfcase>
                            <cfcase value="4">DMD</cfcase>
                            <cfcase value="5">SMG</cfcase>
                        </cfswitch>
                        <cfelse>
                           and has not been assigned to a company.<cfabort>
                    </cfif>
                    </h1>               
<!---                 	<cfelse>
                        <h1 align="center" style="padding-top:3cm">Student #getStudName.firstname# #getStudName.lastname# (#student#) (#getStudName.businessname#) 
                        <cfif getStudName.companyid NEQ 0>
                            is under 
                            <cfswitch expression="#getStudName.companyid#">
                                <cfcase value="1">ISE</cfcase>
                                <cfcase value="2">INTOEDVENTURES</cfcase>
                                <cfcase value="3">ASAI</cfcase>
                                <cfcase value="4">DMD</cfcase>
                                <cfcase value="5">SMG</cfcase>
                            </cfswitch>
                            <cfelse>
                            	has not been assigned to a company.
                        </cfif> --->
            			</h1>
				</cfif>
			</cfoutput>
            
            <cfelse>        
                <cfoutput>
                    <h1 align="center" style="padding-top:3cm">No student was found under ID number #student#</h1><cfabort>
                </cfoutput>
        </cfif>           
    </cfif>
    
    <cfswitch expression="#form.chooseProgram#">
        <cfcase value="High School">

            <cfquery name="getChargesCancellations" datasource="MySQL">
            SELECT s.chargeid, s.agentid, s.invoiceid, s.description, s.amount_due, s.stuid, s.companyid, s.programid, s.active, s.type AS charge_type, sp.type, sp.programname, su.accepts_sevis_fee, sc.creditid AS creditid, sc.amount AS amount, sc.description AS credDescription, sc.type AS creditType
            FROM smg_charges s
            LEFT JOIN smg_credit sc ON s.chargeid = sc.chargeid
            INNER JOIN smg_programs sp ON sp.programid = s.programid
            INNER JOIN smg_users su ON su.userid = s.agentid
            WHERE s.stuid =#student#
            AND s.agentid =#url.userid#
            AND s.companyid =#client.companyid#
            AND (sp.type !=7
                AND sp.type !=8
                AND sp.type !=9
                AND sp.type !=11
                AND sp.type !=22
                AND sp.type !=23)
            </cfquery>              
    
            <cfquery name="getCreditsDiscounts" datasource="MySQL">
            SELECT sc.creditid, sc.stuid, sc.agentid, sc.companyid, sc.type, sc.amount, sc.description, sp.type AS programType
            FROM smg_credit sc
            INNER JOIN smg_programs sp ON sc.credit_type = sp.programname
            WHERE sc.stuid =#student#
            AND sc.chargeid = 0        
            AND sc.agentid =#url.userid#
            AND sc.companyid =#client.companyid#
            AND sp.companyid =#client.companyid#        
            AND (sp.type !=7
                AND sp.type !=8
                AND sp.type !=9
                AND sp.type !=11
                AND sp.type !=22
                AND sp.type !=23)
            </cfquery> 
            
            <cfquery name="getCurrStudInfo" datasource="MySQL">
            SELECT ss.studentId, ss.intrep AS agentid, ss.programid, ss.firstname, ss.familylastname AS lastname, ss.active AS stud_active, ss.date_host_fam_approved, ss.host_fam_approved, ss.sevis_fee_paid_date, ss.companyid, sp.programname, sh.state AS hostState, sr.regionname
            FROM smg_students ss
            INNER JOIN smg_programs sp ON sp.programid = ss.programid
            LEFT JOIN smg_hosts sh ON ss.hostid = sh.hostid
            LEFT JOIN smg_regions sr ON sh.regionid = sr.regionid
            WHERE ss.studentid =#student#
            </cfquery>          
        </cfcase>
        <cfcase value="Work Program">
            <cfquery name="getChargesCancellations" datasource="MySQL">
            SELECT s.chargeid, s.agentid, s.invoiceid, s.description, s.amount_due, s.stuid, s.companyid, s.programid, s.active, s.type AS charge_type, sp.type, sp.programname, e.firstname, e.lastname, e.active AS stud_active, sc.creditid AS creditid, sc.amount AS amount, sc.description AS credDescription, sc.type AS creditType, su.extra_accepts_sevis_fee
            FROM  `smg_charges` s
            LEFT JOIN smg_credit sc ON s.chargeid = sc.chargeid
            INNER JOIN smg_programs sp ON sp.programid = s.programid
            INNER JOIN extra_candidates e ON e.candidateid = s.stuid
            INNER JOIN smg_users su ON su.userid = s.agentid
            WHERE s.stuid =#student#
            AND s.agentid =#url.userid#
<!---             AND s.companyid =#client.companyid# --->
            AND (sp.type =7
                OR sp.type =8
                OR sp.type =9
                OR sp.type =11
                OR sp.type =22
                OR sp.type =23)
            </cfquery>
            
            <cfquery name="getCreditsDiscounts" datasource="MySQL">
            SELECT sc.creditid, sc.stuid, sc.agentid, sc.companyid, sc.type, sc.amount, sc.description, sp.type AS programType
            FROM smg_credit sc
            INNER JOIN smg_programs sp ON sc.credit_type = sp.programname
            WHERE sc.stuid =#student#
            AND sc.chargeid = 0
            AND sc.agentid =#url.userid#
<!---             AND sc.companyid =#client.companyid#
            AND sp.companyid =#client.companyid# --->        
            AND (sp.type =7
                OR sp.type =8
                OR sp.type =9
                OR sp.type =11
                OR sp.type =22
                OR sp.type =23)
            </cfquery>          
    
            <cfquery name="getCurrStudInfo" datasource="MySQL">
            SELECT e.candidateid AS studentid, e.intrep AS agentid, e.programid, e.firstname, e.lastname, e.active AS stud_active, e.companyid, sp.programname
            FROM extra_candidates e
            INNER JOIN smg_programs sp ON sp.programid = e.programid
            WHERE e.candidateid =#student#
            </cfquery>
        </cfcase>
    </cfswitch>
    
    <br/>
    <br/>
    
    <cfoutput>
    <table class="box" align="center">
        <tr>
            <td></td>
            <td></td>
            <td>
            <h1 align="center" style="padding-top:0.2cm"><a href="..?curdoc=student_info&studentid=#getStudents.stuid#" target="_blank">#getCurrStudInfo.firstname# #getCurrStudInfo.lastname# (#getCurrStudInfo.studentid#)</a></h1></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td>
            <strong>Current program:</strong> #getCurrStudInfo.programname#</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td>
            <strong>Student status:</strong> 
            <cfif getCurrStudInfo.stud_active EQ 1>
                Active
                <cfelse>
                    Canceled
            </cfif></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <cfif form.chooseProgram EQ 'High School'>
            <tr>
                <td></td>
                <td></td>
                <td>
                <strong>Placement status: </strong>
                <cfif getCurrStudInfo.host_fam_approved LTE 4>
                    Placement approved on #DateFormat(getCurrStudInfo.date_host_fam_approved, 'mm/dd/yyyy')# by the HQ.
    				<cfelse>
                    	Unplaced
                </cfif></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr> 
            <tr>
                <td></td>
                <td></td>
                <td>
                <strong>Placed in <em>(State/ Region)</em>: </strong>
                <cfif getCurrStudInfo.host_fam_approved LTE 4>
                    #getCurrStudInfo.hostState# / #getCurrStudInfo.regionname#
					<cfelse>
                    	Unplaced
             	</cfif></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>       
            <tr>
                <td></td>
                <td></td>
                <td>
                <strong>Sevis fee status:</strong> 
                <cfif getChargesCancellations.accepts_sevis_fee EQ 0>
                    Agent does not accept sevis
                    <cfelseif getCurrStudInfo.sevis_fee_paid_date IS NOT " ">
                        Paid on #DateFormat(getCurrStudInfo.sevis_fee_paid_date, 'mm/dd/yyyy')#
    <cfelse>
                            Unpaid
                </cfif></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>        
        </cfif>
    </table>
    </cfoutput>
    
    <br/>
    <br/>
    
    <table class="frame" align="center">
        <tr class="darkBlue">
            <td></td>
            <td></td>
            <td></td>
            <td align="center" class="right">
            <span class="style4">Invoice</span></td>
            <td align="center" class="right">
            <span class="style1 style5">Program</span></td>       
            <td align="center" class="right">
            <span class="style1 style5">Charge Desc.</span></td>       
            <td align="center" class="right">
            <span class="style1 style5">Charge Amount</span></td>        
            <td align="center" class="right">
            <span class="style1 style5">Charge Status</span></td>        
            <td align="center" class="right">
            <span class="style1 style5">Credit Note</span></td>  
            <td align="center" class="right">
            <span class="style1 style5">Credit Type</span></td>              
            <td align="center" class="right"><span class="style1 style5">
            Credit Amount</span>        </td>        
            <td align="center" class="right">
            <span class="style1 style5">Description</span></td>
        </tr>
    
        <cfinput type="hidden" name="agentid#student#" value="#getCurrStudInfo.agentid#">
        <cfinput type="hidden" name="stuid" value="#student#">
        <cfinput type="hidden" name="programid#student#" value="#getCurrStudInfo.programid#">
        <cfinput type="hidden" name="programname#student#" value="#getCurrStudInfo.programname#">
        <cfinput type="hidden" name="companyid#student#" value="#getCurrStudInfo.companyid#">
        
    <cfoutput query="getChargesCancellations">
    	<cfparam name="form.chargeId" default="">
       	<cfinput type="hidden" name="chargeId" value="#getChargesCancellations.chargeid#">
        <cfinput type="hidden" name="agentid#getChargesCancellations.chargeid#" value="#getChargesCancellations.agentid#">
        <cfinput type="hidden" name="stuid#getChargesCancellations.chargeid#" value="#getChargesCancellations.stuid#">
        <cfinput type="hidden" name="programid#getChargesCancellations.chargeid#" value="#getChargesCancellations.programid#">
        <cfinput type="hidden" name="programname#getChargesCancellations.chargeid#" value="#getChargesCancellations.programname#">
        <cfinput type="hidden" name="companyid#getChargesCancellations.chargeid#" value="#getChargesCancellations.companyid#">
        <cfinput type="hidden" name="invoiceid#getChargesCancellations.chargeid#" value="#getChargesCancellations.invoiceid#">
        <cfinput type="hidden" name="amount_due#getChargesCancellations.chargeid#" value="#getChargesCancellations.amount_due#">
    
        <cfquery name="getCreditSum" datasource="MySQL">
        SELECT SUM(IFNULL(sc.amount, 0)) AS totalCredit
        FROM smg_credit sc
        WHERE sc.chargeid =#getChargesCancellations.chargeid#
        </cfquery> 
                  
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td class="right">
            <a href="invoice_view.cfm?id=#getChargesCancellations.invoiceid#" target="_blank">#getChargesCancellations.invoiceid#</a></td>               
            <td class="right">
            #getChargesCancellations.programname#</td>               
            <td class="right">
            <cfif getChargesCancellations.charge_type IS 'miscellaneous'>
            	#getChargesCancellations.description#
                <cfelse>
            		#getChargesCancellations.charge_type#
            </cfif></td>               
            <td class="right">
            #getChargesCancellations.amount_due#</td>               
            <td align="center" class="right">
            <cfif getChargesCancellations.active EQ 1>
                Active
                    <cfelse>
                        Canceled                    
            </cfif></td>       
            <td class="right">
            <a href="credit_note.cfm?creditid=#getChargesCancellations.creditid#" target="_blank">#getChargesCancellations.creditid#</a></td>
            <td class="right">#getChargesCancellations.creditType#</td>     
            <td class="right">                   
            #getChargesCancellations.amount#</td>            
            <td class="right">         
            #getChargesCancellations.credDescription#</td>             
        </tr>
    </cfoutput>
    
    <cfoutput query="getCreditsDiscounts">
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td> 
            <td class="right"><a href="credit_note.cfm?creditid=#getCreditsDiscounts.creditid#" target="_blank">#getCreditsDiscounts.creditid#</a></td>                        
            <td class="right">#getCreditsDiscounts.type#</td> 
            <td class="right">#getCreditsDiscounts.amount#</td>          
            <td class="right">#getCreditsDiscounts.description#</td>                     
        </tr>
    </cfoutput>
    
        <tr>
            <td></td>
            <td></td>
            <td>
            <cfinput type="checkbox" id="charge0#student#" name="charge0#student#" onClick="javaScript:enabDisabCharge();"></td>
            <td class="right"></td>
            <td class="right">
            <cfinput type="text" id="prog0#student#" name="prog0#student#" value="#getCurrStudInfo.programname#" size="6" disabled></td>
            <td class="right">
            <cfinput type="text" id="type0#student#" name="type0#student#" size="8" disabled></td>
            <td class="right">
            <cfinput type="text" id="amount0#student#" name="amount0#student#" size="4" disabled></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>                
            <td class="right"></td>                   
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td>
            <cfinput type="checkbox" id="charge1#student#" name="charge1#student#" onClick="javaScript:enabDisabCharge();"></td>
            <td class="right"></td>
            <td class="right">
            <cfinput type="text" id="prog1#student#" name="prog1#student#" value="#getCurrStudInfo.programname#" size="6" disabled></td>
            <td class="right">
            <cfinput type="text" id="type1#student#" name="type1#student#" size="8" disabled></td>
            <td class="right">
            <cfinput type="text" id="amount1#student#" name="amount1#student#" size="4" disabled></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>                
            <td class="right"></td>                   
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td>
            <cfinput type="checkbox" id="charge2#student#" name="charge2#student#" onClick="javaScript:enabDisabCharge();"></td>
            <td class="right"></td>
            <td class="right">
            <cfinput type="text" id="prog2#student#" name="prog2#student#" value="#getCurrStudInfo.programname#" size="6" disabled></td>
            <td class="right">
            <cfinput type="text" id="type2#student#" name="type2#student#" size="8" disabled></td>
            <td class="right">
            <cfinput type="text" id="amount2#student#" name="amount2#student#" size="4" disabled></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>                
            <td class="right"></td>                   
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td>
            <cfinput type="checkbox" id="charge3#student#" name="charge3#student#" onClick="javaScript:enabDisabCharge();"></td>
            <td class="right"></td>
            <td class="right">
            <cfinput type="text" id="prog3#student#" name="prog3#student#" value="#getCurrStudInfo.programname#" size="6" disabled></td>
            <td class="right">
            <cfinput type="text" id="type3#student#" name="type3#student#" size="8" disabled></td>
            <td class="right">
            <cfinput type="text" id="amount3#student#" name="amount3#student#" size="4" disabled></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>                
            <td class="right"></td>                   
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td>
            <cfinput type="checkbox" id="charge4#student#" name="charge4#student#" onClick="javaScript:enabDisabCharge();"></td>
            <td class="right"></td>
            <td class="right">
            <cfinput type="text" id="prog4#student#" name="prog4#student#" value="#getCurrStudInfo.programname#" size="6" disabled></td>
            <td class="right">
            <cfinput type="text" id="type4#student#" name="type4#student#" size="8" disabled></td>
            <td class="right">
            <cfinput type="text" id="amount4#student#" name="amount4#student#" size="4" disabled></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>                
            <td class="right"></td>                   
        </tr>
    </table>
       
</cfloop>

</cfform>

<br/><br/>

</body>
</html>