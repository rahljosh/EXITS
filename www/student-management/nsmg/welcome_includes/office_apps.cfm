<!----Application Info---->

					
<table width=100% cellpadding=4 cellspacing=0 border=0>
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top">
        	<!--- Temporary code to get student files --->
			<cfif CLIENT.userType LTE 2 OR CLIENT.userID EQ 21485>
            	<cfsetting requesttimeout="300">

                <cfparam name="FORM.submitted" default="0">
                <cfparam name="FORM.studentID" default="0">
                
                <cfif VAL(FORM.submitted)>
                    
                    <cfquery name="qGetDocs" datasource="#APPLICATION.DSN#">
                        SELECT *
                        FROM virtualfolder
                        WHERE isDeleted = 0
                        AND fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">
                        ORDER BY fk_studentID DESC
                    </cfquery>
                    
                    <cfset totalFiles = 0>
                    <cfset movedFiles = 0>
                    <cfset unavailableFiles = 0>
                    
                    <cfloop query="qGetDocs">
                        <cftry>
                            <cfif NOT FileExists("C://websites/student-management/nsmg/#filePath##fileName#")>
                                <cfset totalFiles = totalFiles + 1>
                                <cfset moved = 0>
                                <cfset missing = 0>
                                <cfif movedFiles LT 20>
                                    <cfftp 
                                        action="existsfile" 
                                        remotefile="/student-management/nsmg/#filePath##fileName#"
                                        server="204.12.102.11" 
                                        username="jgriffiths" 
                                        password="Is3^2012"
                                        passive="yes">
                                    <cfif cfftp.ReturnValue>
                                        <cfif NOT DirectoryExists("C://websites/student-management/nsmg/#filePath#")>
                                            <cfdirectory action="create" directory="C://websites/student-management/nsmg/#filePath#">
                                        </cfif>
                                        <cfftp 
                                            action="getfile" 
                                            remotefile="/student-management/nsmg/#filePath##fileName#" 
                                            localfile="C://websites/student-management/nsmg/#filePath##fileName#" 
                                            server="204.12.102.11" 
                                            username="jgriffiths" 
                                            password="Is3^2012"
                                            passive="yes">
                                        <cfset movedFiles = movedFiles + 1>
                                        <cfset moved = 1>
                                    <cfelse>
                                        <cfset unavailableFiles = unavailableFiles + 1>
                                        <cfset missing = 1>
                                    </cfif>
                                </cfif>
                            </cfif>
                        <cfcatch type="any">
                        
                        </cfcatch>
                        </cftry>
                    </cfloop>
                    
                    <cfloop list="student-management/nsmg/uploadedFiles/online_app/page10,student-management/nsmg/uploadedFiles/online_app/page11,student-management/nsmg/uploadedFiles/online_app/page12,student-management/nsmg/uploadedFiles/online_app/page13,student-management/nsmg/uploadedFiles/online_app/page14,student-management/nsmg/uploadedFiles/online_app/page15,student-management/nsmg/uploadedFiles/online_app/page16,student-management/nsmg/uploadedFiles/online_app/page17,student-management/nsmg/uploadedFiles/online_app/page18,student-management/nsmg/uploadedFiles/online_app/page19,student-management/nsmg/uploadedFiles/online_app/page20,student-management/nsmg/uploadedFiles/online_app/page21,student-management/nsmg/uploadedFiles/online_app/page23,student-management/nsmg/uploadedFiles/online_app/page24,student-management/nsmg/uploadedFiles/online_app/page25,student-management/nsmg/uploadedFiles/online_app/page26,student-management/nsmg/uploadedFiles/online_app/page27,student-management/nsmg/uploadedFiles/letters/parents,student-management/nsmg/uploadedFiles/letters/students" index="i">
                        <cftry>
                            <cfset moved = 0>
                            <cfif 
                                NOT FileExists("C://websites/#i#/#FORM.studentID#.jpg")
                                AND NOT FileExists("C://websites/#i#/#FORM.studentID#.jpeg")
                                AND NOT FileExists("C://websites/#i#/#FORM.studentID#.gif")
                                AND NOT FileExists("C://websites/#i#/#FORM.studentID#.tif")
                                AND NOT FileExists("C://websites/#i#/#FORM.studentID#.tiff")
                                AND NOT FileExists("C://websites/#i#/#FORM.studentID#.png")
                                AND NOT FileExists("C://websites/#i#/#FORM.studentID#.pdf")>
                                <cfset ext = "">
                                <cfftp 
                                    action="existsfile" 
                                    remotefile="/#i#/#FORM.studentID#.jpg"
                                    server="204.12.102.11" 
                                    username="jgriffiths" 
                                    password="Is3^2012"
                                    passive="yes">
                                <cfif cfftp.ReturnValue>
                                    <cfset ext = "jpg">
                                </cfif>
                                <cfftp 
                                    action="existsfile" 
                                    remotefile="/#i#/#FORM.studentID#.jpeg"
                                    server="204.12.102.11" 
                                    username="jgriffiths" 
                                    password="Is3^2012"
                                    passive="yes">
                                <cfif cfftp.ReturnValue>
                                    <cfset ext = "jpeg">
                                </cfif>
                                <cfftp 
                                    action="existsfile" 
                                    remotefile="/#i#/#FORM.studentID#.gif"
                                    server="204.12.102.11" 
                                    username="jgriffiths" 
                                    password="Is3^2012"
                                    passive="yes">
                                <cfif cfftp.ReturnValue>
                                    <cfset ext = "gif">
                                </cfif>
                                <cfftp 
                                    action="existsfile" 
                                    remotefile="/#i#/#FORM.studentID#.tif"
                                    server="204.12.102.11" 
                                    username="jgriffiths" 
                                    password="Is3^2012"
                                    passive="yes">
                                <cfif cfftp.ReturnValue>
                                    <cfset ext = "tif">
                                </cfif>
                                <cfftp 
                                    action="existsfile" 
                                    remotefile="/#i#/#FORM.studentID#.tiff"
                                    server="204.12.102.11" 
                                    username="jgriffiths" 
                                    password="Is3^2012"
                                    passive="yes">
                                <cfif cfftp.ReturnValue>
                                    <cfset ext = "tiff">
                                </cfif>
                                <cfftp 
                                    action="existsfile" 
                                    remotefile="/#i#/#FORM.studentID#.png"
                                    server="204.12.102.11" 
                                    username="jgriffiths" 
                                    password="Is3^2012"
                                    passive="yes">
                                <cfif cfftp.ReturnValue>
                                    <cfset ext = "png">
                                </cfif>
                                <cfftp 
                                    action="existsfile" 
                                    remotefile="/#i#/#FORM.studentID#.pdf"
                                    server="204.12.102.11" 
                                    username="jgriffiths" 
                                    password="Is3^2012"
                                    passive="yes">
                                <cfif cfftp.ReturnValue>
                                    <cfset ext = "pdf">
                                </cfif>
                                <cfif LEN(ext)>
                                    <cfif movedFiles LTE 40>
                                        <cfftp 
                                            action="getfile" 
                                            remotefile="/#i#/#FORM.studentID#.#ext#" 
                                            localfile="C://websites/#i#/#FORM.studentID#.#ext#" 
                                            server="204.12.102.11" 
                                            username="jgriffiths" 
                                            password="Is3^2012"
                                            passive="yes">
                                        <cfset movedFiles = movedFiles + 1>
                                        <cfset moved = 1>
                                    </cfif>
                                    <cfset totalFiles = totalFiles + 1>
                                </cfif>
                            </cfif>
                        <cfcatch type="any">
                        
                        </cfcatch>
                        </cftry>
                    </cfloop>
                    
                </cfif>
                
                <form action="" method="post">
                    <input type="hidden" name="submitted" value="1">
                   	Input a student's ID here to attempt to retrieve their files if any appear to be missing.
                    <input type="text" name="studentID">
                    <input type="submit">
                </form>
            </cfif>
			<tr>
				<th colspan="3" align="center" bgcolor="#fef3b9">Waiting on Student</th>
				<th colspan="2" align="center" bgcolor="#bed0fc">Waiting on Intl. Rep.</th>
				<th colspan="5" align="center" bgcolor="#bde2ac">Waiting on <cfoutput>#client.company_submitting#</cfoutput></th>
			</tr>
			<tr>
				<th valign="top">Issued</th>
				<th valign="top">Active</th>                
				<th valign="top">Future</th>
				<th valign="top">To Approve</th>
				<th valign="top">Denied</th>
				<th valign="top">Submitted</th>
                <th valign="top">Received</th>
				<th valign="top">Denied</th>
				<th valign="top">On Hold</th>
				<th valign="top">Approved</th>
			</tr>
			<tr>
				<cfloop list = '1,2,25,5,6,7,8,9,10,11' index="i">
                    <td align="center">
                        <cfquery name="apps" datasource="#application.dsn#">
                            SELECT 
                            	COUNT(*) AS count 
                            FROM 
                            	smg_students
                            WHERE 
   	                        <!--- RANDID = TO IDENTIFY ONLINE APPS --->
                            	randid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                
                            <!--- Do not get active reps if viewing a rejected status --->     
							<cfif NOT ListFind("4,6,9", i)>
                                AND 
                                    active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
							<cfelse>
                                AND
                                    canceldate IS NULL
                            </cfif>
                            
                            <!--- Display Branch Applications (3/4) in the Active list --->
                            <cfif CLIENT.usertype NEQ 11 AND i EQ 2>
                                AND 
                                    app_current_status IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#i#,3,4" list="yes"> )
                            <!--- Display Current Status --->
                            <cfelse>            
                                AND 
                                    app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
                            </cfif>

							<!--- Filter for Case, WEP and ESI --->
                            <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.NonISE, CLIENT.companyID)>
                           		AND 
                                	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                            <cfelse>
                            	AND
                                	companyID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.NonISE#" list="yes"> )
                            </cfif>	
                      		
                        </cfquery> 
                        
                        <cfoutput><a href="index.cfm?curdoc=student_app/student_list_intrep&status=#i#">#apps.count#</a></cfoutput>
                    </td>
				</cfloop>
                </tr>
		</table>
	</td>
	<td align="right" valign="top" rowspan=2></td>
	</tr>
</table>
