<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

    <!--- Param FORM Variables --->
	<cfparam name="FORM.programID" default="">
	<cfparam name="FORM.hostCompanyID" default="0">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">

    <cfquery name="qGetProgramList" datasource="MySql">
        SELECT 
        	programID,
            programname             
        FROM 
        	smg_programs 
        WHERE 
        	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfquery>

    <cfquery name="qGetHostCompanyList" datasource="MySql">
        SELECT 
        	hostcompanyID, 
            name 
        FROM 
        	extra_hostcompany 
        WHERE         	
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND 
        	name != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        <!---
        AND
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        --->
		ORDER BY 
        	name
    </cfquery>

    <!--- FORM submitted --->
    <cfif FORM.submitted>

        <!--- Get Host Companies Assigned to Candidates --->
        <cfquery name="qGetHostCompany" datasource="MySQL">
            SELECT 
                ehc.hostCompanyID,
                ehc.name
            FROM 
            	extra_hostcompany ehc    
			INNER JOIN
            	extra_candidates ec ON ec.hostCompanyID = ehc.hostCompanyID
                	AND
                    	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
					AND
                    	ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
                    AND 
                        ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
            WHERE 
                1 = 1
                <!--- 
				ehc.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				--->
			<cfif VAL(FORM.hostcompanyID)> 
                AND
                    ehc.hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">                               
            </cfif>
       		GROUP BY
            	ehc.hostCompanyID
            ORDER BY
            	ehc.name
		</cfquery>
		
        <!--- Get All Candidates --->
        <cfquery name="qGetAllCandidates" datasource="MySQL">
            SELECT 
                c.candidateID,
                c.uniqueID,
                c.hostCompanyID,
                c.firstname,             
                c.lastname, 
                c.sex, 
                c.dob,                
                c.email, 
                c.ssn, 
                c.ds2019,
                c.startdate, 
                c.enddate, 
                c.wat_placement, 
                c.status,
                u.businessname,
                country.countryname
            FROM   
                extra_candidates c
            INNER JOIN
                smg_users u on u.userid = c.intrep
            INNER JOIN
            	extra_hostCompany ehc ON ehc.hostCompanyID = c.hostCompanyID
            LEFT JOIN 
                smg_countrylist country ON country.countryid = c.home_country
            WHERE 
                c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">    
            AND 
                c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
            AND 
                c.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
           <cfif VAL(FORM.hostcompanyID)> 
                AND
                    c.hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">                               
			</cfif>                
       		ORDER BY
                ehc.name,
                c.candidateID
		</cfquery>

        <cffunction name="filterGetAllCandidates" hint="Gets total by Host Company">
        	<cfargument name="placementType" default="" hint="Placement Type is not required">
            <cfargument name="hostCompanyID" default="0" hint="hostCompanyID is not required">
            
            <cfquery name="qFilterGetAllCandidates" dbtype="query">
                SELECT
                    *
                FROM	
                    qGetAllCandidates
                WHERE
                	1 = 1
                    
				<cfif VAL(ARGUMENTS.hostcompanyID)> 
                    AND
                        hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostcompanyID#">                               
                </cfif>                
                
                <cfif ARGUMENTS.placementType NEQ 'All'>
                    AND
                        wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.placementType#">
            	</cfif>
                
                ORDER BY 
                    candidateID
            </cfquery>
            
            <cfreturn qFilterGetAllCandidates>
        </cffunction>

		<cfscript>
			// Get Overall Results
			totalCSBPlacements = filterGetAllCandidates(placementType='CSB-Placement').recordCount;
		
			totalSelfPlacements = filterGetAllCandidates(placementType='Self-Placement').recordCount;

			totalWalkInPlacements = filterGetAllCandidates(placementType='Walk-In').recordCount;
        </cfscript>	

	</cfif>

</cfsilent>

<style type="text/css">
<!--
.tableTitleView {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	padding:2px;
	color:#FFFFFF;
	background:#4F8EA4;
}
-->
</style>

<cfoutput>

<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
<input type="hidden" name="submitted" value="1" />

    <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>&nbsp; Host Company Reports -> All active students</td>
        </tr>
        <tr valign="middle" height="24">
            <td valign="middle" colspan=2>&nbsp;</td>
        </tr>
        <tr valign="middle">
            <td align="right" valign="middle" class="style1"><b>Host Company: </b></td>
            <td valign="middle">  
                <select name="hostCompanyID" class="style1">
                    <option value="ALL">---  All Host Companies  ---</option>
                    <cfloop query="qGetHostCompanyList">
                    	<option value="#hostcompanyID#" <cfif qGetHostCompanyList.hostcompanyID EQ FORM.hostCompanyID> selected </cfif> >#qGetHostCompanyList.name#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>Program: </b></td><td>
                <select name="programID" class="style1">
                    <option value="0"></option>
                    <cfloop query="qGetProgramList">
                    	<option value="#programID#" <cfif qGetProgramList.programID EQ FORM.programID> selected </cfif> >#programname#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right" class="style1"><b>Format: </b></td>
            <td class="style1"> 
                <input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked="checked" </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked="checked" </cfif> > <label for="printOption2">Print (PDF)</label> 
                <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked="checked" </cfif> > <label for="printOption3">Excel (XLS)</label>
            </td>            
        </tr>
        <tr>
            <td colspan=2 align="center"><br />
                <input type="submit" value="Generate Report" class="style1" /><br />
            </td>
        </tr>
    </table>

</form>

<br /><br />

<!--- Print --->
<cfif FORM.submitted>
	
    <cfscript>
		// On Screen
		if (FORM.printOption EQ 1) {
			tableTitleClass = 'tableTitleView';
		} else {
			tableTitleClass = 'style2';
		}
	</cfscript>

	<cfsavecontent variable="reportContent">
		
        <cfloop query="qGetHostCompany">
			            
			<cfscript>
                // Total By Agent
                qTotalPerHostCompany = filterGetAllCandidates(placementType='ALL', hostCompanyID=qGetHostCompany.hostCompanyID);
				
				totalPerHostCompanyCSBPlacements = filterGetAllCandidates(placementType='CSB-Placement', hostCompanyID=qGetHostCompany.hostCompanyID).recordCount;
                
                totalPerHostCompanySelfPlacements = filterGetAllCandidates(placementType='Self-Placement', hostCompanyID=qGetHostCompany.hostCompanyID).recordCount;
                
                totalPerHostCompanyWalkInPlacements = filterGetAllCandidates(placementType='Walk-In', hostCompanyID=qGetHostCompany.hostCompanyID).recordCount;
            </cfscript>

            <table width=99% cellpadding="4" cellspacing=0 align="center"> 
                <tr>
                    <td colspan="12">
                        <small>
                            <strong>#qGetHostCompany.name# - Total candidates: #qTotalPerHostCompany.recordCount#</strong> 
                            (
                                #totalPerHostCompanyCSBPlacements# CSB; &nbsp; 
                                #totalPerHostCompanySelfPlacements# Self; &nbsp; 
                                #totalPerHostCompanyWalkInPlacements# Walk-In 
                            )
                        </small>
                    </td>
                </tr>
                <tr>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">ID</Td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Last Name</Td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">First Name</Td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Sex</td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">DOB</Td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Country</td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Email</td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">SSN</Td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Start Date</td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">End Date</td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Intl. Rep.</td>
                    <td align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Option</td>
                </tr>
                <cfloop query="qTotalPerHostCompany">
                    <tr <cfif qTotalPerHostCompany.currentRow mod 2>bgcolor="##E4E4E4"</cfif> >
                        <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerHostCompany.uniqueID#" target="_blank" class="style4">#qTotalPerHostCompany.candidateID#</a></td>
                        <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerHostCompany.uniqueID#" target="_blank" class="style4">#qTotalPerHostCompany.lastname#</a></td>
                        <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerHostCompany.uniqueID#" target="_blank" class="style4">#qTotalPerHostCompany.firstname#</a></td>
                        <td><span class="style1">#qTotalPerHostCompany.sex#</span></td>
                        <td><span class="style1">#dateformat(qTotalPerHostCompany.dob, 'mm/dd/yyyy')#</span></td>
                        <td><span class="style1">#qTotalPerHostCompany.countryname#</span></td>
                        <td><span class="style1">#qTotalPerHostCompany.email#</span></td>
                        <td><span class="style1">#qTotalPerHostCompany.ssn#</span></td>
                        <cfif LEN(qTotalPerHostCompany.ds2019)>
                            <td><span class="style1">#dateformat(qTotalPerHostCompany.startdate, 'mm/dd/yyyy')#</span></td>
                            <td><span class="style1">#dateformat(qTotalPerHostCompany.enddate, 'mm/dd/yyyy')# </span></td>
                        <cfelse>
                            <td colspan=2 align="center"><span class="style1">Awaiting DS-2019</span></td>
                        </cfif>
                        <td><span class="style1">#qTotalPerHostCompany.businessname#</span></td>
                        <td><span class="style1">#qTotalPerHostCompany.wat_placement#</span></td>
                    </tr>
                </cfloop>

            </table>
            <br />
         
		</cfloop>
            
        <div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #totalCSBPlacements#</div>	
        <div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #totalSelfPlacements#</div>
        <div class="style1"><strong>&nbsp; &nbsp; Walk-In:</strong> #totalWalkInPlacements#</div>
        <div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>
        <div class="style1"><strong>&nbsp; &nbsp; Total Number of Students:</strong> #qGetAllCandidates.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>  		
		    	
    </cfsavecontent>

	<!-----Display Reports---->
    <cfswitch expression="#FORM.printOption#">
    
        <!--- Screen --->
        <cfcase value="1">
            <!--- Include Report --->
            #reportContent#
        </cfcase>
    
        <!--- PDF --->
        <cfcase value="2">   
            <cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
                <style type="text/css">
                <!--
                .style1 {
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                    font-size: 10px;
                    padding:2;
                }
                .style2 {
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                    font-size: 8px;
                    padding:2;
                }
                .title1 {
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                    font-size: 15px;
                    font-weight: bold;
                    padding:5;
                }					
                -->
                </style>
    
                <img src="../../pics/black_pixel.gif" width="100%" height="2">
                <div class="title1">Students hired per company</div>
                <img src="../../pics/black_pixel.gif" width="100%" height="2">
                
                <!--- Include Report --->
                #reportContent#
            </cfdocument>
        </cfcase>
    
        <!--- Excel --->
        <cfcase value="3">
    
            <!--- set content type --->
            <cfcontent type="application/msexcel">
            
            <!--- suggest default name for XLS file --->
            <cfheader name="Content-Disposition" value="attachment; filename=studentsHiredPerCompany.xls"> 
    
            <style type="text/css">
            <!--
            .style1 {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 10px;
                padding:2;
            }
            .style2 {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 10px;
                padding:2;
            }
            .title1 {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 15px;
                font-weight: bold;
                padding:5;
            }					
            -->
            </style>
           
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
            <div class="title1">Students hired per company</div>
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
            
            <!--- Include Report --->
            #reportContent#
            
            <cfabort>
    
        </cfcase>
        
        <cfdefaultcase>    
            <div align="center" class="style1">
                Print results will replace the menu options and take a bit longer to generate. <br />
                Onscreen will allow you to change criteria with out clicking your back button.
            </div>  <br />
        </cfdefaultcase>
        
    </cfswitch>

<cfelse>

    <div align="center" class="style1">
        Print results will replace the menu options and take a bit longer to generate. <br />
        Onscreen will allow you to change criteria with out clicking your back button.
    </div>  <br />

</cfif>    

</cfoutput>