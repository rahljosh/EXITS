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
    <cfparam name="FORM.population" default="">
    <cfparam name="FORM.cityWebsite" default="">
    <cfparam name="FORM.nearbigCity" default="">
    <cfparam name="FORM.major_air_code" default="">
    <cfparam name="FORM.wintertemp" default="">
    <cfparam name="FORM.summertemp" default="">
    <cfparam name="FORM.snowy_winter" default="">
    <cfparam name="FORM.rainy_winter" default="">
    <cfparam name="FORM.hot_summer" default="">
    <cfparam name="FORM.mild_summer" default="">
    <cfparam name="FORM.high_hummidity" default="">
    <cfparam name="FORM.dry_air" default="">
    <cfparam name="FORM.neighborhood" default="">
    <cfparam name="FORM.community" default="">
    <cfparam name="FORM.avoidArea" default="">
    <cfparam name="FORM.terrain1" default="">
    <cfparam name="FORM.terrain2" default="">
    <cfparam name="FORM.terrain3" default="">
    <cfparam name="FORM.terrain3_desc" default="">
    <cfparam name="FORM.special_cloths" default="">
    <cfparam name="FORM.point_interest" default="">
    
    <cfquery name="qGetAirportList" datasource="#APPLICATION.DSN.Source#">
        SELECT
        	*
        FROM 
        	smg_airports
    </cfquery>

	<cfquery name="qGetCityState" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	*
        FROM 
        	smg.smg_citystate
        WHERE 
        	population > <cfqueryparam cfsqltype="cf_sql_integer" value="30000">
    </cfquery>

	<!--- FORM Submitted --->
	<cfif VAL(FORM.submitted)>
    
		<cfscript>
            // Data Validation

            // nearbigCity
            if( NOT LEN(TRIM(FORM.nearbigCity)) ) {
                SESSION.formErrors.Add("Please indicate the nearest town over 30,000 people.");
            }

			// city website
            if( NOT LEN(TRIM(FORM.cityWebsite)) ) {
                SESSION.formErrors.Add("Please indicate your city/town website.");
            }
			
			// major_air_code
            if( NOT LEN(TRIM(FORM.major_air_code)) ) {
                SESSION.formErrors.Add("Please indicate your major airport code.");
            }

			// wintertemp
            if( NOT LEN(TRIM(FORM.wintertemp)) ) {
                SESSION.formErrors.Add("Please indicate the average winter temp.");
            }

			// summertemp
            if( NOT LEN(TRIM(FORM.summertemp)) ) {
                SESSION.formErrors.Add("Please indicate the average summer temp.");
            }
			
			// neighborhood            
            if( NOT LEN(TRIM(FORM.neighborhood)) ) {
                SESSION.formErrors.Add("Please describe your neighborhood.");
            }

			// community
            if( NOT LEN(TRIM(FORM.community)) ) {
                SESSION.formErrors.Add("Please describe your community.");
            }

            // avoidarea
            if( NOT LEN(TRIM(FORM.avoidarea)) ) {
                SESSION.formErrors.Add("Please indicate if there are or are not areas to be avoided in your neighborhood.");
            }

			// special_cloths
            if( NOT LEN(TRIM(FORM.special_cloths)) ) {
                SESSION.formErrors.Add("Please provide a list of any special clothes to bring.");
            }

			// point_interest
            //if( NOT LEN(TRIM(FORM.point_interest)) ) {
            //    SESSION.formErrors.Add("Please indicate any interests in your area.");
          //  }
        </cfscript>
    
		<cfif NOT SESSION.formErrors.length()>
        
			<cfscript>
				// Calculate Distance
				vCityDistance = APPLICATION.CFC.udf.calculateAddressDistance(
					origin='#qGetHostFamilyInfo.city# #qGetHostFamilyInfo.state# #qGetHostFamilyInfo.zip#', 
					destination=FORM.nearbigCity
				);
        	</cfscript>
	<cfif cgi.REMOTE_HOST eq '184.155.135.147'>
    <cfoutput>
    	#vCityDistance#
      
    </cfoutput>
    </cfif>
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                	smg_hosts
                SET 
                    population = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.population#">,
                    cityWebsite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cityWebsite#">,
                    <Cfif val(vCityDistance)>
                    near_city_dist = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vCityDistance#">,
                    </Cfif>
                    nearbigCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(FORM.nearbigCity, 255)#">,
                    major_air_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.major_air_code#">,
                    wintertemp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wintertemp#">,
                    summertemp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.summertemp#">,
                    snowy_winter = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.snowy_winter)#">,
                    rainy_winter = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.rainy_winter)#">,
                    hot_summer = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.hot_summer)#">,
                    mild_summer = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.mild_summer)#">,
                    high_hummidity = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.high_hummidity)#">,
                    dry_air = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.dry_air)#">,
                    neighborhood = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.neighborhood#">,
                    community = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.community#">,
                    avoidArea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(FORM.avoidArea, 255)#">,
                    terrain1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.terrain1#">,
                    terrain2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.terrain2#">,
                    terrain3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.terrain3#">,
                    terrain3_desc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.terrain3_desc#">,
                    special_cloths = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.special_cloths#">,
                    point_interest = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.point_interest#">
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
			FORM.population = qGetHostFamilyInfo.population;
			FORM.cityWebsite = qGetHostFamilyInfo.cityWebsite;
			FORM.near_city_dist = qGetHostFamilyInfo.near_city_dist;
			FORM.nearbigCity = qGetHostFamilyInfo.nearbigcity;
			FORM.major_air_code = qGetHostFamilyInfo.major_air_code;
			FORM.wintertemp = qGetHostFamilyInfo.wintertemp;
			FORM.summertemp = qGetHostFamilyInfo.summertemp;
			FORM.snowy_winter = qGetHostFamilyInfo.snowy_winter;
			FORM.rainy_winter = qGetHostFamilyInfo.rainy_winter;
			FORM.hot_summer = qGetHostFamilyInfo.hot_summer;
			FORM.mild_summer = qGetHostFamilyInfo.mild_summer;
			FORM.high_hummidity = qGetHostFamilyInfo.high_hummidity;
			FORM.dry_air = qGetHostFamilyInfo.dry_air;
			FORM.neighborhood = qGetHostFamilyInfo.neighborhood;
			FORM.community = qGetHostFamilyInfo.community;
			FORM.avoidarea = qGetHostFamilyInfo.avoidarea;
			FORM.terrain1 = qGetHostFamilyInfo.terrain1;
			FORM.terrain2 = qGetHostFamilyInfo.terrain2;
			FORM.terrain3 = qGetHostFamilyInfo.terrain3;
			FORM.terrain3_desc = qGetHostFamilyInfo.terrain3_desc;  
			FORM.special_cloths = qGetHostFamilyInfo.special_cloths;
			FORM.point_interest = qGetHostFamilyInfo.point_interest;
        </cfscript>
        
    </cfif>
    
    <!---- Attempt to get major airport --->
    <cfif NOT LEN(FORM.major_air_code)>
    
        <cfquery name="qGuessMajorAirport" datasource="#APPLICATION.DSN.Source#">
            SELECT 
            	major_air_code
            FROM 
            	smg_hosts
            WHERE 
            	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostFamilyInfo.city#">
            AND 
            	state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostFamilyInfo.state#">
            AND
            	major_air_code != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            LIMIT 1
        </cfquery>

        <cfscript>
			if ( qGuessMajorAirport.recordcount ) {
        		FORM.major_air_code = qGuessMajorAirport.major_air_code;
			}
        </cfscript>
        
    </cfif>
    
    <!---- Attempt to get local population --->
    <cfif NOT VAL(FORM.population)>
    
        <cfquery name="qGetPopulation" datasource="#APPLICATION.DSN.Source#">
            SELECT 
            	population
            FROM 
            	smg.smg_citystate
            WHERE 
            	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostFamilyInfo.city#">
            AND 
            	state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostFamilyInfo.state#">
        </cfquery>
    	
        <cfscript>
			if ( qGetPopulation.recordcount ) {
				FORM.population = NumberFormat(qGetPopulation.population, '__,___');
			}
		</cfscript>
        
    </cfif>
    
    <!---- Attempt to get local weather --->
    <cfif NOT VAL(FORM.wintertemp)>
    
    	<cfquery name="qGetWeather" datasource="#APPLICATION.DSN.Source#">
            SELECT 
            	wintertemp, 
                summertemp, 
                snowy_winter,
                terrain2,
                terrain1, 
                terrain3, 
                rainy_winter, 
                hot_summer, 
                mild_summer, 
                high_hummidity, 
                dry_air, 
                terrain3_desc 		
            FROM 
            	smg_hosts
            WHERE 
            	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostFamilyInfo.city#">
            AND 
            	state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostFamilyInfo.state#">
            AND 
            	summertemp != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            LIMIT 1
        </cfquery>
    
		<cfscript>
            if (qGetWeather.recordcount) {
        
                FORM.summertemp = qGetWeather.summertemp;
                FORM.terrain3_desc = qGetWeather.terrain3_desc;  
                FORM.wintertemp = qGetWeather.wintertemp;
                FORM.snowy_winter = qGetWeather.snowy_winter;
                FORM.rainy_winter = qGetWeather.rainy_winter;
                FORM.hot_summer = qGetWeather.hot_summer;
                FORM.mild_summer = qGetWeather.mild_summer;
                FORM.high_hummidity = qGetWeather.high_hummidity;
                FORM.dry_air = qGetWeather.dry_air;
            }
        </cfscript>
        
    </cfif>
    
    <!---- Attempt to get point interest --->
    <cfif NOT LEN(FORM.point_interest)>
    
        <cfquery name="qGetPointInterest" datasource="#APPLICATION.DSN.Source#">
            SELECT 
            	point_interest 		
            FROM 
            	smg_hosts
            WHERE 
            	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostFamilyInfo.city#">
            AND 
            	state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostFamilyInfo.state#">
            AND 
            	point_interest != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            LIMIT 1
        </cfquery>
        
        <cfscript>
			if ( qGetPointInterest.recordcount ) {
				FORM.point_interest = qGetPointInterest.point_interest;
			}
		</cfscript>

    </cfif>

</cfsilent>

<script type="text/javascript">
	$(document).ready(function(){
		$(".chzn-select").chosen(); 
		$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
	});
</script>

<cfoutput>

    <h2>Community Profile - #qGetHostFamilyInfo.city#, #qGetHostFamilyInfo.state#</h2>

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

    <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input type="hidden" name="submitted" value="1" />
        
        <table width="100%" cellspacing="0" cellpadding="2">
            <tr>
            	<td align="left">
	                <span class="required">* Required fields</span>
                </td>
                <td align="right">
                    <a href="http://en.wikipedia.org/wiki/#qGetHostFamilyInfo.city#,_#qGetHostFamilyInfo.state#" target="_new">Need more info on #qGetHostFamilyInfo.city#?</a>
                </td>
			</tr>                
		</table>

        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">	
                <td width="30%">Population of #qGetHostFamilyInfo.city# :</td>
                <td class="form_text"><input type="text" name="population" value="#FORM.population#" class="largeField" maxlength="45"/></td>
            </tr>
            <tr>	
                <td>City or Town Website: <span class="required">*</span></td>
                <td class="form_text"><input type="text" name="cityWebsite" value="#FORM.cityWebsite#" class="xxLargeField" maxlength="200"/></td>
            </tr>
            <tr bgcolor="##deeaf3">
            	<td class="label">Nearest Major City: <span class="required">*</span></td>
                <td class="form_text">
                    <select name="nearbigCity" data-placeholder="Enter nearest large city (over 30,000)" class="chzn-select xxLargeField" tabindex="2" onchange="this.FORM.submit(closeCity);">
                        <option value=""></option>
                        <cfloop query="qGetCityState">
                            <option value="#city#, #state#" <cfif FORM.nearbigCity EQ '#city#, #state#'>selected</cfif>>#city#, #state# - (pop: #NumberFormat(population, '__,___')#)</option>
                        </cfloop>
                    </select>
	            </td>
            </tr>
        </table> <br />

        <h3>Airports</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3" >
                <td  width="30%" class="label">Major Airport: <span class="required">*</span></td>
                <td class="form_text">
                    <select name="major_air_code" data-placeholder="Enter City, Airport or Airport Code" class="chzn-select xxxLargeField" tabindex="2">
                        <option value=""></option>
                        <cfloop query="qGetAirportList">
                            <option value="#airCode#" <cfif FORM.major_air_code eq airCode>selected</cfif>>#aircode# - #airportName# - #city#, #state#</option>
                        </cfloop>
                    </select>
				</td>                    
            </tr>
        </table> <br />
        
        <h3>Climate</h3>
        
        <table  width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label" colspan="2">Avg temp in winter: <span class="required">*</span></td>
                <td class="form_text" colspan="4"><input type="text" size="3" name="wintertemp" value="#FORM.wintertemp#" maxlength="6"><sup>o</sup>F</td>
            </tr>
            <tr>
                <td class="label" colspan="2">Avg temp in summer: <span class="required">*</span></td>
                <td class="form_text" colspan="4"><input type="text" size="3" name="summertemp" value="#FORM.summertemp#" maxlength="6"><sup>o</sup>F</td>
            </tr>
            <tr>
                <td colspan="6"  bgcolor="##deeaf3">How would you describe your seasons?</td>
           	</tr>
            <tr bgcolor="##deeaf3">
                <td><input type="checkbox" name="snowy_winter" id="snowy_winter" value="1" <cfif FORM.snowy_winter EQ 1> checked="checked" </cfif>  /> <label for="snowy_winter">Cold, snowy winters</label></td>
                <td><input type="checkbox"  name="rainy_winter" id="rainy_winter" value="1" <cfif FORM.rainy_winter EQ 1> checked="checked" </cfif>/> <label for="rainy_winter">Mild, rainy winters</label></td>
                <td><input type="checkbox" name="hot_summer" id="hot_summer" value="1" <cfif FORM.hot_summer EQ 1> checked="checked" </cfif>  /> <label for="hot_summer">Hot Summers</label></td>
                <td><input type="checkbox"  name="mild_summer" id="mild_summer" value="1" <cfif FORM.mild_summer EQ 1> checked="checked" </cfif>/> <label for="mild_summer">Mild Summers</label></td>
                <td><input type="checkbox" name="high_hummidity" id="high_hummidity" value="1" <cfif FORM.high_hummidity EQ 1> checked="checked" </cfif> /> <label for="high_hummidity">High Humidity</label></td>
                <td><input type="checkbox" name="dry_air" id="dry_air" value="1" <cfif FORM.dry_air EQ 1> checked="checked" </cfif> /> <label for="dry_air">Dry air</label></td>
			</tr>            
        </table> <br />
        
        <h3>Neighborhood & Terrain</h3>
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr  bgcolor="##deeaf3">
            	<td class="label">You would describe your neighborhood as: <span class="required">*</span></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td>
                	<input type="radio" name="neighborhood" id="neighborhoodUrban" value="urban" <cfif FORM.neighborhood EQ "urban"> checked="checked" </cfif> /> <label for="neighborhoodUrban">Urban</label>
                    <input type="radio" name="neighborhood" id="neighborhoodSuburban" value="suburban" <cfif FORM.neighborhood EQ "suburban"> checked="checked" </cfif> /> <label for="neighborhoodSuburban">Suburban</label>
                    <input type="radio" name="neighborhood" id="neighborhoodRural" value="rural" <cfif FORM.neighborhood EQ "rural"> checked="checked" </cfif> /> <label for="neighborhoodRural">Rural</label>
                    <input type="radio" name="neighborhood" id="neighborhoodResort" value="resort" <cfif FORM.neighborhood EQ "resort"> checked="checked" </cfif> /> <label for="neighborhoodResort">Resort</label>
                </td>
            </tr>
            <tr>
                <td class="label">Would you describe the community as: <span class="required">*</span></td>
            </tr>
       		<tr>
                <td>
                	<input type="radio" name="community" id="communityUrban" value="urban" <cfif FORM.community EQ "urban"> checked="checked" </cfif> /> <label for="communityUrban">Urban</label>
                    <input type="radio" name="community" id="communitySuburban" value="suburban" <cfif FORM.community EQ "suburban"> checked="checked" </cfif> /> <label for="communitySuburban">Suburban</label>
                    <input type="radio" name="community" id="communitySmallTown" value="small" <cfif FORM.community EQ "small"> checked="checked" </cfif> /> <label for="communitySmallTown">Small Town</label>
                    <input type="radio" name="community" id="communityRural" value="rural" <cfif FORM.community EQ "rural"> checked="checked" </cfif> /> <label for="communityRural">Rural</label>
                </td>
        	</tr>
            <tr bgcolor="##deeaf3">
            	<td colspan="2">Areas in or near your neighborhood to be avoided: <span class="required">*</span></td>
            </tr>
            <tr colspan="2" bgcolor="##deeaf3">
                <td><textarea rows="5" cols="70" name="avoidArea">#FORM.avoidArea#</textarea></td>
            </tr>
            <tr>
	            <td class="label">The terrain of your community is (<strong><em>please select one from each row</em></strong>):</td>
            </tr>
            <tr>
            	<td colspan="2">
                    <table width="100%" cellspacing="0" cellpadding="4">           
                        <tr>
                            <td><input type="radio" name="terrain1" id="terrain1Flat" value="flat" <cfif FORM.terrain1 EQ "flat"> checked="checked" </cfif> /> <label for="terrain1Flat">Flat</label></td>
                            <td><input type="radio" name="terrain1" id="terrain1Hilly" value="hilly" <cfif FORM.terrain1 EQ "hilly"> checked="checked" </cfif> /> <label for="terrain1Hilly">Hilly</label></td>
                        </tr>
                        <tr bgcolor="##deeaf3">
                            <td><input type="radio" name="terrain2" id="terrain2Flat" value="trees" <cfif FORM.terrain2 EQ "trees"> checked="checked" </cfif> /> <label for="terrain2Flat">Trees</label></td>
                            <td colspan="4"><input type="radio" name="terrain2" id="terrain2Hilly" value="notrees" <cfif FORM.terrain2 EQ "notrees"> checked="checked" </cfif> /> <label for="terrain2Hilly">No Trees</label></td>
                        </tr>
                        <tr>
                            <td><input type="radio" name="terrain3" id="terrain3Ocean" value="ocean" <cfif FORM.terrain3 EQ "ocean"> checked="checked" </cfif> /> <label for="terrain3Ocean">Ocean</label></td>
                            <td><input type="radio" name="terrain3" id="terrain3Lakeside" value="lakeside" <cfif FORM.terrain3 EQ "lakeside"> checked="checked" </cfif> /> <label for="terrain3Lakeside">Lakeside</label></td>
                            <td><input type="radio" name="terrain3" id="terrain3Riverside" value="riverside" <cfif FORM.terrain3 EQ "riverside"> checked="checked" </cfif> /> <label for="terrain3Riverside">Riverside</label></td>
                            <td><input type="radio" name="terrain3" id="terrain3Other" value="other" <cfif FORM.terrain3 EQ "other"> checked="checked" </cfif> /> <label for="terrain3Other">Other</label></td>
                            <td><input type="text" name="terrain3_desc" class="largeField" value="#FORM.terrain3_desc#" maxlength="100"></td>                            
                        </tr>
					</table>
				</td>
			</tr>                                                    
        </table> <br />
        
        <h3>Miscellaneous Info</h3>
        
        <table  width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td class="label" colspan="2">Indicate particular clothes, sports equipment, etc. that your student should consider bringing: <span class="required">*</span></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td><textarea cols="50" rows="4" name="special_cloths" placeholder="Winter coat, swimsuites, hiking boots, etc">#FORM.special_cloths#</textarea></td>	
            </tr>
            <tr>
                <td>Describe the points of interest in your area:</td>
            </tr>
            <tr>
                <td><textarea cols="50" rows="4" name="point_interest" placeholder="Parks, museums, historical sites, local attractions">#FORM.point_interest#</textarea></td>
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
        
    </form>

</cfoutput>