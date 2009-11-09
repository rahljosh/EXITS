<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance Cards</title>
</head>

<body>

<!---		Generate Avery Standard 5371
			id cars for our students.	--->

<!--- 		margin:'0.3in' '0.3in' '0.46in' '0.3in'; --->
<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.3in 0.3in 0.46in;
	}
	div.Section1 {		
		page:Section1;
	}
	td.label {
		width:252.0pt;
		height:144.0pt;
	}
	p {
		margin-top:0in;
		margin-right:5.3pt;
		margin-bottom:0in;
		margin-left:5.3pt;
		mso-pagination:widow-orphan;
		font-size:10.0pt;
		font-family:"Arial";
	}
.style1 {font-size: 6pt} <!--- company address --->
.style2 {font-size: 7pt} <!--- host + rep info ---->
.style3 {font-size: 8pt} <!--- student's name ---->
.style4 {font-size: 10pt} <!--- company name ---->
.style5 {font-size: 5pt} 

</style>
			
<!---		Get names, addresses from our database		--->
<cfquery name="get_students" datasource="MySql"> 
	SELECT 	ec.candidateid, ec.lastname, ec.firstname, ec.ds2019,
			u.businessname,
			p.programname, p.programid, 
			c.companyname, c.address AS c_address, c.city AS c_city, c.state AS c_state, c.zip AS c_zip, c.toll_free,
			hcompany.name as hostcompanyname, hcompany.address as hostaddress, hcompany.city as hostcity, states.state as hoststate,
			hcompany.zip as hostzip
	FROM extra_candidates ec 
	INNER JOIN smg_users u ON ec.intrep = u.userid
	INNER JOIN smg_programs p ON ec.programid = p.programid
	INNER JOIN smg_companies c ON ec.companyid = c.companyid
	LEFT JOIN extra_candidate_place_company place ON ec.candidateid = place.candidateid
	LEFT JOIN extra_hostcompany hcompany ON place.hostcompanyid = hcompany.hostcompanyid
	LEFT JOIN smg_states states ON states.id = hcompany.state
	WHERE ec.active = '1'
		AND place.status = '1'
		<cfif form.intrep NEQ 0>
			AND ec.intrep = '#form.intrep#'
		</cfif>
	ORDER BY u.businessname, ec.firstname
</cfquery>
					
<!---		The table consists has two columns, two labels.
			To identify where to place each, we need to	maintain a column counter.	--->

<div class="Section1">
						
	<cfset col=0> <!--- set variables --->
	<cfset pagebreak=0>
	
	<cfloop query="get_students">
	<cfoutput>
		<cfif pagebreak EQ "0">				
		<!---	Start a table for our labels	--->
		<table align="center" width="670" border="0" cellspacing="2" cellpadding="0">	
		</cfif>
		<!---		If this is the first column, then start a new row	--->
		<cfif col EQ "0">
		<tr>
		</cfif>				
		<!---		Output the label	--->			
			<td class="label" height="144" valign="top">
					<!--- HEADER --->
					<table border="0" width="100%">
					<tr>
						<td width="25%" align="center">
							<img src="../../pics/logo/#client.companyid#.gif" border="0">
						</td>
						<td width="75%" align="center"> 
						<p class="style5">&nbsp;</p>
						<p class="style4"><b>#companyname#</b>
						<p class="style1">#c_address#</p>
						<p class="style1">#c_city#, #c_state# &nbsp; #c_zip#</p>
						<p class="style1">#toll_free#</p>
						<p class="style5">&nbsp;</p>
						<p class="style3">Candidate : <b>#Firstname# #lastname#</b></p>
						<p class="style2">DS-2019 : #ds2019# &nbsp; &nbsp; ID : ## #candidateid#</p>
						</td>
                    </tr>
					</table>
					<!--- BODY --->
					<table border="0" width="100%">
	                <tr>
						<td align="left">
							<p class="style2">Placement : #hostcompanyname#</p>
							<p class="style2">Address : #hostaddress#</p>	
							<p class="style2">#hostcity#, #hoststate# #hostzip#</p>						
							<p class="style2">&nbsp;</p>																
						</td>	
					</tr>
					<tr>
						<td colspan="2">
							<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="50%">
									<p class="style2">&nbsp;</p>
									<p class="style2">&nbsp;</p>
									<p class="style2">&nbsp;</p>
								</td>
								<td width="50%" align="left">
									<p class="style2">&nbsp;</p>
									<p class="style2">&nbsp;</p>
									<p class="style2">&nbsp;</p>
								</td>
							</tr>
							</table>
						</td>
					</tr>					
					</table>
		  </td>
			<cfset col=col+1>						
			<!---If it's column 2, then end the	row and reset the column number.--->
			<cfif col EQ "2">
			</tr>
			<cfset col=0>			
			</cfif>
					
			<cfset pagebreak=pagebreak+1>
			
			<cfif pagebreak EQ "10"> <!--- close table and add a page break --->
				</table>
				<cfset pagebreak=0>
				<div style="page-break-before:always;"></div>					
			</cfif>	
	</cfoutput>
	</cfloop>
		<!---If we didn't end on column 2, then we haveto output blank labels --->
		<cfif col EQ "1">
			<td class="label"  height="144">
				<p>&nbsp;</p>
			</td>
			</tr>		
		</cfif>
		</table>
</div>

</body>
</html>
