<cfif not IsDefined('form.programid')>
	<cfif not IsDefined('url.studentid') OR not IsDefined('url.programid')>
		<cfinclude template="../error_message.cfm">
    <cfelse>
    	<cfset form.programid = url.programid>
    </cfif>
<cfelse>
	<cfset url.studentid = 0>
</cfif>

<!--- Get Program --->
<cfquery name="qGetPrograms" datasource="MySql">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list="#form.programid#" index="prog">
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
</cfquery>

<cfquery name="qGetStudents" datasource="MySql">
	SELECT DISTINCT
    	stu.studentid,
        stu.schoolid,
        s.firstname,
        s.familylastname,
        s.sex,
        p.seasonid,
        p.startdate,
        p.enddate
 	FROM php_students_in_program stu
    INNER JOIN smg_students s ON s.studentid = stu.studentid
    INNER JOIN smg_programs p ON stu.programid = p.programid
    WHERE s.active = '1'
    	AND
        	stu.programid = '#programid#'
        AND
        	stu.return_student = '1'
        AND
        	stu.canceledBy = '0'
        <cfif url.studentid NEQ 0>
        	AND
        		stu.studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer">
        </cfif>
        ORDER BY familylastname
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>

<cfloop query="qGetStudents">
	
    <cfquery name="qGetSchool" datasource="MySql">
        SELECT
            sc.schoolname,
            scd.seasonid,
            scd.year_begins,
            scd.year_ends,
            scd.semester_begins,
            scd.semester_ends
        FROM
            php_schools sc
        INNER JOIN php_school_dates scd ON sc.schoolid = scd.schoolid
        WHERE
        	sc.schoolid = #qGetStudents.schoolid#
            AND
            seasonid = #qGetStudents.seasonid#
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
            <td align="left">&nbsp;
                
            </td>
            <td align="right">
                #DateFormat(NOW(),'dddd, mmmm dd, yyyy')#<br />
                School: #qGetSchool.schoolname#<br />
                From:
				<cfif #DateFormat(qGetStudents.startdate,'mm')# lt 6>
                	#DateFormat(qGetSchool.semester_begins,'mmm. d, yyyy')# 
                <cfelse>
                	#DateFormat(qGetSchool.year_begins,'mmm. d, yyyy')# 
                </cfif>
                thru 
                <cfif #DateFormat(qGetStudents.enddate,'mm')# lt 6>
                	#DateFormat(qGetSchool.year_ends,'mmm. d, yyyy')#
                <cfelse>
                	#DateFormat(qGetSchool.semester_ends,'mmm. d, yyyy')#
                </cfif>
                <br><br>
            </td>
        </tr>
    </table><br><br>
        
    <table width="660" align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
        <tr>	
            <td>
                <div align="justify">
                
                Dear #qGetStudents.firstname# #qGetStudents.familylastname# (#qGetStudents.studentid#),
		
                <p>On behalf of everyone at DMD, I would like to take this opportunity to welcome you back to this exciting, challenging 
                and rewarding program. We are so happy you have decided to return and continue on your educational path here in the States.</p>

				<p>Everyone involved with our Private High School Program wants to assure you that our office will continue to work hard to 
                make sure that this experience will be memorable and beneficial. We are here to assist you in any way possible throughout 
                your stay. Your school is #qGetSchool.schoolname# and they are very eager to see you again and ensure that your stay goes 
                well again this year.</p>
                
                <p>We take our mission statement, "Educating Tomorrow's Leaders" very seriously. Our staff is always available to you. We 
                are fully aware that your experience requires careful planning as well as care, love and attention.</p>
                
                <p>We know that we can all make a difference in this world when we all work together for our common goal. We know our 
                mission is only possible when we all join together to make this upcoming year a great success for everyone!!</p>
                
                <p>We look forward to seeing you return to the States again and continue on your journey.</p>
                <br />
                
                </div>
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
    <div style="page-break-after:always;"></div>
    
</cfloop>

</cfoutput>