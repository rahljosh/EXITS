
<cfparam name="form.update" default="0">
<cfparam name="form.playBand" default="3">
<cfparam name="form.bandInstrument" default="">
<cfparam name="form.playOrchestra" default="3">
<cfparam name="form.OrcInstrument" default="">
<cfparam name="form.playCompSports" default="3">
<cfparam name="form.sportDesc" default="">
<CFparam name="form.specific_interests" default ="">
<!---Get host information---->
   <cfquery name="qGetHostInfo" datasource="mysql">
        SELECT  
        	*
        FROM 
        	smg_hosts shl
        LEFT JOIN 
        	smg_states on smg_states.state = shl.state
        WHERE 
        	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
    </cfquery>
<cfparam name="form.interest" default="#qGetHostInfo.interests#"> 

<cfset listInt = #ListLen(form.interest)#>
<Cfset inttogo = 3 - #listInt#>
		
<!--- Kill Extra Output --->
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<cfif VAL(form.update)>



	<!--- Process Form Submission --->
         <cfscript>
            // Data Validation
			//Play in Band
			 if ( listInt LT 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please spedicfy at least #inttogo# more interest(s) from the list.");
			 }
			//Play in Band
			 if ( FORM.playBand EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any one in your home plays in a band.");
			 }
			
			// Competitve Sports
             if ( FORM.playCompSports EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any one in your home plays competitve sports.");
			 }
			 
			// Address Lookup
            if ( FORM.playOrchestra EQ 3) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if any one in your home plays in an orchestra.");
			 }	
			//Band Answer
			 if (( FORM.playBand EQ 1) AND NOT LEN(TRIM(FORM.bandinstrument)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that someone plays in a band, but you have not indicated what instrument they play.");
			}
			//Orchestra  Answer
			 if (( FORM.playOrchestra EQ 1) AND NOT LEN(TRIM(FORM.orcinstrument)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that someone plays in an orchestra, but you have not indicated what instrument they play.");
			}
			//Comp Sport  Answer
			 if (( FORM.playCompSports EQ 1) AND NOT LEN(TRIM(FORM.sportDesc)) )  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You have indicated that someone plays a competitive sport, but you have not indicated what sport they play.");
			}
		</cfscript>
        <cfoutput>
              
        </cfoutput>
        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
            
			<!--- No Erros --->		


            <cfquery name="insert_interests" datasource="MySQL">
            Update smg_hosts
            set interests = '#form.interest#',
                band = '#form.playBand#',
                orchestra = '#form.playOrchestra#',
                comp_sports = '#form.playCompSports#',
                interests_other = '#form.specific_interests#',
                orcInstrument = '#form.orcInstrument#',
                bandInstrument = '#form.bandInstrument#',
                sportDesc = '#form.sportDesc#',
                playOrchestra = '#form.playOrchestra#',
                orcinstrument = '#form.orcinstrument#',
                playBand = '#form.playBand#',
                bandinstrument = '#form.bandInstrument#',
                playCompSports = '#form.playCompSports#'
            where hostid = #client.hostid#
            </cfquery>
        
            <cflocation url="index.cfm?page=hostLetter" addtoken="no">
		
      
        </cfif>
<cfelse>

		<!----Form not submitted, set to DB values---->
         <cfscript>
        	 FORM.interests = qGetHostInfo.interests;
			FORM.playBand = qGetHostInfo.playBand;
			FORM.bandInstrument = qGetHostInfo.bandInstrument;
			FORM.playOrchestra = qGetHostInfo.playOrchestra;
			FORM.OrcInstrument = qGetHostInfo.OrcInstrument;
			FORM.playCompSports = qGetHostInfo.playCompSports;
			FORM.sportDesc = qGetHostInfo.sportDesc;
			FORM.specific_interests = qGetHostInfo.interests_other;
		</cfscript>
</cfif>



<cfquery name="get_host_interests" datasource="MySQL">
select interests, interests_other
from smg_hosts
where hostid = #client.hostid# 
</cfquery>

<cfquery name="host_interests" datasource="MySQL">
select interests, interests_other, playBand, playOrchestra, playCompSports, orcInstrument, bandInstrument, sportDesc
from smg_hosts
where hostid=#client.hostid#
</cfquery>

<cfquery name="get_interests" datasource="MySQL">
select *
from smg_interests
order by interest
</cfquery>
<Cfoutput>
<h2> Interests</h2>
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
<h4>Quick basics here. Let us know what activties your family does in their free time. <br />Please select at LEAST 3 activities from the list below.<span class="redtext">*</span></h4>


<cfform method="post" action="index.cfm?page=familyInterests">
<input type="hidden" name="update" value=1 />
<table width=100% cellspacing=0 cellpadding=2 class="border">
	<tr><td width="80%">
		<table border=0 cellpadding=2 cellspacing=0 align="left">
			<tr>
            <cfset bg = 0>
            <cfloop query="get_interests">	
					<td><input type="checkbox" name="interest" value='#interestid#' <cfif ListFind(form.interest, interestid , ",")>checked</cfif>> </td><td>#interest#</td>
					<cfif (get_interests.currentrow MOD 4 ) is 0><cfset bg = #bg# + 1></tr><tr <cfif #bg# mod 2>bgcolor="##deeaf3"</cfif>></cfif>
				</cfloop>
			<tr><td>&nbsp;</td></tr>
		<tr><td colspan="8">List any specific interests, hobbies, activities and any awards or accomidations</td></tr>
			<tr>
				<td colspan="8"><textarea cols="75" rows="5" name="specific_interests" wrap="VIRTUAL">#form.specific_interests#</textarea></td>
			</tr>
		</table>
	</td>
	
	</tr>
</table>

<h3>Band, Orchestra, and Sports</h3>


<table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr bgcolor="##deeaf3">
		<td align="left">Does anyone play in a Band?<span class="redtext">*</span></td>
        <td>
		  <label>
            <cfinput type="radio" name="playBand" value="1"
            onclick="document.getElementById('showInst').style.display='table-row';" checked="#form.playBand eq 1#" >
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="playBand" value="0"
            onclick="document.getElementById('showInst').style.display='none';"  checked="#form.playBand eq 0#">
            No
            </label>
		
		<!----
		<cfif host_interests.band is 'yes'><cfinput type="radio" name=band value="yes" checked>Yes <cfinput type="radio" name=band value="no">No
			<cfelseif host_interests.band is 'no'><cfinput type="radio" name=band value="yes">Yes <cfinput type="radio" name=band value="no" checked>No  
			<Cfelse>
            <cfinput type="radio" name=band value="yes" message="Please indicate if any one plays in a band." validateat="onSubmit" required="yes">Yes <cfinput type="radio" name=band value="no">No</cfif>
			--->
			</td>
	</tr>
    <tr  bgcolor="##deeaf3" id="showInst"  <cfif host_interests.playBand eq 0>style="display: none;"</cfif>>
    	<td>What instrument?<span class="redtext">*</span></td><Td><input type="text" name="bandInstrument" size=20 value="#form.bandInstrument#" /></Td>        	
    </tr>
		<Tr>
		<td align="left">Does anyone play in an Orchestra?<span class="redtext">*</span></td>
        <td>
        <label>
            <cfinput type="radio" name="playOrchestra" value="1"
            onclick="document.getElementById('showOrcInst').style.display='table-row';" checked="#form.playOrchestra eq 1#"  />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="playOrchestra" value="0"
            onclick="document.getElementById('showOrcInst').style.display='none';"  checked="#form.playOrchestra eq 0#" >
            No
            </label>
        
        <!----
        <cfinput type="radio" name=orchestra value="yes" checked>Yes  <cfinput type="radio" name=orchestra value="no">No
			 <cfelseif host_interests.orchestra is 'no'><cfinput type="radio" name=orchestra value="yes">Yes  <cfinput type="radio" name=orchestra value="no" checked>No										        	 <cfelse><cfinput type="radio" name=orchestra value="yes" message="Please indicate if any one plays in an orchastra." validateat="onSubmit" required="yes">Yes  <cfinput type="radio" name=orchestra value="no">No</cfif>
			 ---->
			 </td>
	</tr>
        <tr  id="showOrcInst" <cfif host_interests.playOrchestra eq 0>style="display: none;"</cfif>>
    	<td>What instrument?<span class="redtext">*</span></td><Td><input type="text" name="OrcInstrument" size=20 value="#form.OrcInstrument#"/></Td>        	
    </tr>
		<Tr bgcolor="##deeaf3">
		<td align="left">Does anyone play in competitive sports?<span class="redtext">*</span></td>
        <td> 
		  <label>
            <cfinput type="radio" name="playCompSports" value="1"
            onclick="document.getElementById('sportDesc').style.display='table-row';" checked="#form.playCompSports eq 1#" >
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="playCompSports" value="0"
            onclick="document.getElementById('sportDesc').style.display='none';"  checked="#form.playCompSports eq 0#" >
            No
            </label>
        <!----    
		<Cfif host_interests.comp_sports is 'yes'><cfinput type="radio" name=comp_sports value="yes" checked>Yes <cfinput type="radio" name=comp_sports value="no">No
			 <cfelseif host_interests.comp_sports is 'no'><cfinput type="radio" name=comp_sports value="yes" checked >Yes <cfinput type="radio" name=comp_sports value="no" checked>No
			 <cfelse><cfinput type="radio" name=comp_sports message="Please indicate if any one plays in competitive sports." validateat="onSubmit" required="yes" value="yes">Yes <cfinput type="radio" name=comp_sports value="no">No</cfif>
			 ---->
			 </td>
	</tr>
            <tr  id="sportDesc" bgcolor="##deeaf3" <cfif host_interests.playCompSports eq 0>style="display: none;"</cfif>>
    	<td>What sport?<span class="redtext">*</span></td><Td><input type="text" name="sportDesc" size=20 value="#form.sportDesc#"/></Td>        	
    </tr>
    </table>
    


<table border=0 cellpadding=4 cellspacing=0 width=100% >
	<tr>

		<td align="right"> <input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
	</tr>
</table>


</cfform>
</cfoutput>
