

<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
	<tr bgcolor="E4E4E4">
	  <td width="85%" > Program Maintenence</td>
		<td width="15%" class="title1"><!---<cfoutput>#programstools.active# </cfoutput>----></td>
	</tr>
</table>
<cfform name="form" id="form" method="post" action="index.cfm?curdoc=tools/qr_insertprogram"><br>

<table width=95% border=0 align="center" cellpadding=0 cellspacing=0 class="section">
	
	<tr>
		<td><table width="100%" border="0" align="center" >
          <tr>
            <td colspan="5" bgcolor="4F8EA4"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF"> <b>Add New Program</b></font></td>
          </tr>
          <tr>
            <td width="23%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program Name</font></td>
            <td width="77%"><cfinput type="text" name="programname" ></td>
          </tr>
          <tr>
            <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Type</font></td>
            <td>
            <cfquery name="get_programtype" datasource="MySql">
				SELECT programtype, programtypeid
                FROM smg_program_type
              
            </cfquery>
              <select name="type" id="select">
              	<option value=""></option>
                  <cfloop query="get_programtype">
                	<cfoutput><option value="#programtypeid#">#programtype#</option></cfoutput>
                  </cfloop>
              </select>            </td>
          </tr>
          <tr>
            <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Start Date</font></td>
            <td><cfinput type="text" name="startdate">
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> (mm/dd/yyyy</font>)</td>
          </tr>
          <tr>
            <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">End Date</font></td>
            <td><cfinput type="text" name="enddate" > <font size="2" face="Verdana, Arial, Helvetica, sans-serif">(mm/dd/yyyy</font>)</td>
          </tr>
          <tr>
            <td colspan="2" align="center"><input type="image" src="../pics/save.gif" name="button" value="Submit" alt="save" /></td>
          </tr>
        </table></td>
	</tr>
</table>
</cfform>
