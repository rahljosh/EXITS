

<cfquery name="approveImageInfo" datasource="mysql">
select email, name, fileName
from smg_promotion_entries 
where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value='#url.uuid#'>
</cfquery>
<cfif approveImageInfo.recordcount gt 0>
Denying Entry, sending email and deleting file.<Br><br>
<cfquery name="denyImage" datasource="mysql">
delete from smg_promotion_entries 
where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value='#url.uuid#'>
</cfquery>

<cffile action="delete" file="C:\websites\student-management\nsmg\uploadedfiles\promotions\1\#approveImageInfo.fileName#">

<cfmail to="#approveImageInfo.email#" from="support@iseusa.com" subject="Submission Denied" type="html">
#approveImageInfo.name#-
<br><br>
Unfortunatally your submission for the ISE Halloween Costume Contest has been denied due to violation of the contest rules.  <br><br>
Please feel free to submit a new picture and vote for your favorite <a href="https://www.iseusa.com/Student_Exchange_Promotions.cfm">here</a>.

<br><br>
Regards-
ISE
</cfmail>
<cflocation url="https://www.iseusa.com/Student_Exchange_Promotions.cfm?##contestEntry" addtoken="no">
<cfelse>
No submissions matching that ID where found.  
</cfif>

