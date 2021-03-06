<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Students List</title>
</head>

<body>

<cfif not isDefined("url.student_order")>
	<cfset url.student_order = "familylastname">
</cfif>

<cfif NOT isDefined("url.status")>
	<cfset url.status = "unplaced">
</cfif>

<!----International Rep---->
<cfquery name="int_Agent" datasource="caseusa">
	SELECT  u.userid, u.master_account
	FROM smg_users u
	LEFT JOIN smg_insurance_type insu ON insu.insutypeid = u.insurance_typeid
	WHERE u.userid = '#client.userid#'
</cfquery>

<!--- INTL AGENT --->
<cfif client.usertype NEQ '8' AND client.usertype NEQ '11'>
	You do not have rights to see the students.
	<cfabort>
</cfif>

<cfquery name="students" datasource="caseusa">
	SELECT  s.studentid, s.firstname, s.familylastname, s.sex, s.regionassigned, s.programid, s.dateapplication, s.regionguar,
			s.hostid, s.companyid, s.state_guarantee, s.uniqueid, s.branchid, s.host_fam_approved, s.dateplaced,
			smg_regions.regionname,
			smg_g.regionname as r_guarantee,
			c.countryname,
			co.companyshort,
			smg_states.state,
			h.familylastname as hostlastname,
			branch.businessname as branchname,
			office.businessname as officename, 
			p.programname
	FROM smg_students s
	INNER JOIN smg_companies co ON s.companyid = co.companyid		
	LEFT JOIN smg_programs P ON s.programid = p.programid
	LEFT JOIN smg_regions ON s.regionassigned = smg_regions.regionid
	LEFT JOIN smg_countrylist c ON c.countryid = s.countryresident
	LEFT JOIN smg_regions smg_g on s.regionalguarantee = smg_g.regionid
	LEFT JOIN smg_states ON s.state_guarantee = smg_states.id
	LEFT JOIN smg_hosts h ON s.hostid = h.hostid
	LEFT JOIN smg_users branch ON s.branchid = branch.userid
	LEFT JOIN smg_users office ON s.intrep = office.userid
	WHERE s.companyid = 10
		<cfif url.status EQ 'placed'>
			AND s.active = '1' 
			AND s.hostid != 0
			AND s.host_fam_approved <= '4'
		<cfelseif url.status EQ 'unplaced'>
			AND s.active = '1' 
			AND (s.hostid = '0' OR s.hostid != '0' AND s.host_fam_approved >= 5)
		<cfelseif url.status EQ 'inactive'>
			AND s.active = '0'
			AND s.canceldate IS NULL
		<cfelseif url.status EQ 'cancelled'>
			AND s.active = '0'
			AND s.canceldate IS NOT NULL
		</cfif>
		<cfif client.usertype EQ '8'>
			AND (s.intrep = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer"> OR office.master_accountid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">)
		<cfelse>
			AND s.branchid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
		</cfif>
	ORDER BY '#url.student_order#'	
</cfquery>

<style type="text/css">
<!--
div.scroll {
	height: 325px;
	width: 100%;
	overflow: auto;
	border-left: 1px solid #c6c6c6; 
	border-right: 1px solid #c6c6c6;
	background: #Ffffe6;
}
-->
</style>

<Cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Public High School Students</h2></td>
		<td background="pics/header_background.gif" align="right"><cfoutput><font size=-1>
			<!----<font size=-1>[ <a href="?curdoc=intrep/int_php_students">Private High School</a> ] &nbsp; &middot; &nbsp;---->
			[ 
			<cfif url.status EQ "placed"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=intrep/int_students&status=placed">Placed</a></span> &middot; 			
			<cfif url.status EQ "unplaced"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=intrep/int_students&status=unplaced">Unplaced</a></span> &middot; 
			<cfif url.status EQ "all"><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=intrep/int_students&status=all">All</a></span> &middot;
			<cfif url.status EQ "inactive"><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=intrep/int_students&status=inactive">Inactive</a></span> &middot;  
			<cfif url.status EQ "cancelled"><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=intrep/int_students&status=cancelled">Cancelled</a></span>  
			] 
			#students.recordcount# students displayed</cfoutput></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
	<tr><td width="3%"><a href="?curdoc=intrep/int_students&student_order=studentid&status=#url.status#">ID</a></td>
		<td width="10%"><a href="?curdoc=intrep/int_students&student_order=familylastname&status=#url.status#">Last Name</a></td>
		<td width="10%"><a href="?curdoc=intrep/int_students&student_order=firstname&status=#url.status#">First Name</a></td>
		<td width="5%"><a href="?curdoc=intrep/int_students&student_order=sex&status=#url.status#">Sex</a></td>
		<td width="8%"><a href="?curdoc=intrep/int_students&student_order=country&status=#url.status#">Country</a></td>
		<td width="8%"><a href="?curdoc=intrep/int_students&student_order=regionname&status=#url.status#">Region</a></td>
		<td width="8%"><a href="?curdoc=intrep/int_students&student_order=programid&status=#url.status#">Program</a></td>
		<cfif url.status NEQ "unplaced">
			<Td width="10%"><a href="?curdoc=intrep/int_students&student_order=hostid&status=#url.status#">Family</a></td>
			<Td width="8%"><a href="?curdoc=intrep/int_students&student_order=dateplaced&status=#url.status#">Place Date</a></td>
		</cfif>
		<td width="8%"><a href="?curdoc=intrep/int_students&student_order=companyshort&status=#url.status#">Company</a></td>
		<cfif int_Agent.master_account EQ '0'>
		<td width="10%"><a href="?curdoc=intrep/int_students&student_order=branchname&status=#url.status#">Branch</a></td>
		<cfelse>
		<td width="10%"><a href="?curdoc=intrep/int_students&student_order=officename&status=#url.status#">Office</a></td>
		</cfif>
		<td width="2%">&nbsp;</td>
	</tr>
</table>

<div class="scroll">
<table width=100%>
<cfloop query="students">

<cfset urllink="index.cfm?curdoc=intrep/int_student_info&unqid=#uniqueid#"> <!--- PUBLIC STUDENTS  --->

<Cfif #dateapplication# gt #client.lastlogin#>
	<tr bgcolor="##e2efc7">
<cfelse>
	<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
</cfif>
		<td width="3%"><a href='#urllink#'>#Studentid#</a></td>
		<td width="10%"><a href='#urllink#'><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif></a></td>
		<td width="10%"><a href='#urllink#'>#firstname#</a></td>
		<td width="5%">#sex#</td>
		<td width="8%"><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
		<td width="8%">#students.regionname# 
			<cfif students.regionguar is 'yes'>
				<font color="CC0000">
					<cfif r_guarantee is '' and state_guarantee EQ 0>
						* Missing
					</cfif>
					<cfif r_guarantee is not ''>
						* #r_guarantee#
					<cfelseif students.state_guarantee NEQ 0>
						* #students.state#
					</cfif>
				</font>
			</cfif>
		</td>
		<td width="8%">#programname#</td>
		<cfif url.status NEQ "unplaced">
			<td width="10%"><cfif hostid NEQ '0' AND host_fam_approved LTE '4'>#hostlastname#</cfif></td>
			<Td width="8%"><cfif hostid NEQ '0' AND host_fam_approved LTE '4' AND dateplaced NEQ ''>#DateFormat(dateplaced, 'mm/dd/yy')#</cfif></td>
		</cfif>
		<td width="8%">#companyshort#</td>
		<cfif int_Agent.master_account EQ '0'>
		<td width="12%"><cfif branchid EQ '0'>Main Office<cfelse>#branchname#</cfif></td>
		<cfelse>
		<td width="12%">#officename#</td>
		</cfif>
	</tr>
</cfloop>
</table>
</div>
<table width=100% bgcolor="##ffffe6" class="section">
	<tr>
		<td>Students in Green have been added since your last vist.</td><td align="center"><font color="##CC0000">* Regional or State Guarantee</font></td><td align="right">CTRL-F to search</td>
	</tr>
</table>

</cfoutput>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

</body>
</html>