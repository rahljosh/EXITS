
<cftry>

<cfquery name="check_guarantee" datasource="MySQL">
	SELECT app_region_guarantee
	FROM smg_students
	WHERE studentid = '#client.studentid#'
</cfquery>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [20] - Regional Guarantee</title>
</head>
<body <cfif check_guarantee.app_region_guarantee NEQ '0' AND check_guarantee.app_region_guarantee NEQ ''>onLoad="hideAll(); changeDiv('1','block');"</cfif>>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section4/page20print&id=4&p=20" addtoken="no">
</cfif>

<!-----Script to show certain fileds---->
<script type="text/javascript">
<!--
function changeDiv(the_div,the_change)
{
  var the_style = getStyleObject(the_div);
  if (the_style != false)
  {
    the_style.display = the_change;
  }
}
function hideAll()
{
  changeDiv("1","none");
  changeDiv("2","none");
}
function getStyleObject(objectId) {
  if (document.getElementById && document.getElementById(objectId)) {
    return document.getElementById(objectId).style;
  } else if (document.all && document.all(objectId)) {
    return document.all(objectId).style;
  } else {
    return false;
  }
}
function CheckLink()
{
  if (document.page20.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been submited.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and submit to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged()
{
  document.page20.CheckChanged.value = 1;
}
function CheckRegion() {
   var Counter = 0;
   for (i=0; i<document.page20.region_choice.length; i++){
      if (document.page20.region_choice[i].checked){
         Counter++;
      }
   }
   if ((document.page20.region_select[0].checked) && (Counter == 0)) {
		  alert("If you wish a regional choice you must select one of the 5 regions.");
		  return false; }
}
function NextPage() {
	document.page20.action = '?curdoc=section4/qr_page20&next';
	}
//-->
</SCRIPT>

<cfinclude template="../querys/get_student_info.cfm">

<!---- International Rep - EF ACCOUNTS ---->
<cfquery name="int_agent" datasource="MySQL">
	SELECT u.businessname, u.userid, u.master_account, u.master_accountid
	FROM smg_users u
	WHERE u.userid = <cfif get_student_info.branchid EQ '0'>'#get_student_info.intrep#'<cfelse>'#get_student_info.branchid#'</cfif>
</cfquery>

<Cfset doc = 'page20'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [20] - Regional Choice </h2></td>
		<!--- Do not display for Exchange Service or Canada Application --->
		<cfif CLIENT.companyID NEQ 14 AND NOT ListFind("14,15,16", get_student_info.app_indicated_program)> 
	        <td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page20print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<!--- PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
<cfif NOT ListFind("7,8,10,11", get_student_info.app_current_status) AND (DateFormat(now(), 'mm') EQ 4 OR dateFormat(now(), 'mm') EQ 5) AND (get_student_info.app_indicated_program EQ 1 OR get_student_info.app_indicated_program EQ 2)> 
	<div class="section"><br><br>
	<table width="670" cellpadding=2 cellspacing=0 align="center">
		<tr>
			<td>Regional Choices are no longer available.</td>
		</tr>
	</table><br><br>
	</div>
	<!--- FOOTER OF TABLE --->
	<cfinclude template="../footer_table.cfm">
	<cfabort>	
</cfif>
<!----Regional Choice doesn't apply to ESI---->

<cfform action="?curdoc=section4/qr_page20" method="post" name="page20" onSubmit="return CheckRegion();">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">
		

<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES --->
<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (int_agent.master_accountid EQ 10115 OR int_agent.userid EQ 10115 OR int_agent.userid EQ 8318)>
	<div class="section"><br><br>
    

	<table width="670" cellpadding=2 cellspacing=0 align="center">
		<tr>
			<td>Currently, you are unable to request a Regional Choice online. You are still able to request them, you just need to contact your
			#int_agent.businessname# Representative. Contact information is listed above.  
			</td>
		</tr>
	</table><br><br>
	</div>
	<!--- FOOTER OF TABLE --->
	<cfinclude template="../footer_table.cfm">
	<cfabort>
</cfif>


<!--- Do not display for ESI or Canada Application --->
<cfif CLIENT.companyID EQ 14 OR ListFind("14,15,16", get_student_info.app_indicated_program)> 
	
    <div class="section"><br>
        <br><Br><br>
        <h2 align=center>This page does not apply to your program.</h2>
        <Br><br><BR>
	</div>
    
<cfelse>

	<div class="section"><br>

		<!--- Check uploaded file - Upload File Button --->
        <cfinclude template="../check_uploaded_file.cfm">
        
        <table width="670" cellpadding=2 cellspacing=0 align="center">
            <tr>
                <td><h1>Student's Name: #get_student_info.firstname# #get_student_info.familylastname#</h1><br><br>
                    You can choose your regional if you so desire. Both the Semester and Academic Year students can choose a region.<br>
                    You must request a regional choice by printing and signing this page.
                </td>
            </tr>
        </table><br>
        
        <table width=670 border=0 cellpadding=2 cellspacing=0 align="center">
            <tr><td><div align="justify">
                If you would like to specify a region, select option A, 
                confirm your request of region, print this page, sign it and upload it back into the system with original signatures.<br>
                If you do not want a regional choice, select option B. 
                If option B is selected you do not need to print this page, sign it and upload it back into the system.</div><br><br></td></tr>	
            <tr>
                <td>
                    A. <input type="radio" name="region_select" value='yes' onClick="hideAll(); changeDiv('1','block'); DataChanged();" <cfif check_guarantee.app_region_guarantee NEQ '0' AND check_guarantee.app_region_guarantee NEQ ''>checked</cfif>>
                    I would like to request a specific regional choice.<br></td>
            </tr>
            <tr>
                <td>
                    B. <input type="radio" name="region_select" value='no'	onClick="hideAll(); changeDiv('2','block'); DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '0'>checked</cfif>>
                    I do not wish a regional choice.<br><br></td>
            </tr>
            <tr>
                <td>
                    <b>Note: There will be additional charges if you make a regional choice, please contact your representative for details.</b><br><br>
            
                    
                    <div id ="1" style="display:none">
                    <table width=670 border=0 cellpadding=0 cellspacing=0 align="center">
                        <tr><td colspan="3"><h1>Select your regions below, then click Next:</h1><br><br></td></tr>
                        <tr>
                            <td valign="top"><input type="radio" name="region_choice" value="1" onChange="DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '1'>checked</cfif>>Region 1 - East<br><img src="pics/region1.gif"></td>
                            <td valign="top"><input type="radio" name="region_choice" value="2" onChange="DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '2'>checked</cfif>>Region 2 - South<br><img src="pics/region2.gif"></td>
                        </tr>
                        <tr>
                            <td valign="top"><input type="radio" name="region_choice" value="3" onChange="DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '3'>checked</cfif>>Region 3 - Central<br><img src="pics/region3.gif"></td>
                            <td valign="top"><input type="radio" name="region_choice" value="4" onChange="DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '4'>checked</cfif>>Region 4 - Rocky Mountain<br><img src="pics/region4.gif"></td>
                            <td valign="top"><input type="radio" name="region_choice" value="5" onChange="DataChanged();" <cfif check_guarantee.app_region_guarantee EQ '5'>checked</cfif>>Region 5 - West<br><img src="pics/region5.gif"></td>
                        </tr>
                    </table>			
                    </div>
                </td>
            </tr>
        </table><br><br>
	
    </div>

	<!--- PAGE BUTTONS --->
    <cfinclude template="../page_buttons.cfm">

</Cfif>

</cfoutput>

</cfform>


<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</body>
</html>

</cftry>
