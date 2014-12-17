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
		
		// Get Canada Area Choice
		qGetSelectedCanadaAreaChoice = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='canadaAreaChoice', fieldID=qGetStudentInfo.app_canada_area);
	</cfscript>
    
    <cfquery name="qGetApplicationProgram" datasource="#APPLICATION.DSN#">
        SELECT 
        	app_programid, app_program 
        FROM 
        	smg_student_app_programs
        WHERE 
        	app_programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.app_indicated_program)#">
    </cfquery>
     
    <cfquery name="qGetAdditionalProgram" datasource="#APPLICATION.DSN#">
        SELECT 
        	app_programid, app_program 
        FROM
        	smg_student_app_programs
        WHERE 
        	app_programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.app_additional_program)#">
    </cfquery> 
    
    <cfquery name="qGetRegionPreference" datasource="#APPLICATION.DSN#">
        SELECT 
        	app_region_guarantee
        FROM 
        	smg_students
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentid)#">
    </cfquery>
    
    <cfquery name="qGetStatePrefence" datasource="#APPLICATION.DSN#">
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
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentid)#">
    </cfquery>
    
    <cfquery name="qGetPrivateSchool" datasource="#APPLICATION.DSN#">
        SELECT 
        	privateschoolid, 
            privateschoolprice, 
            type
        FROM 
        	smg_private_schools
        WHERE 
        	privateschoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.privateschool)#">
    </cfquery>
    
    <cfquery name="qGetStatusHistory" datasource="#APPLICATION.DSN#">
        SELECT 
        	status, reason, date, u.firstname, u.lastname
        FROM 
        	smg_student_app_status sta
        INNER JOIN 
        	smg_students s ON sta.studentid = s.studentid
        LEFT JOIN 	
        	smg_users u ON sta.approvedby = u.userid
        WHERE 
        	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentid)#">
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
						<img src="pics/EXITSbanner.jpg">
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
            <cfif qGetSelectedCanadaAreaChoice.recordCount>
                <tr>
                	<td>Area in Canada: </td>
                    <td style="font-weight:bold">#qGetSelectedCanadaAreaChoice.name#</td>
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
            <tr><td valign="top">Region Preference: </td>
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
            	<td valign="top">State Preference: </td>
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
            
            <tr>
              <td colspan="2" style="font-weight:bold">Timeline of the ISE Student Application Process</td></tr>
            <tr>
           	  <td colspan="2">
           		  <div align="justify">
                      <p><strong>1.</strong> Student application submitted to ISE by International Representative: Initial review completed by Budge.</p>
<p><strong>2.</strong> Student application moved into &quot;Received&quot; section: Secondary review completed by Lois. </p>
                <p><strong>3</strong>. Student application &quot;Accepted&quot; with a final review completed by the student's Program Manager. The student will then be assigned a region and facilitator, who will serve as the primary contact for any and all specific student issues or concerns going forward. <ul> 
                    </p>
                <li>
                You may hear from Budge (lamonica@iseusa.org) or Lois (lois@iseusa.org) regarding missing documents while the student application is in the Submitted or Received stage.                    
				<p>&nbsp;</p>
				<li>
                You will be contacted by Tom (<a href="mailto:tom@iseusa.org">tom@iseusa.org</a>) if there are any questions regarding a student region or state choice. 
                  <p>&nbsp;</p>
<li>Once a student is assigned to a region, the student's facilitator will serve as the primary contact for questions regarding specific students. Student facilitator information can be found by clicking on the &quot;Students&quot; tab of your EXITS homepage and clicking on the student you wish to find. From there, you will be directedto the student homepage. On the left side of the page, beneath the student photo, you will see the name of the student facilitator listed. If you click on the student facilitator name, an email window will open automatically for you to contact the student facilitator directly. 
<p>&nbsp;</p>
<li>You will receive notification of whether or not a student has been accepted or denied from the program within two weeks of submitting the application to ISE. <br />
  <br />
  
  Sincerely,<br />
  EXITS<br /><br />
  </p>
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