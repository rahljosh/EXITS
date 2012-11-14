<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

<cfset field_list = 'firstname,lastname,address,address2,city,state,zip,phone,email'>

<cfparam name="FORM.firstname" default="">
<cfparam name="FORM.lastname" default="">
<cfparam name="FORM.address" default="">
<cfparam name="FORM.address2" default="">
<cfparam name="FORM.city" default="">
<cfparam name="FORM.state" default="">
<cfparam name="FORM.zip" default="">
<cfparam name="FORM.phone" default="">
<cfparam name="FORM.email" default="">

<cfif isDefined('URL.delete')>
	<cfquery datasource="#APPLICATION.DSN.Source#">
    delete from smg_family_references 
    where refid = #URL.delete#
    </cfquery>
</cfif>




<cfif isDefined('FORM.insert')>
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
       <cfif isDefined('URL.edit')>
            <cfquery name="updateRef" datasource="#APPLICATION.DSN.Source#">
                update smg_family_references 
                    set firstname = '#FORM.firstname#',
                        lastname = '#FORM.lastname#',
                        address = '#FORM.address#',
                        address2 = '#FORM.address2#',
                        city = '#FORM.city#',
                        state = '#FORM.state#',
                        zip = '#FORM.zip#',
                        phone = '#FORM.phone#',
                        email = '#FORM.email#',
                        referencefor = #APPLICATION.CFC.SESSION.getHostSession().ID#
                    where refID = #URL.edit#
            </Cfquery>
          `
        <cfelse>
            <cfquery datasource="#APPLICATION.DSN.Source#">
                insert into smg_family_references(firstname, lastname, address, address2, city, state, zip, phone, email, referencefor)
                values('#FORM.firstname#','#FORM.lastname#', '#FORM.address#', '#FORM.address2#', '#FORM.city#', '#FORM.state#', '#FORM.zip#', '#FORM.phone#', '#FORM.email#', #APPLICATION.CFC.SESSION.getHostSession().ID#)
            </cfquery>
              <cfquery name="refID" datasource="#APPLICATION.DSN.Source#">
                select max(refid) as newID
                from smg_family_references
            </cfquery>
            
         
        </cfif>
        <cfquery name="checkNumberRef" datasource="#APPLICATION.DSN.Source#">
        select firstname
        from smg_family_references
        where referencefor = #APPLICATION.CFC.SESSION.getHostSession().ID#
        </Cfquery>
        <!---number kids at home---->
    <cfquery name="kidsAtHome" datasource="#APPLICATION.DSN.Source#">
    select count(childid) as kidcount
    from smg_host_children
    where liveathome = 'yes' and hostID =#APPLICATION.CFC.SESSION.getHostSession().ID#
    </cfquery>
 	<cfquery name="get_host_info" datasource="#APPLICATION.DSN.Source#">
    select fatherfirstname, motherfirstname
    from smg_hosts
    where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
    </cfquery>

	<cfset father=0>
    <cfset mother=0>
  
    <cfif get_host_info.fatherfirstname is not ''>
        <cfset father = 1>
    </cfif>
    <cfif get_host_info.motherfirstname is not ''>
        <cfset mother = 1>
    </cfif>
    
	<cfset vTotalFamilyMembers = #mother# + #father# + #kidsAtHome.kidcount#>
    <cfif vTotalFamilyMembers eq 1>
	<cfset refs = 6>
    <cfelse>
        <cfset refs = 4>
    </cfif>
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
    <cfif remainingref eq 0>
        <cflocation url="index.cfm?section=checkList" addtoken="no">

    </cfif>
<cfelse>




</cfif>
</cfif>
<cfif isDefined('URL.edit')>
	<cfquery name="get_record" datasource="#APPLICATION.DSN.Source#">
		SELECT *
		FROM smg_family_references
		WHERE refid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.edit#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "FORM.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
</cfif>


    <!---number kids at home---->
    <cfquery name="kidsAtHome" datasource="#APPLICATION.DSN.Source#">
    select count(childid) as kidcount
    from smg_host_children
    where liveathome = 'yes' and hostID =#APPLICATION.CFC.SESSION.getHostSession().ID#
    </cfquery>
 	<cfquery name="get_host_info" datasource="#APPLICATION.DSN.Source#">
    select fatherfirstname, motherfirstname
    from smg_hosts
    where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
    </cfquery>

	<cfset father=0>
    <cfset mother=0>
  
    <cfif get_host_info.fatherfirstname is not ''>
        <cfset father = 1>
    </cfif>
    <cfif get_host_info.motherfirstname is not ''>
        <cfset mother = 1>
    </cfif>
    
	<cfset vTotalFamilyMembers = #mother# + #father# + #kidsAtHome.kidcount#>
    
<h2>Current References</h2>
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        
<p><em><strong>PLEASE NOTE:</strong> The Department of State now requires a second home visit which will be conducted by someone other than your local Area Representative.</em></p>
Please provide at least <cfif vTotalFamilyMembers eq 1>six (6)&dagger;&dagger;<cfelse>four (4)&dagger;</cfif> references.  References can <strong>not</strong> be relatives and must have visited you <strong>in side</strong> your home. 
<br />
<cfquery name="qreferences" datasource="#APPLICATION.DSN.Source#">
select *
from smg_family_references
where referencefor = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="2" class="border">
   <tr>
   	<th>Name</th><th>Address</th><th>City</th><th>State</th><th>Zip</th><th>Phone</th><th></th>
    </tr>
   <cfif qreferences.recordcount eq 0>
    <tr>
    	<td colspan=7>Currently, no references are on file for you</td>
    </tr>
    <cfelse>
    <cfloop query="qreferences">
    <tr <cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
    	<td><h3><p class="p_uppercase">#firstname# #lastname#</h3></td>
        <td><h3><p class="p_uppercase">#address# #address2#</h3></td>
        <td><h3>#city#</h3></td>
        <td><h3>#state#</h3></td>
        <td><h3>#zip#</h3></td>
        <td><h3>#phone#</h3></td>
        <td><a href="?section=references&edit=#refid#"><img src="/images/buttons/pencilBlue23x29.png" border="0" height=20/></a> <a href="?section=references&delete=#refid#" onClick="return confirm('Are you sure you want to delete this reference?')"> <img src="/images/buttons/delete23x28.png" height=20 border="0"/></a></td>
    </tr>
    </cfloop>
    </cfif>
   </table>
	
</cfoutput>

<h2>Add References</h2>
<cfoutput>
<cfif vTotalFamilyMembers eq 1>
	<cfset refs = 6>
<cfelse>
	<cfset refs = 4>
</cfif>
<cfset remainingref = #refs# - #qreferences.recordcount#>

<cfif remainingref lte 0>
No additional references are required.
<cfelse>
#remainingref# additional references are required based on the information on your application.
</cfif>
<div align="center">
  <span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields </span>
</div>

<form method="post" action="?section=references<cfif isDefined('URL.edit')>&edit=#URL.edit#</cfif>">

<input type="hidden" name="insert" />
	  <table width="100%" cellspacing="0" cellpadding="2" class="border">
    <tr bgcolor="##deeaf3">
        <td class="label"><h3> First Name<span class="redtext">*</span></h3> </td>
        <td colspan=3>
            <input type="text" name="firstname" value="#FORM.firstname#" size="20" maxlength="150">
        </td>
      </tr>
    <tr>
        <td class="label"><h3> Last Name<span class="redtext">*</span></h3> </td>
        <td colspan=3>
            <input type="text" name="lastname" value="#FORM.lastname#" size="20" maxlength="150" >
        </td>
      </tr>
    <tr bgcolor="##deeaf3">
        <td ><h3>Phone <span class="redtext">*</span></h3></td>
        <td colspan=3><input type="text" name="phone" value="#FORM.phone#" size="14" maxlength="14" mask="(999) 999-9999"></td>
    </tr>
     <tr>
        <td class="label">
        
        <h3>Address </h3></td>
        <td colspan=2>
        	<input type="text" name="address" value="#FORM.address#" size="40" maxlength="150" >
            <font size="1">NO PO BOXES 
        </td>
        <td rowspan=2> </td>
    </tr>
    <tr>
        <td></td>
        <td colspan=3><input type="text" name="address2" value="#FORM.address2#" size="40" maxlength="150"></td>
    </tr>
    <tr bgcolor="##deeaf3" >			 
        <td class="label"><h3>City</h3></td>
        <td colspan=3><input type="text" name="city" value="#FORM.city#" size="20" maxlength="150" ></td>
    </tr>
    <tr>
        <td class="label"><h3>State </h3></td>
        <td>
            <cfquery name="get_states" datasource="#APPLICATION.DSN.Source#">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<select NAME="state" query="get_states">
			      	<option></option>
				<cfloop query="get_states">
                	<option value="#state#" <cfif state eq #FORM.state#>selected</cfif>>#statename#</option>
                </cfloop>
            </select>
        </td>
        <td class="zip"><h3>Zip</h3> </td>
        <td><input type="text" name="zip" value="#FORM.zip#" size="5" maxlength="5"></td>
    </tr>
	
    <tr bgcolor="##deeaf3">
        <td ><h3>Email</h3></td>
        <td colspan=3><input type="text" name="email" value="#FORM.email#" size="30" maxlength="200" ></td>
    </tr>
	</table>
<table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
    <tr>
        <td align="right"><cfif isDefined('URL.edit')><a href="?section=references"><img src="/images/buttons/goBack_44.png" border="0"/></a> <input name="Submit" type="image" src="/images/buttons/update_44.png" border="0"><cfelse><input name="Submit" type="image" src="/images/buttons/addRef.png" border="0"></cfif>
        <br />
          <a onclick="ShowHide(); return false;" href="##">
         I am finished entering references.</a>
<div id="slidingDiv" display:"none">
        <a href="index.cfm?section=checkList"><img src="/images/buttons/Next.png" border="0" /></a>	</div>	
        
        
       </td>
    </tr>
</table>



	
</form>
</cfoutput>