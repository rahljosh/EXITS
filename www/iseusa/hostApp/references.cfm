<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

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




<cfif isDefined('form.insert')>
	 <!---Error Checking---->
         <cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.firstname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the first name.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(FORM.lastname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the last name.");
            }	
			
		
        	
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.phone)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the phone number.");
            }			
       </cfscript>
  
  
     <cfif NOT SESSION.formErrors.length()>
       <Cfif isDefined('url.edit')>
            <Cfquery name="updateRef" datasource="mysql">
                update smg_family_references 
                    set firstname = '#form.firstname#',
                        lastname = '#form.lastname#',
                        address = '#form.address#',
                        address2 = '#form.address2#',
                        city = '#form.city#',
                        state = '#form.state#',
                        zip = '#form.zip#',
                        phone = '#form.phone#',
                        email = '#form.email#',
                        referencefor = #client.hostid#
                    where refID = #url.edit#
            </Cfquery>
          `
        <cfelse>
            <cfquery datasource="MySQL">
                insert into smg_family_references(firstname, lastname, address, address2, city, state, zip, phone, email, referencefor)
                values('#form.firstname#','#form.lastname#', '#form.address#', '#form.address2#', '#form.city#', '#form.state#', '#form.zip#', '#form.phone#', '#form.email#', #client.hostid#)
            </cfquery>
              <Cfquery name="refID" datasource="mysql">
                select max(refid) as newID
                from smg_family_references
            </cfquery>
            
         
        </Cfif>
        <Cfquery name="checkNumberRef" datasource="mysql">
        select firstname
        from smg_family_references
        where referencefor = #client.hostid#
        </Cfquery>
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
    <Cfif client.totalfam eq 1>
	<cfset refs = 6>
    <cfelse>
        <cfset refs = 4>
    </Cfif>
	<cfset remainingref = #refs# - #checkNumberRef.recordcount#>
      
        <cfscript>
        	FORM.firstname = '';
			FORM.lastname = '';
			FORM.address = '';
			FORM.address2 = '';
			FORM.city = '';
			FORM.state = '';
			FORM.zip = '';
			FORM.phone = '';
			FORM.email = '';
		</cfscript>
    <Cfif remainingref eq 0>
        <cflocation url="index.cfm?page=checkList">

    </Cfif>
<Cfelse>




</cfif>
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
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
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
        <Td><a href="?page=references&edit=#refid#"><img src="../images/buttons/pencilBlue23x29.png" border=0 height=20/></a> <a href="?page=references&delete=#refid#" onClick="return confirm('Are you sure you want to delete this reference?')"> <img src="../images/buttons/delete23x28.png" height=20 border=0/></a></Td>
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

<form method="post" action="?page=references<Cfif isDefined('url.edit')>&edit=#url.edit#</cfif>">

<input type="hidden" name="insert" />
	  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3">
        <td class="label"><h3> First Name<span class="redtext">*</span></h3> </td>
        <td colspan=3>
            <input type="text" name="firstname" value="#form.firstname#" size="20" maxlength="150">
        </td>
      </tr>
    <tr>
        <td class="label"><h3> Last Name<span class="redtext">*</span></h3> </td>
        <td colspan=3>
            <input type="text" name="lastname" value="#form.lastname#" size="20" maxlength="150" >
        </td>
      </tr>
    <tr bgcolor="##deeaf3">
        <td ><h3>Phone <span class="redtext">*</span></h3></td>
        <td colspan=3><input type="text" name="phone" value="#form.phone#" size="14" maxlength="14" mask="(999) 999-9999"></td>
    </tr>
     <tr >
        <td class="label">
        
        <h3>Address </h3></td>
        <td colspan=2>
        	<input type="text" name="address" value="#form.address#" size="40" maxlength="150" >
            <font size="1">NO PO BOXES 
        </td>
        <td rowspan=2> </td>
    </tr>
    <tr >
        <td></td>
        <td colspan=3><input type="text" name="address2" value="#form.address2#" size="40" maxlength="150"></td>
    </tr>
    <tr bgcolor="##deeaf3" >			 
        <td class="label"><h3>City</h3></td>
        <td colspan=3><input type="text" name="city" value="#form.city#" size="20" maxlength="150" ></td>
    </tr>
    <tr>
        <td class="label"><h3>State </h3></td>
        <td>
            <cfquery name="get_states" datasource="mysql">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<select NAME="state" query="get_states">
			      	<option></option>
				<cfloop query="get_states">
                	<option value="#state#" <Cfif state eq #form.state#>selected</cfif>>#statename#</option>
                </cfloop>
            </select>
        </td>
        <td class="zip"><h3>Zip</h3> </td>
        <td><input type="text" name="zip" value="#form.zip#" size="5" maxlength="5"></td>
    </tr>
	
    <tr bgcolor="##deeaf3">
        <td ><h3>Email</h3></td>
        <td colspan=3><input type="text" name="email" value="#form.email#" size="30" maxlength="200" ></td>
    </tr>
	</table>
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
        <td align="right"><Cfif isDefined('url.edit')><a href="?page=references"><img src="../images/buttons/goBack_44.png" border=0/></a> <input name="Submit" type="image" src="../images/buttons/update_44.png" border=0><cfelse><input name="Submit" type="image" src="../images/buttons/addRef.png" border=0></Cfif>
        <br />
          <a onclick="ShowHide(); return false;" href="##">
         I am finished entering references.</a>
<div id="slidingDiv" display:"none">
        <A href="index.cfm?page=checkList"><img src="../images/buttons/Next.png" border="0" /></A>	</div>	
        
        
       </td>
    </tr>
</table>



	
</form>
</cfoutput>