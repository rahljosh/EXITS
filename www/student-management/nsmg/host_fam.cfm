<!--- ------------------------------------------------------------------------- ----
	
	File:		host_fam.cfm
	Author:		Marcus Melo
	Date:		August 6, 2012
	Desc:		Host Family List / search

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param Variables --->
    <cfparam name="FORM.regionid" default="0">
    <cfparam name="submitted" default="0">
    <cfparam name="keyword" default="">
    <cfparam name="hosting" default="">
    <cfparam name="active" default="1">
    <cfparam name="orderby" default="familylastname">
    <cfparam name="recordsToShow" default="25">

	<cfscript>
		// Store List of Supervised Users
		vSupervisedUserIDList = '';
		vHostIDList = '';
	</cfscript>

</cfsilent>

<cfif NOT VAL(FORM.regionID)>

	<script type="text/javascript">	
		$(document).ready(function() {
			$("#regionID").val("0").attr("selected",true);							 
		});
	</script>

</cfif>

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="family.gif"
        tableTitle="Host Families"
        tableRightTitle='<a href="index.cfm?curdoc=forms/host_fam_form">Add Host Family</a>'
    />

    <cfform action="?curdoc=host_fam" method="post">
        <input name="submitted" type="hidden" value="1">
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td><input name="send" type="submit" value="Submit" /></td>
				<cfif APPLICATION.CFC.USER.isOfficeUser()>
                    <td>
						<!--- GET ALL REGIONS --->
                        <cfquery name="qGetRegionList" datasource="#application.dsn#">
                            SELECT 
                            	regionid, 
                                regionname
                            FROM 
                            	smg_regions
                            WHERE 
                            	company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                            AND 
                            	subofregion = 0
                            ORDER BY 
                            	regionname
                        </cfquery>
                        
                        Region<br />
                        <cfselect id="regionID" NAME="regionid" query="qGetRegionList" value="regionid" display="regionName" selected="#regionid#" queryPosition="below">
                        	<option value="0">All</option>
                        </cfselect>
                    </td>
				</cfif>
                <td>
                    Keyword / ID<br />
                    <input type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
                </td>
                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                    <td>
                        Hosting<br />
                        <select name="hosting">
                            <option value="">All</option>
                            <option value="1" <cfif hosting EQ 1>selected</cfif>>Yes</option>
                            <option value="0" <cfif hosting EQ 0>selected</cfif>>No</option>
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
                        <option value="hostid" <cfif orderby EQ 'hostid'>selected</cfif>>ID</option>
                        <option value="familylastname" <cfif orderby EQ 'familylastname'>selected</cfif>>Last Name</option>
                        <option value="fatherfirstname" <cfif orderby EQ 'fatherfirstname'>selected</cfif>>Father</option>
                        <option value="motherfirstname" <cfif orderby EQ 'motherfirstname'>selected</cfif>>Mother</option>
                        <option value="city" <cfif orderby EQ 'city'>selected</cfif>>City</option>
                        <option value="state" <cfif orderby EQ 'state'>selected</cfif>>State</option>
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
    </cfform>

</cfoutput>

<cfif submitted>

	<!--- OFFICE PEOPLE AND ABOVE --->
    <cfif APPLICATION.CFC.USER.isOfficeUser()>
        
        <cfquery name="qGetResults" datasource="#application.dsn#">
            SELECT 
            	h.hostid, 
                h.familylastname, 
                h.fatherfirstname, 
                h.motherfirstname, 
                h.city, 
                h.state
            FROM 
            	smg_hosts h
            
			<cfif hosting EQ 1>
                INNER JOIN smg_students s ON h.hostid = s.hostid
            <cfelseif hosting EQ 0>
                LEFT OUTER JOIN smg_students s ON h.hostid = s.hostid
            </cfif>
            
            WHERE 
            	1 = 1
                
			<cfif CLIENT.companyID EQ 5>
                AND
                	h.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> ) 
            <cfelse>
                AND 
                	h.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
            </cfif>
            
            <cfif VAL(FORM.regionid)>
                AND 
                	h.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">
            </cfif>
            
            <cfif LEN(TRIM(keyword))>
                AND (
                		h.hostid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                	OR 
                    	h.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR 
                    	h.fatherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR 
                    	h.motherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR 
                    	h.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR 
                    	h.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                    OR 
                    	h.email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	)
            </cfif>
            
            <cfif hosting EQ 1>
                AND 
                	s.active = 1
            <cfelseif hosting EQ 0>
                AND 
                	s.hostid IS NULL
            </cfif>
            
            <cfif LEN(active)>
                AND 
                	h.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#active#">
            </cfif>
            
            ORDER BY 
            	#orderby#
        </cfquery>
    
    <!--- FIELD --->
    <cfelse>
        
        <!---- REGIONAL ADVISOR ----->
        <cfif CLIENT.usertype EQ 6>

			<cfscript>
				// Get Available Reps
				qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionID=FORM.regionID);
				
				// Store Users under Advisor on a list
				vSupervisedUserIDList = ValueList(qGetUserUnderAdv.userID);
            </cfscript>

            <cfquery name="qGetHostList" datasource="#application.dsn#">
                SELECT
                    h.hostID
				FROM
                	smg_hosts h
                INNER JOIN
                	smg_students s ON s.hostID = h.hostID
                    AND
                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND
                        (    
                            s.arearepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vSupervisedUserIDList#" list="yes">  )
                        OR 
                            s.placerepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vSupervisedUserIDList#" list="yes">  )
                        )
                WHERE
                	h.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				GROUP BY
                	hostID                 
            </cfquery>
            
            <cfscript>
				// Add to a list
				vHostIDList = ValueList(qGetHostList.hostID);
			</cfscript>
            
        <!--- AREA REP - STUDENTS VIEW --->
        <cfelseif listFind("7,9", CLIENT.usertype)>
        
            <cfquery name="qGetHostList" datasource="#application.dsn#">
                SELECT
                    h.hostID
				FROM
                	smg_hosts h
                INNER JOIN
                	smg_students s ON s.hostID = h.hostID
                    <!---
					AND
                        s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    --->
					AND
                        (    
                            s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                        OR 
                            s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                        )
                WHERE
                	h.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				GROUP BY
                	hostID                 
            </cfquery>

            <cfscript>
				// Add to a list
				vHostIDList = ValueList(qGetHostList.hostID);
			</cfscript>
            
        </cfif>
  
        <cfquery name="qGetResults" datasource="#application.dsn#">
            SELECT DISTINCT 
            	h.familylastname, 
                h.fatherfirstname, 
                h.motherfirstname, 
                h.hostid, 
                h.city, 
                h.state
            FROM 
            	smg_hosts h
            WHERE 
            	h.active = 1
			<!--- REGIONAL MANAGER SEES ALL FAMILIES ON THE REGION --->
            AND 
            	h.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionid#">
                
            <cfif LEN(TRIM(keyword))>
                AND (
                		h.hostid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                	OR 
                    	h.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR 
                    	h.fatherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR 
                    	h.motherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR 
                    	h.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR 
                    	h.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                    OR 
                    	h.email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                )
            </cfif>
            
            <!--- if vHostIDList is null return 0 results. --->
            <cfif listFind("6,7,9", CLIENT.usertype) AND NOT LEN(vHostIDList)>
				AND 
                	1 = 0
            <!--- Advisors, AR and Student view has limited access --->
            <cfelseif listFind("6,7,9", CLIENT.usertype) AND LEN(vHostIDList)>
                AND
                    h.hostid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vHostIDList#" list="yes"> )
            </cfif>
            	
            ORDER BY 
            	#orderby#
        </cfquery>
        
    </cfif>

	<cfif VAL(qGetResults.recordCount)>

		<cfparam name="url.startPage" default="1">
		<cfset totalPages = ceiling(qGetResults.recordCount / recordsToShow)>
		<cfset startrow = 1 + ((url.startPage - 1) * recordsToShow)>
		<cfif qGetResults.recordCount GT url.startPage * recordsToShow>
			<cfset isNextPage = 1>
			<cfset endrow = url.startPage * recordsToShow>
		<cfelse>
			<cfset isNextPage = 0>
			<cfset endrow = qGetResults.recordCount>
		</cfif>
		<cfset urlVariables = "submitted=1&regionid=#regionid#&keyword=#urlEncodedFormat(keyword)#&hosting=#hosting#&active=#active#&orderby=#orderby#&recordsToShow=#recordsToShow#">
  
        <cfoutput>

        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="?curdoc=host_fam&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="?curdoc=host_fam&startPage=#i#&#urlVariables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="?curdoc=host_fam&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                        </cfif>
                        <br />
                    </cfif>
                    Displaying #startrow# to #endrow# of #qGetResults.recordCount#
                </td>
            </tr>
        </table>
            
        <table width=100% class="section">
            <tr align="left">
                <th>ID</th>
                <th>Last Name</th>
                <th>Father</th>
                <th>Mother</th>
                <th>City</th>
                <th>State</th>
            </tr>
            <cfloop query="qGetResults" startrow="#startrow#" endrow="#endrow#">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td><a href="?curdoc=host_fam_info&hostid=#hostid#">#hostid#</a></td>
                <td>#familylastname#</td>
                <td>#fatherfirstname#</td>
                <td>#motherfirstname#</td>
                <td>#city#</td>
                <td>#state#</td>
            </tr>
            </cfloop>
        </table>
    
        </cfoutput>
	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <td>No host families matched your criteria.</td>
            </tr>
        </table>
    </cfif>
    
</cfif>
   
<cfinclude template="table_footer.cfm">