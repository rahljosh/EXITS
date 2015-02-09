<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [18] - Private School</title>
</head>
<body>

<cftry>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section4/page18print&id=4&p=18" addtoken="no">
</cfif>

<script type="text/javascript">
<!--
function CheckLink()
{
  if (document.page18.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been saved.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page18.CheckChanged.value = 1;
}
function NextPage() {
	document.page18.action = '?curdoc=section4/qr_page18&next';
	}
function CheckPrivate() {
   if ((document.page18.privateschool[1].checked) && (document.page18.tuitionprivateschool.value == 0)) {
		  alert("You must select one or the three tuition range.");
		  document.page18.tuitionprivateschool.focus();
		  return false; }
}
//-->
</script>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="private_schools" datasource="#APPLICATION.DSN#">
	SELECT privateschoolid, privateschoolprice, type
	FROM smg_private_schools
	ORDER BY privateschoolprice
</cfquery>

<Cfset doc = 'page18'>

<cfswitch expression="#get_student_info.sex#">

	<cfcase value="male">
		<cfset sd='son'>
        <cfset hs='he'>
        <cfset hh='his'>
    </cfcase>
    
    <cfcase value="female">
		<cfset sd='daughter'>
        <cfset hs='she'>
        <cfset hh='her'>
    </cfcase>
    
    <cfdefaultcase>
		<cfset sd='son/daughter'>
        <cfset hs='he/she'>
        <cfset hh='his/her'>
    </cfdefaultcase>

</cfswitch>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [18] - Private School</h2></td>
		<!--- Do not display for Exchange Service or Canada Application --->
		<cfif CLIENT.companyID NEQ 14 AND NOT ListFind("13,14,15", get_student_info.app_indicated_program)> 
	        <td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page18print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<!--- Do not display for ESI, Canada, or DASH Application --->
<cfif CLIENT.companyID EQ 14 OR ListFind("13,14,15", get_student_info.app_indicated_program)> 

	<div class="section"><br>
        <br><Br><br>
        <h2 align=center>This page does not apply to your program.</h2>
        <Br><br><BR>
	</div>
    
<cfelse>

	<div class="section"><br>
    
        <cfform name="page18" action="?curdoc=section4/qr_page18" method="post" onSubmit="return CheckPrivate();">
        
        <cfoutput query="get_student_info">
        
        <cfinput type="hidden" name="studentid" value="#studentid#">
        <cfinput type="hidden" name="CheckChanged" value="0">
        
        <!--- Check uploaded file - Upload File Button --->
        <cfinclude template="../check_uploaded_file.cfm">
        
        <table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
            <tr>
                <td>
                    <h1>Student's Name: #get_student_info.firstname# #get_student_info.familylastname#</h1>
                    <div align="justify"><cfinclude template="page18text.cfm"></div>
                </td>
            </tr>
        </table><br>
        
        
        <table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
            <tr>
                <td>
                    <table>
                        <tr><td><input type="radio" name="privateschool" value='0' onClick="DataChanged();" <cfif privateschool  EQ '0'>checked</cfif>></td>
                            <td><em>Do not consider my child for J-1 Private Schools</em></td></tr>
                    </table>
                </td>
            </tr>
            <tr><td align="center"><br><h2>- OR -</h2><br></td></tr>
            <tr>
                <td>
                    <table>
                        <tr><td><input type="radio" name="privateschool" value='1' onClick="DataChanged();" <cfif privateschool  GTE '1' AND privateschool LTE '3'>checked</cfif>></td>
                            <td><em>Consider my child for any school in the following tuition range: (select one)</em></td></tr>
                        <tr><td colspan="2">
                            <select name="tuitionprivateschool" onClick="DataChanged();">
                            <option value="0"></option>
                            <cfloop query="private_schools">
                            <option value="#privateschoolid#" <cfif get_student_info.privateschool EQ privateschoolid>selected</cfif>>#privateschoolprice#</option>
                            </cfloop>
                            </select>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        <!---	<tr><td align="center"><br><h2>- OR -</h2><br></td></tr>
            <tr>
                <td>
                    <table>
                        <tr><td><input type="radio" name="privateschool" value='5' onClick="DataChanged();" <cfif privateschool  GT 4>checked</cfif>></td>
                            <td><em>Consider my child for the following 3 choices from the J-1 Private Schools List:</em></td></tr>
                        <tr><td colspan="2">______________________________________________</td></tr>
                        <tr><td colspan="2">______________________________________________</td></tr>
                        <tr><td colspan="2">______________________________________________</td></tr>
                    </table>
                </td>
            </tr>---->
        </table><br><br><br>
        
    </div>
    
    <!--- PAGE BUTTONS --->
    <cfinclude template="../page_buttons.cfm">
    
    </cfoutput>
    
    </cfform>
    
</cfif>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>