<span class="application_section_header">Progress Report Questions</span>
<br>
<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.form.sele_region.options[document.form.sele_region.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<cfif not isDefined('url.month')>
	<cfset url.month = 9>
</cfif>
<cfquery name="questions" datasource="MySQL">
select * 
from smg_prquestions 
where companyid = #client.companyid# and month = #url.month# and active = 1
order by month
</cfquery>
 
	<form name="form">
Select the month of questions you'd like to view:		
		<select name="sele_region" onChange="javascript:formHandler()">
		
		<option value="?curdoc=tools/progress_report_questions&month=9" <cfif url.month eq 9>selected</cfif>>September</option>
		<option value="?curdoc=tools/progress_report_questions&month=12" <cfif url.month eq 12>selected</cfif>>December</option>
		<option value="?curdoc=tools/progress_report_questions&month=2" <cfif url.month eq 2>selected</cfif>>February</option>
		<option value="?curdoc=tools/progress_report_questions&month=4" <cfif url.month eq 4>selected</cfif>>April</option>
		<option value="?curdoc=tools/progress_report_questions&month=6" <cfif url.month eq 6>selected</cfif>>June</option>
		</select>
	
	</form>
<form method="post" action="querys/update_pr_questions.cfm">

<br>
<cfif isDefined('url.u')>
<div align="center"><font color="green">Questions Updated Succesfully!! Make additional changes below.</font></div>
</cfif>
<br>

<Cfoutput>
<input type="hidden" value=#url.month# name="month">


<cfset question_list = ''>
	<cfloop query="questions">
	<cfset question_list= #ListAppend(question_list, #id#, ',')#>
	Question #questions.currentrow# -- Active : <input type=radio name="#questions.id#_active" value=1 <cfif active is 1>checked</cfif> >Yes <input type=radio name="#questions.id#_active" value=0 <cfif active is 0>checked</cfif>>No  <br><textarea cols="60" rows="5" name="#questions.id#_answer" wrap="VIRTUAL">#text#</textarea>
			<input type="hidden" name="#questions.id#_question_number" value=#id#><br>
	<br>

</cfloop>
New Question: -- Add New<input type="checkbox" name="newq" value=1><br><textarea cols="60" rows="5" name="new_question" wrap="VIRTUAL"></textarea>
			
<input type="hidden" name="question_list" value="#question_list#">
</Cfoutput>

<input name="Submit" type="image" src="pics/update.gif" align="right" border=0>
</form>

