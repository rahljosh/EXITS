<cfquery name="get_students" datasource="MySql">
	SELECT     	studentid,  dob, smg_countrylist.countryname, smg_religions.religionname
	FROM       	smg_students
	INNER JOIN 	smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
	LEFT JOIN 	smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
	WHERE 	   	active = '1' 
			 	AND hostid = '0' 
				AND direct_placement = '0'
                AND companyid  < 6
	ORDER BY rand()
	LIMIT 50  
</cfquery>
<HTML>
<HEAD>
<TITLE>ISE - International Student Exchange | Private and Public High School Programs</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	background-color: #000343;
}
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style2 {color: #000066}
-->
</style><script src="menu.js"></script>
</HEAD>
<BODY LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD COLSPAN=3><script>menutop();</script></TD>
	</TR>
	<TR>
		<TD width="17" background="images/blank_02.gif">&nbsp;			</TD>
		<TD width="736" bgcolor="#FFFFFF"> <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="42%"><div align="center"><img src="images/incoming-students.gif" width="266" height="70"></div></td>
            <td width="58%"><img src="images/top6.jpg" width="400" height="70"></td>
          </tr>
          <tr>
            <td height="305" colspan="2"><table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td><span class="style1">Below are some of the students that are in the program this year.<br>
Request more information and be contacted by a representative in your region by filling out this <a href="request_info.cfm?request=host" class="style2">form</a>.
                </span><br>

</div>
<table width=70% align="center">
	<Tr><td>
		<span class="style1"><font color="red">ALL STUDENTS SHOWING ON THIS WEB PAGE HAVE BEEN ASSIGNED TO A SPECIFIC
		REGION.  ACCORDING TO OUR INTERNATIONAL AGREEMENTS, WE CANNOT TRANSFER
		STUDENTS OUT OF SPECIFIC REGIONS.  THESE STUDENTS ARE ONLY TO BE USED AS A
		SAMPLE OF ISE STUDENTS AND MIGHT NOT BE AVAILABLE IN YOUR SPECIFIC REGION.</font>
		</span></td>
	</tr>
</table>

<Table width=80% align="Center">
	<cfoutput query="get_students">
	<CFSET image_path="/var/www/html/student-management/nsmg/uploadedfiles/web-students/#get_students.studentid#.jpg">
	<tr>
		<td>
			<table>
				<tr>
					<td width="133">
						<CFIF FileExists(image_path)>
      						<span class="style1"><img src="http://www.student-management.com/nsmg/uploadedfiles/web-students/#get_students.studentid#.jpg" width="133"> 
	   					    <CFELSE>
	        				Sorry, no picture available at this time.</span>	
	    				</CFIF></td>
					<td class="style1">Age: #DateDiff('yyyy', get_students.dob, now())# <br>
					    From: #get_students.countryname#<br>
					    <br>
					    </td>
				</tr>
			</table>
			<span class="style1"><br> 
		    </span></td>
	</tr>
	</cfoutput>
</TABLE>
<div align="center" class="style1">Request more information and be contacted by a representative in your region by filling out this <a href="request_info.cfm?request=host" class="style2">form</a>.
</div></td>
              </tr>
            </table></td>
          </tr>
        </table></TD>
		<TD width="17" background="images/blank_04.gif">&nbsp;			</TD>
	</TR>
	<TR>
		<TD COLSPAN=3>
			<IMG SRC="images/blank_05.gif" ALT="" WIDTH=770 HEIGHT=34 border="0" usemap="#Map"></TD>
	</TR>
</TABLE>
<map name="Map">
  <area shape="rect" coords="522,6,653,22" href="mailto:contact@iseusa.com">
</map>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-880717-2";
urchinTracker();
</script>
</BODY>
</HTML>