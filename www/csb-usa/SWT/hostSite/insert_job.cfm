<cfset currentDirectory = "c:\websites\student-management\nsmg\uploadedfiles\extra_jobs\">

<Cfif isDefined('form.insertJob')>
	<!--- Uploading FILE --->
    <cfoutput>
    <cfif form.additional_file NEQ ''>
        <cffile action="upload" filefield="form.additional_file" destination="#currentDirectory#" nameconflict="makeunique" mode="777">
    
        File Upload Successful: #file.serverfile#<br><br>
        <cfset addfile = "#file.serverfile#">
    <cfelse>
        <cfset addfile = ''>
    </cfif>
    </cfoutput>
  
    <cfquery name="insert_job" datasource="mysql">
    insert into extra_web_jobs (employer, state, title, spring, summer, winter, file)
                        values('#form.employer#','#form.state#','#form.title#', #form.spring#,#form.summer#,#form.winter#,'#addfile#')
    </cfquery>
<cfelse>
	<!--- Uploading FILE --->
    <cfoutput>
		<cfif form.additional_file NEQ ''>
            <cffile action="upload" filefield="form.additional_file" destination="#currentDirectory#" nameconflict="makeunique" mode="777">
        
            File Upload Successful: #file.serverfile#<br><br>
            <cfset addfile = "#file.serverfile#">
        <cfelse>
            <cfset addfile = ''>
        </cfif>
        <cfquery name="updateJob" datasource="mysql">
        update extra_web_jobs
            set employer = '#form.employer#',
                state = '#form.state#',
                title = '#form.title#', 
                spring = #form.spring#,
                summer = #form.summer#,
                <cfif form.additional_file NEQ ''>
                file = '#addfile#',
                </cfif>
                winter = #form.winter#
                
                
            where jobid = #form.editJob#
        </Cfquery>
	</Cfoutput>
</Cfif>
<cflocation url="../hostsite.cfm" addtoken="yes">
