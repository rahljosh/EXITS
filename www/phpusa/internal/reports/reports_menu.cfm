<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Reports</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cftry>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_php_intl_reps.cfm">

<cfinclude template="../querys/get_php_school_info.cfm">

<cfoutput>
<br />
<Table class="nav_bar" cellpadding=3 cellspacing="0" width="90%" align="center">
	<tr><td bgcolor="##C4CDE7"><b>R E P O R T S</b></td></tr>
</table>

<table border=0 cellpadding=0 cellspacing=0 width="90%" align="center">
<tr><td>

	<!--- ROW 1 - 2 boxes --->
	<table cellpadding=3 cellspacing="0" align="center" width="100%">
		<tr>
			<td width="50%" valign="top">
				<cfform action="reports/school_doc_tracking.cfm" method="POST" target="blank">
				<Table cellpadding=3 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##C4CDE7">Document Tracking Report</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname#</option></cfloop>
							</cfselect>
						</td>
					</tr>							
					<tr>
						<td align="right">Order by:</td>
						<td><cfselect name="orderby">
								<option value="schoolname" selected="selected">School Name</option>
								<option value="businessname">Intl. Agent</option>
							</cfselect>
						</td>
					</tr>
					<tr><td colspan="2" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
			<td width="50%" valign="top">
				<cfform action="reports/evaluations_tracking.cfm" method="POST" target="blank">
				<Table cellpadding=3 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##C4CDE7">Evaluations / Grades Tracking Report</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname#</option></cfloop>
							</cfselect>
						</td>
					</tr>							
					<tr>
						<td align="right">Order by:</td>
						<td><cfselect name="orderby">
								<option value="familylastname" selected="selected">Last Name</option>
								<option value="schoolname">School Name</option>
								<option value="businessname">Intl. Agent</option>
							</cfselect>
						</td>
					</tr>
					<tr><td colspan="2" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
		</tr>
	</table><br>
	
	<!--- ROW 2 - 2 boxes --->
	<table cellpadding=3 cellspacing="0" align="center" width="100%">
		<tr>
			<td width="50%" valign="top">
				<cfform action="reports/students_per_grade.cfm" method="POST" target="blank">
				<Table cellpadding=3 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##C4CDE7">Students by Grade Level</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Grade :</td>
						<td><cfselect name="grades">
								<option value="">All</option>
								<option value="7">7</option>
								<option value="8">8</option>
								<option value="9">9</option>
								<option value="10">10</option>
								<option value="11">11</option>
								<option value="12">12</option>
							</cfselect>
						</td>
					</tr>
					<tr><td colspan="2" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
			<td width="50%" valign="top">
				<cfform action="reports/students_school_dates.cfm" method="POST" target="blank">
				<Table cellpadding=3 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##C4CDE7">Students & School Dates</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Intl. Rep :</td>
						<td><cfselect name="intrep">
								<option value="0"></option>
								<cfloop query="get_php_intl_reps"><option value="#userid#">#businessname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr><td colspan="2" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>		
			</td>
		</tr>
	</table><br>

	<!--- ROW 3 - 2 boxes --->
	<table cellpadding=3 cellspacing="0" align="center" width="100%">
		<tr>
			<td width="50%" valign="top">
				<cfform action="reports/hf_pay_list.cfm" method="POST" target="blank">
				<Table cellpadding=3 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##C4CDE7">Host Families to be Paid</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname#</option></cfloop>
							</cfselect>
						</td>
					</tr>							
					<tr><td colspan="2" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
			<td width="50%" valign="top">
				<cfform action="reports/welcome_fam_report.cfm" method="POST" target="blank">
				<Table cellpadding=3 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##C4CDE7">Welcome Family Report</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname#</option></cfloop>
							</cfselect>
						</td>
					</tr>							
					<tr><td colspan="2" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
		</tr>
	</table><br>
    
    <!--- ROW 4 - 1 box --->
	<table cellpadding=3 cellspacing="0" align="center" width="100%">
		<tr>
			<td width="50%" valign="top" align="center">
				<cfform action="reports/invoice_report.cfm" method="POST" target="blank">
				<Table cellpadding=3 cellspacing="0" width="50%">
					<tr><th colspan="2" bgcolor="##C4CDE7">Invoice Report</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td>
                        	<cfselect name="programID" multiple size="5" style="width:16%">
								<cfloop query="get_programs">
                                	<option value="#programid#">#programname#</option>
                               	</cfloop>
							</cfselect>
						</td>
					</tr>
                    <tr>
						<td align="right">Intl. Rep :</td>
						<td>
                        	<cfselect name="repID" style="width:60%">
								<option value="0">All</option>
								<cfloop query="get_php_intl_reps">
                                	<option value="#userid#">#businessname#</option>
                               	</cfloop>
							</cfselect>
						</td>
					</tr>
                    <tr>
						<td align="right">School :</td>
						<td>
                        	<cfselect name="schoolID" style="width:60%">
								<option value="0">All</option>
								<cfloop query="qGetPHPSchools">
                                	<option value="#schoolid#">#schoolname#</option>
                              	</cfloop>
							</cfselect>
						</td>
					</tr>
                    <tr>
						<td align="right">Order By :</td>
						<td>
                        	<cfselect name="orderBy" style="width:20%">
								<option value="1">Intl. Rep</option>
                                <option value="2">School</option>
                                <option value="3">Student</option>
							</cfselect>
						</td>
					</tr>						
					<tr><td colspan="2" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
		</tr>
	</table><br>

</td>
</tr>
</table><br>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>
