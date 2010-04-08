<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<link rel="stylesheet" href="../../smg.css" type="text/css">
<head>
<title>Receive Payments</title>
<div class="application_section_header">Total Amount Invoiced</div><br>
</head>

<!----Report to show how much has been invoiced to each company.  Shows absolutly every thing.---->


<cfquery name=amount_invoiced datasource="caseusa">
select *
from smg_charges
where invoiceid <> 0
</cfquery>

<cfoutput query="amount_invoiced">
#companyid# #agentid# #invoiceid# #stuid#  Student Name #type# #amount#<br>


</cfoutput>

