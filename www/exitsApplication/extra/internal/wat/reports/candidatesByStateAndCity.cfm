<!--- ------------------------------------------------------------------------- ----
	
	File:		candidatesByStateAndCity.cfm
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
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.studentStatus" default="All">

    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
	</cfscript>
    
    <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
    	SELECT DISTINCT
        	c.candidateID,
            c.uniqueID,
            c.companyID,
            c.programID,
            c.firstname,
            c.lastname,
            c.sex,
            c.email,
            c.startdate,
            c.enddate,
            c.wat_placement,
            c.hostCompanyID,
            c.ds2019,
            h.city,
            h.state,
            cntry.countryName AS country,
            r.firstname AS repFirstName,
            r.lastname AS repLastName,
            r.userID AS repID,
            r.businessName,
            com.companyShort,
            p.programName,
            eir.subject
     	FROM
        	extra_candidates c
      	INNER JOIN
        	extra_hostcompany h ON c.hostCompanyID = h.hostCompanyID
      	INNER JOIN
        	smg_users r ON r.userID = c.intrep
       	INNER JOIN
        	smg_companies com ON com.companyID = c.companyID
       	INNER JOIN
        	smg_programs p ON p.programID = c.programID
       	INNER JOIN
        	smg_countrylist cntry ON cntry.countryID = c.citizen_country
       	LEFT JOIN
            extra_incident_report eir ON eir.candidateID = c.candidateID
            AND
                eir.isSolved = 0
            AND
                eir.subject = "Terminated"
      	WHERE
        	c.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
        <cfif FORM.studentStatus NEQ 'All'>
        	AND
            	c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentStatus#">
        </cfif>    
		<cfif FORM.programID GT 0>
        	AND
            	c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
    	</cfif>
        <cfif FORM.stateID GT 0> 
            AND
                h.state = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.stateID#">
      	</cfif>
        GROUP BY
        	c.candidateID
        ORDER BY
        	state
    </cfquery>
    
    <cfquery name="qGetStates" datasource="#APPLICATION.DSN.Source#">
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
            <td valign="middle" align="right" class="style1"><b>Student Status:</b></td>
            <td> 
                <select name="studentStatus" class="style1">
                    <option value="All" <cfif "All" eq FORM.studentStatus> selected</cfif>>All</option>
                    <option value="1" <cfif 1 eq FORM.studentStatus> selected</cfif>>Active</option>
                    <option value="0" <cfif 0 eq FORM.studentStatus> selected</cfif>>Inactive</option>
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
            	<input type="hidden" name="submitted" id="submitted" value="1" />
        		<br /> <input type="submit" class="style1" value="Generate Report" />
			</td>
        </tr>
    </table> <br/>

</form>

</cfoutput>

<cfif FORM.submitted>

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
            
            	<cfif VAL(qGetNumState.recordCount)>
            
                    <table width="98%" cellpadding="3" cellspacing="0" align="center" style="margin-top:20px; margin-bottom:20px; border:1px solid ##4F8EA4"> 
                        <tr style="font-weight:bold;">
                            <td colspan="4" style="font-weight:bold; font-size: 11px;">#qGetStates.statename#: #qGetNumState.recordCount#</td>
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
                            
                            <cfquery name="qGetCityFlyer" datasource="#APPLICATION.DSN.Source#">
                                SELECT
                                    *
                                FROM
                                    extra_cities
                                WHERE
                                    name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCities.city#">
                                    AND stateid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetStates.id#">
                            </cfquery>
                            
                            <tr style="font-weight:bold;">
                                <td colspan="4" style="font-weight:bold; font-size: 8px; font-family:Verdana, Geneva, sans-serif;">
                                	&nbsp;&nbsp&nbsp;&nbsp;&nbsp;#qGetCities.city#: #qGetNumCity.recordCount# &nbsp; &nbsp;
                                    <cfif qGetCityFlyer.recordCount GT 0>
                                    	(<a 
                                                                    href="##"
                                                                    class="readOnly" 
                                                                    onclick="printDocumentFile('#qGetCityFlyer.id#')" 
                                                                    style="cursor:pointer;">
                                                                    PREVIEW
                                                                </a>) <input type="hidden" id="flyer_#qGetStates.id#_#qGetCities.city#_upload"/><!--- This is to prevent errors with ajaxUpload --->
                                    <cfelse>
                                		(No Flyer Available - <a href="##" 
                                                                    value="Upload" 
                                                                    name="flyer_#qGetStates.id#_#qGetCities.city#_upload" 
                                                                    id="flyer_#qGetStates.id#_#qGetCities.city#_upload" 
                                                                    style="cursor:pointer">
                                                                    UPLOAD
                                                                </a>)  
                                    </cfif>
                                </td>
                            </tr>
                            
                            <tr style="background-color:##4F8EA4; color:##FFF; padding:5px; font-weight:bold; font-size: 9px;">
                                <!--- The td widths are set differently for the onScreen report and the print report --->
                                <cfif FORM.printOption EQ 1>
                                    <td width="4%">ID</Td>
                                    <td width="10%">Last Name</td>
                                    <td width="10%">First Name</td>
                                    <td width="4%">Gender</td>
                                    <td width="7%">Country</td>
                                    <td width="10%">Email</td>
                                    <td width="6%">Start Date</td>
                                    <td width="6%">End Date</td>
                                    <td width="20%">Placement Info</td>
                                    <td width="8%">Option</td>
                                    <td width="15%">Intl. Rep.</td>
                                     <td width="15%">DS-2019</td>
                                <cfelse>
                                    <td>ID</Td>
                                    <td>Last Name</td>
                                    <td>First Name</td>
                                    <td>Gender</td>
                                    <td>Country</td>
                                    <td>Email</td>
                                    <td>Start Date</td>
                                    <td>End Date</td>
                                    <td>Placement Info</td>
                                    <td>Option</td>
                                    <td>Intl. Rep</td>
                                    <td>DS-2019</td>
                                </cfif>
                            </tr>
                        
                            <cfscript>
                                vRowCount = 0;
                            </cfscript>
                            
                            <cfloop query="qGetNumCity">
                                
                                <cfscript>
                                    vRowCount = vRowCount + 1;
                                </cfscript>
                                
                                <cfquery name="qGetPlacements" datasource="#APPLICATION.DSN.Source#">
                                    SELECT
                                        h.name,
                                        j.title
                                    FROM
                                        extra_hostcompany h
                                    INNER JOIN
                                        extra_candidate_place_company ecpc ON ecpc.hostCompanyID = h.hostCompanyID
                                    LEFT JOIN
                                        extra_jobs j ON j.ID = ecpc.jobID
                                    WHERE
                                        ecpc.status = 1
                                    AND
                                        ecpc.candidateID = #qGetNumCity.candidateID#
                                    ORDER BY
                                        ecpc.isSecondary ASC
                                </cfquery>
                                
                                <tr bgcolor="###IIf(vRowCount MOD 2 ,DE("FFFFFF") ,DE("E4E4E4") )#" style="font-size:10px;">
                                    <td valign="center">
                                        <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetNumCity.uniqueID#" target="_blank" class="style4">
                                            #qGetNumCity.candidateid#
                                            <cfif LEN(qGetNumCity.subject)>
                                            	<font color="red"><b>T</b></font>
                                            </cfif>
                                        </a>
                                    </td>
                                    <td>#qGetNumCity.lastname#</td>
                                    <td>#qGetNumCity.firstname#</td>
                                    <td>#qGetNumCity.sex#</td>
                                    <td>#qGetNumCity.country#</td>
                                    <td>#qGetNumCity.email#</td>
                                    <td>#DateFormat(qGetNumCity.startdate, 'mm/dd/yyyy')#</td>
                                    <td>#DateFormat(qGetNumCity.enddate, 'mm/dd/yyyy')#</td>
                                    <td><cfloop query="qGetPlacements">(#qGetPlacements.currentRow#) #name# - #title#<cfif qGetPlacements.currentRow NEQ qGetPlacements.recordCount><br /></cfif></cfloop></td>
                                    <td>#qGetNumCity.wat_placement#</td>
                                    <td>#qGetNumCity.businessName#</td>
                                    <Td>#qGetNumState.ds2019#</Td>
                                </tr>
                                
                            </cfloop>
                            
                            <tr height="10px"><td></td></tr>
                        
                        </cfloop>
                    
                    </table>
                    
              	</cfif>
                    
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
                    <style type="text/css" media="screen">
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
    
    <script language="javascript" src="../linked/js/ajaxUpload.js"></script>
    
    <script language="JavaScript">
		$().ready(function() {
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
                   	
                    <cfif VAL(qGetNumState.recordCount)>
                       
                	<cfloop query="qGetCities">
                        new AjaxUpload('<cfoutput>flyer_#qGetStates.id#_#qGetCities.city#_upload</cfoutput>', {
                            action: '../wat/hostCompany/addCityFlyer.cfm?option=upload&stateID=<cfoutput>#qGetStates.id#&city=#qGetCities.city#</cfoutput>',
                            name: 'image'
                        });
            		</cfloop>
            	</cfif>
           	</cfloop>
		});
		
		// Popup to print image that is referenced by the input file type.
		var printDocumentFile = function(id) {
			var printURL = document.URL.substring(0, document.URL.indexOf("/index.cfm")) + "/hostcompany/addCityFlyer.cfm?option=print&fileID="+id;
			window.open(printURL, "File", "width=800, height=600");
		}
	</script>
	
</cfif>
