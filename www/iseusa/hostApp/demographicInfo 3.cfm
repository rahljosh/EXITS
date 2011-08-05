<cfparam name="form.publicAssitance" default="3">
<cfparam name="form.crime" default="3">
<cfparam name="form.cps" default="3">
<cfparam name="form.cpsexpl" default="">
<cfparam name="form.crimeExpl" default="">
<cfparam name="form.income" default="0">

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	


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
                    hostid = #client.hostid#
            </cfquery>
			<cflocation url="index.cfm?page=hello">
         <cfelse>
         
         
         </cfif>
</cfif>
<cfquery name="demoInfo" datasource="MySql">
select income, publicAssitance, crime, crimeExpl, cps, cpsExpl
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<h2>Confidential Income & Finance Data</h2>
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
The following information is requried by the Department of State. This information will be kept confidential by the exchange company and will not be distributed to the student, the natural family, or the Internationl Agent. The income data collected will be used solely for the purposes of determining that the basic needs of the exchange student can be met, including three quality meals and transportation to and from school activities.<sup>&dagger;</sup>

<cfoutput>
<cfform method="post" action="index.cfm?page=demographicInfo">
<input type="hidden" name="process" />
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
   
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
<h3><u>Department Of State Regulations</u></h3>

<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(2)</a></strong><br />
<em>Utilize a standard application form developed by the sponsor that includes, at a minimum, all data fields provided in Appendix F, "Information to be Collected on Secondary School Student Host Family Applications". The form must include a statement stating that: "The income data collected will be used solely for the purposes of determining that the basic needs of the exchange student can be met, including three quality meals and transportation to and from school activities." Such application form must be signed and dated at the time of application by all potential host family applicants. The host family application must be designed to provide a detailed summary and profile of the host family, the physical home environment (to include photographs of the host family home's exterior and grounds, kitchen, student's bedroom, bathroom, and family or living room), family composition, and community environment. Exchange students are not permitted to reside with their relatives.</em></p>

<p>&dagger;&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(6)</a></strong><br />
<em>Ensure that the host family has adequate financial resources to undertake hosting obligations and is not receiving needs-based government subsidies for food or housing;</em>

<p>&dagger;&dagger;&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(7)</a></strong><br />
       <em>Verify that each member of the host family household 18 years of age and older, as well as any new adult member added to the household, or any member of the host family household who will turn eighteen years of age during the exchange student's stay in that household, has undergone a criminal background check (which must include a search of the Department of Justice's National Sex Offender Public Registry);</em></p>


 

</cfform>
</cfoutput>

    