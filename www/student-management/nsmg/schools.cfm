<cfif client.usertype EQ 9>
	You do not have access to Schools.
    <cfabort>
</cfif>

<cfparam name="submitted" default="0">
<cfparam name="stateShort" default="">
<cfparam name="keyword" default="">
<cfparam name="school_dates" default="">
<cfparam name="orderBy" default="schoolname">
<cfparam name="recordsToShow" default="25">
<script src="linked/js/jquery.colorbox.js"></script>
	<!----open window details---->
	<script>
        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            
            $(".iframe").colorbox({width:"60%", height:"60%", iframe:true, 
            
               onClosed:function(){ location.reload(true); } });

        });
    </script>
<Cfscript>

if (CLIENT.companyid eq 13){
			// Get Province List
			qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState(country='CA');
		}else{
			// Get State List
			qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
		}
</cfscript>		
<!----
<cfquery name="qGetStateList" datasource="#APPLICATION.dsn#">
    SELECT DISTINCT 
    	state
    FROM 
    	smg_schools
    ORDER BY 
    	state
</cfquery>
---->
<!--- default state to user's state. --->
<cfif NOT LEN(stateShort) AND client.companyid NEQ 13>

    <cfquery name="qGetUserState" datasource="#APPLICATION.dsn#">
        SELECT 
        	u.state
        FROM 
        	smg_users u
		INNER JOIN
        	smg_states s ON s.state = u.state          
        WHERE 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
	
	<cfscript>
		if (qGetUserState.recordCount) {
			stateShort = qGetUserState.state;
		}
	</cfscript>

</cfif>
<cfquery name="currentSeason" datasource="#APPLICATION.dsn#">
	SELECT seasonID, season
    FROM smg_seasons
    WHERE <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#"> BETWEEN startDate AND ADDDATE(endDate, 31)
</cfquery>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
        <td background="pics/header_background.gif"><h2>Schools</h2></td>
        <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=forms/school_form">Add School</a></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfoutput>

<form action="?curdoc=schools" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
        <td>
            State<br />
			<select name="stateShort" id="stateShort">
            	<option value="ALL" <cfif NOT LEN(stateShort) OR stateShort is 'ALL'> selected="selected" </cfif>>All</option>
            	<cfloop query="qGetStateList">
                    <option value="#qGetStateList.state#" <cfif qGetStateList.state EQ stateShort> selected="selected" </cfif> >#qGetStateList.state#</option>
                </cfloop>
            </select>
        </td>
        <td>
            Keyword / ID<br />
			<input type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
        </td>
        <td>
            School Dates<br />
			<select name="school_dates">
				<option value="">All</option>
				<option <cfif school_dates EQ 'Unassigned'>selected</cfif>>Unassigned</option>
			</select>            
        </td>
        <td>
            Order By<br />
            <select name="orderBy">
                <option value="schoolid" <cfif orderBy EQ 'schoolid'>selected</cfif>>ID</option>
                <option value="schoolname" <cfif orderBy EQ 'schoolname'>selected</cfif>>School Name</option>
                <option value="principal" <cfif orderBy EQ 'principal'>selected</cfif>>Contact</option>
                <option value="city" <cfif orderBy EQ 'city'>selected</cfif>>City</option>
                <option value="state" <cfif orderBy EQ 'state'>selected</cfif>>State</option>
                <option value="noStudentsThisYear" <cfif orderBy EQ 'noStudentsThisYear'>selected</cfif>>No. Students Currently</option>
                <option value="noStudentsNextYear" <cfif orderBy EQ 'noStudentsNextYear'>selected</cfif>>No. Students Upcoming</option>
            </select>            
        </td>
        <td>
            Records Per Page<br />
            <select name="recordsToShow">
                <option <cfif recordsToShow EQ 25>selected</cfif>>25</option>
                <option <cfif recordsToShow EQ 50>selected</cfif>>50</option>
                <option <cfif recordsToShow EQ 100>selected</cfif>>100</option>
                <option <cfif recordsToShow EQ 250>selected</cfif>>250</option>
                <option <cfif recordsToShow EQ 500>selected</cfif>>500</option>
            </select>            
        </td>
    </tr>
</table>
</form>

</cfoutput>

<cfif submitted>
	<cfquery name="currentSeasonPrograms" datasource="#APPLICATION.dsn#">
    select programid
    from smg_programs where seasonid = <cfqueryparam value="#currentSeason.seasonid#" cfsqltype="cf_sql_integer">
    and companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(APPLICATION.SETTINGS.COMPANYLIST.ISESMG)#" list="yes"> )
    </cfquery>
    <cfset programList = "">
   
   <Cfloop query="currentSeasonPrograms">
    	<cfset programList = listAppend(programList, #programID#)>
    </Cfloop>
   
  <cfset nextSeason = #currentSeason.seasonid# + 1>
  <cfquery name="nextSeasonPrograms" datasource="#APPLICATION.dsn#">
    select programid
    from smg_programs where seasonid = <cfqueryparam value="#nextSeason#" cfsqltype="cf_sql_integer">
    and companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(APPLICATION.SETTINGS.COMPANYLIST.ISESMG)#" list="yes"> )
    </cfquery>
    <cfset nextProgramList = "">
   
   <Cfloop query="nextSeasonPrograms">
    	<cfset nextProgramList = listAppend(nextProgramList, #programID#)>
    </Cfloop>

  <cfquery name="thisSeasons" datasource="#APPLICATION.dsn#">
  select season from smg_seasons
  where seasonid = <cfqueryparam value="#currentSeason.seasonid#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfquery name="nextSeasons" datasource="#APPLICATION.dsn#">
  select season from smg_seasons
  where seasonid = <cfqueryparam value="#nextSeason#" cfsqltype="cf_sql_integer">
  </cfquery>
 
  
    <cfquery name="getResults" datasource="#APPLICATION.dsn#">
       SELECT DISTINCT 
			s.*, (SELECT count(studentid) as NoStudents
					FROM smg_students
					WHERE schoolid = s.schoolid 
                    AND programID IN ( #programList#)
                    <cfif CLIENT.companyID EQ 10>
                    AND
                        smg_students.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                    <cfelseif CLIENT.companyID EQ 14>
                    AND
                    	smg_students.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                <cfelse>
                    AND
                        smg_students.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                </cfif> )as noStudentsThisYear,
                    (SELECT count(studentid) as NoNextStudents
					FROM smg_students
					WHERE schoolid = s.schoolid 
                    AND programID IN ( #nextProgramList#)
                    <cfif CLIENT.companyID EQ 10>
                    AND
                        smg_students.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                    <cfelseif CLIENT.companyID EQ 14>
                    AND 
                    	smg_students.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                <cfelse>
                    AND
                        smg_students.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                </cfif> )as noStudentsNextYear
        FROM 
        	smg_schools s
       
        WHERE 
        	1=1		
		
		<cfif client.companyid eq 13>
        	AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>
        	AND 
            	s.companyID != <cfqueryparam cfsqltype="cf_sql_integer" value="13"> 
        </cfif>
		
		<cfif (LEN(stateShort) AND stateShort is not 'ALL' ) >
            AND 
            	s.state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stateShort#">
        </cfif>

        <cfif LEN(TRIM(keyword))>
            AND 
            	(
                	s.schoolid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(keyword)#">
                OR 
                	s.schoolname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                OR 
                	s.principal LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                OR 
                	s.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
                OR 
                	s.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(keyword)#%">
            	)
        </cfif>
        
		<cfif LEN(school_dates)>
            AND 
            	scd.schoolid IS NULL
        </cfif>
     
        ORDER BY
            <cfif ListFind("schoolid,schoolname,principal,city,state,noStudentsThisYear,noStudentsNextYear", orderBy)>
            	#orderBy#
            <cfelse>
            	s.schoolname
            </cfif>
            <cfif orderBy is 'noStudentsThisYear' or orderBy is 'noStudentsNextYear'>
            desc
            </cfif>
           
    
    </cfquery>


	<cfif getResults.recordCount GT 0>

		<cfparam name="url.startPage" default="1">
		<cfset totalPages = ceiling(getResults.recordCount / recordsToShow)>
		<cfset startrow = 1 + ((url.startPage - 1) * recordsToShow)>
		<cfif getResults.recordCount GT url.startPage * recordsToShow>
			<cfset isNextPage = 1>
			<cfset endrow = url.startPage * recordsToShow>
		<cfelse>
			<cfset isNextPage = 0>
			<cfset endrow = getResults.recordCount>
		</cfif>
		<cfset urlVariables = "submitted=1&stateShort=#stateShort#&keyword=#urlEncodedFormat(keyword)#&school_dates=#school_dates#&orderBy=#orderBy#&recordsToShow=#recordsToShow#">
    
        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="?curdoc=schools&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="?curdoc=schools&startPage=#i#&#urlVariables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="?curdoc=schools&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                        </cfif>
                        <br>
                    </cfif>
                    Displaying #startrow# to #endrow# of #getResults.recordCount#
              </td>
            </tr>
        </table>

        <table width=100% class="section" border=0>
          <tr align="left" style="font-weight:bold;">
                <td colspan=2></td>
                
                <td colspan=2 align="center">Enrollment</td>
                <td colspan=3></td>
              
            </tr>
            <tr align="left" style="font-weight:bold;">
                <td>ID</td>
                <td>School Name</td>
                <td align="center">#thisSeasons.season#</td>
                <td align="center">#nextSeasons.season#</td>
                <td>Contact</td>
                <td>City</td>
                <td>State</td>
            </tr>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
                
               
                
             
            <tr bgcolor="###iif(currentRow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                <td><a href="?curdoc=school_info&schoolid=#schoolid#">#schoolid#</a></td>
                <td><a href="?curdoc=school_info&schoolid=#schoolid#">#schoolname#</a></td>
                <td align="center">#noStudentsThisYear#
                  <cfif noStudentsThisYear gte 5>
              <cfquery name="dateInfo" datasource="#APPLICATION.dsn#">
                    select fiveStudentAssigned
                    from smg_school_dates
                    where schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#schoolid#">
                    and seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentSeason.seasonid#">
                    </cfquery>
                     <cfquery name="docUploaded" datasource="#APPLICATION.dsn#">
                    select dateCreated
                    from document
                    where foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#schoolid#">
                    and seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentSeason.seasonid#">
                    and documenttypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="44">
                    </cfquery>
                    
                     <cfscript>	
						// Get the letter info
						qGetSchoolDocs = APPCFC.DOCUMENT.getDocuments(foreignTable='school_info',foreignid=schoolid,seasonid=currentSeason.seasonid);
				 	</cfscript>
						<cfif qGetSchoolDocs.recordcount eq 0>
                        	<a class='iframe' href="schoolInfo/fifthStudentLetter.cfm?schoolid=#schoolid#&season=#currentSeason.seasonid#&seasonLabel=#currentSeason.season#&letterDate=#DateFormat(dateInfo.fiveStudentAssigned, 'mm/dd/yyyy')#">
                         <cfif docUploaded.recordcount eq 0>   	
                            	<img src="pics/warning.png" height=10 border=0 /></a>
                         <cfelse>
                         <img src="pics/valid.png" border=0 />
                         </cfif>
                         </cfif>
                     </cfif>
					
                </td>
                <Td align="center">#noStudentsNextYear#
          <cfif noStudentsNextYear gte 5>
                    <cfquery name="dateInfo" datasource="#APPLICATION.dsn#">
                    select fiveStudentAssigned
                    from smg_school_dates
                    where schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#schoolid#">
                    and seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#nextSeason#">
                    </cfquery>
                      <cfquery name="docUploaded" datasource="#APPLICATION.dsn#">
                    select dateCreated
                    from document
                    where foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#schoolid#">
                    and seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#nextSeason#">
                    and documenttypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="44">
                    </cfquery>
                    
                     <cfscript>	
						// Get the letter info
						qGetSchoolDocs = APPCFC.DOCUMENT.getDocuments(foreignTable='school_info',foreignid=schoolid,seasonid=currentSeason.seasonid);
				 	</cfscript>
						<cfif qGetSchoolDocs.recordcount eq 0>
                        	<a class='iframe' href="schoolInfo/fifthStudentLetter.cfm?schoolid=#schoolid#&season=#nextSeason#&seasonLabel=#currentSeason.season#&letterDate=#DateFormat(dateInfo.fiveStudentAssigned, 'mm/dd/yyyy')#">
                         <cfif docUploaded.recordcount eq 0>   	
                            	<img src="pics/warning.png" height=10 border=0 /></a>
                         <cfelse>
                         		<img src="pics/valid.png" border=0 />
                         </cfif>
                         </cfif>
                     </cfif>
                
                </Td>
                <td>#principal#</td>
                <td>#city#</td>
                <td>#state#</td>
            </tr>
            </cfloop>
        </table>
               
        </cfoutput>
	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td>No schools matched your criteria.</td>
            </tr>
        </table>
    </cfif>

</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

