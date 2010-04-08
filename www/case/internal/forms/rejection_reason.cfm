<span class="application_section_header">Rejection Reason</span><br><br>
&nbsp;&nbsp;Please indicate why the report has been rejected.<br>
<cfoutput>
<form method="post" action="querys/reject_progress_report.cfm?number=#url.number#">
</cfoutput>
&nbsp;&nbsp;<textarea cols="40" rows="10" name="reason"></textarea><br>
<div class="button"><input name="Submit" type="image" src="pics/continue.gif" alt="Edit"  border=0 align="right"></div></form>