<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param FORM Variables --->	
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.isSevisID" default="1">
    <cfparam name="FORM.submitted" default="0">
    
	<cfinclude template="../querys/get_company_short.cfm">

	<cfscript>
        qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
    </cfscript>

    <cfif FORM.submitted>
    
        <cfquery name="qGetStudents" datasource="#APPLICATION.DSN.Source#">
            SELECT
                c.candidateid, 
                c.uniqueID,
                c.firstname, 
                c.lastname, 
                c.dob, 
                c.citizen_country, 
                c.ds2019, 
                c.companyid, 
                c.hostcompanyid, 
                c.status,
                c.home_address cadress, 
                c.wat_placement,
                c.wat_participation, 
                c.startdate,
                cl.countryname, 
                eh.name, 
                eh.address, 
                eh.address as hostcompany_address, 
                eh.city as hostcompany_city, 
                eh.state, 
                eh.zip as hostcompany_zip, 
                s.state as hostcompany_state 
            FROM 
                extra_candidates c
            INNER JOIN 
                smg_programs ON smg_programs.programID = c.programID
            INNER JOIN 
                smg_countrylist cl ON cl.countryid = c.citizen_country
            LEFT JOIN 
                extra_hostcompany eh ON eh.hostcompanyid = c.hostcompanyid
            LEFT JOIN 
                smg_states s ON s.id = eh.state
            WHERE
                c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            AND
                c.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">		
            <cfif VAL(FORM.isSevisID)>
            AND 
                c.ds2019 != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            </cfif>            
            AND 
                c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
            ORDER BY 
                c.ds2019
        </cfquery>

    </cfif>
    
    <cfscript>
        qGetProgram = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID,programID=FORM.programID);
    </cfscript>
    
	<cfscript>
		if ( qGetProgram.extra_sponsor EQ 'INTO' ) {
			// Set Sponsor
			setSponsor = qGetProgram.extra_sponsor;
		} else {
			// Default Sponsor
			setSponsor = 'WAT';	
		}

		// Set bgColor
		bgColor = '##4F8EA4';
		bgColorSubTitle = '##4F8EA4';
		tbBorder = 0;
	</cfscript>

</cfsilent>

<cfoutput>

<form action="index.cfm?curdoc=reports/list_students_work_study_wt" method="post">
<input type="hidden" name="submitted" value="1" />

<table width="95%" cellpadding="4" cellspacing="4" border="0" align="center">
    <tr valign="middle" height="24">
        <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> List of Candidates for DOS</font>
        </td>
	</tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Program:</b></td>
        <td class="style1"> 
            <select name="programID" class="style1">
                <option></option>
                <cfloop query="qGetProgramList">
                    <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programID EQ FORM.programID> selected</cfif> >#qGetProgramList.programname#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    <tr>
        <td align="right" class="style1"><b>Format: </b></td>
        <td class="style1"> 
        	<input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1"> Onscreen (View Only) </label>
            <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2"> Excel Spreadsheet</label>            
            <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3"> Print (PDF) </label>
            <input type="radio" name="printOption" id="printOption4" value="4" <cfif FORM.printOption EQ 4> checked </cfif> > <label for="printOption4"> Print (FlashPaper) </label>
		</td>            	
    </tr>
    <tr>
        <td align="right" class="style1"><b>SEVIS ID##: </b></td>
        <td class="style1"> 
        	<input type="radio" name="isSevisID" id="hasDS2019" value="1" <cfif FORM.isSevisID EQ 1> checked </cfif> > <label for="hasDS2019"> Only candidates with a DS2019 </label>
            <input type="radio" name="isSevisID" id="includeAll" value="0" <cfif FORM.isSevisID EQ 0> checked </cfif> > <label for="includeAll"> All candidates</label>            
		</td>            	
    </tr>
    <tr>
        <td colspan=2 align="center">
        	<br /> <input type="submit" class="style1" value="Generate Report" /><br />
        </td>
    </tr>
</table>
</form>

<cfif FORM.submitted>

    <cfsavecontent variable="reportHeader">
        <table width=100% align="center" border="0">
            <tr>
                <td valign="top">
                    <img src="../../../../#APPLICATION.CSB[setSponsor].logo#" />
                </td>	
                <td align="center" valign="top"> 
                    #APPLICATION.CSB[setSponsor].name# Summer Work Travel Program / #APPLICATION.CSB[setSponsor].programNumber# <br />
                    Placement Report
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <p> Season #qGetProgram.programName# </p>
                    <p> Total Number of Participants: #qGetStudents.recordcount# </p> 
                </td>	
            </tr>		
        </table> <br />
    </cfsavecontent>

    <cfsavecontent variable="reportContent">
    
        <cfscript>
            if(ListFind("2,3,4", FORM.printOption)) {
                bgColor = '##CCCCCC';
                tbBorder = 1;
            }
        </cfscript>
    
        <table width=100% cellpadding="4" cellspacing="0" border="#tbBorder#">        
            <cfif ListFind("2,3,4", FORM.printOption)>
                <tr>
                    <td colspan="10"><strong>DEPARTMENT OF STATE SEMI-ANNUAL PLACEMENT REPORT: #DateFormat(now(), 'mm/dd/yyyy')#</strong></td>
                </tr>
            </cfif>
            <tr>
                <th align="left" bgcolor="#bgColor#" class="style2" rowspan="2" valign="bottom">PROGRAM NUMBER</th>
                <th align="left" bgcolor="#bgColor#" class="style2" rowspan="2" valign="bottom">PROGRAM NAME</th>
                <th class="style2" bgcolor="#bgColor#" colspan="3">EXCHANGE VISITOR</th>
                <th class="style2" bgcolor="#bgColor#" colspan="3">EMPLOYER</th>
                <th class="style2" bgcolor="#bgColor#" rowspan="2" valign="bottom">## OF <br /> PREVIOUS <br /> SWT <br /> EXCHANGES</th>
                <th class="style2" bgcolor="#bgColor#" rowspan="2" valign="bottom">DAYS TO FIND <br /> INITIAL <br /> EMPLOYMENT <br /> (0 = PRE-ARRANGED)</th>
            </tr>
            <tr>
                <th align="left" bgcolor="#bgColor#" class="style2">LAST NAME</th>
                <th align="left" bgcolor="#bgColor#" class="style2">FIRST NAME</th>
                <th align="left" bgcolor="#bgColor#" class="style2">SEVIS ID##</th>
                <th align="left" bgcolor="#bgColor#" class="style2">NAME</th>
                <th align="left" bgcolor="#bgColor#" class="style2">CITY</th>
                <th align="left" bgcolor="#bgColor#" class="style2">STATE</th>
            </tr>
            <cfloop query="qGetStudents">
                <cfscript>
                    if(qGetStudents.currentrow MOD 2) {
                        rowColor = '##E4E4E4';
                    } else {
                        rowColor = '';
                    }
                </cfscript>
                
                <cfquery name="qGetHistory" datasource="#APPLICATION.DSN.Source#">
                	SELECT
                    	ecpc.status,
                        ec.name,
                        ec.city,
                        s.stateName as state
                  	FROM
                    	extra_candidate_place_company ecpc
                   	INNER JOIN
                    	extra_hostcompany ec ON ec.hostCompanyID = ecpc.hostCompanyID
                   	INNER JOIN
                    	smg_states s ON s.ID = ec.state
                   	WHERE
                    	ecpc.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.candidateID#">
                </cfquery>
                
                <cfloop query="qGetHistory">
                    <tr>
                        <td class="style1" bgcolor="#rowColor#">#APPLICATION.CSB[setSponsor].programNumber#</td>
                        <td class="style1" bgcolor="#rowColor#">CSB Summer Work Travel Program</td>
                        <td class="style1" bgcolor="#rowColor#"><a href="?curdoc=candidate/candidate_info&uniqueid=#qGetStudents.uniqueID#" class="style4">#qGetStudents.lastname#</a></td>
                        <td class="style1" bgcolor="#rowColor#"><a href="?curdoc=candidate/candidate_info&uniqueid=#qGetStudents.uniqueID#" class="style4">#qGetStudents.firstname#</a></td>
                        <td class="style1" bgcolor="#rowColor#">#qGetStudents.ds2019#</td>
                        <td class="style1" bgcolor="#rowColor#">#qGetHistory.name# <cfif qGetHistory.status EQ 1>(Active)<cfelse>(Inactive)</cfif></td>
                        <td class="style1" bgcolor="#rowColor#">#qGetHistory.city#</td>
                        <td class="style1" bgcolor="#rowColor#">#qGetHistory.state#</td>
                        <td class="style1" bgcolor="#rowColor#" align="center"><cfif LEN(qGetStudents.wat_participation)>#qGetStudents.wat_participation#<cfelse>0</cfif></td>
                        <td class="style1" bgcolor="#rowColor#" align="center">
                            <cfif qGetStudents.wat_placement EQ 'Walk-In'>
        
                                <cfquery name="qInitialEmployment" datasource="#APPLICATION.DSN.Source#">
                                    SELECT placement_date
                                    FROM extra_candidate_place_company
                                    WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.candidateID#">
                                    AND status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                            
                                    <!--- Exclude Seeking Employment --->
                                    AND hostCompanyID != <cfqueryparam cfsqltype="cf_sql_integer" value="195">
                                </cfquery>
                                
                                <cfif IsDate(qGetStudents.startDate) AND IsDate(qInitialEmployment.placement_date)>
                                    #DateDiff("d", qGetStudents.startDate, qInitialEmployment.placement_date)#
                                <cfelse>
                                    n/a
                                </cfif>
                                        
                            <cfelse>
                                0
                            </cfif> 
                        </td>
                    </tr>
               	</cfloop>
            </cfloop>
            <cfif NOT VAL(qGetStudents.recordCount)>
                <tr>
                    <td align="center" colspan="10">
                        <div align="center">
                        	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">No students found based on the criteria you specified. Please change and re-run the report.</font>
                      	</div>
                        <br/>
                    </td>
                </tr>
            </cfif>
            
            <cfif FORM.printOption EQ 1>
            <tr>
                <td colspan="10">
                    <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br/><br/>
                    <font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font> 
                </td>
            </tr>  
            </cfif>              
        </table>
    </cfsavecontent>


    <cfswitch expression="#FORM.printOption#">
    
        <!--- Screen --->
        <cfcase value="1">
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif" style="font-weight:bold;">Total Number of Students: #qGetStudents.recordcount#</font>
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
            <!--- Include Report --->
            #reportContent#
        </cfcase>
        
        <!--- Excel --->
        <cfcase value="2">
    
            <!--- set content type --->
            <cfcontent type="application/msexcel">
            
            <!--- suggest default name for XLS file --->
            <cfheader name="Content-Disposition" value="attachment; filename=DOS-Report.xls"> 
    
            <!--- Include Report --->
            #reportContent#
            
            <cfabort>
        </cfcase>
    
        <!--- PDF --->
        <cfcase value="3">   
            <cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
                <style type="text/css">
                <!--
                .style1 { 
                    font-family: Arial, Helvetica, sans-serif;
                    font-size: 10;
                    }
                -->
                </style>
                <!--- Include Report --->
                #reportContent#
            </cfdocument>
        </cfcase>
    
        <!--- Flash Paper --->
        <cfcase value="4">  
            <cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">  
                <style type="text/css">
                <!--
                .style1 { 
                    font-family: Arial, Helvetica, sans-serif;
                    font-size: 10;
                    }
                -->
                </style>
                <!--- Include Report --->
                #reportContent#
            </cfdocument>
        </cfcase>
    
        <cfdefaultcase>    
            <span class="style1">
                <center>Print resutls will replace the menu options and take a bit longer to generate.<br /> 
                Onscreen will allow you to change criteria with out clicking your back button.</center>
            </span> <br />
        </cfdefaultcase>
        
    </cfswitch>

<cfelse>
    
    <span class="style1">
        <center>Print resutls will replace the menu options and take a bit longer to generate.<br /> 
        Onscreen will allow you to change criteria with out clicking your back button.</center>
    </span> <br />

</cfif>

</cfoutput>