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

<cfoutput>

<table width="100%" border="0" cellpadding="3" cellspacing="1" bgcolor="##333333">
    <tr bgcolor="##003300" class="style1">
      <td height="31" colspan="3" class="label style3">Thank you for vote.</td>
    </tr>
</table><br>

<table width="100%" border="0" cellpadding="3" cellspacing="1">
	<tr><td align="center">&nbsp;<input type="image" value="close window" src="close.gif" onClick="javascript:window.close()"></td></tr>
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