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
    <cfparam name="FORM.race" default="">
    <cfparam name="FORM.ethnicityOther" default="">

    <cfquery name="qGetConfidentialInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            income, 
            publicAssitance, 
            publicAssitanceExpl, 
            crime, 
            crimeExpl, 
            cps, 
            cpsExpl, 
            race, 
            ethnicityOther
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
			
			// race
			if ( NOT LEN(TRIM(FORM.race)) ) {
				SESSION.formErrors.Add("Please indicate the race of your household.");
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
                    cpsexpl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cpsexpl#">,
                    race = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.race#">,
                    ethnicityOther = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ethnicityOther#">
                WHERE
                	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            </cfquery>

            <cflocation url="index.cfm?section=references" addtoken="no">
        
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
			FORM.race = qGetConfidentialInfo.race;
			FORM.ethnicityOther = qGetConfidentialInfo.ethnicityOther;
		</cfscript>		
    
    </cfif>        
	
</cfsilent>

<cfoutput>

    <h2>Confidential Information</h2>
	
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
        
	<p>    
        The following information is required by the Department of State. 
        This information will be kept confidential by the exchange company and will not be distributed to the student, the natural family, or the International Agent. <sup>&dagger;</sup>
    </p>

    <cfform method="post" action="index.cfm?section=confidentialData">
        <input type="hidden" name="submitted" value="1" />
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label" valign="top"><h3>Is any member of your household receiving<br> any kind of public assistance?<span class="required">*</span><sup>&dagger;&dagger;</sup></h3></td>
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
                	Please explain<span class="required">*</span><br />
            		<textarea name="publicAssitanceExpl" cols="50" rows="4">#FORM.publicAssitanceExpl#</textarea>
                </td>
            </tr>
            <tr>
                <td class="label" valign="top"><h3>Average annual income range<span class="required">*</span><sup>&dagger;&dagger;</sup></h3></td>
                <td>
                    <cfinput checked="#FORM.income EQ 25#" type="radio" name="income" id="income25" value="25" /><label for="income25">Less then $25,000</label><br />
                    <cfinput checked="#FORM.income EQ 35#" type="radio" name="income" id="income35" value="35" /><label for="income35">$25,000 - $35,000</label><br />
                    <cfinput checked="#FORM.income EQ 45#" type="radio" name="income" id="income45" value="45" /><label for="income45">$35,001 - $45,000</label><br />
                    <cfinput checked="#FORM.income EQ 55#" type="radio" name="income" id="income55" value="55" /><label for="income55">$45,001 - $55,000</label><br />
                    <cfinput checked="#FORM.income EQ 65#" type="radio" name="income" id="income65" value="65" /><label for="income65">$55,001 - $65,000</label><br />
                    <cfinput checked="#FORM.income EQ 75#" type="radio" name="income" id="income75" value="75" /><label for="income75">$65,001 - $75,000</label><br />
                    <cfinput checked="#FORM.income EQ 85#" type="radio" name="income" id="income85" value="85" /><label for="income85">$75,000 and above</label><br />
                </td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label" valign="top"><h3>Has any member of your household ever been charged<Br> with a crime?<span class="required">*</span></h3></td>
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
                    Please explain<span class="required">*</span><br />
                    <textarea name="crimeExpl" cols="50" rows="4">#FORM.crimeExpl#</textarea>
                </td>
            </tr>
            <tr>
                <td class="label" valign="top"><h3>Have you had any contact with Child Protective Services<br /> Agency in the past? <span class="required">*</span></h3></td>
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
                	Please explain<span class="required">*</span><br />
                    <textarea name="cpsExpl" cols="50" rows="4">#FORM.cpsExpl#</textarea>
                </td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td class="label" valign="top" colspan="2"><h3>What is the families race? (check as many boxes as needed)<span class="required">*</span></h3></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td colspan="2">
                
                    <table width="100%">
                        <tr>
                            <td width="10px"><input name="race" id="raceAfrican" value="African American" type="checkbox" <cfif ListFind(FORM.race, 'African American')>checked</cfif> /></td>
                            <td><label for="raceAfrican">African American</label></td>
                            <td width="10px"><input name="race" id="raceHispanic" value="Hispanic" type="checkbox" <cfif ListFind(FORM.race, 'Hispanic')>checked</cfif> /></td>
                            <td><label for="raceHispanic">Hispanic</label></td>
                        </tr>
                        <tr>
                           <td><input name="race" id="raceAmerican" value="American Indian or Alaska Native" type="checkbox" <cfif ListFind(FORM.race, 'American Indian or Alaska Native')>checked</cfif> /></td>
                            <td><label for="raceAmerican">American Indian / Alaska Native</label></td>
                            <td><input name="race" id="raceKorean" value="Korean" type="checkbox" <cfif ListFind(FORM.race, 'Korean')>checked</cfif> /></td>
                            <td><label for="raceKorean">Korean</label></td>
                         </tr>
                        <tr>
                            <td><input name="race" id="raceAsian" value="Asian Indian" type="checkbox" <cfif ListFind(FORM.race, 'Asian Indian')>checked</cfif> /></td>
                            <td><label for="raceAsian">Asian Indian</label></td>
                            <td><input name="race" id="raceHawaiian" value="Native Hawaiian" type="checkbox" <cfif ListFind(FORM.race, 'Native Hawaiian')>checked</cfif> /></td>
                            <td><label for="raceHawaiian">Native Hawaiian</label></td>
                        </tr>
                        <tr>
                            <td><input name="race" id="raceChinese" value="Chinese" type="checkbox" <cfif ListFind(FORM.race, 'Chinese')>checked</cfif> /></td>
                            <td><label for="raceChinese">Chinese</label></td>
                            <td><input name="race" id="raceSamoan" value="Samoan" type="checkbox" <cfif ListFind(FORM.race, 'Samoan')>checked</cfif> /></td>
                            <td><label for="raceSamoan">Samoan</label></td>
                        </tr>
                        <tr>
                            <td><input name="race" id="raceFilipino" value="Filipino" type="checkbox" <cfif ListFind(FORM.race, 'Filipino')>checked</cfif> /></td>
                            <td><label for="raceFilipino">Filipino</label></td>
                            <td><input name="race" id="raceVietnamese" value="Vietnamese" type="checkbox" <cfif ListFind(FORM.race, 'Vietnamese')>checked</cfif> /></td>
                            <td><label for="raceVietnamese">Vietnamese</label></td>                        
                        </tr>
                        <tr>
                            <td><input name="race" id="raceGuamanian" value="Guamanian or Chamorro" type="checkbox" <cfif ListFind(FORM.race, 'Guamanian or Chamorro')>checked</cfif> /></td>
                            <td><label for="raceGuamanian">Guamanian or Chamorro</label></td>
                            <td><input name="race" id="raceWhite" value="White" type="checkbox" <cfif ListFind(FORM.race, 'White')>checked</cfif> /></td>
                            <td><label for="raceWhite">White</label></td>
                        </tr>
                        <tr>
                            <td colspan="4"><label for="ethnicityOther">Other:</label><input type="text" size=30 name="ethnicityOther" id="ethnicityOther" value="#FORM.ethnicityOther#" /></td>
                        </tr>
                    </table>
            
                </td>
            </tr>        
        </table>
        
        <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
            <tr>
            	<td align="right"><input name="Submit" type="image" src="images/buttons/Next.png" border="0"></td>
            </tr>
        </table>
        
        <h3><u>Department Of State Regulations</u></h3>
        
        <p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(2)</a></strong><br />
        <em>"The income data collected will be used solely for the purposes of determining that the basic needs of the exchange student can be met, including three quality meals and transportation to and from school activities."</em></p>
        
        <p>&dagger;&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(6)</a></strong><br />
        <em>Ensure that the host family has adequate financial resources to undertake hosting obligations and is not receiving needs-based government subsidies for food or housing;</em>
     
	</cfform>
    
</cfoutput>