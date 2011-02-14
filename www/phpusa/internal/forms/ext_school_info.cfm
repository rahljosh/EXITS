<cfoutput>
<table width = 90% border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor=##ffffff>
<tr>
	<td colspan=2><div align="center">Show school on external site? <input type="radio" name="show_school" value="1" <cfif get_school.show_school eq 1>checked</cfif>>Yes <input type="radio" name="show_school" value="0" <cfif get_school.show_school eq 0>checked</cfif>>No </div></td>
</tr>
<tr>
<td align="left" width="45%" valign="top"  class="box">
	
<table border=0 cellpadding=6 cellspacing=0 align="left" width=100%>
			<tr bgcolor="##0078A9">
				<td><font color="white">Location of School</td>
			</tr>
			<tr>
				<td>#get_school.city#, #get_school.statename#</td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Type of School</td>
			</tr>
			<tr>
				<td><input type="text" size="40" value="#get_school.ext_school_type#" name="ext_school_type"></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Grades Offered</td>
			</tr>
			<tr>
				<td><input type="text" size="40" value="#get_school.ext_school_grade_offer#" name="ext_school_grade_offer"></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Nearest Major City</td>
			</tr>
			<tr>
				<td><input type="text" size="40" value="#get_school.ext_major_city#" name="ext_major_city"></td>
			</tr>
						<tr bgcolor="##0078A9">
				<td><font color="white">Religious Affiliation</td>
			</tr>
			<tr>
				<td><input type="text" size="40" value="#get_school.ext_school_religion#" name="ext_school_religion"></td>
			</tr>
					<tr bgcolor="##0078A9">
				<td><font color="white">Number of Students</td>
			</tr>
			<tr>
				<td><input type="text" size="40" value="#get_school.ext_school_number_students#" name="ext_school_number_students"></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Number of Intl. Students</td>
			</tr>
			<tr>
				<td><input type="text" size="40" value="#get_school.ext_school_int_students#" name="ext_school_int_students"></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Student:Teacher Ratio </td>
			</tr>
			<tr>
				<td><input type="text" size="40" value="#get_school.ext_ratio#" name="ext_ratio"></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Uniforms Required? </td>
			</tr>
			<tr>
				<td><input type="radio" name="ext_uniform" value=1 <cfif #get_school.ext_uniform# eq 1>checked</cfif>>Yes <input type="radio" name="ext_uniform" value=0 <cfif #get_school.ext_uniform# eq 0>checked</cfif>>No </td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Is ESL offered?</td>
			</tr>
			<tr>
				<td><input type="radio" name="ext_esl" value=1 <cfif get_school.ext_esl eq 1>checked</cfif>>Yes <input type="radio" name="ext_esl" value=0 <cfif #get_school.ext_esl# eq 0>checked</cfif>>No </td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Nearest Airport</td>
			</tr>
			<tr>
				<td>#get_school.airport_city#, (#get_school.major_air_code#)</td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Picture</td>
			</tr>
			<tr>
				<td align="center">
                    <cfif FileExists(APPLICATION.PATH.PHP.schools & '#get_school.schoolid#.jpg')>
                        <img src="../newschools/#get_school.schoolid#.jpg" width="220" height="140" border="0"><br>
                        <a class=nav_bar href="" onClick="javascript: win=window.open('forms/uploadPicture.cfm?schoolID=#url.sc#', 'Settings', 'height=300, width=500, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Change Picture</a>
                    <cfelse>
                        <a class=nav_bar href="" onClick="javascript: win=window.open('forms/uploadPicture.cfm?schoolID=#url.sc#', 'Settings', 'height=300, width=500, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
                        	<img src="../newschools/no_image_school.gif" border="0">
                        </a>
                    </cfif>
				</td>
			</tr>
</table>

	</td>
	<td valign="top"  class="box">
			<table width=100%>
			<tr bgcolor="##0078A9">
				<td><font color="white">About the School</td>
			</tr>
			<tr>
				<td><textarea cols=48 rows="5" name="ext_school_about">#get_school.ext_school_about#</textarea></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Location</td>
			</tr>
			<tr>
				<td><textarea cols=48 rows="5" name="ext_school_location">#get_school.ext_school_location#</textarea></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Courses Offered</td>
			</tr>
			<tr>
				<td><textarea cols=48 rows="5" name="ext_courses">#get_school.ext_courses#</textarea></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Dress Code</td>
			</tr>
			<tr>
				<td><textarea cols=48 rows="5" name="ext_dress_code">#get_school.ext_dress_code#</textarea></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Housing</td>
			</tr>
			<tr>
				<td><textarea cols=48 rows="5" name="ext_housing">#get_school.ext_housing#</textarea></td>
			</tr>
			<tr bgcolor="##0078A9">
				<td><font color="white">Athletics</td>
			</tr>
			<tr>
				<td><textarea cols=48 rows="5" name="ext_athletics">#get_school.ext_athletics#</textarea></td>
			</tr>
		</table>
		
	</td>
</tr>	
</table>
</cfoutput>