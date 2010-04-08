
<div class="application_section_header">Create Invoice</div><br>
Select the type of invoice you would like to create from the options below.<br><br>

<i>If an item is greyed out, it means that no charges of that type are currently waiting to be invoiced.</i><br/><br/>
<cfquery name="type_check" datasource="caseusa">
select distinct type from smg_charges
where invoiceid = 0 and agentid = #url.agentid#
</cfquery>
<cfset typelist = ''>
<cfoutput query=type_check>
<cfset typelist = ListAppend(typelist, '#type#')>
</cfoutput>
<cfoutput>
<cfform method="post" action="invoice/create_invoice.cfm?agentid=#url.agentid#" name="type">
<table>
	<tr>
		<td><cfinput type="radio" name="inv_type" value="deposit" message="Please select an invoice type." required="yes"></td><td>Deposit - <font size=-2>creates an invoice with ALL deposits in the current charges list.</font></td>
	</tr>
	<tr>
		<td><cfinput type="radio" name="inv_type" value="final" message="Please select an invoice type." required="yes"></td><td>Final - <font size=-2>creates an invoice with ALL program charges, insurance, regional guarantees in the current charges list.</font></td>
	</tr>
	<tr>
		<td><cfinput type="radio" name="inv_type" value="misc" message="Please select an invoice type." required="yes" ></td><td>Miscellanoues - <font size=-2>creates an invoice with ALL other charges not invoiced in the current charges list.</font></td>
	</tr>
</table><br>

<font size=-2>**Clicking on Submit will create the invoice type indicated above and can not easily be undone by the system.  For mistakes with charges you didn't mean to invoice yet, please contact Josh, ASAP and they can be corrected.**</font>
<br><br>
<div class="button" align="right"><input type="submit" value=" Generate Invoice "></div>
</cfform>
</cfoutput>

