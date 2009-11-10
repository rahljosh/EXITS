<cfquery name="qr_editjob" datasource="MySql">
UPDATE extra_jobs 
SET title = '#title#',

<cfif form.description NEQ ''>
description = '#form.description#',
</cfif>


wage = '#wage#',

<!---wage_type = '#wage_type#',
low_wage = '#low_wage#',---->
hours = '#hours#',


sex = #sex#





<!----avail_position = #avail_position#--->
WHERE extra_jobs.id = #url.jobid#
</cfquery>
<cflocation url="reload_window.cfm">