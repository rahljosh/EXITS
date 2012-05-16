<!--- ------------------------------------------------------------------------- ----
	
	File:		missingCheckedInDate.cfm
	Author:		James Griffiths
	Date:		May 16, 2012
	Desc:		Candidates by State and City.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param FORM Variables --->	
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.stateID" default="0">
    <cfparam name="FORM.printOption" default="0">

    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		
		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
	</cfscript>
    
    <cfquery name="qGetCandidates" datasource="mySql">
    	SELECT DISTINCT
        	c.candidateID,
            c.uniqueID,
            c.firstname,
            c.lastname,
            c.sex,
            c.email,
            c.startdate,
            c.enddate,
            c.ds2019,
            c.wat_placement,
            h.city,
            h.state,
            r.firstname AS repFirstName,
            r.lastname AS repLastName,
            r.userID AS repID,
            ej.title
     	FROM
        	extra_candidates c
      	INNER JOIN
        	extra_hostCompany h ON c.hostCompanyID = h.hostCompanyID
      	INNER JOIN
        	smg_users r ON r.userID = c.intrep
      	INNER JOIN
        	extra_candidate_place_company ecpc ON ecpc.candidateID = c.candidateID
       	LEFT OUTER JOIN
        	extra_jobs ej ON ej.ID = ecpc.jobID
      	WHERE
        	c.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		<cfif FORM.programID GT 0>
        	AND
            	c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
    	</cfif>
        <cfif FORM.stateID GT 0> 
            AND
                h.state = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.stateID#">
      	</cfif>
        ORDER BY
        	state
    </cfquery>
    
    <cfquery name="qGetStates" datasource="mySql">
    	SELECT
        	ID,
            state,
            stateName
      	FROM
        	smg_states
       	WHERE
        	1=1
            <cfif FORM.stateID GT 0>
            	AND ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.stateID#">
           	</cfif>
       	ORDER BY
        	stateName
    </cfquery>

</cfsilent>

<cfoutput>

<form action="index.cfm?curdoc=reports/candidatesByStateAndCity" method="post">
    
    <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Candidates by State and City</font>
            </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1" width="45%"><b>Program: </b></td>
            <td> 
            	<select name="programID" class="style1">
                    <option value="0">ALL</option>
                    <cfloop query="qGetProgramList">
                        <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programid eq FORM.programID> selected</cfif>>#qGetProgramList.programname#</option>
                    </cfloop>
                </select>
	        </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>State: </b></td>
            <td> 
            	<select name="stateID" class="style1">
                    <option value="0">ALL</option>
                    <cfloop query="qGetStateList">
                        <option value="#qGetStateList.ID#" <cfif qGetStateList.ID eq FORM.stateID> selected</cfif>>#qGetStateList.state#</option>
                    </cfloop>
                </select>
	        </td>
        </tr>
        <tr>
            <td align="right"  class="style1"><b>Format: </b></td>
            <td class="style1"> 
            	<input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2">Print</label>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
        		<br /> <input type="submit" class="style1" value="Generate Report" />
			</td>
        </tr>
    </table> <br/>

</form>

</cfoutput>

<cfsavecontent variable="reportContent">
   
    <cfoutput>  
        <div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #qGetCandidates.recordCount#</div>	
    </cfoutput>    

    <img src="../../pics/black_pixel.gif" width="100%" height="2">
    
    <cfloop query="qGetStates">
    	
        <cfquery name="qGetNumState" dbtype="query">
        	SELECT
            	*
           	FROM
            	qGetCandidates
           	WHERE
            	qGetCandidates.state = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStates.ID#">
       	</cfquery>
        
        <cfquery name="qGetCities" dbtype="query">
        	SELECT DISTINCT
            	city
          	FROM
            	qGetNumState
           	ORDER BY
            	city
      	</cfquery>          	
                
		<cfoutput>
        
            <table width="98%" cellpadding="3" cellspacing="0" align="center" style="margin-top:20px; margin-bottom:20px; border:1px solid ##4F8EA4"> 
                <tr style="font-weight:bold;">
                    <td colspan="4" style="font-weight:bold; font-size: 12px;">#qGetStates.statename#: #qGetNumState.recordCount#</td>
                </tr>
                
                <cfloop query="qGetCities">
                	
                    <cfquery name="qGetNumCity" dbType="query">
                    	SELECT
                        	*
                       	FROM
                        	qGetNumState
                      	WHERE
                        	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCities.city#">
                      	ORDER BY
                        	lastname
                   	</cfquery>
                    
                	<tr style="font-weight:bold;">
                        <td colspan="4" style="font-weight:bold; font-size: 12px;">&nbsp;&nbsp&nbsp;&nbsp;&nbsp;#qGetCities.city#: #qGetNumCity.recordCount#</td>
                    </tr>
                    
                    <tr style="background-color:##4F8EA4; color:##FFF; padding:5px; font-weight:bold; font-size: 12px;">
                        <td width="5%">ID</Td>
                        <td width="11%">Last Name</td>
                        <td width="11%">First Name</td>
                        <td width="5%">Gender</td>
                        <td width="10%">E-mail</td>
                        <td width="7%">Start Date</td>
                        <td width="7%">End Date</td>
                        <td width="10%">Placement Information</td>
                        <td width="10%">Job Title</td>
                        <td width="10%">DS-2019</td>
                        <td width="14%">Intl. Rep.</td>
                    </tr>
                
                	<cfscript>
						vRowCount = 0;
					</cfscript>
                    
                    <cfloop query="qGetNumCity">
                    	
                        <cfscript>
							vRowCount = vRowCount + 1;
						</cfscript>
                        
                        <tr bgcolor="###IIf(vRowCount MOD 2 ,DE("FFFFFF") ,DE("E4E4E4") )#" style="font-size:11px;">
                        	<td valign="top">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetNumCity.uniqueID#" target="_blank" class="style4">
                                    #qGetNumCity.candidateid#
                                </a>
                            </td>
                            <td>#qGetNumCity.lastname#</td>
                            <td>#qGetNumCity.firstname#</td>
                            <td><cfif qGetNumCity.sex EQ "f">Female<cfelse>Male</cfif></td>
                            <td>#qGetNumCity.email#</td>
                            <td>#DateFormat(qGetNumCity.startdate, 'mm/dd/yyyy')#</td>
                            <td>#DateFormat(qGetNumCity.enddate, 'mm/dd/yyyy')#</td>
                            <td>#qGetNumCity.wat_placement#</td>
                            <td>#qGetNumCity.title#</td>
                            <td>#qGetNumCity.ds2019#</td>
                            <td>#qGetNumCity.repFirstName# #qGetNumCity.repLastName# ###qGetNumCity.repID#</td>
                        </tr>
                        
                    </cfloop>
                    
                    <tr height="10px"><td></td></tr>
                
           		</cfloop>
            
            </table>
                
        </cfoutput>
        
    </cfloop>
    
    <cfoutput>
        <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br/><br/>
        <span  class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>     
    </cfoutput>
</cfsavecontent>


	<cfoutput>
    
        <!-----Display Reports---->
        <cfswitch expression="#FORM.printOption#">
        
            <!--- Screen --->
            <cfcase value="1">
                <!--- Include Report --->
                #reportContent#
            </cfcase>
            
            <!--- Print --->
            <cfcase value="2">
                <cfdocument format="PDF" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
                    <style type="text/css">
                    <!--
                    .style1 { 
                        font-family: Arial, Helvetica, sans-serif;
                        font-size: 10;
                        }
                    -->
                    </style>
                    
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <strong><font size="4" face="Verdana, Arial, Helvetica, sans-serif" >Candidates by State and City</font></strong><br>                
                    
                    <!--- Include Report --->
                    #reportContent#
                </cfdocument>
            </cfcase>
        
            <cfdefaultcase>    
                <div align="center" class="style1">
                    Print results will replace the menu options and take a bit longer to generate. <br />
                    Onscreen will allow you to change criteria with out clicking your back button.
                </div>
            </cfdefaultcase>
            
        </cfswitch>
    
    </cfoutput>