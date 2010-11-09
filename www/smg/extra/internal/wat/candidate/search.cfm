<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Param FORM Variable --->
	<cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.search" default="">

	<cfif FORM.submitted>

        <cfquery name="qCandidateSearch" datasource="MySql">
            SELECT 
                ec.firstname, 
                ec.lastname, 
                ec.sex, 
                ec.home_country, 
                ec.candidateid, 
                ec.programid,
                ec.intrep, 
                ec.uniqueid, 
                cl.countryname, 
                p.programname, 
                u.businessname
            FROM 
                extra_candidates ec
            LEFT JOIN 
            	smg_countrylist cl ON cl.countryid = ec.home_country 
            LEFT JOIN 
            	smg_programs p ON p.programid = ec.programid 
            LEFT JOIN 
            	smg_users u ON u.userid = ec.intrep 	
            WHERE 
                ec.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
	        AND
                applicationStatusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,11" list="yes"> )     
            AND
            	ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                
			<!--- Intl Rep Account --->
            <cfif NOT ListFind("1,2,3,4", CLIENT.userType)>
                AND
                    intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">            
            </cfif>
            <!--- Search Criteria --->
            <cfif LEN(TRIM(FORM.search))>            
                AND 
                    (
                        ec.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(TRIM(FORM.search))#">
                    OR
                        ec.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(FORM.search)#%">
                    OR
                        ec.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(FORM.search)#%">
                    OR
                        ec.degree LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(FORM.search)#%">
                    OR
                        ec.email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(FORM.search)#%">
					<cfif IsDate(FORM.search)>
                        OR
                            ec.dob = <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(CreateODBCDate(FORM.search))#">                        
                    </cfif>                        
                    )
			<cfelse>
            	AND
                	1 != 1
			</cfif>                    
            ORDER BY 
                ec.lastName
        </cfquery>
        
	</cfif>    

</cfsilent>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
	<tr>
    	<td bordercolor="##FFFFFF">

		<!----Header Table---->
		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
			<tr valign=middle height=24>
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;Search Candidate</td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">
					<cfif FORM.submitted>
                        #qCandidateSearch.recordcount# candidate<cfif qCandidateSearch.recordcount GT 1>s</cfif> found &nbsp; <br>
					</cfif>
				</td>
				<td width="1%"></td>
			</tr>
		</table>

		<br />
		
		<form id="searchForm" name="searchForm" method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
        <input type="hidden" name="submitted" value="1">
		<table width="770" border="1" align="center" cellpadding="8" cellspacing="8">	
			<tr>
				<td align="center" class="style1">
					Search Criteria: <input name="search" value="#FORM.search#" type="text" style="width:250px;" />
                    &nbsp; &nbsp; 
                    <input type="submit" name="Submit" value="Search" /> <br /><br />
                    PS: Search will be performed on candidate ID, first name, last name, DOB, email and degree fields.
				</td>
			</tr>
		</table>
		</form> <br /><br />
		
		<cfif FORM.submitted>
		
            <table border="0" cellpadding="4" cellspacing="0" class="section" align="center" width=95%>
                <tr bgcolor="##4F8EA4" >
                    <th width="5%" align="left"><a href="?curdoc=candidate/candidates&order=candidateID&status=#URL.status#" class="style2">ID</a></th>
                    <th width="15%" align="left"><a href="?curdoc=candidate/candidates&order=lastName&status=#URL.status#" class="style2">Last Name</a></th>
                    <th width="12%" align="left"><a href="?curdoc=candidate/candidates&order=firstName&status=#URL.status#" class="style2">First Name</a></th>
                    <th width="10%" align="left"><a href="?curdoc=candidate/candidates&order=sex&status=#URL.status#" class="style2">Sex</a></th>
                    <th width="13%" align="left"><a href="?curdoc=candidate/candidates&order=countryName&status=#URL.status#" class="style2">Country</a></th>
                    <th width="20%" align="left"><a href="?curdoc=candidate/candidates&order=programName&status=#URL.status#" class="style2">Program</a></th>		
                    <th width="25%" bgcolor="##4F8EA4"><a href="?curdoc=candidate/candidates&order=businessName&status=#URL.status#" class="style2">Intl. Rep.</a></th>
                </tr>
                <cfloop query="qCandidateSearch">
                    <tr bgcolor="###iif(qCandidateSearch.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                        <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qCandidateSearch.uniqueid#" class="style4">#qCandidateSearch.candidateID#</a></td>
                        <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qCandidateSearch.uniqueid#" class="style4">#qCandidateSearch.lastName#</a></td>
                        <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qCandidateSearch.uniqueid#" class="style4">#qCandidateSearch.firstName#</a></td>
                        <td class="style5"><cfif qCandidateSearch.sex EQ 'm'>Male<cfelse>Female</cfif></td>
                        <td class="style5">#qCandidateSearch.countryName#</td>
                        <td class="style5">#qCandidateSearch.programName#</td>		
                        <td class="style5">#qCandidateSearch.businessName#</td>
                    </tr>
                </cfloop>
            
                <cfif NOT qCandidateSearch.recordCount>
                    <tr bgcolor="##e9ecf1">
                        <td class="style5" colspan="7">
                        	<cfif LEN(FORM.search)>
	                            There are no records that match your criteria.
							<cfelse>
                            	You must enter a search criteria.
                            </cfif>                                
                        </td>
                    </tr>
                </cfif>
            </table>
            
            <br><br>
		
		</cfif>

		</td>
	</tr>
</table>

</cfoutput>
