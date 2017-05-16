<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [07] - School Information</title>
</head>
<BODY>

<cftry>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section2/page7print&id=2&p=7" addtoken="no">
</cfif>

<script type="text/javascript">

	function CheckLink() {
  		if (document.page7.CheckChanged.value != 0) {
    		if (confirm("You have made changes on this page that have not been submited.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and submit to save your changes."))
      			return true;
    		else
      			return false;
  		}
	}

	function DataChanged() {
		document.page7.CheckChanged.value = 1;
	}

	function NextPage() {
		document.page7.action = '?curdoc=section2/qr_page7&next';
	}

	function change(href) {
		window.location.href = href;
	}

</script>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page07'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [07] - School Information</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section2/page7print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section2/qr_page7" method="post" name="page7">

<cfoutput query="get_student_info">

<cfinput type="hidden" name="studentid" value="#studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<div class="section"><br>

<!--- Check uploaded file - Upload File Button --->
<cfinclude template="../check_uploaded_file.cfm">

<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td align="center"><b>SCHOOL INFORMATION</b></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td width="120"><em>School's Name</em></td>
		<td><cfinput type="text" name="app_school_name" size="45" value="#app_school_name#" onchange="DataChanged();"></td></tr>
	<tr><td><em>Address</em></td>
		<td><cfinput type="text" name="app_school_add" size="45" value="#app_school_add#" onchange="DataChanged();"></td></tr>	
	<tr><td><em>Telephone</em></td>
		<td><cfinput type="text" name="app_school_phone" size="45" value="#app_school_phone#" onchange="DataChanged();"></td></tr>
	<tr><td><em>Public or Private</em></td>
		<td>
			<input type="radio" name="app_school_type" id="app_school_typePublic" value="Public" onchange="DataChanged();" <cfif app_school_type EQ 'Public'> checked="yes" </cfif>> <label for="app_school_typePublic">Public</label>
			<input type="radio" name="app_school_type" id="app_school_typePrivate" value="Private" onchange="DataChanged();" <cfif app_school_type EQ 'Private'> checked="yes" </cfif>> <label for="app_school_typePrivate">Private</label>
        </td>
	</tr>
	<tr><td><em>Administrator's Name</em></td>
		<td><cfinput type="text" name="app_school_person" size="45" value="#app_school_person#" onchange="DataChanged();"></td></tr>
</table>

<hr class="bar" style="margin-top:10px; margin-bottom:10px;"></hr>

<table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr><td colspan="4" align="center"><b>GRADE CONVERSION CHART</b></td></tr>
	<tr><td colspan="4" align="center"><em>Please explain your grading system.</em></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="130"><em>American Grades</em></td>
		<td width="100">&nbsp;</td>
		<td width="180"><em>Country Equivalent</em></td>
		<td width="260"><em>Comments or explanations</em></td>
	</tr>		
	<tr>
		<td>Superior</td>
		<td>A+</td>
		<td><cfinput type="text" name="app_grade_1" size="20" value="#app_grade_1#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_1_com" size="35" value="#app_grade_1_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Excellent</td>
		<td>A</td>
		<td><cfinput type="text" name="app_grade_2" size="20" value="#app_grade_2#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_2_com" size="35" value="#app_grade_2_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Very Good</td>
		<td>A- or B+</td>
		<td><cfinput type="text" name="app_grade_3" size="20" value="#app_grade_3#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_3_com" size="35" value="#app_grade_3_com#" maxlength="50" onchange="DataChanged();"></td>		
	</tr>
	<tr>
		<td>Good</td>
		<td>B or B-</td>
		<td><cfinput type="text" name="app_grade_4" size="20" value="#app_grade_4#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_4_com" size="35" value="#app_grade_4_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Average</td>
		<td>C</td>
		<td><cfinput type="text" name="app_grade_5" size="20" value="#app_grade_5#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_5_com" size="35" value="#app_grade_5_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Sufficient</td>
		<td>C-</td>
		<td><cfinput type="text" name="app_grade_6" size="20" value="#app_grade_6#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_6_com" size="35" value="#app_grade_6_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Poor</td>
		<td>D</td>
		<td><cfinput type="text" name="app_grade_7" size="20" value="#app_grade_7#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_7_com" size="35" value="#app_grade_7_com#" maxlength="50" onchange="DataChanged();"></td>
	</tr>
	<tr>
		<td>Fail</td>
		<td>F</td>
		<td><cfinput type="text" name="app_grade_8" size="20" value="#app_grade_8#" maxlength="20" onchange="DataChanged();"></td>
		<td><cfinput type="text" name="app_grade_8_com" size="35" value="#app_grade_8_com#" maxlength="50" conchange="DataChanged();"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>                

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
        <cfif ListFind("14,15,16", get_student_info.app_indicated_program)>     
        	<!--- Canada Application --->       	
	        <td width="65%"><em>What grade level will student have completed upon arrival in Canada?</em></td>
		<cfelse>
        	<!--- USA - Public High School --->
	        <td width="65%"><em>What grade level will student have completed upon arrival in the USA?</em></td>
        </cfif>	
		<td>
			<!---<cfif companyID EQ 6 OR companyID EQ 14>--->
			<input type="radio" name="grades" id="grade8" value="8" onchange="DataChanged();" style="margin:2px;" <cfif grades EQ 8> checked="yes" </cfif>> <label for="grade8">8<sup>th</sup></label>
			<!---</cfif>--->
        	<input type="radio" name="grades" id="grade9" value="9" onchange="DataChanged();" style="margin:2px;" <cfif grades EQ 9> checked="yes" </cfif>> <label for="grade9">9<sup>th</sup></label>
            <input type="radio" name="grades" id="grade10" value="10" onchange="DataChanged();" style="margin:2px;" <cfif grades EQ 10> checked="yes" </cfif>> <label for="grade10">10<sup>th</sup></label>
            <input type="radio" name="grades" id="grade11" value="11" onchange="DataChanged();" style="margin:2px;" <cfif grades EQ 11> checked="yes" </cfif>> <label for="grade11">11<sup>th</sup></label>
            <input type="radio" name="grades" id="grade12" value="12" onchange="DataChanged();" style="margin:2px;" <cfif grades EQ 12> checked="yes" </cfif>> <label for="grade12">12<sup>th</sup></label>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td><em>Upon arrival, will the student have completed secondary school in his/her home country?</em></td>
		<td>
			<input type="radio" name="app_completed_school" id="app_completed_schoolYes" value="Yes" onchange="DataChanged();" <cfif app_completed_school EQ 'Yes'> checked="yes" </cfif>> <label for="app_completed_schoolYes">Yes</label>
			<input type="radio" name="app_completed_school" id="app_completed_schoolNo" value="No" onchange="DataChanged();" <cfif app_completed_school EQ 'No'> checked="yes" </cfif>> <label for="app_completed_schoolNo">No</label>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr>
		<td><em>Has the student received a diploma in his/her home country?</em></td>
		<td>
			<input type="radio" name="gradAtHome" id="gradAtHomeYes" value="Yes" onchange="DataChanged();" <cfif gradAtHome EQ 'Yes'> checked="yes" </cfif>> <label for="gradAtHomeYes">Yes</label>
			<input type="radio" name="gradAtHome" id="gradAtHomeNo" value="No" onchange="DataChanged();" <cfif gradAtHome EQ 'No'> checked="yes" </cfif>> <label for="gradAtHomeNo">No</label>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
    <tr>
		<td><em>Does the student need to have his/her transcript convalidated?</em></td>
		<td>
			<input type="radio" name="convalidation_needed" id="convalidation_neededYes" value="Yes" onchange="DataChanged();" <cfif convalidation_needed EQ 'Yes'> checked="yes" </cfif>> <label for="convalidation_neededYes">Yes</label>
			<input type="radio" name="convalidation_needed" id="convalidation_neededNo" value="No" onchange="DataChanged();" <cfif convalidation_needed EQ 'No'> checked="yes" </cfif>> <label for="convalidation_neededNo">No</label>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td width="48%"><div align="justify">
				<u>Enrollment in the exchange program is primarily for a cultural exchange.
				A high school diploma or graduation is not guaranteed to any student.</u>
				Credit for academic achievements earned while abroad shall be determined solely 
				by the student's native school upon the completion of the program. While the
				program cannot guarantee specific courses will be available for this student, 
				please list any	courses you recommend this student be enrolled in while partipating
				in the exchange program, especially for those who need to convalidate their grades.</div>
		</td>
		<td width="4%">&nbsp;</td>
		<td width="48%" valign="top"><textarea name="app_extra_courses" onchange="DataChanged();" cols="43" rows="9">#app_extra_courses#</textarea></td>
	</tr>
</table><br>
</div>
	
<!--- PAGE BUTTONS --->
<cfinclude template="../page_buttons.cfm">

</cfoutput>
</cfform>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>