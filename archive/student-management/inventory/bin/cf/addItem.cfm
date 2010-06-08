<cfif  form.lowpoint EQ ''>
	<cfset form.lowpoint = '0'>
</cfif>
<cfif  form.itemname NEQ ''>
	<cfquery name="additem" datasource="mysql">
		INSERT INTO inventory_items
			(companyid, name, description, file, stock, printed, sample, low_point)
		VALUES
			('#form.companyid#', '#form.itemname#', '#form.description#', '#form.file#', '0', '#form.printed#',
			 '#form.sample#', '#form.lowpoint#')
	</cfquery>
	<addsuccess>yes</addsuccess>
<cfelse>
<addsuccess>no</addsuccess>
</cfif>