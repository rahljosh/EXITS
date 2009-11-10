<cfif  form.lowpoint_edit EQ ''>
	<cfset form.lowpoint_edit = '0'>
</cfif>
<cfif  form.itemname_edit NEQ ''>
	<cfquery name="additem" datasource="mysql">
		UPDATE inventory_items
		SET name='#form.itemname_edit#', description='#form.description_edit#', file='#form.file_edit#',
			printed='#form.printed_edit#', sample='#form.sample_edit#', low_point='#form.lowpoint_edit#'
		WHERE itemid = '#form.itemid_edit#'
	</cfquery>

<addsuccess>yes</addsuccess>
<cfelse>
<addsuccess>no</addsuccess>
</cfif>