<cfparam name="form.church_activity" default="-1">
<cfparam name="form.stu_trans" default="">
<cfparam name="form.stu_Attend" default="">
<cfparam name="form.religious_participation" default="">


<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<cfquery name="qGetHostInfo" datasource="MySQL">
select religion, religious_participation, churchfam,  churchtrans
from smg_hosts
where hostid = #client.hostid#
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
			 if (( FORM.religious_affiliation gt 0) AND (FORM.church_activity EQ -1))  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated a religious belief but have not answered the question: How often do you go to your religious establishment?");
			 }
			 if ((( FORM.church_activity EQ 4) OR (FORM.church_activity EQ 3) OR (FORM.church_activity EQ 2)) and ( not LEN(TRIM(FORM.stu_Attend)) ) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that you go attend religious services, but did not answer: Would you expect your exchange student to attend services with your family?");
			 }
		
	 // Student Transportation
			 if  ( not LEN(TRIM(FORM.stu_trans)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you will provide transportation to the students religious services if they are different from your own.");
			 }
			 
        </cfscript>
        
        <cfif NOT SESSION.formErrors.length()>
         <cfquery datasource="mysql">
        update smg_hosts
            set religious_participation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.church_Activity#">,
               <cfif isDefined('form.stu_Attend')> churchfam =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stu_attend#">, </cfif>
                churchtrans = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.stu_trans#">,
                churchfam = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.stu_attend#">,
                religion =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.religious_affiliation#">
            where hostid = #client.hostid#
        </cfquery>
			 <cfif form.church_activity gt 1>
				 <Cflocation url="index.cfm?page=churchInfo" addtoken="no">
             <cfelse>
                  <cflocation url="index.cfm?page=communityProfile" addtoken="no">
             </cfif>
   	    </cfif>
<!----If they are not procesing info, set to db answers---->
<cfelse>

         <cfscript>
			 // Set FORM Values   
			FORM.church_activity = qGetHostInfo.religious_participation;
			FORM.stu_trans = qGetHostInfo.churchtrans;
			FORM.stu_Attend = qGetHostInfo.churchfam;
			FORM.religious_affiliation =  qGetHostInfo.religion;
		</cfscript>

</cfif>



<cfquery name="religion" datasource="MySQL">
select *
from smg_religions
</cfquery>







<cfform action="index.cfm?page=religionPref">

<cfinput type="hidden" name="process"> 
<h2>Religious Preference</h2>
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
What religions beliefs do you follow?<span class="redtext">*</span>
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
<cfif form.religious_Affiliation eq 0 or form.religious_affiliation eq 00>
<div id="slidingDiv" display:"none">
</cfif>

<h2>Religious Attendance</h2>
How often do you go to your religious establishment?<span class="redtext">*</span>
<table width=100% cellspacing=0 cellpadding=2 class="border">

    <tr bgcolor="#deeaf3">
    	<td colspan=2><cfinput type="radio"
         onclick="document.getElementById('showname').style.display='table-row';"
         name="church_Activity" 
         checked="#form.religious_participation is 'Active'#"
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
        >No Interest
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
 <cfif form.religious_Affiliation eq 0 or form.religious_affiliation eq 00>
</div>    
</cfif>
<h2>Transportation</h2>
<table width=100% cellspacing=0 cellpadding=2 class="border">

      <tr bgcolor="#deeaf3">
    	<td>Would you provide transportation to the student's religious services<Br /> if they are different from your own?<span class="redtext">*</span> </td>
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
	

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
</cfform>


