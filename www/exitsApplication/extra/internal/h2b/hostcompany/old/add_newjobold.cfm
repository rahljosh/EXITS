<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Add New Job</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>

<body>


<cfform action="qr_insertjob.cfm?hostcompanyid=#url.hostcompanyid#" method="post" name="form">
  <table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
  
  <table width="69%" border="0" align="left" cellpadding="3" cellspacing="0" bordercolor="#C7CFDC" bgcolor="#ffffff">
    <tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
      <td height="16" bgcolor="#8FB6C9" colspan="3" class="style1" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF"><b>:: Add New Job</b></font></td>
    </tr>
    <tr>
      <td height="32" align="left" valign="top" bordercolor="#FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Job Title
        <cfinput type="text" name="title"/>
        </font> <br />
        <cfoutput><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Low Wage</font>
            <cfinput type="text" name="low_wage" />
            </font></cfoutput><br />
        <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Wage
        <cfinput type="text" name="wage"/>
        </font>
        <br />
        <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Wage Type </font>
        <cfselect name="wage_type" multiple="no" >
         <option value="hourly"> Hourly </option>
         <option value="salary"> Salary </option>
         <option value="shift"> Shift </option>
         <option value="weekly"> Weekly </option>
        </cfselect>
        <br />
        <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Hours
        <cfinput type="text" name="hours"/>
        </font> <br />
        <cfoutput><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Positions Avail: </font>
          <cfinput type="text" name="avail_position"/>
            </font></cfoutput><br /></td>
      <td valign="top" bordercolor="#FFFFFF" border=0><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
        Sex </font> <br />
        <input type="radio" name="sex" value="0"  />
        <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Either </font>
        <input type="radio" name="sex" value="1" />
        <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Male</font>
        <input type="radio" name="sex" value="2" />
        <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Female<br />
        </font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><br />
        Description<br />
        <textarea name="description" cols=35 rows=6></textarea>
        <br />
       <input type="image" name="submit" src="../../pics/add-job.gif" value="Add" />
       <!--- <cfinput type="submit" name="Submit" value="Submit" />--->
        </font></td>
    </tr>
  </table>
  
  </td>
							</tr>
						</table>
  <strong><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><br />
  <br />
  </font></strong><br />
  <br />
</cfform>
</body>
</html>
