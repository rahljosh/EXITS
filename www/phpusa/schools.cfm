<HTML>
<HEAD>
<TITLE>DM Discoveries : Private High School Program</TITLE>
<META NAME="Keywords" CONTENT="exchange student, foreign students, student exchange, foreign exchange, foreign exchange program, academic exchange, student exchange program, high school, high school program, private high school program, private high school, American exchange, host family, host families">
<META NAME="Description" CONTENT="The Private High School Program offers students, age 13-19 years old, the opportunity to study and live in the United States. Students are able to further their own education by attending a high level academic institution while at the same time interacting with American families and friends.">

<cfquery name="school" datasource="mysql">
	SELECT schoolid as School_ID, schoolname as School_Name, city as School_City, active as School_Active, smg_states.state as School_state
	FROM php_schools
	LEFT JOIN smg_states ON smg_states.id = php_schools.state
	WHERE active = 1 AND show_school = 1
	ORDER BY smg_states.state, city
</cfquery>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY>
<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD background="images/botton_02.gif"><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="40%" rowspan="2"><P align="justify" class="style1"><img src="images/foto4.jpg" width="240" height="183"><br>
            </P></td>
            <td width="60%" height="29">
              <div align="left">
                <table width="92%"  border="0" align="left" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><P align="justify" class="style1"><span class="style2">:: High Schools ::</span></P></td>
                  </tr>
                </table>
            </div></td>
          </tr>
          <tr>
            <td width="60%">              
              <div align="left"></div>
              <table width="92%"  border="0" align="left" cellpadding="0" cellspacing="0">
                <tr>
                  <td><P align="justify" class="style1">Please click on the city or state below to learn more about each school we work with.<SPAN 
style="mso-spacerun: yes">&nbsp; </SPAN>Please feel free to &ldquo;contact us&rdquo; with questions about any school on this list. <br>
                    <br>
                    <br>
                  </P>
                  </td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td colspan="2">              <table width="92%"  border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td>    <cfoutput>
                  <table width="100%" border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td width=300><span class="style1"><strong>City</strong></span></td>
		<td width=150><span class="style1"><strong>State</strong></span></td>
	</tr>
</table>
</cfoutput>
<table width="100%" border=0 cellpadding=4 cellspacing=0>
<CFOUTPUT QUERY="school">
 <tr bgcolor="#iif(school.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
 <td width=300 class="style6">
    <B><A HREF="details.cfm?School_id=#URLEncodedFormat(Trim(School_id))#" class="style3">#School_City#</A></B>
 </TD>
 <td width=150>
 	    <B><A HREF="details.cfm?School_id=#URLEncodedFormat(Trim(School_id))#" class="style3">#School_State#</A></B>
 </TD>
</TR>
</CFOUTPUT>
</TABLE></td>
              </tr>
            </table>            </td>
          </tr>
        </table>  </TD>
	</TR>
	<TR>
		<TD>
			<IMG SRC="images/index2_06.gif" ALT="" WIDTH=770 HEIGHT=88 border="0" usemap="#Map"></TD>
	</TR>
</TABLE>
<map name="Map">
  <area shape="rect" coords="54,20,170,73" href="http://www.student-management.com" target="_blank">
</map>
</BODY>
</HTML>