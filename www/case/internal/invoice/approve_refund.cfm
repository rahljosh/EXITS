<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<!----get invoice number to add 1 for new invoice number---->
<cfquery name="get_invoice_number" datasource="caseusa">
select max(refund_receipt_id) as id
from smg_invoice_refunds
</cfquery>
<cfset new_id = #get_invoice_number.id# + 1>

<!----Get Credit ID and inactivate credits---->
<cfquery name="get_credit_id" datasource="caseusa">
select creditid
from smg_invoice_refunds
where refund_receipt_id = 0 and agentid = #url.userid#
</cfquery>
<cfoutput query="get_credit_id">
<cfquery name= "set_inactive" datasource="caseusa">
update smg_credit
set active = 0
where creditid = #creditid#
</cfquery>
</cfoutput>

<!----Assigne Receipt number to Refund items---->
<cfquery name="assign_receipt" datasource="caseusa">
update  smg_invoice_refunds
set refund_receipt_id = #new_id#
where agentid = #url.userid# and refund_receipt_id = 0
</cfquery>

<body onLoad="opener.location.reload()"> 
<h2>Receipt has been succesfully created.</h2>

<br><br>
<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">