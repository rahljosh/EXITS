<cfif isDefined('form.update')>
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
        bandinstrument = '#form.bandinstrument#',
        playCompSports = '#form.playCompSports#'
    where hostid = #client.hostid#
    </cfquery>

	<cflocation url="index.cfm?page=hostLetter" addtoken="no">
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
Quick basics here. Let us know what activties your family does in their free time. <br />

<cfform method="post" action="index.cfm?page=familyInterests">

<table width=100% cellspacing=0 cellpadding=2 class="border">
	<tr><td width="80%">
		<table border=0 cellpadding=2 cellspacing=0 align="left">
			<tr>
            <cfset bg = 0>
            <cfloop query="get_interests">	
					<td><input type="checkbox" name="interest" value='#interestid#' <cfif ListFind(get_host_interests.interests, interestid , ",")>checked</cfif>> </td><td>#interest#</td>
					<cfif (get_interests.currentrow MOD 4 ) is 0><cfset bg = #bg# + 1></tr><tr <cfif #bg# mod 2>bgcolor="##deeaf3"</cfif>></cfif>
				</cfloop>
			<tr><td>&nbsp;</td></tr>
		<tr><td colspan="8">List any specific interests, hobbies, activities and any awards or accommodations</td></tr>
			<tr>
				<td colspan="8"><textarea cols="75" rows="5" name="specific_interests" wrap="VIRTUAL">#get_host_interests.interests_other#</textarea></td>
			</tr>
		</table>
	</td>
	
	</tr>
</table>

<h3>Band, Orchestra, and Sports</h3>


<table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr bgcolor="##deeaf3">
		<td align="left">Does anyone play in a Band?</td>
        <td>
		  <label>
            <cfinput type="radio" name="playBand" value="1"
            onclick="document.getElementById('showInst').style.display='table-row';" checked="#host_interests.playBand eq 1#" required="yes" message="Please answer: Does anyone play in a band?"/>
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="playBand" value="0"
            onclick="document.getElementById('showInst').style.display='none';"  checked="#host_interests.playBand eq 0#" required="yes" message="Please answer: Does anyone play in a band?">
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
    	<td>What instrument?</td><Td><input type="text" name="bandinstrument" size=20 value="#host_interests.bandInstrument#" /></Td>        	
    </tr>
		<Tr>
		<td align="left">Does anyone play in an Orchestra?</td>
        <td>
        <label>
            <cfinput type="radio" name="playOrchestra" value="1"
            onclick="document.getElementById('showOrcInst').style.display='table-row';" checked="#host_interests.playOrchestra eq 1#" required="yes" message="Please answer: Does anyone play in an orchastra?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="playOrchestra" value="0"
            onclick="document.getElementById('showOrcInst').style.display='none';"  checked="#host_interests.playOrchestra eq 0#" required="yes" message="Please answer: Does anyone play in an orchastra?">
            No
            </label>
        
        <!----
        <cfinput type="radio" name=orchestra value="yes" checked>Yes  <cfinput type="radio" name=orchestra value="no">No
			 <cfelseif host_interests.orchestra is 'no'><cfinput type="radio" name=orchestra value="yes">Yes  <cfinput type="radio" name=orchestra value="no" checked>No										        	 <cfelse><cfinput type="radio" name=orchestra value="yes" message="Please indicate if any one plays in an orchastra." validateat="onSubmit" required="yes">Yes  <cfinput type="radio" name=orchestra value="no">No</cfif>
			 ---->
			 </td>
	</tr>
        <tr  id="showOrcInst" <cfif host_interests.playOrchestra eq 0>style="display: none;"</cfif>>
    	<td>What instrument?</td><Td><input type="text" name="orcinstrument" size=20 value="#host_interests.orcInstrument#"/></Td>        	
    </tr>
		<Tr bgcolor="##deeaf3">
		<td align="left">Does anyone play in competitive sports?</td>
        <td> 
		  <label>
            <cfinput type="radio" name="playCompSports" value="1"
            onclick="document.getElementById('sportDesc').style.display='table-row';" checked="#host_interests.playCompSports eq 1#" required="yes" message="Please answer: Does anyone play competitive sports?">
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="playCompSports" value="0"
            onclick="document.getElementById('sportDesc').style.display='none';"  checked="#host_interests.playCompSports eq 0#" required="yes" message="Please answer: Does anyone play competitive sports?">
            No
            </label>
        <!----    
		<Cfif host_interests.comp_sports is 'yes'><cfinput type="radio" name=comp_sports value="yes" checked>Yes <cfinput type="radio" name=comp_sports value="no">No
			 <cfelseif host_interests.comp_sports is 'no'><cfinput type="radio" name=comp_sports value="yes" checked >Yes <cfinput type="radio" name=comp_sports value="no" checked>No
			 <cfelse><cfinput type="radio" name=comp_sports message="Please indicate if any one plays in competitive sports." validateat="onSubmit" required="yes" value="yes">Yes <cfinput type="radio" name=comp_sports value="no">No</cfif>
			 ---->
			 </td>
	</tr>
            <tr  id="sportDesc"  <cfif host_interests.playCompSports eq 0>style="display: none;"</cfif>>
    	<td>What sport?</td><Td><input type="text" name="sportDesc" size=20 value="#host_interests.sportDesc#"/></Td>        	
    </tr>
    </table>
    


<table border=0 cellpadding=4 cellspacing=0 width=100% >
	<tr>
<input type="hidden" name="update" />
		<td align="right"> <input name="Submit" type="image" src="images/buttons/Next.png" border=0></td>
	</tr>
</table>


</cfform>
</cfoutput>
