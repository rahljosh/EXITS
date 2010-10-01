
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
<strong><small>Outstanding Balances Report (ONLY FROM FALL 2009 ON)</small></strong>
    <cfform>
        
        <cfinput type="hidden" name="submitted">
    
        <select name="selectPrograms" multiple="multiple" size="10">
            <option value="All" selected="selected">All (from Fall09 on)</option>
            <option value="0">Charges not related to a program</option>
            <cfoutput query="getPrograms">
                <option value="#programid#">#getPrograms.programname#</option>
            </cfoutput>
        </select>
        <br/>

        <cfinput name="submit" type="image" src="pics/submit.gif">

    </cfform>

	<cfif NOT ISDEFINED('form.submitted')>
        <cfabort>
    </cfif>

</div>
</cfif>

<cfoutput>
<div align="center"><h2><small>Outstanding balances as of #DateFormat(now(), 'mm-dd-yyyy')# at #TimeFormat(now(),'h:mm:ss tt')#<br></small></h2></div>
</cfoutput>

<strong><small><center>Programs Selected:</center></small></strong>

<cfloop list="#form.selectPrograms#" index="programsSelected">

	<cfif programsSelected IS "All" AND listLen(form.selectPrograms) GT 1>
        <div align="center"><h2><small>The option "<font color="##FF0000">All Programs (from Fall09 on)</font>" cannot be combined with other options.<br></small></h2></div>
        <cfabort>
    </cfif>

    <cfif programsSelected IS "All">
    
        <small><center>All programs were selected (From Fall 2009 on)</center></small>
        
        <cfelseif programsSelected EQ 0>
        
            <small><center>Charges not related to a program</center></small>
        
            <cfelse>
            
                <cfquery name="getProgramsSelected" datasource="MySQL">
                SELECT *
                FROM smg_programs sp
				WHERE sp.programid = #programsSelected#
                ORDER BY companyid ASC, startdate DESC
                </cfquery>
                
                <cfoutput query="getProgramsSelected">
                
                <small><center>#getProgramsSelected.programname# (###getProgramsSelected.programid#)</center></small>
                
                </cfoutput>
        
    </cfif>
    
</cfloop>

<cfquery name="qTotalAgentBalance" datasource="MySQL">

	<!--- QUERIES OF INVOICES, PAYMENTS RELATED TO A PROGRAM --->
    select t.intl_rep, t.intrepid, t.billing_contact, t.billing_email, t.program, t.programid, sum(t.amount) as amount
    from (
    
    select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, ec.invoiceid, sum(ec.amount) as amount
    from egom_charges ec
    inner join egom_invoice ei on ei.invoiceid = ec.invoiceid
    inner join smg_users su on su.userid = ei.intrepid
    left join smg_programs sp on sp.programid = ec.programid
    where 
    	ec.programID != 0
    <cfif FORM.selectPrograms EQ 'ALL'>
    	AND 
        	sp.startdate >= '2009-08-01' <!--- from fall 2009 on --->
    <cfelse>    	
    	AND 
        	ec.programid IN (#form.selectPrograms#)
    </cfif>
    group by ei.intrepid
    
    union all
    
    select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, ec.invoiceid, sum(epc.amount_paid * -1)
    from egom_payment_charges epc
    left join egom_charges ec on ec.chargeid = epc.chargeid
    inner join egom_invoice ei on ei.invoiceid = ec.invoiceid
    inner join smg_users su on su.userid = ei.intrepid
    left join smg_programs sp on sp.programid = ec.programid
    where 
    	ec.programID != 0
    <cfif FORM.selectPrograms EQ 'ALL'>
    	AND 
        	sp.startdate >= '2009-08-01' <!--- from fall 2009 on --->
    <cfelse>    	
    	AND 
        	ec.programid IN (#form.selectPrograms#)           
    </cfif>
    group by ei.intrepid
    
    
    <!--- BELOW: QUERIES FOR INVOICES, PAYMENTS NOT RELATED TO A PROGRAM, AND CREDITS UNAPPLIED --->
    <cfif listFind(form.selectPrograms, 0) OR listFind(form.selectPrograms, "All")>
    
        union all
        
        select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, ec.invoiceid, sum(ec.amount) as amount
        from egom_charges ec
        inner join egom_invoice ei on ei.invoiceid = ec.invoiceid
        inner join smg_users su on su.userid = ei.intrepid
        left join smg_programs sp on sp.programid = ec.programid
        where ec.programid = 0
        and ec.date > '2009-12-01'
        group by ei.intrepid
        
        union all
        
        select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, ec.invoiceid, sum(epc.amount_paid * -1)
        from egom_payment_charges epc
        left join egom_charges ec on ec.chargeid = epc.chargeid
        inner join egom_invoice ei on ei.invoiceid = ec.invoiceid
        inner join smg_users su on su.userid = ei.intrepid
        left join smg_programs sp on sp.programid = ec.programid
        where ec.programid = 0
        and ec.date > '2009-12-01'
        group by ei.intrepid
        
        union all
        
        select concat(su.businessname, " (", ecd.intrep, ")") as intl_rep, ecd.intrep, ecd.originalPayRef, '', '', '', '', sum(ecd.amount * -1)
        from egom_credits ecd
        inner join smg_users su on su.userid = ecd.intrep
        group by ecd.intrep
    
    </cfif>
    
    ) t
    
    group by t.intrepid HAVING amount > 0
    order by amount DESC
    
</cfquery>

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

<cfform method="post" action="invoice/m_sendEmailNotification.cfm">

<strong><small><center>RECEIVABLES</center></small></strong>
<br/>

<cfif qTotalAgentBalance.recordCount EQ 0>
	<small>There are not receivables for the selected programs</small>
<cfelse>
<table class="frame" align="center">

    <tr class="darkBlue">
        <td class="right">AGENT</td>
        <td class="right">TOTAL</td>
    </tr>

<cfoutput query="qTotalAgentBalance">

    <cfinput type="hidden" name="agentId" value="#qTotalAgentBalance.intrepid#">        
    
    <tr <cfif qTotalAgentBalance.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
        
        <td class="two">#toString(qTotalAgentBalance.intl_rep)#</td> 
        <td class="two <cfif qTotalAgentBalance.amount LT 0>style1</cfif>">#LsCurrencyFormat(qTotalAgentBalance.amount)#</td>
        
    </tr>
    
    <cfparam name="grandTotalBal" default="0">
    <cfset grandTotalBal = grandTotalBal + qTotalAgentBalance.amount>

</cfoutput>

<cfoutput>

    <tr class="darkBlue">
        
        <td class="right">TOTAL</td>
        <td class="right">#LsCurrencyFormat(variables.grandTotalBal)#</td>
    </tr>

</cfoutput>

</table>

</cfif>


<!--- FROM THIS LINE DOWN: NEGATIVE BALANCES --->
<cfquery name="qTotalAgentNegBalance" datasource="MySQL">

	<!--- QUERIES OF INVOICES, PAYMENTS RELATED TO A PROGRAM --->
    select t.intl_rep, t.intrepid, t.billing_contact, t.billing_email, t.program, t.programid, sum(t.amount) as amount
    from (
    
    select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, ec.invoiceid, sum(ec.amount) as amount
    from egom_charges ec
    inner join egom_invoice ei on ei.invoiceid = ec.invoiceid
    inner join smg_users su on su.userid = ei.intrepid
    left join smg_programs sp on sp.programid = ec.programid
    where 
    	ec.programID != 0
    <cfif FORM.selectPrograms EQ 'ALL'>
    	AND 
        	sp.startdate >= '2009-08-01' <!--- from fall 2009 on --->
    <cfelse>    	
    	AND 
        	ec.programid IN (#form.selectPrograms#)
    </cfif>
    group by ei.intrepid
    
    union all
    
    select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, ec.invoiceid, sum(epc.amount_paid * -1)
    from egom_payment_charges epc
    left join egom_charges ec on ec.chargeid = epc.chargeid
    inner join egom_invoice ei on ei.invoiceid = ec.invoiceid
    inner join smg_users su on su.userid = ei.intrepid
    left join smg_programs sp on sp.programid = ec.programid
    where 
    	ec.programID != 0
    <cfif FORM.selectPrograms EQ 'ALL'>
    	AND 
        	sp.startdate >= '2009-08-01' <!--- from fall 2009 on --->
    <cfelse>    	
    	AND 
        	ec.programid IN (#form.selectPrograms#)           
    </cfif>
    group by ei.intrepid
    
    
    <!--- BELOW: QUERIES FOR INVOICES, PAYMENTS NOT RELATED TO A PROGRAM, AND CREDITS UNAPPLIED --->
    <cfif listFind(form.selectPrograms, 0) OR listFind(form.selectPrograms, "All")>
    
        union all
        
        select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, ec.invoiceid, sum(ec.amount) as amount
        from egom_charges ec
        inner join egom_invoice ei on ei.invoiceid = ec.invoiceid
        inner join smg_users su on su.userid = ei.intrepid
        left join smg_programs sp on sp.programid = ec.programid
        where ec.programid = 0
        and ec.date > '2009-12-01'
        group by ei.intrepid
        
        union all
        
        select concat(su.businessname, " (", ei.intrepid, ")") as intl_rep, ei.intrepid, su.billing_contact, su.billing_email, concat(sp.programname, " (", ec.programid, ")") as program, ec.programid, ec.invoiceid, sum(epc.amount_paid * -1)
        from egom_payment_charges epc
        left join egom_charges ec on ec.chargeid = epc.chargeid
        inner join egom_invoice ei on ei.invoiceid = ec.invoiceid
        inner join smg_users su on su.userid = ei.intrepid
        left join smg_programs sp on sp.programid = ec.programid
        where ec.programid = 0
        and ec.date > '2009-12-01'
        group by ei.intrepid
        
        union all
        
        select concat(su.businessname, " (", ecd.intrep, ")") as intl_rep, ecd.intrep, ecd.originalPayRef, '', '', '', '', sum(ecd.amount * -1)
        from egom_credits ecd
        inner join smg_users su on su.userid = ecd.intrep
        group by ecd.intrep
    
    </cfif>
    
    ) t
    
    group by t.intrepid HAVING amount < 0
    order by amount DESC
    
</cfquery>

<br/>

<br/><br/>

<strong><small><center>REFUNDS DUE</center></small></strong>
<br/>

<cfif qTotalAgentNegBalance.recordCount EQ 0>
	<small><center>There are not refunds due for the selected programs</center></small>
<cfelse>
<table class="frame" align="center">

    <tr class="darkBlue">
        <td class="right">AGENT</td>
        <td class="right">TOTAL</td>
    </tr>

<cfoutput query="qTotalAgentNegBalance">

    <cfinput type="hidden" name="agentId" value="#qTotalAgentBalance.intrepid#">        
    
    <tr <cfif qTotalAgentNegBalance.currentRow MOD 2>bgcolor="##FFFFFF"</cfif>>
        
        <td class="two">#toString(qTotalAgentNegBalance.intl_rep)#</td> 
        <td class="two <cfif qTotalAgentNegBalance.amount LT 0>style1</cfif>">#LsCurrencyFormat(qTotalAgentNegBalance.amount)#</td>
        
    </tr>
    
    <cfparam name="grandTotalNegBal" default="0">
    <cfset grandTotalNegBal = grandTotalNegBal + qTotalAgentNegBalance.amount>

</cfoutput>

<cfoutput>

    <tr class="darkBlue">        
        <td class="right">TOTAL</td>
        <td class="right">#LsCurrencyFormat(variables.grandTotalNegBal)#</td>
    </tr>

</cfoutput>

</table>

</cfif>

</cfform>

</body>
</html>