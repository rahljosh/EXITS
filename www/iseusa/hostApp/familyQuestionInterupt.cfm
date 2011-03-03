<cfquery name="qHostParentsMembers" datasource="mysql">
select h.fatherfirstname, h.fatherdob, h.fatherlastname, h.motherfirstname, h.motherlastname, h.motherdob
from smg_hosts h
where h.hostid = #client.hostid# 
</cfquery>
<cfquery name="qHostFamilyMembers" datasource="mysql">
select k.name, k.lastname, k.birthdate, k.cbc_form_received
from smg_host_children k
where k.hostid = #client.hostid# 
</cfquery>

<h2>Criminal Background Check</h2>
Due to Department of State Regulations&dagger;, criminal background checks will need to be run on the following persons.  Please provide the following information on each person so that we can complete the background check. <Br /><Br />
<cfoutput>
<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr>
   	<Th>Name</Th><th>Date of Birth</th><th>Age</th><Th>Drivers License ##</Th><th>Social Security</th>
    </Tr>
   <Cfif qHostParentsMembers.recordcount eq 0>
    <tr>
    	<td>Currently, no family members require a backgroundcheck.</td>
    </tr>
    <cfelse>
    <Cfloop query="qHostParentsMembers">
    <cfif fatherfirstname is not ''>
        <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
            <Td><h3><p class=p_uppercase>#fatherfirstname# #fatherlastname#</h3></Td>
            <Td><h3>#DateFormat(fatherdob, 'mmm d, yyyy')#</h3></Td>
            <td><h3>#DateDiff('yyyy',fatherdob,now())#</h3></td> 
            <td><input type="text" size=10 name="fatherssn"/></td>
            <td><input type="text" size=10 name="fatherdl"/></td>
        </tr>
    </cfif>
    <cfif motherfirstname is not ''>
        <tr >
            <Td><h3><p class=p_uppercase>#motherfirstname# #motherlastname#</h3></Td>
            <Td><h3>#DateFormat(motherdob, 'mmm d, yyyy')#</h3></Td>
            <td><h3>#DateDiff('yyyy',motherdob,now())#</h3></td> 
            <td><input type="text" size=10 name="motherssn"/></td>
            <td><input type="text" size=10 name="motherdl"/></td>
        </tr>
    </cfif>
    </Cfloop>
    <Cfloop query="qHostFamilyMembers">
		
        <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
            <Td><h3><p class=p_uppercase>#name# #lastname#</h3></Td>
            <Td><h3>#DateFormat(birthdate, 'mmm d, yyyy')#</h3></Td>
            <td><h3>#DateDiff('yyyy',birthdate,now())#</h3></td> 
			<Cfif #DateDiff('yyyy',birthdate,now())# gte 18>
                <td><input type="text" size=10 name="kssn"/></td>
                <td><input type="text" size=10 name="kdl"/></td>
            <cfelse>
                <td colspan=2 align="Center">Background check not required.</td>
            </Cfif> 
        </tr>
      
    </Cfloop>
    </cfif>
   </table>
	
</cfoutput>
<Br />
<p>By providing this information and clicking on submit I do hereby authorize verification of all information in my application for involvement with the Exchange Program from all necessary sources and additionally authorize any duly recognized agent of General Information Services, Inc. to obtain the said records and such disclosures.</p>
<p>Information entered on this Authorization will be used exclusively by General Information Services, Inc. for identification purposes and for the release of information that will be considered in determining any suitability for participation in the Exchange Program. </p>
<p>Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to request from General Information Services, Inc. information about the nature and substance of all records on file about me at the time of my request.  This may include the type of information requested as well as those who requested reports from General Information Services, Inc.  within the two-year period preceding my request.</p>
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><a href="index.cfm?page=familyInterests"><input name="Submit" type="image" src="../images/buttons/submitBlue.png" border=0></a></td>
	</tr>
</table>
<p><b>As part of our background check, reports from several sources may be obtained.  Reports may include, but not be limited to, criminal history reports, Social Security verifications, address histories,and Sex Offender Registries.  Should any results from the aforementioned reports indicate that driving history records will need to be reviewed during a more comprehensive assessment, an additional authorization and release will be requested at that time.  You have a the right, upon written request, to complete and accurate disclosure of the nature and scope of the background check. 
</b></p>

<h3><u>Department Of State Regulations</u></h3>
<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(7)</a></strong><br />
<em> Verify that each member of the host family household 18 years of age and older, as well as any new adult member added to the household, or any member of the host family household who will turn eighteen years of age during the exchange student's stay in that household, has undergone a criminal background check (which must include a search of the Department of Justice's National Sex Offender Public Registry);</em>

<br /><br />
<!---
<h3>Great!  Your done with the fast, simple questions. Now we need to get to know your family a little better.  The next few pages include questions that are key items we use to find kids that will ultimately fit best with your family. </h3>
<br />
<div align="center"><a href="index.cfm?page=familyInterests">Lets get started....</a></div>
---->
