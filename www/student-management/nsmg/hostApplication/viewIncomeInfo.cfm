<cfparam name="form.publicAssitance" default="3">
<cfparam name="form.crime" default="3">
<cfparam name="form.cps" default="3">
<cfparam name="form.cpsexpl" default="">
<cfparam name="form.crimeExpl" default="">
<cfparam name="form.income" default="0">

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<link href="http://iseusa.com/css/ISEstyle.css" rel="stylesheet" type="text/css" />
<link href="http://iseusa.com/hostApp/css/hostApp.css" rel="stylesheet" type="text/css" />
<link href="http://ise.exitsapplication.com/nsmg/linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="chosen/chosen.css" />
<link rel="stylesheet" href="http://iseusa.com/css/css/wiki.css" />
<link rel="stylesheet" href="http://iseusa.com/css/css/colorbox2.css" />
<cfinclude template="approveDenyInclude.cfm">

<cfif isDefined('form.process')>


  <cfscript>
           // Data Validation
			// Family Last Name
            if (FORM.publicAssitance EQ 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any member of your household is receiving any public assistance.");
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
    		  if ( (form.crime EQ 1) AND (NOT LEN(TRIM(FORM.crimeExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that someone has been charged with a crime, but did not explain.");
            }		
			if ( FORM.cps EQ 3 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if you have been contacted by Child Protectve Services.");
            }	
			
			// City
    		  if ( (form.cps EQ 1) AND (NOT LEN(TRIM(FORM.cpsExpl))) ) {
              // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that you have been contacted by Child Protective Services, but did not explain.");
            }	
        	
        		
	</cfscript>

         <cfif NOT SESSION.formErrors.length()>
       
         <cfquery name="insert_rules" datasource="MySQL">
            update smg_hosts
                set
                    income = #form.income#,
                    publicAssitance = #form.publicAssitance#,
                    crime = #form.crime#,
                    crimeExpl = "#form.crimeExpl#",
                    cps = #form.cps#,
                    cpsexpl = "#form.cpsexpl#"
                where
                    hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
            </cfquery>
         
			
         </cfif>
</cfif>
<cfquery name="demoInfo" datasource="MySql">
select income, publicAssitance, crime, crimeExpl, cps, cpsExpl
from smg_hosts
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
</cfquery>

	<cfscript>
	 // Set FORM Values   
			FORM.income = demoInfo.income;
			FORM.crime = demoInfo.crime;
			FORM.publicAssitance = demoInfo.publicAssitance;
			FORM.crimeExpl = demoInfo.crimeExpl;
			FORM.cps = demoInfo.cps;
			FORM.cpsExpl = demoInfo.cpsExpl;
	</cfscript>
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        />
<h2>Income Questionaire<br /><font size=-2><span class="redtext">*</span>Indicates a required question</font></h2>
<hr width=80% align="center" height=1px />
<cfoutput>
<cfform method="post" action="viewIncomeInfo.cfm?itemID=#url.itemID#&usertype=#url.usertype#">
<input type="hidden" name="process" value=1>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr  bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Is any member of your household receiving<br> any kind of public assistance?<span class="redtext">*</span><sup>&dagger;&dagger;</sup></h3></td>
        <td><cfinput  checked="#demoInfo.publicAssitance eq 0#" type="radio" name="publicAssitance" value=0 />No <cfinput type="radio" checked="#demoInfo.publicAssitance eq 1#" name="publicAssitance" value=1 />Yes</td>
    </tr>
    <tr >
    	<td class="label" valign="top"><h3>Average annual income range<span class="redtext">*</span><sup>&dagger;&dagger;</sup></h3></td>
        <td><cfinput checked="#form.income eq 25#" type="radio" name="income" value=25 />Less then $25,000<br />
        	<cfinput checked="#form.income eq 35#" type="radio" name="income" value=35 />$25,000 - $35,000<br />
      		<cfinput checked="#form.income eq 45#" type="radio" name="income" value=45 />$35,001 - $45,000<br />
            <cfinput checked="#form.income eq 55#" type="radio" name="income" value=55 />$45,001 - $55,000<br />
            <cfinput checked="#form.income eq 65#" type="radio" name="income" value=65 />$55,001 - $65,000<br />
            <cfinput checked="#form.income eq 75#" type="radio" name="income" value=75 />$65,001 - $75,000<br />
            <cfinput checked="#form.income eq 85#"type="radio" name="income" value=85 />$75,000 and above<br />
       </td>
    </tr>
    <tr bgcolor="##deeaf3">
    	<td class="label" valign="top"><h3>Has any member of your household ever been charged<Br> with a crime?<span class="redtext">*</span><sup>&dagger;&dagger;&dagger;</sup></h3></td>
        <td>   <label>
            <cfinput type="radio" name="crime" value="1"
            checked="#form.crime eq 1#" onclick="document.getElementById('crimeExpl').style.display='table-row';" 
            />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="crime" value="0"
           checked="#form.crime eq 0#" onclick="document.getElementById('crimeExpl').style.display='none';" 
            />
            No
            </label>
            </td>
            
    </tr>
    <tr colspan=4 bgcolor="##deeaf3">
    	<Td id="crimeExpl"  <cfif form.crime eq 0>style="display: none;" bgcolor="##deeaf3"</cfif> >Please explain<span class="redtext">*</span><br />
        <textarea name="crimeExpl" cols="50" rows="4" >#form.crimeExpl#</textarea></Td>
    <td></td>
    </tr>
    
    <tr>
    	<td class="label" valign="top"><h3>Have you had any contact with Child Protective Services<br /> Agency in the past? ?<span class="redtext">*</span></h3></td>
        <td>   <label>
            <cfinput type="radio" name="cps" value="1"
            checked="#form.cps eq 1#" onclick="document.getElementById('cpsExpl').style.display='table-row';" 
            />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="cps" value="0"
           checked="#form.cps eq 0#" onclick="document.getElementById('cpsExpl').style.display='none';" 
            />
            No
            </label>
            </td>
    </tr>
    <tr colspan=4>
    	<Td id="cpsExpl" <cfif form.cps eq 0>style="display: none;" bgcolor="##deeaf3"</cfif> >Please explain<span class="redtext">*</span><br />
        <textarea name="cpsExpl" cols="50" rows="4">#form.cpsExpl#</textarea></Td>
    </tr>
   </table>
   <br />
<hr width=80% align="center" height=1px />

<cfinclude template="updateInfoInclude.cfm">
   </cfform>
   <cfinclude template="approveDenyButtonsInclude.cfm">
   </cfoutput>