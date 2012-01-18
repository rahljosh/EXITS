<Cfif isDefined('form.approvehostApp')> 
 	<cfquery name="approvehostApp" datasource="#application.dsn#">
        update smg_hosts
        set HostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#"> 
        where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.hostid#">  
        </cfquery> 
	<cfif client.usertype eq 7>  
        <cfquery name="getEmail" datasource="#application.dsn#">
        select advisorid, email
        from user_access_rights uar
        left outer join smg_users u on u.userid = uar.advisorid
        where uar.userid = #client.userid# and regionid = #client.regionid#
        </cfquery>
            <cfif getEmail.advisorid eq 0>
                <cfscript>
                // Get Host Mother CBC
                getEmail = APPCFC.user.getRegionalManager(
                    regionid= #client.regionid#
                );
                </cfscript>
            </cfif>
        <cfelseif client.usertype eq 6>
        	<cfscript>
                // Get Host Mother CBC
                getEmail = APPCFC.user.getRegionalManager(
                    regionid= #client.regionid#
                );
                </cfscript>
        <cfelseif client.usertype lte 5>
        	
            <cfscript>
                // Get Host Mother CBC
                getEmail = APPCFC.region.getRegionFacilitatorByRegionID(
                    regionid= #client.regionid#
                );
                </cfscript>
        </cfif>
        <cfoutput>
        <!-----Send email indicationg app was approved---->
    <cfquery name="hostInfo" datasource="mysql">
    select familylastname
    from smg_hosts where hostid = #url.hostid#
    </Cfquery>
   
   <cfsavecontent variable="emailMessage">
                <p>The attached application was approved by #client.name# on #dateformat(now(), 'mm/dd/yyyy')#</p>
               ******Would be sent to*****
               sent to #getEmail.email#
   			   ***************************
   </cfsavecontent>
            
            <!--- Create PDF File - Include Profile and Letters --->
            <cfdocument name="HostApp" format="pdf">
	            <!--- Include Application Template --->
                <cfinclude template="appForPDF.cfm">
            </cfdocument>
            
            <!--- Save PDF File --->
            
            <cffile action="write" file="#AppPath.temp#HostApplication.pdf" output="#HostApp#" nameconflict="overwrite">    
           
            
            <!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#client.email#">
                <cfinvokeargument name="email_subject" value="Host Application APPROVED for #hostInfo.familylastname# family ">
                <cfinvokeargument name="email_message" value="#emailMessage#">
                <cfinvokeargument name="email_from" value="""Host Application Support"" <HostApplication@iseusa.com>">
                <!--- Attach Students Profile  --->
                <cfinvokeargument name="email_file" value="#AppPath.temp#HostApplication.pdf">
         		
               
               
            </cfinvoke>
      </cfoutput>


</Cfif>


<cfparam name="form.submitted" default="0">
<cfparam name="form.regionid" default="#client.regionid#">
<cfparam name="form.keyword" default="">
<cfparam name="form.status" default="8">
<cfparam name="form.active" default="1">
<cfparam name="form.orderby" default="familylastname">
<cfparam name="form.recordsToShow" default="25">

<br>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor="#ffffff">
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=30 background="pics/header_background.gif"><img src="pics/family.gif"></td>
        <td background="pics/header_background.gif"><h2>Host Family Applications</h2></td>
        <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=forms/host_fam_form">Add Host Family</a></td>
    	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
	<cfif client.usertype LTE 4>
        <td>
			<!--- GET ALL REGIONS --->
            <cfquery name="list_regions" datasource="#application.dsn#">
                SELECT regionid, regionname
                FROM smg_regions
                WHERE company = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                AND subofregion = 0
                ORDER BY regionname
            </cfquery>
            Region<br />
            
            
			<cfselect NAME="regionid" query="list_regions" value="regionid" display="regionname" selected="#form.regionid#" queryPosition="below">
				<option value="0" <cfif form.regionid eq 0>selected</cfif>>Unassigned</option>
                <option value="" <cfif form.regionid is ''>selected</cfif>>All</option>
                
			</cfselect>
        </td>
	</cfif>
        <td>
            Keyword / ID<br />
			<cfinput type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
        </td>
	<cfif client.usertype LTE 4>
        <td>
            Status<br />
			<select name="status">
				<option value="">All</option>
				<option value="8" <cfif form.status EQ 8>selected</cfif>>Filling Out</option>
				<option value="7" <cfif form.status EQ 7>selected</cfif>>Waiting on Area Representative</option>
                <option value="6" <cfif form.status EQ 6>selected</cfif>>Waiting on Regional Advisor</option>
                <option value="5" <cfif form.status EQ 5>selected</cfif>>Waiting on Regional Manager</option>
                <option value="4" <cfif form.status EQ 4>selected</cfif>>Waiting on Program Manager</option>
                
			</select>
            
        </td>
        <td>
            Active<br />
			<select name="active">
				<option value="">All</option>
				<option value="1" <cfif form.active EQ 1>selected</cfif>>Yes</option>
				<option value="0" <cfif form.active EQ 0>selected</cfif>>No</option>
			</select>            
        </td>
	</cfif>
        <td>
            Order By<br />
            <select name="orderby">
                <option value="hostid" <cfif form.orderby EQ 'hostid'>selected</cfif>>ID</option>
                <option value="familylastname" <cfif form.orderby EQ 'familylastname'>selected</cfif>>Last Name</option>
                <option value="fatherfirstname" <cfif form.orderby EQ 'fatherfirstname'>selected</cfif>>Father</option>
                <option value="motherfirstname" <cfif form.orderby EQ 'motherfirstname'>selected</cfif>>Mother</option>
                <option value="city" <cfif form.orderby EQ 'city'>selected</cfif>>City</option>
                <option value="state" <cfif form.orderby EQ 'state'>selected</cfif>>State</option>
            </select>            
        </td>
        <td>
            Records Per Page<br />
            <select name="recordsToShow">
                <option <cfif form.recordsToShow EQ 25>selected</cfif>>25</option>
                <option <cfif form.recordsToShow EQ 50>selected</cfif>>50</option>
                <option <cfif form.recordsToShow EQ 100>selected</cfif>>100</option>
                <option <cfif form.recordsToShow EQ 250>selected</cfif>>250</option>
                <option <cfif form.recordsToShow EQ 500>selected</cfif>>500</option>
            </select>            
        </td>
    </tr>
</table>
</cfform>

<cfif submitted>

	<!--- OFFICE PEOPLE AND ABOVE --->
    <cfif client.usertype LTE 4>
        
        <cfquery name="getResults" datasource="#application.dsn#">
            SELECT h.hostid, h.familylastname, h.fatherfirstname, h.motherfirstname, h.city, h.state, h.HostAppStatus, smg_regions.regionname
            FROM smg_hosts h
            LEFT OUTER JOIN smg_regions on smg_regions.regionid = h.regionid 
            WHERE h.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
           
            <cfif form.regionid NEQ '' and form.regionid is not ''>
                AND h.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.regionid#">
            </cfif>
			
            <cfif trim(keyword) NEQ ''>
                AND (
                	h.hostid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                	OR h.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.fatherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.motherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                )
            </cfif>
            <Cfif val(form.status)>
               	AND h.HostAppStatus = #form.status#    
            </Cfif>
			<cfif form.active NEQ ''>
                AND h.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.active#">
            </cfif>
            ORDER BY #form.orderby#
        </cfquery>
    
    <!--- FIELD --->
    <cfelse>
        
        <!---- REGIONAL ADVISOR ----->
        <cfif client.usertype EQ 6>
			<cfset hostlist = ''>
        	<!--- get reps who the user is the advisor of, and in the region. --->
            <cfquery name="areareps" datasource="#application.dsn#">
                SELECT userid
                FROM user_access_rights
                WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
                AND (advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                OR userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">) 
                GROUP BY userid
                ORDER BY userid
            </cfquery>
            <cfloop query="areareps">
                <cfquery name="hosts_under_reps" datasource="#application.dsn#">
                    SELECT DISTINCT hostid
                    FROM smg_students 
                    WHERE arearepid = '#areareps.userid#'
                    OR placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                    UNION
                    SELECT DISTINCT hostid
                    FROM smg_hosts
                    WHERE arearepid = '#areareps.userid#'
                    ORDER BY hostid
                </cfquery>
                <cfif hosts_under_reps.recordcount NEQ 0>	
					<!--- we're inside a loop so need listAppend. --->
                    <cfset hostlist = listAppend(hostlist, valueList(hosts_under_reps.hostid))>>
                </cfif>
            </cfloop>
        <!--- AREA REP - STUDENTS VIEW --->
        <cfelseif listFind("7,9", client.usertype)>
			<cfset hostlist = ''>
            <cfquery name="host_under_area" datasource="#application.dsn#">
                SELECT DISTINCT hostid
                FROM smg_students 
                WHERE arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                OR placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                UNION
                SELECT DISTINCT hostid
                FROM smg_hosts 
                WHERE arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                ORDER BY hostid
            </cfquery>
			<cfset hostlist = valueList(host_under_area.hostid)>
        </cfif>
    
        <cfquery name="getResults" datasource="#application.dsn#">
            SELECT DISTINCT h.familylastname, h.fatherfirstname, h.motherfirstname, h.hostid, h.city, h.state
            FROM smg_hosts h
            WHERE h.active = 1
			<!--- REGIONAL MANAGER SEES ALL FAMILIES ON THE REGION --->
            AND h.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
            <cfif trim(keyword) NEQ ''>
                AND (
                	h.hostid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(keyword)#">
                	OR h.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.fatherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.motherfirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                	OR h.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(keyword)#%">
                )
            </cfif>
            <cfif listFind("6,7,9", client.usertype)>
				<!--- if hostlist is null return 0 results. --->
                <cfif hostlist EQ ''>
                    AND 1 = 0
                <cfelse>
                    AND h.hostid IN (#hostlist#)
                </cfif>
            </cfif>		
            ORDER BY #orderby#
        </cfquery>
        
    </cfif>
	
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
		<cfset urlVariables = "submitted=1&regionid=#regionid#&keyword=#urlEncodedFormat(keyword)#&status=#status#&active=#active#&orderby=#orderby#&recordsToShow=#recordsToShow#">
    
        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="">NEXT ></a>
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
                <th>Father</th>
                <th>Mother</th>
                <th>City</th>
                <th>State</th>
                <th>Region</th>
                <th>Student</th>
                <th>Status</th>
                <th>% Complete</th>
                <th>Approve</th>
            </tr>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
                <cfquery name="RegionName" datasource="#application.dsn#">
                    select regionname
                    from smg_regions
                    where regionid = #client.regionid#
                </cfquery>
				<Cfset statusBar = #RandRange(25,100)#>
                <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#" height="30">
                    <td><a href="hostApplication/viewApp.cfm?hostid=#hostid#" target="_blank">#hostid#</a></td>
                    <td>#familylastname#</td>
                    <td>#fatherfirstname#</td>
                    <td>#motherfirstname#</td>
                    <td>#city#</td>
                    <td>#state#</td>
                    <td>#regionname#</td>
                    <td></td>
                    <td>
                        <cfif hostAppStatus eq 8>Filling out</cfif>
                        <cfif hostAppStatus eq 7>Waiting on Area Rep</cfif>
                        <cfif hostAppStatus eq 6>Waiting on Regional Advisor</cfif>
                        <cfif hostAppStatus eq 5>Waiting on Regional Manager</cfif>
                        <cfif hostAppStatus eq 4>Waiting on Program Manager</cfif>
                        <cfif hostAppStatus eq 3>Approved</cfif>
                    </td>
                    <td>
                    
                    <cfinclude template="appStatus.cfm">
                    <cfset barLength = Round((#appNotComplete# / 300) * 100)>
                    <cfif barLength gte 99><cfset barLength = 99></cfif>
                    <img src="pics/gradient.png" alt="Percentage Complete" name="Percent Complete" width="#barLength#" height=10 />&nbsp;<em>#barLength#%</em></td>
                    <td>
					<cfif hostAppStatus lte #client.usertype#>
                  		Submitted
                  <cfelse>
                      <form method="post" action="index.cfm?curdoc=hostApplication/hostAppIndex&hostid=#hostid#">
                        <input type="image" src="pics/approve.gif" value="ApproveApp"/>
                        <input type="hidden" name="approveHostApp" />
                        <input name="submitted" type="hidden" value="1">
                      </form>
                  </cfif> </td>
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

<cfinclude template="../table_footer.cfm">