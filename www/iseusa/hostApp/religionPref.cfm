<cfparam name="form.church_activity" default="-1">
<cfparam name="form.stu_trans" default="">
<cfparam name="form.stu_attend" default="">
<cfparam name="form.religious_participation" default="">

<cfparam name="form.informReligiousPref" default="3">
<cfparam name="form.hostingDiff" default="3">

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<cfquery name="qGetHostInfo" datasource="MySQL">
select religion, religious_participation, churchfam,  churchtrans, informReligiousPref, hostingDiff
from smg_hosts
where hostid =<cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
</cfquery>


<cfif isDefined('form.process')>
    	<cfif form.religious_affiliation eq 666>
        	<cfset form.church_activity = 'no'>
            <cfset form.stu_attend eq 0>
        </cfif>
      
        
         <!---Error Checking---->
         <cfscript>
            // Data Validation
			//REligions Belief
		
		
	 // Student Transportation
			 if  ( not LEN(TRIM(FORM.stu_trans)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you will provide transportation to the students religious services if they are different from your own.");
			 }
			  // Student Transportation
			 if  (FORM.informReligiousPref eq 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate will voluntarily provide your religious affiliation.");
			 }
			   // Student Transportation
			 if  ( FORM.hostingDiff eq 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if anyone in your household has difficulty with hosting a student whoms religious differs from your own.");
			 }
			 
        </cfscript>
        
        <cfif NOT SESSION.formErrors.length()>
       <cfif form.informReligiousPref is 'no'>
        <cfquery datasource="mysql">
        update smg_hosts
            set 
               informReligiousPref = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.informReligiousPref#">,
                churchtrans = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.stu_trans#">,
                hostingDiff = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.hostingDiff#">
            where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
        </cfquery>
       <cfelse>
         <cfquery datasource="mysql">
        update smg_hosts
            set religious_participation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.church_Activity#">,
               <!----<cfif isDefined('form.stu_Attend')> churchfam =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.stu_attend#">, </cfif>---->
                churchtrans = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.stu_trans#">,
                informReligiousPref = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.informReligiousPref#">,
                religion =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.religious_affiliation#">,
                hostingDiff = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.hostingDiff#">
            where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
        </cfquery>
			</cfif>
                  <cflocation url="index.cfm?page=familyRules" addtoken="no">
           
   	    </cfif>
<!----If they are not procesing info, set to db answers---->
<cfelse>

         <cfscript>
			 // Set FORM Values   
			FORM.church_activity = qGetHostInfo.religious_participation;
			FORM.stu_trans = qGetHostInfo.churchtrans;
			FORM.stu_Attend = qGetHostInfo.churchfam;
			FORM.religious_affiliation =  qGetHostInfo.religion;
			FORM.informReligiousPref = qGetHostInfo.informReligiousPref;
			FORM.hostingDiff = qGetHostInfo.hostingDiff;
		</cfscript>

</cfif>



<cfquery name="religion" datasource="MySQL">
select *
from smg_religions
</cfquery>







<cfform action="index.cfm?page=religionPref">

<cfinput type="hidden" name="process"> 
<h2>Religious Affiliation</h2>
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
<h2>Transportation</h2>
<table width=100% cellspacing=0 cellpadding=2 class="border">

      <tr bgcolor="#deeaf3">
    	<td width=500>Would you provide transportation to the student's religious services if they are different from your own?<span class="redtext">*</span> </td>
        <td> <label>
            <cfinput type="radio" name="stu_trans" value="yes" checked="#form.stu_trans eq 'yes'#"/>
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="stu_trans" value="no" checked="#form.stu_trans eq 'no'#"/>
            No
            </label>
		</td>
      </tr>
	</table>
    <br />
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<tr>
    	<td width=500>
 Are you willing to voluntarily inform your exchange student of your religious affiliation? 
 		</td>
       	<td> 
         <label>
            <cfinput type="radio" name="informReligiousPref" value="1"
            checked="#form.informReligiousPref eq 1#" onclick="document.getElementById('informReligiousPrefDiv').style.display='table-row';" 
            />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="informReligiousPref" value="0"
           checked="#form.informReligiousPref eq 0#" onclick="document.getElementById('informReligiousPrefDiv').style.display='none';" 
            />
            No
            </label></td>
</tr>
	<tr bgcolor="#deeaf3">
    	<td width=500>
Does any member of your household have difficulty hosting a student with different religious beliefts?
 		</td>
       	<td> 
         <label>
            <cfinput type="radio" name="hostingDiff" value="1"
            checked="#form.hostingDiff eq 1#"  
            />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="hostingDiff" value="0"
           checked="#form.hostingDiff eq 0#"  
            />
            No
            </label></td>
</tr>
	
</table>
<table width=100%>
	<tr id="informReligiousPrefDiv"  <Cfif form.informReligiousPref neq 1>style="display: none;"</cfif>>
    	<td>

<h2>Religious Preference</h2>

      
What is your religious affiliation?
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<tr bgcolor="#deeaf3">
    	<td>
 <select name="religious_affiliation" onChange="ShowHide();" >
			<option value="666" selected>Non-Religious
			<cfoutput query="religion">
			<cfif #form.religious_affiliation# is #religionid#><option value=#religionid# selected>#religionname#<cfelse><option value=#religionid#>#religionname#</cfif>
			</cfoutput>
			<option value=999999>Other</option>
			</select>
	</td>
   </tr>
</table>
<br />




<h2>Religious Attendance</h2>
How often do you go to your religious place of worship?
<table width=100% cellspacing=0 cellpadding=2 class="border">
  
  <tr bgcolor="#deeaf3">
    	<td colspan=2><cfinput type="radio"
         onclick="document.getElementById('showname').style.display='table-row';"
         name="church_Activity" 
         checked="#form.church_activity is 'Active'#"
         value="Active" 
         
        > Active (2+ times a week)</td>
    </tr>
    <tr >
    	<Td colspan=2>
		<cfinput type="radio" 
        name="church_Activity" 
        onclick="document.getElementById('showname').style.display='table-row';"
        value="Average" 
        checked="#form.church_activity is 'Average'#"
       >Average (1-2x a week) 
</td>
    </tr>
    <tr bgcolor="#deeaf3" >
    	<Td colspan=2>
		<cfinput type="radio" 
        onclick="document.getElementById('showname').style.display='table-row';"
        name="church_Activity" 
        value="LIttle Interest" 
        checked="#form.church_activity is 'Little Interest'#"
        >Little Interest (occasionally)
</td>
    </tr>
    <tr >
    	<Td colspan=2>
		<cfinput type="radio" 
        name="church_Activity" 
        value="Inactive" 
        onclick="document.getElementById('showname').style.display='none';"
        checked="#form.church_activity is 'Inactive'#"
        >Inactive (Never attend)
        </td>
    </tr>
    <tr bgcolor="#deeaf3" >
    	<Td colspan=2>
		<cfinput type="radio" 
        name="church_Activity" 
        onclick="document.getElementById('showname').style.display='none';"
        value="No Interest" 
        checked="#form.church_activity is 'No Interest'#"
        >Holidays
		</td>
    </tr>
        <tr  colspan=2 id="showname" <cfif form.church_Activity lte 1> style="display: none;"</cfif> >
    	<td>Would you expect your exchange student to attend services with your family?<span class="redtext">*</span> </td>
        <td> <label>
            <cfinput type="radio" name="stu_attend" value="yes" checked="#form.stu_Attend eq 'yes'#"
              />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="stu_attend" value="no" checked="#form.stu_Attend eq 'no'#"
             />
            No
            </label>
		</td>
      </tr>
 </Table>
	</td>
   </tr>
 </table>
  



<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>

<h3><u>Department Of State Regulations</u></h3>

<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?type=simple;c=ecfr;cc=ecfr;sid=406e4a7eed2230e1d0c7300cdaa991eb;idno=22;region=DIV1;q1=religious%20services;rgn=div5;view=text;node=22%3A1.0.1.7.36#22:1.0.1.7.36.8.1.1.6" target="_blank" class=external>CFR Title 22, Part 62, Family Activities</a></strong><br />
  Note: A host family may want the exchange visitor to attend one or more religious services or programs with the family. The exchange visitor cannot be required to do so, but may decide to experience this facet of U.S. culture at his or her discretion.</p>
</cfform>


