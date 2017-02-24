<!--- ------------------------------------------------------------------------- ----
	
	File:		familyRules.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Family Rules

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.houserules_curfewweeknights" default="">
    <cfparam name="FORM.houserules_curfewweekends" default="">
    <cfparam name="FORM.houserules_chores" default="">
    <cfparam name="FORM.houserules_inet" default="">
    <cfparam name="FORM.houserules_expenses" default="">
    <cfparam name="FORM.houserules_other" default="">
	  
    <!--- FORM Submitted --->    
	<cfif VAL(FORM.submitted)>
        
        <cfscript>
            // Data Validation
                  
            // Curfew School Nights
            if ( NOT LEN(TRIM(FORM.houserules_curfewweeknights)) ) {
				SESSION.formErrors.Add("Please specify the curfew for school nights.");
            }	
            
            // Curfew Weekends
            if ( NOT LEN(TRIM(FORM.houserules_curfewweekends)) ) {
				SESSION.formErrors.Add("Please specify the curfew for weekends.");
            }			
            
            // Chores
            if ( NOT LEN(TRIM(FORM.houserules_chores)) ) {
				SESSION.formErrors.Add("Please list the chores that the student we responsible for.");
            }		
			
            // Computer Usage
            if ( NOT LEN(TRIM(FORM.houserules_inet)) )  {
				SESSION.formErrors.Add("Please indicate any internet, computer or email usage restrictions you have.");
            }			
            
            // Expenses
            if ( NOT LEN(TRIM(FORM.houserules_expenses)) )  {
				SESSION.formErrors.Add("Please indicate any expenses you expect the student to be responsible for.");
            }	
        </cfscript>
        
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>
        
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                    smg_hosts 
                SET
                    houserules_curfewweeknights = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(FORM.houserules_curfewweeknights, 300)#">,
                    houserules_curfewweekends = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(FORM.houserules_curfewweekends, 300)#">,
                    houserules_chores = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.houserules_chores#">,
                    houserules_inet = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.houserules_inet#">,
                    houserules_expenses = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.houserules_expenses#">,
                    houserules_other = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.houserules_other#">
                WHERE
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            </cfquery>
    
			<cfscript>
				// Successfully Updated - Set navigation page
				Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
			</cfscript>				

        </cfif>
        
    <cfelse>
    
        <!----The first time the page is loaded, pass in current values, if they exist.---->
         <cfscript>
             // Set FORM Values   
            FORM.houserules_curfewweeknights = qGetHostFamilyInfo.houserules_curfewweeknights;
            FORM.houserules_curfewweekends = qGetHostFamilyInfo.houserules_curfewweekends;
            FORM.houserules_chores = qGetHostFamilyInfo.houserules_chores;
            FORM.houserules_inet = qGetHostFamilyInfo.houserules_inet;
            FORM.houserules_expenses = qGetHostFamilyInfo.houserules_expenses;
			FORM.houserules_other = qGetHostFamilyInfo.houserules_other;
        </cfscript>
        
    </cfif>

</cfsilent>

<cfoutput>
    
    <h2>Family Rules</h2>
    
    <!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />

    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
    
    List your household rules and personal expectations. It is very important that your student be treated as a member of your family. 
    We will share this information with the student you select. 
    <b>Exchange students MUST abide by all #APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='shortName')# rules and all local, state & federal laws, regardless of home rules.</b>
    <br /><br />
    
    <span class="required">* Required fields</span>

    <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input type="hidden" name="submitted" value="1" />
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr>
                <td class="label" valign="top"><h3>Curfew on school nights <span class="required">*</span></h3></td>
                <td><textarea cols="50" rows="4" name="houserules_curfewweeknights">#Replace(FORM.houserules_curfewweeknights,"<br>","#chr(10)#","all")# </textarea></td>
            </tr>   
            <tr  bgcolor="##deeaf3">
                <td class="label" valign="top"><h3>Curfew on weekends <span class="required">*</span></h3></td>
                <td><textarea cols="50" rows="4" name="houserules_curfewweekends">#Replace(FORM.houserules_curfewweekends,"<br>","#chr(10)#","all")#</textarea></td>
            </tr> 
            <tr>
                <td class="label" valign="top"><h3>Chores <span class="required">*</span></h3></td>
                <td><textarea cols="50" rows="4" name="houserules_chores">#Replace(FORM.houserules_chores,"<br>","#chr(10)#","all")# </textarea></td>
            </tr> 
            <tr  bgcolor="##deeaf3">
                <td class="label" valign="top"><h3>Computer, Internet, and Email Usage <span class="required">*</span></h3> </td>
                <td><textarea cols="50" rows="4" name="houserules_inet">#Replace(FORM.houserules_inet,"<br>","#chr(10)#","all")# </textarea></td>
            </tr> 
            <tr>
                <td class="label" valign="top">
                	<h3>Expenses <span class="required">*</span></h3>
                	<i>personal expenses expected to be paid by the students</i>
                </td>
                <td><textarea cols="50" rows="4" name="houserules_expenses"  placeholder="toiletries, eating out with friends, etc">#Replace(FORM.houserules_expenses,"<br>","#chr(10)#","all")# </textarea></td>
            </tr> 
            <tr bgcolor="##deeaf3">
                <td class="label" valign="top"><h3>Other</h3> <i>please include any other rules or expectations you will have of your exchange student</i></td>
                <td><textarea cols="50" rows="4" name="houserules_other" placeholder="Homework, access to food, etc"> #Replace(FORM.houserules_other,"<br>","#chr(10)#","all")#</textarea></td>
            </tr> 
        </table>

        <!--- Check if FORM submission is allowed --->
        <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
            <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                <tr>
                    <td align="right"><input name="Submit" type="image" src="images/buttons/Next.png" border="0"></td>
                </tr>
            </table>
		</cfif>
                
    </form>

</cfoutput>