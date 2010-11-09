<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Param URL Variable --->
	<cfparam name="URL.status" default="1">
	<cfparam name="URL.order" default="lastName">

	<!--- Inactivate Students --->
    <cfquery name="qSetExpiredCandidates" datasource="mysql">
        UPDATE 
            extra_candidates
        SET 
            status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        WHERE 
            status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            endDate < <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(), 'yyyy-mm-dd')#">
    </cfquery> 
    
    <!--- Get Candidates --->   
    <cfquery name="qCandidates" datasource="MySql">
        SELECT 
        	ec.candidateID, 
            ec.firstName, 
            ec.lastName, 
            ec.sex, 
            ec.residence_country, 
            ec.programid,
        	ec.intrep, 
            ec.uniqueid, 
            c.countryName, 
            p.programName, 
            u.businessName
        FROM 
        	extra_candidates ec
        LEFT JOIN 
        	smg_countrylist c ON c.countryid = ec.residence_country 
        LEFT JOIN 
        	smg_programs p ON p.programid = ec.programid 
        LEFT JOIN 
        	smg_users u ON u.userid = ec.intrep 	
        WHERE 
        	ec.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
		AND
        	applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )     
		<cfif URL.status EQ 'canceled'>
            AND ec.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
        <cfelseif URL.status EQ 0>
            AND ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        <cfelseif URL.status EQ 1>
            AND ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        </cfif>
        
        <!--- Intl Rep Account --->
        <cfif NOT ListFind("1,2,3,4", CLIENT.userType)>
            AND
                ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">            
        </cfif>
            
        ORDER BY 
        	<cfswitch expression="#URL.order#">
            
            	<cfcase value="candidateID">
                	ec.candidateID
                </cfcase>
                
                <cfcase value="lastName">
                	ec.lastName,
                    ec.firstName
                </cfcase>

                <cfcase value="firstName">
                	ec.firstName,
                    ec.lastName                   
                </cfcase>

                <cfcase value="sex">
                	ec.sex,
                    ec.lastName
                </cfcase>

                <cfcase value="countryName">
                	c.countryName,
                    ec.lastName
                </cfcase>

                <cfcase value="programName">
                	p.programName,
                    ec.lastName
                </cfcase>

                <cfcase value="businessName">
                	u.businessName,
                    ec.lastName
                </cfcase>

                <cfdefaultcase>
                	ec.lastName,
                    ec.firstName
                </cfdefaultcase>

			</cfswitch>                	

    </cfquery>

</cfsilent>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
  <tr>
    <td bordercolor="##FFFFFF">

		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
			<tr valign=middle height=24>
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;Candidates</td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">
					#qCandidates.recordcount#
					<cfif URL.status EQ 1>
                    	<b>Active</b>
					<cfelseif URL.status EQ 0>
                    	<b>Canceled</b>
					<cfelseif URL.status is 'all'>
                    	<b>All</b>
					</cfif>
					candidate<cfif qCandidates.recordcount GT 1>s</cfif> found &nbsp; <br>
                    
					Filter: &nbsp; <cfif URL.status NEQ 'All'><a href="?curdoc=candidate/candidates&placed=all&status=all" class="style4"></cfif>All</a> 
					&nbsp; | &nbsp; <cfif URL.status NEQ 1><a href="?curdoc=candidate/candidates&status=1" class="style4" ></cfif>Active</a> 
					&nbsp; | &nbsp; <cfif URL.status NEQ 0><a href="?curdoc=candidate/candidates&status=0" class="style4" ></cfif>Inactive</a> 					
					&nbsp; | &nbsp; <cfif URL.status NEQ 'canceled'><a href="?curdoc=candidate/candidates&status=canceled" class="style4" ></cfif>Cancelled</a>&nbsp;</td>
				<td width="1%"></td>
			</tr>
		</table>

        <cfif VAL(CLIENT.userType) LTE 4>
            <br />
            <div align="center">
                <a href="index.cfm?curdoc=candidate/new_candidate"><img src="../pics/add-candidate.gif" border="0" align="middle" alt="Add a Candidate"></img></a>
            </div>
		</cfif>
		<br />
        
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
			<tr bgcolor="##4F8EA4" >
				<th width="5%" align="left"><a href="?curdoc=candidate/candidates&order=candidateID&status=#URL.status#" class="style2">ID</a></th>
				<th width="15%" align="left"><a href="?curdoc=candidate/candidates&order=lastName&status=#URL.status#" class="style2">Last Name</a></th>
				<th width="12%" align="left"><a href="?curdoc=candidate/candidates&order=firstName&status=#URL.status#" class="style2">First Name</a></th>
				<th width="10%" align="left"><a href="?curdoc=candidate/candidates&order=sex&status=#URL.status#" class="style2">Sex</a></th>
				<th width="13%" align="left"><a href="?curdoc=candidate/candidates&order=countryName&status=#URL.status#" class="style2">Country</a></th>
				<th width="20%" align="left"><a href="?curdoc=candidate/candidates&order=programName&status=#URL.status#" class="style2">Program</a></th>		
				<th width="25%" bgcolor="##4F8EA4"><a href="?curdoc=candidate/candidates&order=businessName&status=#URL.status#" class="style2">Intl. Rep.</a></th>
			</tr>
            <cfloop query="qCandidates">
                <tr bgcolor="###iif(qCandidates.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                    <td><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#candidateID#</a></td>
                    <td><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#lastName#</a></td>
                    <td><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#firstName#</a></td>
                    <td class="style5"><cfif sex EQ 'm'>Male<cfelse>Female</cfif></td>
                    <td class="style5">#countryName#</td>
                    <td class="style5">#programName#</td>		
                    <td class="style5">#businessName#</td>
                </tr>
            </cfloop>
        
			<cfif NOT qCandidates.recordCount>
                <tr bgcolor="##e9ecf1">
                    <td class="style5" colspan="7">There are no records.</td>
                </tr>
            </cfif>
		</table>
		
        <br><br>
		
        <cfif VAL(CLIENT.userType) LTE 4>
            <div align="center">
                <a href="index.cfm?curdoc=candidate/new_candidate"><img src="../pics/add-candidate.gif" border="0" align="middle" alt="Add a Candidate"></img></a>
            </div> <br>
		</cfif>
        
	</td>
  </tr>
</table>

</cfoutput>
