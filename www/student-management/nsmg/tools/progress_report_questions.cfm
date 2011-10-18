
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

<cfparam name="form.showActive" default="0">

<Cfif isDefined('form.processUpdate')>
        <cfloop list = "#FORM.question_list#" Index = "x">
        <cfset question = #Evaluate("FORM." & x & "_answer")#>
        <cfset question2 = #PreserveSingleQuotes(question)#>
                <Cfquery name="add_question_Details" datasource="mySQL">
                 update smg_prquestions
                    set text = '#question2#',
                     yn = '#Evaluate("FORM." & x & "_yn")#',
                     companyGroup = '#client.company_submitting#',
                     month =#form.month#,
                     ynValues = '#Evaluate("FORM." & x & "_ynValues")#',
                     required = #Evaluate("FORM." & x & "_req")#,
                     active = #Evaluate("FORM." & x & "_active")#
                    where id = #x#
                 </Cfquery>
        
        </cfloop>
        <cfif isdefined('form.newq')>
        
        <cfset newq2 = #PreserveSingleQuotes(form.new_question)#>
            <cfquery name="insert_new_question" datasource="MySQL">
            insert into smg_prquestions(text, yn, companyGroup, month)
                values('#newq2#', 'yes', '#client.company_submitting#', #form.month#)
            </cfquery>
        </cfif>
      
<div align="center"><font color="green">Questions Updated Successfully!! Make additional changes below.</font></div>

</Cfif>



<cfif not isDefined('url.month')>
	<cfset url.month = 10>
</cfif>
<cfquery name="questions" datasource="MySQL">
select * 
from smg_prquestions 
where companygroup = '#client.company_submitting#' and month = #url.month# 
<Cfif form.showActive eq 1>
and active = 1
</Cfif>
order by month
</cfquery>

<style type="text/css">
.border {
       border: thin solid #999;
	   padding-left:10px;
	   padding-right:10px;
	   padding-top:10px;
	   padding-bottom:10px;
}
.fontBold{
		font-weight:bold;
		width:800px;
}
button{
	clear:both;
	margin-left:150px;
	width:125px;
	height:31px;
	background:#666666 url(img/button.png) no-repeat;
	text-align:center;
	line-height:31px;
	color:#FFFFFF;
	font-size:11px;
	font-weight:bold;
}
 </style>
<div class="fontBold">
	<form name="form">
Select the month of questions you'd like to view:		
		<select name="sele_region" onChange="javascript:formHandler()">
        <option value="?curdoc=tools/progress_report_questions&month=8" <cfif url.month eq 8>selected</cfif>>August</option>
		<option value="?curdoc=tools/progress_report_questions&month=9" <cfif url.month eq 9>selected</cfif>>September</option>
		<option value="?curdoc=tools/progress_report_questions&month=10" <cfif url.month eq 10>selected</cfif>>October</option>
        <option value="?curdoc=tools/progress_report_questions&month=11" <cfif url.month eq 11>selected</cfif>>November</option>
		<option value="?curdoc=tools/progress_report_questions&month=12" <cfif url.month eq 12>selected</cfif>>December</option>
        <option value="?curdoc=tools/progress_report_questions&month=1" <cfif url.month eq 1>selected</cfif>>January</option>
		<option value="?curdoc=tools/progress_report_questions&month=2" <cfif url.month eq 2>selected</cfif>>February</option>
        <option value="?curdoc=tools/progress_report_questions&month=3" <cfif url.month eq 3>selected</cfif>>March </option>
		<option value="?curdoc=tools/progress_report_questions&month=4" <cfif url.month eq 4>selected</cfif>>April</option>
        <option value="?curdoc=tools/progress_report_questions&month=5" <cfif url.month eq 5>selected</cfif>>May</option>
		<option value="?curdoc=tools/progress_report_questions&month=6" <cfif url.month eq 6>selected</cfif>>June</option>

		
		</select>
	
	</form>
    <Cfoutput>
<form method="post" action="index.cfm?curdoc=tools/progress_report_questions&month=#url.month#">
<br />
Show only active questions: <input type="checkbox" name="showActive" value=1 <cfif form.showActive eq 1>checked</cfif> />
<br>
<cfif isDefined('url.u')>
<div align="center"><font color="green">Questions Updated Successfully!! Make additional changes below.</font></div>
</cfif>
<br>


<input type="hidden" value=#url.month# name="month">


<cfset question_list = ''>
	<cfloop query="questions">
	<cfset question_list= #ListAppend(question_list, #id#, ',')#>
	
    <table cellpadding=2 class="border" <cfif questions.currentrow mod 2>bgcolor="##cccccc"</cfif> >
    <Tr>
    	<th bgcolor="##666666" colspan=3><font color="white" size=4>Question #questions.currentrow# </font></th>
    </Tr>
    <Tr>
        	<Td>Active : </Td>
            <td><input type=radio name="#questions.id#_active" value=1 <cfif active is 1>checked</cfif> > &nbsp;Yes 
                <input type=radio name="#questions.id#_active" value=0 <cfif active is 0>checked</cfif>> &nbsp;No  </td>
        </Tr>
        <tr>
        	<td>Required: </td>
            <td><input type="radio" value="1" name="#questions.id#_req" <cfif required eq 1>checked</cfif>  /> &nbsp;Yes
            	<input type="radio" value="0" name="#questions.id#_req" <Cfif required eq 0>checked</cfif> /> &nbsp;No 
            </td>
         </tr>
         <tr>
         	<td>Yes/No/Maybe type Question: </td>
            <td><input type="radio" value="yes" name="#questions.id#_yn" <Cfif yn is 'yes'>checked</cfif> /> &nbsp;Yes
            	<input type="radio" value="no" name="#questions.id#_yn" <Cfif yn is 'no'>checked</cfif> /> &nbsp;No 
       
            </td>
         <tr>
            <td>If Yes/No/Maybe, enter possible answers.  Seperate each with a comma.</td>
            <td><input type="text" name="#questions.id#_ynValues" size=10 value="#ynValues#"/>
         </tr>
         <tr>
         	<td colspan=2>
	<textarea cols="60" rows="5" name="#questions.id#_answer" wrap="VIRTUAL">#text#</textarea>
			     <input type="hidden" name="#questions.id#_question_number" value=#id#>
            </td>
         </tr>
     </table>
     <br /><br />
</cfloop>
<table cellpadding=2 class="border" bgcolor="##FFCC99" >
    <Tr>
    	<th bgcolor="##666666" colspan=3><font color="white" size=4>New Question </font></th>
    </Tr>
	<Tr>
    	<Td>I want to add a new question: <input type="checkbox" name="newq" value=1>Yes</Td>
    </Tr>
    <tr>
    	<td><textarea cols="60" rows="5" name="new_question" wrap="VIRTUAL"></textarea></td>
    </tr>
 </table>
			
<input type="hidden" name="question_list" value="#question_list#">
<input type="hidden" name="processUpdate" />
<br /><Br />
<button type="submit">Submit Information</button>

</form>
</Cfoutput>
</div>

