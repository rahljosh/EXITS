<cfquery name="get_pass" datasource="isenet_new" dbtype="ODBC">
SELECT      ISERep_Email, ISERep_login, ISERep_password, ISERep_First_Name
FROM         web_ise_representative 
WHERE       (ISERep_Email = '#form.email#')
</cfquery>
<!----
<cfquery name="get_pass_hq" datasource="iseusrs">
SELECT      ise_usr_email, ISEusr_log_id, ISE_usr_log_pwd, ISE_usr_fname
FROM         ise_usrs 
WHERE       (ise_usr_email = '#form.email#')
</cfquery>

<cfif get_pass.recordcount is not 0>
	<cfset current_query = "get_pass">
<cfelseif get_pass_hq.recordcount is not 0>
	<cfset current_query = "get_pass_hq">
<cfelse>
<cf_header>
<div class="page-title">Request Results&nbsp;</div>
<Br><br>

<div align="center">No record was found for the email address: <cfoutput>#form.email#</cfoutput><br>
Click back and try again.<br><br>  If you do not have access to that email address any more, please contact <a href="mailto:june@iseusa.com">June Loehr</a> to update your profile. Once your profile is updated, you can request your password again. 
<br><BR>
</cfif>
<cfabort>
---->
<cfif get_pass.recordcount is 0>
<cf_header>
<div class="page-title">Request Results&nbsp;</div>
<Br><br>

<div align="center">No record was found for the email address: <cfoutput>#form.email#</cfoutput><br>
Click your browsers back button and try again.<br><br>  If you do not have access to that email address any more, please contact <a href="mailto:june@iseusa.com">June Loehr</a> to update your profile. Once your profile is updated, you can request your password again. 
<br><BR>
<Cfelse>
<cf_header>
<cfoutput query='get_pass'>
<cfmail to="#iserep_email#" from="admin@iseusa.com" Subject="Password Request Results">
#ISERep_First_Name#-
You request was recently submitted from the ISE website to have your username and password sent to you. 

Username: #iserep_login#
password: #iserep_password#

To log in visit http://www.iseusa.com/relogin.cfm?username=#iserep_login# and enter your password.
</cfmail>

<div align="Center">#Iserep_first_name#, your username/password have been sent to #iserep_email#.<br>Your login information should show up in just a few minutes, if not, simply resubmit a request. </div> <br>
</cfoutput>
</cfif>
<cf_footer>

 