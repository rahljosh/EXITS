<HTML>
<HEAD>
<TITLE>DM Discoveries : Private High School Program</TITLE>
<META NAME="Keywords" CONTENT="exchange student, foreign students, student exchange, foreign exchange, foreign exchange program, academic exchange, student exchange program, high school, high school program, private high school program, private high school, American exchange, host family, host families">
<META NAME="Description" CONTENT="The Private High School Program offers students, age 13-19 years old, the opportunity to study and live in the United States. Students are able to further their own education by attending a high level academic institution while at the same time interacting with American families and friends.">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY BGCOLOR=#FFFFFF>
<cfparam name="fname" default="Not filled in the request form">
<cfparam name="address" default="Not filled in the request form">
<cfparam name="city" default="Not filled in the request form">
<cfparam name="country" default="Not filled in the request form">
<cfparam name="phone" default="Not filled in the request form">
<cfparam name="fax" default="Not filled in the request form">
<cfparam name="email" default="">
<cfparam name="info" default="Not filled in the request form">

<cfset desc = 'The following student requested information on being an exchange student'>

<cfmail to='luke@phpusa.com' cc='craig@phpusa.com' from='php@phpusa.com' subject='Request for Info'>
#desc# from the PHP web site on #dateformat(Now())#.

Name: #form.fname#
Address: #form.address#
City: #form.city#
Country: #form.country#
Zip: #form.zip#
Phone: #form.phone#
Fax: #form.fax#
E-Mail Address: #form.email#

Comments: #form.info#

--
</cfmail>

<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD background="images/botton_02.gif"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="50%" height="29"><table width="92%"  border="0" align="right" cellpadding="0" cellspacing="0">
              <tr>
                <td><P align="justify" class="style1"><span class="style2">:: Student Form::</span></P>
                </td>
              </tr>
            </table>              </td>
            <td width="50%"><div align="right"></div></td>
          </tr>
          <tr>
            <td colspan="2">
              <div align="center">
                <table width="92%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td class="style1"><p>Request Submitted&nbsp;</p>
                      <br>
The following information was submitted to ISE: <cfoutput>
  <table width=90% align="center">
    <tr>
      <td class="style1"> Name: #form.fname#<br>
        Address: #form.address#<br>
        City: #form.city#<br>
        Country: #form.country#<br>
        Zip: #form.zip#<br>
        Phone: #form.phone#<br>
        Fax: #form.fax#<br>
        E-Mail Address: #form.email#<br>
        <br>
        Comments: #form.info# </td>
    </tr>
  </table>
</cfoutput> <br>
You will be contacted shortly.</td>
                  </tr>
                </table>
              </div>              </td>
          </tr>
        </table>  </TD>
	</TR>
	<TR>
		<TD>
			<IMG SRC="images/index2_06.gif" ALT="" WIDTH=770 HEIGHT=88 border="0" usemap="#Map"></TD>
	</TR>
</TABLE>

<map name="Map">
  <area shape="rect" coords="55,21,169,72" href="http://www.student-management.com" target="_blank">
</map>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-880717-6";
urchinTracker();
</script>
</BODY>
</HTML>