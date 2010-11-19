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
	
    <cfquery name="get_candidates" datasource="MySql"> 
				SELECT 	s.candidateid, s.lastname, s.firstname, s.home_city, s.home_zip, s.entrydate, s.active,
						p.programname, p.programid, 
						u.businessname, u.userid,
					<!---	r.regionid, r.regionname,---->
						c.companyshort, c.companyid
				FROM extra_candidates s
				INNER JOIN smg_programs p ON s.programid = p.programid 
				INNER JOIN smg_users u ON s.intrep = u.userid
				INNER JOIN smg_companies c ON s.companyid = c.companyid
				<!---LEFT JOIN smg_regions r ON s.regionassigned = r.regionid--->
						WHERE s.companyid = #client.companyid# 
						AND s.candidateid between '#form.id1#' AND '#form.id2#'
						AND s.active = '1'
						<!---<cfif form.programid is 0><cfelse>AND s.programid = '#form.programid#'</cfif>--->
                        <cfif form.programid2 NEQ 0>AND s.programid = #form.programid#</cfif>
				ORDER BY s.candidateid
			</cfquery>
            
            		
	<!----		<cfquery name="get_students" datasource="MySql"> 
				SELECT 	s.studentid, s.familylastname, s.firstname, s.city, s.zip, s.dateapplication, s.active,
						p.programname, p.programid, 
						u.businessname, u.userid,
						r.regionid, r.regionname,
						c.companyshort, c.companyid
				FROM smg_students s
				INNER JOIN smg_programs p ON s.programid = p.programid
				INNER JOIN smg_users u ON s.intrep = u.userid
				INNER JOIN smg_companies c ON s.companyid = c.companyid
				LEFT JOIN smg_regions r ON s.regionassigned = r.regionid
				WHERE   s.companyid = #client.companyid# 
						AND s.studentid between '#form.id1#' AND '#form.id2#'
						AND s.active = '1'				
						<cfif form.programid is 0><cfelse>AND s.programid = '#form.programid#'</cfif>	
				ORDER BY s.studentid
			</cfquery> ---->
						
			<!---
						The table consists has five columns,
						two lablels and two spacers, interchanged.
						
						To identify where to place each, we need to
						maintain a column counter.
						--->
			<cfset col=1>
			<cfoutput query="get_candidates">
				
				
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
					<p>#lastname#, #firstname# (#candidateid#)</p>
					<p>#companyshort# - #programname#</p>
					<p>#businessname#</p>
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
	value="attachment; filename=Labelsforfiling.doc">
