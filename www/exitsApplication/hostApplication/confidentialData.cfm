<cfparam name="FORM.publicAssitance" default="3">
<cfparam name="FORM.crime" default="3">
<cfparam name="FORM.cps" default="3">
<cfparam name="FORM.cpsexpl" default="">
<cfparam name="FORM.crimeExpl" default="">
<cfparam name="FORM.income" default="0">
<cfparam name="FORM.publicAssitanceExpl" default="">
<cfparam name="FORM.race" default="">
<cfparam name="FORM.ethnicityOther" default="">

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

<cfquery name="demoInfo" datasource="#APPLICATION.DSN.Source#">
select income, publicAssitance, publicAssitanceExpl, crime, crimeExpl, cps, cpsExpl, race, ethnicityOther
from smg_hosts
where hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#"> 
</cfquery>

<cfif isDefined('FORM.process')>

  <cfscript>
           // Data Validation
			// Family Last Name
            if (FORM.publicAssitance EQ 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any member of your household is receiving any public assistance.");
            }	
			 if (NOT LEN(TRIM(FORM.race))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate the race of your household.");
            }
			// City
    		  if ( (FORM.publicAssitance EQ 1) AND (NOT LEN(TRIM(FORM.publicAssitanceExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that you receive public assistance, but did not explain.");
            }			
        	// State
            if ( FORM.income EQ 0 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate your household income.");
            }	
			// Address
            if ( FORM.crime EQ 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any member in your household has beeen charged with a crime.");
            }	
			
			// City
    		  if ( (FORM.crime EQ 1) AND (NOT LEN(TRIM(FORM.crimeExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that someone has been charged with a crime, but did not explain.");
            }		
			if ( FORM.cps EQ 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you have been contacted by Child Protectve Services.");
            }	
			
			// City
    		  if ( (FORM.cps EQ 1) AND (NOT LEN(TRIM(FORM.cpsExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that you have been contacted by Child Protective Services, but did not explain.");
            }	
        	
        		
	</cfscript>
         <cfif NOT SESSION.formErrors.length()>
         <cfquery name="insert_rules" datasource="#APPLICATION.DSN.Source#">
            update smg_hosts
                set
                    income = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.income#">,
                    publicAssitance = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.publicAssitance#">,
                    publicAssitanceExpl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.publicAssitanceExpl#">, 
                    crime = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.crime#">,
                    crimeExpl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.crimeExpl#">,
                    cps = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.cps#">,
                    cpsexpl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cpsexpl#">,
                    race = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.race#">,
                    ethnicityOther = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ethnicityOther#">
                where
                    hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
            </cfquery>
			<cflocation url="index.cfm?section=references" addtoken="no">

         </cfif>
<cfelse>

 		<cfscript>
			 // Set FORM Values   
			FORM.publicAssitance = demoInfo.publicAssitance;
			FORM.publicAssitanceExpl = demoInfo.publicAssitanceExpl;
			FORM.crime = demoInfo.crime;
			FORM.crimeExpl = demoInfo.crimeExpl;
			FORM.cps = demoInfo.cps;
			FORM.cpsexpl =  demoInfo.cpsexpl;
			FORM.income = demoInfo.income;
			FORM.race = demoInfo.race;
			FORM.ethnicityOther = demoInfo.ethnicityOther;
	
		</cfscript>

</cfif>

<h2>Confidential Information</h2>
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        
The following information is required by the Department of State. This information will be kept confidential by the exchange company and will not be distributed to the student, the natural family, or the International Agent. <sup>&dagger;</sup>

<cfoutput>
<cfform method="post" action="index.cfm?section=confidentialData">
<input type="hidden" name="process" />
  <table width="100%" cellspacing="0" cellpadding="2" class="border">
    <tr  bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Is any member of your household receiving<br> any kind of public assistance?<span class="redtext">*</span><sup>&dagger;&dagger;</sup></h3></td>
        <td>
        <label>
            <cfinput type="radio" name="publicAssitance" value="1"
            checked="#FORM.publicAssitance eq 1#" onclick="document.getElementById('publicAssitanceExpl').style.display='table-row';" 
            />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="publicAssitance" value="0"
           checked="#FORM.publicAssitance eq 0#" onclick="document.getElementById('publicAssitanceExpl').style.display='none';" 
            />
            No
            </label>
            </td>
        </td>
    </tr>
     <tr colspan=4 bgcolor="##deeaf3">
    	<Td id="publicAssitanceExpl"  <cfif FORM.publicAssitance eq 0>style="display: none;" bgcolor="##deeaf3"</cfif> >Please explain<span class="redtext">*</span><br />
        <textarea name="publicAssitanceExpl" cols="50" rows="4" >#FORM.publicAssitanceExpl#</textarea></td>
    <td></td>
    </tr>
    <tr>
    	<td class="label" valign="top"><h3>Average annual income range<span class="redtext">*</span><sup>&dagger;&dagger;</sup></h3></td>
        <td><cfinput checked="#FORM.income eq 25#" type="radio" name="income" value=25 />Less then $25,000<br />
        	<cfinput checked="#FORM.income eq 35#" type="radio" name="income" value=35 />$25,000 - $35,000<br />
      		<cfinput checked="#FORM.income eq 45#" type="radio" name="income" value=45 />$35,001 - $45,000<br />
            <cfinput checked="#FORM.income eq 55#" type="radio" name="income" value=55 />$45,001 - $55,000<br />
            <cfinput checked="#FORM.income eq 65#" type="radio" name="income" value=65 />$55,001 - $65,000<br />
            <cfinput checked="#FORM.income eq 75#" type="radio" name="income" value=75 />$65,001 - $75,000<br />
            <cfinput checked="#FORM.income eq 85#"type="radio" name="income" value=85 />$75,000 and above<br />
       </td>
    </tr>
    
    <tr bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Has any member of your household ever been charged<Br> with a crime?<span class="redtext">*</span></h3></td>
        <td>   <label>
            <cfinput type="radio" name="crime" value="1"
            checked="#FORM.crime eq 1#" onclick="document.getElementById('crimeExpl').style.display='table-row';" 
            />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="crime" value="0"
           checked="#FORM.crime eq 0#" onclick="document.getElementById('crimeExpl').style.display='none';" 
            />
            No
            </label>
            </td>
            
    </tr>
    <tr colspan=4 bgcolor="##deeaf3">
    	<Td id="crimeExpl"  <cfif FORM.crime eq 0>style="display: none;" bgcolor="##deeaf3"</cfif> >Please explain<span class="redtext">*</span><br />
        <textarea name="crimeExpl" cols="50" rows="4" >#FORM.crimeExpl#</textarea></td>
    <td></td>
    </tr>
    
    <tr>
    	<td class="label" valign="top"><h3>Have you had any contact with Child Protective Services<br /> Agency in the past? ?<span class="redtext">*</span></h3></td>
        <td>   <label>
            <cfinput type="radio" name="cps" value="1"
            checked="#FORM.cps eq 1#" onclick="document.getElementById('cpsExpl').style.display='table-row';" 
            />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="cps" value="0"
           checked="#FORM.cps eq 0#" onclick="document.getElementById('cpsExpl').style.display='none';" 
            />
            No
            </label>
            </td>
    </tr>
    <tr colspan=4>
    	<Td id="cpsExpl" <cfif FORM.cps eq 0>style="display: none;" bgcolor="##deeaf3"</cfif> >Please explain<span class="redtext">*</span><br />
        <textarea name="cpsExpl" cols="50" rows="4">#FORM.cpsExpl#</textarea></td>
    </tr>
 
    
     <tr bgcolor="##deeaf3">
    	<td class="label" valign="top" colspan="2"><h3>What is the families race? (check as many boxes as needed)<span class="redtext">*</span></h3></td>
           
      </tr>
      <tr bgcolor="##deeaf3">
      	<td colspan=2>
        <Table>
        	<tr>
            	<td><input name="race" value="African American" type="checkbox" <cfif ListFind('#race#', 'African American')>checked</cfif> /></td><td>African American</td>
                <td><input name="race" value="American Indian or Alaska Native" type="checkbox" <cfif ListFind('#race#', 'American Indian or Alaska Native')>checked</cfif> /></td><td>American Indian / Alaska Native</td>
                <td><input name="race" value="Asian Indian" type="checkbox" <cfif ListFind('#race#', 'Asian Indian')>checked</cfif> /></td><td>Asian Indian</td>
                <td><input name="race" value="American Indian or Alaska Native" type="checkbox" <cfif ListFind('#race#', 'American Indian or Alaska Native')>checked</cfif> /></td><td>American Indian / Alaska Native</td>
            </tr>
            <tr>
            	<td><input name="race" value="Chinese" type="checkbox" <cfif ListFind('#race#', 'Chinese')>checked</cfif> /></td><td>Chinese</td>
                <td><input name="race" value="Filipino" type="checkbox" <cfif ListFind('#race#', 'Filipino')>checked</cfif> /></td><td>Filipino</td>
                <td><input name="race" value="Chinese" type="checkbox" <cfif ListFind('#race#', 'Chinese')>checked</cfif> /></td><td>Chinese</td>
                <td><input name="race" value="Korean" type="checkbox" <cfif ListFind('#race#', 'Korean')>checked</cfif> /></td><td>Korean</td>
            </tr>
            <tr>
            	<td><input name="race" value="Native Hawaiian" type="checkbox" <cfif ListFind('#race#', 'Native Hawaiian')>checked</cfif> /></td><td>Native Hawaiian</td>
                <td><input name="race" value="Vietnamese" type="checkbox" <cfif ListFind('#race#', 'Vietnamese')>checked</cfif> /></td><td>Vietnamese</td>
                <td><input name="race" value="Samoan" type="checkbox" <cfif ListFind('#race#', 'Samoan')>checked</cfif> /></td><td>Samoan</td>
                <td><input name="race" value="Guamanian or Chamorro" type="checkbox" <cfif ListFind('#race#', 'Guamanian or Chamorro')>checked</cfif> /></td><td>Guamanian or Chamorro</td>
            </tr>
            <tr>
            	 <td><input name="race" value="White" type="checkbox" <cfif ListFind('#race#', 'White')>checked</cfif> /></td><td>White</td>
                 <td></td><Td colspan=3>Other: <input type="text" size=30 name="ethnicityOther" value="#FORM.ethnicityOther#" /></td>
            
            
        </Table>
        
        
            </td>
            
    </tr>
   
   </table>
   
<table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="/images/buttons/Next.png" border="0"></td>
    </tr>
</table>
<h3><u>Department Of State Regulations</u></h3>

<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(2)</a></strong><br />
<em>"The income data collected will be used solely for the purposes of determining that the basic needs of the exchange student can be met, including three quality meals and transportation to and from school activities."</em></p>

<p>&dagger;&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(6)</a></strong><br />
<em>Ensure that the host family has adequate financial resources to undertake hosting obligations and is not receiving needs-based government subsidies for food or housing;</em>



 

</cfform>
</cfoutput>

    