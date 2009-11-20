<cfoutput>

<!----
<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.batch.program.options[document.batch.program.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler2(form){
var URL = document.batch.intrep.options[document.batch.intrep.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler3(form){
var URL = document.batch.intrep.options[document.batch.school.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>
---->
<Cfparam name=url.programid default=0>
<cfparam name=url.intrep default=all>
<cfparam name=url.schoolid default=0>


<cfquery name="report_dates" datasource="mysql">
select distinct i20received 
from php_students_in_program
where i20received is not null
<!----
<cfif isDefined('url.intrep')>
	<cfif url.intrep is 'all'>
	<cfelse>
	and intrep = #url.intrep#
	</cfif> 
</cfif>
<cfif isDefined('url.programid')>
and programid = #url.programid#
</cfif>
<cfif isDefined('url.schoolid')>
and schoolid = #url.schoolid#
</cfif>
---->
order by i20received
</cfquery> 

<form action="reports/letter_hf_welcome_batch.cfm" method="post" name="batch">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4"  class="style1" colspan=2><strong>&nbsp;Select the representative, school and program you would like to generate batch welcome letters for.  Students will only show up on this list once.  Once the report is run, the student will be marked as letter printed and no longer show up on this list.  To print additional copies, click on Host Family Welcome Letter on the student's profile.</strong></td>

  </tr>
  <tr valign="middle" height="24">
    <td valign="middle"class="title1" colspan=2>&nbsp;</td>

  </tr>


  	
  <tr valign="middle">
    <td align="right" valign="middle" class="style1"><strong>Int. Rep.:</strong> </td>
	
	<td valign="middle">     
   
	<cfquery name="get_intrep" datasource="MySql">
		SELECT userid as intrep, businessname
		FROM smg_users
		WHERE usertype = 8
		ORDER BY businessname
	</cfquery>
      
       
	   <select name="intrep" onChange="javascript:formHandler2()"  class="style1">
			<option>All</option>
            <cfloop query="get_intrep">
              <option value="#intrep#" <cfif IsDefined('url.intrep')><cfif get_intrep.intrep eq #url.intrep#> selected</cfif></cfif>> #get_intrep.businessname# </option>
            </cfloop>
       </select>
<!----         <input type="hidden" name="selected_rep" value="#url.intrep#"> ---->
        </td>

  </tr>
    <tr>
    <cfquery name="get_program" datasource="MySql">
	SELECT programname, programid
	FROM smg_programs 
	where companyid = #client.companyid# and active = 1
    </cfquery>
    <td valign="middle" align="right"  class="style1"><strong>Program:</strong></td>
	
	<td>

	 <select name="program" onChange="javascript:formHandler()"  class="style1">

		<option></option>
	
	<cfloop query="get_program">
	<option value="#programid#" <cfif IsDefined('url.programid')><cfif get_program.programid eq #url.programid#> selected</cfif></cfif>>#programname#</option>

	</cfloop>
		</select>
<!----	 <input type="hidden" name="selected_program" value="#url.programid#"> ---->
	
	 </td>
	</tr>
	<Tr>
    	<Td valign="middle" align="right"  class="style1"><strong>Type:</Td><td><input type="radio" name="print_form" value="hf" selected>Host Family  <input type="radio" name="print_form" value="stu" /> Student</td>
   <!---- <tr>
    <cfquery name="get_school" datasource="MySql">
	SELECT schoolname, schoolid
	FROM php_schools 
	ORDER BY schoolname
    </cfquery>
    <td valign="middle" align="right"  class="style1"><strong>School:</strong></td>
	
	<td>

	 <select name="school" onChange="javascript:formHandler3()"  class="style1">

		<option></option>
	
	<cfloop query="get_school">
	<option value="#schoolid#" <cfif IsDefined('url.schoolid')><cfif get_school.schoolid eq #url.schoolid#> selected</cfif></cfif>>#schoolname#</option>

	</cfloop>
		</select>
<!----	 <input type="hidden" name="selected_school" value="#url.schoolid#"> ---->
	
	 </td>
	</tr>

	<tr>
		<td align="right" valign="middle" class="style1"><strong>Dates:</strong> </td>
		<td>
		
		
		<select name="date"  class="style1">
		<option value=""></option>
		<cfloop query="report_dates">
		<option value="#DateFormat(i20received, 'yyyy-mm-dd')#">#DateFormat(i20received, 'mm-dd-yyyy')#</option>
		</cfloop>
		</select>
	
		</td>
	</tr>---->
  <tr>
  	<td colspan=2 align="center"><input type="submit" value="Generate Report"  class="style1" /></td>
  </tr>
</table>

</cfoutput>

