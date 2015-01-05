<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

    <!--- Param FORM Variables --->
	<cfparam name="FORM.userID" default="0">
	<cfparam name="FORM.programID" default="">
	<cfparam name="FORM.flightType" default="Arrival">
    <cfparam name="FORM.isDisplayAll" default="1">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.email" default="">

    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(usertype=8,isActive=1,businessNameExists=1,companyID=CLIENT.companyID);
	</cfscript>

    <!--- FORM submitted --->
    <cfif FORM.submitted>

        <!--- Get Intl. Reps Assigned to Candidates --->
        <cfquery name="qGetIntlRep" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                u.userID,
                u.businessName,
                u.email
            FROM 
            	smg_users u
			INNER JOIN
            	extra_candidates ec ON ec.intRep = u.userID
                	AND
                    	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
					AND
                    	ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
                    AND 
                        ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
			<cfif FORM.isDisplayAll>
                LEFT OUTER JOIN
                    extra_flight_information efi ON efi.candidateID = ec.candidateID 
                    AND 
                        ec.candidateID IN ( SELECT candidateID FROM extra_flight_information WHERE flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.flightType#"> )
            <cfelse>
                INNER JOIN
                    extra_flight_information efi ON efi.candidateID = ec.candidateID 
                AND
                    efi.flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.flightType#">
            </cfif>    
            WHERE 
                1 = 1
			<cfif VAL(FORM.userID)> 
                AND
                    u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">                               
            </cfif>
       		GROUP BY
            	u.userID
            ORDER BY
            	u.businessName
		</cfquery>
		
        <!--- Get All Candidates --->
        <cfquery name="qGetAllCandidates" datasource="#APPLICATION.DSN.Source#">
            SELECT DISTINCT
                c.candidateID,
                c.uniqueID,
                c.firstname,             
                c.lastname, 
                c.intRep,                
                c.wat_placement,
                c.startDate,
                ehc.name AS hostCompanyName,
                country.countryname
            FROM   
                extra_candidates c
            INNER JOIN
                smg_users u on u.userid = c.intrep
            INNER JOIN
            	extra_hostcompany ehc ON ehc.hostCompanyID = c.hostCompanyID
            LEFT JOIN 
                smg_countrylist country ON country.countryid = c.home_country
			<cfif FORM.isDisplayAll>
                LEFT OUTER JOIN
                    extra_flight_information efi ON efi.candidateID = c.candidateID 
                    AND 
                        c.candidateID IN ( SELECT candidateID FROM extra_flight_information WHERE flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.flightType#"> )
            <cfelse>
                INNER JOIN
                    extra_flight_information efi ON efi.candidateID = c.candidateID 
                AND
                    efi.flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.flightType#">
            </cfif>    
            WHERE 
                c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">    
            AND 
                c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
            AND 
                c.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
           <cfif VAL(FORM.userID)> 
                AND
                    c.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">                               
			</cfif>                
       		ORDER BY
                u.businessName,
                c.candidateID
		</cfquery>
		
        <cffunction name="filterGetAllCandidates" hint="Gets total by Host Company">
        	<cfargument name="placementType" default="" hint="Placement Type is not required">
            <cfargument name="intRep" default="0" hint="intRep is not required">
            
            <cfquery name="qFilterGetAllCandidates" dbtype="query">
                SELECT
                    *
                FROM	
                    qGetAllCandidates
                WHERE
                	1 = 1
                    
				<cfif VAL(ARGUMENTS.intRep)> 
                    AND
                        intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">                               
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
	font-weight:bold;
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
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; International Representative Reports -> Flight Information</font>
            </td>
        </tr>
        <tr valign="middle" height="24">
            <td valign="middle" colspan="2">&nbsp;</td>
        </tr>
        <tr valign="middle">
            <td align="right" valign="middle" class="style1"><b>Intl. Rep.:</b> </td>
            <td valign="middle">  
                <select name="userID" class="style1">
                    <option value="All">---  All International Representatives  ---</option>
                    <cfloop query="qGetIntlRepList">
                        <option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.userID> selected</cfif> >#qGetIntlRepList.businessname#</option>
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
            <td valign="middle" align="right" class="style1"><b>Flight Type: </b></td><td>
                <select name="flightType" class="style1">
                    <option value="Arrival" <cfif FORM.flightType EQ 'Arrival'> selected </cfif> >Arrival</option>
                    <option value="Departure" <cfif FORM.flightType EQ 'Departure'> selected </cfif> >Departure</option>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>Display Option: </b></td><td>
                <select name="isDisplayAll" class="style1">
                    <option value="1" <cfif FORM.isDisplayAll EQ 1> selected </cfif> >All Candidates</option>
                    <option value="0" <cfif FORM.isDisplayAll EQ 0> selected </cfif> >Candidates with flight only</option>
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
        	<td align="right" class="style1"><b>Email Intl. Rep.: </b></td>
            <td class="style1">
            	<input type="checkbox" name="email" id="email" <cfif FORM.email EQ 'on'>checked</cfif> />
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
		
        <cfloop query="qGetIntlRep">
			            
			<cfscript>
                // Total By Agent
                qTotalPerIntlRep = filterGetAllCandidates(placementType='ALL', intRep=qGetIntlRep.userID);
				
				totalPerIntlRepCSBPlacements = filterGetAllCandidates(placementType='CSB-Placement', intRep=qGetIntlRep.userID).recordCount;
                
                totalPerIntlRepSelfPlacements = filterGetAllCandidates(placementType='Self-Placement', intRep=qGetIntlRep.userID).recordCount;
                
                totalPerIntlRepWalkInPlacements = filterGetAllCandidates(placementType='Walk-In', intRep=qGetIntlRep.userID).recordCount;
            </cfscript>
            
            <cfsavecontent variable="currentRepReportText">
            	<p>
                	Dear #qGetIntlRep.businessName#,
                    <br/>
                    <br/>
					Please take notice of the list of all participants who are missing the Flight Information from their applications. 
                    As previously notified, due to concerns over the health, welfare and safety of the SWT Program participants, the entire flight information 
                    <font color="red">must be added in EXTRA system (online application, flight information section) with 10 (ten) days before their specific arrival dates.</font>
                    <br/>
                    <br/>
					Please ensure you submit this crucial information on time. If you have any questions or concerns, please feel free to contact us.
                    <br/>
                    <br/>
					Note: If meanwhile you have submitted the requested information, thank you and please disregard this notice.
                </p>
            </cfsavecontent>

			<cfsavecontent variable="currentRepReportContent">

                <table width=99% cellpadding="4" cellspacing=0 align="center"> 
                    <tr>
                        <td colspan="12">
                            <small>
                                <strong>#qGetIntlRep.businessName# - Total candidates: #qTotalPerIntlRep.recordCount#</strong> 
                                (
                                    #totalPerIntlRepCSBPlacements# CSB; &nbsp; 
                                    #totalPerIntlRepSelfPlacements# Self; &nbsp; 
                                    #totalPerIntlRepWalkInPlacements# Walk-In 
                                )
                            </small>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" align="left" bgcolor="4F8EA4" class="#tableTitleClass#">ID</Td>
                        <td width="15%" align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Last Name</Td>
                        <td width="15%" align="left" bgcolor="4F8EA4" class="#tableTitleClass#">First Name</Td>
                        <td width="15%" align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Country</td>
                        <td width="15%" align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Host Company</td>
                        <td width="35%" align="left" bgcolor="4F8EA4" class="#tableTitleClass#">Flight Information</td>
                    </tr>
                    <cfloop query="qTotalPerIntlRep">
                        <cfscript>
                            // Get Flight Information
                            qGetFlightInfo = APPLICATION.CFC.FLIGHTINFORMATION.getFlightInformationByCandidateID(candidateID=qTotalPerIntlRep.candidateID, flightType=FORM.flightType);
                        </cfscript>
                        
                        <tr <cfif qTotalPerIntlRep.currentRow mod 2>bgcolor="##E4E4E4"</cfif> >
                            <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerIntlRep.uniqueID#" target="_blank" class="style4">#qTotalPerIntlRep.candidateID#</a></td>
                            <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerIntlRep.uniqueID#" target="_blank" class="style4">#qTotalPerIntlRep.lastname#</a></td>
                            <td><a href="?curdoc=candidate/candidate_info&uniqueid=#qTotalPerIntlRep.uniqueID#" target="_blank" class="style4">#qTotalPerIntlRep.firstname#</a></td>
                            <td><span class="style1">#qTotalPerIntlRep.countryname#</span></td>
                            <td><span class="style1">#qTotalPerIntlRep.hostCompanyName#</span></td>                        
                            <td>
                                <span class="style1">
                                    <cfif qGetFlightInfo.recordCount>
                                        <cfloop query="qGetFlightInfo">                                       
                                            Arrive on 
                                            <cfif qGetFlightInfo.isOvernightFlight EQ 1>
                                                #DateFormat(DateAdd("d", 1, qGetFlightInfo.departDate), 'mm/dd/yyyy')# 
                                            <cfelse>
                                                #qGetFlightInfo.departDate#
                                            </cfif>
                                                at #qGetFlightInfo.arriveTime#
                                            - Airport: #qGetFlightInfo.arriveAirportCode# 
                                            - Flight Number: #qGetFlightInfo.flightNumber# 
                                            <br />
                                        </cfloop>   
                                    <!--- Alert Arrival Missing --->
                                    <cfelseif qTotalPerIntlRep.wat_placement EQ 'CSB-Placement' AND DateAdd("d", -14, qTotalPerIntlRep.startDate) LTE now() AND FORM.flightType EQ 'arrival'>
                                        <span style="color:##F00; font-weight:bold;">
                                            Alert Arrival Missing (CSB-Placement) - Program Start Date: #DateFormat(qTotalPerIntlRep.startDate, 'mm/dd/yy')#
                                        </span>
                                    <cfelseif qTotalPerIntlRep.wat_placement EQ 'Self-Placement' AND DateAdd("d", -14, qTotalPerIntlRep.startDate) LTE now() AND FORM.flightType EQ 'arrival'>
                                        <span style="color:##F90; font-weight:bold;">
                                            Alert Arrival Missing (Self-Placement) - Program Start Date: #DateFormat(qTotalPerIntlRep.startDate, 'mm/dd/yy')#
                                        </span>
                                    <cfelse>
                                    	<span style="color:##444; font-weight:bold;">
                                        	Arrival Missing
                                       	</span>
                                    </cfif> 
                                </span>
                            </td>
                        </tr>
                    </cfloop>
    
                </table>
                <br />
                
          	</cfsavecontent>
            
           	#currentRepReportContent#
            
            <cfif FORM.email EQ 'on'>
            	<cfscript>
					APPLICATION.CFC.EMAIL.sendEmail(
						emailTo=qGetIntlRep.email,
						emailMessage=currentRepReportText & currentRepReportContent,
						emailSubject='SWT CSB Participants – Missing Flight Information',
						companyID=CLIENT.companyID,
						footerType='emailRegular');
				</cfscript>
          	</cfif>
         
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
                <div class="title1">Candidate Flight Information</div>
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
            <div class="title1">Candidate Flight Information</div>
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