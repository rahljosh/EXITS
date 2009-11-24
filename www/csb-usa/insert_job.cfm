<cfset currentDirectory = "/var/www/html/student-management/nsmg/uploadedfiles/extra_jobs/">

<!--- Uploading FILE --->
<cfoutput>
<cfif form.additional_file NEQ ''>
	<cffile action="upload" filefield="form.additional_file" destination="#currentDirectory#" nameconflict="makeunique" mode="777">

	File Upload Successful: #file.ServerFileName#<br><br>
	<cfset addfile = "#file.ServerFileName#.#file.ServerFileExt#">
<cfelse>
	<cfset addfile = ''>
</cfif>
</cfoutput>
<cfquery name="insert_job" datasource="mysql">
insert into extra_web_jobs (title, spring, summer, winter, file)
					values('#form.title#','#form.spring#','#form.summer#','#form.winter#', '#addfile#')
</cfquery>
	
<cflocation url="job_listing.cfm" addtoken="yes">
