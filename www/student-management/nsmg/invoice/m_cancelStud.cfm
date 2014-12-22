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
-->
</style>
<div class="application_section_header">CANCEL CHARGES OR ENTER CREDITS TO ACCOUNT</div></br></br>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Cancellation, Credits, Discounts</title>

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
-->
</style>
</head>

<body>

<cfform>
	<cfinput type="hidden" name="submitted" value="1">
<table style="padding-top:0.5cm">
    <tr>
        <td colspan="2">
        </td>
        <td>
        Choose Program type
        </td>
        <td>
        <select name="chooseProgram">
            <option>High School</option>
            <option>Work Program</option>
        </select>    
        </td>
    </tr>         
    <tr>
        <td colspan="2">
        </td>
        <td>
        Enter student ID number or invoice number
        </td>
        <td>
        <cfinput type="text" name="studId" size="50"><br/>
        <span class="style7">"You can enter as many student IDs as you want (<span class="style6">SEPARATED BY SINGLE SPACE</span>)"</span> </td>
        <td>
        <cfinput type="image" name="submit3"  src="../pics/update.gif">
        </td>
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
        SELECT s.chargeid, s.agentid, s.invoiceid, s.description, s.amount_due, s.stuid, s.companyid, s.programid, s.active, s.type AS charge_type, sp.type, sp.programname, su.accepts_sevis_fee, sc.creditid AS creditid, sc.amount AS amount, sc.description AS credDescription, sc.type AS creditType
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
        <!--- AND s.companyid =#client.companyid# --->
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
        SELECT s.chargeid, s.agentid, s.invoiceid, s.description, s.amount_due, s.stuid, s.companyid, s.programid, s.active, s.type AS charge_type, sp.type, sp.programname, e.firstname, e.lastname, e.status AS stud_active, sc.creditid AS creditid, sc.amount AS amount, sc.description AS credDescription, sc.type AS creditType, su.extra_accepts_sevis_fee
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

<cfif getSmgChargesCredit.recordCount EQ 0>
    <cfoutput>
    	<h1 align="center" style="padding-top:3cm">No charges were found for #form.chooseProgram# student ID #students#.</h1>
    </cfoutput>
</cfif>

<cfset arrayInputId = ArrayNew(1)>
<cfset arrayChargeStatus = ArrayNew(1)>
<cfset arrayChargeId = ArrayNew(1)>
<cfset counter = getSmgChargesCredit.recordCount>
<cfloop query="getSmgChargesCredit">
	<cfset aInputId = #arrayAppend(arrayInputId, "#getSmgChargesCredit.stuid#")#>
	<cfset aChargeStatus = #arrayAppend(arrayChargeStatus, "#getSmgChargesCredit.active#")#>
	<cfset aChargeId = #arrayAppend(arrayChargeId, "#getSmgChargesCredit.chargeid#")#>
</cfloop>

<cfoutput>
	<script type="text/javascript">
		var #toScript(arrayInputId, "jsArrayInputId")#;
		var #toScript(arrayChargeStatus, "jsArrayChargeStatus")#;
		var #toScript(arrayChargeId, "jsArrayChargeId")#;
		var #toScript(counter, "jsCounter")#;
			
		function checkAll() {	
			for (var i=0; i<=jsCounter-1; i++) {	
				if(jsArrayChargeStatus[i] == 1) {	
					if(document.getElementById("all"+jsArrayInputId[i]).checked == true) {
					document.getElementById("chargeId"+jsArrayChargeId[i]).checked = true;
					document.getElementById("creditAmount"+jsArrayChargeId[i]).style.display = "inline";
					document.getElementById("creditDescription"+jsArrayChargeId[i]).style.display = "inline";
					
						if(document.getElementById("cancelFee"+jsArrayInputId[i]) != undefined) {
							document.getElementById("cancelFee"+jsArrayInputId[i]).checked = true;
							document.getElementById("cancelProg"+jsArrayInputId[i]).disabled = "";
							document.getElementById("cancelType"+jsArrayInputId[i]).disabled = "";
							document.getElementById("cancelAmount"+jsArrayInputId[i]).disabled = "";
						}
						
						if(document.getElementById("sevis"+jsArrayInputId[i]) != undefined) {
							document.getElementById("sevis"+jsArrayInputId[i]).checked = true;
							document.getElementById("sevisProg"+jsArrayInputId[i]).disabled = "";
							document.getElementById("sevisType"+jsArrayInputId[i]).disabled = "";
							document.getElementById("sevisAmount"+jsArrayInputId[i]).disabled = "";
						}
					}
						else {
							document.getElementById("chargeId"+jsArrayChargeId[i]).checked = false;
							document.getElementById("creditAmount"+jsArrayChargeId[i]).style.display = "none";
							document.getElementById("creditDescription"+jsArrayChargeId[i]).style.display = "none";
						
							if(document.getElementById("cancelFee"+jsArrayInputId[i]) != undefined) {
							document.getElementById("cancelFee"+jsArrayInputId[i]).checked = false;
							document.getElementById("cancelProg"+jsArrayInputId[i]).disabled = "disabled";
							document.getElementById("cancelType"+jsArrayInputId[i]).disabled = "disabled";
							document.getElementById("cancelAmount"+jsArrayInputId[i]).disabled = "disabled";
							}
							
							if(document.getElementById("sevis"+jsArrayInputId[i]) != undefined) {
							document.getElementById("sevis"+jsArrayInputId[i]).checked = false;
							document.getElementById("sevisProg"+jsArrayInputId[i]).disabled = "disabled";
							document.getElementById("sevisType"+jsArrayInputId[i]).disabled = "disabled";
							document.getElementById("sevisAmount"+jsArrayInputId[i]).disabled = "disabled";
							}
						}
				}					
			}
		}
		
		function checkOne() {
			for (var i=0; i<=jsCounter-1; i++) {
				if(jsArrayChargeStatus[i] == 1) {
					if(document.getElementById("chargeId"+jsArrayChargeId[i]).checked == true) {
						document.getElementById("creditAmount"+jsArrayChargeId[i]).style.display = "inline";
						document.getElementById("creditDescription"+jsArrayChargeId[i]).style.display = "inline";						
					}
										
						else {
							document.getElementById("creditAmount"+jsArrayChargeId[i]).style.display = "none";
							document.getElementById("creditDescription"+jsArrayChargeId[i]).style.display = "none";						
						}
				}
			}
		}
		
		function enabDisabCancFee() {
			for (var i=0; i<=jsCounter-1; i++) {                
				if(document.getElementById("cancelFee"+jsArrayInputId[i]) != undefined) {
					if(document.getElementById("cancelFee"+jsArrayInputId[i]).checked == true) {
						document.getElementById("cancelProg"+jsArrayInputId[i]).disabled = "";
						document.getElementById("cancelType"+jsArrayInputId[i]).disabled = "";
						document.getElementById("cancelAmount"+jsArrayInputId[i]).disabled = "";
					}
					else {
						document.getElementById("cancelProg"+jsArrayInputId[i]).disabled = "disabled";
						document.getElementById("cancelType"+jsArrayInputId[i]).disabled = "disabled";
						document.getElementById("cancelAmount"+jsArrayInputId[i]).disabled = "disabled";			
					}		
				}
			}
		}
		
		function enabDisabSevis() {
			for (var i=0; i<=jsCounter-1; i++) {			
				if(document.getElementById("sevis"+jsArrayInputId[i]) != undefined) {
					if(document.getElementById("sevis"+jsArrayInputId[i]).checked == true) {
						document.getElementById("sevisProg"+jsArrayInputId[i]).disabled = "";
						document.getElementById("sevisType"+jsArrayInputId[i]).disabled = "";
						document.getElementById("sevisAmount"+jsArrayInputId[i]).disabled = "";
					}
					else {
						document.getElementById("sevisProg"+jsArrayInputId[i]).disabled = "disabled";
						document.getElementById("sevisType"+jsArrayInputId[i]).disabled = "disabled";
						document.getElementById("sevisAmount"+jsArrayInputId[i]).disabled = "disabled";
					}				
				}					
			}
		}	
		
		function enabDisabCredit() {
			for (var i=0; i<=jsCounter-1; i++) {			
				if(document.getElementById("cred"+jsArrayInputId[i]).checked == true) {
					document.getElementById("credChoose"+jsArrayInputId[i]).disabled = "";
					document.getElementById("credAmount"+jsArrayInputId[i]).disabled = "";
					document.getElementById("credDescrip"+jsArrayInputId[i]).disabled = "";	
				}
				else  {
					document.getElementById("credChoose"+jsArrayInputId[i]).disabled = "disabled";			
					document.getElementById("credAmount"+jsArrayInputId[i]).disabled = "disabled";
					document.getElementById("credDescrip"+jsArrayInputId[i]).disabled = "disabled";
				}
			}
		}
				
	</script>
</cfoutput>

<br/><br/><br/>

<cfform name="header" method="post" action="m_processCancellation.cfm?userid=#url.userid#">
<table align="center">
    <tr align="center">
        <td align="center"><cfinput type="image" name="submit2"  src="../pics/update.gif"></td>
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
            <!--- AND s.companyid =#client.companyid# --->
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
					<cfif getStudName.companyid NEQ 0>
                    	under 
                        <cfswitch expression="#getStudName.companyid#">
                            <cfcase value="1">ISE</cfcase>
                            <cfcase value="2">INTOEDVENTURES</cfcase>
                            <cfcase value="3">ASAI</cfcase>
                            <cfcase value="4">DMD</cfcase>
                            <cfcase value="5">SMG</cfcase>
                        </cfswitch>
                        <cfelse>
                           and has not been assigned to a company.
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
                    <h1 align="center" style="padding-top:3cm">No student was found under ID number #student#</h1>
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
            <!--- AND s.companyid =#client.companyid# --->
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
            INNER JOIN smg_programs sp ON (sp.programname = sc.credit_type) AND sp.type NOT IN (7,8,9,11,22,23)
            WHERE sc.stuid =#student#
            AND sc.chargeid = 0        
            AND sc.agentid =#url.userid#
<!---             AND sc.companyid =#client.companyid#
            AND sp.companyid =#client.companyid# --->        
            GROUP BY sc.id
            </cfquery> 
            
            <cfquery name="getCurrStudInfo" datasource="MySQL">
            SELECT
            	ss.studentid AS stuid, 
                ss.firstname, 
                ss.familylastname AS lastname, 
                ss.active AS stud_active, 
                ss.hostID, 
                ss.date_host_fam_approved, 
                ss.host_fam_approved, 
                ss.sevis_fee_paid_date, 
                ss.intrep AS agentid, 
                ss.programid, 
                ss.companyid, 
                ss.canceldate, 
                ss.cancelreason, 
                sp.programname, 
                sp.type AS progType, 
                sh.state AS hostState, 
                sr.regionname, 
                shist.datePISEmailed,
                shist.datePlaced
            FROM
            	smg_students ss
            LEFT JOIN
            	smg_programs sp ON sp.programid = ss.programid
            LEFT JOIN
            	smg_hosts sh ON ss.hostid = sh.hostid
            LEFT JOIN
            	smg_regions sr ON sh.regionid = sr.regionid
            LEFT JOIN
            	smg_hosthistory shist ON shist.studentID = ss.studentID AND isActive = 1
            WHERE
            	ss.studentid =#student#
            </cfquery>          
        </cfcase>
        <cfcase value="Work Program">
        
        	<!--- check if agent is in the extra_wt_prices table, if not, do not join table to query--->
            <cfquery name="checkAgent" datasource="MySQL">
            SELECT *
            FROM extra_wt_prices
            WHERE userID = #url.userid#
            </cfquery>

            <cfquery name="getChargesCancellations" datasource="MySQL">
            SELECT	s.chargeid, 
            		s.agentid, 
                    s.invoiceid, 
                    s.description, 
                    s.amount_due, 
                    s.stuid, 
                    s.companyid, 
                    s.programid, 
                    s.active, 
                    s.type AS charge_type, 
                    sp.type, sp.programname, 
                    e.firstname, 
                    e.lastname, 
                    e.status AS stud_active, 
                    sc.creditid AS creditid, 
                    sc.amount AS amount, 
                    sc.description AS credDescription, 
                    sc.type AS creditType
					<cfif checkAgent.recordCount GT 0>
                    	, ewp.includeSevis, ewp.sevis
                    </cfif>

            FROM  `smg_charges` s
            LEFT JOIN smg_credit sc ON s.chargeid = sc.chargeid
            INNER JOIN smg_programs sp ON sp.programid = s.programid
            INNER JOIN extra_candidates e ON e.candidateid = s.stuid
            INNER JOIN smg_users su ON su.userid = s.agentid
			<cfif checkAgent.recordCount GT 0>
            	INNER JOIN extra_wt_prices ewp on ewp.userid = s.agentid
			</cfif>
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
            SELECT 	e.candidateid AS stuid, 
            		e.firstname, e.lastname, 
                    e.status AS stud_active, 
                    e.intrep AS agentid, 
                    e.programid, 
                    e.companyid, 
                    e.cancel_date AS canceldate, 
                    e.cancel_reason AS cancelreason, 
                    sp.programname, 
                    sp.type AS progType 
 					<cfif checkAgent.recordCount GT 0>
                    	, ewp.includeSevis
					</cfif>
            FROM extra_candidates e
            LEFT JOIN smg_programs sp ON sp.programid = e.programid
            LEFT JOIN smg_users su ON su.userid = e.intrep
			<cfif checkAgent.recordCount GT 0>
            	LEFT JOIN extra_wt_prices ewp on ewp.userid = e.intrep
			</cfif>
            WHERE e.candidateid =#student#
            </cfquery>
        </cfcase>
    </cfswitch>

	<cfquery name="getHostState" datasource="MySQL">
	SELECT ss.hostid, sst.state AS statePlaced
	FROM smg_students ss
	LEFT JOIN smg_hosts sh ON sh.hostid = ss.hostid
	LEFT JOIN smg_states sst ON sst.state = sh.state
	WHERE ss.studentid = #student#
	</cfquery>

	<cfoutput query="getHostState">
	
		<cfswitch expression="#getHostState.statePlaced#">
		   <cfcase value="ME,VT,NH,MA,RI,CT,NJ,DE,MD,NY,PA,OH,WV,VA,KY">
				<cfset regionPlaced = 'East'>
			</cfcase>
			<cfcase value="OK,TX,AR,LA,TN,MS,AL,GA,SC,NC">
				<cfset regionPlaced = 'South'>
			</cfcase>
			<cfcase value="MN,WI,IA,NE,KS,MO,IL,IN,MI">
				<cfset regionPlaced = 'Central'>
			</cfcase>
			<cfcase value="MT,ND,ID,WY,SD,CO,NM">
				<cfset regionPlaced = 'Rocky Mountain'>
			</cfcase>
			<cfcase value="WA,OR,NV,UT,AZ">
				<cfset regionPlaced = 'West'>
			</cfcase>
			<cfdefaultcase>
				<cfset regionPlaced = 'Unplaced'>
			</cfdefaultcase>
		</cfswitch>
	
	</cfoutput>
    
    <br/>
    <br/>
    
    <cfoutput>
    <table class="box" align="center">
        <tr>
            <td></td>
            <td></td>
            <td>
            <h1 align="center" style="padding-top:0.2cm"><a href="#CLIENT.exits_url#/nsmg/index.cfm?curdoc=student_info&studentid=#getStudents.stuid#" target="_blank">#getCurrStudInfo.firstname# #getCurrStudInfo.lastname# (#getCurrStudInfo.stuid#)</a></h1></td>
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
            <cfif getCurrStudInfo.stud_active EQ 1 AND getCurrStudInfo.stud_active NEQ 'canceled'>
                Active
                <cfelse>
                    Canceled on #dateFormat(getCurrStudInfo.canceldate, 'mm/dd/yyyy')# <strong>Reason:</strong> #getCurrStudInfo.cancelreason#
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
                <cfif getCurrStudInfo.datePlaced IS NOT ''>
                    Placement approved on #DateFormat(getCurrStudInfo.datePlaced, 'mm/dd/yyyy')#.
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
                <cfif getCurrStudInfo.datePlaced IS NOT ''>
                    #getCurrStudInfo.hostState# / #variables.regionPlaced#
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
                    <cfelseif getCurrStudInfo.sevis_fee_paid_date IS NOT "">
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
            <td>
            <cfinput type="checkbox" id="all#student#" name="all#student#" onClick="javaScript:checkAll();" checked="true"></td>
            <td align="center" class="right">
            <span class="style4">Invoice</span></td>
            <td align="center" class="right">

            <span class="style1 style5">Program</span></td>       
            <td align="center" class="right">
            <span class="style1 style5">Charge Type</span></td>       
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
            <td align="left" class="right">
            <span class="style1 style5">Description</span></td>
        </tr>
    	
        <cfif getChargesCancellations.recordCount NEQ 0>
            <cfinput type="hidden" name="agentid#student#" value="#getChargesCancellations.agentid#">
            <cfinput type="hidden" name="stuid" value="#student#">
            <cfinput type="hidden" name="programid#student#" value="#getChargesCancellations.programid#">
            <cfinput type="hidden" name="programname#student#" value="#getChargesCancellations.programname#">
            <cfinput type="hidden" name="companyid#student#" value="#getChargesCancellations.companyid#">
            <cfelse>
                <cfinput type="hidden" name="agentid#student#" value="#getCurrStudInfo.agentid#">
                <cfinput type="hidden" name="stuid" value="#student#">
                <cfinput type="hidden" name="programid#student#" value="#getCurrStudInfo.programid#">
                <cfinput type="hidden" name="programname#student#" value="#getCurrStudInfo.programname#">
                <cfswitch expression="#getCurrStudInfo.progType#">
                    <cfcase value="7,8,9">
                    	<cfset varCompanyid = 1>
                	</cfcase>
                    <cfcase value="11">
                    	<cfset varCompanyid = 2>
                	</cfcase>
                    <cfcase value="22,23">
                    	<cfset varCompanyid = 5>
                	</cfcase>
                    <cfdefaultcase>
                    	<cfset varCompanyid = #getCurrStudInfo.companyid#>
                    </cfdefaultcase>                   
                </cfswitch>
                
                <cfinput type="hidden" name="companyid#student#" value="#variables.varCompanyid#">
        </cfif>
        
    <cfoutput query="getChargesCancellations">
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
            
        <cfif getChargesCancellations.active EQ 1>
            <cfset disab = "">
            <cfset check = "true">
            <cfset inpType = "text">
            <cfelse>
                <cfset disab = "disabled">
                <cfset check = "false">
                <cfset inpType = "hidden">
        </cfif>      
        <tr>
            <td></td>
            <td></td>
            <td>
            <cfinput type="checkbox" id="chargeId#getChargesCancellations.chargeid#" name="chargeId#getChargesCancellations.chargeid#" value="#getChargesCancellations.chargeid#" checked="#check#" onClick="javaScript:checkOne();" disabled="#disab#"></td>
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
            
            <!--- variables to construct credit description --->
            <cfif getCreditSum.totalCredit EQ "">
                <cfset total_credit = 0>
                <cfelse>
                    <cfset total_credit = getCreditSum.totalCredit>
            </cfif>
            
            <cfset amountToCredit = #getChargesCancellations.amount_due# - #variables.total_credit#>
                    
            <cfparam name="studPlaced" default="">
            <cfparam name="sevisPaid" default="">
            <cfif form.chooseProgram EQ "High School">
                <cfif getCurrStudInfo.datePlaced IS NOT ''>
                    <cfset studPlaced = "Placed.">
                    <cfelse>
                        <cfset studPlaced = "Unplaced.">
                </cfif>
                
                <cfif getChargesCancellations.accepts_sevis_fee EQ 0>
                    <cfset sevisPaid = "No Sevis.">
                    <cfelseif getCurrStudInfo.sevis_fee_paid_date IS NOT "">
                        <cfset sevisPaid = "Sevis Paid.">
                        <cfelse>
                            <cfset sevisPaid = "Sevis unpaid.">
                </cfif>        
            </cfif> 
            <!--- END of variables to construct credit description --->       
                               
            <cfif getChargesCancellations.creditid IS NOT ' '>
                <td class="right">        
                <cfinput type="#inpType#" id="creditAmount#getChargesCancellations.chargeid#" name="creditAmount#getChargesCancellations.chargeid#" value="#amountToCredit#">           
                #getChargesCancellations.amount#</td>            
                <td class="right">
                <cfinput type="#inpType#" id="creditDescription#getChargesCancellations.chargeid#" name="creditDescription#getChargesCancellations.chargeid#" value="#getCurrStudInfo.firstname# #getCurrStudInfo.lastname#. #studPlaced# #sevisPaid#Cancellation of #getChargesCancellations.charge_type# charge.">         
                #getChargesCancellations.credDescription#</td>            
                <cfelse>
                    <td class="right">
                    <cfinput type="#inpType#" id="creditAmount#getChargesCancellations.chargeid#" name="creditAmount#getChargesCancellations.chargeid#" value="#amountToCredit#"></td>               
                    <td class="right">
                    <cfinput type="#inpType#" id="creditDescription#getChargesCancellations.chargeid#" name="creditDescription#getChargesCancellations.chargeid#" value="#getCurrStudInfo.firstname# #getCurrStudInfo.lastname#. #studPlaced# #sevisPaid# Cancellation of #getChargesCancellations.charge_type# charge."></td>                                       
            </cfif>
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

	<cfif getChargesCancellations.recordCount EQ 0>
    	<cfset progrName = #getCurrStudInfo.programname#>
		<cfelse>
            <cfset progrName = #getChargesCancellations.programname#>
    </cfif>
        
    <cfswitch expression="#form.chooseProgram#">
        <cfcase value="High School">
        
        	<!--- Cancellation fee --->
            <cfset cancFee = 500>
            <!--- General rule: Cancellation fee applies to placed students who are not visa denials --->
            <cfif getCurrStudInfo.datePlaced IS NOT '' AND getCurrStudInfo.cancelreason IS NOT 'visa denial'>
                
                    <tr>
                        <td></td>
                        <td></td>
                        <td>
                        <cfinput type="checkbox" id="cancelFee#student#" name="cancelFee#student#" onClick="javaScript:enabDisabCancFee();" checked="true"></td>
                        <td class="right"></td>
                        <td class="right">
                        <cfif getChargesCancellations.recordCount EQ 0>
                            <cfset progrName = #getCurrStudInfo.programname#>
                            <cfelse>
                                <cfset #getChargesCancellations.programname#>
                        </cfif>
                        <cfinput type="text" id="cancelProg#student#" name="cancelProg#student#" value="#variables.progrName#" size="6"></td>
                        <td class="right">
                        <cfinput type="text" id="cancelType#student#" name="cancelType#student#" value="Cancellation fee" size="8"></td>
                        <td class="right">
                        <cfinput type="text" id="cancelAmount#student#" name="cancelAmount#student#" value="#variables.cancFee#" size="4"></td>
                        <td class="right"></td>
                        <td class="right"></td>
                        <td class="right"></td>
                        <td class="right"></td>                
                        <td class="right"></td>                   
                    </tr>
            <!--- End of: General rule: Cancellation fee applies to placed students who are not visa denials --->
			
            <!--- Exception to the general rule: Glint agentid = 123 (former smg vietnam) gets charged 200 for visa denials --->
			<cfelseif getCurrStudInfo.datePlaced IS NOT '' AND getCurrStudInfo.cancelreason IS 'visa denial' AND getCurrStudInfo.agentid EQ 123>

                <cfset cancFee = 200>
                
                    <tr>
                        <td></td>
                        <td></td>
                        <td>
                        <cfinput type="checkbox" id="cancelFee#student#" name="cancelFee#student#" onClick="javaScript:enabDisabCancFee();" checked="true"></td>
                        <td class="right"></td>
                        <td class="right">
                        <cfif getChargesCancellations.recordCount EQ 0>
                            <cfset progrName = #getCurrStudInfo.programname#>
                            <cfelse>
                                <cfset #getChargesCancellations.programname#>
                        </cfif>
                        <cfinput type="text" id="cancelProg#student#" name="cancelProg#student#" value="#variables.progrName#" size="6"></td>
                        <td class="right">
                        <cfinput type="text" id="cancelType#student#" name="cancelType#student#" value="Cancellation fee" size="8"></td>
                        <td class="right">
                        <cfinput type="text" id="cancelAmount#student#" name="cancelAmount#student#" value="#variables.cancFee#" size="4"></td>
                        <td class="right"></td>
                        <td class="right"></td>
                        <td class="right"></td>
                        <td class="right"></td>                
                        <td class="right"></td>                   
                    </tr>
                    
            </cfif>
            <!--- End of: Exception to the general rule: NK Internl agentid = 123 (former smg vietnam) gets charged 200 for visa denials --->
            
            <cfif getCurrStudInfo.sevis_fee_paid_date IS NOT "">
                <tr>
                    <td></td>
                    <td></td>
                    <td>
                    <cfinput type="checkbox" id="sevis#student#" name="sevis#student#" onClick="javaScript:enabDisabSevis();" checked="true"></td>
                    <td class="right"></td>
                    <td class="right">
                    <cfinput type="text" id="sevisProg#student#" name="sevisProg#student#" value="#variables.progrName#" size="6"></td>
                    <td class="right">
                    <cfinput type="text" id="sevisType#student#" name="sevisType#student#" value="Sevis" size="8"></td>
                    <td class="right">
                    <cfinput type="text" id="sevisAmount#student#" name="sevisAmount#student#" value="180" size="4"></td>
                    <td class="right"></td>
                    <td class="right"></td>
                    <td class="right"></td>

                    <td class="right"></td>                
                    <td class="right"></td>              
                </tr>
            </cfif>
        </cfcase>
    
        <cfcase value="Work Program">
            <tr>
                <td></td>
                <td></td>
                <td>
                <cfinput type="checkbox" id="cancelFee#student#" name="cancelFee#student#" onClick="javaScript:enabDisabCancFee();" checked="true"></td>
                <td class="right"></td>
                <td class="right">
                <cfinput type="text" id="cancelProg#student#" name="cancelProg#student#" value="#variables.progrName#" size="6"></td>
                <td class="right">
                <cfinput type="text" id="cancelType#student#" name="cancelType#student#" value="Cancellation fee" size="8"></td>
                <td class="right">
                <cfinput type="text" id="cancelAmount#student#" name="cancelAmount#student#" value="100" size="4"></td>
                <td class="right"></td>
                <td class="right"></td>
                <td class="right"></td>
                <td class="right"></td>                        
                <td class="right"></td>                    
            </tr>
            <cfif getChargesCancellations.recordCount NEQ 0>
            	
				<cfif checkAgent.recordCount NEQ 0>
                
            		<cfset extraSevis = #getChargesCancellations.includeSevis#>
                    <cfset sevisCharged = #getChargesCancellations.sevis#>
                	
                    <cfelse> <!--- if getChargesCancellations.recordCount = 0 and checkAgent.recordCount = 0, student must be a trainee --->
                    
                    	<cfquery name="checkTraineeSevis" datasource="MySQL">
                        SELECT *
                        FROM smg_charges
                        WHERE stuid = #student#
                        AND companyid = 7
                        AND type = "Sevis fee"
                        AND active = 1
                        </cfquery>
                        
                        <cfif checkTraineeSevis.recordCount GT 0>
                        	<cfset extraSevis = 1>
                            <cfset sevisCharged = checkTraineeSevis.amount_due>
                        <cfelse>
                        	<cfset extraSevis = 0>
                            <cfset sevisCharged = 0>
                        </cfif>
                    
                 </cfif>
                
                <cfelse>
                
                	<cfset extraSevis = #getCurrStudInfo.includeSevis#>
            </cfif>
            
            <cfif variables.extraSevis EQ 1>
                <tr>
                    <td></td>
                    <td></td>
                    <td>
                    <cfinput type="checkbox" id="sevis#student#" name="sevis#student#" onClick="javaScript:enabDisabSevis();" checked="true"></td>
                    <td class="right"></td>
                    <td class="right">
                    <cfinput type="text" id="sevisProg#student#" name="sevisProg#student#" value="#variables.progrName#" size="6"></td>
                    <td class="right">
                    <cfinput type="text" id="sevisType#student#" name="sevisType#student#" value="Sevis fee" size="8"></td>
                    <td class="right">
                    <cfinput type="text" id="sevisAmount#student#" name="sevisAmount#student#" value="#sevisCharged#" size="4"></td>
                    <td class="right"></td> 
                    <td class="right"></td>                        
                    <td class="right"></td>                        
                    <td class="right"></td>
                    <td class="right"></td>                         
                </tr>
            </cfif>         
        </cfcase>               
    </cfswitch>
        <tr>
            <td></td>
            <td></td>
            <td>
            <cfinput type="checkbox" id="cred#student#" name="cred#student#" onClick="javaScript:enabDisabCredit();"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td>
            <td class="right"></td> 
            <td class="right"></td>                        
            <td class="right">
            <cfselect id="credChoose#student#" name="credChoose#student#" disabled="disabled">
                <option>Credit</option>        
                <option>Discount</option>
            </cfselect></td> 
            <td class="right">
            <cfinput type="text" id="credAmount#student#" name="credAmount#student#" size="4" disabled="disabled"></td>          
            <td class="right">
            <cfinput type="text" id="credDescrip#student#" name="credDescrip#student#" disabled="disabled"></td>                     
        </tr>
    </table>
	
    
</cfloop>

</cfform>

<br/><br/>

</body>
</html>