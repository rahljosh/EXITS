<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Param URL Variable --->
	<cfparam name="URL.status" default="1">
	<cfparam name="URL.sortBy" default="lastName">
    <cfparam name="URL.sortOrder" default="ASC">
	<cfparam name="URL.isProgramUnassigned" default="0">
	<cfparam name="URL.isCompanyUnassigned" default="0">
        
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
            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">            
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
        <cfif NOT ListFind("1,2,3,4,28", CLIENT.userType)>
            AND
                ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">            
        </cfif>

        <!--- Host Company Users --->
        <cfif CLIENT.userType EQ '28'>
            AND
                ec.hostCompanyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#CLIENT.hostCompanyID#">)   
        </cfif>
 
        <!--- Unassigned Program --->
        <cfif VAL(URL.isProgramUnassigned)>
            AND
                ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">            
        </cfif>

        <!--- Unassigned Company --->
        <cfif VAL(URL.isCompanyUnassigned)>
            AND
                ec.candidateID NOT IN ( 
                						SELECT 	
                                        	candidateID 
                                        FROM 
                                        	extra_candidate_place_company 
                                        WHERE 
                                        	candidateID = ec.candidateID AND status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
                                        GROUP BY
                                        	candidateID
									)
        </cfif>
           
        ORDER BY 
        	<cfswitch expression="#URL.sortBy#">
            
            	<cfcase value="candidateID">
                	ec.candidateID #URL.sortOrder#
                </cfcase>
                
                <cfcase value="lastName">
                	ec.lastName #URL.sortOrder#,
                    ec.firstName #URL.sortOrder#
                </cfcase>

                <cfcase value="firstName">
                	ec.firstName #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#                   
                </cfcase>

                <cfcase value="sex">
                	ec.sex #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#
                </cfcase>

                <cfcase value="countryName">
                	c.countryName #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#
                </cfcase>

                <cfcase value="programName">
                	p.programName #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#
                </cfcase>

                <cfcase value="businessName">
                	u.businessName #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#
                </cfcase>

                <cfdefaultcase>
                	ec.lastName #URL.sortOrder#,
                    ec.firstName #URL.sortOrder#
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
				<td width="40%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;Candidates</td>
				<td width="59%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">
					#qCandidates.recordcount#
					<cfif URL.status EQ 1>
                    	<b>Active</b>
					<cfelseif URL.status EQ 0>
                    	<b>Canceled</b>
					<cfelseif URL.status is 'all'>
                    	<b>All</b>
					</cfif>
					candidate<cfif qCandidates.recordcount GT 1>s</cfif> found &nbsp; <br>
                    
					Filter: &nbsp; 
					<a href="?curdoc=candidate/candidates&placed=all&status=all&isProgramUnassigned=#URL.isProgramUnassigned#&isCompanyUnassigned=#URL.isCompanyUnassigned#" <cfif URL.status EQ 'All'>class="filterOn"<cfelse>class="filterOff"</cfif> class="filterOff">All</a>
					&nbsp; | &nbsp; 
					
                    <a href="?curdoc=candidate/candidates&status=1&isProgramUnassigned=#URL.isProgramUnassigned#&isCompanyUnassigned=#URL.isCompanyUnassigned#" <cfif URL.status EQ 1>class="filterOn"<cfelse>class="filterOff"</cfif> >Active</a>
					&nbsp; | &nbsp; 
					
                    <a href="?curdoc=candidate/candidates&status=0&isProgramUnassigned=#URL.isProgramUnassigned#&isCompanyUnassigned=#URL.isCompanyUnassigned#" <cfif URL.status EQ 0>class="filterOn"<cfelse>class="filterOff"</cfif> >Inactive</a>
					&nbsp; | &nbsp; 
					
                    <a href="?curdoc=candidate/candidates&status=canceled&isProgramUnassigned=#URL.isProgramUnassigned#&isCompanyUnassigned=#URL.isCompanyUnassigned#" <cfif URL.status EQ 'canceled'>class="filterOn"<cfelse>class="filterOff"</cfif> >Cancelled</a>
                    &nbsp; | &nbsp; 
					
                    <a href="?curdoc=candidate/candidates&status=#URL.status#&isProgramUnassigned=#Int(NOT VAL(URL.isProgramUnassigned))#&isCompanyUnassigned=#URL.isCompanyUnassigned#" <cfif VAL(URL.isProgramUnassigned)>class="filterOn"<cfelse>class="filterOff"</cfif> >Unassigned Program</a>
                    &nbsp; | &nbsp; 
					
                    <a href="?curdoc=candidate/candidates&status=#URL.status#&isProgramUnassigned=#URL.isProgramUnassigned#&isCompanyUnassigned=#Int(NOT VAL(URL.isCompanyUnassigned))#" <cfif VAL(URL.isCompanyUnassigned)>class="filterOn"<cfelse>class="filterOff"</cfif> >Unassigned Host Company</a>
                    &nbsp;
                </td>
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
				<th width="5%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='candidateID',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">ID</a></th>
				<th width="15%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='lastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Last Name</a></th>
				<th width="12%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='firstName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">First Name</a></th>
				<th width="10%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='sex',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Sex</a></th>
				<th width="13%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='country',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Country</a></th>
				<th width="20%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='programName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Program</a></th>		
				<th width="25%" bgcolor="##4F8EA4"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='intrep',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Intl. Rep.</a></th>
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
