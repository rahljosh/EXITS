<cfquery name="available_posistions" datasource="MySQL">
delete
from extra_web_jobs
where jobid = #url.jobid#
</cfquery>
<cflocation url="job-list.cfm?loged=yes">