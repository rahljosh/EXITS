<cfquery name="approveImageInfo" datasource="mysql">
select email, fullName, fileName
from smg_promotion_entries 
where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value='#url.uuid#'>
</cfquery>
<cfquery name="denyImage" datasource="mysql">
delete from smg_promotion_entries 
where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value='#url.uuid#'>
</cfquery>

<cffile action="delete" file="C:\websites\student-management\nsmg\uploadedfiles\promotions\1\#approveImageInfo.fileName#">

<cfmail to="#approveImageInfo.email#" from="support@iseusa.com" subject="Submission Approved" type="html">
#approveImageInfo.fullName#-
<br><br>
Unfortunatally your submission for the ISE Halloween Costume Contest has been denied due to violation of the contest rules.  <br><br>
Please feel free to submit a new picture and vote for your favorite <a href="https://www.iseusa.com/Student_Exchange_Promotions.cfm">here</a>.

<br><br>
Regards-
ISE
</cfmail>
<cflocation url="https://www.iseusa.com/Student_Exchange_Promotions.cfm?#contestEntry">
