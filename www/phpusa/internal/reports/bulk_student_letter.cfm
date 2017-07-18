<!--- ------------------------------------------------------------------------- ----
	
	File:		bulk_student_letter.cfm
	Author:		Marcus Melo
	Date:		December 20, 2010
	Desc:		Bulk Student Letter

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
            s.studentid,
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
            php.schoolID,
            sc.schoolName,
            sd.year_begins, 
            sd.semester_ends, 
            sd.semester_begins, 
            sd.year_ends        
        FROM 
        	smg_students s 
        INNER JOIN 
            php_students_in_program php ON php.studentid = s.studentid
        INNER JOIN 
            smg_programs p ON php.programid = p.programid
        INNER JOIN 
            smg_companies c ON php.companyid = c.companyid
        LEFT OUTER JOIN
            smg_hosts h ON php.hostid = h.hostid 
		LEFT OUTER JOIN 
        	php_schools sc ON php.schoolid = sc.schoolid         
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
      	AND
        	php.return_student = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            
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
<title>Bulk Student Letter</title>
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

<cfif NOT VAL(qGetStudents.recordcount)>
    No records were found that match your criteria.<br />
    Please use your browser's back button to select different criteria and resubmit.
	<cfabort>    
</cfif>

<cfif NOT VAL(qGetStudents.recordcount)>
    No records were found that match your criteria.<br />
    Please use your browser's back button to select different criteria and resubmit.
	<cfabort>    
</cfif>

<cfoutput>

<cfloop query="qGetStudents">

		<!--- Page Header --->
        <table width="660" align="center" border=0 bgcolor="##FFFFFF" cellpadding="2" style="font-size:13px"> 
            <tr>
                <td valign="top"><img src="../pics/dmd-logo.jpg"></td>
                <td align="right" > 
                    <b>#companyshort.companyname#</b><br />
                    #companyshort.address#<br />
                    #companyshort.city#, #companyshort.state# #companyshort.zip#<br /><br />
                    <cfif companyshort.phone NEQ ''> Phone: #companyshort.phone#<br /></cfif>
                    <cfif companyshort.toll_free NEQ ''> Toll Free: #companyshort.toll_free#<br /></cfif>
                    <cfif companyshort.fax NEQ ''> Fax: #companyshort.fax#<br /></cfif>
                </td>
            </tr>
            <tr><td colspan="2"><hr width=100% align="center"></td></tr>	
        </table>
        
        <table width="660" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
            <tr><td align="right">#DateFormat(now(), 'dddd, mmmm d, yyyy')#</td></tr>
            <tr><td align="right">School: #qGetStudents.schoolname#</td></tr>
            <tr>
                <td align="right">
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
                </td>
            </tr>	
        </table><br /><br />
            
        <table width="660" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
            <tr>	
                <td style="text-align:justify;">
                    <p>Dear #qGetStudents.firstname# #qGetStudents.familylastname# (###qGetStudents.studentid#).
            
                    <p>On behalf of everyone at DMD, I would like to take this opportunity to welcome you to this exciting, 
                    challenging and rewarding program.</p>
                    
                    <p>Everyone involved with our Private High School Program wants to assure you that we have worked hard to make sure that this
                    experience will be memorable and beneficial. We are here to assist you in any way possible throughout your stay. 
                    Your school is #qGetStudents.schoolname# and they are very eager to greet you and ensure that your stay goes well.</p>
                    
                    <p>We take our mission statement, "Educating Tomorrow's Leaders" very seriously. Our staff is always available to you. 
                    We are fully aware that your experience requires careful planning as well as care, love and attention.</p>
                    
                    <p>We know that we can all make a difference in this world when we all work together for our common goal. 
                    We know our mission is only possible when we all join together to make this upcoming year a great success for everyone!!</p>
                    
                    <p>We look forward to seeing you in the States.</p>	
                </td>
            </tr>
        </table>
        
        <!--- PAGE BOTTON --->	
	 <table width="660" align="center" border=0 cellpadding="1" cellspacing="1" style="font-size:13px">
		<tr><td>Best Regards,</td></tr>	
		<tr><td>&nbsp;</td></tr>
		<tr><td><img src="../pics/diana_signature.png" border="0"></td></tr>
		<tr><td>Diana DeClemente</td></tr>
		<tr><td>Program Director</td></tr>	
		<tr><td>#companyshort.companyname#</td></tr>			
	</table><br />
        
        <cfif qGetStudents.currentRow NEQ qGetStudents.recordCount>
        	<div style="page-break-after:always;"></div><br />
		</cfif>
        
    </cfloop>

</cfoutput>

</body>
</html>