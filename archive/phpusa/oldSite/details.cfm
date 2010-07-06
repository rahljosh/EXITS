<HTML>
<HEAD>
<TITLE>DM Discoveries : Private High School Program</TITLE>
<META NAME="Keywords" CONTENT="exchange student, foreign students, student exchange, foreign exchange, foreign exchange program, academic exchange, student exchange program, high school, high school program, private high school program, private high school, American exchange, host family, host families">
<META NAME="Description" CONTENT="The Private High School Program offers students, age 13-19 years old, the opportunity to study and live in the United States. Students are able to further their own education by attending a high level academic institution while at the same time interacting with American families and friends.">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
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
<CFSET image_src="newschools/#school.schoolID#.jpg">
<CFSET image_path=ExpandPath(image_src)>
<style type="text/css">
<!--
.style5 {font-weight: bold}
.style6 {
	font-size: 14px;
	font-style: italic;
}
.style9 {font-weight: bold; font-size: 12px;}
.style11 {font-size: 16}
-->
</style>
</HEAD>
<BODY BGCOLOR=#FFFFFF>
<CFOUTPUT QUERY="school">
<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD background="images/botton_02.gif"><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td colspan="2">
                  <TABLE width="530" height="50" align="center" border="0">
    <TH COLSPAN="2"> <span class="style2 style11">#City#, #State_name.state#</span></TH>
    </TR>
                  </TABLE>
                </td>
              </tr>
              <tr>
                <td width="67%" rowspan="2">
                  <TABLE width="96%" align="right" bgcolor="FFFFFF"  border="0">
                    <TR>
                      <TH class="style1" height="20"><div align="left" class="box"><i>&nbsp;&nbsp;A B O U T<i> &nbsp; &nbsp; </i>T H E &nbsp; &nbsp; S C H O O L</i></div></TH>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TD class="style1"><p align="justify">#ext_School_About#</p></TD>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH class="style1" height="20"><div align="right" class="box"><i>&nbsp;&nbsp;L O C A T I O N</i></div></TH>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TD class="style1"><p align="justify">#ext_School_Location#</p></TD>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH class="style1" height="20"><div align="left" class="box"><i>&nbsp;&nbsp;C O U R S E S &nbsp; &nbsp; O F F E R E D</i></div></TH>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TD class="style1"><p align="justify">#ext_Courses#</p></TD>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH class="style1" height="20"><div align="right" class="box"><i>&nbsp;&nbsp;D R E S S &nbsp; &nbsp; C O D E</i></div></TH>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TD class="style1"><p align="justify">#ext_dress_code#</p></TD>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH class="style1" height="20"><div align="left" class="box"><i> &nbsp;&nbsp;H O U S I N G</i></div></TH>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TD class="style1"><p align="justify">#ext_housing#</p></TD>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TH class="style1" height="20"><div align="right" class="box"><i>&nbsp;&nbsp;A T H L E T I C S</i></div></TH>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TD class="style1"><p align="justify">#ext_athletics#</p></TD>
                    </TR>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <TR>
                      <TD height="21" colspan="2" align="center"><A href="schools.cfm" class="style3">Back</A></TD>
                    </TR>
                  </TABLE>
                </td>
                <td width="33%">
                    <div align="right">
                      <TABLE width="220" height="120"  border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="##FF7E0D">
                        <TR>
                          <TD align="center" bgcolor="##FFFFFF"><CFIF FileExists(image_path)>
      		                <div align="center"><IMG SRC="#image_src#" width="220" height="140"><br> 
	                            <CFELSE>
	                            <span class="style2"><img src="newschools/no_school.gif" width="220" height="140"></span>	
	                          </div>
                          </CFIF>
                          </TD>
                        </TR>
                      </TABLE>
                    </div>
                </td>
              </tr>
              <tr>
                <td width="33%">
                  <table width="190" border="0" align="right" bgcolor="##FF7E0D">
                    <tr>
                      <td width="210" height="60" class="style1"><div align="center" class="style1 style5">
                          <p><span class="style4 style6">QUICK FACTS</span><br>
                          </p>
                      </div></td>
                    </tr>
                    <tr>
                      <td height="20" class="style1"><div align="center"><strong>LOCATION OF SCHOOL</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style2"><span class="style4">#City#, #State_name.state#</span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center"><strong>TYPE OF SCHOOL</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style9"><span class="style4">#ext_school_type#</span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center"><strong>GRADES OFFERED</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style9"><span class="style4">#ext_School_Grade_Offer#</span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center"><strong>NEAREST MAJOR CITY</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style4"><span class="style4">#nearbigcity# (#bigcitydistance#)</span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center"><strong>RELIGIOUS AFFILIATION</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style9"><span class="style4">#ext_school_religion#</span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center"><strong>NUMBER OF STUDENTS</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style9"><span class="style4">#ext_School_Number_Students#</span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center"><strong>NUMBER OF INTL. STUDENTS</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style9"><span class="style4">#ext_school_int_students#</span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center"><strong>STUDENT: TEACHER RATIO</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style2"><span class="style4">#ext_ratio#</span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center"><strong>ARE UNIFORM REQUIRED?</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style9"><span class="style4"><cfif ext_uniform eq 1>Yes<cfelse>No</cfif></span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center" class="style1"><strong>IS ESL OFFERED?</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style9"><span class="style4"><cfif ext_esl eq 1>Yes<cfelse>No</cfif></span></div></td>
                    </tr>
                    <TR>
                      <TD class="style1">&nbsp;</TD>
                    </TR>
                    <tr>
                      <td height="20" class="style1"><div align="center" class="style1"><strong>NEAREST AIRPORT</strong></div></td>
                    </tr>
                    <tr>
                      <td><div align="center" class="style4"><span class="style4">#airport_city# (#major_air_code#)</span></div></td>
                    </tr>
                    <TR>
                      <TD>&nbsp;</TD>
                    </TR>
                  </table>
                </td>
              </tr>
            </table>              
            </td>
          </tr>
        </table></CFOUTPUT>  </TD>
	</TR>
	<TR>
		<TD>
			<IMG SRC="images/index2_06.gif" ALT="" WIDTH=770 HEIGHT=88 border="0" usemap="#Map"></TD>
	</TR>
</TABLE>


<map name="Map">
  <area shape="rect" coords="56,21,167,71" href="http://www.student-management.com" target="_blank">
</map>
</BODY>
</HTML>