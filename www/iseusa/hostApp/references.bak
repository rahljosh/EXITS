<cfset field_list = 'firstname,lastname,address,address2,city,state,zip,phone,email'>

<cfparam name="form.firstname" default="">
<cfparam name="form.lastname" default="">
<cfparam name="form.address" default="">
<cfparam name="form.address2" default="">
<cfparam name="form.city" default="">
<cfparam name="form.state" default="">
<cfparam name="form.zip" default="">
<cfparam name="form.phone" default="">
<cfparam name="form.email" default="">
<cfif isDefined('url.delete')>
	<cfquery datasource="mysql">
    delete from smg_family_references
    where refid = #url.delete#
    </cfquery>
</cfif>
<cfif isDefined('url.edit')>
	<cfquery name="get_record" datasource="mysql">
		SELECT *
		FROM smg_family_references
		WHERE refid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.edit#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>

</cfif>


<cfif isDefined('form.insert')>
    <cfquery datasource="MySQL">
    insert into smg_family_references(firstname, lastname, address, address2, city, state, zip, phone, email, referencefor)
        values('#form.firstname#','#form.lastname#', '#form.address#', '#form.address2#', '#form.city#', '#form.state#', #form.zip#, '#form.phone#', '#form.email#', #client.hostid#)
    </cfquery>
</cfif>
    <!---number kids at home---->
    <cfquery name="kidsAtHome" datasource="mysql">
    select count(childid) as kidcount
    from smg_host_children
    where liveathome = 'yes' and hostid =#client.hostid#
    </cfquery>
 	<Cfquery name="get_host_info" datasource="mysql">
    select fatherfirstname, motherfirstname
    from smg_hosts
    where hostid = #client.hostid#
    </cfquery>

	<Cfset father=0>
    <cfset mother=0>
  
    <Cfif get_host_info.fatherfirstname is not ''>
        <cfset father = 1>
    </Cfif>
    <Cfif get_host_info.motherfirstname is not ''>
        <cfset mother = 1>
    </Cfif>
    
	<cfset client.totalfam = #mother# + #father# + #kidsAtHome.kidcount#>
    
<h2>Current References</h2>
<p><em><strong>PLEASE NOTE:</strong> The Department of State now requires a second home visit which will be conducted by someone other than your local Area Representative.</em></p>
Please provide at least <cfif client.totalfam eq 1>six (6)&dagger;&dagger;<cfelse>four (4)&dagger;</cfif> references.  References can <strong>not</strong> be relatives and must have visited you <strong>in side</strong> your home. 
<br />
<cfquery name="qreferences" datasource="MySQL">
select *
from smg_family_references
where referencefor = #client.hostid#
</cfquery>

<cfoutput>

<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr>
   	<Th>Name</Th><Th>Address</Th><th>City</th><Th>State</Th><th>Zip</th><th>Phone</th><th></th>
    </Tr>
   <Cfif qreferences.recordcount eq 0>
    <tr>
    	<td colspan=7>Currently, no references are on file for you</td>
    </tr>
    <cfelse>
    <Cfloop query="qreferences">
    <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
    	<Td><h3><p class=p_uppercase>#firstname# #lastname#</h3></Td>
        <td><h3><p class=p_uppercase>#address# #address2#</h3></td>
        <Td><h3>#city#</h3></Td>
        <td><h3>#state#</h3></td>
        <td><h3>#zip#</h3></td>
        <td><h3>#phone#</h3></td>
        <Td><a href="?page=references&edit=#refid#">EDIT</a> <a href="?page=references&delete=#refid#" onClick="return confirm('Are you sure you want to delete this reference?')"> DELETE</a></Td>
    </tr>
    </Cfloop>
    </cfif>
   </table>
	
</cfoutput>

<h2>Add References</h2>
<cfoutput>
<Cfif client.totalfam eq 1>
	<cfset refs = 6>
<cfelse>
	<cfset refs = 4>
</Cfif>
<cfset remainingref = #refs# - #qreferences.recordcount#>

<cfif remainingref lte 0>
No additional references are required.
<cfelse>
#remainingref# additional references are required based on the information on your application.
</cfif>
<div align="center">
  <span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields </span>
</div>
<cfform method="post" action="?page=references">
<input type="hidden" name="insert" />
	  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3">
        <td class="label"><h3> First Name<span class="redtext">*</span></h3> </td>
        <td colspan=3>
            <cfinput type="text" name="firstname" value="#form.firstname#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter their first name.">
        </td>
      </tr>
    <tr>
        <td class="label"><h3> Last Name<span class="redtext">*</span></h3> </td>
        <td colspan=3>
            <cfinput type="text" name="lastname" value="#form.lastname#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter their last name.">
        </td>
      </tr>
     <tr bgcolor="##deeaf3">
        <td class="label">
        
        <h3>Address <span class="redtext">*</span></h3></td>
        <td colspan=2>
        	<cfinput type="text" name="address" value="#form.address#" size="40" maxlength="150" required="yes" validate="noblanks" message="Please enter the Address.">
            <font size="1">NO PO BOXES 
        </td>
        <td rowspan=2> </td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td></td>
        <td colspan=3><cfinput type="text" name="address2" value="#form.address2#" size="40" maxlength="150"></td>
    </tr>
    <tr>			 
        <td class="label"><h3>City <span class="redtext">*</span></h3></td>
        <td colspan=3><cfinput type="text" name="city" value="#form.city#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter the City."></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td class="label"><h3>State <span class="redtext">*</span></h3></td>
        <td>
            <cfquery name="get_states" datasource="mysql">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<cfselect NAME="state" query="get_states" value="state" display="statename" selected="#form.state#" queryPosition="below">
				<option></option>
			</cfselect>
        </td>
        <td class="zip"><h3>Zip<span class="redtext">*</span></h3> </td>
        <td><cfinput type="text" name="zip" value="#form.zip#" size="5" maxlength="5" required="yes" validate="zipcode" message="Please enter a valid Zip."></td>
    </tr>
	  <tr >
        <td ><h3>Phone <span class="redtext">*</span></h3></td>
        <td colspan=3><cfinput type="text" name="phone" value="#form.phone#" size="14" maxlength="14" mask="(999) 999-9999" validate="telephone" message="Please enter a valid Phone."></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td ><h3>Email</h3></td>
        <td colspan=3><cfinput type="text" name="email" value="#form.email#" size="30" maxlength="200" validate="email" message="Please enter a valid Email."></td>
    </tr>
	</table>
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
        <td align="right"><input name="Submit" type="image" src="../images/addReference.png" border=0> <a href="index.cfm?startApp.cfm&done"><img src="../images/done.png" /></a></td>
    </tr>
</table>

<h3><u>Department Of State Regulations</u></h3>
<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(5)</a></strong><br />
<em>Ensure that the host family has a good reputation and character by securing two personal references from within the community from individuals who are not relatives of the potential host family or representatives of the sponsor ( i.e. , field staff or volunteers), attesting to the host family's good reputation and character;</em>

<p>&dagger;&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(9)</a></strong><br />
       <em>Ensure that a potential single adult host parent without a child in the home undergoes a secondary level review by an organizational representative other than the individual who recruited and selected the applicant. Such secondary review should include demonstrated evidence of the individual's friends or family who can provide an additional support network for the exchange student and evidence of the individual's ties to his/her community. Both the exchange student and his or her natural parents must agree in writing in advance of the student's placement with a single adult host parent without a child in the home</em></p>
	


	
</cfform>
</cfoutput>