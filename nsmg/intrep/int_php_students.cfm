<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>PHP Students List</title>
<style type="text/css">
<!--
div.scroll {
	height: 360px;
	width: 100%;
	overflow: auto;
	border-left: 1px solid #c6c6c6; 
	border-right: 1px solid #c6c6c6;
	background: #Ffffe6;
}
-->
</style>
</head>

<body>

<cfif not isDefined("url.student_order")>
	<cfset url.student_order = "familylastname">
</cfif>

<cfif not isDefined("url.placed")>
	<cfset url.placed = "no">
</cfif>

<!----International Rep---->
<cfquery name="int_Agent" datasource="MySQL">
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

<!--- PHP STUDENTS --->
<cfquery name="php_students" datasource="MySql">
	SELECT s.firstname, s.familylastname, s.sex, s.country, s.studentid, s.uniqueid, s.branchid,
		stu_prog.programid, stu_prog.hostid, stu_prog.schoolid, stu_prog.datecreated,
		co.companyshort,
		smg_countrylist.countryname, 
		smg_programs.programname,
		sc.schoolname,
		stu_prog.datecreated,
		branch.businessname as branchname,
		office.businessname as officename
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	INNER JOIN smg_companies co ON stu_prog.companyid = co.companyid
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = s.country  
	LEFT JOIN smg_programs ON smg_programs.programid = stu_prog.programid 
	LEFT JOIN php_schools sc ON sc.schoolid = stu_prog.schoolid
	LEFT JOIN smg_users branch ON s.branchid = branch.userid
	LEFT JOIN smg_users office ON s.intrep = office.userid	
	WHERE stu_prog.companyid = '6' 
		  AND stu_prog.active = '1'
		<cfif url.placed EQ 'no'>
			AND stu_prog.schoolid = '0'
		<cfelseif url.placed EQ 'yes'>
			AND stu_prog.schoolid != '0'	
		</cfif>
		<cfif client.usertype EQ '8'>
			AND (s.intrep = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer"> OR office.master_accountid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">)
		<cfelse>
			AND s.branchid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
		</cfif>	
	ORDER BY '#url.student_order#' 
</cfquery>

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Private High School Students </td>
		<td background="pics/header_background.gif" align="right"><cfoutput>
			<font size=-1>[ <a href="?curdoc=intrep/int_students">Public High School</a> ] &nbsp; &middot; &nbsp;
			[ 
			<cfif url.placed is "yes"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>	<cfif IsDefined('get_user_region.usertype') AND get_user_region.usertype is '9'><cfelse><a href="?curdoc=intrep/int_php_students&placed=yes">placed</a></span> &middot; </cfif> 			
			<cfif url.placed is "no"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>    <a href="?curdoc=intrep/int_php_students&placed=no">unplaced</a></span>  
			<cfif url.placed is "all"><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif>   <cfif IsDefined('get_user_region.usertype') AND get_user_region.usertype is '9'><cfelse> &middot; <a href="?curdoc=intrep/int_php_students&placed=all">all</a></span></cfif>
			] #php_students.recordcount# students displayed</cfoutput></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
	<tr><td width="20"><a href="?curdoc=intrep/int_php_students&student_order=studentid&placed=#url.placed#">ID</a></td>
		<td width="80"><a href="?curdoc=intrep/int_php_students&student_order=familylastname&placed=#url.placed#">Last Name</a></td>
		<td width="80"><a href="?curdoc=intrep/int_php_students&student_order=firstname&placed=#url.placed#">First Name</a></td>
		<td width="40"><a href="?curdoc=intrep/int_php_students&student_order=sex&placed=#url.placed#">Sex</a></td>
		<td width="60"><a href="?curdoc=intrep/int_php_students&student_order=country&placed=#url.placed#">Country</a></td>
		<td width="60"><a href="?curdoc=intrep/int_php_students&student_order=programid&placed=#url.placed#">Program</a></td>
		<cfif url.placed NEQ "no">
			<Td width="80"><a href="?curdoc=intrep/int_php_students&student_order=hostid&placed=#url.placed#">School</a></td>
		</cfif>
		<td width="40"><a href="?curdoc=intrep/int_php_students&student_order=companyshort&placed=#url.placed#">Company</a></td>
		<cfif int_Agent.master_account EQ '0'>
		<td width="60"><a href="?curdoc=intrep/int_php_students&student_order=branchname&placed=#url.placed#">Branch</a></td>
		<cfelse>
		<td width="60"><a href="?curdoc=intrep/int_php_students&student_order=officename&placed=#url.placed#">Office</a></td>
		</cfif>
		<td width="20">&nbsp;</td></td>
	</tr>
</table>

<div class="scroll">
<table width=100%>
<cfloop query="php_students">

	<cfset urllink="index.cfm?curdoc=intrep/int_student_info_php&unqid=#uniqueid#"> <!--- PHP STUDENTS --->
	
	<Cfif datecreated GT client.lastlogin>
		<tr bgcolor="##e2efc7">
	<cfelse>
		<tr bgcolor="#iif(php_students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
	</cfif>
			<td width="20"><a href='#urllink#'>#Studentid#</a></td>
			<td width="80"><a href='#urllink#'><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif></a></td>
			<td width="80"><a href='#urllink#'>#firstname#</a></td>
			<td width="40">#sex#</td>
			<td width="60"><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
			<td width="60">#programname#</td>
			<cfif url.placed NEQ "no">
				<td width="60"><cfif schoolid NEQ '0'>#schoolname#</cfif></td>
			</cfif>
			<td width="40">#companyshort#</td>
			<cfif int_Agent.master_account EQ '0'>
			<td width="60"><cfif branchid EQ '0'>Main Office<cfelse>#branchname#</cfif></td>
			<cfelse>
			<td width="60">#officename#</td>
			</cfif>
			<td width="20">&nbsp;</td>
		</tr>
</cfloop>
</table>
</div>
<table width=100% bgcolor="ffffe6" class="section">
	<tr>
		<td>Students in Green have been added since your last vist.</td><td align="center"><font color="CC0000">* Regional or State Guarantee</font></td><td align="right">CTRL-F to search</td>
	</tr>
</table>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table><br />

</cfoutput>

</body>
</html>
