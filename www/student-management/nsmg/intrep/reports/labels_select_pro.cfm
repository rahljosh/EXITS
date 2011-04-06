<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body> 

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>



<!--- INTERNATIONAL REPS WITH KIDS ASSIGNED TO THE COMPANY--->




<cfinclude template="../../querys/get_countries.cfm">

<cfquery name="get_program" datasource="mysql">
select distinct s.programid, smg_programs.programname
from smg_students s
LEFT join smg_programs on s.programid = smg_programs.programid
where intrep = #client.userid# 
and s.active = 1 and s.programid > 0
<Cfif client.companyid neq 10>
and (s.companyid = 1 or s.companyid =2 or s.companyid =2 or s.companyid = 4 or s.companyid = 12)
<cfelse>
and s.companyid = 10
</Cfif>
</cfquery>


<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>LABELS and Student ID Cards</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td valign="top">

	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="##e2efc7">STUDENT'S ID CARDS <font size="-2"></font></th></tr>

	<tr>
		<td width="50%" valign="top">
			<cfform action="intrep/reports/BatchIDCards.cfm" method="POST" target="_blank">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">By Program</th></tr>
				<tr><td>Program :</td>
					<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#programid#">#programname#</option></cfloop>	
						</select></td></tr>
							
		
							
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>		
		</td>
		
		<td width="50%" valign="top">
			<cfform action="intrep/reports/BatchIDCards.cfm" method="POST" target="_blank">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">By ID</th></tr>
				<tr><td>Enter a single ID or list of ID's seperated by coma's :</td>
					<td><input type="text" name="id_list"></td></tr>
							
		
							
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>		
		</td>
		<!----
		<td width="50%" valign="top">	
			<cfform action="reports/labels_student_idcards_id.cfm" method="POST" target="_blank">
			<Table class="nav_bar" align="right" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Per Student ID</th></tr>
				<tr><td>Program :</td>
					<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#programid#">#programname#</option></cfloop>	
						</select></td></tr>
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><cfselect name="intrep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
						<option value=0>All Reps</option>
						</cfselect>
					</td>
				</tr>					
				<tr>
					<td>Insurance <br> Type:</td>
					<td><cfselect name="insurance_typeid" query="insurance_policies" value="insutypeid" display="type" queryPosition="below" >
							<option value="0"></option>
						</cfselect>
					</td>
				</tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="id1" size="4" maxlength="6" validate="integer"></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="id2" size="4" maxlength="6" validate="integer"></td></tr>
				<tr><td align="right"><input type="checkbox" name="usa"></input></td><td>Only American Citizen Students</td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>			
		</td>
		---->
	</tr>
	<tr> 
		<td colspan="2"><div align="justify">
		<font color="FF0000">Note: </font>Each ID card will print on its own sheet of paper.<br>Make sure to remove any information that would print in the header and footer so they are blank. </font></div>
		</td>
	</tr>
	</table><br><br>
	
<!----
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="##e2efc7">ID CARDS & MAILING LABELS - STUDENTS IN THE USA <font size="-2">(Approved placements only)</font></th></tr>
	<tr><td width="50%" valign="top">
			<cfform action="reports/labels_student_idcards_place_date.cfm" method="POST" target="_blank">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">ID CARDS Per Placement Date</th></tr>
				<tr><td>Program :</td>
					<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#programid#">#programname#</option></cfloop>	
						</select></td></tr>				
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><cfselect name="intrep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
						<option value=0>All Reps</option>
						</cfselect>
					</td>
				</tr>					
				<tr>
					<td>Insurance <br> Type:</td>
					<td><cfselect name="insurance_typeid" query="insurance_policies" value="insutypeid" display="type" queryPosition="below" >
							<option value="0"></option>
						</cfselect>
					</td>
				</tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>				
				<tr><td colspan="2"><a href="reports/intl_agent_insurance_policies.cfm" target="_blank">Intl. Representatives Insurance Policy List</a></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="reports/labels_students_place_date.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">LABELS Per Placement Date</th></tr>
				<tr><td>Program :</td>
					<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#programid#">#programname#</option></cfloop>	
						</select></td></tr>				
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><cfselect name="intrep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
						<option value=0>All Reps</option>
						</cfselect>
					</td>
				</tr>					
				<tr>
					<td>Insurance <br> Type:</td>
					<td><cfselect name="insurance_typeid" query="insurance_policies" value="insutypeid" display="type" queryPosition="below" >
							<option value="0"></option>
						</cfselect>
					</td>
				</tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>				
				<tr><td colspan="2"><a href="reports/intl_agent_insurance_policies.cfm" target="_blank">Intl. Representatives Insurance Policy List</a></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>		
		</td>
	</tr>
	<tr><td width="50%" valign="top">&nbsp;</td>
		<td width="50%" valign="top">
			<cfform action="reports/labels_student_insurance_date.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">Caremed LABELS Per Insurance Date</th></tr>
				<tr><td>Program :</td>
					<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#programid#">#programname#</option></cfloop>	
						</select>
					</td>
				</tr>	
				<tr align="left">
					<td>Insurance Date:</td>
					<td><cfselect name="insurance" query="insurance_dates" value="insurance" display="insurance" multiple="yes" size="5"></cfselect></td>
				</tr>							
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><cfselect name="intrep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
						<option value=0>All Reps</option>
						</cfselect>
					</td>
				</tr>							
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>		
		</td>
	</tr>	
	</table><br><br>
		
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="##e2efc7">LABELS FOR FILING</th></tr>
	<tr><td width="50%" valign="top">
			<cfform action="reports/labels_for_filing.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">Per Period</th></tr>
				<tr><td>Program :</td>
					<td><select name="programid" size="1">
						<option value=0>All Programs</option>
						<cfloop query="get_program"><option value="#programid#">#programname#</option></cfloop>	
						</select></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="reports/labels_for_filing_id.cfm" method="POST">
			<Table class="nav_bar" align="right" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Per Student ID</th></tr>
				<tr>
					<td>Program :</td>
					<td><select name="programid" size="1">
						<option value=0>All Programs</option>
						<cfloop query="get_program"><option value="#programid#">#programname#</option></cfloop>	
						</select></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="id1" size="4" maxlength="6" validate="integer" required="yes"></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="id2" size="4" maxlength="6" validate="integer" required="yes"></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	</table><br><br>
		
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="##e2efc7">MAILING LABELS - STUDENTS IN THE USA <font size="-2">(Approved placements only)</font></th></tr>
	<tr><td width="50%" valign="top">
			<cfform action="reports/labels_students.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">Per Period</th></tr>
				<tr><td>Program :</td>
						<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select></td></tr>
				<tr><td>Country :</td>
					<td><select name="countryid" size="1">
						<option value="0"></option>
						<cfloop query="get_countries"><option value="#countryid#">#countryname#</option></cfloop>
						</select></td>
				</tr>	
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>
				<tr><td colspan="2"><font size="-2" color="000066">* Application Received Date</font></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="reports/labels_students_id.cfm" method="POST">
			<Table class="nav_bar" align="right" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Per Student ID</th></tr>
				<tr><td>Program :</td>
					<td><select name="programid" multiple  size="5">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select></td></tr>
				<tr><td>Country :</td>
					<td><select name="countryid" size="1">
						<option value="0"></option>
						<cfloop query="get_countries"><option value="#countryid#">#countryname#</option></cfloop>
						</select></td>
				</tr>					
				<tr><td width="5">From : </td><td><cfinput type="text" name="id1" size="4" maxlength="6" validate="integer" required="yes"></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="id2" size="4" maxlength="6" validate="integer" required="yes"></td></tr>
				<tr><td colspan="2"><font size="-2" color="000066">* Student ID's</font></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	<tr><td width="50%" valign="top">
			<cfform action="reports/labels_students_place_date.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">Per Placement Date</th></tr>
				<tr><td>Program :</td>
						<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select></td></tr>
				<tr>
					<td>Insurance <br> Type:</td>
					<td><cfselect name="insurance_typeid" query="insurance_policies" value="insutypeid" display="type" queryPosition="below" >
							<option value="0"></option>
						</cfselect>
					</td>
				</tr>				
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date" required="yes"> mm/dd/yyyy</td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
		</td>
	</tr>
	</table><br><br>
	
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="##e2efc7">MAILING LABELS - STUDENTS IN CARE OF HOST FAMILY <font size="-2">(Approved placements only)</font></th></tr>
	<tr><td width="50%" valign="top">
			<cfform action="reports/labels_stu_per_region.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">Per Region</th></tr>
				<tr><td>Program :</td>
						<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select></td></tr>
				<tr><td>Region :</td>
					<td><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" multiple="yes" size="5"></cfselect></td>
				</tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
	
		</td>
	</tr>
	</table><br><br>
	
	<!--- BULK MAILING - LABELS + WELCOME LETTERS --->
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="##e2efc7">BULK Mailing <font size="-2">(Approved placements only)</font></th></tr>
	<tr><td width="50%" valign="top">
			<cfform action="reports/bulk_host_family_letter.cfm" method="POST" target="_blank">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">Host Family Welcome Letters</th></tr>
				<tr><td>Program :</td>
						<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select></td></tr>
				<tr>
					<td>Insurance <br> Type:</td>
					<td><cfselect name="insurance_typeid" query="insurance_policies" value="insutypeid" display="type" queryPosition="below" >
							<option value="0"></option>
						</cfselect>
					</td>
				</tr>				
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm/dd/yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm/dd/yyyy</td></tr>
				<tr><td colspan="2"><font size="-2" color="000066">* Date Placed (Leave blank for all)</font></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="reports/bulk_host_family_label.cfm" method="POST" target="_blank">
			<Table class="nav_bar" align="right" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Host Family Labels</th></tr>
				<tr><td>Program :</td>
					<td><select name="programid" multiple  size="5">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select></td></tr>
				<tr>
					<td>Insurance <br> Type:</td>
					<td><cfselect name="insurance_typeid" query="insurance_policies" value="insutypeid" display="type" queryPosition="below" >
							<option value="0"></option>
						</cfselect>
					</td>
				</tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm/dd/yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm/dd/yyyy</td></tr>
				<tr><td colspan="2"><font size="-2" color="000066">* Date Placed (Leave blank for all)</font></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	<tr><td width="50%" valign="top">
			<cfform action="reports/bulk_school_welc_letter.cfm" method="POST" target="_blank">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">School Welcome Letters</th></tr>
				<tr><td>Program :</td>
					<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
						</select>
					</td>
				</tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm/dd/yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm/dd/yyyy</td></tr>
				<tr><td colspan="2"><font size="-2" color="000066">* Date Placed (Leave blank for all)</font></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<!----School Address Labels---->
		<td width="50%" valign="top">

			<cfform action="reports/labels_schools_address.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">School Labels</th></tr>
			<tr><td>Program :</td>
					<td><select name="programid" multiple size="5">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
						</select>
					</td>
				</tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm/dd/yyyy</td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm/dd/yyyy</td></tr>
				<tr><td colspan="2"><font size="-2" color="000066">* Date Placed (Leave blank for all)</font></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
	
	</tr>	
	</table><br><br>
		
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="##e2efc7">MAILING LABELS</th></tr>
	<tr><td width="50%" valign="top">
			<cfform action="reports/labels_rep_per_region.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">Reps - per Region</th></tr>
				<tr><td>Region :</td>
					<td><select name="regionid" multiple size="5">
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>	
						</select></td>
				</tr>
				<tr><td colspan="3"><input type="checkbox" name="inactive">Include Inactive Reps.</input></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<!--- Int Rep Mailing Labels --->
			<cfform action="reports/int_rep_mailing_labels.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">Int. Reps</th></tr>
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><select name="intrep" size="1">
						<option value=0>All Reps</option>
						<cfloop query="get_intl_rep"><option value="#userid#">#businessname#</option></cfloop>
						</select></td></tr>								
				<tr><td colspan="3"><input type="checkbox" name="inactive">Include Inactive Intl. Reps.</input></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	<!----Mailing Lables for Schools---->
	<tr>
		<td width="50%" valign="top">
		<!----Empty Cell---->
		</td>
	</tr>
	
	
	</table><br><br>
	
	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="##e2efc7">LABELS FOR FILING - INTL. REPRESENTATIVE</th></tr>
	<tr><td width="50%" valign="top">
			<cfform action="reports/labels_intrep.cfm" method="POST">
			<Table class="nav_bar" align="left" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="3" bgcolor="##e2efc7">Int. Reps</th></tr>
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><select name="intrep" size="1">
						<option value=0>All Reps</option>
						<cfloop query="get_intl_rep"><option value="#userid#">#businessname#</option></cfloop>
						</select></td></tr>								
				<tr><td colspan="3"><input type="checkbox" name="inactive">Include Inactive Intl. Reps.</input></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<!--- new box goes here --->
		</td>
	</tr>
	</table><br><br>
---->
</td></tr>
</table>

<cfinclude template="../../table_footer.cfm">	

</cfoutput>

</body>
</html>