<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfquery name="insert_charge" datasource="MySQL">
insert into smg_charges (type, description, amount, amount_due, agentid, date, userinput, companyid)
			values ('#form.type#','#form.description#', #form.amount#, #form.amount#, #form.agentid#,#now()#, #client.userid#, #client.companyid#)
</cfquery>


<script language="JavaScript"><!--
function load(file,target) {
    if (target != '')
        target.window.location.href = '?curdoc=invoice/invoice_index?userid=#url.userid#';
    else
        window.location.href = '?curdoc=invoice/invoice_index';
}
//-->
</script>


<cflocation url="add_charge.cfm?userid=#form.agentid#">

</body>
