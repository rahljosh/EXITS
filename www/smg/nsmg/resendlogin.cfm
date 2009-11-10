<cfquery name="get_info_for_email" datasource="MySQL">
select smg_users.firstname, smg_users.lastname, smg_users.username, smg_users.password, smg_users.email, smg_users.defaultcompany, smg_users.usertype, smg_users.whocreatedaccount,
smg_companies.url, smg_companies.companyshort, smg_companies.companyname 
from smg_users right join smg_companies on smg_users.defaultcompany = smg_companies.companyid 
where smg_users.userid = #url.userid#
</cfquery>



<cfoutput query="get_info_for_email">
<cfmail from="support@student-management.com" to="#email#" subject="New Account Created / Login Information">
****This email has been resent.  You may or may not be prompted to change your password, depending on your account settings.****
An account has been created for you on the #companyname# website.  Your account login information is below.  

Login ID / Username: #username#
Password: #password#

Upon your first login, you will need to activate your account by providing your zip code and the last four digits of your phone number. 
You will then be prompted to change your password from the temporary password to one of your choosing.  Once you have changed your password 
you will have to login again with your new password.

After you have successfully completed your login, you can change your password, username or any other account information by going to Users 
from the main menu and clicking on your name, then on Edit.  All changes that you make will be immediate. 

Two things to keep in mind when changing your password:
*your password MUST be at least 6 characters long
*you password can not start with the word 'temp'

You can login immediately by visiting:  http://www.student-management.com/  and log in with the information above. 

If you have any questions or problems with logging in please contact support@student-management.com  or by replying to this email.

If you have questions regarding your account access levels, please contact your Regional Advisor or Regional Director. 


Sincerely-

SMG Technical Support
--
Internal Ref: u#url.userid#eb#whocreatedaccount#

</cfmail>
</cfoutput>
<cfoutput>
<cflocation url="index.cfm?curdoc=user_info&userid=#url.userid#&es">
</cfoutput>
