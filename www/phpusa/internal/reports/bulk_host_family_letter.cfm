<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Host Family Welcome Letter</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfif NOT IsDefined('form.programid')>
	YOU MUST SELECT A PROGRAM IN ORDER TO CONTINUE.
	<cfabort>
</cfif>

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_students" datasource="MySql">
	SELECT 	DISTINCT php.studentid,
			s.firstname, s.familylastname, s.sex, 
			h.address, h.address2, h.city, h.zip, h.state, h.familylastname as hostlastname,
			u.businessname, u.userid,
			c.companyname, c.companyshort,
			p.programid, p.programname, p.startdate, p.enddate,
			country.countryname
	FROM php_students_in_program php
	INNER JOIN smg_students s ON php.studentid = s.studentid
	INNER JOIN smg_programs p ON php.programid = p.programid
	INNER JOIN smg_hosts h ON php.hostid = h.hostid 
	INNER JOIN smg_companies c ON php.companyid = c.companyid
	INNER JOIN smg_users u ON s.intrep = u.userid
	LEFT JOIN smg_countrylist country ON country.countryid = s.countryresident
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

<cfoutput>

<cfloop query="get_students">
<cfquery name="school_id" datasource="mysql">
select schoolid 
from php_students_in_program
where studentid = #get_students.studentid#
</cfquery>
<cfquery name="season_id" datasource="mysql">
select max(seasonid) as seasonid
from php_school_dates
where schoolid = #school_id.schoolid#

</cfquery>
<cfquery name="school_dates" datasource="mysql">
select max(seasonid) as seasonid, year_begins, semester_ends, semester_begins, year_ends
from php_school_dates
where schoolid = #school_id.schoolid# and seasonid = #season_id.seasonid#
group by seasonid
</cfquery>
<!--- Page Header --->
<table width="660" align="center" border=0 bgcolor="##FFFFFF" cellpadding="2" style="font-size:13px"> 
	<tr>
		<td><img src="../pics/dmd-logo.jpg"></td>
		<td align="right" > 
			<b>#companyshort.companyname#</b><br>
			#companyshort.address#<br>
			#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
			<cfif companyshort.phone NEQ ''> Phone: #companyshort.phone#<br></cfif>
			<cfif companyshort.toll_free NEQ ''> Toll Free: #companyshort.toll_free#<br></cfif>
			<cfif companyshort.fax NEQ ''> Fax: #companyshort.fax#<br></cfif>
		</td>
	</tr>
	<tr><td colspan="2"><hr width=100% align="center"></td></tr>	
</table>

<table width="660" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr>
		<td align="left">The #get_students.hostlastname# Family<br>
			#get_students.address#<br>
			<Cfif get_students.address2 NEQ ''>#get_students.address2#<br></Cfif>
			#get_students.city#, #get_students.state# #get_students.zip#
		</td>
		<td align="right">
			Program: #get_students.programname#<br>
			From: From:
            <cfif #DateFormat(get_students.startdate,'mm')# lt 6>
            #DateFormat(school_dates.semester_begins,'mmm. d, yyyy')# 
            <cfelse>
            #DateFormat(school_dates.year_begins,'mmm. d, yyyy')# 
            </cfif>
            thru 
            <cfif #DateFormat(get_students.enddate,'mm')# lt 6>
            #DateFormat(school_dates.year_ends,'mmm. d, yyyy')#
            <cfelse>
            #DateFormat(school_dates.semester_ends,'mmm. d, yyyy')#
            </cfif><br><br>
		</td>
	</tr>
</table><br><br>
	
<table width="660" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr>	
		<td>
			<div align="justify">
			Dear #get_students.hostlastname# Family,
		
			<p>Welcome to the DMD Private High School Program!</p>

			<p>I would like to begin by thanking you for opening you heart and home to 
			#get_students.firstname# #get_students.familylastname# from #get_students.countryname#. 
			I hope that your hosting experience will be enjoyable and memorable.</p>
			
			<p>Enclosed, you will find your DMD arrival folder. This folder has been created to help you prepare the arrival of 
			your international student and to familiarize you with DMD's Private High School Program. Inside, you will find a 
			DMD Host Family Handbook that explains DMD's expectations and program rules. This Handbook also offers advice for 
			different situations that may arise during your hosting experience. Please read your Handbook carefully and use it as
			a guide whenever possible.</p>
			
			<p>We suggest that you contact the student before 
			<cfif get_students.sex EQ 'male'>he<cfelseif get_students.sex EQ 'female'>she<cfelse>he or she</cfif> arrives. 
			Not only will such communication relieve your anxieties, but it will also do wonders to relieve your student and his or her
			parents' anxieties. Your initial contact will also give you the opportunity to re-confirm your student's arrival information.</p>

			<p>The DMD office is in constant communication with your local representatives regarding your student's flight information. 
			As soon as DMD receives your student's flight details we will forward this information to you via fax, phone or post. 
			In most cases the DMD local contact person will be giving this information directly to your local representative.</p>

			<p>Also included in your family's arrival folder, are numerous flyers that will help you prepare, organize and learn about your
			international student before <cfif get_students.sex EQ 'male'>he<cfelseif get_students.sex EQ 'female'>she<cfelse>he or she</cfif> 
			arrives! Please take a few minutes to review all materials.</p>

			<p>If you should have any questions regarding your arrival folder, please feel free to contact DMD. 
			I will be happy to answer any questions or address any concerns you may have.</p>

			<p>Thank you again.</p>
			</div>
		</td>
	</tr>
</table>

<!--- PAGE BOTTON --->	
<table width="660" align="center" border=0 cellpadding="1" cellspacing="1" style="font-size:13px">
	<tr><td>Best Regards,</td></tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td><img src="../pics/lukesign.jpg" border="0"></td></tr>
	<tr><td>Luke Davis</td></tr>
	<tr><td>Program Director</td></tr>	
	<tr><td>#companyshort.companyname#</td></tr>			
</table><br />
<div style="page-break-after:always;"></div><br>

</cfloop>

</cfoutput>
</body>
</html>