<link rel="stylesheet" href="forms.css" type="text/css">
<div style="width:500px; background-color: #white; padding: 5px; margin: 0px auto;">
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="get_email" datasource="MySQL">
select email
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<cfmail to="#get_email.email#" from="hostapplications@student-management.com" subject="Application Status">
You have completed the host application process. You application to host a foreign exchange student is under review and you will be contacted by your local
representative when the review is complete, usually 2-3 weeks.

You can review your application and its status at any time by visiting #CLIENT.exits_url#/hostapp.cfm/  

Your local representative is:
name
email
phone

If you have any questions, please contact your representative.

**This is an unmonitored email address, if you reply to this message it will not be recived.**
For email corespondance, please contact your area rep at the email address above.
</cfmail>

Your application will now be reviewed and you will be contacted by your local representative when the review process is over. 
You can view your application at any time by visiting, #CLIENT.exits_url#/hostapp.cfm/ 

You will also recieve and email with this information. 

Thank you for applying to host a student with Student Management Group.


</body>
</html>
