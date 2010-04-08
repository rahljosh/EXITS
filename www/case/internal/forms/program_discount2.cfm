<span class="application_section_header">Program Fees</span> <br>

<p>Assign program fees per program for this International Rep.  Changing information here will only affect students that have NOT been invoiced. <br><br>
If there is difference from the base price, just leave blank, don't put in zero's, N/A, etc.<br>
If you need to remove an amount, set it to 0 (zero).</p>

<Cfquery name="programs" datasource="caseusa">
select smg_programs.programname, smg_programs.programid, smg_programs.type, smg_programs.companyid, smg_programs.enddate, smg_programs.programfee

from smg_programs 
where enddate > #now()#
<cfif #client.companyid# is 5>
<cfelse> 
and companyid = #client.companyid# 
</cfif>
order by companyid
</Cfquery>

<form method="post" action="querys/add_discount.cfm">
<Cfoutput>
<input type="hidden" name="numberrecords" value=#programs.recordcount#>
<input type="hidden" name="userid" value=#url.userid#>
</Cfoutput>
<cfif isDefined('url.message')>

</cfif>
<table div align="center" cellpadding= 4 cellspacing=0>
	<tr bgcolor="#00003C">
		<Td></Td><td><font color="white">Program Name</td><td><font color="white">Type</td><td><font color="white">Base Fee</td><td><font color="white">Program Fee</td>
	</tr>
	<cfoutput query="programs">
	<cfquery name="discount_check" datasource="caseusa">
	select *
	from smg_program_discount
	where programid = #programs.programid# and userid = #url.userid#
	</cfquery>
		<cfquery name="type" datasource="caseusa">
	select programtype
	from smg_program_type 
	where programtypeid = #type#
	</cfquery>
	<tr bgcolor="#iif(programs.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
	
		<Td><cfif #enddate# lt #now()#><font color="red">expired<cfelse><Font color="green">active</cfif></Font></Td><td>#programname#</a></td><td><cfif type.programtype is ''><font color="red">None Assigned</font><cfelse>#type.programtype#</cfif></td><td>#programfee#</td><td><input type="text" size=5 name="#currentRow#_program_fee" value=<cfif discount_check.recordcount is 0><cfelse>#discount_check.program_fee#</cfif>><input type="hidden" name="#CurrentRow#_programid" value=#programid#></td>
	</tr>
	</cfoutput>

	<tr bgcolor="#00003C">
		<td colspan=5><font color="white">Insurance Type</td>
	</tr>
	<cfquery name="insurance_type" datasource="caseusa">
	select ins_deductable
	from smg_users
	where userid=#url.userid#
	
	</cfquery>
	<tr>
		<td colspan=2>Non- Deductable<input type="radio" name="deductable" value=0 <cfif insurance_type.ins_deductable is 0>checked</cfif> ></td><td colspan=2>Deductable<input type="radio" name="deductable" value=1 <cfif insurance_type.ins_deductable is 1>checked</cfif>></td>
	</tr>
	<Tr>
<td colspan=2><input name="Submit" type="image" src="pics/next.gif" border=0></td>
</Tr>
</table>
<br>

</form>
<Cfif isDefined('url.message')>
<p><span class="get_attention" align="center">Program charges were updated / added succesfully!!</span><br><br></cfif>