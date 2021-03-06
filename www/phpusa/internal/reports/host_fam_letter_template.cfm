
<cfquery name="get_student_unqid" datasource="MySql">
	SELECT s.studentid, s.firstname, s.familylastname, s.uniqueid, s.intrep, s.sex,
		h.hostid, h.familylastname as hostlastname, h.address, h.address2, h.city, h.state, h.zip, 
		<!--- sta.state as hoststate, --->
		p.programid, p.programname, p.startdate, p.enddate,
		c.countryname,
		<!--- FROM THE NEW TABLE PHP_STUDENTS_IN_PROGRAM --->		
		stu_prog.assignedid, stu_prog.companyid, stu_prog.programid, stu_prog.hostid, stu_prog.schoolid, stu_prog.placerepid, stu_prog.arearepid,
		stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.active, stu_prog.i20no
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN smg_programs p ON stu_prog.programid = p.programid
	LEFT JOIN smg_hosts h ON stu_prog.hostid = h.hostid
	LEFT JOIN smg_countrylist c ON c.countryid = s.countryresident
	WHERE 1 = 1 
	<cfif isDefined('form.intrep')>AND s.intrep = #form.intrep#</cfif>
	<cfif isDefined('form.program')>AND stu_prog.programid = #form.program#</cfif>
	<cfif isDefined('form.school')>AND stu_prog.schoolid = #form.school#</cfif>
	<cfif isDefined('form.date')>AND stu_prog.i20received = #form.date#</cfif>
	ORDER BY assignedid DESC	
</cfquery>

<cfif get_student_unqid.recordcount EQ 0>
No records were found that match your criteria.<br />
Please use your browser's back button to select different criteria and resubmit.

<cfelse>

<cfloop query="get_student_unqid">
<cfquery name="school_id" datasource="mysql">
select schoolid 
from php_students_in_program
where studentid = #get_student_unqid.studentid#
</cfquery>
<cfquery name="school_dates" datasource="mysql">
select max(seasonid) as seasonid, year_begins, semester_ends, semester_begins, year_ends
from php_school_dates
where schoolid = #school_id.schoolid#
group by seasonid
</cfquery>
<cfoutput>
<div style="page-break-after: always">
<!----
<cfquery name="set_printed_date" datasource="MySQL">
	UPDATE php_students_in_program
	SET welcome_letter_printed = #CreateODBCDateFormat(now())#
	WHERE studentid = #studentid#
</cfquery>
---->
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

<table width="660" align="center" border=0 bgcolor="##FFFFFF" style="font-size:13px"> 
	<tr>
		<td align="left">The #get_student_unqid.hostlastname# Family<br>
			#get_student_unqid.address#<br>
			<Cfif get_student_unqid.address2 NEQ ''>#get_student.address2#<br></Cfif>
			#get_student_unqid.city#, #get_student_unqid.state# #get_student_unqid.zip#
		</td>
		<td align="right">
			Program: #get_student_unqid.programname#<br>
			From:
            <cfif #DateFormat(get_student_unqid.startdate,'mm')# lt 6>
            #DateFormat(school_dates.semester_begins,'mmm. d, yyyy')# 
            <cfelse>
            #DateFormat(school_dates.year_begins,'mmm. d, yyyy')# 
            </cfif>
            thru 
            <cfif #DateFormat(get_student_unqid.enddate,'mm')# lt 6>
            #DateFormat(school_dates.year_ends,'mmm. d, yyyy')#
            <cfelse>
            #DateFormat(school_dates.semester_ends,'mmm. d, yyyy')#
            </cfif><br><br>
		</td>
	</tr>
</table><br><br>
	
<table width="660" align="center" border=0 bgcolor="##FFFFFF" style="font-size:13px"> 
	<tr>	
		<td>
			<div align="justify">
			Dear #get_student_unqid.hostlastname# Family,
		
			<p>Welcome to the DMD Private High School Program!</p>

			<p>I would like to begin by thanking you for opening you heart and home to 
			#get_student_unqid.firstname# #get_student_unqid.familylastname# from #get_student_unqid.countryname#. 
			I hope that your hosting experience will be enjoyable and memorable.</p>
			
			<p>Enclosed, you will find your DMD arrival folder. This folder has been created to help you prepare the arrival of 
			your international student and to familiarize you with DMD's Private High School Program. Inside, you will find a 
			DMD Host Family Handbook that explains DMD's expectations and program rules. This Handbook also offers advice for 
			different situations that may arise during your hosting experience. Please read your Handbook carefully and use it as
			a guide whenever possible.</p>
			
			<p>We suggest that you contact the student before 
			<cfif get_student_unqid.sex EQ 'male'>he<cfelseif get_student_unqid.sex EQ 'female'>she<cfelse>he or she</cfif> arrives. 
			Not only will such communication relieve your anxieties, but it will also do wonders to relieve your student and his or her
			parents' anxieties. Your initial contact will also give you the opportunity to re-confirm your student's arrival information.</p>

			<p>The DMD office is in constant communication with your local representatives regarding your student's flight information. 
			As soon as DMD receives your student's flight details we will forward this information to you via fax, phone or post. 
			In most cases the DMD local contact person will be giving this information directly to your local representative.</p>

			<p>Also included in your family's arrival folder, are numerous flyers that will help you prepare, organize and learn about your
			international student before <cfif get_student_unqid.sex EQ 'male'>he<cfelseif get_student_unqid.sex EQ 'female'>she<cfelse>he or she</cfif> 
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
</cfoutput>
</cfloop>
</cfif>
