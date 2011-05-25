<cfoutput>

<cfscript>
	// Get Program List
	qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
</cfscript>

<form action="index.cfm?curdoc=reports/taxback" method="post">
<table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
  <tr valign="middle" height="24">
    <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
        <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Report for Taxback</font>
    </td>
  </tr>
  <tr valign="middle" height="24">
    <td valign="middle" colspan="2">&nbsp;</td>
  </tr>
    <tr>
    <td valign="middle" align="right" class="style1"><b>Program: </b></td><td>
	 <select name="program" class="style1">
		<option></option>
	<cfloop query="qGetProgramList">
	<option value=#programid# <cfif IsDefined('form.program')><cfif qGetProgramList.programid eq #form.program#> selected</cfif></cfif>>#programname#</option>
	</cfloop>
	</select>
	
	 </td>
  </tr>

  <!--- <Tr>
  	<td align="right" class="style1"><b>Format: </b></td>
	<td class="style1"> <input type="radio" class="style1" name="print" value=0 checked>  Onscreen (View Only) <input type="radio" name="print" value=1> Print (PDF)
  <input type="radio" name="print" value=2> Excel (XLS)
  </Tr> --->
  <tr>
  	<td colspan=2 align="center"><br />
	<input type="submit" value="Generate Report" class="style1" /><br />
	<br />	</td>
  </tr>
</table>


<br>


<cfif IsDefined('form.program')>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />
		<meta http-equiv="refresh" content="1;url=reports/taxback_excel.cfm?program=#form.program#">
</cfif>
    

</cfoutput>