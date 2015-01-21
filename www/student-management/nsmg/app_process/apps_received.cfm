<!--- ONLY OFFICE USERS --->
<cfif not CLIENT.usertype LTE 4>
	You do not have the rights to see this page.
	<cfabort>
</cfif>

<cfparam name="submitted" default="0">
<cfparam name="status" default="received">
<cfparam name="keyword" default="">
<cfparam name="orderby" default="familylastname">
<cfparam name="recordsToShow" default="25">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor="#ffffff">
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=30 background="pics/header_background.gif"><img src="pics/family.gif"></td>
        <td background="pics/header_background.gif"><h2>Students Received</h2></td>
        <td background="pics/header_background.gif" align="right">
        	<a href="index.cfm?curdoc=app_process/new_paper_app">Add Student</a>
        </td>
    	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=app_process/apps_received" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
        <td>
            Status<br />
			<select name="status">
				<option value="received" <cfif status EQ 'received'>selected</cfif>>Received</option>
				<option value="hold" <cfif status EQ 'hold'>selected</cfif>>On Hold</option>
				<option value="denied" <cfif status EQ 'denied'>selected</cfif>>Denied</option>
			</select>            
        </td>
        <td>
            Keyword / ID<br />
			<cfinput type="text" name="keyword" value="#keyword#" size="10" maxlength="50">         
        </td>
        <td>
            Order By<br />
            <select name="orderby">
                <option value="studentid" <cfif orderby EQ 'studentid'>selected</cfif>>ID</option>
                <option value="familylastname" <cfif orderby EQ 'familylastname'>selected</cfif>>Last Name</option>
                <option value="firstname" <cfif orderby EQ 'firstname'>selected</cfif>>First Name</option>
                <option value="sex" <cfif orderby EQ 'sex'>selected</cfif>>Sex</option>
                <option value="countryname" <cfif orderby EQ 'countryname'>selected</cfif>>Country</option>
                <option value="randid" <cfif orderby EQ 'randid'>selected</cfif>>Type</option>
                <option value="app_program" <cfif orderby EQ 'app_program'>selected</cfif>>Program</option>
                <option value="businessname" <cfif orderby EQ 'businessname'>selected</cfif>>Intl. Agent</option>
                <cfif status EQ 'hold'>
                    <option value="hold_reason" <cfif orderby EQ 'hold_reason'>selected</cfif>>Hold Reason</option>
                </cfif>
                <option value="companyshort" <cfif orderby EQ 'companyshort'>selected</cfif>>Company</option>
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

<cfif submitted>

    <cfquery name="getResults" datasource="#application.dsn#">
        SELECT 
        	s.studentid, 
            s.uniqueid, 
            s.familylastname, 
            s.firstname, 
            s.dob, 
            s.sex, 
            s.countryresident, 
            s.active, 
            s.app_current_status, 
            s.app_indicated_program, 
            s.dateapplication, 
            s.hostid, 
            s.randid, 
            s.companyid,
            smg_countrylist.countryname, 
            p.app_program, 
            c.companyshort, 
            u.businessname, 
            hold.hold_reason
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON u.userid = s.intrep
        <!--- we need a left join on smg_companies because unassigned students can show up. --->
        LEFT JOIN 
        	smg_companies c ON c.companyid = s.companyid
        LEFT JOIN 
        	smg_countrylist ON countryresident = smg_countrylist.countryid
        LEFT JOIN 
        	smg_student_app_programs p ON p.app_programid = s.app_indicated_program
        LEFT JOIN 
        	smg_student_app_hold hold ON hold.holdid = s.onhold_reasonid
        WHERE 1=1
        
        <!--- Filter out CASE, Canada and ESI if under ISE --->
		<cfif CLIENT.companyID EQ 5>
            AND 
            	s.companyid NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="10,13,14" list="yes"> )
        <cfelse>
            AND 
            	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
        
        <cfif status EQ 'received'>
            AND 
            	s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
            AND 
            	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfelseif status EQ 'hold'>
            AND 
            	s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="10">
            AND 
            	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfelseif status EQ 'denied'>
            AND
            	s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="9">
        </cfif>
        
        <cfif LEN(keyword)>
            AND 
            	(
                	s.studentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#keyword#">
                OR 
                	s.familylastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
                OR 
                	s.firstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
                OR 
                	smg_countrylist.countryname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
                OR 
                	p.app_program LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
                OR 	
                	u.businessname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
                OR 
                	hold.hold_reason LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#keyword#%">
            	)
        </cfif>
        
        ORDER BY <cfqueryparam cfsqltype="cf_sql_varchar" value="#orderby#">
    </cfquery>

	<cfif getResults.recordCount>

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
		<cfset urlVariables = "submitted=1&status=#status#&keyword=#urlEncodedFormat(keyword)#&orderby=#orderby#&recordsToShow=#recordsToShow#">
    
        <cfoutput>
    
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr align="center">
                <td>
					<cfif totalPages GT 1>
                        <cfif url.startPage NEQ 1>
                            <a href="index.cfm?curdoc=app_process/apps_received&startPage=#url.startPage - 1#&#urlVariables#">< PREV</a> &nbsp;
                        </cfif>
                        <cfloop from="1" to="#totalPages#" index="i">
                            <cfif i is url.startPage>#i#<cfelse><a href="index.cfm?curdoc=app_process/apps_received&startPage=#i#&#urlVariables#">#i#</a></cfif>
                        </cfloop>
                        <cfif isNextPage>
                            &nbsp; <a href="index.cfm?curdoc=app_process/apps_received&startPage=#url.startPage + 1#&#urlVariables#">NEXT ></a>
                        </cfif>
                        <br>
                    </cfif>
                    Displaying #startrow# to #endrow# of #getResults.recordCount#
                </td>
            </tr>
        </table>
            
        <table width=100% class="section">
            <tr align="left" style="font-weight:bold;">
                <td>ID</td>
                <td>Last Name</td>
                <td>First Name</td>
                <td>Sex</td>
                <td>Country</td>
                <td>Type</td>
                <td>Program</td>
                <td>Intl. Agent</td>
                <cfif status EQ 'hold'>
	                <td>Hold Reason</td>
                <cfelseif status EQ 'denied'>
	                <td>Denied By</td>
                </cfif>
                <td>Company</td>            
                <td>Actions</td>
            </tr>
            <cfloop query="getResults" startrow="#startrow#" endrow="#endrow#">
				<cfif dateapplication GT CLIENT.lastlogin>
                    <cfset bgcolor="##e2efc7">
                <cfelseif DateDiff('d',dateapplication, now()) GTE 25 AND DateDiff('d',dateapplication, now()) LTE 34>
                    <cfset bgcolor="##B3D9FF">
                <cfelseif DateDiff('d',dateapplication, now()) GTE 35 AND DateDiff('d',dateapplication, now()) LTE 49>
                    <cfset bgcolor="##FFFF9D">
                <cfelseif DateDiff('d',dateapplication, now()) GTE 50>
                    <cfset bgcolor="##FF9D9D">
                <cfelse>
                    <cfset bgcolor="">
                </cfif>
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                    <td bgcolor="#bgcolor#">
                        <cfif status EQ 'received'>
                        	<a href="index.cfm?curdoc=app_process/app_received_info&studentid=#studentid#">#studentid#</a>
                        <cfelseif status EQ 'hold'>
                        	<a href="index.cfm?curdoc=app_process/app_onhold_info&studentid=#studentid#">#studentid#</a>
                        <cfelseif status EQ 'denied'>
                        	<a href="index.cfm?curdoc=app_process/deny_app_info&studentid=#studentid#">#studentid#</a>
                        </cfif>
                    </td>
                    <td>
                        <cfif status EQ 'received'>
                        	<a href="index.cfm?curdoc=app_process/app_received_info&studentid=#studentid#">#familylastname#</a>
                        <cfelseif status EQ 'hold'>
                        	<a href="index.cfm?curdoc=app_process/app_onhold_info&studentid=#studentid#">#familylastname#</a>
                        <cfelseif status EQ 'denied'>
                        	<a href="index.cfm?curdoc=app_process/deny_app_info&studentid=#studentid#">#familylastname#</a>
                        </cfif>
					</td>                    
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
                    	<cfif randid EQ 0>
                        	Paper
                        <cfelse>
                        	Online
                        </cfif>
                    </td>
                    <td>#app_program#</td>
                    <td>#businessname#</td>
                    <cfif status EQ 'hold'>
	                    <td>#hold_reason#</td>
                    <cfelseif status EQ 'denied'>
                        <cfquery name="denied_by" datasource="#application.dsn#" maxrows="1">
                            SELECT u.firstname, u.lastname
                            FROM smg_student_app_status hist
                            INNER JOIN smg_users u ON u.userid = hist.approvedby
                            WHERE hist.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                            AND hist.status = 9
                            ORDER BY hist.date DESC
                        </cfquery>	
	                    <td>#denied_by.firstname# #denied_by.lastname#</td>
                    </cfif>
                    <td>
                    	<cfif NOT VAL(companyid)>
                        	<a href="index.cfm?curdoc=app_process/apps_received_assignment&studentid=#studentid#">[ Assign ]</a>
                        <cfelse>
                        	#companyshort#
                        </cfif>
                    </td>
                    <td>
                        <cfif status EQ 'received'>
                            <a href="javascript:openPopUp('student_app/index.cfm?curdoc=approve_student_app&unqid=#uniqueid#', 800, 700);">[ Approve ]</a>
                            <!--- 
							<cfif VAL(companyID)>
                                &nbsp; | &nbsp;   	
                                <a href="index.cfm?curdoc=app_process/onhold_app&studentid=#studentid#">[ Hold ]</a>
                                &nbsp; | &nbsp;   	
                                <a href="javascript:openPopUp('student_app/index.cfm?curdoc=deny_application&unqid=#uniqueid#', 800, 700);">[ Deny ]</a>
                                &nbsp; | &nbsp;   	
                                <a href="index.cfm?curdoc=app_process/transfer_app&studentid=#studentid#">[ Transfer ]</a>	
                            </cfif>
							--->
                        </cfif>
                    </td>
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
                        <td>Waiting for 25-34 days.</td>
                      </tr>
                    </table>
                </td>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="FFFF9D" width="15">&nbsp;</td>
                        <td>Waiting for 35-49 days.</td>
                      </tr>
                    </table>
                </td>
                <td>
                    <table>
                      <tr>
                        <td bgcolor="FF9D9D" width="15">&nbsp;</td>
                        <td>Waiting more than 50 days.</td>
                      </tr>
                    </table>
                </td>
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
   
<cfinclude template="../table_footer.cfm">