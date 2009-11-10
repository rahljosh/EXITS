<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfquery name="get_question" datasource="MySql">
	SELECT questionid, caption, question, date, active
	FROM poll_questions
	WHERE active = '1'
</cfquery>

<cfquery name="get_answers" datasource="MySql">
	SELECT answerid, questionid, answer, votes
	FROM poll_answers
	WHERE questionid = '#get_question.questionid#'
</cfquery>

<script language="JavaScript">
<!--
function ProcessForm(answer) {
   var Proceed=0;
   for (i=0; i<=<cfoutput>#get_answers.RecordCount#</cfoutput>-1; i++) {
      if (document.poll.answerid[i].checked) {
         Proceed=1;
         break;
      }
   }
   if (Proceed == 0) {
      alert("You must select an answer to place your vote.");
	} else if (document.poll.answerid[8].checked & document.poll.other_city.value == '') {
   	  alert("You've selected 'other' as an option. You must type other city where you would like to go with SMG.");
    } else {
      document.poll.submit();
   }
}

function enableField()
{
	if (document.poll.answerid[8].checked) {
		document.poll.other_city.disabled=false;
		document.poll.other_city.required=true;
		document.poll.other_city.focus();
		document.poll.other_city.value = '';
	} else {
		document.poll.other_city.disabled=true;
		document.poll.other_city.required=false;
		document.poll.other_city.value = '';
	}
}
//-->
</script>

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
.style4 {
	color: #003300;
	font-weight: bold;
}
body {
	margin-left: 10px;
	margin-top: 10px;
	margin-right: 10px;
	margin-bottom: 10px;
}
-->
   </style>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>

<body>

<cfoutput>	

<cfform name="poll" action="process_poll.cfm" method="post">
<table border="1" cellpadding="3" cellspacing="0" bordercolor="##003300">
      <cfinput type="hidden" name="questionid" value="#get_question.questionid#">
		<tr bgcolor="##003300">
		 <td height="31" colspan="2" class="style1"><span class="style3">#get_question.question#</span></td>
	  </tr>
		<cfloop query="get_answers">
		<tr bordercolor="##FFFFFF" bgcolor="##FFFFFF" class="style1">
			 <td>#answer#</td>
		  <td><input type="radio" name="answerid" value="#answerid#" id="#answer#" onClick="enableField()"></td>
		</tr>
		</cfloop>
		<tr bordercolor="##FFFFFF" bgcolor="##FFFFFF" class="style1">
		  <td colspan="2"><cfinput type="text" name="other_city" size="30" maxlength="50" value="" disabled></td>
		</tr>
		<tr bordercolor="##FFFFFF" bgcolor="##FFFFFF" class="style1">
		  <td colspan="2" align="center"><input type="button" value="Vote" onClick="ProcessForm()"></td>
		</tr>
<!--- 		<tr bordercolor="##FFFFFF" bgcolor="##FFFFFF" class="style1">
		  <td colspan="2" align="center"><a href="process_poll.cfm?questionid=#get_question.questionid#" class="style4">View Results</a></td>
	  </tr> --->
</table></cfform>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><div align="center"><span class="style1">SMG &copy; 2006 <a href="http://www.student-management.com" class="style4">Student Management Group</a> </span></div></td>
  </tr>
</table>
</cfoutput>
</body>
</html>
