<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Community Profile</title>
<link href="../linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<link href="css/hostApp.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="chosen/chosen.css" />
<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
<cfinclude template="approveDenyInclude.cfm">

</head>


<cfparam name="cityPopulation" default="">
<cfparam name="capitalPopulation" default="">
<cfparam name="townPopulation" default="">
<cfparam name="metroPopulation" default="">
<Cfparam name="form.majorAirDist" default="">
<Cfparam name="form.near_city_dist" default="">
<Cfparam name="form.near_city" default="">
<Cfparam name="form.avoidarea" default="">
<Cfparam name="form.population" default="">
<Cfparam name="form.major_air_code" default="">
<Cfparam name="form.point_interest" default="">
<Cfparam name="form.special_cloths" default="">
<Cfparam name="form.summertemp" default="">
<Cfparam name="form.terrain3_desc" default="">
<Cfparam name="form.wintertemp" default="">
<Cfparam name="form.snowy_winter" default="">
<Cfparam name="form.terrain2" default="">
<Cfparam name="form.terrain1" default="">
<Cfparam name="form.terrain3" default="">
<Cfparam name="form.rainy_winter" default="">
<Cfparam name="form.hot_summer" default="">
<Cfparam name="form.mild_summer" default="">
<Cfparam name="form.high_hummidity" default="">
<Cfparam name="form.dry_air" default="">
<Cfparam name="form.community" default="">
<Cfparam name="form.neighborhood" default="">
<cfparam name="displayMessage" default="">

<cfquery name="localInfo" datasource="MySQL">
	select city, state, zip
	from smg_hosts
	where hostid = #client.hostid#
</cfquery>


<cfquery name="family_info" datasource="MySQL">
select *
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<cfquery name="airports" datasource="MySQL">
select *
from smg_airports
</cfquery>
<Cfquery name="cityState" datasource="mysql">
    select *
    from smg_cityState
    where population > 30000
    </Cfquery>


<cfif isDefined('form.process')>


     
	<cfscript>
    // Family Smokes
             if(NOT LEN(TRIM(FORM.near_city))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate the nearest town over 30,000 people.");
			 }
    // Family Smokes
             if(NOT LEN(TRIM(FORM.avoidarea))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if there are or are not areas to be avoided in your neighborhood.");
			 }
			 
             if(NOT LEN(TRIM(FORM.local_air_code))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate your local airport code.");
			 }
			 
			 if(NOT LEN(TRIM(FORM.major_air_code))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate your major airport code.");
			 }
			 
			  if(NOT LEN(TRIM(FORM.point_interest))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate any interests in your area.");
			 }
			 
			  if(NOT LEN(TRIM(FORM.special_cloths))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please provide a list of any special cloths to bring.");
			 }
			 
			 if(NOT LEN(TRIM(FORM.summertemp))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate the average summer temp.");
			 }
			 
			 if(NOT LEN(TRIM(FORM.wintertemp))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate the average winter temp.");
			 }
			 
			 if(NOT LEN(TRIM(FORM.community))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe your community.");
			 }
			 
		
			 
			 if(NOT LEN(TRIM(FORM.neighborhood))) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe your neighborhood.");
			 }
			 
	</cfscript>

	
   
       <cfif NOT SESSION.formErrors.length()>

        
         
            <cfquery name="insert_community_info" datasource="MySQL">
            update smg_hosts
                set 
                
                population="#form.population#",
                    near_City_Dist="cityDist",
               		nearbigCity="#form.near_City#",
                    neighborhood="#form.neighborhood#",
                    community="#form.community#",
                    avoidArea = "#form.avoidArea#",
                    terrain1="#form.terrain1#",
                    terrain2="#form.terrain2#",
                    <cfif isDefined('form.terrain3')>
                    terrain3 = "#form.terrain3#",
                    terrain3_desc = "#form.terrain3_desc#",
                    </cfif>
                    wintertemp="#form.wintertemp#",
                    summertemp="#form.summertemp#",
                    special_cloths = "#form.special_cloths#",
                    point_interest = "#form.point_interest#",
                    local_air_code = "#form.local_Air_code#",
                    major_air_code = "#form.major_air_code#",
                    snowy_winter = <cfif val(form.snowy_winter)>1<cfelse>0</cfif>,
                    rainy_winter = <cfif val(form.rainy_winter)>1<cfelse>0</cfif>,
                    hot_summer = <cfif val(form.hot_summer)>1<cfelse>0</cfif>,
                    mild_summer = <cfif val(form.mild_summer)>1<cfelse>0</cfif>,
                    high_hummidity = <cfif val(form.high_hummidity)>1<cfelse>0</cfif>,
                    dry_air = <cfif val(form.dry_air)>1<cfelse>0</cfif>
                    
              where hostid=#client.hostid#
            </cfquery> 
           <cfquery name="family_info" datasource="MySQL">
            select *
            from smg_hosts
            where hostid = #client.hostid#
            </cfquery>
           
           
	</cfif>
		


  
  
<cfelse>


 <cfscript>
			
			FORM.population = family_info.population;
			FORM.near_city_dist = family_info.near_city_dist;
			FORM.near_city = family_info.nearbigcity;
			FORM.avoidarea = family_info.avoidarea;
			FORM.local_air_code = family_info.local_air_code;
			FORM.major_air_code = family_info.major_air_code;
			FORM.point_interest = family_info.point_interest;
			FORM.special_cloths = family_info.special_cloths;
			FORM.summertemp = family_info.summertemp;
			FORM.terrain3_desc = family_info.terrain3_desc;  
			FORM.wintertemp = family_info.wintertemp;
			FORM.snowy_winter = family_info.snowy_winter;
			FORM.terrain2 = family_info.terrain2;
			FORM.terrain1 = family_info.terrain1;
			FORM.terrain3 = family_info.terrain3;
			FORM.rainy_winter = family_info.rainy_winter;
			FORM.hot_summer = family_info.hot_summer;
			FORM.mild_summer = family_info.mild_summer;
			FORM.high_hummidity = family_info.high_hummidity;
			FORM.dry_air = family_info.dry_air;
			FORM.community = family_info.community;
			FORM.neighborhood = family_info.neighborhood;
		</cfscript>
</cfif>
	<cfscript>
                // Get Host Mother CBC
                cityDist = APPCFC.udf.calculateAddressDistance(
                    origin='#family_info.address# #family_info.city#, #family_info.state#', 
                    destination='#family_info.nearbigcity#'
                );
            </cfscript>

<!---Attempt to guess local airport code---->
<cfif form.local_air_code is ''>
    <cfquery name="guessLocalAirport" datasource="MySQL">
    select *
    from smg_airports
    where city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.city#">
    AND state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.state#">
    </cfquery>

    <Cfif guessLocalAirport.recordcount neq 0>
		<cfscript>
            FORM.local_air_code = guessLocalAirport.aircode;
        </cfscript>
    </Cfif>
</cfif>
<cfif form.major_air_code is ''>
    <cfquery name="guessMajorAirport" datasource="MySQL">
    select major_air_code
    from smg_hosts
    where city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.city#">
    AND state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.state#">
    limit 1
    </cfquery>

    <Cfif guessMajorAirport.recordcount neq 0>
		<cfscript>
            FORM.major_air_code = guessMajorAirport.major_air_code;
        </cfscript>
    </Cfif>
</cfif>
<!-----Attempt to get local population---->
<cfif not val(form.population)>
    <cfquery name="getPopulation" datasource="MySQL">
    select population
    from smg_cityState
    where city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.city#">
    AND state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.state#">
    </cfquery>

    <Cfif getPopulation.recordcount neq 0>
          <cfset FORM.population = #NumberFormat(getPopulation.population, '__,___')#>
        
    </Cfif>
</cfif>
<!-----Attempt to get local weather---->

<cfif not val(form.wintertemp)>
    <cfquery name="getWeather" datasource="MySQL">
    select wintertemp, summertemp, snowy_winter,terrain2,terrain1, terrain3, rainy_winter, hot_summer, mild_summer, high_hummidity, dry_air, terrain3_desc 		
    from smg_hosts
    where city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.city#">
    AND state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.state#">
    and summertemp != 0
    limit 1
    </cfquery>
	
    <Cfif getWeather.recordcount neq 0>
           <cfscript>
			
			
			FORM.summertemp = getWeather.summertemp;
			FORM.terrain3_desc = getWeather.terrain3_desc;  
			FORM.wintertemp = getWeather.wintertemp;
			FORM.snowy_winter = getWeather.snowy_winter;
			FORM.rainy_winter = getWeather.rainy_winter;
			FORM.hot_summer = getWeather.hot_summer;
			FORM.mild_summer = getWeather.mild_summer;
			FORM.high_hummidity = getWeather.high_hummidity;
			FORM.dry_air = getWeather.dry_air;
	
		</cfscript>
    </Cfif>
</cfif>
<cfoutput>

</cfoutput>
<cfif not len(form.point_interest)>
    <cfquery name="getInterest" datasource="MySQL">
    select point_interest 		
    from smg_hosts
    where city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.city#">
    AND state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#localInfo.state#">
    and point_interest != ''
    limit 1
    </cfquery>

    <Cfif getInterest.recordcount neq 0>
           <cfscript>
			FORM.point_interest = getInterest.point_interest;
		</cfscript>
    </Cfif>
</cfif>
<cfoutput>

</cfoutput>
<cfoutput>

    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        />


<cfform action="viewCommunityProfile.cfm?itemID=#url.itemID#&usertype=#url.usertype#" method="post">
<input type="hidden" name="process" />
<table width=100%>
	<tr>
    	<td>
<h2>Community Information for #localInfo.city#, #localInfo.state#</h2>
		</td>
        <Td align="right">
        <a href="http://en.wikipedia.org/wiki/#localInfo.city#,_#localInfo.state#" class="iframe">Need more info on #localInfo.city#?</a>
        </Td>
<table width=100% cellspacing=0 cellpadding=2 class="border">
	
     <tr>	
        <td >Population of #localInfo.city# :</td><td class="form_text"><input type="text" size=15 name="population" value='#form.population#'/></td>
        
      </tr>
      <tr  bgcolor="##deeaf3">
        <td class="label">Nearest Major City:</td><td class="form_text">
                <select data-placeholder="Enter nearest large city (over 30,000)..." class="chzn-select" style="width:350px;" tabindex="2" name="near_city" onchange="this.form.submit(closeCity);">
               
                    <option value=""></option>
                <Cfloop query="cityState">
                    <option value="#city#, #state#" <cfif form.near_city is '#city#, #state#'>selected</cfif>>#city#, #state# - (pop: #NumberFormat(population, '__,___')#)</option>
                </Cfloop>
                    
                </select>
        
        
        </span>
         
       (#cityDist# miles away)
        </td>
 
     </tr>
 </table>
 <h2>Airports</h2>

 <table width=100% cellspacing=0 cellpadding=2 class="border">
	
     <tr>	
        <td class="label">Your local Airport:</td><td class="form_text">
        
           
        
                <select data-placeholder="Enter City, Airport or Airport Code" class="chzn-select" style="width:350px;" tabindex="2" name="local_air_code">
               
                    <option value=""></option>
                <Cfloop query="airports">
                    <option value="#airCode#" <cfif '#trim(form.local_air_code)#' is '#trim(airCode)#'>selected</cfif>>#aircode# - #airportName# - #city#, #state#</option>
                </Cfloop>
                    
                </select>
    
        
       </span>
      </tr>
       <!----
      <tr bgcolor="##deeaf3">	 
        <td>Nearest Major City (Population):</td><td class="form_text">
        <select data-placeholder="Enter nearest large city (over 50,000)..." class="chzn-select" style="width:350px;" tabindex="2" name="near_city" onchange="this.form.submit();">
               
                    <option value=""></option>
                <Cfloop query="cityState">
                    <option value="#city#, #state#" <cfif form.near_city is '#city#, #state#'>selected</cfif>>#city#, #state# - (pop: #NumberFormat(population, '__,___')#)</option>
                </Cfloop>
                    
                </select>
        
        
        </span>
        </td>
     </tr>
    
     <tr>
        <td class="label">Major City Popluation:</td><td class="form_text">
        
        
        
        <cfinput type="text" name="near_pop" size=20 value="#family_info.near_pop#"></span>
     </tr>
	 ---->
     
     <tr bgcolor="##deeaf3" >
        <td class="label">Major Airport:</td><td class="form_text">
         <select data-placeholder="Enter City, Airport or Airport Code" class="chzn-select" style="width:350px;" tabindex="2" name="major_air_code" >
               
                    <option value=""></option>
                <Cfloop query="airports">
                    <option value="#airCode#" <cfif form.major_air_code eq airCode>selected</cfif>>#aircode# - #airportName# - #city#, #state#</option>
                </Cfloop>
                    
                </select>
        </span>
     </tr>
     
   

		</table>
        <h2>Climate</h2>
         
 <table  width=100% cellspacing=0 cellpadding=2 class="border">

 
 	<tr bgcolor="##deeaf3">
		
<td class="label" colspan=2>Avg temp in winter: </td><td class="form_text" colspan=4><input type="text" size="3" name="wintertemp" value=#form.wintertemp#><sup>o</sup>F</span>
</tr><tr>
 <td class="label" colspan=2>Avg temp in summer:</td><td class="form_text" colspan=4> <input type="text" size="3" name="summertemp" value=#form.summertemp#><sup>o</sup>F</span>
</tr>
<tr>
	<Td colspan=6  bgcolor="##deeaf3">How would you describe your seasons?</Td>
<Tr bgcolor="##deeaf3">
	<Td><input type="checkbox" name="snowy_winter" value=1 <Cfif form.snowy_winter eq 1>checked </cfif>  />Cold, snowy winters </Td>
    <Td><input type="checkbox"  name="rainy_winter" value=1 <Cfif form.rainy_winter eq 1>checked </cfif>/>Mild, rainy winters</Td>
    <Td><input type="checkbox" name="hot_summer" value=1 <Cfif form.hot_summer eq 1>checked </cfif>  />Hot Summers</Td>
    <Td><input type="checkbox"  name="mild_summer" value=1 <Cfif form.mild_summer eq 1>checked </cfif>/>Mild Summers</Td>
    <td><input type="checkbox" name="high_hummidity" value=1 <Cfif form.high_hummidity eq 1>checked </cfif> />High Humidity</td>
    <td><input type="checkbox" name="dry_air" value=1 <Cfif form.dry_air eq 1>checked </cfif> />Dry air</td>
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
<cfif #form.neighborhood# is 'upper income'><cfinput type="radio" name="neighborhood"  value="upper income"><cfelse> <cfinput type="radio" name="neighborhood" value="upper income" ></cfif>Urban
<cfif #form.neighborhood# is 'white collar'><cfinput type="radio" name="neighborhood" value="white collar" checked> <cfelse><cfinput type="radio" name="neighborhood" value="white collar"></cfif>Suburban
<cfif #form.neighborhood# is 'blue collar'><cfinput type="radio" name="neighborhood" value="blue collar" checked> <cfelse><cfinput type="radio" name="neighborhood" value="blue collar"></cfif>Rural 
<cfif #form.neighborhood# is 'tradesman'><cfinput type="radio" name="neighborhood" value="tradesman" checked><cfelse><cfinput type="radio" name="neighborhood" value="tradesman"></cfif>Resort<br><br>
		</Td>
    </tr>
    <tr>
    <Tr >
    	<td class="label">
Would you describe the community as:</td>
	</Tr>
    
    	<td>
<cfif #form.community# is 'Urban'><cfinput type="radio" name="community" value="Urban" checked><cfelse><cfinput type="radio" name="community" value="Urban"  > </cfif>Urban
<cfif #form.community# is 'suburban'><cfinput type="radio" name="community" value="suburban" checked><cfelse><cfinput type="radio" name="community" value="suburban"></cfif>Suburban
<cfif #form.community# is 'small'><cfinput type="radio" name="community" value="small" checked><cfelse><cfinput type="radio" name="community" value="small"></cfif>Small Town
<cfif #form.community# is 'rural'><cfinput type="radio" name="community" value="rural" checked><cfelse><cfinput type="radio" name="community" value="rural"></cfif>Rural
		</td>
	</Tr>
    <Tr bgcolor="##deeaf3">
    	<Td colspan=2>Areas in or near your neighborhood to be avoided</Td>
    </Tr>
    <Tr colspan=2 bgcolor="##deeaf3">
        <td><textarea rows="5" cols=70 name="avoidArea">#form.avoidArea#</textarea></td>
    </Tr>
    <tr>
    	<td class="label">
 The terrain of your community is (<strong><em>please select one from each row</em></strong>):
 		</td>
    </tr>
    <tr>
    	<td>
             <table border=0 cellpadding="4" cellspacing=0>
                <tr>
                    <Td><cfif #form.terrain1# is 'flat'><cfinput type="radio"  name="terrain1" value="flat" checked><cfelse><cfinput type="radio" name="terrain1" value="flat" ></cfif>Flat</td>
                    <td><cfif #form.terrain1# is 'hilly'> <cfinput type="radio" name="terrain1" value="hilly" checked><cfelse><cfinput type="radio" name="terrain1" value="hilly"></cfif>Hilly</td> <td colspan=2></td>
                    </tr>
                    <tr bgcolor="##deeaf3">
                    

                    <td><cfif #form.terrain2# is 'trees'> <cfinput type="radio" name="terrain2" value="trees" checked><cfelse><cfinput type="radio" name="terrain2" value="trees"></cfif>Trees</td><td><cfif #form.terrain2# is 'notrees'><cfinput type="radio" name="terrain2" value="notrees" checked><cfelse><cfinput type="radio" name="terrain2" value="notrees"></cfif>No Trees</td><td colspan=2></td>
                </tr>
                 <tr>
                    <td><cfif #form.terrain3# is 'ocean'><cfinput type="radio" name="terrain3" value="ocean" checked><cfelse><cfinput type="radio" name="terrain3" value="ocean"></cfif>Ocean</td>
                    <td><cfif #form.terrain3# is 'lakeside'> <cfinput type="radio" name="terrain3" value="lakeside" checked><cfelse> <cfinput type="radio" name="terrain3" value="lakeside"></cfif>Lakeside</td>
                    <td><cfif #form.terrain3# is 'riverside'><cfinput type="radio" name="terrain3" value="riverside" checked><cfelse><cfinput type="radio" name="terrain3" value="riverside"></cfif>Riverside </td>
                    <td><cfif #form.terrain3# is 'other'> <cfinput type="radio" name="terrain3" value="other" checked>Other <cfinput type="text" name="terrain3_desc" size=10 value="#form.terrain3_desc#"><cfelse><cfinput type="radio" name="terrain3" value="other">Other <cfinput type="text" name="terrain3_desc" size=10></cfif></td>
                </tr>
            </table>
   </td>
  </tr>
 </table>

<h2>Misc. Info</h2>
 <table  width=100% cellspacing=0 cellpadding=2 class="border">
 	<tr bgcolor="##deeaf3">
		
<td class="label" colspan=2>
Indicate particular clothes, sports equipment, etc. that your student should consider bringing:</td>
	</tr>
    <tr bgcolor="##deeaf3">
    	<td>
<textarea cols="50" rows="4" name="special_cloths" wrap="VIRTUAL" placeholder="Winter coat, swimsuites, hiking boots, etc"><cfoutput>#form.special_cloths#</cfoutput></textarea></td>	
	</tr>
    <tr>
    	<td>
Describe the points of interest in your  area:</td>
	</tr>
    <tr>
    	<Td>
        
<textarea cols="50" rows="4" name="point_interest" wrap="VIRTUAL" placeholder="Parks, museums, historical sites, local attractions"><cfoutput>#form.point_interest#</cfoutput></textarea><br>
		</Td>
    </tr>
 </table>
      <br />
<hr width=80% align="center" height=1px />
<cfinclude template="updateInfoInclude.cfm">
</cfform>




<cfinclude template="approveDenyButtonsInclude.cfm">

</cfoutput>

	 <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
  <script src="chosen/chosen.jquery.js" type="text/javascript"></script>
  <script type="text/javascript"> $(".chzn-select").chosen(); $(".chzn-select-deselect").chosen({allow_single_deselect:true}); </script>
