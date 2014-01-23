

<cfquery name="approveImageInfo" datasource="mysql">
select email, name
from smg_promotion_entries 
where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value='#url.uuid#'>
</cfquery>
<cfif approveImageInfo.recordcount gt 0>
Approving Entry and sending email. <br><br>
<cfquery name="approveImage" datasource="mysql">
update smg_promotion_entries 
set isApproved = 1
where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value='#url.uuid#'>
</cfquery>
<cfmail to="#approveImageInfo.email#" from="support@iseusa.com" subject="Submission Approved" type="html">
#approveImageInfo.name#-
<br><br>
Your submission for the ISE Halloween Costume Contest has been approved.  <br><br>
You can vote for your favorite submission <a href="https://www.iseusa.com/Student_Exchange_Promotions.cfm">here</a>.
<br><br>
Regards-
ISE
</cfmail>

<cflocation url="https://www.iseusa.com/Student_Exchange_Promotions.cfm?##contestEntry" addtoken="no">
<cfelse>
No submissions matching that ID where found.  
</cfif>
