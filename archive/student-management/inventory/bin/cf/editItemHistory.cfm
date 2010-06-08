<cfif form.status NEQ ''>
	<cfquery name="edit_ItemHistory" datasource="mysql">
		INSERT INTO inventory_items_history
			(itemid, date, quantity, status, remarks, user_name)
		VALUES
			('#form.itemid_histedit#', #CreateODBCDate(form.date)#, '#form.quantity#', '#form.status#', '#form.remark#', '#session.auth.firstname#')
	</cfquery>
	
	<cfif form.status EQ 'Received' OR form.status EQ 'Sent Out' OR form.status EQ 'In Stock'>
	
		<cfquery name="getItemStock" datasource="MySQL">
			SELECT stock
			FROM inventory_items
			WHERE itemid = '#form.itemid_histedit#'
		</cfquery>
		
		<cfif form.status EQ 'Received' or  form.status EQ 'In Stock'>
			<cfset stockQuantity = #getItemStock.stock# + #form.quantity#>
		</cfif>
		
		<cfif form.status EQ 'Sent Out'>
			<cfset stockQuantity = #getItemStock.stock# - #form.quantity#>
		</cfif>
		
		<cfquery name="edit_ItemStock" datasource="mysql">
			UPDATE inventory_items
			SET stock = '#stockQuantity#'
			WHERE itemid = '#form.itemid_histedit#'
		</cfquery>
	</cfif>
	
<addsuccess>yes</addsuccess>
<cfelse>
<addsuccess>no</addsuccess>
</cfif>