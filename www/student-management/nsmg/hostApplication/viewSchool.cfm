<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<link href="../linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<link href="css/hostApp.css" rel="stylesheet" type="text/css" />
</head>

<body>
<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<cfinclude template="approveDenyInclude.cfm">

<Cfif isDefined('form.process')>
 <cfscript>
			// Name of School
            if ( NOT LEN(TRIM(FORM.schoolname)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the name of the school.");
            }			
        	
			// Address
            if ( NOT LEN(TRIM(FORM.address)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the address of the school.");
            }	
			
			// City
            if ( NOT LEN(TRIM(FORM.city)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the city the school is located in.");
            }			
        	
        	// State
            if ( NOT LEN(TRIM(FORM.state)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the state the school is located in.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(FORM.zip)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the school's zip code.");
            }	
				// type
            if (NOT LEN(TRIM(FORM.schoolType)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if this is a public or private school.");
            }
			if (NOT LEN(TRIM(FORM.schoolFees)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if this is a public or private school.");
            }
				if (NOT isNumeric(TRIM(FORM.numberofstudents)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate the number of students attending.  This should be a numeric answer.");
            }

        	// Works at School
            if ( form.schoolWorks EQ 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any member of your household works for the high school.");
            }		
			
			// Explanation of who works at school
            if ( (form.schoolWorks EQ 1) AND (NOT LEN(TRIM(FORM.schoolWorksExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that someone works with the school, but didn't explain.  Please provide details regarding the posistion.");
            }	
			//Been contacted by coach
			if ( form.schoolCoach EQ 3 ) {
               // Get all the missing items in a list
               SESSION.formErrors.Add("Please indicate if a coach has contacted you about hosting an exchange student.");
            }		
			
			// Coach explanation
            if ( (form.schoolCoach EQ 1) AND (NOT LEN(TRIM(FORM.schoolCoachExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that a coach contacted you, but didn't explain.  Please provide details regarding this contact.");
            }	
			
			
			// Other Transportation 
            if ( (form.schooltransportation is 'other') AND (NOT LEN(TRIM(FORM.other_desc))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You indicated that the student will get to school but Other, but didn't specify what that other method would be.");
            }	
     	   // Transportaion
            if (NOT LEN(TRIM(FORM.schoolTransportation)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate how the student will get to school.");
            }
			// Extra Curricular Transportaion
            if (NOT LEN(TRIM(FORM.extraCuricTrans)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you will provide transportation to extracuricular activities.");
            }
		
        </cfscript>
        
  <cfif NOT SESSION.formErrors.length()>       
	<cfquery name="updateSchool" datasource="#application.dsn#">
    	update smg_schools 	
        	set schoolname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.schoolname#">,
            	address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
			    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
				city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
				state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
				zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                principal =<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.principal#">,
				phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
				email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
				type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.schoolType#">,
				tuition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.schoolFees#">,
                numberofstudents = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.numberofstudents#">
    	where schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.process#">
    
    </cfquery>
	<!----Update the host info---->
    <cfquery name="insert_transportation" datasource="MySQL">
                update smg_hosts
                set 
                schoolWorks = "#form.schoolWorks#",
                schoolWorksExpl = "#form.schoolWorksExpl#",
                schoolCoach = "#form.schoolCoach#",
                schoolCoachExpl = "#form.schoolCoachExpl#",
                schooltransportation = "#form.schoolTransportation#",
                schooltransportationother = "#form.other_desc#",
                extraCuricTrans = "#form.extraCuricTrans#"
                where hostid = #client.hostid#
                </cfquery>
</cfif>

</Cfif>
<cfquery name="get_host_school" datasource="MySQL">
select smg_hosts.schoolid, smg_schools.schoolname, smg_schools.address, smg_schools.address2, smg_schools.principal,smg_schools.city, smg_schools.state, smg_schools.zip, smg_schools.phone, smg_schools.email, smg_schools.tuition, smg_schools.type, smg_schools.numberofstudents
from smg_hosts 
left join smg_schools on smg_schools.schoolid = smg_hosts.schoolid
where smg_hosts.hostid = #client.hostid#
</cfquery>
<cfquery name="qGetHostInfo" datasource="MySQL">
select address, city, state, zip, schoolWorks, schoolWorksExpl, schoolCoach, schoolCoachExpl, schooltransportation, schooltransportationother,extraCuricTrans, schoolid
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<cfquery name="localinfo" datasource="MySQL">
	select city,state,zip
	from smg_hosts
	where hostid = #client.hostid#
</cfquery>
<cfquery name="hostKids" datasource="MySQL">
select *
from smg_host_children
where hostid = #client.hostid#
</cfquery>
       <cfquery name="kidsAtSchool" datasource="#application.dsn#">
                select name
                from smg_host_children 
                where school = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_host_school.schoolid#">

</cfquery>

 <cfscript>
                // Get Host Mother CBC
                homeSchoolDist = APPCFC.udf.calculateAddressDistance(
                    origin='#qGetHostInfo.address# #qGetHostInfo.city#, #qGetHostInfo.state# #qGetHostInfo.zip#', 
                    destination='#get_host_school.address# #get_host_school.city#, #get_host_school.state# #get_host_school.zip#'
                );
            </cfscript>
<!----The first time the page is loaded, pass in current values, if they exist.---->
	 <cfscript>
			// Set FORM Values   
			FORM.schoolName = get_host_school.schoolName;
			FORM.address = get_host_school.address;
			FORM.address2 = get_host_school.address2;
			FORM.city = get_host_school.city;
			FORM.state = get_host_school.state;
			FORM.zip = get_host_school.zip;
			FORM.schoolWorks = qGetHostInfo.schoolWorks;
			FORM.schoolWorksExpl = qGetHostInfo.schoolWorksExpl;
			FORM.schoolCoach = qGetHostInfo.schoolCoach;
			FORM.schoolCoachExpl = qGetHostInfo.schoolCoachExpl;
			FORM.schooltransportation = qGetHostInfo.schooltransportation;
			FORM.schooltransportationother = qGetHostInfo.schooltransportationother;
			FORM.extraCuricTrans = qGetHostInfo.extraCuricTrans;
			FORM.school = qGetHostInfo.schoolid;
			FORM.principal = get_host_school.principal;
			FORM.phone = get_host_school.phone;
			FORM.email = get_host_school.email;
			FORM.schoolType = get_host_school.type;
			FORM.schoolFees = get_host_school.tuition;
			FORM.numberofstudents = get_host_school.numberofstudents;
	 </cfscript>
 <cfoutput>
<cfform method="post" action="viewSchool.cfm?itemID=#url.itemID#&usertype=#url.usertype#">
<input type="hidden" name="process" value=#get_host_school.schoolid# />
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        />
<h2>School Information</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border" align="center">
    <tr bgcolor="##deeaf3">
        <td class="label" width=100>High School<span class="redtext">*</span></td><td class="form_text" > 
        <input type="text" name="schoolname" size="20" value="#form.schoolname#"></span>
</tr>
		<tr>
			<td class="label">Address<span class="redtext">*</span></td><td  class="form_text"> 
           <input type="text" name="address" size="20" value="#form.address#" /></td>
		</tr>
		<tr>
			<td></td ><td   class="form_text"> 
            <input type="text" name="address2" size="20" value="#form.address2#" />
		</tr>
		<tr bgcolor="##deeaf3">			 
			<td class="label">City<span class="redtext">*</span> </td><td   class="form_text">
            <input type="text" name="city" size="20" value="#form.city#">
		</tr> 
		<tr >	
			<td class="label" > State<span class="redtext">*</span> </td><td width=10 class="form_Text">
			
   			 <cfquery name="get_states" datasource="mysql">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<cfselect NAME="state" query="get_states" value="state" display="statename" selected="#form.state#" queryPosition="below">
				<option></option>
			</cfselect>
			
	
	</td>
    </tr>
    <tr>
    <td class="zip" >Zip<span class="redtext">*</span> </td><td class="form_text">
    
    <input type="text" name="zip" size="5" value="#form.zip#"></td>

		</tr>
      
		<tr bgcolor="##deeaf3">
			<td class="label">Contact</td><td class="form_text" ><cfinput type="text" name="principal" size=20 value="#form.principal#"></span> 
		</tr>
		<tr>			
		<td class="label">Phone</td><td class="form_text" >
        <cfinput type="text" name="phone" size=20 value="#form.phone#"  mask='(999) 999-9999'></span>
		</tr>
		
		<tr  bgcolor="##deeaf3">
			<td class="label">Contact Email</td><td class="form_text" > 
            <cfinput name="email" size=20 type="text" value="#form.email#"></span>
		</tr>
        <Tr>
        	<td class="label">School Type</td>
            <td  ><input type="radio" value="public"  name="schoolType" <Cfif form.schooltype is 'public'>checked</cfif> /> Public &nbsp;&nbsp; <input name="schoolType" type="radio"  value="private"  <Cfif form.schooltype is 'private'>checked</cfif>   /> Private </td>
        </Tr>
        <Tr  bgcolor="##deeaf3">
        	<td class="label">School Fees</td><td  >
            
            <input type="text" name="schoolFees" size=25 value="#form.schoolFees#" /> </td>
        </Tr>
        <tr>
			<td class="label">Student Enrollment</td>
            <td class="form_text" >
            
             <cfinput name="numberofStudents" size=10 type="text"  value="#FORM.numberofstudents#"></span>
		</tr>
        <tr   bgcolor="##deeaf3">
			<td class="label">Distance from Hosts' Home</td><td class="form_text" > #homeSchoolDist# mile<cfif #homeSchoolDist# gt 1>s</cfif></span>
		</tr>
       
		
    	
		
			
	</tr>
</table>

 <h2>Relationships</h2>
 <table width=100% cellspacing=0 cellpadding=2 class="border" border=0>
    <tr bgcolor="##deeaf3">
        <td class="label">Does any member of your household work for the high<br /> school in a coaching/teaching/administrative capacity?<span class="redtext">*</span></td>
        <td>
            <label>
            <cfinput type="radio" name="schoolWorks" value="1"
            checked="#form.schoolWorks eq 1#" onclick="document.getElementById('showSchoolWorks').style.display='table-row';" 
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="schoolWorks" value="0"
           checked="#form.schoolWorks eq 0#" onclick="document.getElementById('showSchoolWorks').style.display='none';" 
           />
            No
            </label>
		 </td>
	</tr>
    <Tr>
	     <td align="left" colspan=2 id="showSchoolWorks" <cfif form.schoolWorks eq 0> style="display: none;"</cfif>><Br /><strong>Job Title & Duties<span class="redtext">*</span></strong><br><textarea cols="50" rows="4" name="schoolWorksExpl" wrap="VIRTUAL"><Cfoutput>#form.schoolWorksExpl#</cfoutput></textarea></td>
	</tr>   
    <tr>
        <td class="label">Has any member of your household had contact with a coach<Br /> regarding the hosting of an exchange student with a particular athletic ability?<span class="redtext">*</span></td>
        <td>
            <label>
            <cfinput type="radio" name="schoolCoach" value="1"
            checked="#form.schoolCoach eq 1#" onclick="document.getElementById('showCoachExpl').style.display='table-row';" 
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="schoolCoach" value="0"
           checked="#form.schoolCoach eq 0#" onclick="document.getElementById('showCoachExpl').style.display='none';" 
           />
            No
            </label>
		 </td>
	</tr>
    <Tr>
	     <td align="left" colspan=2 id="showCoachExpl" <cfif form.schoolCoach eq 0>style="display: none;"</cfif>><br /><strong>Please describe<span class="redtext">*</span></strong><br><textarea cols="50" rows="4" name="schoolCoachExpl" wrap="VIRTUAL"><Cfoutput>#form.schoolCoachExpl#</cfoutput></textarea></td>
	</tr>
    <Tr bgcolor="##deeaf3">
	     <td align="left" colspan=2 >Host siblings that also attend this school:<br>
          <tr>
            <td>
     
                <cfloop query="kidsAtSchool">
                <strong>#name#</strong><cfif kidsAtSchool.currentrow neq kidsAtSchool.recordcount>, </cfif>
                </cfloop>
                </td>
            </tr>
         </td>
	</tr>
</table>

  <h2>Transportation</h2>
  How will the student get to school?<span class="redtext">*</span>
<table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3">
        <td class="label"><cfinput type="radio" name="schoolTransportation"  value="School Bus"  checked="#form.schoolTransportation eq 'School Bus'#" >School Bus</td>
        <td class="form_text"><cfinput type="radio" name="schoolTransportation" value="Car" checked="#form.schoolTransportation eq 'Car'#">Car  </td>
        <td class="form_text"><cfinput type="radio" name="schoolTransportation" value="Walk" checked="#form.schoolTransportation eq 'Walk'#">Walk #homeSchoolDist# mile<cfif #homeSchoolDist# gt 1>s</cfif></td>
	</tr>
    <tr>
    	<td class="label"> <cfinput type="radio" name="schoolTransportation" value="Public Transportation" checked="#form.schoolTransportation eq 'Public Transportation'#">Public Transportation<br></td>
        <Td><cfinput type="radio" name="schoolTransportation" value="Other" checked="#form.schoolTransportation eq 'Other'#" >Other: <cfinput type="text" name="other_desc" size=10 value="#form.schoolTransportationother#"> </Td>
        <td> </td>
    </tr>
	<tr bgcolor="##deeaf3">
        <td class="label" colspan=2>Will you provide transportation for extracurricular activities?<span class="redtext">*</span></td>
        <td>
            <label>
            <cfinput type="radio" name="extraCuricTrans" value="1"
            checked="#form.extraCuricTrans eq 1#"
             />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="extraCuricTrans" value="0"
           checked="#form.extraCuricTrans eq 0#" 
           />
            No
            </label>
		 </td>
	</tr>
</table>


<br />

<hr width=80% align="center" height=1px />

<cfinclude template="updateInfoInclude.cfm">

</cfform>
<cfinclude template="approveDenyButtonsInclude.cfm">
</cfoutput> 
</body>
</html>