<!----Insert the data that we are going to collect and put it in the database---->
<cfquery name="insert_contact_info" datasource="caseusa">
insert into case_web_contacts (firstname, lastname, address, city, state, zip, phone, email)
					values('#form.firstname#','#form.lastname#','#form.address#','#form.city#',#form.state#,'#form.zip#','#form.phone#','#form.email#')			
</cfquery>

<!----Email the information to Stacy---->
<cfmail to="jeimi@exitgroup.org,josh@pokytrails.com" from="#form.email#" subject="Rep Contact from Website" type="html"> 
Stacy-

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
</table>

</cfmail>
<cfoutput>

Your information was submited to Case.  A rep should be contacting you shortly. <br />

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
</table>
</cfoutput>
