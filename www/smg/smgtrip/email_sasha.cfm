

<!----Email the information to Sasha---->
<cfmail to="sasha@troikaviagens.com " from="trips@student-management.com" replyto="#form.email#"  cc="jeimi@exitgroup.org" subject="Trip Contact Info" type="html"> 
Sasha-

The following information was submitted on the website. 
<table>
	<Tr>
		<td>First Name:</td><td>#form.firstname#</td>
	</Tr>
	<tr>
		<td>Last Name:</td><td> #form.lastname#</td>
	</tr>
	<tr>
		<td>Email:</td><td> #form.email#</td>
	</tr>
    <tr>
		<td>Telephone:</td><td> #form.phone#</td>
	</tr>
    <tr>
		<td>Fax Number:</td><td> #form.faxnumber#</td>
	</tr>
    <tr>
		<td>Name of Tours:</td><td> #form.nameoftour#</td>
	</tr>
    <tr>
		<td>Tour Dates:</td><td> #form.tourdates#</td>
	</tr>
    <tr>
		<td>Departure City / Airport:</td><td> #form.departurecity#</td>
	</tr>
    <tr>
		<td>Return City / Airport:</td><td> #form.returnAirport#</td>
	</tr>
</table>

</cfmail>
<cfoutput>

Your information was submited.  If we have any further questions we will contact you. <br />

The following information submitted:<br />
<table>
	<Tr>
		<td>First Name:</td><td>#form.firstname#</td>
	</Tr>
	<tr>
		<td>Last Name:</td><td> #form.lastname#</td>
	</tr>
	<tr>
		<td>Email:</td><td> #form.email#</td>
	</tr>
    <tr>
		<td>Telephone:</td><td> #form.phone#</td>
	</tr>
    <tr>
		<td>Fax Number:</td><td> #form.faxnumber#</td>
	</tr>
    <tr>
		<td>Name of Tours:</td><td> #form.nameoftour#</td>
	</tr>
    <tr>
		<td>Tour Dates:</td><td> #form.tourdates#</td>
	</tr>
    <tr>
		<td>Departure City / Airport:</td><td> #form.departurecity#</td>
	</tr>
    <tr>
		<td>Return City / Airport:</td><td> #form.returnAirport#</td>
	</tr>
</table>
</cfoutput>
