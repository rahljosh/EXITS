<link rel="stylesheet" href="forms.css" type="text/css">
<div style="width:500px; background-color: #white; padding: 5px; margin: 0px auto;">
	

<cfset client.hostid = 50>
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>

<cfquery name="host_info" datasource="MySQL">
select * 
from Smg_hosts
where hostid = #client.hostid#
</cfquery>

<cfquery name="host_kids" datasource="MySQL">
select *
from smg_host_children
where hostid = #client.hostid#
</cfquery>

<cfquery name="host_pets" datasource="MySQL">
select *
from smg_host_animals
where hostid = #client.hostid#
</cfquery>

<cfquery name="host_interests" datasource="MySQL">
select interests
from smg_hosts
where hostid = #client.hostid#
</cfquery>

<cfquery name="host_Religion" datasource="MySQL">
select religionname
from smg_religions 
where religionid = #host_info.religion#
</cfquery>

<cfquery name="host_church" datasource="MySQL">
select *
from smg_churches
where churchid = #host_info.churchid#
</cfquery>

<Cfquery name="school_info" datasource="MySQL">
select *
from smg_schools
where schoolid = #host_info.schoolid#
</cfquery>
<cfquery name="host_refs" datasource="MySQL">
select * 
from smg_family_references
where referencefor = #client.hostid#
</cfquery>
<i>Once you have reviewed the information and are ready to process your application, please click on 'Process Application'.  Your application will NOT be reviewed until this is done.</i>
<br><Br>
<span class="application_section_header">Contact & Host Parents  Information</span>
<cfoutput>
<Table width="612">
	<tr>
		<td>
#host_info.Fatherfirstname#<cfif #host_info.fatherlastname# is #host_info.motherlastname#> and <cfelse> #host_info.fatherlastname# and </cfif> #host_info.motherfirstname#<cfif #host_info.fatherlastname# is #host_info.motherlastname#> #host_info.familylastname# <cfelse> #host_info.motherlastname# </cfif><br>

#host_info.address#<br>
<cfif #host_info.address2# is not ''>
#host_info.address2#<br>
</cfif>
#host_info.city# #host_info.state#, #host_info.zip#
<br>
#host_info.phone#<br>
#host_info.email#<br>
<br>
		</td>
		<td valign="top">

		<table cellspacing="0" cellpadding="0" align="right">
			<tr>
				<td width=110 bgcolor="black"><font color="white">Employment Info</td><td width=150 bgcolor=WhiteSmoke align="Center"><u>#host_info.fatherfirstname#</u></td><td align="center" bgcolor=f0f0f0><u>#host_info.motherfirstname#</u></td>
			</tr>
			<tr bgcolor=ececff>
				<td>Occupation</td><td bgcolor=WhiteSmoke>#host_info.fatherworktype#</td><td bgcolor=f0f0f0>#host_info.motherworktype#</td>
			</tr>
			<tr bgcolor=ffecef>
				<td>Company</td><td bgcolor=WhiteSmoke>#host_info.fathercompany#</td><td bgcolor=f0f0f0>#host_info.mothercompany#</td>
			</tr>
			<tr bgcolor=ececff>
				<td>Work Phone</td><td bgcolor=WhiteSmoke>#host_info.fatherworkphone#</td><td bgcolor=f0f0f0>#host_info.motherworkphone#</td>
			</tr>
			<tr bgcolor=ffecef>
				<td>SSN</td><td bgcolor=WhiteSmoke>#host_info.fatherSSN#</td><td bgcolor=f0f0f0>#host_info.motherSSN#</td>
			</tr>
		
		</table>
		
		</td>
	</tr>
</table>

</cfoutput>
<br>
<span class="application_section_header">Other Family Members</span>
<table border=0 width=100% cellpadding=0 cellspacing=0>
	<tr>
		<td align="center"><U>Name</td>
		<td align="center"><U>Birthdate</td>
		<td align="center"><U>Sex</td>
		<td align="center"><u>Relationship</td>
		<td align="center"><u>Share Room</td>
	</tr>
	<cfoutput query="host_kids">
	<cfif host_kids.currentrow MOD 2> <tr bgcolor=whitesmoke><cfelse><tr></cfif>
		<td align="center">#name#</td>
		<td align="center">#dateformat('#birthdate#','yyyy/mm/dd')#</td>
		<td align="center">#sex#</td>
		<td align="center">#membertype#</td>
		<td align="center">#shared#</td>
	</tr>
	</cfoutput>
</table>
<br>
<span class="application_section_header">Family Interests</span><br>
<cfoutput>
#host_info.interests_other#<br><br>

Other activities that you have an interest or participate in include

<cfloop list=#host_interests.interests# index=i>
	<cfquery name="get_interests" datasource="MySQL">
		Select interest 
		from smg_interests 
		where interestid = #i#
	</cfquery>

	#get_interests.interest#,

</cfloop>
</cfoutput> 
<cfoutput>
<br>
<cfif #host_info.band# is 'no'>NO f<cfelse>F</cfif>amily members play in a band.<br>
<cfif #host_info.orchestra# is 'no'>NO f<cfelse>F</cfif>amily members play are in an orchestra.<br>
<cfif #host_info.comp_sports# is 'no'>NO f<cfelse>F</cfif>amily members play in a competitve sport.<br>
<br>
<span class="application_section_header">Animals and Smoking</span><br>

Your family has #host_pets.recordcount# pet<cfif #host_pets.recordcount# gt 1>s</cfif><br>
</cfoutput>
<cfoutput query="host_pets">
#number# #animaltype#<cfif #number# gt 1>s</cfif> which <cfif #number# gt 1>are</cfif>is <cfif #indoor# is 'both'>both an indoor and outdoor<cfelseif #indoor# is 'indoor'>an indoor<cfelse>an outdoor</cfif> #animaltype#. <br>
</cfoutput>
You are <cfif #host_info.pet_allergies# is 'no'>not</cfif> willing to host a student who is allergic to animals.<br>
<br>
<Cfoutput>
Your family <cfif #host_info.hostsmokes# is 'no'>doesn't</cfif> smoke<cfif #host_info.hostsmokes# is not 'no'>s</cfif>.<br>
Your family will <cfif #host_info.acceptsmoking# is 'no'>not</cfif> accept a student who smokes<cfif host_info.smokeconditions is ''>.<cfelse> under the the following conditions:<br>
#host_info.smokeconditions#</cfif>
</cfoutput>
<br><br>
 <DIV style="page-break-after:always"></DIV>
<cfoutput>
<span class="application_section_header">Religious Information</span><br>
Your family<cfif #host_info.religion# is 00> does not have a religious affiliation.<cfelse> has a #host_religion.religionname# religious affiliation.</cfif><br>
Your family <cfif #host_info.religious_participation# is "no interest" or #host_info.religious_participation# is "inactive">does not<cfelseif #host_info.religious_participation# is "little interest">occasionally<cfelseif #host_info.religious_participation# is "average"> frequently (1-2 times a week) attends <cfelseif #host_info.religious_participation# is "active"> very frequently (more then 2 times a week)</cfif> attends religious gatherings.<br>
You <cfif #host_info.churchfam# is 'yes'><cfelse>do not </cfif>expect your student to attend your religius services. <br>
You will <cfif #host_info.churchtrans# is 'yes'><cfelse>not </cfif>provide transportation to your students religious services.<br>
<cfif #host_info.religion# is 00><cfelse>
Your church information:<br>
#host_church.pastorname#<br>
#host_church.churchname#<br>
#host_church.address#<br>
<cfif #host_church.address1# is ''><cfelse>#host_church.address1#<br></cfif>
#host_church.city# #host_church.state#, #host_church.zip#<br>
#host_church.phone#<br>
</cfif>
<br>
<span class="application_section_header">House Rules</span><br>
Regarding Smoking:<br>
<Cfif #host_info.houserules_smoke# is ''>No rules regarding smoking.<cfelse>#host_info.houserules_smoke#</cfif><br><Br>
Regarding Weeknight Curfew:<br>
<Cfif #host_info.houserules_curfewweeknights# is ''>No rules regarding a weeknight curfew.<cfelse>#host_info.houserules_curfewweeknights#</cfif><br><Br>
Regarding Weekend Curfew:<br>
<Cfif #host_info.houserules_curfewweekends# is ''>No rules regarding a weekend curfew.<cfelse>#host_info.houserules_curfewweekends#</cfif><br><Br>
Regarding Chores:<br>
<Cfif #host_info.houserules_chores# is ''>No rules regarding hosehold chores.<cfelse>#host_info.houserules_chores#</cfif><br><Br>
Regarding Church:<br>
<Cfif #host_info.houserules_church# is ''>No rules regarding church services.<cfelse>#host_info.houserules_church#</cfif><br><Br>
Regarding Other Rules:<br>
<Cfif #host_info.houserules_other# is ''>No other specific rules.<cfelse>#host_info.houserules_other#</cfif><br><Br>
<DIV style="page-break-after:always"></DIV>
<span class="application_section_header">School Information</span><br>
<table width=100%>
	<tr>
		<td>
		#school_info.schoolname#<br>
		#school_info.address#<br>
		<cfif #school_info.address2# is ''><cfelse>#school_info.address2#</cfif>
		#school_info.city# #school_info.state#, #school_info.zip#<br>
		Principal: #school_info.principal#<br>
		Phone: #school_info.phone#<br>
		Fax: #school_info.fax#<br>
		Email: #school_info.email#<br>
		Web: #school_info.url#<Br>
		</td>
		<td valign="top">
			<table cellpadding=0 cellspacing=0>
			<tr>
				<td align="right">Enrollment/Orientation: &nbsp;&nbsp;</td><td> #dateformat('#school_info.enrollment#', 'mmmm d, yyyy')#</td>
			</tr>
			<tr>
		<td align="right">School Year Begins: &nbsp;&nbsp;</td><td> #dateformat('#school_info.begins#', 'mmmm d, yyyy')#</td>
			</tr>
			<tr>
		<td align="right">Second Semester Begins: &nbsp;&nbsp;</td><td> #dateformat('#school_info.semesterbegins#', 'mmmm d, yyyy')#</td>
			</tr>
			<tr>
		<td align="right">School Year Ends: &nbsp;&nbsp;</td><td> #dateformat('#school_info.ends#', 'mmmm d, yyyy')#</td>
		</td>
			</tr>
			<tr>
				<td align="center" colspan=2>&middot;&middot;&middot;&middot;&middot;&middot;&middot;&middot;&middot;&middot;&middot;&middot;</td>
			</tr>
			<tr>
				<td align="right">Number of Students: &nbsp;&nbsp;</td><td>#school_info.numberofstudents#</td>
			</tr>
			<tr>
				<td align="right">College Bound: &nbsp;&nbsp;</td><td>#school_info.collegebound#%</td>
			</tr>
			<tr>
				<td align="right">Transportation: &nbsp;&nbsp;</td><td>#host_info.schooltransportation#</td>
		</table>
	</tr>
</table>
<br>
	Programs, unique features or electives available to foreign students:<br>
	#school_info.special_programs#<br><br>
	High school policy regarding graduation of exchange students and granting of diploma:<br>
	#school_info.grad_policy#<br><br>
	Extra curricular activities and sports available to exchange students:<br>
	#school_info.sports#<br><br>
	Other school policies related to exchange students:<br>
	#school_info.other_policies#<br><br>
	Private High School information:<br>
	#school_info.private_school_info#<br><br>
	
<DIV style="page-break-after:always"></DIV>
<span class="application_section_header">Community Information</span><br>
#host_info.city# #host_info.state# <br>
Population: #numberformat(host_info.population)#<br>
Airport: #host_info.local_air_code#<br>

You live in a #host_info.neighborhood# neighborhood, and the community is #host_info.community#. <br>
The terrain of your community is #host_info.terrain1# with #host_info.terrain2# and <cfif host_info.terrain3 is 'other'>#host_info.terrain3_desc#<cfelse>#host_info.terrain3#</cfif>.<br>
<cfset wc = ( (5/9)*(#host_info.wintertemp#-32) )>
<cfset sc = ( (5/9)*(#host_info.summertemp#-32) )>
Pocatello's average winter temperature is #host_info.wintertemp#<sup>o</sup>F (#numberformat(wc)#<sup>o</sup>C) and the average summer temperature is #host_info.summertemp#<sup>o</sup>F (#numberformat(sc)#<sup>o</sup>C)<br><br>

Your student should try to bring the following items:<br>
#host_info.special_cloths#
<br><br>
Pocatello has the following activities and points of interest:<br>
#host_info.point_interest#
<br><br>
Nearest Major City: #host_info.near_city# <br>
Population #numberformat(host_info.near_pop)#<br>
Airport: #host_info.major_air_code#<br>
 Distance: #host_info.near_City_dist#<br><br>

<DIV style="page-break-after:always"></DIV>
<span class="application_section_header">Family Letter</span><br>
#host_info.familyletter#
</cfoutput>
<br>
<br>

<DIV style="page-break-after:always"></DIV>
<span class="application_section_header">Pictures</span><br>
<cfquery name="get_pic" datasource="MySQL">
select pictures from
smg_hosts 
where hostid = #client.hostid#
</cfquery>

<table>
	<tr>
<cfloop index="x" from=1 to=#get_pic.pictures#>		

<cfoutput query="get_pic"><td>#x#</td><td><cfoutput><img height=200 src="../hostpics/#client.hostid#_#x#.jpg"></cfoutput></td>
<cfif (x MOD 2 ) is 0></tr><tr></cfif>
</cfoutput>
</cfloop>
</table>

</table>

<br>
<br>
<DIV style="page-break-after:always"></DIV>
<span class="application_section_header">References</span><br>

<cfoutput query="host_refs">
#name#<br>
#address#<br>
<cfif address2 is ''><cfelse>#address2#<br></cfif>
#City# #state#, #zip#<br>
#phone#<br><br>
</cfoutput>


<cfform action="../querys/process_host_app.cfm" method="POST" enablecab="Yes"> <INPUT type="submit" value="    process application    "></cfFORM>

