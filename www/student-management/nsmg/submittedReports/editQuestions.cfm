<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>
<cfif isDefined('form.addQuestion')>

	<Cfquery name="insertQuestion"  datasource="#application.dsn#">
    insert into smg_submitted_report_questions (fk_reportid, question, type)
    						values(#form.qid#,'#form.question#', '#form.questionType#')
                            
    </Cfquery>
</cfif>

<Cfquery name="activeQuestions" datasource="#application.dsn#">
select *
from smg_submitted_report_questions
where fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.qid#">
</Cfquery>
<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">Questions</span> 
        <div style="float:right;"><img src="pics/betaTesting.png"></div> 
    </div>
    <div class="rdbox">
    <h1>Add a Question</h1>
   <Cfoutput> 
    <form method="post" action="#CGI.PATH_INFO#?#CGI.QUERY_STRING#">
    <input type="hidden" value="#url.qid#" name="qid" />
    <Table width="80%">
    	<tr>
        	<td valign="top">Question: <textarea name="question" rows=5 cols=60></textarea></td>
            <td>Answer: <select name="questionType" >
            <option value="Full Text" selected>Full Text</option>
            </select>
            </td>
          	
           
      		<td><input name="addQuestion" id="addQuestion" type="submit" value="Add Question"  alt="Add Question" border="0" class="basicOrangeButton" /></td>
          </tr>
      </table>
    </form>
    <h1>Current Questions on this Report</h1>
    
    <Table width="80%">
   		<tr>
        	<td>Question </td>
            <Td>Type</Td>
            <td>Active</td>
            <td>## of Reports</td>
           
    <cfif activeQuestions.recordcount eq 0>
    	<Tr>
        	<td colspan = 4 align="center">No questions on this report. </td>
        </Tr>
    <cfelse>
    <Cfloop query="activeQuestions">
    	<tr>
        	<td>#question#</td>
            <td>#type#</td>
          	<Td> <cfif #isActive# eq 1>Yes<cfelse>No</cfif></Td>
            
      		
          </tr>
     </Cfloop>
     </cfif>
     </table>
      </cfoutput>
    </div>
  <div class="rdbottom"></div> <!-- end bottom --> 
</div>