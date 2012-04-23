
<cfparam name="url.childid" default="">
<Cfif isDefined('delete_child')>
	<cfquery datasource="mysql">
    delete from smg_host_children
    where childid = #url.delete_child#
    limit 1
    </cfquery>
    <cflocation url="index.cfm?page=familyMembers" addtoken="no">
</Cfif>
<cfif url.childid EQ "">
	<cfset new = true>
<cfelse>
	<cfquery name="verifyFam" datasource="mysql">
    select hostid
    from smg_host_children
    where childid = #url.childid#
    </cfquery>
    <cfif verifyFam.hostid neq client.hostid>
    	<h3>The child you are trying to edit is not assigned to your account.  </h3>
       	<cfabort>
    </cfif>
	<cfif not isNumeric(url.childid)>
        A numeric childid is required to edit a family member.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfif new>
	<cfparam name="url.hostid" default="#client.hostid#">
	<cfif not isNumeric(url.hostid)>
        a numeric hostid is required to add a new school date.
        <cfabort>
	</cfif>
</cfif>

<cfset field_list = 'name,sex,birthdate,membertype,liveathome,school'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>


	<!--- not defined if not selected. --->
    <cfparam name="form.sex" default="">
    <cfparam name="form.liveathome" default="">
    
	<cfif trim(form.name) EQ ''>
		<cfset errorMsg = "Please enter the Name.">
	<cfelseif trim(form.sex) EQ ''>
		<cfset errorMsg = "Please select the Sex.">
	<cfelseif not isDate(trim(form.birthdate))>
		<cfset errorMsg = "Please enter a valid Date of Birth.">
	<cfelseif trim(form.membertype) EQ ''>
		<cfset errorMsg = "Please enter the Relation.">
	<cfelseif trim(form.liveathome) EQ ''>
		<cfset errorMsg = "Please select Living at Home.">
    <cfelseif #Datediff('yyyy',form.birthdate, now())# gt 120>
		<cfset errorMSG = "The birthdate you entered, indicates the person is over 120 years old, please check the birthyear.">
    <cfelseif #Datediff('yyyy',form.birthdate, now())# lt 0>
		<cfset errorMSG = "The birthdate you entered is not valid.">
	<cfelse>
		<cfif new>
            <cfquery datasource="mysql">
                INSERT INTO smg_host_children (hostid, name, sex, birthdate, membertype, liveathome, school)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#url.hostid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sex#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.birthdate#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membertype#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.liveathome#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.school#">
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
			<cfquery datasource="mysql">
				UPDATE smg_host_children SET
                name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sex#">,
                birthdate = <cfqueryparam cfsqltype="cf_sql_date" value="#form.birthdate#">,
                membertype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membertype#">,
                liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.liveathome#">,
                school = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.school#">
				WHERE childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.childid#">
			</cfquery>
		</cfif>
        <cflocation url="index.cfm?page=familyMembers" addtoken="No">
	</cfif>

<!--- add --->
<cfelseif new>

	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = "">
	</cfloop>
        
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="mysql">
		SELECT *
		FROM smg_host_children
		WHERE childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.childid#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
    <!--- hostid is passed in the url for a new date, but set it for edit. --->
    <cfset url.hostid = get_record.hostid>

</cfif>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>






<h2>Current Family Members</h2>
<cfquery name="qFamilyMembers" datasource="mysql">
select *
from smg_host_children
where hostid = #client.hostid#
</cfquery>
<Cfif qFamilyMembers.recordcount eq 0>
	No Members added.
</cfif>
<cfoutput>
<table width=100% cellspacing=0 cellpadding=2 class="border">
   <Tr>
   	<Th>Name</Th><Th>Sex</Th><th>Date of Birth</th><Th>Relation</Th><th>At Home?</th><th>School</th><th></th>
    </Tr>
   <Cfif qFamilyMembers.recordcount eq 0>
    <tr>
    	<td>Currently, no other family members are indicated as living in your home.</td>
    </tr>
    <cfelse>
    <Cfloop query="qFamilyMembers">
    <tr <Cfif currentrow mod 2> bgcolor="##deeaf3"</cfif>>
    	<Td><h3><p class=p_uppercase>#name#</h3></Td>
        <td><h3><p class=p_uppercase>#sex#</h3></td>
        <Td><h3>#DateFormat(birthdate, 'mmm d, yyyy')#</h3></Td>
        <td><h3><p class=p_uppercase>#membertype#</h3></td>
        <td><h3><p class=p_uppercase>#liveathome#</h3></td>
        <td><h3><p class=p_uppercase>#school#</h3></td>
        <Td><a href="index.cfm?page=familyMembers&childid=#childid#">EDIT</a> <a href="index.cfm?page=familyMembers&delete_child=<cfoutput>#childid#&hostid=#url.hostid#</cfoutput>" onClick="return confirm('Are you sure you want to delete this Family Member?')"> DELETE</a></Td>
    </tr>
    </Cfloop>
    </cfif>
   </table>
	
</cfoutput>

<cfform action="index.cfm?page=familyMembers&childid=#url.childid#&hostid=#url.hostid#" method="post" preloader="no">
<input type="hidden" name="submitted" value="1">


<h2>Family Members </h2>
Please include all your children, whether they are living at home or not, and any other persons who live with you on a regular basis.<br /><span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>

<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr>
    	<td class="label"><h3>Name<span class="redtext">*</span></h3></td>
        <td><cfinput type="text" name="name" value="#form.name#" size="20" maxlength="50" required="yes" validate="noblanks" message="Please enter the Name."></td>
    </tr>
    <tr bgcolor="#deeaf3">
    	<td class="label"><h3>Sex <span class="redtext">*</span></h3></td>
        <td>
        	<cfinput type="radio" name="sex" value="Male" checked="#yesNoFormat(form.sex EQ 'Male')#" required="yes" message="Please select the Sex.">Male
            <cfinput type="radio" name="sex" value="Female" checked="#yesNoFormat(form.sex EQ 'Female')#">Female
        </td>
    </tr>
    <tr>
    	<td class="label"><h3>Date of Birth <span class="redtext">*</span></h3></td>
        <td><cfinput type="text" name="birthdate" value="#dateFormat(form.birthdate, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" required="yes" validate="date" message="Please enter a valid Date of Birth."> mm/dd/yyyy</td>
    </tr>
    <tr bgcolor="#deeaf3">
    	<td class="label"><h3>Relation<span class="redtext">*</span></h3> </td>
        <td><cfinput type="text" name="membertype" value="#form.membertype#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter the Relation."></td>
    </tr>
    <tr>
    	<td class="label"><h3>Living at Home <span class="redtext">*</span></h3></td>
        <td>
        	<cfinput type="radio" name="liveathome" value="Yes" checked="#yesNoFormat(form.liveathome EQ 'Yes')#" required="yes" message="Please select Living at Home.">Yes
            <cfinput type="radio" name="liveathome" value="No" checked="#yesNoFormat(form.liveathome EQ 'No')#">No
            
        </td>
        
    </tr>
        <tr bgcolor="#deeaf3">
    	<td class="label"><h3>Current School Attending (if applicable)</h3></td>
        <td>
        	<cfinput type="text" name="school" value="#form.school#" size="20" maxlength="150">
            
        </td>
        
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
    	<cfif not new>
			<td></td>
        </cfif>
		<td align="right">
		<Cfif url.childid is not ''><a href="?page=familyMembers">
        	<img src="../images/buttons/goBack_44.png" border=0/></a> 
            <input name="Submit" type="image" src="../images/buttons/update_44.png" border=0> 
        <cfelse>
        	<input name="Submit" type="image" src="../images/addMember.png" border=0>
        </Cfif> <br />
        
         <a onclick="ShowHide(); return false;" href="##">
         I am finished entering family members.</a>
<div id="slidingDiv" display:"none">
        <A href="index.cfm?page=familyQuestionInterupt"><img src="../images/buttons/next.png" border="0" /></A>	</div>	</td>
	</tr>
</table>

</cfform>



