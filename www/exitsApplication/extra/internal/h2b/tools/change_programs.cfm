<html>
<head>
<title></title>

<head></head>
<body>
<cfquery name="programstools" datasource="MySql">
	SELECT programid, programname, type, smg_program_type.programtype, startdate, enddate, insurance_startdate, insurance_enddate, smg_programs.companyid, programfee, smg_programs.active, smg_programs.hold
	FROM smg_programs
    INNER JOIN smg_companies ON smg_companies.companyid = smg_programs.companyid
    LEFT JOIN smg_program_type ON smg_program_type.programtypeid = smg_programs.type
    WHERE smg_programs.companyid = #client.companyid# AND programid = #url.programid#
</cfquery>


<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
	<tr bgcolor="E4E4E4">
	  <td width="85%" class="title1"> Program Maintenence</td>
		<td width="15%" class="title1"><!---<cfoutput>#programstools.active# </cfoutput>----></td>
	</tr>
</table><br />


<cfform name="form" id="form" method="post" action="index.cfm?curdoc=tools/qr_updateprogram&programid=#url.programid#">
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	
	<tr><cfoutput query="programstools">
		<td><table width="95%" border="0" align="center">
          <tr>
            <td colspan="2" bgcolor="4F8EA4"><span class="style1"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="FFFFFF"><b>Edit Program</b></font></span></td>
            </tr>
          <tr>
            <td width="16%"><div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program Name</font></div></td>
            <td width="84%">
              
                <div align="left">
                  <cfinput type="text" name="programname" value="#programname#">
              </div></td>
          </tr>
          <tr>
            <td><div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Type</font></div></td>
            <td> 
              
                  <div align="left">
                      <cfquery name="get_programtype" datasource="MySql">
				SELECT smg_program_type.programtype, smg_program_type.programtypeid as typeid
                FROM smg_program_type
                             
                    </cfquery>
                      
                      <select name="type" id="select">
                        <option value=""></option>
                        <cfloop query="get_programtype">
                          <cfoutput>
                            <option value="#typeid#" <cfif programstools.type eq #typeid#>selected</cfif>> #programtype#  </option>
                          </cfoutput>
                        </cfloop>
                      </select>
                </div></td>
          </tr>
          <tr>
            <td><div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Start Date</font></div></td>
            <td>
              
                <div align="left">
                  <input type="text" name="startdate" <cfif startdate is ''>value=''<cfelse>value="#DateFormat(startdate, 'mm/dd/yyyy')#"</cfif>name='startdate'> 
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">(mm/dd/yyyy</font>)</div></td>
          </tr>
          <tr>
            <td><div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">End Date</font></div></td>
            <td>
              
                <div align="left">
                  <input type="text" name="enddate" <cfif enddate is ''>value=''<cfelse>value="#DateFormat(enddate, 'mm/dd/yyyy')#"</cfif>name='startdate'> 
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">(mm/dd/yyyy</font>)</div></td>
          </tr>
          <tr>
            <td colspan="2"><center><input type="image" src="../pics/save.gif" name="button" value="Submit" alt="save"  /></center></td>
            </tr>
        </table></td></cfoutput>
	</tr>
</table>
</cfform>

</body>
</html>