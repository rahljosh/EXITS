<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfparam name="edit" default="no" >
	<cfif isDefined('form.edit')>
	<cfset edit=#form.edit#>
</cfif>

<!-----Company Information----->
<Cfquery name="companyshort" datasource="MySQL">
	select *
	from smg_companies
	where companyid = #client.companyid#
</Cfquery>

<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
<tr><td align="right"><font size="-1">International Agent: &nbsp; <u><b>____________________________________________(________)</font></b></u></td></tr>
</table>

<Cfoutput>
<table cellspacing="2" cellpadding="2" border="0" width="650" align="center" class="box">
<tr>
    <td><img src="../pics/logos/#companyshort.companyid#.gif"  alt="" border="0" align="left" border="0"></td>
	 <td  align="left">
		<cfif not IsDefined('url.month')><cfset url.month = '12'></cfif>
		<font size="+3">Student Progress Report for 
			<cfif url.month is 10>October<br></cfif>
			<cfif url.month is 12>December<br></cfif>
			<cfif url.month is 2>February<br></cfif>
			<cfif url.month is 4>April<br></cfif>
			<cfif url.month is 6>June<br></cfif>
			<cfif url.month is 8>August<br></cfif></font><br>
		<font size="+1">Student Name:</font> ___________________________________(___) <br>
		Program: _____________________________________________(___)
	</td>
</tr>
</table>

<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
<hr>
</table>

<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
	<Tr>
		<td>Host Family: </td>
		<td>___________________________________(___)</td>
	</Tr>
	<tr>
		<td width="20%">Area Representitve: </td><td>___________________________________(___)</td>
	</tr>
	<Tr>
		<td>Regional Director: </td><td>___________________________________(___)</td>
	</Tr>
</table>
<br>

<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
	<TR>
		<TD align="left" valign=top>
				<TABLE>
					<TR>
						<TD align="center"><b>Contact: In-Person</b></td>
					</tr>
					<tr>
						<td>
							<table class=nav_bar width=100% align="Center" background="pics/inperson_background.jpg">
			
								<TR>
									<td align="center">Host Family<br>(mm/dd/yy)</td><td align="center">Student<br>(mm/dd/yy)</td>
								</tr>
								<TR>
									<TD align="right">Date: <input type="Text" name="host_date_inperson" align="LEFT"  required="No" size="8" maxlength="10" value=""></td><TD align="right">Date: <input type="Text" name="stu_date_inperson" align="LEFT" required="No" size="8" maxlength="10" value=""></td>
								</tr>
								<tr>
									<TD align="right">Date: <input type="Text" name="host_date_inperson2" align="LEFT"  required="No" size="8" maxlength="10" value=""></td><td align="right">Date: <input type="Text" name="stu_date_inperson2" align="LEFT" required="No" size="8" maxlength="10" value=""></td>
								</tr>
								<tr>
									<TD align="right">Date: <input type="Text" name="host_date_inperson3" align="LEFT"  required="No" size="8" maxlength="10" value=""></td><td align="right">Date: <input type="Text" name="stu_date_inperson3" align="LEFT" required="No" size="8" maxlength="10" value=""></td>
								</tr>
							</TABLE>
						</td>
					</tr>
				</table>
		</TD>
		<TD align="right" valign=top>
				<TABLE>
					<TR>
						<TD align="center"><b>Contact: By Telephone</b></td>
					</tr>
					<tr>
						<td>
						
							<table class=nav_bar width=100% align="Center"  background="pics/phone_background.jpg">
								<TR>
									<td align="center">Host Family<br>(mm/dd/yy)</td><td align="center">Student<br>(mm/dd/yy)</td>
								</tr>
								<TR>
									<TD>Date: <input type="Text" name="host_date_phone" align="LEFT"  required="No" size="8" maxlength="10" value=""></td><TD>Date: <input type="Text" name="stu_date_phone" align="LEFT"  required="No" size="8" maxlength="10" value=""></td>
								</tr>
								<tr>
									<TD>Date: <input type="Text" name="host_date_phone2" align="LEFT"  required="No" size="8" maxlength="10" value=""></td><td>Date: <input type="Text" name="stu_date_phone2" align="LEFT"  required="No" size="8" maxlength="10" value=""></td>
								</tr>
								<tr>
									<TD>Date: <input type="Text" name="host_date_phone3" align="LEFT"  required="No" size="8" maxlength="10" value=""></td><td>Date: <input type="Text" name="stu_date_phone3" align="LEFT"  required="No" size="8" maxlength="10" value=""></td>
								</tr>
							</TABLE>
						</td>
					</tr>
				</table>
		</TD>
	</TR>
</TABLE>

<br>
<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
	<cfquery name="questions" datasource="MySQL">
		SELECT DISTINCT * from smg_prquestions
		WHERE month = '#url.month#'
			  AND companyid = '1'
			  AND active = '1'
		ORDER BY id
	</cfquery>
	
	<cfif questions.recordcount EQ '0'>
		<tr><td>No Questions were found for this month.</td></tr>
	<cfelse>
		<cfloop query="questions">
		<TR>
			<TD width="75%"><div align="justify">#questions.text#</div></td>
			<td width="10%"></td>
			<td width="15%">Yes &nbsp; No</td>
		</tr>
		<tr>
			<td colspan=3>Comments:</td>
		</tr>
			<tr>
			<td colspan=3><div align="justify">____________________________________________________________________________________</div></td>
		</tr>
		<tr>
			<td colspan=3 align="Center"><hr width=80%></td>
		</tr>
		</cfloop>
	</cfif>
</table>
<Br>
</cfoutput>