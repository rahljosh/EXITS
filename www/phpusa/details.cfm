<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>DMD &#45; Private High Schools About Us</title>
<!--- School list page --->
<CFSET list_page="schools.cfm">
<!--- Make sure FilmID was passed --->
<CFIF NOT IsDefined("URL.School_ID")>
  <!--- It wasn't, send to movie list --->
  <CFLOCATION URL="#list_page#">
</CFIF>

<!--- Get a movie from database --->
<CFQUERY NAME="school" datasource="mysql">
SELECT * FROM php_schools WHERE SchoolID=#URL.School_ID#
</CFQUERY>
<!--- Make sure valid SchoolID was passed --->
<CFIF school.RecordCount IS 0>
  <!--- It wasn't, send to School list --->
  <CFLOCATION URL="#list_page#">
</CFIF>
<cfquery name="state_name" datasource="mysql">
select state
from smg_states
where id = #school.state#
</cfquery>
<!--- Build image paths --->
<CFSET imageFullPath=APPLICATION.PATH.PHP.schools & "#school.schoolID#.jpg">
<CFSET imageRelativePath="newSchools/#school.schoolID#.jpg">
<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
<!--
.table {
	width: 350px;
}
#detailsPhoto {
	float: right;
	height: 200px;
	width: 300px;
	border: medium solid ##202554;
	margin-top: 0px;
	margin-left: 20px;
	margin-bottom: 20px;
	clear: right;
	display: block;
	position: relative;
	z-index: 10;
	top: 0px;
	background-color: #FFF;
}
td {
	height: 20px;
}
#detailsOrange {
	float: right;
	height: 200px;
	width: 350px;
	margin-top: 300px;
	margin-left: 20px;
	margin-bottom: 20px;
	clear: right;
	display: block;
	position: fixed;
	z-index: 10;
	left: 717px;
	top: 249px;
	background-color: ##FFF;
}
.right {
	background-color: ##0F0;
	width: 250px;
}
#right {
	background-color: ##0F0;
	float: left;
	width: 350px;
}
#mainContentD {
	border: medium solid #202554;
	background-image: url(images/gradientblue.png);
	background-repeat: repeat-x;
	background-position: left top;
	padding-top: 10;
	padding-right: 20px;
	padding-bottom: 0;
	padding-left: 20px;
	min-height: 1800px;
	background-color: #FFF;
}
-->
</style>

<link href="css/phpusa.css" rel="stylesheet" type="text/css" />
</head>
<CFOUTPUT QUERY="school">
<body class="oneColFixCtrHdr">
<div id="container">
  <cfinclude template="header.cfm">
  <div class="spacer"></div>
  <div id="mainContent">
  <div class="spacerlg"></div>
  <div id="mainContentPad">
<p class="headline">#City#, #State_name.state#</p>
  <div id="detailsPhoto">
					<CFIF FileExists(imageFullPath)>
	                  <IMG SRC="#imageRelativePath#" width="220" height="140"><br>
	                  <cfelse>
	                  <span class="menu11"><img src="images/no_school.gif" width="220" height="138"></span>	
                          </CFIF>
<table width="220" border="0" align="left" bgcolor="##FEE6A8" cellpadding="0" cellspacing="0"><CFOUTPUT>
                    <tr>
                      <td>
                        <p align="center" class="menu1">QUICK FACTS<br></p>
                      </td>
      </tr>
                    <tr>
                      <td><p align="center" class="menu1"><strong>LOCATION OF SCHOOL</strong></p></td>
                    </tr>
                    <tr>
                      <td><p align="center" class="menu1">#City#, #State_name.state#</p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <tr>
                      <td><p align="center" class="menu1"><strong>TYPE OF SCHOOL</strong></td>
                    </tr>
                    <tr>
                      <td><p align="center" class="menu1">#ext_school_type#</p></td>
                    </tr>
                    <TR>
                      <TD class="menu1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td><p align="center" class="menu1"><strong>GRADES OFFERED</strong></p></td>
            </tr>
                    <tr>
                      <td><p align="center" class="menu1">#ext_School_Grade_Offer#</p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <tr>
                      <td><p align="center" class="menu1"><strong>NEAREST MAJOR CITY</strong></p></td>
                    </tr>
                    <tr>
                      <td><p align="center" class="menu1">#nearbigcity# (#bigcitydistance#)</p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <tr>
                      <td><p align="center"  class="menu1"><strong>RELIGIOUS AFFILIATION</strong></p></td>
                    </tr>
                    <tr>
                      <td><p align="center" class="menu1">#ext_school_religion#</p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <tr>
                      <td><p align="center" class="menu1"><strong>NUMBER OF STUDENTS</strong></p></td>
                    </tr>
                    <tr>
                      <td><p align="center" class="menu1">#ext_School_Number_Students#</p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <tr>
                      <td><p align="center" class="menu1"><strong>NUMBER OF INTL. STUDENTS</strong></p></td>
                    </tr>
                    <tr>
                      <td><p align="center" class="menu1">#ext_school_int_students#</p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <tr>
                      <td><p align="center" class="menu1"><strong>STUDENT: TEACHER RATIO</strong></p></td>
                    </tr>
                    <tr>
                      <td><p align="center" class="menu1">#ext_ratio#</p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <tr>
                      <td><p align="center"  class="menu1"><strong>ARE UNIFORM REQUIRED?</strong></p></td>
                    </tr>
                    <tr>
                      <td><p align="center" class="menu1"><cfif ext_uniform eq 1>Yes<cfelse>No</cfif></p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <tr>
                      <td><p align="center" class="menu1"><strong>IS ESL OFFERED?</strong></p></td>
                    </tr>
                    <tr>
                      <td><p align="center" class="menu1"><cfif ext_esl eq 1>Yes<cfelse>No</cfif></p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <tr>
                      <td> <p align="center" class="menu1"><strong>NEAREST AIRPORT</strong></p></td>
                    </tr>
                    <tr>
                      <td><p align="center" p class="menu1">#airport_city# (#major_air_code#)</p></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD> 
                    </TR></cfoutput>
	</table>
    </div>
    <div id="right">
                        
   <TABLE width="346" align="left" bgcolor="FFFFFF"  border="0" cellpadding="0" cellspacing="0"><cfoutput> 
<TR>
                      <TH><p align="left" class="menu1"><i>&nbsp;&nbsp;A B O U T<i> &nbsp; &nbsp; </i>T H E &nbsp; &nbsp; S C H O O L</i></p></TH>
      </TR>
                    <TR>
                      <TD ><p align="justify" class="menu1">#ext_School_About#</p></TD>
                    </TR>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH><p align="left" class="menu1"><i>&nbsp;&nbsp;L O C A T I O N</i></p></TH>
                    </TR>
                    <TR>
                      <TD><p align="justify" class="menu1">#ext_School_Location#</p></TD>
                    </TR>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH><p align="left" class="menu1"><i>&nbsp;&nbsp;C O U R S E S &nbsp; &nbsp; O F F E R E D</i></p></TH>
                    </TR>
                    <TR>
                      <TD><p align="justify" class="menu1">#ext_Courses#</p></TD>
                    </TR>
                    <TR>
                      <TD >&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH><p align="left" class="menu1"><i>&nbsp;&nbsp;D R E S S &nbsp; &nbsp; C O D E</i></p></TH>
                    </TR>
                    <TR>
                      <TD><p align="justify" class="menu1">#ext_dress_code#</p></TD>
                    </TR>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH><p align="left" class="menu1"><i> &nbsp;&nbsp;H O U S I N G</i></p></TH>
                    </TR>
                    <TR>
                      <TD><p align="justify" class="menu1">#ext_housing#</p></TD>
                    </TR>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH ><p align="justify" class="menu1"><i>&nbsp;&nbsp;A T H L E T I C S</i></p></TH>
                    </TR>
                    <TR>
                      <TD><p align="justify" class="menu1">#ext_athletics#</p></TD>
                    </TR>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                    <TR>
                      <TD height="21" colspan="2" align="center"><A href="schools.cfm" class="menu">Back</A></TD>
                    </TR>
					<TR>
                      <TD>&nbsp;</TD>
                    </TR></cfoutput>
    </TABLE>
  </div>
  <p>&nbsp;</p>
        <div class="clearfix"></div> 
        <!-- end mainContentPad --></div>
        <div class="bottomGradient"></div>       
  <!-- end mainContent --></div></cfoutput>
  <div class="spacersm"></div>
<cfinclude template="footer.cfm">
  <div class="spacersm"></div>
<!-- end container --></div>
</body>
</html>
