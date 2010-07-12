<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>ID Cards & Labels</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cftry>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_php_intl_reps.cfm">

<cfinclude template="../querys/get_insurance_policies.cfm">

<cfinclude template="../querys/get_states.cfm">

<cfoutput>

<br />

<Table class="nav_bar" cellpadding=2 cellspacing="0" width="90%" align="center">
	<tr><td bgcolor="##C4CDE7" height="25px;"><b>Labels and Student ID Cards</b></td></tr>
</table>

<br />

<table border=0 cellpadding=0 cellspacing=0 width="90%" align="center">
<tr><td>

	<!--- ROW 1 - 2 boxes --->
	<table cellpadding=2 cellspacing="0" align="center" width="100%">
		<tr>
			<td width="49%" valign="top">
				<cfform action="reports/student_id_cards.cfm?RequestTimeout=2300" method="POST" target="blank">
				<Table cellpadding=2 cellspacing="0" width="100%" style="border:1px solid ##C4CDE7;">
					<tr><th colspan="3" bgcolor="##C4CDE7" height="25px;">Student ID Cards</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname# &nbsp;</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Intl. Rep :</td>
						<td><cfselect name="intrep">
								<option value="0">All</option>
								<cfloop query="get_php_intl_reps"><option value="#userid#">#businessname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Insurance Policy :</td>
						<td><cfselect name="insurance_typeid">
								<cfloop query="get_insurance_policies"><option value="#insutypeid#">#type#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr><td align="right">Date Entered</td><td>* not required</td></tr>
					<tr><td align="right">From :</td><td><cfinput type="text" name="date1" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>
					<tr><td align="right">To :</td><td><cfinput type="text" name="date2" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>																												
					<tr><td colspan="3" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
            <td width="2%">&nbsp;</td>
			<td width="49%" valign="top">
				<cfform action="reports/student_id_cards_list.cfm" method="POST" target="blank">
				<Table cellpadding=2 cellspacing="0" width="100%" style="border:1px solid ##C4CDE7;">
					<tr><th colspan="3" bgcolor="##C4CDE7" height="25px;">Student ID Cards LIST</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname# &nbsp;</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Intl. Rep :</td>
						<td><cfselect name="intrep">
								<option value="0">All</option>
								<cfloop query="get_php_intl_reps"><option value="#userid#">#businessname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Insurance Policy :</td>
						<td><cfselect name="insurance_typeid">
								<cfloop query="get_insurance_policies"><option value="#insutypeid#">#type#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr><td align="right">Date Entered</td><td>* not required</td></tr>
					<tr><td align="right">From :</td><td><cfinput type="text" name="date1" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>
					<tr><td align="right">To :</td><td><cfinput type="text" name="date2" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>																												
					<tr><td colspan="3" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>					
			</td>
		</tr>
		<tr><th colspan="3">PS: Please set your margins as follow: top 0.4in / bottom 0.4in / left 0.4in / right 0.4in for ID Cards.</th></tr>
	</table><br>

	
    <!--- ROW 2 - 2 boxes --->
	<table cellpadding=2 cellspacing="0" align="center" width="100%">
		<tr>
			<td width="49%" valign="top">
				<cfform action="reports/insurance_cards.cfm" method="POST" target="blank">
				<Table cellpadding=2 cellspacing="0" width="100%" style="border:1px solid ##C4CDE7;">
					<tr><th colspan="3" bgcolor="##C4CDE7" height="25px;">Insurance Cards</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname# &nbsp;</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Intl. Rep :</td>
						<td><cfselect name="intrep">
								<option value="0">All</option>
								<cfloop query="get_php_intl_reps"><option value="#userid#">#businessname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Insurance Policy :</td>
						<td><cfselect name="insurance_typeid">
								<cfloop query="get_insurance_policies"><option value="#insutypeid#">#type#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr><td align="right">Date Entered</td><td>* not required</td></tr>
					<tr><td align="right">From :</td><td><cfinput type="text" name="date1" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>
					<tr><td align="right">To :</td><td><cfinput type="text" name="date2" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>																												
                    <tr> 
                        <td colspan="3" align="center">
                            <div style="font-weight:bold;">
                                Set margins to: <br>
                                IE: top: 0.5 / bottom: 0.4 / left: 0.7 / right: 0.5 <br>                                                
                                Firefox: top: 0.3 / bottom: 0.3 / left: 0.5 / right: 0.5 <br>                                                
                                Make sure you set page scaling to: Shrink to Printable Area <br>
                            </div>
                        </td>
                    </tr>
					<tr><td colspan="3" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
                </table>
				</cfform>
			</td>
            <td width="2%">&nbsp;</td>
			<td width="49%" valign="top">
				&nbsp;
			</td>
		</tr>
	</table><br>


	<!--- ROW 3 - 2 boxes --->
	<table cellpadding=2 cellspacing="0" align="center" width="100%">
		<tr>
			<td width="49%" valign="top">
				<cfform action="reports/labels_students.cfm" method="POST">
				<Table cellpadding=2 cellspacing="0" width="100%" style="border:1px solid ##C4CDE7;">
					<tr><th colspan="3" bgcolor="##C4CDE7" height="25px;">Student Labels (HF and School)</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname# &nbsp;</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Intl. Rep :</td>
						<td><cfselect name="intrep">
								<option value="0">All</option>
								<cfloop query="get_php_intl_reps"><option value="#userid#">#businessname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Insurance Policy :</td>
						<td><cfselect name="insurance_typeid">
								<cfloop query="get_insurance_policies"><option value="#insutypeid#">#type#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr><td align="right">Date Entered</td><td>* not required</td></tr>
					<tr><td align="right">From :</td><td><cfinput type="text" name="date1" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>
					<tr><td align="right">To :</td><td><cfinput type="text" name="date2" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>																												
					<tr><td colspan="3" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
            <td width="2%">&nbsp;</td>
			<td width="49%" valign="top">
				<cfform action="reports/labels_schools.cfm" method="POST">
				<Table cellpadding=2 cellspacing="0" width="100%" style="border:1px solid ##C4CDE7;">
					<tr><th colspan="3" bgcolor="##C4CDE7" height="25px;">School Labels</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname# &nbsp;</option></cfloop>
							</cfselect>
						</td>
					</tr>					
					<tr>
						<td align="right" width="20%">State :</td>
						<td>
							<cfselect name="state" query="states" display="state" value="id" queryPosition="below">
								<option value="0">All</option>
							</cfselect>
						</td>
					</tr>
					<tr><td colspan="3" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
		</tr>
	</table><br>

	<!--- ROW 4 - 2 boxes --->
	<table cellpadding=2 cellspacing="0" align="center" width="100%">
		<tr>
			<td width="49%" valign="top">
				<cfform action="reports/labels_host_families.cfm" method="POST" target="blank">
				<Table cellpadding=2 cellspacing="0" width="100%" style="border:1px solid ##C4CDE7;">
					<tr><th colspan="3" bgcolor="##C4CDE7" height="25px;">Host Famliy Labels</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname# &nbsp;</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Intl. Rep :</td>
						<td><cfselect name="intrep">
								<option value="0">All</option>
								<cfloop query="get_php_intl_reps"><option value="#userid#">#businessname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Insurance Policy :</td>
						<td><cfselect name="insurance_typeid">
								<option value="0">All</option>
								<cfloop query="get_insurance_policies"><option value="#insutypeid#">#type#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr><td align="right">Date Placed</td><td>* not required</td></tr>
					<tr><td align="right">From :</td><td><cfinput type="text" name="date1" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>
					<tr><td align="right">To :</td><td><cfinput type="text" name="date2" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>																												
					<tr><td colspan="3" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
            <td width="2%">&nbsp;</td>
			<td width="49%" valign="top">
				<cfform action="reports/bulk_host_family_letter.cfm" method="POST" target="blank">
				<Table cellpadding=2 cellspacing="0" width="100%" style="border:1px solid ##C4CDE7;">
					<tr><th colspan="3" bgcolor="##C4CDE7" height="25px;">Bulk Host Famliy Letter</th></tr>
					<tr>
						<td align="right">Program :</td>
						<td><cfselect name="programid" multiple size="5">
								<cfloop query="get_programs"><option value="#programid#">#programname# &nbsp;</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Intl. Rep :</td>
						<td><cfselect name="intrep">
								<option value="0">All</option>
								<cfloop query="get_php_intl_reps"><option value="#userid#">#businessname#</option></cfloop>
							</cfselect>
						</td>
					</tr>
					<tr>
						<td align="right">Insurance Policy :</td>
						<td><cfselect name="insurance_typeid">
								<option value="0">All</option>
								<cfloop query="get_insurance_policies"><option value="#insutypeid#">#type#</option></cfloop>
							</cfselect>
						</td>
					</tr>							
					<tr><td align="right">Date Placed</td><td>* not required</td></tr>
					<tr><td align="right">From :</td><td><cfinput type="text" name="date1" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>
					<tr><td align="right">To :</td><td><cfinput type="text" name="date2" size="6" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>																												
					<tr><td colspan="3" align="center" bgcolor="##C4CDE7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
				</cfform>
			</td>
		</tr>
	</table><br>

</td></tr>
</table><br>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>