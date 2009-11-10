<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title></title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style9 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; }
.style12 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size:36px;
	font-weight: bold;
}
.style13 {
	font-size: 16px;
	font-weight: bold;
}
.style14 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-weight: bold;
}
.formm {
	height: auto;
	width: auto;
	border-top-style: none;
	border-right-style: none;
	border-bottom-style: none;
	border-left-style: none;
	border-top-color: #FFFFFF;
	border-right-color: #FFFFFF;
	border-bottom-color: #FFFFFF;
	border-left-color: #FFFFFF;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #000000;
}
-->
</style>
</head>

<cfquery name="get_user" datasource="MySql">
	SELECT firstname, lastname
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>	

<cfquery name="hostcompanies" datasource="MySql">
	SELECT name, fax, phone
	FROM extra_hostcompany
	WHERE hostcompanyid = #url.hostcompanyid#    
</cfquery>

<body>
<table width="700" border="0" align="center" cellpadding="3" cellspacing="0" bgcolor="#ffffff">
  <tr class="style1" bordercolor="#FFFFFF" bgcolor="#C2D1EF">
    <td width="195" height="16" bordercolor="#FFFFFF" bgcolor="#FFFFFF" class="style1" ><div align="center"><img src="../../pics/ISE-Logo.gif" width="87" height="80" /></div></td>
    <td width="423" height="16" bordercolor="#FFFFFF" bgcolor="#FFFFFF" class="style1" ><span class="style9"><strong>International Student Exchange </strong><br />
      119 Cooper Street<br />
    Babylon, NY 11702 </span></td>
    <td width="256" height="16" bordercolor="#FFFFFF" bgcolor="#FFFFFF" class="style9" >Phone: 631-893-4540 <br />
      Toll Free: 1-800-766-4656<br />
    Fax: 631-893-4550 </td>
  </tr>
  <tr>
    <td height="16" colspan="3" align="left" valign="top" bordercolor="#FFFFFF"><hr align="center" width="97%" color="#999999" /></td>
  </tr>
  <tr>
    <td height="16" colspan="3" align="left" valign="top" bordercolor="#FFFFFF" class="style1"><div align="center"><span class="style6"><br />
      <br />
          <span class="style12"><br />
        F A X</span></span><br />
          <br />
          <br />
          <br />
    <br />
    </div></td>
  </tr>
  <tr>
    <td height="32" colspan="3" align="left" valign="top" bordercolor="#FFFFFF">
	<cfoutput>
	
	<table width="80%" border="0" align="center" cellpadding="5" cellspacing="0">
      <tr>
        <td width="312" class="style9"><b>To:</b> #hostcompanies.name#</td>
        <td width="303" class="style9"><b>From:</b> #get_user.firstname# #get_user.lastname# </td>
      </tr>
      <tr>
        <td class="style9"><b>Fax:</b> #hostcompanies.fax#</td>
        <td class="style9"><b>Date:</b> #DateFormat(now(), "mmmm d, yyyy")#</td>
      </tr>
      <tr>
        <td class="style9"><b>Phone:</b> #hostcompanies.phone#</td>
        <td class="style9"><b>Pages:</b> <input name="textfield" type="text" class="formm" /></td>
      </tr>
      <tr>
        <td colspan="2" class="style9"><b>Re: 
          <input name="textfield2" type="text" class="formm" size="80" />
        </b></td>
        </tr>
    </table>
	</cfoutput>
    <p align="center" class="title1"><br />
      <span class="style14">M E S S A G E</span></p>
    <p align="center" class="title1 style7 style13"><br />
      <b>
      <textarea name="textfield22" cols="100" rows="23" class="formm"></textarea>
    </b></p>
    <p align="center" class="title1">&nbsp;</p></td>
  </tr>
</table>
</body>
</html>
