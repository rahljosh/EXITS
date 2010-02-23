<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
  <title>SMG Poll</title>
  <link href="../style.css" rel="stylesheet" type="text/css">
  <style type="text/css">
<!--
.style3 {
	color: #FFFFFF;
	font-weight: bold;
}
body {
	margin-left: 10px;
	margin-top: 10px;
	margin-right: 10px;
	margin-bottom: 10px;
}
.style4 {
	color: #003300;
	font-weight: bold;
}
-->
  </style>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>

<body>

<cfif not IsDefined('client.usertype') OR client.usertype GTE 5>
	<table border="0" cellpadding="3" cellspacing="1" bgcolor="##333333">
		<tr bgcolor="##003300" class="style1">
		  <td height="31" colspan="3" class="label style3">Sorry, you do not have sufficient privileges to see this page.</td>
		</tr>
	</table>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td><div align="center"><span class="style1">SMG &copy; 2006 <a href="http://www.student-management.com" class="style4">Student Management Group</a> </span></div></td>
	  </tr>
	</table>
	<cfabort>
</cfif>

<cfif IsDefined("form.answerid")>
	<cftransaction>
		<cfquery name="last_vote" datasource="MySql">
			SELECT votes
			FROM poll_answers
			WHERE questionid = '#form.questionid#'
			AND answerid= '#form.answerid#'
		</cfquery>
		
		<cfset new_vote = (last_vote.votes + 1)>
		
		<cfquery name="new_vote" datasource="MySql">
			UPDATE poll_answers
			SET votes = '#new_vote#'
			WHERE questionid = '#form.questionid#'
			AND answerid= '#form.answerid#'
		</cfquery>
		
		<cfif IsDefined('form.other_city')>
			<cfquery name="other_city" datasource="MySql">
				INSERT INTO poll_other
					(questionid , answerid , other)
				VALUES
					('#form.questionid#', '#form.answerid#', <cfqueryparam value="#form.other_city#" cfsqltype="cf_sql_char">)
			</cfquery>
		</cfif>
	</cftransaction>
</cfif>

<cfquery name="get_question" datasource="MySql">
	SELECT questionid, caption, question, date, active
	FROM poll_questions
	WHERE active = '1'
	<cfif IsDefined('url.questionid')>AND questionid = <cfqueryparam value="#url.questionid#" cfsqltype="cf_sql_integer"></cfif>
</cfquery>

<cfquery name="total_votes" datasource="MySql">
	SELECT sum(votes) as total
	FROM poll_answers
	WHERE questionid = '#get_question.questionid#'
	GROUP BY questionid
</cfquery>

<cfquery name="Results" datasource="MySql">
	SELECT answerid, questionid, answer, votes
	FROM poll_answers
	WHERE questionid = '#get_question.questionid#'
</cfquery>

<cfquery name="other" datasource="MySql">
	SELECT other, count(other) as total 
	FROM `poll_other` 
	WHERE questionid = '1'
	GROUP BY other
	ORDER BY other
</cfquery>

<cfoutput>

<table width="100%" border="0" cellpadding="3" cellspacing="1">
<tr>
	<td width="48%" valign="top">
		<table width="100%" border="0" cellpadding="3" cellspacing="1" bgcolor="##333333">
			<tr bgcolor="##003300" class="style1">
			  <td height="31" colspan="3" class="label style3">#get_question.question#</td>
			</tr>
		  <cfloop query="results">
			<cfif total_votes.total NEQ 0>
				<cfset percent = Round((results.votes / total_votes.total) * 100)>
			<cfelse>
				<cfset percent = 0>
			</cfif>
			<tr bgcolor="##FFFFFF" class="style1">
			  <td class="label">#results.answer#</td>
			  <td>
				<table border="0" cellpadding="0" cellspacing="0">
				  <tr>
					<td valign="middle"><img align="middle" src="pics/orange_square.gif" width="#Percent#" height="20"></td>
					<td valign="middle"><span class="style1">&nbsp; #percent#</span><span class="label">%</span></td>
				  </tr>
				</table>
			  </td>
			  <td align="right" class="label">#results.votes# vote(s)</td>
			</tr>
		  </cfloop>
			<tr bgcolor="##FFFFFF" class="style1">
			  <td colspan="3" align="right" class="label">Total: #Int(total_votes.total)# votes</td>
			</tr>
		</table>
	</td>
	<td width="4%" valign="top">&nbsp;</td>
	<td width="48%" valign="top">
		<table width="100%" border="0" cellpadding="3" cellspacing="1" bgcolor="##333333">
			<tr bgcolor="##003300" class="style1">
			  <td height="31" colspan="3" class="label style3">Other Cities</td>
			</tr>
		  <cfloop query="other">
			<tr bgcolor="##FFFFFF" class="style1">
			  <td class="label">#other.other#</td>
			  <td align="right" class="label">#other.total# vote(s)</td>
			</tr>
		  </cfloop>
		</table>
	</td>
</tr>
</table><br>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td><div align="center"><span class="style1">SMG &copy; 2006 <a href="http://www.student-management.com" class="style4">Student Management Group</a> </span></div></td>
  </tr>
</table>
<p>
</cfoutput>

</body>
</html>