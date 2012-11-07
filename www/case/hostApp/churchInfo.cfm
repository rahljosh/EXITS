<cfparam name="form.church_name" default="">
<cfparam name="form.address" default="">
<cfparam name="form.city" default="">
<cfparam name="form.zip" default="">
<cfparam name="form.phone" default="">
<cfparam name="form.pastor" default="">


<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	




<cfif isDefined('form.process')>
	<cfif form.exist_church is 0>
    	<cfquery name="checkChurch" datasource="mysql">
        select churchid 
        from smg_hosts
        where hostid = #client.hostid#
        </cfquery>
        <Cfif checkChurch.churchid eq 0>
            <Cfquery datasource="mysql">
            insert into churches (churchname, address, address2, city, state, zip, phone, pastor, religionaffiliation)
                        values(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.church_name#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#" null="#yesNoFormat(trim(form.address2) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pastor#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.process#">)
            </cfquery>
            <Cfquery name="churchID" datasource="mysql">
            select max(churchid) as churchid 
            from churches
            </cfquery>
            <cfquery datasource="mysql">
            update smg_hosts set churchid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#churchid.churchid#">
            where hostid = #client.hostid#
            </cfquery>
        <cfelse>
        	 <Cfquery datasource="mysql">
            update churches 
            	set churchname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.church_name#">,
                	address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#" null="#yesNoFormat(trim(form.address2) EQ '')#">,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                    state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
                    zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
                    pastor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pastor#">
                where churchid = #checkchurch.churchid#
            </cfquery>
        	<cfset churchid.churchid = #checkchurch.churchid#>
        </Cfif>
        
           <!---Error Checking---->
         <cfscript>
            // Data Validation
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.church_name)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the name of your religious institution.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(FORM.address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the address.");
            }	
			
			// City
            if ( NOT LEN(TRIM(FORM.city)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the city.");
            }			
        	
        	// State
            if ( NOT LEN(TRIM(FORM.state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please select the state");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(FORM.zip)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a zip code.");
            }			
        	
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.pastor)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the religious leaders name.");
            }
			
			// Family Last Name
            if ( NOT LEN(TRIM(FORM.phone)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the phone number of your religious institution.");
            }	
        	
        	
			 
        </cfscript>
    <cfelse>
        <cfquery datasource="mysql">
        update smg_hosts set churchid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#form.exist_church#">
        where hostid = #client.hostid#
        </cfquery>
    </cfif>
    
 
    <cfif NOT SESSION.formErrors.length()>
        <cflocation url="index.cfm?page=communityProfile">
    
	</cfif>
</cfif>

<!----Conditional Things---->
	<cfform method="post" action="index.cfm?page=churchInfo"> 
	<cfoutput>
	
	<!----Querys for needed info---->

	<cfquery name="local" datasource="MySQL">
	select city,state,zip,religion,religious_participation, churchfam, churchtrans
	from smg_hosts
	where hostid = #client.hostid#
	</cfquery>
    
	<cfquery name="churches" datasource="MySQL">
	select *
	from churches
	where (religionaffiliation= #local.religion#) and (city = "#local.city#") and (state = "#local.state#")
	</cfquery>
	
    <cfquery name="church_name" datasource="MySQL">
	select religionname
	from smg_religions
	where religionid = #local.religion#
	</cfquery>
	<cfquery name="host_church" datasource="MySQL">
	select smg_hosts.churchid, churches.churchid, churches.churchname, churches.address, churches.address2,churches.city, churches.state,churches.zip, churches.pastor,churches.phone
	from smg_hosts, churches
	where smg_hosts.hostid = #client.hostid# and churches.churchid = smg_hosts.churchid
	</cfquery>
	
	<input type="hidden" name="religion" value="#local.religion#">
	<input type="hidden" name="church_activity" value="#local.religious_participation#">
	

	<!----Webpage Output---->
	

	

<h2>Religious Information</h2>
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
		<cfif churches.recordcount is 0>
		
	
			<p>Currently, there are no #church_name.religionname# places of worship in our system from #local.city# #local.state#. Please add yours below.</p>
			<input type="hidden" name="exist_church" value = 0>
		
		<cfelse>
		
			
			<p>The following #church_name.religionname# religious institutions in #local.city# #local.state# are in our system.  If yours is in the list, please select it. </p>
			
			<table width=100% cellspacing=0 cellpadding=2 class="border">
			<tr bgcolor="##deeaf3">
			<td class="label"><h3>Religious Institution</h3></td><td><select name="exist_church">
						<option value=0></option>
						<cfloop query="churches">
						<cfif host_church.churchname is #churchname#><option value=#churchid# selected>#churchname# - Pastor: #pastor#<cfelse><option value=#churchid#>#churchname#</cfif>
						</cfloop>
						
						</select></span>
                        
            
			
			</td>
		</table>
        
		</cfif>
<cfif #host_church.recordcount# eq 0>
	<cfif churches.recordcount is not 0>
    <br />
    
    <a onclick="ShowHide(); return false;" href="##">+/- Our religious institution is not listed, we need to add it. </a>
    <div id="slidingDiv" display:"none">
    </cfif>
</cfif>
<h2>New Religious Institution</h2>
		<table width=100% cellspacing=0 cellpadding=2 class="border">
			<tr bgcolor="##deeaf3">
				
			<td class="label"><h3>Name of Religious Institution<span class="redtext">*</span></h3></td><td class="form_text" colspan=3><cfinput name="church_name" size=20 type="text" value="#host_church.churchname#"></span>
		</tr>
		<tr>
			<td class="label"><h3>Address<span class="redtext">*</span></h3></td><td class="form_text" colspan=3><cfinput name="address" size=20 type="text" value="#host_church.address#"></span>
		</tr>
		<tr bgcolor="##deeaf3">
			<td></td><td colspan=3 class="form_text"><cfinput name="address2" size=20 type="text" value="#host_church.address2#"></span>
		</tr>			 
		<tr>
			<td class="label"><h3>City<span class="redtext">*</span></h3> </td><td  colspan=3 class="form_text"><cfinput type="text" name="city" size="20" value="#host_church.city#">
		</tr>
		<tr bgcolor="##deeaf3">	
			<td class="label" > <h3>State<span class="redtext">*</span></h3> </td><td  class="form_text">
		
 <cfquery name="get_states" datasource="mysql">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<cfselect NAME="state" query="get_states" value="state" display="statename" selected="#host_church.state#" queryPosition="below">
				<option value=''></option>
			</cfselect>
	
	</td>
    
    <td class="zip"></td>

			</tr>
        <tr>
        	<td><h3>Zip<span class="redtext">*</span></h3></td><td   colspan=3 > <cfinput type="text" name="zip" size="20" value="#host_church.zip#"></td>
        </tr>
		<tr bgcolor="##deeaf3">
			<td class="label" ><h3>Religous Leaders Name<span class="redtext">*</span></h3></td><td class="form_text" colspan=3><cfinput name="pastor" size=20 type="text" value="#host_church.pastor#"></span>
		</tr>
		<tr>
			<td class="label"><h3>Phone<span class="redtext">*</span></h3></td><td class="form_text" colspan=3><cfinput type="text" name="phone" message="Please  indicate the phone number." validateat="onSubmit" validate="telephone"  value="#host_church.phone#" size=20 mask="(999) 999-9999"   showautosuggestloadingicon="true"> (nnn) nnn-nnnn</span>
				</tr>
			</table>			
<cfif #host_church.recordcount# eq 0>
	<cfif churches.recordcount is not 0>
        </div>	
    </cfif>
</cfif>
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right">
        <input type="hidden" name="process" value="#local.religion#" />
        <input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
 </cfoutput>
	</cfform>



