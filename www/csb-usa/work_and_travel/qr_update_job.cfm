<body onLoad="opener.location.reload()"> 
<cfset currentDirectory = "/var/www/html/student-management/nsmg/uploadedfiles/extra_jobs/">

<!--- Uploading FILE --->
<cfoutput>
<cfif form.additional_file NEQ ''>
	<cffile action="upload" filefield="form.additional_file" destination="#currentDirectory#" nameconflict="makeunique" mode="777">

	File Upload Successful: #file.ServerFileName#<br><br>
	<cfset addfile = "#file.ServerFileName#.#file.ServerFileExt#">
<cfelse>
<cfquery name="current_file" datasource="mysql">
select file
from extra_web_jobs
where jobid = #url.jobid#
</cfquery>
	<cfset addfile = '#current_file.file#'>
</cfif>
</cfoutput>

<cfquery name="update_job" datasource="mysql">
update extra_web_jobs 
	set title = '#form.title#',
    	spring = #form.spring#,
        summer = #form.summer#,
        winter = #form.winter#,
        file = '#addfile#'
        where jobid = #url.jobid#
</cfquery>
Job Listing Updated.