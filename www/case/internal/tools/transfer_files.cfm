<cfquery name="get_student_info" datasource="caseusa">
select smg_id, studentid 
from smg_students
where smg_id = #form.smg_id#
order by smg_id
limit 1
</cfquery>
<cfif isDefined('form.pic_only')>
	<!----Transfer Picture---->
	<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/web-students" name="pic_check" filter="#get_student_info.smg_id#.*">
	<cfif pic_check.recordcount neq 0>
	<cfdirectory directory="/var/www/html/case/internal/uploadedfiles/web-students" name="pic" filter="#get_student_info.studentid#.*">
		<cfif pic.recordcount eq 0>
			<cffile action="copy"  source="/var/www/html/student-management/nsmg/uploadedfiles/web-students/#get_student_info.smg_id#.#Right(pic_check.name,3)#" 
				destination="/var/www/html/case/internal/uploadedfiles/web-students/#get_student_info.studentid#.#Right(pic_check.name,3)#">
		</cfif>
	</cfif>
	
<cfelse>

<cfloop query="get_student_info">

<!----Update Siblings and album descriptions--->
<cfquery name="update_album" datasource="caseusa">
update smg_student_app_family_album
set studentid = #studentid#
where smg_id = #smg_id#
</cfquery>
1
<cfquery name="update_siblings" datasource="caseusa">
update smg_student_siblings
set studentid = #studentid#
where smg_id = #smg_id#
</cfquery>
2
<cfquery name="update_app_heatlth" datasource="caseusa">
update smg_student_app_health
set studentid = #studentid#
where smg_id = #smg_id#
</cfquery>
3
<cfquery name="update_app_shots" datasource="caseusa">
update smg_student_app_shots
set studentid = #studentid#
where smg_id = #smg_id#
</cfquery>
4
<cfquery name="update_app_states" datasource="caseusa">
update smg_student_app_state_requested
set studentid = #studentid#
where smg_id = #smg_id#
</cfquery>
5
<cfquery name="update_app_status" datasource="caseusa">
update smg_student_app_status
set studentid = #studentid#
where smg_id = #smg_id#
</cfquery>
6
<cfquery name="update_app_status_companyid" datasource="caseusa">
update smg_students
set companyid = 10,
app_current_status = 11,
active = 1,
canceldate = null,
cancelreason = ''
where smg_id = #smg_id#
</cfquery>
7
<cfquery name="update_app_status_companyid" datasource="caseusa">
insert into smg_student_app_status (studentid, status, reason, date, approvedby)
				values             (#studentid#, 11, 'Transfer','2009-04-21',1)
</cfquery>
8
	<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/online_app/picture_album/#get_student_info.smg_id#/" name="smg_album_check">

	<cfif smg_album_check.recordcount gt 0>
		<cfdirectory directory="/var/www/html/case/internal/uploadedfiles/online_app/picture_album/#get_student_info.studentid#/" name="case_album_check">

			<cfif case_album_check.recordcount eq 0>
			<cfdirectory action="create" directory="/var/www/html/case/internal/uploadedfiles/online_app/picture_album/#get_student_info.studentid#/" mode="777">
			<cfdump var="#smg_album_check#">
				<cfloop query="smg_album_check">
					<cffile action="copy"  
					source="/var/www/html/student-management/nsmg/uploadedfiles/online_app/picture_album/#get_student_info.smg_id#/#smg_album_check.name#" 
					destination="/var/www/html/case/internal/uploadedfiles/online_app/picture_album/#get_student_info.studentid#/#smg_album_check.name#"  mode="777">
					<Cfoutput>
					#smg_album_check.currentrow#<br />
					</Cfoutput>
				</cfloop>
			</cfif>
	</cfif>

</cfloop>	


<cfloop query="get_student_info">
<!----
	<cfquery name="uncancel" datasource="caseusa">
	update smg_students
	set canceldate = null,
	cancelreason = null,
	companyid = 10,
	active = 1,
	app_current_status = 11
	where studentid = #studentid#
	</cfquery>
	
	<cfquery name="update_app_status" datasource="caseusa">
	insert into smg_student_app_status (studentid, status, reason, date, approvedby)
					values (#studentid#, 11, 'App succesfully trans. to CASE', #now()#, 1) 
	</cfquery>
---->
	<!----Transfer Picture---->
	<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/web-students" name="pic_check" filter="#get_student_info.smg_id#.*">
	<cfif pic_check.recordcount neq 0>
	<cfdirectory directory="/var/www/html/case/internal/uploadedfiles/web-students" name="pic" filter="#get_student_info.studentid#.*">
		<cfif pic.recordcount eq 0>
			<cffile action="copy"  source="/var/www/html/student-management/nsmg/uploadedfiles/web-students/#get_student_info.smg_id#.#Right(pic_check.name,3)#" 
				destination="/var/www/html/case/internal/uploadedfiles/web-students/#get_student_info.studentid#.#Right(pic_check.name,3)#">
		</cfif>
	</cfif>
	


		<!----Transfer Family Album---->
	<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/online_app/picture_album/#get_student_info.smg_id#" name="album_check">
	<cfdump var="#album_check#">
	<cfif album_check.recordcount neq 0>
	<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/online_app/#get_student_info.studentid#" name="album_pics">
		<cfif album_check.recordcount eq 0>
		<cfdump var="#album_pics#">
		
	
			<cffile action="copy"  source="/var/www/html/student-management/nsmg/uploadedfiles/online_app/#get_student_info.smg_id#/#album_pics.name#" 
				destination="/var/www/html/case/internal/uploadedfiles/online_app/#get_student_info.studentid#/#album_pics.name#"  mode="777">
		
		</cfif>
	</cfif>
	

<!----signature pages of application---->
<cfoutput>

<cfloop list="07,08,09,10,12,13,14,15,16,17,18,19,20,21" index="x">

<cfdirectory directory="/var/www/html/case/internal/uploadedfiles/online_app/page#x#" name="doc_check" filter="#get_student_info.smg_id#.*">

	<cfif doc_check.recordcount eq 0>
		<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/online_app/page#x#" name="doc" filter="#get_student_info.smg_id#.*">
	
			<cfif doc.recordcount gt 0>
			
			<cffile action="copy"  source="/var/www/html/student-management/nsmg/uploadedfiles/online_app/page#x#/#doc.name#" 
				destination="/var/www/html/case/internal/uploadedfiles/online_app/page#x#/#get_student_info.studentid#.#Right(doc.name,3)#"  mode="777">	
				
			</cfif>
	</cfif>
	<br />
</cfloop>

</cfoutput>
</cfloop>

	<!----Transfer Stu Letter---->
	<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/letters/students" name="stuletter_check" filter="#get_student_info.smg_id#.*">
	<cfdump var="#stuletter_check#">
	<cfif stuletter_check.recordcount neq 0>
	<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/letters/students" name="stuletter" filter="#get_student_info.studentid#.*">
	<cfdump var="#stuletter#">
		<cfif stuletter.recordcount eq 0>
			<cffile action="copy" 
				destination="/var/www/html/student-management/nsmg/uploadedfiles/letters/students/#get_student_info.studentid#.#Right(stuletter_check.name,3)#" mode="777"  source="/var/www/html/student-management/nsmg/uploadedfiles/letters/students/#get_student_info.smg_id#.#Right(stuletter_check.name,3)#">
		</cfif>
	</cfif>
	
	
	<!----Transfer Par Letter---->
	<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/letters/parents" name="parletter_check" filter="#get_student_info.smg_id#.*">
	
	<cfif stuletter_check.recordcount neq 0>
	<cfdirectory directory="/var/www/html/student-management/nsmg/uploadedfiles/letters/parents" name="parletter" filter="#get_student_info.studentid#.*">
		<cfif stuletter.recordcount eq 0>
			<cffile action="copy"  source="/var/www/html/student-management/nsmg/uploadedfiles/letters/parents/#get_student_info.smg_id#.#Right(parletter_check.name,3)#" 
				destination="/var/www/html/student-management/nsmg/uploadedfiles/letters/parents/#get_student_info.studentid#.#Right(parletter_check.name,3)#"  mode="777">
		</cfif>
	</cfif>

</cfif>
<cflocation url="http://www.case-usa.org/internal/index.cfm?curdoc=student_info&studentid=#get_student_info.studentid#">