<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Additional Health Questions</title>
</head>

<body>
<cfif isDefined('form.insert')>
<cfquery name="delete_current" datasource="#application.dsn#">
delete from smg_student_app_health_explanations
		where studentid = #client.studentid#
</cfquery>
<cfloop list="#client.need_add_info#" index="i">
    <cfquery name="insert_details" datasource="#application.dsn#">
    insert into smg_student_app_health_explanations (question, answer, studentid)
    										VALUES('#i#', '#form["question" & i]#', #client.studentid#) 
    </cfquery>
</cfloop>

<cflocation url="?curdoc=section3/page12&id=3&p=12">
</cfif>
<br />
You answered yes to the following questions, please provide as much information as possible regarding the following items:<br /><br />
<cfform method="post" action="index.cfm?curdoc=section3/additional_health_answers">
<cfoutput>
<cfloop list=#client.need_add_info# index="i">
<!----Check to see if there is an answer for this question already---->
<cfquery name="current_answers" datasource="#application.dsn#">
select *
from smg_student_app_health_explanations
where studentid = #client.studentid# and question = '#i#'
</cfquery>
<!----set temp var to current answer or else blank it---->
<cfif current_answers.recordcount gt 0>
<cfset this_answer = '#current_answers.answer#'>
<Cfelse>
<cfset this_answer = ''>
</cfif>
#i#<br />
<cftextarea name="question#i#" cols="40" rows="10" required="yes" message="Please provide information in the area regarding: #i#">#this_answer#</cftextarea>
<br /><br />
</cfloop>
</cfoutput>
<input type="hidden" name="insert" />
<input type="submit" value="Submit" />
</cfform>
</body>
</html>
