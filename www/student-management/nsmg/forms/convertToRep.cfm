<!----------------->
<!----Convert a 2nd visit rep to a regular rep.
Just updating the user type and adjusting the date to get the users account to block of they haven't finished the training. 
Josh Rahl
07/06/2011
---->
<!----------------->

<Cfquery datasource="#application.dsn#">
update user_access_rights
set usertype = 7,
	changedate = #now()#
where userid = #url.userid#
</cfquery>
<Cfquery datasource="#application.dsn#">
update smg_users
set trainingDeadlineDate = #now()#,
	accountCreationVerified = 0,
    active = 0
where userid = #url.userid#
</cfquery>

<cflocation url="index.cfm?curdoc=user_info&userid=#url.userid#">