<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Edit Job</title>
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

<cfquery name="get_extrajobs" datasource="MySql">
 SELECT extra_jobs.id, extra_jobs.title, extra_jobs.description, extra_jobs.wage, extra_jobs.wage_type, extra_jobs.hours,
 		extra_jobs.avail_position, extra_jobs.sex, extra_jobs.low_wage
 FROM extra_jobs
 INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_jobs.hostcompanyid 
 WHERE extra_jobs.id = #url.jobid#
</cfquery> 

        
<cfif client..usertype LTE 4>
<cfform action="qr_editjob.cfm?jobid=#get_extrajobs.id#" method="post" name="form" >
 <cfoutput query="get_extrajobs">
  
                                
 <td align="right" valign="top">
                           
 <table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
							  <td bordercolor="FFFFFF">
          <table width="90%" border="0" align="left" cellpadding="3" cellspacing="0" bordercolor="##C7CFDC" bgcolor="##ffffff">
            <tr class="style1" bordercolor="##FFFFFF" bgcolor="##C2D1EF">
              <td height="16" bgcolor="##8FB6C9" colspan="4" class="style1" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF"><b>:: Edit Job</b></font></td>
            </tr>
            <tr>
              <td align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Job 
                Title </font></td>
              <td height="32" align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                <cfinput type="text" name="title" value="#title#">
              </font></td>
              <td valign="top" bordercolor="##FFFFFF" border="0"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Sex:</font>
                <input type="radio" name="sex" value="0" <cfif sex EQ 0 > checked</cfif> />
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Either </font>
                <input type="radio" name="sex" value="1" <cfif sex EQ 1 > checked</cfif> />
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Male</font>
                <input type="radio" name="sex" value="2" <cfif wage_type EQ 2 > checked</cfif> />
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Female</font></td>
            </tr>
            <tr>
              <td align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Low
                Wage</font></td>
              <td height="32" align="left" valign="top" bordercolor="##FFFFFF"><cfinput type="text" name="low_wage" value="#low_wage#"/></td>
              <td width="39%" rowspan="5" valign="top" bordercolor="##FFFFFF" border="0"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">          Description
                <br />
                <textarea name="description" cols="35" rows="6">#description#</textarea>
              </font></td>
            </tr>
            <tr>
              <td align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Wage</font></td>
              <td height="32" align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                <cfinput type="text" name="wage" value="#wage#"/>
              </font></td>
              </tr>
            <tr>
              <td align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Wage 
                Type</font></td>
              <td height="32" align="left" valign="top" bordercolor="##FFFFFF"><cfselect name="wage_type" multiple="no" >
              <option value="hourly" <cfif wage_type is 'hourly'> selected </cfif> > Hourly </option>
              <option value="salary" <cfif wage_type is 'salary'> selected </cfif>> Salary </option>
              <option value="shift" <cfif wage_type is 'shift'> selected </cfif>> Shift </option>
              <option value="weekly" <cfif wage_type is 'weekly'> selected </cfif>> Weekly </option>
              </cfselect></td>
              </tr>
            <tr>
              <td align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Hours</font></td>
              <td height="32" align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                <cfinput type="text" name="hours" value="#hours#"/>
              </font></td>
              </tr>
            <tr>
              <td width="26%" align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Positions Avail</font></td>
              <td width="35%" height="32" align="left" valign="top" bordercolor="##FFFFFF"><cfinput type="text" name="avail_position" value="#avail_position#"/>
              </font><br />              <br /></td>
        </tr>
            <tr>
              <td height="32" colspan="3" align="left" valign="top" bordercolor="##FFFFFF"><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                <cfinput type="image" src="../../pics/save.gif" name="Submit" value="Submit" />
              </font></div></td>
            </tr>
          </table>
        
          	</td>
		</tr>
	</table>
</cfoutput>

</cfform>

<cfelse>
<cfoutput query="get_extrajobs">

<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
							
<table width="69%" border="0" align="left" cellpadding="3" cellspacing="0" bordercolor="##C7CFDC" bgcolor="##ffffff">
            <tr class="style1" bordercolor="##FFFFFF" bgcolor="##C2D1EF">
              <td height="16" bgcolor="##8FB6C9" colspan="2" class="style1" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF"><b>:: Edit Job</b></font></td>
            </tr>
            <tr>
              <td height="32" align="left" valign="top" bordercolor="##FFFFFF"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Job Title: #title#<br />
              Low Wage: #low_wage#</font><br />
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Wage: #wage# </font>
<br />  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Wage Type: #wage_type#<br />
 Positions Avail: #avail_position#<br />
 Sex: #sex#
</font> <br />
<font size="2" face="Verdana, Arial, Helvetica, sans-serif"> Description:<br />
#description#
  <br />
             
              </font></td>
        </tr>
          </table>
          </td>
		</tr>
	</table>
</cfoutput>

</cfif>          
          <br />
          <br />

        
  

</body>
</html>
