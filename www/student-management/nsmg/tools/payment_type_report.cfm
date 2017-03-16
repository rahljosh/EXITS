<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>

<body>
<cfquery name="types" datasource="MySQL">
	select distinct(transtype)
	from smg_users_payments
	where dateCreated between '2017-02-01' and '2017-02-28'
	and companyid in (1,2,3,4,5,12) 
</cfquery>
<Table>
<Tr colspa=5>
	<th>Summary for Date Range</Th>
</Tr>	
<Tr>
	<td>Description</td>
	<td>Amount</td>
</Tr>

<cfoutput>
	<cfloop query="types">
	<Cfquery name="amounts" datasource="query">
		select sum(amount) as sumAmount
		from types
		where transtype = '#transtype#'
	</Cfquery>
	
	<Tr>
		<Td>#transtype#</Td><td>#amounts.sumAmount#</td>
	</Tr>
		
		
	</cfloop>
	
</cfoutput>
<Cfquery name="totalAmount" datasource="query">
		select sum(amount) as sumAmount
		from types
	
	</Cfquery>
	<tr>
		<Td>
			<strong>Total</strong>
		</Td>
		<Td>
			<strong>#totalAmount.sumAmount#</strong>
		</Td>
	</tr>
	</Table>

</body>
</html>
