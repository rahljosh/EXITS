<!--- ------------------------------------------------------------------------- ----
	
	File:		students.cfm
	Author:		Marcus Melo
	Date:		July 29, 2011
	Desc:		Student's list / search

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param Variables --->
    <cfparam name="submitted" default="0">
    <cfparam name="regionID" default="#CLIENT.regionID#">
    <cfparam name="keyword" default="">
    <cfparam name="orderby" default="familyLastName">
    <cfparam name="recordsToShow" default="25">

	<cfif CLIENT.usertype GT 4>
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
    
    <!--- advanced search items. --->
    <cfparam name="searchStudentID" default="">
    <cfparam name="adv_search" default="0">
    <cfparam name="familyLastName" default="">
    <cfparam name="studentFirstName" default="">
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
    <cfparam name="countryID" default="">
    <cfparam name="intrep" default="">
    <cfparam name="stateid" default="">
    <cfparam name="programID" default="">
    <cfparam name="privateschool" default="">
    <cfparam name="placementStatus" default="">
    
    <cfscript>
		// Get Private Schools Prices
		qPrivateSchools = APPCFC.SCHOOL.getPrivateSchools();
		
		if ( NOT APPLICATION.CFC.USER.isOfficeUser() ) {
			submitted = 1;
		}
		
		// Set placed = yes if selecting approved/pending status
		if ( ListFindNoCase("Approved,Pending", placementStatus) ) {
			placed = 1;
		}
		
		// Default Value
		vAdvancedSearchLink = '';
		
		// Advanced Search Link
		if ( CLIENT.userType NEQ 27 ) {
			
			vAdvancedSearchLink = '<a href="index.cfm?curdoc=students&adv_search=1">Advanced Search</a>';
			
			if ( VAL(adv_search) ) {
				vAdvancedSearchLink = '<a href="index.cfm?curdoc=students&adv_search=0">Hide Advanced Search</a>';
			}
			
		}
    </cfscript>
    
	<!--- GET ALL REGIONS --->
    <cfquery name="qListRegions" datasource="#application.dsn#">
        SELECT 
        	regionID, 
            regionName
        FROM 
        	smg_regions
        WHERE 
        	company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND 
        	subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        ORDER BY 
        	regionName
    </cfquery>
	
    <!--- Advanced Search --->
	<cfif VAL(adv_search)>
    
        <cfquery name="qGetReligionList" datasource="#application.dsn#">
            SELECT 
                *
            FROM 
                smg_religions
            WHERE 
                religionname != ''
            ORDER BY 
                religionname
        </cfquery>
    
        <cfquery name="qGetInterestList" datasource="#application.dsn#">
            SELECT 
                *
            FROM 
                smg_interests
            ORDER BY 
                interest
        </cfquery>
        
        <cfquery name="qGetCountryList" datasource="#application.dsn#">
            SELECT 
                countryname, 
                countryID
            FROM 
                smg_countrylist
            ORDER BY 
                countryname
        </cfquery>
    
        <cfquery name="qGetIntlRepList" datasource="#application.dsn#">
            SELECT 
            	smg_students.intrep, 
                smg_users.businessname
            FROM 
            	smg_students 
            INNER JOIN 
            	smg_users ON smg_students.intrep = smg_users.userid 
            <cfif CLIENT.companyID NEQ 5>
                AND 
                	smg_students.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            </cfif>
            GROUP BY 
            	intrep
            ORDER BY 
            	businessname
        </cfquery>

        <cfquery name="qGetStateList" datasource="#application.dsn#">
            SELECT 
            	id, 
                statename
            FROM 
            	smg_states
            ORDER BY 
            	statename
        </cfquery>
    
        <cfquery name="qGetProgramList" datasource="#application.dsn#">
            SELECT 
                p.programID, 
                p.programname,
                c.companyShort,
                CONCAT(c.companyShort, ' ', p.programname) AS companyProgram
            FROM 
                smg_programs p
            INNER JOIN 
                smg_companies c ON p.companyID = c.companyID
            WHERE 
                p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            <cfif CLIENT.companyID EQ 5>
                AND          
                    c.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
            <cfelseif client.companyID eq 14>
                 AND 
                    p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND 
                    p.companyID = (<cfqueryparam cfsqltype="cf_sql_integer" value="14" list="yes">)
            <cfelseif client.companyID eq 15>
            	AND 
                	p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND 
                	p.companyID = (<cfqueryparam cfsqltype="cf_sql_integer" value="15" list="yes">)
            <cfelse>
                AND 
                    p.is_deleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND 
                    p.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
            </cfif>
            ORDER BY 
            	p.startdate DESC, 
                p.programname
        </cfquery>

	</cfif>

</cfsilent>

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Students"
        tableRightTitle="#vAdvancedSearchLink#"
    />

    <cfform action="index.cfm?curdoc=students" method="post">
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="adv_search" value="#adv_search#">
    	
        <!--- Guest User Account | Student ID Option Only --->
        <cfif CLIENT.userType EQ 27>
        
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td>
                    
                        <table border="0" cellpadding="4" cellspacing="0" width="100%">
                            <tr>
                                <td>
                                    Student ID <br />
                                    <input type="text" name="searchStudentID" value="#searchStudentID#" size="10" maxlength="50">   
                                    <input name="send" type="submit" value="Submit" />      
                                </td>
                            </tr>
                        </table>
            
                    </td>
                </tr>
            </table>
		
        <!--- All Other Users --->
        <cfelse>
        
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
                <tr>
                    <td>
                    
                        <table border="0" cellpadding="4" cellspacing="0" width="100%">
                            <tr>
                                <td><input name="send" type="submit" value="Submit" /></td>
                                <cfif listFind("1,2,3,4", CLIENT.userType)>
                                    <td>
                                        Region<br />
                                        <cfif listFind("1,2,3,4", CLIENT.userType)>
                                            <cfselect name="regionID" query="qListRegions" value="regionID" display="regionName" queryPosition="below">
                                                <option value="" selected="selected">All</option>
                                            </cfselect>
                                        <cfelse>
                                            <cfselect name="regionID" query="qListRegions" value="regionID" display="regionName" selected="#regionID#" queryPosition="below">
                                                <option value="">All</option>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </cfif>
                                <td>
                                    Keyword / ID<br />
                                    <input type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
                                </td>
                                <cfif CLIENT.usertype NEQ 9>
                                    <td>
                                        Placed<br />
                                        <select name="placed">
                                            <cfif listFind("1,2,3,4", CLIENT.userType)>
                                                <option value="">All</option>
                                            </cfif>
                                            <option value="1" <cfif placed EQ 1>selected</cfif>>Yes</option>
                                            <option value="0" <cfif placed EQ 0>selected</cfif>>No</option>
                                        </select>            
                                    </td>
                                </cfif>
                                <cfif listFind("1,2,3,4", CLIENT.userType)>
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
                                        <option value="studentID" <cfif orderby EQ 'studentID'>selected</cfif>>ID</option>
                                        <option value="familyLastName" <cfif orderby EQ 'familyLastName'>selected</cfif>>Last Name</option>
                                        <option value="studentFirstName" <cfif orderby EQ 'studentFirstName'>selected</cfif>>First Name</option>
                                        <option value="sex" <cfif orderby EQ 'sex'>selected</cfif>>Sex</option>
                                        <option value="country" <cfif orderby EQ 'country'>selected</cfif>>Country</option>
                                        <option value="regionName" <cfif orderby EQ 'regionName'>selected</cfif>>Region</option>
                                        <option value="programID" <cfif orderby EQ 'programID'>selected</cfif>>Program</option>
                                        <option value="hostID" <cfif orderby EQ 'hostID'>selected</cfif>>Family</option>
                                        <cfif CLIENT.companyID EQ 5>
                                            <option value="companyShort" <cfif orderby EQ 'companyShort'>selected</cfif>>Company</option>
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
                        <cfif VAL(adv_search)>
                        
                            <hr align="center" noshade="noshade" size="1" width="95%" />
                            
                            <table border="0" cellpadding="4" cellspacing="0" width="100%">
                                <tr>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>
                                        Last Name<br />
                                        <input type="text" name="familyLastName" value="#familyLastName#" size="10" maxlength="50">
                                    </td>
                                    <td>
                                        First Name<br />
                                        <input type="text" name="studentFirstName" value="#studentFirstName#" size="10" maxlength="50">
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
                                    <Td>
                                        Sex<br />
                                        <select name="sex">
                                            <option value="">All</option>
                                            <option <cfif sex EQ 'Male'>selected</cfif>>Male</option>
                                            <option <cfif sex EQ 'Female'>selected</cfif>>Female</option>
                                        </select>
                                     </Td>
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
                                        Private School Tuition<br />
                                        <select name="privateschool">
                                            <option value="" <cfif NOT LEN(privateschool)>selected</cfif>>n/a</option>
                                            <option value="0" <cfif privateschool EQ 0>selected</cfif>>All Tuitions</option>
                                            <cfloop query="qPrivateSchools">
                                                <option value="#privateschoolid#" <cfif privateschool eq privateschoolid>selected</cfif>>#privateschoolprice#</option>
                                            </cfloop>
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
                                        Religion<br />
                                        <cfselect name="religionid" query="qGetReligionList" value="religionid" display="religionname" selected="#religionid#" queryPosition="below">
                                            <option value="">All</option>
                                        </cfselect>
                                    </td>
                                    <td>
                                        Interests<br />
                                        <cfselect name="interestid" query="qGetInterestList" value="interestid" display="interest" selected="#interestid#" queryPosition="below">
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
                                        <input type="text" name="interests_other" value="#interests_other#" size="10" maxlength="50">
                                    </td>
                                    <td>
                                        Placement Status<br />
                                        <select name="placementStatus">
                                            <option value="">All</option>
                                            <option <cfif placementStatus EQ 'Pending'>selected</cfif>>Pending</option>
                                            <option <cfif placementStatus EQ 'Approved'>selected</cfif>>Approved</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>
                                        Country of Origin<br />
                                        <cfselect name="countryID" query="qGetCountryList" value="countryID" display="countryname" selected="#countryID#" queryPosition="below">
                                            <option value="">All</option>
                                        </cfselect>
                                    </td>
                                    <td colspan="2">
                                        International Rep.<br />
                                        <cfselect name="intrep" query="qGetIntlRepList" value="intrep" display="businessname" selected="#intrep#" queryPosition="below">
                                            <option value="">All</option>
                                        </cfselect>
                                    </td>
                                    <td>
                                        State Preference<br />
                                        <cfselect name="stateid" query="qGetStateList" value="id" display="statename" selected="#stateid#" queryPosition="below">
                                            <option value="">All</option>
                                        </cfselect>
                                    </td>
                                    <td colspan="2">
                                        Program<br />
                                        <cfif CLIENT.companyID EQ 5>
                                            <cfselect name="programID" query="qGetProgramList" group="companyShort" value="programID" display="companyProgram" selected="#programID#" queryPosition="below" multiple="yes" size="5">
                                                <option value="">All</option>
                                            </cfselect>
                                        <cfelse>
                                            <cfselect name="programID" query="qGetProgramList" value="programID" display="programname" selected="#programID#" queryPosition="below" multiple="yes" size="5">
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

		</cfif>
    
    </cfform>

</cfoutput>

<cfif submitted>

    <!--- STUDENTS UNDER ADVISOR --->		
    <cfif CLIENT.usertype EQ 6>
    
        <!--- show only placed by the reps under the advisor --->
        <cfquery name="get_users_under_adv" datasource="#application.dsn#">
            SELECT DISTINCT 
            	userid
            FROM 
            	user_access_rights
            WHERE 
            	advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            AND 
            	regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
        </cfquery>
        
        <cfscript>
			vUserUnderAdvisorList = '';
			vUserUnderAdvisorList = valueList(get_users_under_adv.userid);
			// include the current user on the list.
			vUserUnderAdvisorList = listAppend(vUserUnderAdvisorList, CLIENT.userid);
		</cfscript>
        
    </cfif>
                    
    <cfquery name="qGetResults" datasource="#application.dsn#">
        SELECT  
        	s.studentID, 
            s.nexits_id,
            s.uniqueid, 
            s.programID,
            s.hostID,
            s.FirstName,
            s.familyLastName, 
            s.sex, 
            s.active, 
            s.dateassigned, 
            s.regionguar,
            s.state_guarantee, 
            s.aypenglish, 
            s.ayporientation, 
            s.scholarship, 
            s.privateschool,
            s.host_fam_approved,
            smg_regions.regionName, 
            smg_g.regionName as r_guarantee, 
            smg_states.state,             
            p.programname,
            c.countryname, 
            co.companyShort, 
            smg_hosts.familyLastName AS hostname
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_companies co ON s.companyID = co.companyID
        LEFT OUTER JOIN 
        	smg_regions ON s.regionassigned = smg_regions.regionID
        LEFT OUTER JOIN 
        	smg_countrylist c ON s.countryresident = c.countryID
        LEFT OUTER JOIN 
        	smg_regions smg_g ON s.regionalguarantee = smg_g.regionID
        LEFT OUTER JOIN 
        	smg_states ON s.state_guarantee = smg_states.id
        LEFT OUTER JOIN 
        	smg_hosts ON s.hostID = smg_hosts.hostID
        LEFT OUTER JOIN 
        	smg_programs p ON s.programID = p.programID
            
		<!--- advanced search item. --->
		<cfif preayp EQ 'english'>
            INNER JOIN 
            	smg_aypcamps ON s.aypenglish = smg_aypcamps.campid
        <cfelseif preayp EQ 'orient'>
            INNER JOIN 
            	smg_aypcamps ON s.ayporientation = smg_aypcamps.campid
        </cfif>
        
        WHERE 
        
        	<!--- SHOW ONLY APPS APPROVED --->
        	s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
        
        <!--- OFFICE PEOPLE --->
        <cfif listFind("1,2,3,4", CLIENT.userType)>
        
            <!--- Students under companies --->
			<cfif CLIENT.companyID EQ 5>
                AND
                    s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> ) 
            <cfelse>
                AND
                    s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            </cfif>
            
            <cfif VAL(regionID)>
                AND 
                	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionID#">
            </cfif>
            
			<cfif cancelled EQ 1>
                AND 
                    canceldate IS NOT NULL
            <cfelseif cancelled EQ 0>
                AND 
                    canceldate IS NULL
            </cfif>
            
            <cfif LEN(active)>
                AND 
                	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
            </cfif>
            
            <cfif privateschool EQ 0>
				AND 
                	privateschool != <cfqueryparam cfsqltype="cf_sql_integer" value="#privateschool#">
            <cfelseif VAL(privateschool)>
				AND 
                	privateschool = <cfqueryparam cfsqltype="cf_sql_integer" value="#privateschool#">
			</cfif>

			<cfif placed EQ 1>
                AND 
                	s.hostid != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            <cfelseif placed EQ 0>
                AND 
                	s.hostid = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            </cfif>
        
        <!--- Guest Account --->
        <cfelseif CLIENT.userType EQ 27>
        
            <!--- Students under companies --->
			<cfif CLIENT.companyID EQ 5>
                AND
                    s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> ) 
            <cfelse>
                AND
                    s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            </cfif>

            AND 
                s.studentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(searchStudentID)#">
        
        <!--- FIELD --->
        <cfelse>
        
            AND 
            	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
            
			<!--- Don't show 08 programs --->
            AND 
            	fieldviewable = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
            	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                
			<cfif placed EQ 1>
                AND 
                	s.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                  
                <!--- STUDENTS UNDER REGIONAL ADVISOR --->  
				<cfif CLIENT.userType EQ 6>
                    AND (
                        	s.arearepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vUserUnderAdvisorList#" list="yes"> )
                        OR 
                        	s.placerepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vUserUnderAdvisorList#" list="yes"> )
                   		)
                        
                <!--- STUDENTS UNDER AN AREA REPRESENTATIVE --->
                <cfelseif CLIENT.userType EQ 7>
                    AND (
                        	s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                        OR 
                        	s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                   		)
				</cfif> 
                           
            <cfelseif placed EQ 0>
               	AND 
               		s.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            </cfif>
            
        </cfif>
                
        <!--- Search --->            
        <cfif LEN(trim(keyword))>
            AND (
                    s.studentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                OR 
                	s.familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR 
                	s.FirstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR 
                	c.countryname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR 
                	smg_regions.regionName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR 
                	p.programname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                OR 
                	smg_hosts.familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
            )
        </cfif>
		
		<!--- advanced search items. --->        
        <cfif VAL(adv_search)>
        
			<cfif LEN(familyLastName)>
                AND
                	s.familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(familyLastName)#%">
            </cfif>
            
            <cfif LEN(studentFirstName)>
                AND 
                	s.FirstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(studentFirstName)#%">
            </cfif>
            
            <cfif LEN(direct)>
                AND 
                	s.direct_placement = <cfqueryparam cfsqltype="cf_sql_bit" value="#direct#">
            </cfif>
            
            <cfif VAL(age)>
                AND 
                	FLOOR(DATEDIFF(now(), s.dob) / 365) = <cfqueryparam cfsqltype="cf_sql_integer" value="#age#">
            </cfif>
            
            <cfif LEN(sex)>
                AND 
                	s.sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sex#">
            </cfif>
            
            <cfif VAL(grade)>
                AND 
                	s.grades = <cfqueryparam cfsqltype="cf_sql_integer" value="#grade#">
            </cfif>
            
            <cfif LEN(graduate)>
                AND (
                    	s.grades = 12
                    OR 
                        (
                            s.grades = 11 
                        AND 
                            s.countryresident IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="49,237" list="yes"> ) 
                        )
                )
            </cfif>
            
			<cfif VAL(religionid)>
            	AND 
                	s.religiousaffiliation = <cfqueryparam cfsqltype="cf_sql_integer" value="#religionid#">	
            </cfif>	
            
			<cfif LEN(interestid)>
            	<!--- s.interests is a comma-delimited list of interestid's.  check single item, beginning of list, middle of list, end of list. --->
            	AND (
                		s.interests = <cfqueryparam cfsqltype="cf_sql_integer" value="#interestid#">
                	OR 
                    	s.interests LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#interestid#,%">
                	OR 
                    	s.interests LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#interestid#,%">
                	OR 
                    	s.interests LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#interestid#">
                )
            </cfif>	
            
            <cfif LEN(sports)>
                AND 
                	s.comp_sports = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sports#">
            </cfif>
            
			<cfif LEN(interests_other)>
                AND 
                	s.interests_other LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(interests_other)#%">
            </cfif>
            
            <cfif placementStatus EQ 'Approved'>
            	AND
                	s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> )   
            <cfelseif placementStatus EQ 'Pending'>
            	AND
                	s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )              
            </cfif>
            
			<cfif VAL(countryID)>
                AND 
                	s.countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="#countryID#">
            </cfif>
            
			<cfif VAL(intrep)>
            	AND 
                	s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#intrep#">
            </cfif>
            
			<cfif VAL(stateid)>
                AND 
                	s.state_guarantee = <cfqueryparam cfsqltype="cf_sql_integer" value="#stateid#">
            </cfif>	
            	
			<cfif VAL(programID)>
                AND 
                	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#" list="yes"> )
            </cfif>
            		
        </cfif>
        
        ORDER BY 
        	
            <cfswitch expression="#orderBy#">
            
            	<cfcase value="studentID,familyLastName,studentFirstName,sex,regionName,programID,hostID,companyShort">
                	#orderby#	
                </cfcase>
                
                <cfcase value="country">
                	s.countryresident
                </cfcase>
                
                <cfdefaultcase>
                	familyLastName
                </cfdefaultcase>
                        
            </cfswitch>

    </cfquery>
    
	<cfif qGetResults.recordCount>

		<cfparam name="url.startPage" default="1">
        
        <cfscript>
			totalPages = ceiling(qGetResults.recordCount / recordsToShow);
			startrow = 1 + ((url.startPage - 1) * recordsToShow);
			
			if ( qGetResults.recordCount GT url.startPage * recordsToShow ) {
				isNextPage = 1;
				endrow = url.startPage * recordsToShow;
			} else {
				isNextPage = 0;
				endrow = qGetResults.recordCount;
			}
			
			urlVariables = "submitted=1&adv_search=#adv_search#&regionID=#regionID#&keyword=#urlEncodedFormat(keyword)#&placed=#placed#&cancelled=#cancelled#&active=#active#&orderby=#orderby#&recordsToShow=#recordsToShow#";
			
			if ( adv_search ) {
				urlVariables = "#urlVariables#&familyLastName=#urlEncodedFormat(familyLastName)#&studentFirstName=#urlEncodedFormat(studentFirstName)#&preayp=#preayp#&direct=#direct#&age=#age#&sex=#sex#&grade=#grade#&graduate=#graduate#&religionid=#religionid#&interestid=#interestid#&sports=#sports#&interests_other=#urlEncodedFormat(interests_other)#&placementStatus=#placementStatus#&countryID=#countryID#&intrep=#intrep#&stateid=#stateid#&programID=#programID#";
			}
		</cfscript>
    
        <cfoutput>
    
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
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
                        
                        <br />
                    </cfif>
                    
                    Displaying #startrow# to #endrow# of #qGetResults.recordCount#
                </td>
            </tr>
        </table>
            
        <table width="100%" class="section">
            <tr style="font-weight:bold;">
                <td>ID</td>
                <td>NEXITS ID</td>
                <td>Last Name</td>
                <td>First Name</td>
                <td>Sex</td>
                <td>Country</td>
                <td>Region</td>
                <td>Program</td>
                <td>Family</td>
                <cfif CLIENT.companyID EQ 5>
                	<td>Division</td>
                </cfif>
            </tr>
            <cfloop query="qGetResults" startrow="#startrow#" endrow="#endrow#">
				<cfif dateassigned NEQ '' AND dateassigned GT CLIENT.lastlogin>
                    <cfset bgcolor="e2efc7">
                <cfelseif dateassigned NEQ '' AND DateDiff('d',dateassigned, now()) GTE 25 AND DateDiff('d',dateassigned, now()) LTE 34 AND hostID EQ 0 AND active EQ 1>
                    <cfset bgcolor="B3D9FF">
                <cfelseif dateassigned NEQ '' AND DateDiff('d',dateassigned, now()) GTE 35 AND DateDiff('d',dateassigned, now()) LTE 49 AND hostID EQ 0 AND active EQ 1>
                    <cfset bgcolor="FFFF9D">
                <cfelseif dateassigned NEQ '' AND DateDiff('d',dateassigned, now()) GTE 50 AND hostID EQ 0 AND active EQ 1>
                    <cfset bgcolor="FF9D9D">
                <cfelse>
                    <cfset bgcolor="">
                </cfif>
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                    <td bgcolor="#bgcolor#">
                        <cfif CLIENT.usertype EQ 9>
                        	<a href="index.cfm?curdoc=student_profile&uniqueid=#uniqueid#">#studentID#</a>
                        <cfelseif CLIENT.userType EQ 27>
                        	<a href="index.cfm?curdoc=student/index&action=studentInformation&studentID=#studentID#">#studentID#</a>
						<cfelse>
                        	<a href="index.cfm?curdoc=student_info&studentID=#studentID#">#studentID#</a>
                        </cfif>
                    </td>
                    <td><cfif val(#nexits_id#)>#nexits_id#<cfelse>n/a</cfif></td>
                    <td>#familyLastName#</td>
                    <td>#FirstName#</td>
                    <td>#sex#</td>
                    <td>#countryname#</td>
                    <td>
                    	#regionName#

						<cfif r_guarantee NEQ ''>
                            <font color="CC0000">
                                * #r_guarantee#
                            </font>
                        </cfif>
                            
                        <cfif state_guarantee NEQ 0>
                        	<font color="CC0000">
                        	  * #state#
                            </font>
                        </cfif> 
                        
                    </td>
                    <td>
                        #programname#
                        <font color="CC0000">
                        
							<cfif VAL(aypenglish)>
                                * Pre-Ayp English
                            <cfelseif VAL(ayporientation)>
                                * Pre-Ayp Orient.
                            </cfif>
                            
                            <cfif VAL(scholarship)>
                                * Scholarship
                             </cfif>
                             
                             <cfif VAL(privateschool)>
                                * Private School
                             </cfif>
                             
                        </font>
                    </td>
                    <td>#hostname#</td>
					<cfif CLIENT.companyID EQ 5>
                        <td>#companyShort#</td>
                    </cfif>
                </tr>
            </cfloop>
        </table>
    
        </cfoutput>
        
        <table width="100%" bgcolor="#ffffe6" class="section">
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
                <td><font color="CC0000">* Regional / State Preference.</font></td>
            </tr>
        </table>

	<cfelse>
    
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr>
                <td>No students matched your criteria.</td>
            </tr>
        </table>
        
    </cfif>

</cfif>
   
<cfinclude template="table_footer.cfm">