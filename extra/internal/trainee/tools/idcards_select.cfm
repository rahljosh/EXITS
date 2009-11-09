<html>
<head>
</head>

<cfinclude template="../querys/get_active_programs.cfm">

<cfoutput>

<br />
    <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="50%">
      <tr>
        <th colspan="2" bgcolor="##4F8EA4" class="style2">ID Cards</th>
      </tr>
      <tr>
        <!---- <td width="50%">
		<cfform action="tools/labels_for_filing.cfm" method="POST">
            <table class="nav_bar" align="left" cellpadding="6" cellspacing="0" width="100%">
              <tr>
                <th colspan="3" bgcolor="##e9ecf1"><span class="style2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Per Period</font></span></th>
              </tr>
              <tr>
                <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program :</font></td>
                <td><select name="programid" size="1">
                    <option value="0">All Programs</option>
                    <cfloop query="get_active_programs">
                      <option value="#programid#">#programname#</option>
                    </cfloop>
                </select></td>
              </tr>
              <tr>
                <td width="5"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">From :</font> </td>
                <td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date" required="yes">
                  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">mm/dd/yyyy </font></td>
              </tr>
              <tr>
                <td width="5"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">To : </font></td>
                <td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date" required="yes">
                  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">mm/dd/yyyy</font></td>
              </tr>
              <tr>
                <td colspan="2" align="center" bgcolor="##e9ecf1"><input type="image" src="../pics/preview.gif" align="center" border="0" /></td>
              </tr>
            </table>
        </cfform>
		
		</td> ---->
        <td><cfform action="tools/idcards_id.cfm" method="POST">
            <table class="nav_bar" align="right" cellpadding="6" cellspacing="0" width="100%">
              <tr>
                <th colspan="2" bgcolor="##e9ecf1" class="style1"><b>Per Candidate ID</b></th>
              </tr>
              <tr>
                <td class="style1"><b>Program:</b></font></td>
                <td><select name="programid2" class="style1" size="1">
                    <option value="0">All Programs</option>
                    <cfloop query="get_active_programs">
                      <option value="#programid#">#programname#</option>
                    </cfloop>
                </select></td>
              </tr>
              <tr>
                <td width="5" class="style1"><b>From: </b> </td>
                <td><cfinput type="text" name="id1" class="style1" size="4" maxlength="6" validate="integer" required="yes"></td>
              </tr>
              <tr>
                <td width="5" class="style1"><b>To: </b> </td>
                <td><cfinput type="text" name="id2" class="style1" size="4" maxlength="6" validate="integer" required="yes"></td>
              </tr>
              <tr>
                <td colspan="2" align="center" bgcolor="##e9ecf1"><input type="image" src="../pics/preview.gif" align="center" border="0" /></td>
              </tr>
            </table>
        </cfform></td>
      </tr>
    </table>
</cfoutput>
</html>
