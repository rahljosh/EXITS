<cfif isDefined('form.process')>
    <cfquery name="insert_community_info" datasource="MySQL">
    update smg_hosts
        set population="#form.population#",
            nearbigCity="#form.near_City#",
            near_City_Dist="#form.near_City_Dist#",
            near_pop="#form.near_pop#",
            neighborhood="#form.neighborhood#",
            community="#form.community#",
            terrain1="#form.terrain1#",
            terrain2="#form.terrain2#",
            
            wintertemp="#form.wintertemp#",
            summertemp="#form.summertemp#",
            special_cloths="#form.special_cloths#",
            point_interest="#form.point_interest#",
            local_air_code="#form.local_Air_code#",
            major_air_code="#form.major_air_code#",
            snowy_winter = <cfif isDefined('form.snowy_winter')>1<cfelse>0</cfif>,
            rainy_winter = <cfif isDefined('form.rainy_winter')>1<cfelse>0</cfif>,
            hot_summer = <cfif isDefined('form.hot_summer')>1<cfelse>0</cfif>,
            mild_summer = <cfif isDefined('form.mild_summer')>1<cfelse>0</cfif>,
            high_hummidity = <cfif isDefined('form.high_hummidity')>1<cfelse>0</cfif>,
            dry_air = <cfif isDefined('form.dry_air')>1<cfelse>0</cfif>
            
      where hostid=#client.hostid#
           
           

            
    </cfquery>
    <cfif isDefined('form.terrain3')>
    <cfquery name="terrain3" datasource="MySQL">
    update smg_hosts
        set 
        terrain3 = "#form.terrain3#",
        terrain3_desc = "#form.other_desc#"
    where hostid=#client.hostid#
    </cfquery>
    </cfif>
	<cflocation url="index.cfm?page=schoolInfo">
</cfif>

<cfquery name="local" datasource="MySQL">
	select city,state,zip
	from smg_hosts
	where hostid = #client.hostid#
</cfquery>
<cfform action="index.cfm?page=communityProfile" method="post">
<cfquery name="family_info" datasource="MySQL">
select *
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<cfoutput>
<input type="hidden" name="process" />
<h2>Community Information for #local.city# #local.state#, #local.zip#</h2>

 <table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr  bgcolor="##deeaf3">
        <td class="label">Population:</td><td class="form_text"><cfinput type="text" name="population" size=20 value="#family_info.population#"></span>
     </tr>
     <tr>	
        <td class="label">Local Airport Code:</td><td class="form_text"><cfinput type="text" name="local_air_code" size=3 value="#family_info.local_air_code#"></span>
      </tr>
      <tr  bgcolor="##deeaf3">	 
        <td class="label">Nearest Major City:</td><td class="form_text"><cfinput type="text" name="near_city" size=20 value="#family_info.nearbigcity#"></span>
     </tr>
     <tr>
        <td class="label">Major City Popluation:</td><td class="form_text"><cfinput type="text" name="near_pop" size=20 value="#family_info.near_pop#"></span>
     </tr>
     <tr bgcolor="##deeaf3">
        <td class="label">Major Airport Code:</td><td class="form_text"><cfinput type="text" name="major_air_code" size=3 value="#family_info.major_air_code#"></span>
     </tr>
     <tr  >
        <td class="label">Distance:</td><td class="form_text"> <cfinput name="near_city_dist" size=20 type="text" value="#family_info.near_City_dist#"> miles</span>
     </tr>

		</table>
<h2>Neighborhood & Terrain</h2>

<table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr  bgcolor="##deeaf3">
        <td class="label">
You would describe your neighborhood as:
		</td>
    </Tr>
    <tr bgcolor="##deeaf3">
    	<Td>
<cfif #family_info.neighborhood# is 'upper income'><cfinput type="radio" name="neighborhood" message="Please indicate the type of neighborhood you live in." required="yes" value="upper income"><cfelse> <cfinput type="radio" name="neighborhood" value="upper income" required="yes" message="Please indicate the type of neighborhood you live in."></cfif>Upper Income
<cfif #family_info.neighborhood# is 'white collar'><cfinput type="radio" name="neighborhood" value="white collar" checked> <cfelse><cfinput type="radio" name="neighborhood" value="white collar"></cfif>White Collar
<cfif #family_info.neighborhood# is 'blue collar'><cfinput type="radio" name="neighborhood" value="blue collar" checked> <cfelse><cfinput type="radio" name="neighborhood" value="blue collar"></cfif>Blue Collar
<cfif #family_info.neighborhood# is 'tradesman'><cfinput type="radio" name="neighborhood" value="tradesman" checked><cfelse><cfinput type="radio" name="neighborhood" value="tradesman"></cfif>Tradesman<br><br>
		</Td>
    </tr>
    <Tr >
    	<td class="label">
Would you describe the community as:</td>
	</Tr>
    <Tr >
    	<td>
<cfif #family_info.community# is 'Urban'><cfinput type="radio" name="community" message="Please indicate the type of community you live in." required="yes" value="Urban" checked><cfelse><cfinput type="radio" name="community" value="Urban"  message="Please indicate the type of community you live in." required="yes"> </cfif>Urban
<cfif #family_info.community# is 'suburban'><cfinput type="radio" name="community" value="suburban" checked><cfelse><cfinput type="radio" name="community" value="suburban"></cfif>Suburban
<cfif #family_info.community# is 'small'><cfinput type="radio" name="community" value="small" checked><cfelse><cfinput type="radio" name="community" value="small"></cfif>Small Town
<cfif #family_info.community# is 'rural'><cfinput type="radio" name="community" value="rural" checked><cfelse><cfinput type="radio" name="community" value="rural"></cfif>Rural
		</td>
	</Tr>
    <tr bgcolor="##deeaf3">
    	<td class="label">
 The terrain of your community is (please select one from each row):
 		</td>
    </tr>
    <tr bgcolor="##deeaf3">
    	<td>
             <table border=0>
                <tr>
                    <Td><cfif #family_info.terrain1# is 'flat'><cfinput type="radio" message="Please indicate the type of terrain around your community." required="yes" name="terrain1" value="flat" checked><cfelse><cfinput type="radio" name="terrain1" value="flat" message="Please indicate the type of terrain around your community." required="yes"></cfif>Flat</td>
                    <td><cfif #family_info.terrain1# is 'hilly'> <cfinput type="radio" name="terrain1" value="hilly" checked><cfelse><cfinput type="radio" name="terrain1" value="hilly"></cfif>Hilly</td> <td colspan=2></td>
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
   </td>
  </tr>
 </table>
<h2>Climate</h2>
 <table  width=100% cellspacing=0 cellpadding=2 class="border">
 	<tr bgcolor="##deeaf3">
		
<td class="label" colspan=2>Avg temp in winter: </td><td class="form_text" colspan=4><cfinput type="text" size="3" name="wintertemp" value=#family_info.wintertemp#><sup>o</sup>F</span>
</tr><tr>
 <td class="label" colspan=2>Avg temp in summer:</td><td class="form_text" colspan=4> <cfinput type="text" size="3" name="summertemp" value=#family_info.summertemp#><sup>o</sup>F</span>
</tr>
<tr>
	<Td colspan=6  bgcolor="##deeaf3">How would you describe your seasons?</Td>
<Tr bgcolor="##deeaf3">
	<Td><input type="checkbox" name="snowy_winter" <Cfif family_info.snowy_winter eq 1>checked </cfif> />Cold, snowy winters </Td>
    <Td><input type="checkbox"  name="rainy_winter" <Cfif family_info.rainy_winter eq 1>checked </cfif>/>Mild, rainy winters</Td>
    <Td><input type="checkbox" name="hot_summer" <Cfif family_info.hot_summer eq 1>checked </cfif>  />Hot Summers</Td>
    <Td><input type="checkbox"  name="mild_summer" <Cfif family_info.mild_summer eq 1>checked </cfif>/>Mild Summers</Td>
    <td><input type="checkbox" name="high_hummidity" <Cfif family_info.high_hummidity eq 1>checked </cfif> />High Humidity</td>
    <td><input type="checkbox" name="dry_air" <Cfif family_info.dry_air eq 1>checked </cfif> />Dry air</td>
</table>
<h2>Misc. Info</h2>
 <table  width=100% cellspacing=0 cellpadding=2 class="border">
 	<tr bgcolor="##deeaf3">
		
<td class="label" colspan=2>
Indicate particular clothes, sports equipment, etc. that your student should consider bringing:</td>
	</tr>
    <tr bgcolor="##deeaf3">
    	<td>
<textarea cols="50" rows="4" name="special_cloths" wrap="VIRTUAL"><cfoutput>#family_info.special_cloths#</cfoutput></textarea></td>	
	</tr>
    <tr>
    	<td>
Describe the points of interest and available activities/opportunities for teenagers in your surrounding area:</td>
	</tr>
    <tr>
    	<Td>
        
<textarea cols="50" rows="4" name="point_interest" wrap="VIRTUAL"><cfoutput>#family_info.point_interest#</cfoutput></textarea><br>
		</Td>
    </tr>
 </table>
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right">
      
        <input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
</cfoutput>
</cfform>