<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [08] - Transcript of Grades</title>
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
	<cflocation url="?curdoc=section2/page8print&id=2&p=8" addtoken="no">
</cfif>

<script type="text/javascript">

	function CheckLink() {
		if (document.page8.CheckChanged.value != 0) {
			if (confirm("You have made changes on this page that have not been saved.\n\
						These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and click on save to save your changes."))
				return true;
			else
				return false;
		}
	}
	
	function DataChanged() {
  		document.page8.CheckChanged.value = 1;
	}

	function NextPage() {
		document.page8.action = '?curdoc=section2/qr_page8&next';
	}

</script>

<cfinclude template="../querys/get_student_info.cfm">

<!--- querys to get 9, 10, 11 and 12th years and grades --->
<cfloop from="9" to="12" index="i">
	<cfquery name="get_#i#class" datasource="#APPLICATION.DSN#">
		SELECT yearid, studentid, beg_year, end_year, class_year
		FROM smg_student_app_school_year 
		WHERE studentid = <cfqueryparam value="#get_student_info.studentid#" cfsqltype="cf_sql_integer">
			  AND class_year = '#i#th'
		ORDER BY class_year
	</cfquery>
	<cfquery name="get_#i#grades" datasource="#APPLICATION.DSN#">
		SELECT gradesid, yearid, class_name, hours, grade
		FROM smg_student_app_grades
		WHERE yearid = '#Evaluate("get_" & i & "class.yearid")#'
		ORDER BY yearid
	</cfquery>
</cfloop>

<cfset doc = 'page08'>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [08] - Transcript of Grades</h2></td>
		<td align="right" class="tablecenter">
        	<a href="" onClick="javascript: win=window.open('section2/page8print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes');
            win.opener=self; return false;">
            	<img src="pics/printhispage.gif" border="0" alt="Click here to print this page" />
         	</a>
            &nbsp; &nbsp;
      	</td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfform action="?curdoc=section2/qr_page8" method="post" name="page8">

	<cfoutput query="get_student_info">

        <cfinput type="hidden" name="studentid" value="#studentid#">
        <cfinput type="hidden" name="CheckChanged" value="0">

		<div class="section">
        	<br>
			<!--- Check uploaded file - Upload File Button --->
            <cfinclude template="../check_uploaded_file.cfm">
    
            <table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
                <tr>
                    <td align="center"><b>TRANSCRIPT OF GRADES</b></td>
                </tr>
               
               
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td align="center">
                        <div align="justify">
                            In English, type names, hours per week, and the final <b>(American-equivalent)</b> grade for the classes you attended
                            in the 9<sup>th</sup>, 10<sup>th</sup>, 11<sup>th</sup> and 12<sup>th</sup> grades. Indicate the grade in which you 
                            are presently enrolled. In addition to this translation, please also attach a copy of each year's transcript of grades 
                            issued by your school.
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
            </table>
    
            <table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
                <tr>
                    <td width="48%" valign="top">
                        <!--- 9th grade --->
                        <table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
                            <cfif get_9class.recordcount EQ 0>  <!--- year has not been entered --->
                                <tr>
                                    <td colspan="3">
                                        <em>
                                            &nbsp; School Year &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="new9_beg_year" 
                                                size="6" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$"
                                                range="1901,2155"
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="9th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) &nbsp; to &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="new9_end_year" 
                                                size="6" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$"
                                                range="1901,2155" 
                                                onchange="DataChanged();"  
                                                validateat="onsubmit,onserver" 
                                                message="9th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy)
                                        </em>
                                    </td>
                                </tr>
                                <cfinput type="hidden" name="new_9class" value="9th">
                            <cfelse>
                                <tr>
                                    <td colspan="3">
                                        <em>
                                            &nbsp; School Year &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="upd9_beg_year" 
                                                size="6" 
                                                value="#DateFormat(get_9class.beg_year, 'yyyy')#" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="9th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) &nbsp; to &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="upd9_end_year" 
                                                size="6" 
                                                value="#DateFormat(get_9class.end_year, 'yyyy')#" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="9th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy)
                                        </em>
                                    </td>
                                </tr>
                                <cfinput type="hidden" name="upd_9class" value="9th">
                                <cfinput type="hidden" name="upd_9yearid" value="#get_9class.yearid#">			
                            </cfif>
                            <tr>
                                <td align="center">
                                    <em>9<sup>th</sup> year classes</em>
                                </td>
                                <td align="center">
                                    <em>Hours <br>per week</em>
                                </td>
                                <td align="center">
                                    <em>Final Grade<br> (Am. Equivalent)</em>
                                </td>
                            </tr>
                            <cfif get_9class.recordcount NEQ 0>
                                <cfinput type="hidden" name="upd_9class_count" value='#get_9grades.recordcount#'>		
                                <cfloop query="get_9grades">
                                    <tr>
                                        <cfinput type="hidden" name="upd_9class_gradesid#currentrow#" value="#gradesid#">
                                        <td align="center">
                                            <cfinput 
                                                type="text" 
                                                name="upd_9class_name#currentrow#" 
                                                value="#class_name#" 
                                                size="24" 
                                                onchange="DataChanged();">
                                        </td>
                                        <td align="center">
                                            <cfinput 
                                                type="text" 
                                                name="upd_9class_hour#currentrow#" 
                                                value="#hours#" 
                                                size="6" 
                                                maxlength="3" 
                                                validate="range" 
                                                message="Total of hours per week for #class_name# must be a number." 
                                                onchange="DataChanged();">
                                        </td>
                                        <td align="center">
                                            <cfinput 
                                                type="text" 
                                                name="upd_9class_grade#currentrow#" 
                                                value="#grade#" 
                                                size="12" 
                                                maxlength="4" 
                                                onchange="DataChanged();javascript:this.value=this.value.toUpperCase();">
                                        </td>
                                    </tr>			
                                </cfloop>
                            </cfif>			
                            <!--- NEW CLASSES UP TO 14 --->
                            <cfset new9classes = 14 - get_9grades.recordcount>
                            <cfinput type="hidden" name="new_9class_count" value="#new9classes#">
                            <cfinput type="hidden" name="new_9class_yearid" value="#get_9class.yearid#">
                            <cfloop from="1" to="#new9classes#" index="i">
                                <tr>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="new_9class_name#i#" 
                                            size="24" 
                                            onchange="DataChanged();">
                                    </td>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="new_9class_hour#i#" 
                                            size="6" 
                                            maxlength="3" 
                                            validate="range" 
                                            message="9th class field #i# - Total of hours per week must be a number." 
                                            onchange="DataChanged();">
                                    </td>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="new_9class_grade#i#" 
                                            size="12" 
                                            maxlength="4" 
                                            onchange="DataChanged();javascript:this.value=this.value.toUpperCase();">
                                    </td>
                                </tr>
                            </cfloop>		
                        </table>	
                    </td>
                    <td width="4%">&nbsp;</td>
                    <td width="48%" valign="top" align="left">
                        <!--- 10th grade --->
                        <table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
                            <cfif get_10class.recordcount EQ 0>  <!--- year has not been entered --->
                                <tr>
                                    <td colspan="3">
                                        <em>
                                            &nbsp; School Year &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="new10_beg_year" 
                                                size="6" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="10th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) &nbsp; to &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="new10_end_year" 
                                                size="6" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="10th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy)
                                        </em>
                                    </td>
                                </tr>
                                <cfinput type="hidden" name="new_10class" value="10th">
                            <cfelse>
                                <tr>
                                    <td colspan="3">
                                        <em>
                                            &nbsp; School Year &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="upd10_beg_year" 
                                                size="6" 
                                                value="#DateFormat(get_10class.beg_year, 'yyyy')#" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="10th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) &nbsp; to &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="upd10_end_year" 
                                                size="6" 
                                                value="#DateFormat(get_10class.end_year, 'yyyy')#" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="10th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy)
                                        </em>
                                    </td>
                                </tr>
                                <cfinput type="hidden" name="upd_10class" value="10th">
                                <cfinput type="hidden" name="upd_10yearid" value="#get_10class.yearid#">			
                            </cfif>
                            <tr>
                                <td align="center"><em>10<sup>th</sup> year classes</em></td>
                                <td align="center"><em>Hours <br>per week</em></td>
                                <td align="center"><em>Final Grade<br> (Am. Equivalent)</em></td>
                            </tr>
                            <cfif get_10class.recordcount NEQ 0>
                                <cfinput type="hidden" name="upd_10class_count" value='#get_10grades.recordcount#'>		
                                <cfloop query="get_10grades">
                                    <tr>
                                        <cfinput type="hidden" name="upd_10class_gradesid#currentrow#" value="#gradesid#">
                                        <td align="center">
                                            <cfinput 
                                                type="text" 
                                                name="upd_10class_name#currentrow#" 
                                                value="#class_name#" 
                                                size="24" 
                                                onchange="DataChanged();">
                                        </td>
                                        <td align="center">
                                            <cfinput 
                                                type="text" 
                                                name="upd_10class_hour#currentrow#" 
                                                value="#hours#" 
                                                size="6" 
                                                maxlength="3" 
                                                validate="range" 
                                                message="Total of hours per week for #class_name# must be a number." 
                                                onchange="DataChanged();">
                                        </td>
                                        <td align="center">
                                            <cfinput 
                                                type="text" 
                                                name="upd_10class_grade#currentrow#" 
                                                value="#grade#" 
                                                size="12" 
                                                maxlength="4" 
                                                onchange="DataChanged();javascript:this.value=this.value.toUpperCase();">
                                        </td>
                                    </tr>			
                                </cfloop>
                            </cfif>			
                            <!--- NEW CLASSES UP TO 14 --->
                            <cfset new10classes = 14 - get_10grades.recordcount>
                            <cfinput type="hidden" name="new_10class_count" value="#new10classes#">
                            <cfinput type="hidden" name="new_10class_yearid" value="#get_10class.yearid#">
                            <cfloop from="1" to="#new10classes#" index="i">
                                <tr>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="new_10class_name#i#" 
                                            size="24" 
                                            onchange="DataChanged();">
                                    </td>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="new_10class_hour#i#" 
                                            size="6" 
                                            maxlength="3" 
                                            validate="range" 
                                            message="10th class field #i# - Total of hours per week must be a number." 
                                            onchange="DataChanged();">
                                    </td>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="new_10class_grade#i#" 
                                            size="12" 
                                            maxlength="4" 
                                            onchange="DataChanged();javascript:this.value=this.value.toUpperCase();">
                                    </td>
                                </tr>
                            </cfloop>		
                        </table>	
                    </td>
                </tr>
            </table>
            <br>
            <table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
                <tr>
                    <td width="48%" valign="top">
                        <!--- 11th grade --->
                        <table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
                            <cfif get_11class.recordcount EQ 0>  <!--- year has not been entered --->
                                <tr>
                                    <td colspan="3">
                                        <em>
                                            &nbsp; School Year &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="new11_beg_year" 
                                                size="6" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="11th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) &nbsp; to &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="new11_end_year" 
                                                size="6" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="11th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) 
                                        </em>
                                    </td>
                                </tr>
                                <cfinput type="hidden" name="new_11class" value="11th">
                            <cfelse>
                                <tr>
                                    <td colspan="3">
                                        <em>
                                            &nbsp; School Year &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="upd11_beg_year" 
                                                size="6" 
                                                value="#DateFormat(get_11class.beg_year, 'yyyy')#" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="11th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) &nbsp; to &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="upd11_end_year" 
                                                size="6" 
                                                value="#DateFormat(get_11class.end_year, 'yyyy')#" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="11th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) 
                                        </em>
                                    </td>
                                </tr>
                                <cfinput type="hidden" name="upd_11class" value="11th">
                                <cfinput type="hidden" name="upd_11yearid" value="#get_11class.yearid#">			
                            </cfif>
                            <tr>
                                <td align="center"><em>11<sup>th</sup> year classes</em></td>
                                <td align="center"><em>Hours <br>per week</em></td>
                                <td align="center"><em>Final Grade<br> (Am. Equivalent)</em></td>
                            </tr>
                            <cfif get_11class.recordcount NEQ 0>
                                <cfinput type="hidden" name="upd_11class_count" value='#get_11grades.recordcount#'>		
                                <cfloop query="get_11grades">
                                    <tr>
                                        <cfinput type="hidden" name="upd_11class_gradesid#currentrow#" value="#gradesid#">
                                        <td align="center">
                                            <cfinput 
                                                type="text" 
                                                name="upd_11class_name#currentrow#" 
                                                value="#class_name#" 
                                                size="24" 
                                                onchange="DataChanged();">
                                        </td>
                                        <td align="center">
                                            <cfinput 
                                                type="text" 
                                                name="upd_11class_hour#currentrow#" 
                                                value="#hours#" 
                                                size="6" 
                                                maxlength="3" 
                                                validate="range" 
                                                message="Total of hours per week for #class_name# must be a number." 
                                                onchange="DataChanged();">
                                        </td>
                                        <td align="center">
                                            <cfinput 
                                                type="text" 
                                                name="upd_11class_grade#currentrow#" 
                                                value="#grade#" 
                                                size="12" 
                                                maxlength="4" 
                                                onchange="DataChanged();javascript:this.value=this.value.toUpperCase();">
                                        </td>
                                    </tr>			
                                </cfloop>
                            </cfif>			
                            <!--- NEW CLASSES UP TO 14 --->
                            <cfset new11classes = 14 - get_11grades.recordcount>
                            <cfinput type="hidden" name="new_11class_count" value="#new11classes#">
                            <cfinput type="hidden" name="new_11class_yearid" value="#get_11class.yearid#">
                            <cfloop from="1" to="#new11classes#" index="i">
                                <tr>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="new_11class_name#i#" 
                                            size="24" 
                                            onchange="DataChanged();">
                                    </td>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="new_11class_hour#i#" 
                                            size="6" 
                                            maxlength="3" 
                                            validate="range" 
                                            message="11th class field #i# - Total of hours per week must be a number." 
                                            onchange="DataChanged();">
                                    </td>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="new_11class_grade#i#" 
                                            size="12" 
                                            maxlength="4" 
                                            onchange="DataChanged();javascript:this.value=this.value.toUpperCase();">
                                    </td>
                                </tr>
                            </cfloop>		
                        </table>	
                    </td>
                    <td width="4%">&nbsp;</td>
                    <td width="48%" valign="top" align="left">
                        <!--- 12th grade --->
                        <table border=1 cellpadding=0 cellspacing=0  bordercolor="CCCCCC" width="100%">
                            <cfif get_12class.recordcount EQ 0>  <!--- year has not been entered --->
                                <tr>
                                    <td colspan="3">
                                        <em>
                                            &nbsp; School Year &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="new12_beg_year" 
                                                size="6" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="12th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) &nbsp; to &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="new12_end_year" 
                                                size="6" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="12th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) 
                                        </em>
                                    </td>
                                </tr>
                                <cfinput type="hidden" name="new_12class" value="12th">
                            <cfelse>
                                <tr>
                                    <td colspan="3">
                                        <em>
                                            &nbsp; School Year &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="upd12_beg_year" 
                                                size="6" 
                                                value="#DateFormat(get_12class.beg_year, 'yyyy')#" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="12th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) &nbsp; to &nbsp; 
                                            <cfinput 
                                                type="text" 
                                                name="upd12_end_year" 
                                                size="6" 
                                                value="#DateFormat(get_12class.end_year, 'yyyy')#" 
                                                maxlength="4" 
                                                validate="regex" 
                                                pattern="^[0-9]{4,4}$" 
                                                range="1901,2155" 
                                                onchange="DataChanged();" 
                                                validateat="onsubmit,onserver" 
                                                message="12th Grade School Year - Please enter a valid year in the YYYY format."> 
                                            (yyyy) 
                                        </em>
                                    </td>
                                </tr>
                                <cfinput type="hidden" name="upd_12class" value="12th">
                                <cfinput type="hidden" name="upd_12yearid" value="#get_12class.yearid#">			
                            </cfif>
                            <tr>
                                <td align="center"><em>12<sup>th</sup> year classes</em></td>
                                <td align="center"><em>Hours <br>per week</em></td>
                                <td align="center"><em>Final Grade<br> (Am. Equivalent)</em></td>
                            </tr>
                            <cfif get_12class.recordcount NEQ 0>
                                <cfinput type="hidden" name="upd_12class_count" value='#get_12grades.recordcount#'>		
                                <cfloop query="get_12grades">
                                <tr>
                                    <cfinput type="hidden" name="upd_12class_gradesid#currentrow#" value="#gradesid#">
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="upd_12class_name#currentrow#" 
                                            value="#class_name#" 
                                            size="24" 
                                            onchange="DataChanged();">
                                    </td>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="upd_12class_hour#currentrow#" 
                                            value="#hours#" 
                                            size="6" 
                                            maxlength="3" 
                                            validate="range" 
                                            message="Total of hours per week for #class_name# must be a number." 
                                            onchange="DataChanged();">
                                    </td>
                                    <td align="center">
                                        <cfinput 
                                            type="text" 
                                            name="upd_12class_grade#currentrow#" 
                                            value="#grade#" 
                                            size="12" 
                                            maxlength="4" 
                                            onchange="DataChanged();javascript:this.value=this.value.toUpperCase();">
                                    </td>
                                </tr>			
                            </cfloop>
                        </cfif>			
                        <!--- NEW CLASSES UP TO 14 --->
                        <cfset new12classes = 14 - get_12grades.recordcount>
                        <cfinput type="hidden" name="new_12class_count" value="#new12classes#">
                        <cfinput type="hidden" name="new_12class_yearid" value="#get_12class.yearid#">
                        <cfloop from="1" to="#new12classes#" index="i">
                            <tr>
                                <td align="center">
                                    <cfinput 
                                        type="text" 
                                        name="new_12class_name#i#" 
                                        size="24" 
                                        onchange="DataChanged();">
                                </td>
                                <td align="center">
                                    <cfinput 
                                        type="text" 
                                        name="new_12class_hour#i#" 
                                        size="6" 
                                        maxlength="3" 
                                        validate="range" 
                                        message="12th class field #i# - Total of hours per week must be a number." 
                                        onchange="DataChanged();">
                                </td>
                                <td align="center">
                                    <cfinput 
                                        type="text" 
                                        name="new_12class_grade#i#" 
                                        size="12" 
                                        maxlength="4" 
                                        onchange="DataChanged();javascript:this.value=this.value.toUpperCase();">
                                </td>
                            </tr>
                        </cfloop>		
                    </table>	
							</td>
						
            </tr>
        </table>
		
        <br>
        <br>
        <table width="670" border=0 cellpadding=1 cellspacing=0 align="center">
            <tr>
                <td align="center">Please attach a copy of each year's transcript of grades using the upload feature on the top of this page.</td>
            </tr>	
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td align="center">
                    Students must bring an official transcript with them for scheduling purposes in the American School.
                    <br>
                    All documents must be translated into English.
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <br>
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