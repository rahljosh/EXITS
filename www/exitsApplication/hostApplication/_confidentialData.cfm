<!--- ------------------------------------------------------------------------- ----
	
	File:		communityProfile.cfm
	Author:		Marcus Melo
	Date:		November 19, 2012
	Desc:		Community Profile Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">    
    <cfparam name="FORM.publicAssitance" default="">
    <cfparam name="FORM.publicAssitanceExpl" default="">
    <cfparam name="FORM.crime" default="">
    <cfparam name="FORM.cps" default="">
    <cfparam name="FORM.cpsexpl" default="">
    <cfparam name="FORM.crimeExpl" default="">
    <cfparam name="FORM.income" default="">

    <cfquery name="qGetConfidentialInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            income, 
            publicAssitance, 
            publicAssitanceExpl, 
            crime, 
            crimeExpl, 
            cps, 
            cpsExpl 
        FROM 
            smg_hosts
        WHERE 
            hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#"> 
    </cfquery>
    
	<!--- FORM Submitted --->
	<cfif VAL(FORM.submitted)>
    
		<cfscript>
            // Data Validation
			
			// publicAssitance
			if ( NOT LEN(FORM.publicAssitance) ) {
				SESSION.formErrors.Add("Please indicate if any member of your household is receiving any public assistance.");
			}	
			
			// publicAssitance
			if ( FORM.publicAssitance EQ 1 AND NOT LEN(TRIM(FORM.publicAssitanceExpl)) ) {
				SESSION.formErrors.Add("You have indicated that you receive public assistance, but did not explain.");
			}	
			
			// Income
			if ( NOT LEN(FORM.income) ) {
				SESSION.formErrors.Add("Please indicate your household income.");
			}	
			
			// Crime Explanation
			if ( NOT LEN(FORM.crime) ) {
				SESSION.formErrors.Add("Please indicate if any member in your household has beeen charged with a crime.");
			}	
			
			// Crime Explanation
			if ( FORM.crime EQ 1 AND NOT LEN(TRIM(FORM.crimeExpl)) ) {
				SESSION.formErrors.Add("You have indicated that someone has been charged with a crime, but did not explain.");
			}	
			
			// Child Protective Services
			if ( NOT LEN(FORM.cps) ) {
				SESSION.formErrors.Add("Please indicate if you have been contacted by Child Protective Services.");
			}	
			
			// Child Protective Services
			if ( FORM.cps EQ 1 AND NOT LEN(TRIM(FORM.cpsExpl)) ) {
				SESSION.formErrors.Add("You have indicated that you have been contacted by Child Protective Services, but did not explain.");
			}	
		</cfscript>
        
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>

            <cfquery name="insert_rules" datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                	smg_hosts
               	SET
                    income = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.income#">,
                    publicAssitance = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.publicAssitance#">,
                    publicAssitanceExpl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.publicAssitanceExpl#">, 
                    crime = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.crime#">,
                    crimeExpl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.crimeExpl#">,
                    cps = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.cps#">,
                    cpsexpl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cpsexpl#">
                WHERE
                	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            </cfquery>

            <cfscript>
				// Successfully Updated - Set navigation page
				Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
			</cfscript>
        
        </cfif>

    <!--- FORM Not Submitted - Set Default Values --->
    <cfelse>
    
    	<cfscript>
			 // Set FORM Values   
			FORM.publicAssitance = qGetConfidentialInfo.publicAssitance;
			FORM.publicAssitanceExpl = qGetConfidentialInfo.publicAssitanceExpl;
			FORM.crime = qGetConfidentialInfo.crime;
			FORM.crimeExpl = qGetConfidentialInfo.crimeExpl;
			FORM.cps = qGetConfidentialInfo.cps;
			FORM.cpsexpl =  qGetConfidentialInfo.cpsexpl;
			FORM.income = qGetConfidentialInfo.income;
		</cfscript>		
    
    </cfif>        
	
</cfsilent>

<cfoutput>

    <h2>Confidential Data</h2>
	
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
        
    The following information is required by the Department of State. 
    This information will be kept confidential by the exchange company and will not be distributed to the student, the natural family, or the International Agent. <sup>&dagger;</sup> <br /><br />
    
    <span class="required">* Required fields</span>

    <cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input type="hidden" name="submitted" value="1" />
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label" valign="top"><h3>Is any member of your household receiving<br /> any kind of public assistance? <span class="required">*</span><sup>&dagger;&dagger;</sup></h3></td>
                <td>
                    <cfinput type="radio" name="publicAssitance" id="publicAssitanceYes" value="1" checked="#FORM.publicAssitance EQ 1#" onclick="document.getElementById('publicAssitanceExpl').style.display='table-row';" />
                    <label for="publicAssitanceYes">Yes</label>
               		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="publicAssitance" id="publicAssitanceNo" value="0" checked="#FORM.publicAssitance EQ 0#" onclick="document.getElementById('publicAssitanceExpl').style.display='none';" />
                	<label for="publicAssitanceNo">No</label>
                </td>
            </tr>
            <tr bgcolor="##deeaf3" id="publicAssitanceExpl" <cfif FORM.publicAssitance NEQ 1>class="displayNone"</cfif> >
                <td colspan="2">
                	Please explain <span class="required">*</span><br />
            		<textarea name="publicAssitanceExpl" cols="70" rows="4">#FORM.publicAssitanceExpl#</textarea>
                </td>
            </tr>
            <tr>
                <td class="label" valign="top"><h3>Average annual income range <span class="required">*</span><sup>&dagger;&dagger;</sup></h3></td>
                <td>
                    <cfinput checked="#FORM.income EQ 25#" type="radio" name="income" id="income25" value="25" /><label for="income25">Less than $25,000</label><br />
                    <cfinput checked="#FORM.income EQ 35#" type="radio" name="income" id="income35" value="35" /><label for="income35">$25,000 - $35,000</label><br />
                    <cfinput checked="#FORM.income EQ 45#" type="radio" name="income" id="income45" value="45" /><label for="income45">$35,001 - $45,000</label><br />
                    <cfinput checked="#FORM.income EQ 55#" type="radio" name="income" id="income55" value="55" /><label for="income55">$45,001 - $55,000</label><br />
                    <cfinput checked="#FORM.income EQ 65#" type="radio" name="income" id="income65" value="65" /><label for="income65">$55,001 - $65,000</label><br />
                    <cfinput checked="#FORM.income EQ 75#" type="radio" name="income" id="income75" value="75" /><label for="income75">$65,001 - $75,000</label><br />
                    <cfinput checked="#FORM.income EQ 85#" type="radio" name="income" id="income85" value="85" /><label for="income85">$75,000 and above</label><br />
                </td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label" valign="top"><h3>Has any member of your household ever been charged<br /> with a crime? <span class="required">*</span></h3></td>
                <td>   
                    <cfinput type="radio" name="crime" id="crimeYes" value="1" checked="#FORM.crime EQ 1#" onclick="document.getElementById('crimeExpl').style.display='table-row';" />
                    <label for="crimeYes">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="crime" id="crimeNo" value="0" checked="#FORM.crime EQ 0#" onclick="document.getElementById('crimeExpl').style.display='none';" />
                    <label for="crimeNo">No</label>
                </td>
            </tr>
            <tr bgcolor="##deeaf3" id="crimeExpl" <cfif FORM.crime NEQ 1>class="displayNone"</cfif>>
                <td colspan="2">
                    Please explain <span class="required">*</span><br />
                    <textarea name="crimeExpl" cols="70" rows="4">#FORM.crimeExpl#</textarea>
                </td>
            </tr>
            <tr>
                <td class="label" valign="top"><h3>Have you had any contact with Child Protective Services<br /> in the past, other than foster care or adoption? <span class="required">*</span></h3></td>
                <td>   
                    <cfinput type="radio" name="cps" id="cpsYes" value="1" checked="#FORM.cps EQ 1#" onclick="document.getElementById('cpsExpl').style.display='table-row';" />
                    <label for="cpsYes">Yes</label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfinput type="radio" name="cps" id="cpsNo" value="0" checked="#FORM.cps EQ 0#" onclick="document.getElementById('cpsExpl').style.display='none';" />
                    <label for="cpsNo">No</label>
                </td>
            </tr>
            <tr id="cpsExpl" <cfif FORM.cps NEQ 1>class="displayNone"</cfif>>
                <td colspan="2">
                	Please explain <span class="required">*</span><br />
                    <textarea name="cpsExpl" cols="70" rows="4">#FORM.cpsExpl#</textarea>
                </td>
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
                
        <h3><u>Department Of State Regulations</u></h3>
        
        <p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(2)</a></strong><br />
        <em>"The income data collected will be used solely for the purposes of determining that the basic needs of the exchange student can be met, including three quality meals and transportation to and from school activities."</em></p>
        
        <p>&dagger;&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(6)</a></strong><br />
        <em>Ensure that the host family has adequate financial resources to undertake hosting obligations and is not receiving needs-based government subsidies for food or housing;</em>
     
	</cfform>
    
</cfoutput>