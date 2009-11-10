<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>
<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="ffffff">
	<tr>
		<td bordercolor="FFFFFF">


		<!----Header Table---->
		<table width="95%" cellpadding="0" cellspacing="0" border="0" align="center" height="25" bgcolor="E4E4E4">
			<tr bgcolor="E4E4E4">
				<td class="title1">&nbsp; &nbsp; Search Candidate </td>
			</tr>
		</table>

		<br />
		
		<form id="form" name="form" method="post" action="?curdoc=candidate/search&search=1&status=All">
		<table width="770" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="C7CFDC" bgcolor="ffffff">	
			<tr>
				<td align="center" class="style1">
				
					<input name="search" type="text" />&nbsp; on field &nbsp; 
					<select name="field">
						<option value="firstname" selected="selected">First Name</option>
						<option value="lastname">Last Name</option>
						<option value="candidateid">ID</option>
						<option value="degree">Degree</option>
						<option value="email">Email</option>
						<option value="dob">Date of Birth</option>
					</select>&nbsp; &nbsp;
					<input type="submit" name="Submit" value="Search" />
				</td>
				<td>
			</tr>
		</table>
		</form>
		
		<cfif url.search EQ '1'>
		
			<cfquery name="candidates" datasource="MySql">
				SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.sex, extra_candidates.home_country, extra_candidates.candidateid, extra_candidates.programid,
				extra_candidates.intrep, extra_candidates.uniqueid, smg_countrylist.countryname, smg_programs.programname, smg_users.businessname
				FROM extra_candidates
				LEFT JOIN smg_countrylist ON smg_countrylist.countryid = extra_candidates.home_country 
				LEFT JOIN smg_programs ON smg_programs.programid = extra_candidates.programid 
				LEFT JOIN smg_users ON smg_users.userid = extra_candidates.intrep 	
				WHERE extra_candidates.companyid = '#client.companyid#' 
				AND extra_candidates.#form.field#  = '#form.search#'
				ORDER BY lastname
			</cfquery>

		<cfoutput>
		
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
			<tr>
				<th width="30"  bgcolor="4F8EA4" align="left"><font class="style2">ID</font></th>
				<th width="110" bgcolor="4F8EA4" align="left"><font class="style2">First Name</font></th>
				<th width="110" bgcolor="4F8EA4" align="left"><font class="style2">Last Name</font></th>
				<th width="50"  bgcolor="4F8EA4" align="left"><font class="style2">Sex</font></th>
				<th width="150" bgcolor="4F8EA4" align="left"><font class="style2">Country</font></th>
				<th width="100" bgcolor="4F8EA4" align="left"><font class="style2">Program</font></th>
				<th width="150" bgcolor="4F8EA4" align="left"><font class="style2">Intl. Rep.</font></th>
			</tr>
		<cfloop query="candidates">
			<tr bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
					<div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#candidateid#</a></div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
					<div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#firstname#</a></div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
					<div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#lastname#</a></div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left"><cfif sex EQ 'm'>Male<cfelse>Female</cfif></div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#countryname#</div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#programname#</div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#businessname#</div></td>
			</tr>
			</cfloop>
			<cfif candidates.recordcount EQ 0>
			<tr>
				<td colspan="7" class="style1">
				Not founded!
				</td>
			</tr>
			</cfif>
		</table>
		<br><br>
		</cfoutput>
		</cfif>

		</td>
	</tr>
</table>
<body>
</body>
</html>
