<!--- ------------------------------------------------------------------------- ----
	
	File:		progressReports.cfm
	Author:		Marcus Melo
	Date:		December 1, 2009
	Desc:		This Tag displays a progress report in a print view format for now.
				It can be edited to display edit view as well. 
				We should centralize the PR code we do not have to change it in
				multiple pages.

	Status:		In Development
	
----- ------------------------------------------------------------------------- --->


<!--- Kill extra output --->
<cfsilent>

	<!--- Param tag attributes --->
	<cfparam 
		name="ATTRIBUTES.prQuery"
		type="query"
		/>

	<cfparam 
		name="ATTRIBUTES.reportMode"
		type="string"
        default="print"
		/>

</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(THISTAG.ExecutionMode, "Start")>

	<cfoutput>

	<cfif NOT VAL(ATTRIBUTES.prQuery.recordCount)>
        <table cellpadding="2" cellspacing="0" width="800px">
            <tr>
                <td>There are no progress reports that match your criteria.</th>
            </tr>
        </table>
		<cfabort>                
    </cfif>

    <cfloop query="ATTRIBUTES.prQuery">
        
        <cfscript>           
            //Get Program Info
            qGetProgram = APPLICATION.CFC.program.getPrograms(ProgramID=ATTRIBUTES.prQuery.fk_program);
            
            // Get Progress Report Dates
            qGetDates = APPLICATION.CFC.progressReport.getPRDates(prID=ATTRIBUTES.prQuery.pr_ID);
    
            // Get Progress Report Questions
            qGetQuestions = APPLICATION.CFC.progressReport.getPRQuestions(prID=ATTRIBUTES.prQuery.pr_ID);
    
            // Get Host Family
            qGetHost = APPLICATION.CFC.host.getHosts(hostID=ATTRIBUTES.prQuery.fk_host);
    
            // Get Facilitator
            qGetFacilitator = APPLICATION.CFC.user.getUserByID(VAL(ATTRIBUTES.prQuery.fk_ny_user));
    
            // Get Super Rep
            qGetRep = APPLICATION.CFC.user.getUserByID(VAL(ATTRIBUTES.prQuery.fk_sr_user));
    
            // Get Advisor for Rep
            qGetAdvisor = APPLICATION.CFC.user.getUserByID(VAL(ATTRIBUTES.prQuery.fk_ra_user));
        
            // Get Regional Director
            qGetRegionalDirector = APPLICATION.CFC.user.getUserByID(VAL(ATTRIBUTES.prQuery.fk_rd_user));
    
            // Get Regional Director
            qGetIntlRep = APPLICATION.CFC.user.getUserByID(VAL(ATTRIBUTES.prQuery.fk_intrep_user));
        </cfscript>
    
        <table cellpadding="2" cellspacing="0" width="800px" align="center" style="margin-top:15px;">      
            <tr>
                <td rowspan="10" valign="top" width="200px" align="center">
                    <!--- Logo --->
                    <img src="../pics/logos/#ATTRIBUTES.prQuery.companyID#.gif" align="middle">
                </td>
                <td valign="top" align="center">	
                    <h2>Student Progress Report</h2> <br />
                    
                    <h2>Student: #ATTRIBUTES.prQuery.firstname# #ATTRIBUTES.prQuery.familylastname# (#ATTRIBUTES.prQuery.studentid#)</h2>

                    <cfswitch expression="#ATTRIBUTES.prQuery.pr_month_of_report#">
                        <cfcase value="10">
                            <h2>
                                Phase 1<br>
                                <font size=-1>Due Oct 1st - includes information from Aug 1 through Oct 1</font>
                            </h2>
                        </cfcase>
                        <cfcase value="12">
                            <h2>
                                Phase 2<br>
                                <font size=-1>Due Dec 1st - includes information from Oct 1 through Dec 1</font>
                            </h2>
                        </cfcase>
                        <cfcase value="2">
                            <h2>
                                Phase 3<br>
                                <font size=-1>Due Feb 1st - includes information from Dec 1 through Feb 1st</font>
                            </h2>
                        </cfcase>
                        <cfcase value="4">
                            <h2>
                                Phase 4<br>
                                <font size=-1>Due April 1st - includes information from Feb 1st through April 1st</font>
                            </h2>
                       </cfcase>
                        <cfcase value="6">
                            <h2>
                                Phase 5<br>
                                <font size=-1>Due June 1st - includes information from April 1st through June  1st</font>
                            </h2>
                        </cfcase>
                        <cfcase value="8">
                            <h2>
                                Phase 6<br>
                                <font size=-1>Due August 1st - includes information from June 1st through August 1st</font>
                            </h2>
                        </cfcase>
                    </cfswitch>
                    
                    <br />
                    
                    <table cellpadding="2" cellspacing="0" width="600px">
                        <tr>
                            <th bgcolor="##CCCCCC" colspan="2">Program</th>
                        </tr>
                        <tr>
                            <th align="right" width="30%">Program Name:</th>
                            <td>#qGetProgram.programname# (#qGetProgram.programid#)</td>
                        </tr>
                        <tr>
                            <th align="right">Supervising Representative:</th>
                            <td>#qGetRep.firstname# #qGetRep.lastname# (#qGetRep.userID#)</td>
                        </tr>
                        <tr>
                            <th align="right">Regional Advisor:</th>
                            <td>
                                <cfif NOT VAL(ATTRIBUTES.prQuery.fk_ra_user)>
                                    Reports Directly to Regional Director
                                <cfelse>
                                    #qGetRegionalDirector.firstname# #qGetRegionalDirector.lastname# (#qGetRegionalDirector.userID#)
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <th align="right">Regional Director:</th>
                            <td>#qGetRegionalDirector.firstname# #qGetRegionalDirector.lastname# (#qGetRegionalDirector.userID#)</td>
                        </tr>
                        <tr>
                            <th align="right">Facilitator:</th>
                            <td>#qGetFacilitator.firstname# #qGetFacilitator.lastname# (#qGetFacilitator.userID#)</td>
                        </tr>
                        <tr>
                            <th align="right">Host Family:</th>
                            <td>
                                #qGetHost.fatherfirstname#
                                <cfif LEN(qGetHost.fatherfirstname) AND LEN(qGetHost.motherfirstname)>&amp;</cfif>
                                #qGetHost.motherfirstname#
                                #qGetHost.familylastname# (#qGetHost.hostID#)
                            </td>
                        </tr>
                        <tr>
                            <th align="right">International Agent:</th>
                            <td>#qGetIntlRep.businessname# (#qGetIntlRep.userID#)</td>
                        </tr>
                    </table>                            
                    
                </td>		
            </tr>        
        </table>
        
        <br />
       
        <table cellpadding="2" cellspacing="0" width="800px" align="center">
            <tr>
                <th bgcolor="##CCCCCC" colspan="4">
                    Contact Dates
                </th>
            </tr>
            <tr align="center">
                <cfif VAL(qGetDates.recordCount)>
                    <td colspan="4">
                        There are no contact dates yet.
                    </td>
                <cfelse>
                    <tr align="left">
                        <th>Date</th>
                        <th>Type</th>
                        <th>Contact</th>
                        <th>Comments</th>
                    </tr>
                    <cfloop query="qGetDates">
                        <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                            <td style="padding-left:15px;">#dateFormat(prdate_date, 'mm/dd/yyyy')#</td>
                            <td nowrap="nowrap">#prdate_type_name#</td>
                            <td nowrap="nowrap">#prdate_contact_name#</td>
                            <td><font size="1">#replaceList(prdate_comments, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</font></td>
                        </tr>
                    </cfloop>
                </cfif>    
            </tr>
        </table>
        
        <br />
        
        <table cellpadding="2" cellspacing="0" width="800px" align="center">
            <tr>
                <th bgcolor="##CCCCCC">Questions</th>
            </tr>
            <cfloop query="qGetQuestions">
                <tr>
                    <th align="left" style="padding-left:15px;">#qGetQuestions.text#</th>
                </tr>
                <tr>
                    <td style="padding-left:15px;">#replaceList(x_pr_question_response, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</td>
                </tr>
                <cfif qGetQuestions.currentRow NEQ qGetQuestions.RecordCount>
                    <tr>
                        <td height="25"><hr align="center" noshade="noshade" size="1" width="98%" /></td>
                    </tr>
                </cfif>
            </cfloop>
        </table>
    
        <!--- Line Break --->
        <div style="page-break-after:always;"></div><br>
		
   	</cfloop>
	
    </cfoutput>
    	
</cfif>