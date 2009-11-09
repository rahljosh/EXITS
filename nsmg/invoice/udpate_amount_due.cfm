<cfquery name="get_charge" datasource="MySQL">
select chargeid, amount, type 
from smg_charges
</cfquery>

<cfloop query="get_charge">
<cfquery name="amount_due" datasource="mysql">
update smg_charges
<cfif type is 'program fee'>
	set amount_due = (#amount# - 500)
<cfelse>
	set amount_Due = #amount#
</cfif>
	where chargeid = #chargeid#
</cfquery> 
</cfloop>