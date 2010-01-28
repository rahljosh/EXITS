<cfoutput>


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

<Cfparam name=url.programid default=0>
<cfparam name=url.intrep default=all>


<cfquery name="report_dates" datasource="mysql">
select distinct verification_received 
from extra_candidates
where verification_received is not null

<cfif isDefined('url.intrep')>
	<cfif url.intrep is 'all'>
	<cfelse>
	and intrep = #url.intrep#
	</cfif> 
</cfif>
<cfif isDefined('url.program')>
and programoid = #url.program#
</cfif>

order by verification_received
</cfquery> 

<form action="candidate/batchimmigrationLetter.cfm" method="post" name="batch">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4"  class="style1" colspan=2><strong>&nbsp;Select the Intl. Rep. and program you would like to generate batch immigration letters for.  Candidates will only show up on this list once.  Once the report is ran, the candidate will be marked as letter printed and no longer show up on this list.  To print additional copies, click on Immigration Letter on the candidates profile.</strong></td>

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
              <option value="?curdoc=candidate/select_batch&programid=#url.programid#&intrep=#intrep#" <cfif IsDefined('url.intrep')><cfif get_intrep.intrep eq #url.intrep#> selected</cfif></cfif>> #get_intrep.businessname# </option>
            </cfloop>
       </select>
         <input type="hidden" name="selected_rep" value="#url.intrep#">
        </td>

  </tr>
    <tr>
    <cfquery name="get_program" datasource="MySql">
	SELECT programname, programid
	FROM smg_programs 
	where companyid = #client.companyid#
    </cfquery>
    <td valign="middle" align="right"  class="style1"><strong>Program:</strong></td>
	
	<td>

	 <select name="program" onChange="javascript:formHandler()"  class="style1">

		<option></option>
	
	<cfloop query="get_program">
	<option value="?curdoc=candidate/select_batch&programid=#programid#&intrep=#url.intrep#" <cfif IsDefined('url.programid')><cfif get_program.programid eq #url.programid#> selected</cfif></cfif>>#programname#</option>

	</cfloop>
		</select>
	 <input type="hidden" name="selected_program" value=#url.programid#>
	
	 </td>
	</tr>

	<tr>
		<td align="right" valign="middle" class="style1"><strong>Dates:</strong> </td>
		<td>
		
		
		<select name="date"  class="style1">
		<option value=""></option>
		<cfloop query="report_dates">
		<option value="#DateFormat(verification_received, 'yyyy-mm-dd')#">#DateFormat(verification_received, 'mm-dd-yyyy')#</option>
		</cfloop>
		</select>
	
		</td>
  <tr>
  	<td colspan=2 align="center"><input type="submit" value="Generate Report"  class="style1" /></td>
  </tr>
</table>

</cfoutput>

