<!--- ------------------------------------------------------------------------- ----
	
	File:		bulk_host_family_letter.cfm
	Author:		Marcus Melo
	Date:		December 20, 2010
	Desc:		Bulk Host Family Letter

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- FORM Variables --->
    <cfparam name="FORM.programid" default="0">
    <cfparam name="FORM.insurance_typeid" default="0">
    <cfparam name="FORM.date1" default="">
    <cfparam name="FORM.date2" default="">
    <cfparam name="FORM.intrep" default="0">

    <cfinclude template="../querys/get_company_short.cfm">
    
    <cfquery name="qGetStudents" datasource="MySql">
        SELECT DISTINCT 
            php.studentid,
            php.schoolID,
            s.firstname, 
            s.familylastname, 
            s.sex, 
            h.address, 
            h.address2, 
            h.city,         
            h.state, 
            h.zip, 
            h.familylastname as hostlastname,
            u.userid,
            u.businessname, 
            c.companyname, 
            c.companyshort,
            p.programid, 
            p.programname, 
            p.startdate, 
            p.enddate, 
            p.type,
            country.countryname,
            sd.year_begins, 
            sd.semester_ends, 
            sd.semester_begins, 
            sd.year_ends        
        FROM 
            php_students_in_program php
        INNER JOIN 
            smg_students s ON php.studentid = s.studentid
        INNER JOIN 
            smg_programs p ON php.programid = p.programid
        INNER JOIN 
            smg_hosts h ON php.hostid = h.hostid 
        INNER JOIN 
            smg_companies c ON php.companyid = c.companyid
        INNER JOIN 
            smg_users u ON s.intrep = u.userid
        LEFT OUTER JOIN 
            smg_countrylist country ON country.countryid = s.countryresident
        LEFT OUTER JOIN
            php_school_dates sd ON sd.schoolID = php.schoolID AND sd.seasonID = p.seasonID
        WHERE 
            php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND
            php.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
        <cfif VAL(FORM.insurance_typeid)>
            AND 
                u.insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.insurance_typeid#">
        </cfif>
        <cfif IsDate(FORM.date1) AND IsDate(FORM.date2)>
            AND 
                php.hf_placement BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(DateAdd('d', 1, FORM.date2))#
        </cfif>
        <cfif VAL(FORM.intrep)>
            AND 
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
        </cfif>
        GROUP BY 
            php.studentid
        ORDER BY 
            h.familylastname, 
            s.familylastname, 
            s.firstname	
    </cfquery>
    
        <!--- PROGRAM TYPES
        1 AYP 10 months
        2 AYP 12 months
        3 AYP 1st semester
        4 AYP 2nd semester
        --->
    
</cfsilent>    

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Host Family Welcome Letter</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<!--- Data Validation --->
<cfif NOT VAL(FORM.programid)>
	Please select at least one program.
	<cfabort>
</cfif>

<cfif LEN(FORM.date1) AND NOT IsDate(FORM.date1)>
	Please enter a valid start date.
	<cfabort>
</cfif>

<cfif LEN(FORM.date2) AND NOT IsDate(FORM.date2)>
	Please enter a valid end date.
	<cfabort>
</cfif>

<cfoutput query="qGetStudents">

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
		<td align="left">The #qGetStudents.hostlastname# Family<br>
			#qGetStudents.address#<br>
			<Cfif qGetStudents.address2 NEQ ''>#qGetStudents.address2#<br></Cfif>
			#qGetStudents.city#, #qGetStudents.state# #qGetStudents.zip#
		</td>
		<td align="right">
			Program: #qGetStudents.programname#<br>
            From: 
            <cfif qGetStudents.type EQ 4>
                #DateFormat(qGetStudents.semester_begins, 'mmm. d, yyyy')#
            <cfelse>
                #DateFormat(qGetStudents.year_begins, 'mmm. d, yyyy')#
            </cfif>		
            thru
            <cfif qGetStudents.type EQ 3>
                #DateFormat(qGetStudents.semester_ends, 'mmm. d, yyyy')#
            <cfelse>
                #DateFormat(qGetStudents.year_ends, 'mmm. d, yyyy')#
            </cfif>						
			<br><br>
		</td>
	</tr>
</table><br><br>
	
<table width="660" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr>	
		<td>
			<div align="justify">
			Dear #qGetStudents.hostlastname# Family,
		
			<p>Welcome to the DMD Private High School Program!</p>

			<p>I would like to begin by thanking you for opening you heart and home to 
			#qGetStudents.firstname# #qGetStudents.familylastname# from #qGetStudents.countryname#. 
			I hope that your hosting experience will be enjoyable and memorable.</p>
			
			<p>Enclosed, you will find your DMD arrival folder. This folder has been created to help you prepare the arrival of 
			your international student and to familiarize you with DMD's Private High School Program. Inside, you will find a 
			DMD Host Family Handbook that explains DMD's expectations and program rules. This Handbook also offers advice for 
			different situations that may arise during your hosting experience. Please read your Handbook carefully and use it as
			a guide whenever possible.</p>
			
			<p>We suggest that you contact the student before 
			<cfif qGetStudents.sex EQ 'male'>he<cfelseif qGetStudents.sex EQ 'female'>she<cfelse>he or she</cfif> arrives. 
			Not only will such communication relieve your anxieties, but it will also do wonders to relieve your student and his or her
			parents' anxieties. Your initial contact will also give you the opportunity to re-confirm your student's arrival information.</p>

			<p>The DMD office is in constant communication with your local representatives regarding your student's flight information. 
			As soon as DMD receives your student's flight details we will forward this information to you via fax, phone or post. 
			In most cases the DMD local contact person will be giving this information directly to your local representative.</p>

			<p>Also included in your family's arrival folder, are numerous flyers that will help you prepare, organize and learn about your
			international student before <cfif qGetStudents.sex EQ 'male'>he<cfelseif qGetStudents.sex EQ 'female'>she<cfelse>he or she</cfif> 
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

</cfoutput>
</body>
</html>