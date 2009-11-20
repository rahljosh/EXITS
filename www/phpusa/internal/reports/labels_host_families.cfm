<!--- Generate Avery Standard 5160 labels for our contacts. --->

<cfif NOT IsDefined('form.programid')>
	YOU MUST SELECT A PROGRAM IN ORDER TO CONTINUE.
	<cfabort>
</cfif>

<html>

	<head>
<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.4in 13.6pt 0in 13.6pt;
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
	
	
			<!--- Start a table for our labels --->
			<table border="0" cellspacing="0" cellpadding="0">

			<cfquery name="get_students" datasource="MySql"> 
				SELECT 	DISTINCT php.studentid, 
						h.address, h.address2, h.city, h.zip, h.state, h.familylastname as hostname,
						u.businessname, u.userid,
						c.companyname, c.companyshort,
						p.programname, p.programid
				FROM php_students_in_program php
				INNER JOIN smg_students s ON php.studentid = s.studentid
				INNER JOIN smg_programs p ON php.programid = p.programid
				INNER JOIN smg_hosts h ON php.hostid = h.hostid 
				INNER JOIN smg_companies c ON php.companyid = c.companyid
				INNER JOIN smg_users u ON s.intrep = u.userid
				WHERE php.active = '1'
					<cfif form.insurance_typeid NEQ 0>AND u.insurance_typeid = '#form.insurance_typeid#'</cfif>
					<cfif form.date1 NEQ '' AND form.date2 NEQ ''>
						AND php.hf_placement between #CreateODBCDate(form.date1)# and #CreateODBCDate(DateAdd('d', 1, form.date2))#
					</cfif>
					<cfif form.intrep NEQ '0'>AND s.intrep = '#form.intrep#'</cfif>
					AND ( <cfloop list="#form.programid#" index="prog">php.programid = #prog#
							<cfif prog is #ListLast(form.programid)#><Cfelse>or </cfif></cfloop> )							
				GROUP BY php.studentid
				ORDER BY h.familylastname, s.familylastname, s.firstname
			</cfquery>
						
			<!--- The table consists has five columns, two lablels and two spacers, interchanged.
				  To identify where to place each, we need to maintain a column counter. --->
			<cfset col=1>
			<cfoutput query="get_students">
				<!--- If this is the first column, then start a new row --->
				<cfif col EQ "1">
					<tr>
				</cfif>
				
				<!--- Output the label --->
				<td class="label">
					<p>The #hostname# Family</p>
					<p><cfif address2 NEQ ''>#address2#<cfelse>#address#</cfif></p>
					<p>#city#, #state# #zip#</p>
				</td>
				<!--- if this is column 1 or 2, then output a spacer cell and increment the column number. --->
				<cfif col LTE 2>

					<td class="spacer">
					<p>&nbsp;</p>
					</td>
					<cfset col=col+1>
	
				<!--- If it's column 3, then end the row and reset the column number. --->
				<cfelse>
					</tr>
					<cfset col=1>
				</cfif>

			</cfoutput>
			
			<!--- If we didn't end on column 3, then we have to output blank labels --->
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

<!--- Tell the browser this is a word document --->
<cfheader name="Content-Type" value="application/msword">

<!--- Tell the browser this is an attachment and provide a filename. --->
<cfheader name="Content-Disposition" value="attachment; filename=hostfamily_labels.doc">
