
<cfparam name="form.churchwithfam" default="0">
<cfparam name="form.religious_part" default="0">
<cfparam name="form.trans" default="0">
<cfparam name="form.smoke" default="0">
<cfparam name="form.houserules_smoking" default=''>
<cfparam name="form.houserules_curfewweeknights" default=''>
<cfparam name="form.houserules_curfewweekends" default=''>
<cfparam name="form.houserules_church" default=''>
<cfparam name="form.houserules_chores" default=''>
<cfparam name="form.houserules_other" default=''>
<cfparam name="form.houserules_inet" default=''>
<cfparam name="form.houserules_expenses" default=''>
<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<cfquery name="select_prev_rules" datasource="MySQL">
select smokeconditions, religious_participation, churchtrans, churchfam, houserules_inet, houserules_expenses, acceptsmoking,houserules_smoke,houserules_curfewweeknights,houserules_curfewweekends,houserules_chores,houserules_church,
houserules_other
from smg_hosts
where hostid =<cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
</cfquery>


<cfif isDefined('form.process')>

    
             <cfscript>
            // Data Validation
					
        	
			// Address
            if ( NOT LEN(TRIM(FORM.houserules_curfewweeknights)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please specify the curfew for school nights.");
            }	
			
			// City
            if ( NOT LEN(TRIM(FORM.houserules_curfewweekends)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please specify the curfew for weekends.");
            }			
        	
        	// State
            if ( NOT LEN(TRIM(FORM.houserules_chores)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please list the chores that the student we responsible for.");
            }		
			
			// Zip
            if ( NOT LEN(TRIM(FORM.houserules_expenses)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate any expenses you expect the student to be responsible for.");
            }			
        	// Zip
            if ( NOT LEN(TRIM(FORM.houserules_inet)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate any internet, computer or email usage restrictions you have.");
            }			
        	

        	
			 
        </cfscript>
		<cfif NOT SESSION.formErrors.length()>
            <cfquery name="insert_rules" datasource="MySQL">
            update smg_hosts 
                set
                    houserules_curfewweeknights = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.houserules_curfewweeknights#">,
                    houserules_curfewweekends = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.houserules_curfewweekends#">,
                    houserules_chores = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.houserules_chores#">,
                    houserules_church = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.houserules_church#">,
                    houserules_other = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.houserules_other#">,
                    houserules_inet = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.houserules_inet#">,
                    houserules_expenses = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.houserules_expenses#">
                where
                    hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
            </cfquery>
    
            <cflocation url="index.cfm?page=familyAlbum">
        </cfif>
<cfelse>
<!----The first time the page is loaded, pass in current values, if they exist.---->
	 <cfscript>

			 // Set FORM Values   
			
			FORM.houserules_curfewweeknights = select_prev_rules.houserules_curfewweeknights;
			FORM.houserules_curfewweekends = select_prev_rules.houserules_curfewweekends;
			FORM.houserules_chores = select_prev_rules.houserules_chores;
			FORM.houserules_church = select_prev_rules.houserules_church;
			FORM.houserules_other = select_prev_rules.houserules_other;
			FORM.houserules_inet = select_prev_rules.houserules_inet;
			FORM.houserules_expenses = select_prev_rules.houserules_expenses;
		</cfscript>
</cfif>








<!---
<Cfif select_prev_rules.religious_participation is "active">
	<cfset religious_part = "We attend church more than two times a week and ">
<cfelseif select_prev_rules.religious_participation is "average">
	<cfset religious_part = "We attend church 1-2 times a week and ">
<cfelseif select_prev_rules.religious_participation is "little interest">
	<cfset religious_part = "We attend church occasionally and ">
<cfelseif select_prev_rules.religious_participation is "inactive">
	<cfset religious_part = "We never attend church and ">
<cfelseif select_prev_rules.religious_participation is "no interest">
	<cfset religious_part = "We have no interest in church attendance and ">
<cfelse>
	<cfset religious_part = "">
</cfif>
<cfif select_prev_rules.churchfam is "yes">
	<cfset churchwithfam = "we expect our student to attend with us">
<cfelseif select_prev_rules.churchfam is "no">
	<cfset churchwithfam = "we do not expect our student to attend with us">
<cfelse>
	<cfset churchwithfam = "">
</cfif>
<Cfif select_prev_rules.churchtrans is "yes">
	<cfset trans = " but we will transport the student to their church if they so desire.">
<cfelseif select_prev_rules.churchtrans is "no">
	<cfset trans = " but the student will be required to find their own transpotation if they want to go to their own church.">
</cfif>
<Cfif select_prev_rules.acceptsmoking is "no" and select_prev_rules.acceptsmoking is ''>
	<cfset smoke="We will not accept a student who smokes.">
<Cfelseif select_prev_rules.acceptsmoking is "no" and select_prev_rules.acceptsmoking is not  ''>
	<cfset smoke="We will not accept a student who smokes.">
<cfelseif select_prev_rules.acceptsmoking is "yes" and select_prev_rules.acceptsmoking is not ''>
	<cfset smoke="We will accept a student who smokes with the following exceptions," >
<cfelseif select_prev_rules.acceptsmoking is "yes" and select_prev_rules.acceptsmoking is ''>
	<cfset smoke="We will accept a student who smokes.">
<cfelse>
	<cfset smoke="">
</cfif>
---->


<cfform action="index.cfm?page=familyRules" method="post">
<input type="hidden" name="process" />
<cfoutput>
 <h2>Family Rules</h2>
 <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        List your household rules and personal expectations. It is very important
that your student be treated as a member of your family. We will share this information with
the student you select. <b>Exchange students MUST abide by all ISE rules and all local, state & federal laws, regardless of home rules.</b>
<br /><br />
  <table width=100% cellspacing=0 cellpadding=2 class="border">
  <!----
    <tr  bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Smoking<span class="redtext">*</span></h3></td>
        <td><textarea cols="50" rows="4" name="houserules_smoking" wrap="VIRTUAL"><cfif form.houserules_smoking is ''>#smoke# #select_prev_rules.smokeconditions#<cfelse>#form.houserules_smoking#</cfif> </textarea></td>
    </tr>
	---->
     <tr>
    	<td class="label" valign="top"><h3>Curfew on school nights</h3></td>
        <td><textarea cols="50" rows="4" name="houserules_curfewweeknights" wrap="VIRTUAL">#form.houserules_curfewweeknights#</textarea></td>
    </tr>   
     <tr  bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Curfew on weekends</h3></td>
        <td><textarea cols="50" rows="4" name="houserules_curfewweekends" wrap="VIRTUAL">#form.houserules_curfewweekends#</textarea></td>
    </tr> 
     <tr>
    	<td class="label" valign="top"><h3>Chores</h3></td>
        <td><textarea cols="50" rows="4" name="houserules_chores" wrap="VIRTUAL">#form.houserules_chores#</textarea></td>
    </tr> 
    <!----
     <tr  bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Religious Expectations<span class="redtext">*</span></h3> <i>include number of times/hours per week attendance will be expected</i></td>
        <td><textarea cols="50" rows="4" name="houserules_church" wrap="VIRTUAL"><cfif form.houserules_church is ''>#religious_part##churchwithfam##trans#<cfelse>#form.houserules_church#</cfif></textarea></td>
    </tr> 
    ---->
     <tr  bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Computer, Internet, and Email Usage</h3> </td>
        <td><textarea cols="50" rows="4" name="houserules_inet" wrap="VIRTUAL">#form.houserules_inet# </textarea></td>
    </tr> 
    <tr>
    	<td class="label" valign="top"><h3>Expenses</h3>
        <i>personal expenses expected to be paid by the students</i></td>
        <td><textarea cols="50" rows="4" name="houserules_expenses" wrap="VIRTUAL"  placeholder="toiletries, eating out with friends, etc">#form.houserules_expenses#</textarea></td>
    </tr> 
     <tr bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Other</h3> <i>please include any other rules or expectations you will have of your exchange student</i></td>
        <td><textarea cols="50" rows="4" name="houserules_other" wrap="VIRTUAL" placeholder="Homework, access to food, etc">#form.houserules_other#</textarea></td>
    </tr> 
</table>

</cfoutput> 

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
</cfform>
