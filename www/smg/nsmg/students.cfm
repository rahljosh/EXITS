<cfparam name="submitted" default="0">
<cfparam name="regionid" default="#client.regionid#">
<cfparam name="keyword" default="">

<cfif client.usertype GT 4>
	<!--- Field --->
    <cfparam name="placed" default="0">
    <cfparam name="cancelled" default="0">
    <cfparam name="active" default="1">    
<cfelse>
	<!--- Office USERS --->
	<cfparam name="placed" default="">
    <cfparam name="cancelled" default="">
    <cfparam name="active" default="">
</cfif>

<cfparam name="orderby" default="familylastname">
<cfparam name="recordsToShow" default="25">
<!--- advanced search items. --->
<cfparam name="adv_search" default="0">
<cfparam name="familylastname" default="">
<cfparam name="firstname" default="">
<cfparam name="preayp" default="">
<cfparam name="direct" default="">
<cfparam name="age" default="">
<cfparam name="sex" default="">
<cfparam name="grade" default="">
<cfparam name="graduate" default="">
<cfparam name="religionid" default="">
<cfparam name="interestid" default="">
<cfparam name="sports" default="">
<cfparam name="interests_other" default="">
<cfparam name="countryid" default="">
<cfparam name="intrep" default="">
<cfparam name="stateid" default="">
<cfparam name="programID" default="">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor="#ffffff">
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=30 background="pics/header_background.gif"><img src="pics/family.gif"></td>
        <td background="pics/header_background.gif"><h2>Students</h2></td>
        <td background="pics/header_background.gif" align="right">
        	<cfif adv_search>
        		<a href="index.cfm?curdoc=students&adv_search=0">Hide Advanced Search</a>
            <cfelse>
        		<a href="index.cfm?curdoc=students&adv_search=1">Advanced Search</a>
            </cfif>
        </td>
    	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=students" method="post">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="adv_search" value="#adv_search#">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td>
        
<table border=0 cellpadding=4 cellspacing=0 width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
	<cfif client.usertype LTE 4>
        <td>
			<!--- GET ALL REGIONS --->
            <cfquery name="list_regions" datasource="#application.dsn#">
                SELECT regionid, regionname
                FROM smg_regions
                WHERE company = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                	AND subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    AND active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                ORDER BY regionname
            </cfquery>
            Region<br />
            <cfif client.usertype LTE 4>
                <cfselect name="regionid" query="list_regions" value="regionid" display="regionname" queryPosition="below">
                    <option value="" selected="selected">All</option>
                </cfselect>
            <cfelse>
                <cfselect name="regionid" query="list_regions" value="regionid" display="regionname" selected="#regionid#" queryPosition="below">
                    <option value="">All</option>
                </cfselect>
            </cfif>
        </td>
	</cfif>
        <td>
            Keyword / ID<br />
			<cfinput type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
        </td>
	<cfif client.usertype NEQ 9>
        <td>
            Placed<br />
			<select name="placed">
            	<cfif client.usertype LTE 4>
					<option value="">All</option>
                </cfif>
				<option value="1" <cfif placed EQ 1>selected</cfif>>Yes</option>
				<option value="0" <cfif placed EQ 0>selected</cfif>>No</option>
			</select>            
        </td>
	</cfif>
	<cfif client.usertype LTE 4>
        <td>
            Cancelled<br />
			<select name="cancelled">
				<option value="">All</option>
				<option value="1" <cfif cancelled EQ 1>selected</cfif>>Yes</option>
				<option value="0" <cfif cancelled EQ 0>selected</cfif>>No</option>
			</select>
            
        </td>
        <td>
            Active<br />
			<select name="active">
				<option value="">All</option>
				<option value="1" <cfif active EQ 1>selected</cfif>>Yes</option>
				<option value="0" <cfif active EQ 0>selected</cfif>>No</option>
			</select>            
        </td>
	</cfif>
        <td>
            Order By<br />
            <select name="orderby">
                <option value="studentid" <cfif orderby EQ 'studentid'>selected</cfif>>ID</option>
                <option value="familylastname" <cfif orderby EQ 'familylastname'>selected</cfif>>Last Name</option>
                <option value="firstname" <cfif orderby EQ 'firstname'>selected</cfif>>First Name</option>
                <option value="sex" <cfif orderby EQ 'sex'>selected</cfif>>Sex</option>
                <option value="country" <cfif orderby EQ 'country'>selected</cfif>>Country</option>
                <option value="regionname" <cfif orderby EQ 'regionname'>selected</cfif>>Region</option>
                <option value="s.programID" <cfif orderby EQ 's.programID'>selected</cfif>>Program</option>
                <option value="hostid" <cfif orderby EQ 'hostid'>selected</cfif>>Family</option>
                <cfif client.companyid EQ 5>
	                <option value="companyshort" <cfif orderby EQ 'companyshort'>selected</cfif>>Company</option>
                </cfif>
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

<!--- advanced search. --->
<cfif adv_search>
	<hr align="center" noshade="noshade" size="1" width="95%" />
    <table border=0 cellpadding=4 cellspacing=0 width=100%>
        <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td>
                Last Name<br />
                <cfinput type="text" name="familylastname" value="#familylastname#" size="10" maxlength="50">
            </td>
            <td>
                First Name<br />
                <cfinput type="text" name="firstname" value="#firstname#" size="10" maxlength="50">
            </td>
            <td>
                Pre-AYP<br />
                <select name="preayp">
                    <option value="">All</option>
                    <option value="english" <cfif preayp EQ 'english'>selected</cfif>>English Camp</option>
                    <option value="orient" <cfif preayp EQ 'orient'>selected</cfif>>Orientation Camp</option>
                </select>
            </td>
            <td>
                Direct Placement<br />
                <select name="direct">
                    <option value="">All</option>
                    <option value="1" <cfif direct EQ 1>selected</cfif>>Yes</option>
                    <option value="0" <cfif direct EQ 0>selected</cfif>>No</option>
                </select>            
            </td>
            <td>
                Age<br />
                <select name="age">
                    <option value="">All</option>
                    <option <cfif age EQ 15>selected</cfif>>15</option>
                    <option <cfif age EQ 16>selected</cfif>>16</option>
                    <option <cfif age EQ 17>selected</cfif>>17</option>
                    <option <cfif age EQ 18>selected</cfif>>18</option>
                </select>
            </td>
            <td>
            	Sex<br />
                <select name="sex">
                    <option value="">All</option>
                    <option <cfif sex EQ 'Male'>selected</cfif>>Male</option>
                    <option <cfif sex EQ 'Female'>selected</cfif>>Female</option>
                </select>
            </td>
        </tr>
        <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td>
                Last Grade Completed<br />
                <select name="grade">
                    <option value="">All</option>
                    <option <cfif grade EQ 7>selected</cfif>>7</option>
                    <option <cfif grade EQ 8>selected</cfif>>8</option>
                    <option <cfif grade EQ 9>selected</cfif>>9</option>
                    <option <cfif grade EQ 10>selected</cfif>>10</option>
                    <option <cfif grade EQ 11>selected</cfif>>11</option>
                    <option <cfif grade EQ 12>selected</cfif>>12</option>
                </select>
            </td>
            <td>
                Graduated in Home Country<br />
                <select name="graduate">
                    <option value="">All</option>
                    <option value="1" <cfif graduate EQ 1>selected</cfif>>Yes</option>
                </select>
            </td>
            <td>
                <cfquery name="get_religious" datasource="#application.dsn#">
                    SELECT *
                    FROM smg_religions
                    WHERE religionname <> ''
                    ORDER BY religionname
                </cfquery>
    			Religion<br />
                <cfselect name="religionid" query="get_religious" value="religionid" display="religionname" selected="#religionid#" queryPosition="below">
                    <option value="">All</option>
                </cfselect>
            </td>
            <td>
                <cfquery name="get_interests" datasource="#application.dsn#">
                    SELECT *
                    FROM smg_interests
                    ORDER BY interest
                </cfquery>
                Interests<br />
                <cfselect name="interestid" query="get_interests" value="interestid" display="interest" selected="#interestid#" queryPosition="below">
                    <option value="">All</option>
                </cfselect>
            </td>
            <td>
                Play in Competitive Sports<br />
                <select name="sports">
                    <option value="">All</option>
                    <option <cfif sports EQ 'Yes'>selected</cfif>>Yes</option>
                    <option <cfif sports EQ 'No'>selected</cfif>>No</option>
                </select>
            </td>
            <td>
                Text in the Narrative<br />
                <cfinput type="text" name="interests_other" value="#interests_other#" size="10" maxlength="50">
            </td>
        </tr>
        <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td>
                <cfquery name="get_countries" datasource="#application.dsn#">
                    SELECT countryname, countryid
                    FROM smg_countrylist
                    ORDER BY countryname
                </cfquery>
                Country of Origin<br />
                <cfselect name="countryid" query="get_countries" value="countryid" display="countryname" selected="#countryid#" queryPosition="below">
                    <option value="">All</option>
                </cfselect>
            </td>
            <td colspan="2">
                <cfquery name="get_intl_rep" datasource="#application.dsn#">
                    SELECT smg_students.intrep, smg_users.businessname
                    FROM smg_students 
                    INNER JOIN smg_users ON smg_students.intrep = smg_users.userid 
                    <cfif client.companyid NEQ 5>
                        AND smg_students.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                    </cfif>
                    GROUP BY intrep
                    ORDER BY businessname
                </cfquery>
                International Rep.<br />
                <cfselect name="intrep" query="get_intl_rep" value="intrep" display="businessname" selected="#intrep#" queryPosition="below">
                    <option value="">All</option>
                </cfselect>
            </td>
            <td>
                <cfquery name="get_states" datasource="#application.dsn#">
                    SELECT id, statename
                    FROM smg_states
                    ORDER BY statename
                </cfquery>
                State Guarantee<br />
                <cfselect name="stateid" query="get_states" value="id" display="statename" selected="#stateid#" queryPosition="below">
                    <option value="">All</option>
                </cfselect>
            </td>
            <td colspan="2">
                <cfquery name="qGetPrograms" datasource="#application.dsn#">
                    SELECT 
                    	p.programID, 
                        p.programname,
                        c.companyshort,
                        CONCAT(c.companyshort, ' ', p.programname) AS companyProgram
                    FROM 
                    	smg_programs p
					INNER JOIN 
                    	smg_companies c ON p.companyid = c.companyid
                    WHERE 
                    	p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfif client.companyid EQ 5>
                        AND 
                        	c.website = <cfqueryparam cfsqltype="cf_sql_varchar" value="SMG">
                    <cfelse>
                        AND 
                            p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        AND 
                            p.companyid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10" list="yes">)
                    </cfif>
                    ORDER BY p.startdate DESC, p.programname
                </cfquery>
                
                Program<br />
				<cfif client.companyid EQ 5>
                    <cfselect name="programID" query="qGetPrograms" group="companyshort" value="programID" display="companyProgram" selected="#programID#" queryPosition="below" multiple="yes" size="5">
                        <option value="">All</option>
                    </cfselect>
                <cfelse>
                    <cfselect name="programID" query="qGetPrograms" value="programID" display="programname" selected="#programID#" queryPosition="below" multiple="yes" size="5">
                        <option value="">All</option>
                    </cfselect>
                </cfif>
            </td>
        </tr>
    </table>
</cfif>

        </td>
    </tr>
</table>
</cfform>

<cfif submitted>

    <!--- STUDENTS UNDER ADVISOR --->		
    <cfif client.usertype EQ 6>
		<cfset rep_list = ''>
        <!--- show only placed by the reps under the advisor --->
        <cfquery name="get_users_under_adv" datasource="#application.dsn#">
            SELECT DISTINCT userid
            FROM user_access_rights
            WHERE advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            AND regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
        </cfquery>
        <cfset rep_list = valueList(get_users_under_adv.userid)>
        <!--- include the user on the list. --->
        <cfset rep_list = listAppend(rep_list, client.userid)>
    <!--- STUDENTS UNDER AN AREA REPRESENTATIVE --->		
    <cfelseif client.usertype is 7>
        <cfset rep_list = client.userid>
    </cfif>
                    
    <cfquery name="getResults" datasource="#application.dsn#">
        SELECT  s.studentid, s.uniqueid, s.firstname, s.familylastname, s.sex, s.active, s.dateassigned, s.regionguar,
            s.state_guarantee, s.aypenglish, s.ayporientation, s.hostid,
            smg_regions.regionname, smg_g.regionname as r_guarantee, smg_states.state, smg_programs.programname,
            c.countryname, co.companyshort, smg_hosts.familylastname AS hostname
        FROM smg_students s
        INNER JOIN smg_companies co ON s.companyid = co.companyid
        LEFT JOIN smg_regions ON s.regionassigned = smg_regions.regionid
        LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
        LEFT JOIN smg_regions smg_g ON s.regionalguarantee = smg_g.regionid
        LEFT JOIN smg_states ON s.state_guarantee = smg_states.id
        LEFT JOIN smg_hosts ON s.hostid = smg_hosts.hostid
        LEFT JOIN smg_programs on s.programID = smg_programs.programID
		<!--- advanced search item. --->
		<cfif preayp NEQ ''>
			<cfif preayp EQ 'english'>
            	INNER JOIN smg_aypcamps ON s.aypenglish = smg_aypcamps.campid
            <cfelseif preayp EQ 'orient'>
            	INNER JOIN smg_aypcamps ON s.ayporientation = smg_aypcamps.campid
            </cfif>
        </cfif>
        <!--- SHOW ONLY APPS APPROVED --->
        WHERE s.app_current_status = 11
        <!--- OFFICE PEOPLE AND ABOVE --->
        <cfif client.usertype LTE 4>
            <!--- Students under companies --->
            <cfif client.companyid EQ 5>
                AND co.website = 'SMG'
            <cfelse>
                AND s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            </cfif>
            <cfif regionid NEQ ''>
                AND s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionid#">
            </cfif>
            <cfif cancelled NEQ ''>
                <cfif cancelled EQ 1>
                    AND canceldate IS NOT NULL
                <cfelseif cancelled EQ 0>
                    AND canceldate IS NULL
                </cfif>
            </cfif>
            <cfif active NEQ ''>
                AND s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
            </cfif>
			<cfif placed NEQ ''>
                <cfif placed EQ 1>
                    AND s.hostid <> 0
                <cfelseif placed EQ 0>
                    AND s.hostid = 0
                </cfif>
            </cfif>
        <!--- FIELD --->
        <cfelse>
            AND s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
            <!--- Don't show 08 programs --->
            AND fieldviewable = 1
            AND s.active = 1
			<cfif placed EQ 1>
                AND s.hostid <> 0
				<cfif listFind("6,7", client.usertype)>
                    AND (
                        s.arearepid IN (#rep_list#)
                        OR s.placerepid IN (#rep_list#)
                    )
                </cfif>            
            <cfelseif placed EQ 0>
                AND s.hostid = 0
            </cfif>
        </cfif>            
        <cfif trim(keyword) NEQ ''>
            AND (
                s.studentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                OR s.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR s.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR c.countryname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR smg_regions.regionname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR smg_programs.programname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR smg_hosts.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
            )
        </cfif>
		<!--- advanced search items. --->
        <cfif adv_search>
			<cfif trim(familylastname) NEQ ''>
                AND s.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(familylastname)#%">
            </cfif>
            <cfif trim(firstname) NEQ ''>
                AND s.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(firstname)#%">
            </cfif>
            <cfif direct NEQ ''>
                AND s.direct_placement = <cfqueryparam cfsqltype="cf_sql_bit" value="#direct#">
            </cfif>
            <cfif age NEQ ''>
                AND FLOOR(DATEDIFF(now(), s.dob) / 365) = <cfqueryparam cfsqltype="cf_sql_integer" value="#age#">
            </cfif>
            <cfif sex NEQ ''>
                AND s.sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sex#">
            </cfif>
            <cfif grade NEQ ''>
                AND s.grades = <cfqueryparam cfsqltype="cf_sql_integer" value="#grade#">
            </cfif>
            <cfif graduate NEQ ''>
                AND (
                    s.grades = 12
                    OR (s.grades = 11 AND (s.countryresident = 49 OR s.countryresident = 237))
                )
            </cfif>
			<cfif religionid NEQ ''>
            	AND s.religiousaffiliation = <cfqueryparam cfsqltype="cf_sql_integer" value="#religionid#">	
            </cfif>	
			<cfif interestid NEQ ''>
            	<!--- s.interests is a comma-delimited list of interestid's.  check single item, beginning of list, middle of list, end of list. --->
            	AND (
                	s.interests = <cfqueryparam cfsqltype="cf_sql_integer" value="#interestid#">
                	OR s.interests LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#interestid#,%">
                	OR s.interests LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#interestid#,%">
                	OR s.interests LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#interestid#">
                )
            </cfif>	
            <cfif sports NEQ ''>
                AND s.comp_sports = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sports#">
            </cfif>
			<cfif trim(interests_other) NEQ ''>
                AND s.interests_other LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(interests_other)#%">
            </cfif>
			<cfif countryid NEQ ''>
                AND s.countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="#countryid#">
            </cfif>
			<cfif intrep NEQ ''>
            	AND s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#intrep#">
            </cfif>
			<cfif stateid NEQ ''>
                AND s.state_guarantee = <cfqueryparam cfsqltype="cf_sql_integer" value="#stateid#">
            </cfif>		
			<cfif programID NEQ ''>
                AND s.programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#programID#" list="yes">)
            </cfif>		
        </cfif>
        ORDER BY #orderby#	
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
		<cfset urlVariables = "submitted=1&adv_search=#adv_search#&regionid=#regionid#&keyword=#urlEncodedFormat(keyword)#&placed=#placed#&cancelled=#cancelled#&active=#active#&orderby=#orderby#&recordsToShow=#recordsToShow#">
		<cfif adv_search>
        	<cfset urlVariables = "#urlVariables#&familylastname=#urlEncodedFormat(familylastname)#&firstname=#urlEncodedFormat(firstname)#&preayp=#preayp#&direct=#direct#&age=#age#&sex=#sex#&grade=#grade#&graduate=#graduate#&religionid=#religionid#&interestid=#interestid#&sports=#sports#&interests_other=#urlEncodedFormat(interests_other)#&countryid=#countryid#&intrep=#intrep#&stateid=#stateid#&programID=#programID#">
        </cfif>
    
        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="index.cfm?curdoc=students&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="index.cfm?curdoc=students&startPage=#i#&#urlVariables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="index.cfm?curdoc=students&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                        </cfif>
                        <br>
                    </cfif>
                    Displaying #startrow# to #endrow# of #getResults.recordCount#
                </td>
            </tr>
        </table>
            
        <table width=100% class="section">
            <tr align="left">
                <th>ID</th>
                <th>Last Name</th>
                <th>First Name</th>
                <th>Sex</th>
                <th>Country</th>
                <th>Region</th>
                <th>Program</th>
                <th>Family</th>
                <cfif client.companyid EQ 5>
                	<th>Company</th>
                </cfif>
            </tr>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
				<cfif dateassigned NEQ '' AND dateassigned GT client.lastlogin>
                    <cfset bgcolor="e2efc7">
                <cfelseif dateassigned NEQ '' AND DateDiff('d',dateassigned, now()) GTE 25 AND DateDiff('d',dateassigned, now()) LTE 34 AND hostid EQ 0 AND active EQ 1>
                    <cfset bgcolor="B3D9FF">
                <cfelseif dateassigned NEQ '' AND DateDiff('d',dateassigned, now()) GTE 35 AND DateDiff('d',dateassigned, now()) LTE 49 AND hostid EQ 0 AND active EQ 1>
                    <cfset bgcolor="FFFF9D">
                <cfelseif dateassigned NEQ '' AND DateDiff('d',dateassigned, now()) GTE 50 AND hostid EQ 0 AND active EQ 1>
                    <cfset bgcolor="FF9D9D">
                <cfelse>
                    <cfset bgcolor="">
                </cfif>
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                    <td bgcolor="#bgcolor#">
                        <cfif client.usertype EQ 9>
                        	<a href="index.cfm?curdoc=student_profile&uniqueid=#uniqueid#">#studentid#</a>
                        <cfelse>
                        	<a href="index.cfm?curdoc=student_info&studentid=#studentid#">#studentid#</a>
                        </cfif>
                    </td>
                    <td>#familylastname#</td>
                    <td>#firstname#</td>
                    <td>
                    	<cfif sex EQ 'male'>
                        	Male
                        <cfelseif sex EQ 'female'>
                        	Female
                        </cfif>
                    </td>
                    <td>#countryname#</td>
                    <td>
                    	#regionname#
						<cfif regionguar is 'yes'>
                            <font color="CC0000">
                            <cfif r_guarantee NEQ ''>
                                * #r_guarantee#
                            <cfelseif state_guarantee NEQ 0>
                                * #state#
                            <cfelse>
                                * Missing
                            </cfif>
                            </font>
                        </cfif>
                    </td>
                    <td>
                        #programname#
                        <font color="CC0000">
                        <cfif aypenglish NEQ 0>
                            * Pre-Ayp English
                        <cfelseif ayporientation NEQ 0>
                            * Pre-Ayp Orient.
                        </cfif>
                        </font>
                    </td>
                    <td>#hostname#</td>
					<cfif client.companyid EQ 5>
                        <td>#companyshort#</td>
                    </cfif>
                </tr>
            </cfloop>
        </table>
    
        </cfoutput>
        <table width=100% bgcolor="#ffffe6" class="section">
            <tr>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="e2efc7" width="15">&nbsp;</td>
                        <td>Added since your last vist.</td>
                      </tr>
                    </table>
                </td>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="B3D9FF" width="15">&nbsp;</td>
                        <td>Unplaced for 25-34 days.</td>
                      </tr>
                    </table>
                </td>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="FFFF9D" width="15">&nbsp;</td>
                        <td>Unplaced for 35-49 days.</td>
                      </tr>
                    </table>
                </td>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="FF9D9D" width="15">&nbsp;</td>
                        <td>Unplaced more than 50 days.</td>
                      </tr>
                    </table>
                </td>
                <td><font color="CC0000">* Regional / State Guarantee.</font></td>
            </tr>
        </table>

	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td>No students matched your criteria.</td>
            </tr>
        </table>
    </cfif>
    
</cfif>
   
<cfinclude template="table_footer.cfm">