<!--- ------------------------------------------------------------------------- ----
	
	File:		cover_page.cfm
	Author:		Marcus Melo
	Date:		May 4, 2011
	Desc:		Online Application Cover Page

	Updated:  	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfparam name="URL.unqID" default="">
    
    <cfscript>
		if ( LEN(URL.unqID) ) {
		
			qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.unqID);
			CLIENT.studentID = qGetStudentInfo.studentID;

		} else {
		
			qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=CLIENT.studentID);

		}
		
		qGetIntlRep = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.intrep);
	</cfscript>
    
    <cfquery name="qGetApplicationProgram" datasource="MySQL">
        SELECT 
        	app_programid, app_program 
        FROM 
        	smg_student_app_programs
        WHERE 
        	app_programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.app_indicated_program)#">
    </cfquery>
     
    <cfquery name="qGetAdditionalProgram" datasource="MySQL">
        SELECT 
        	app_programid, app_program 
        FROM
        	smg_student_app_programs
        WHERE 
        	app_programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.app_additional_program)#">
    </cfquery> 
    
    <cfquery name="qGetRegionPreference" datasource="MySQL">
        SELECT 
        	app_region_guarantee
        FROM 
        	smg_students
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
    </cfquery>
    
    <cfquery name="qGetStatePrefence" datasource="MySQL">
        SELECT 
        	state1, sta1.statename as statename1, state2, sta2.statename as statename2, state3, sta3.statename as statename3
        FROM 
        	smg_student_app_state_requested 
        LEFT JOIN 
        	smg_states sta1 ON sta1.id = state1
        LEFT JOIN 
        	smg_states sta2 ON sta2.id = state2
        LEFT JOIN 
        	smg_states sta3 ON sta3.id = state3
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
    </cfquery>
    
    <cfquery name="qGetPrivateSchool" datasource="MySql">
        SELECT 
        	privateschoolid, 
            privateschoolprice, 
            type
        FROM 
        	smg_private_schools
        WHERE 
        	privateschoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.privateschool#">
    </cfquery>
    
    <cfquery name="qGetStatusHistory" datasource="MySql">
        SELECT 
        	status, reason, date, u.firstname, u.lastname
        FROM 
        	smg_student_app_status sta
        INNER JOIN 
        	smg_students s ON sta.studentid = s.studentid
        LEFT JOIN 	
        	smg_users u ON sta.approvedby = u.userid
        WHERE 
        	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
        AND 
        	sta.status = <cfqueryparam cfsqltype="cf_sql_integer" value="9">
    </cfquery>

</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<script type="text/javascript" language="javascript">
            $(document).ready(function() {	
                // Print
                print();
                // Close Window		
               setTimeout(function() { window.close(); }, 2000);
            });
        </script>

		<!--- Table Header --->
        <gui:tableHeader
            imageName="students.gif"
            tableTitle="#CLIENT.companyName# EXITS Online Application"
            width="100%"
            imagePath="../"
        />    

        <div class="section"><br />
        
        <table width="660" border=0 cellpadding=4 cellspacing=2 align="center">	
            <tr>
            	<td colspan="2" align="center">
					<!--- EXITS LOGO --->
                    <cfif NOT ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
						<img src="pics/top-email.gif">
                    <!--- ESI LOGO --->
					<cfelse>
                        <h2>#CLIENT.companyName#</h2>
                    </cfif>
				</td>
			</tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr>
            	<td width="100">Date Received: </td>
                <td width="560" style="font-weight:bold">#DateFormat(qGetStudentInfo.app_sent_student, 'mm/dd/yyyy')#</td>
            </tr> 
            <tr>
            	<td>Student's Name: </td>
                <td style="font-weight:bold">#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)</td>
            </tr> 
            <tr>
            	<td>International Agent: </td>
                <td style="font-weight:bold">#qGetIntlRep.businessname#</td>
            </tr>
            <tr>
            	<td>Program Information: </td>
                <td style="font-weight:bold">#qGetApplicationProgram.app_program#</td>
            </tr>
            <cfif LEN(qGetStudentInfo.app_canada_area)>
                <tr>
                	<td>Area in Canada: </td>
                    <td style="font-weight:bold">#qGetStudentInfo.app_canada_area#</td>
                </tr>
            </cfif>
            <tr>
            	<td>Additional Program: </td>
                <td style="font-weight:bold">#qGetAdditionalProgram.app_program#</td>
            </tr>
            <tr>
            	<td valign="top">J-1 Private School: </td>
                <td style="font-weight:bold">
                    <cfif qGetPrivateSchool.recordcount>
                        Tuition Range: #qGetPrivateSchool.privateschoolprice#
                    <cfelse>
                        n/a	
                    </cfif>
                </td>
            </tr>	
            <tr><td valign="top">Region Guarantee: </td>
                <td style="font-weight:bold">
                    <cfswitch expression="#VAL(qGetRegionPreference.app_region_guarantee)#">
                        
                        <cfcase value="1">
                            Region 1 - East
                        </cfcase>
                    
                        <cfcase value="2">
                            Region 2 - South
                        </cfcase>
                    
                        <cfcase value="3">
                            Region 3 - Central
                        </cfcase>
                    
                        <cfcase value="4">
                            Region 4 - Rocky Mountain
                        </cfcase>
                    
                        <cfcase value="5">
                            Region 5 - West
                        </cfcase>
                        <cfcase value="6">
                            West Region
                        </cfcase>
                        <cfcase value="7">
                            Central
                        </cfcase>
                        <cfcase value="8">
                            South
                        </cfcase>
                        <cfcase value="9">
                            East
                        </cfcase>
                        <cfdefaultcase>
                            n/a
                        </cfdefaultcase>
                        
                    </cfswitch>
                </td>
            </tr>
            <tr>
            	<td valign="top">State Guarantee: </td>
                <td style="font-weight:bold">
                    <cfif NOT VAL(qGetStatePrefence.recordcount)>
                        n/a
                    <cfelse>
                        1st Choice: #qGetStatePrefence.statename1#<br />
                        2nd Choice: #qGetStatePrefence.statename2#<br />
                        3rd Choice: #qGetStatePrefence.statename3#<br />
                    </cfif>
                </td>
            </tr>
            <tr><td colspan="2">Comments from #qGetIntlRep.businessname#.</td></tr>
            <tr><td colspan="2"><div align="justify"><cfif qGetStudentInfo.app_intl_comments EQ ''>n/a<cfelse>#qGetStudentInfo.app_intl_comments#</cfif></div></td></tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            
            <!--- APP PREVIOUSLY DENIED --->
            <cfif qGetStatusHistory.recordcount>
            	<tr><td colspan="2" style="font-weight:bold">This application has been denied by SMG. Please see information below.</td></tr>
            <cfloop query="qGetStatusHistory">
            	<tr><td colspan="2">Application denied on #DateFormat(qGetStatusHistory.date, 'mm/dd/yyyy')# by #qGetStatusHistory.firstname# #qGetStatusHistory.lastname#. Reason: #qGetStatusHistory.reason#.</td></tr>
            </cfloop>
            	<tr><td colspan="2">&nbsp;</td></tr>
            </cfif>
            <!--- APP PREVIOUSLY DENIED --->
            
            <tr><td colspan="2" style="font-weight:bold">Please read carefully the instructions below:</td></tr>
            <tr>
            	<td colspan="2">
            		<div align="justify">
                        This student's application has already been submitted through EXITS, so 
                        you will not need to input the application as a new application.  You 
                        must first review the application according to your normal application 
                        reviewing procedures; creating and filing the application review 
                        checklist accordingly. <br /><br />
                        
                        As soon as the student is assigned to the requested company, the student's
                        record will show up on your unplaced students list.  Once the student's 
                        application appears on your unplaced students list, you must complete 
                        the information listed in the Student Information Screen since this is 
                        only recorded after the student's application has been assigned to your 
                        company.  This includes assigning a program, a region, a region 
                        guarantee or a state guarantee.<br /><br />
                        
                        Please also remember to send out acceptance letters and to fill out the 
                        missing documents page as you do for all paper applications.<br /><br />
                        
                        Regional Managers will have access to the complete online student 
                        application through the Student's Info page of EXITS.<br /><br />
                        
                        Sincerely,<br />
                        EXITS<br /><br />
                    </div>
                </td>
            </tr>
        </table>

        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="100%"
			imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>