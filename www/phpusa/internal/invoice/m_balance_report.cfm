
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Balance Report Per Program, includes Credit Notes</title>

<cfsetting requesttimeout="9999">

<style type="text/css">

	table.frame 
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFE1;
	padding:2px;
	}
	
	td.right
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	color:#FFFFFF;
	font-weight:bold;
	border-right-style:solid;
	border-right-width:thin;
	border-right-color:#004080;
	border-right-collapse:collapse;
	padding:4px;
	}
	
	td.two
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
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

.style1 {color: #FF0000}
</style>

</head>

<cfparam name="FORM.selectPrograms" default="0">

<cfquery name="getPrograms" datasource="MySQL">
SELECT 
	*
FROM 
	smg_programs
WHERE
	companyID = 6
AND
	startdate >= '2009-08-01'
ORDER BY  
	startdate DESC
</cfquery>

<body>

<cfif NOT ISDEFINED('form.submitted')>
<div align="center">
<strong><small>Outstanding Balances Report</small></strong>
    <cfform>
        
        <cfinput type="hidden" name="submitted">
    
        <select name="selectPrograms" multiple="multiple" size="10">
            <option value="All" selected="selected">Select All</option>
            <option value="0">Charges not related to a program</option>
            <cfoutput query="getPrograms">
                <option value="#programid#">#getPrograms.programname#</option>
            </cfoutput>
        </select>
        <br/>
        <cfinput name="printFormat" type="checkbox" checked="yes"> <strong><small>Display print format?</small></strong>
        <br/>
        <cfinput name="submit" type="image" src="../pics/submit.gif">
    
    </cfform>

	<cfif NOT ISDEFINED('form.submitted')>
        <cfabort>
    </cfif>

</div>
</cfif>

<cfoutput>
<div align="center"><h2>Outstanding balances as of #DateFormat(now(), 'mm-dd-yyyy')# at #TimeFormat(now(),'h:mm:ss tt')#<br></h2></div>
</cfoutput>

<strong><small>Programs Selected:</small></strong><br/>

<cfloop list="#form.selectPrograms#" index="programsSelected">

    <cfif programsSelected IS "All">
    
        <small>All programs were selected</small><br/>
        
        <cfelseif programsSelected EQ 0>
        
            <small>Charges not related to a program</small><br/>
        
            <cfelse>
            
                <cfquery name="getProgramsSelected" datasource="MySQL">
                SELECT *
                FROM smg_programs sp
				WHERE sp.programid = #programsSelected#
                ORDER BY companyid ASC, startdate DESC
                </cfquery>
                
                <cfoutput query="getProgramsSelected">
                
                <small>#getProgramsSelected.programname# (###getProgramsSelected.programid#)</small> <br/>
                
                </cfoutput>
        
    </cfif>
    
</cfloop>

<cfquery name="qTotalAgentBalance" datasource="MySQL">
SELECT t.intl_rep, t.intrepid, t.billing_contact, t.billing_email, t.program, t.programid, SUM(t.amount) as amount

FROM (

select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, sum(ec.amount) as amount
from egom_charges ec
left join smg_students ss on ss. studentid = ec.studentid
left join egom_invoice ei on ei.invoiceid = ec.invoiceid
left join smg_users su on su.userid = ei.intrepid
left join smg_programs sp on sp.programid = ec.programid
where  ec.studentid != 0
and sp.programid IN (#form.selectPrograms#)
group by intl_rep

UNION ALL

select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep,ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, IFNULL(sum(epc.amount_paid), 0) * -1 as amount
from egom_payment_charges epc
right join egom_charges ec on ec.chargeid = epc.chargeid
left join smg_students ss on ss. studentid = ec.studentid
left join egom_invoice ei on ei.invoiceid = ec.invoiceid
left join smg_users su on su.userid = ei.intrepid
left join smg_programs sp on sp.programid = ec.programid
where  ec.studentid != 0
and sp.programid IN (#form.selectPrograms#)
group by intl_rep

) t
GROUP BY intl_rep HAVING amount > 0
ORDER BY amount DESC
</cfquery>

<br/>

<cfset arrayEmailAgent = ArrayNew(1)>
<cfloop query="qTotalAgentBalance">
	<cfset aEmailAgent = #arrayAppend(arrayEmailAgent, "#qTotalAgentBalance.intrepid#")#>
</cfloop>
<cfoutput>
	<script type="text/javascript">
		var #toScript(arrayEmailAgent, "jsArrayEmailAgent")#;
		var i=0;
		
		function checkUncheck() {
			if (document.getElementById("emailAgent").checked == false) {
				for (i in jsArrayEmailAgent) {	
					document.getElementById("email"+jsArrayEmailAgent[i]).checked = false;
				}
			}
			else {
				for (i in jsArrayEmailAgent) {	
					document.getElementById("email"+jsArrayEmailAgent[i]).checked = true;
				}
			}
		}	
	</script>
</cfoutput>

<cfform method="post" action="m_sendEmailNotification.cfm">

<cfif NOT ISDEFINED('form.printFormat')>
    <div align="center">
        <cfinput type="submit" name="sendEmail" src="../pics/send-email.gif">
    </div>
</cfif>

<br/><br/>

<strong><small>RECEIVABLES</small></strong>
<br/>

<cfif qTotalAgentBalance.recordCount EQ 0>
	<small>There are not receivables for the selected programs</small>
<cfelse>
<table class="frame">

    <tr class="darkBlue">
    	<cfif NOT ISDEFINED('form.printFormat')>
            <td align="center">
                <cfinput name="emailAgent" id="emailAgent" type="checkbox" onClick="javaScript:checkUncheck();" checked="true">
            </td>
        </cfif>
        <td class="right">AGENT</td>
        <td class="right">TOTAL</td>
    </tr>

<cfoutput query="qTotalAgentBalance">

    <cfinput type="hidden" name="agentId" value="#qTotalAgentBalance.intrepid#">        
    
    <tr <cfif qTotalAgentBalance.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
    
		<cfif NOT ISDEFINED('form.printFormat')>
        <td align="center">
            <cfinput name="email#qTotalAgentBalance.intrepid#" id="email#qTotalAgentBalance.intrepid#" type="checkbox" checked="yes" align="absmiddle">
        </td>
        </cfif>
        
        <td class="two">#toString(qTotalAgentBalance.intl_rep)#</td> 
        <td class="two <cfif qTotalAgentBalance.amount LT 0>style1</cfif>">#LsCurrencyFormat(qTotalAgentBalance.amount)#</td>
        
    </tr>
    
    <cfparam name="grandTotalBal" default="0">
    <cfset grandTotalBal = grandTotalBal + qTotalAgentBalance.amount>

</cfoutput>

<cfoutput>

    <tr class="darkBlue">
    	<cfif NOT ISDEFINED('form.printFormat')>
    		<td></td>
        </cfif>
        
        <td class="right">TOTAL</td>
        <td class="right">#LsCurrencyFormat(variables.grandTotalBal)#</td>
    </tr>

</cfoutput>

</table>

</cfif>


<!--- FROM THIS LINE DOWN: NEGATIVE BALANCES --->
<cfquery name="qTotalAgentBalance" datasource="MySQL">
SELECT t.intl_rep, t.intrepid, t.billing_contact, t.billing_email, t.program, t.programid, SUM(t.amount) as amount

FROM (

select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, sum(ec.amount) as amount
from egom_charges ec
left join smg_students ss on ss. studentid = ec.studentid
left join egom_invoice ei on ei.invoiceid = ec.invoiceid
left join smg_users su on su.userid = ei.intrepid
left join smg_programs sp on sp.programid = ec.programid
where  ec.studentid != 0
and sp.programid IN (#form.selectPrograms#)
group by intl_rep

UNION ALL

select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep,ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, IFNULL(sum(epc.amount_paid), 0) * -1 as amount
from egom_payment_charges epc
right join egom_charges ec on ec.chargeid = epc.chargeid
left join smg_students ss on ss. studentid = ec.studentid
left join egom_invoice ei on ei.invoiceid = ec.invoiceid
left join smg_users su on su.userid = ei.intrepid
left join smg_programs sp on sp.programid = ec.programid
where  ec.studentid != 0
and sp.programid IN (#form.selectPrograms#)
group by intl_rep

) t
GROUP BY intl_rep HAVING amount < 0
ORDER BY amount DESC
</cfquery>

<br/>

<cfif NOT ISDEFINED('form.printFormat')>
    <div align="center">
        <cfinput type="submit" name="sendEmail" src="../pics/send-email.gif">
    </div>
</cfif>

<br/><br/>

<strong><small>RECEIVABLES</small></strong>
<br/>

<cfif qTotalAgentBalance.recordCount EQ 0>
	<small>There are not receivables for the selected programs</small>
<cfelse>
<table class="frame">

    <tr class="darkBlue">
    	<cfif NOT ISDEFINED('form.printFormat')>
            <td align="center"></td>
        </cfif>
        <td class="right">AGENT</td>
        <td class="right">TOTAL</td>
    </tr>

<cfoutput query="qTotalAgentBalance">

    <cfinput type="hidden" name="agentId" value="#qTotalAgentBalance.intrepid#">        
    
    <tr <cfif qTotalAgentBalance.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
    
		<cfif NOT ISDEFINED('form.printFormat')>
        <td align="center"></td>
        </cfif>
        
        <td class="two">#toString(qTotalAgentBalance.intl_rep)#</td> 
        <td class="two <cfif qTotalAgentBalance.amount LT 0>style1</cfif>">#LsCurrencyFormat(qTotalAgentBalance.amount)#</td>
        
    </tr>
    
    <cfparam name="grandTotalNegBal" default="0">
    <cfset grandTotalNegBal = grandTotalNegBal + qTotalAgentBalance.amount>

</cfoutput>

<cfoutput>

    <tr class="darkBlue">
    	<cfif NOT ISDEFINED('form.printFormat')>
    		<td></td>
        </cfif>
        
        <td class="right">TOTAL</td>
        <td class="right">#LsCurrencyFormat(variables.grandTotalNegBal)#</td>
    </tr>

</cfoutput>

</table>

</cfif>

</cfform>

</body>
</html>