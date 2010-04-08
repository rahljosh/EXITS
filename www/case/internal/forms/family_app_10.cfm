<cfinclude template="../querys/get_local.cfm">
<cfform action="querys/insert_community_info.cfm" method="post">
<cfinclude template="../querys/family_info.cfm">
<cfoutput query="local">
<span class="application_section_header">Community Information</span>
<cfinclude template = "../family_app_menu.cfm">

<div class="row">

<table>
	<tr>
		<td colspan=2 align=center><h3>#city# #state#, #zip#</h3></td>
	</tr>
	<Tr>
<td class="label">Population:</td><td class="form_text"><cfinput type="text" name="population" size=20 value="#family_info.population#"></span>
</tr><tr>	
<td class="label">Local Airport Code:</td><td class="form_text"><cfinput type="text" name="local_air_code" size=3 value="#family_info.local_air_code#"></span>
</tr><tr>	 
			<td class="label">Nearest Major City:</td><td class="form_text"><cfinput type="text" name="near_city" size=20 value="#family_info.nearbigcity#"></span>
			</tr><tr>
			<td class="label">Major Airport Code:</td><td class="form_text"><cfinput type="text" name="major_air_code" size=3 value="#family_info.major_air_code#"></span>
			</tr><tr>
			<td class="label">Distance:</td><td class="form_text"> <cfinput name="near_city_dist" size=20 type="text" value="#family_info.near_City_dist#"></span>
			</tr><tr>
			<td class="label">Popluation:</td><td class="form_text"><cfinput type="text" name="near_pop" size=20 value="#family_info.near_pop#"></span>
			</tr>
		</table>
</div>
<div class="row1">
You would describe your neighborhood as:<br>
<cfif #family_info.neighborhood# is 'upper income'><cfinput type="radio" name="neighborhood" value="upper income" checked><cfelse> <cfinput type="radio" name="neighborhood" value="upper income"></cfif>Upper Income
<cfif #family_info.neighborhood# is 'white collar'><cfinput type="radio" name="neighborhood" value="white collar" checked> <cfelse><cfinput type="radio" name="neighborhood" value="white collar"></cfif>White Collar
<cfif #family_info.neighborhood# is 'blue collar'><cfinput type="radio" name="neighborhood" value="blue collar" checked> <cfelse><cfinput type="radio" name="neighborhood" value="blue collar"></cfif>Blue Collar
<cfif #family_info.neighborhood# is 'tradesman'><cfinput type="radio" name="neighborhood" value="tradesman" checked><cfelse><cfinput type="radio" name="neighborhood" value="tradesman"></cfif>Tradesman<br><br>
Would you describe the community as:<br>
<cfif #family_info.community# is 'Urban'><cfinput type="radio" name="community" value="Urban" checked><cfelse><cfinput type="radio" name="community" value="Urban"> </cfif>Urban
<cfif #family_info.community# is 'suburban'><cfinput type="radio" name="community" value="suburban" checked><cfelse><cfinput type="radio" name="community" value="suburban"></cfif>Suburban
<cfif #family_info.community# is 'small'><cfinput type="radio" name="community" value="small" checked><cfelse><cfinput type="radio" name="community" value="small"></cfif>Small Town
<cfif #family_info.community# is 'rural'><cfinput type="radio" name="community" value="rural" checked><cfelse><cfinput type="radio" name="community" value="rural"></cfif>Rural
 
 <br><br>
 The terrain of your community is:<br>
 <table>
	<tr>
		<Td><cfif #family_info.terrain1# is 'flat'><cfinput type="radio" name="terrain1" value="flat" checked><cfelse><cfinput type="radio" name="terrain1" value="flat"></cfif>Flat</td><td><cfif #family_info.terrain1# is 'hilly'> <cfinput type="radio" name="terrain1" value="hilly" checked><cfelse><cfinput type="radio" name="terrain1" value="hilly"></cfif>Hilly</td><td colspan=2></td>
	</tr>
	<tr>
		<td><cfif #family_info.terrain2# is 'trees'> <cfinput type="radio" name="terrain2" value="trees" checked><cfelse><cfinput type="radio" name="terrain2" value="trees"></cfif>Trees</td><td><cfif #family_info.terrain2# is 'notrees'><cfinput type="radio" name="terrain2" value="notrees" checked><cfelse><cfinput type="radio" name="terrain2" value="notrees"></cfif>No Trees</td><td colspan=2></td>
	</tr>
	<tr>
		<td><cfif #family_info.terrain3# is 'ocean'><cfinput type="radio" name="terrain3" value="ocean" checked><cfelse><cfinput type="radio" name="terrain3" value="ocean"></cfif>Ocean</td>
		<td><cfif #family_info.terrain3# is 'lakeside'> <cfinput type="radio" name="terrain3" value="lakeside" checked><cfelse> <cfinput type="radio" name="terrain3" value="lakeside"></cfif>Lakeside</td>
		<td><cfif #family_info.terrain3# is 'riverside'><cfinput type="radio" name="terrain3" value="riverside" checked><cfelse><cfinput type="radio" name="terrain3" value="riverside"></cfif>Riverside </td>
		<td><cfif #family_info.terrain3# is 'other'> <cfinput type="radio" name="terrain3" value="other" checked>Other <cfinput type="text" name="other_desc" size=10 value="#family_info.other_Desc#"><cfelse><cfinput type="radio" name="terrain3" value="other">Other <cfinput type="text" name="other_desc" size=10></cfif></td>
	</tr>
</table>
   
 </div>
 <div class="row">
 <table>
 	<tr>
		
<td class="label">Avg temp in winter: </td><td class="form_text"><cfinput type="text" size="3" name="wintertemp" value=#family_info.wintertemp#><sup>o</sup>F</span>
</tr><tr>
 <td class="label">Avg temp in summer:</td><td class="form_text"> <cfinput type="text" size="3" name="summertemp" value=#family_info.summertemp#><sup>o</sup>F</span>
</tr>
</table>
 </div>
<div class="row1">

Indicate particular clothes, sports equipment, etc. that your student should consider bringing:<br>
<textarea cols="50" rows="4" name="special_cloths" wrap="VIRTUAL"><cfoutput>#family_info.special_cloths#</cfoutput></textarea><br>
Describe the points of interest and available activities/opportunities for teenagers in your surrounding area:
<textarea cols="50" rows="4" name="point_interest" wrap="VIRTUAL"><cfoutput>#family_info.point_interest#</cfoutput></textarea><br>
</div>

 <div class="button"><input type="submit" value="    next    "></div>
</cfoutput>
</cfform>