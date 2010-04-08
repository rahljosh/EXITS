<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<link rel="stylesheet" href="../../../smg.css" type="text/css">
<head>
<title>Receive Payments</title>
<div class="application_section_header">Payment Received</div><br>
</head>

<style type="text/css">
<!--
.style1 {font-size: 12px}

.thin-border{ border: 1px solid #000000;}
.thin-border-right{ border-right: 1px solid #000000;}
.thin-border-left{ border-left: 1px solid #000000;}
.thin-border-right-bottom{ border-right: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
.thin-border-left-bottom{ border-left: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-right-bottom-top{ border-right: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-top{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-right{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-left-top-right{ border-left: 1px solid #000000; border-top: 1px solid #000000; border-right: 1px solid #000000;}
-->
</style>
<Cfquery name="payments_received" datasource="caseusa">
select distinct paymentref
from smg_payment_received
where agentid = 19
</Cfquery>
<table width=50% align="center" class="thin-border" cellpadding=4 cellspacing=0>
	<tr bgcolor="#CCCCCC">
		<td>Agent</td><td>Payment Processed</td><td>Refrence #</td><td>Total Received</td>
	</tr>
<cfoutput query=payments_Received>
<cfquery name="totals" datasource="caseusa">
select agentid, paymenttype, date, paymentref, sum(totalreceived) as payment_total
from smg_payment_received
where paymentref = #paymentref#
group by agentid
</cfquery>


<cfloop query=totals>
<cfquery name="agent_details" datasource="caseusa">
select businessname
from smg_users
where userid = #agentid#
</cfquery>
<tr>
<td>#agent_details.businessname# (#agentid#)</td><Td>#DateFormat(date, 'mm/dd/yyyy')#</Td><Td>#paymentref#</Td><td>#LSCurrencyFormat(payment_total, 'local')#</td> 
</tr>

</cfloop>

</cfoutput></table>