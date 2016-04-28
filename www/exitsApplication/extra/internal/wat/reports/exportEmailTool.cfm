<!--- ------------------------------------------------------------------------- ----
	
	File:		exportEmailTool.cfm
	Author:		Marcus Melo
	Date:		July 18, 2011
	Desc:		Incident Report

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param URL Variables --->	
    <cfparam name="URL.action" default="">

    <!--- Param FORM Variables --->	
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.hostCompanyID" default="0">
    <cfparam name="FORM.candidateStatus" default="1">
    <cfparam name="FORM.action" default="candidate">
    <cfparam name="FORM.placementType" default="all">

	<cfscript>
        qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetHostCompanyList = APPLICATION.CFC.HOSTCOMPANY.getHostCompanies(companyID=CLIENT.companyID);
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1,companyID=CLIENT.companyID);
		
		if ( LEN(URL.action) ) {
			FORM.action = URL.action;	
		}
    </cfscript>
    
    <!--- FORM Submitted --->
    <cfif FORM.submitted>
    
        <cfswitch expression="#FORM.action#">
        
        	<!--- Export Candidates --->
            <cfcase value="candidate">
                        
                <cfquery name="qGetResults" datasource="#APPLICATION.DSN.Source#">
                    SELECT 
                        ec.candidateID,
                        ec.firstname,             
                        ec.lastname,
                        ec.email,
                        ec.ds2019
                    FROM   
                        extra_candidates ec
                    WHERE 
                        ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">    
                    AND 
                        ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
                    
					<cfif LEN(FORM.candidateStatus)>
                        AND 
                            ec.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.candidateStatus#">
					</cfif>

                    <cfif VAL(FORM.intRep)> 
                        AND
                            ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intRep#">                               
                    </cfif>                
                    
                    <cfif VAL(FORM.hostcompanyID)> 
                        AND
                            ec.hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">                               
                    </cfif>                
                    
                    ORDER BY
                        ec.candidateID
                </cfquery>
            
            </cfcase>
            
            <!--- Export Host Company --->
            <cfcase value="hostCompany">

                <cfquery name="qGetResults" datasource="#APPLICATION.DSN.Source#">
        			SELECT
             			extra_candidate_place_company.hostCompanyID,      
                      	extra_hostcompany.name,      
                      	extra_hostcompany.email      
                    FROM extra_candidate_place_company
                    INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidate_place_company.hostCompanyID
                    INNER JOIN extra_candidates ON extra_candidates.candidateID = extra_candidate_place_company.candidateID
                    WHERE extra_candidates.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                    AND extra_candidates.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
                    <cfif LEN(FORM.candidateStatus)>
                    	AND extra_candidates.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.candidateStatus#">
                    </cfif>
                    <cfif FORM.placementType EQ "primary">
                    	AND extra_candidate_place_company.isSecondary = 0
                  	<cfelseif FORM.placementType EQ "secondary">
                    	AND extra_candidate_place_company.isSecondary = 1
                    </cfif>
                    AND extra_hostcompany.active = 1
                    GROUP BY extra_hostcompany.hostCompanyID
                    ORDER BY extra_hostcompany.name
                </cfquery>
                
            </cfcase>
        	
            <!--- Export Intl. Rep --->
            <cfcase value="intlRep">

				<cfquery name="qGetResults" datasource="#APPLICATION.DSN.Source#">
                    SELECT
                        u.businessName,
                        u.wat_contact,
                        u.wat_email,
                        u.email
                    FROM 
                        smg_users u
                    INNER JOIN
                        extra_candidates ec ON ec.intRep = u.userID
                    WHERE
                        ec.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                    AND	
                        ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND
                        u.businessName != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                    AND 
                        ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
                    GROUP BY
                        u.userID
                    ORDER BY
                        u.businessName
				</cfquery>    
    
            </cfcase>
            
        </cfswitch>            

    </cfif>
    
</cfsilent>

<cfoutput>

    <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="action" value="#FORM.action#" />
        
       	<cfswitch expression="#FORM.action#">
			
            <!--- Export Candidates --->
        	<cfcase value="candidate">

                <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
                    <tr height="24">
                        <td bgcolor="##E4E4E4" class="title1" colspan=2>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Mass Email Reports -> Export Candidate Email Address List</font>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" class="style1"><b>Program: </b></td>
                        <td> 
                            <select name="programID" class="style1">
                                <cfloop query="qGetProgramList">
                                    <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programid EQ FORM.programID> selected</cfif>>#qGetProgramList.programname#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" class="style1"><b>Intl. Rep.:</b> </td>
                        <td> 
                            <select name="intRep" class="style1">
                                <option value="All">---  All International Representatives  ---</option>
                                <cfloop query="qGetIntlRepList">
                                    <option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.intRep> selected</cfif> >#qGetIntlRepList.businessname#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td align="right" class="style1"><b>Host Company: </b></td>
                        <td>  
                            <select name="hostCompanyID" class="style1">
                                <option value="ALL">---  All Host Companies  ---</option>
                                <cfloop query="qGetHostCompanyList">
                                    <option value="#hostcompanyID#" <cfif qGetHostCompanyList.hostcompanyID EQ FORM.hostCompanyID> selected </cfif> >#qGetHostCompanyList.name#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" class="style1"><b>Candidate Status: </b></td>
                        <td> 
                            <select id="candidateStatus" name="candidateStatus" class="style1">
                            	<option value="" <cfif NOT LEN(FORM.candidateStatus)>selected="selected"</cfif>>All</option>
                                <option value="1" <cfif FORM.candidateStatus EQ 1>selected="selected"</cfif>>Active</option>
                                <option value="0" <cfif FORM.candidateStatus EQ 0>selected="selected"</cfif>>Inactive</option>
                                <option value="canceled" <cfif FORM.candidateStatus EQ 'canceled'>selected="selected"</cfif>>Canceled</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit" class="style1" value="Generate Report" />
                        </td>
                    </tr>
                </table> <br/>
            
            </cfcase>
			
            <!--- Export Host Company --->
        	<cfcase value="hostCompany">

                <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
                    <tr height="24">
                        <td bgcolor="##E4E4E4" class="title1" colspan=2>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Mass Email Reports -> Export Host Company Email Address List</font>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" class="style1"><b>Program: </b></td>
                        <td> 
                            <select name="programID" class="style1">
                                <cfloop query="qGetProgramList">
                                    <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programid EQ FORM.programID> selected</cfif>>#qGetProgramList.programname#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" class="style1"><b>Placement Type: </b></td>
                        <td> 
                            <select name="placementType" class="style1">
                            	<option value="" <cfif NOT LEN(FORM.placementType)>selected="selected"</cfif>>All</option>
                                <option value="primary" <cfif FORM.placementType EQ "primary">selected="selected"</cfif>>Primary</option>
                                <option value="secondary" <cfif FORM.placementType EQ "secondary">selected="selected"</cfif>>Secondary</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" class="style1"><b>Candidate Status: </b></td>
                        <td> 
                            <select id="candidateStatus" name="candidateStatus" class="style1">
                            	<option value="" <cfif NOT LEN(FORM.candidateStatus)>selected="selected"</cfif>>All</option>
                                <option value="1" <cfif FORM.candidateStatus EQ 1>selected="selected"</cfif>>Active</option>
                                <option value="0" <cfif FORM.candidateStatus EQ 0>selected="selected"</cfif>>Inactive</option>
                                <option value="canceled" <cfif FORM.candidateStatus EQ 'canceled'>selected="selected"</cfif>>Canceled</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit" class="style1" value="Generate Report" />
                        </td>
                    </tr>
                </table> <br/>
            
            </cfcase>
			
            <!--- Export Intl Rep --->
        	<cfcase value="intlRep">

                <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
                    <tr height="24">
                        <td bgcolor="##E4E4E4" class="title1" colspan=2>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Mass Email Reports -> Export Intl. Representative Email Address List</font>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" class="style1"><b>Program: </b></td>
                        <td> 
                            <select name="programID" class="style1">
                                <cfloop query="qGetProgramList">
                                    <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programid EQ FORM.programID> selected</cfif>>#qGetProgramList.programname#</option>
                                </cfloop>
                            </select> 
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit" class="style1" value="Generate Report" />
                        </td>
                    </tr>
                </table> <br/>
            
            </cfcase>

		</cfswitch>            
        
    
    </form>

	<!--- FORM submitted --->
    <cfif FORM.submitted>
        
        <cfif NOT VAL(qGetResults.recordCount)>        	
            <p style="text-align:center">No records found</p>
          	<cfabort>
        </cfif>   
        
        <cfswitch expression="#FORM.action#">
        	
            <!--- Export Candidates --->
            <cfcase value="candidate">
                    
                <!--- set content type --->
                <cfcontent type="application/msexcel">
                
                <!--- suggest default name for XLS file --->
                <cfheader name="Content-Disposition" value="attachment; filename=candidateEmailAddressList.xls"> 
                
                <table width="98%" cellpadding="4" cellspacing="0"> 
                    <tr style="font-weight:bold;">
                        <td>ID</Td>
                        <td>Last Name</Td>
                        <td>First Name</Td>
                        <td>Email Address</td>
                        <td>DS-2019</td>
                    </tr>
                    <cfloop query="qGetResults">
                        <tr>
                            <td>#qGetResults.candidateID#</td>
                            <td>#qGetResults.lastname#</td>
                            <td>#qGetResults.firstname#</td>
                            <td>#qGetResults.email#</td>
                            <td>DS-2019</td>
                        </tr>
                    </cfloop>
                </table>
            	
                <cfabort>
                
            </cfcase>
            
            <!--- Export Host Company --->
            <cfcase value="hostCompany">
    
                <!--- set content type --->
                <cfcontent type="application/msexcel">
                
                <!--- suggest default name for XLS file --->
                <cfheader name="Content-Disposition" value="attachment; filename=hostCompanyAddressList.xls"> 

                <table width="98%" cellpadding="4" cellspacing="0"> 
                    <tr style="font-weight:bold;">
                        <td>Host Company Name</Td>
                        <td>Email Address</td>
                    </tr>
                    <cfloop query="qGetResults">
                        <tr>
                            <td>#qGetResults.name#</td>
                            <td>#qGetResults.email#</td>
                        </tr>
                    </cfloop>
                </table>
            	
                <cfabort>
            
            </cfcase>
        	
            <!--- Export Intl. Rep. --->
            <cfcase value="intlRep">
    
                <!--- set content type --->
                <cfcontent type="application/msexcel">
                
                <!--- suggest default name for XLS file --->
                <cfheader name="Content-Disposition" value="attachment; filename=intlRepAddressList.xls"> 

                <table width="98%" cellpadding="4" cellspacing="0"> 
                    <tr style="font-weight:bold;">
                        <td>Business Name</Td>
                        <td>WAT Contact</Td>
                        <td>WAT Email Address</td>
                        <td>Email Address</td>
                    </tr>
                    <cfloop query="qGetResults">
                        <tr>
                            <td>#qGetResults.businessName#</td>
                            <td>#qGetResults.wat_contact#</td>
                            <td>#qGetResults.wat_email#</td>
                            <td>#qGetResults.email#</td>
                        </tr>
                    </cfloop>
                </table>
            	
                <cfabort>
    
            </cfcase>
            
        </cfswitch>            
    
    </cfif>
	
</cfoutput>    