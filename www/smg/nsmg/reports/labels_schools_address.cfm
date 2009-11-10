<!---
			Generate Avery Standard 5160
			labels for our contacts.
			--->
<html>

	<head>
<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:.5in 13.6pt 0in 13.6pt;
	}
	div.Section1 {
		page:Section1;
	}
	table {
		mso-table-layout-alt:fixed;
		mso-padding-top-alt:0in;
		mso-padding-bottom-alt:0in
	}
	tr {
		page-break-inside:avoid;
		height:1.0in;
	}	
	td {
		padding-top:0in;
		padding-right:.75pt;
		padding-bottom:0in;
		padding-left:.75pt;
	}
	td.label {
		width:189.0pt;
	} 
	td.spacer {
		width:9.0pt;
	}
	p {
		margin-top:0in;
		margin-right:5.3pt;
		margin-bottom:0in;
		margin-left:5.3pt;
		mso-pagination:widow-orphan;
		font-size:11.0pt;
		font-family:"Arial";
	}
</style>
	
	</head>
	
	<body>
	
		<div class="Section1">
	
	
			<!---
						Start a table for our labels
						--->
			<table 
				border="0" 
				cellspacing="0" 
				cellpadding="0">
			<!---
						Get names, addresses from our database
						--->
			
			<cfquery name="get_schools" datasource="MySql"> 
	SELECT s.studentid, s.familylastname, s.firstname, s.arearepid, s.regionassigned, s.hostid, s.dateplaced, 
		s.schoolid, s.grades, s.countryresident, s.sex, s.dateplaced,
		h.hostid, h.familylastname AS h_lastname, h.address AS h_address, h.address2 AS h_address2, h.city AS h_city, h.state AS h_state, h.zip AS h_zip, h.phone as h_phone,
		sc.schoolid, sc.schoolname, sc.principal, sc.address AS sc_address, sc.address2 AS sc_address2, sc.city AS sc_city, sc.state AS sc_state, sc.zip AS sc_zip, sc.phone AS sc_phone,
		ar.userid, ar.lastname AS ar_lastname, ar.firstname AS ar_firstname, ar.address AS ar_address, ar.address2 AS ar_address2, ar.city AS ar_city, 
		ar.state AS ar_state, ar.zip AS ar_zip, ar.phone AS ar_phone,
		c.countryname,
		p.programname, p.startdate, p.enddate
	FROM smg_students s
	INNER JOIN smg_hosts h ON s.hostid = h.hostid
	INNER JOIN smg_schools sc ON s.schoolid = sc.schoolid
	INNER JOIN smg_users ar ON s.arearepid = ar.userid
	INNER JOIN smg_countrylist c ON c.countryid = s.countryresident
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.active = '1'
		AND s.hostid != '0'
		AND s.host_fam_approved <= '4'
		<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
			AND (s.dateplaced between #CreateODBCDateTime(form.date1)# AND #CreateODBCDateTime(form.date2)#) 
		</cfif>
		AND (<cfloop list="#form.programid#" index="prog">
				s.programid = '#prog#' 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	ORDER BY s.familylastname, s.firstname	
</cfquery>
			<!---
						The table consists has five columns,
						two lablels and two spacers, interchanged.
						
						To identify where to place each, we need to
						maintain a column counter.
						--->
			<cfset col=1>
			<cfoutput query="get_schools">
				
				
				<!---
							If this is the first column, 
							then start a new row
							--->
				<cfif col EQ "1">
					<tr>
				</cfif>
				
				<!---
							Output the label
							--->
				<td class="label">
					<p>#schoolname#</p>
					<p>#principal#</p>
					<p><cfif sc_address is ''>#sc_address2#<cfelse>#sc_address#</cfif></p>
					<p>#sc_city# #sc_state#  #sc_zip#</p>
				</td>
				
				<!---
							If this is column 1 or 2, then
							output a spacer cell and 
							increment the column number.
							--->
				<cfif col LTE 2>

					<td class="spacer">
					<p>&nbsp;</p>
					</td>

					<cfset col=col+1>
	
	
				<!---
							If it's column 3, then end the
							row and reset the column number.
							--->
				<cfelse>

					</tr>
					<cfset col=1>
					
				</cfif>

			</cfoutput>


			<!---
						If we didn't end on column 3, then we have
						to output blank labels
						--->
			<cfif col EQ "2">

				<td class="label">
					<p>&nbsp;</p>
				</td>
				<td class="spacer">
					<p>&nbsp;</p>
				</td>
				<td class="label">
					<p>&nbsp;</p>
				</td>
				</tr>
				
			<cfelseif col EQ "3">

				<td class="label">
					<p>&nbsp;</p>
				</td>
				</tr>
				
			</cfif>
			
			</table>
	
		</div>
	
	</body>

</html>


<!---
			Tell the browser this is a word document
			--->
<cfheader 
	name="Content-Type" 
	value="application/msword">


<!---
			Tell the browser this is an attachment and
			provide a filename.
			--->
<cfheader 
	name="Content-Disposition" 
	value="attachment; filename=SchoolMailingLables.doc">