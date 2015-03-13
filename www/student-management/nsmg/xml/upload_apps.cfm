<cfsetting requesttimeout="20000" />

<cfhttp url="#form.file_upload#"></cfhttp>

<cfset StudentXMLFile = XMLParse(cfhttp.FileContent)>
<cfset numberofstudents = ArrayLen(#StudentXMLFile.applications.application#)>
<cfset numberill = ArrayLen(#StudentXMLFile.applications.application[1].page9.illness.type#)>
<cfoutput>
Total Number of Applications: #numberofstudents# applications.<br /><br />

<cfloop from="1" to="#numberofstudents#" index="i">
<br /><br />

<Cfdump var="#studentXMLFile#">


<!----Check if Student has been submitted---->
<cfquery name="check_soid" datasource="MySQL">
select studentid, soid, familylastname, firstname, app_current_status, uniqueID
from smg_students where soid = '#StudentXMLFile.applications.application[i].XmlAttributes.studentid#'
</cfquery>

<cfif check_soid.recordcount neq 0>
	<cfloop query="check_soid">
		<cfquery name="delete_current_apps" datasource="mysql">
		delete from smg_students
		where soid = '#check_soid.soid#'
		and app_current_status < 11
		limit 1
		</cfquery>
	</cfloop>
</cfif>


<cfif (check_soid.recordcount neq 0 and check_soid.app_current_status lt 11) or (check_soid.recordcount eq 0)>

		<cfset unid = CreateUUID()>
        <cfif client.companyid lte 5>
        	<cfset AssignedID = 5>
        <cfelse>
        	<cfset AssignedID = #client.companyid#>
        </cfif>
		<cfquery name="inset_soid" datasource="MySQL">
		insert into smg_students  (soid, intrep, phone, randid, uniqueid, app_current_status, companyid)
					values ('#StudentXMLFile.applications.application[i].XmlAttributes.studentid#',#client.userid#,'523-0944',8675309,'#unid#',5, #AssignedID#)
		</cfquery>
		<cfquery name="get_studentid" datasource="mysql">
		select studentid 
		from smg_students
		where soid = '#StudentXMLFile.applications.application[i].XmlAttributes.studentid#'
		</cfquery>
		<cfset client.studentid = #get_studentid.studentid#>
		
		<cfquery datasource="mysql">
			insert into smg_student_app_status  (status, reason, studentid)
			values (5, 'XML File upload not complete.', #get_studentid.studentid# )
		</cfquery>

		<cfscript>
			function removecoma( p_string ) {
			  var list1 = ",";
			  var list2 = ".";
			  var v_string = ReplaceList(p_string, list1, list2) ; 
			 return( v_string );
			}
		</cfscript>
		<!----
<cfoutput>
<cfdirectory action ="create" directory ="#AppPath.onlineApp.virtualFolder##client.studentid#/page22/" mode="777">
<cfset number_misc_docs = Arraylen(#StudentXMLFile.applications.application[i].miscData.miscDocuments.document#)>
	Number of Documents: #number_misc_docs#<br>
	<cfloop index="misc_docs" from="1" to="#number_misc_docs#">
	Current Doc: #misc_docs#<br> 
	Filename: #client.studentid#_#misc_docs#.#Right(StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext,3)#<br>
	URL: #StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext#<br>
	Path: #AppPath.onlineApp.virtualFolder##client.studentid#/page22/
	<br><br>....<br>
	<cfhttp url='#StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext#'  method="get" path="#AppPath.onlineApp.virtualFolder##client.studentid#/page22/" file="#client.studentid#_#misc_docs#.#Right(StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
	<cfquery name="insert_category" datasource="MySql">
		INSERT INTO smg_virtualfolder (studentid, categoryid, filename)
		VALUES (#client.studentid#, 1, '#client.studentid#_#misc_docs#.#Right(StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext,3)#')
	</cfquery>
	<cfflush>Misc doc transfered.
	
	</Cfloop>
</cfoutput>
---->
			<!----Page 1 of app---->
			<cfoutput>
			
			<cfinclude template="qr_page1.cfm">
			<cfflush>
			10%...
			<!----Family album pictures and descriptions---->
			<cfinclude template="qr_page2.cfm">
			<cfflush>
			20%...
			<!----page 3 of app	---->
			<cfinclude template="qr_interest.cfm">
			<cfflush>
			30%...
			<!----Page 3 of XML page 5 of App---->
			<!----Student Letter 	---->
			<cfinclude template="qr_page3.cfm">
			<cfflush>
			40%...
			<!----Page 4 of XML page 4 of App---->
			<!----Photo Album Letter 
			<cfinclude template="qr_page4.cfm">---->
			<!----Page 6 of XML page 6 of App---->
			<!----Parents  Letter ---->
			<cfinclude template="qr_page6.cfm">
			<cfflush>
			50%...
			<!----Page 7 8 of XML page 7 of App---->
			<!----School Information ---->
			<cfinclude template="qr_page7.cfm">
			<cfflush>
			60%...
			<!----Page 9 of XML page 11 of App---->
			<!----School Grade Information
			<cfinclude template="qr_page9.cfm"> ---->
			<!----Page 09 and 10  of app :: Language Evaluation and Social Skills---->
			<cfinclude template="qr_page9.cfm">
			<cfflush>
			70%...
			<cfinclude template="qr_medical_history4.cfm">
			<cfflush>
			75%...
			<cfinclude template="qr_insert_grades.cfm">
			<cfflush>
			80%...
			<!----<cfinclude template="qr_region_choice.cfm">---->
			<!----Page 10 of XML page 7 of App---->
			<!----Immunizations  
			<cfinclude template="qr_page7.cfm">---->
			<cfflush>
			85%...<Br />
			<!----Family Album:
			<cfinclude template="fam_album.cfm">
			<cfflush>
			---->
            90%...
			Scanned Items: 
			<cfinclude template="qr_scanned_items.cfm">
			<cfflush>
			
			<!----Page 2 of app---->
			
			
			
		
			
			
			
			
			
		
			

			
	
<!----
	
#StudentXMLFile.applications.application[i].XmlAttributes.studentid# ::
#StudentXMLFile.applications.application[i].page1.student.firstname.XmlText# #StudentXMLFile.applications.application[i].page1.student.lastname.XmlText#
was submitted Successfully. 
<cfflush>
<cfset client.checkstudent =#StudentXMLFile.applications.application[i].XmlAttributes.studentid#>

<cfinclude template="check_submission.cfm">
#client.countred# mandatory items are missing <br />
Set application status to 7 if no items are missing for SMG to approve, set to 5 if items are missing for agent to approve
<cfif client.countred eq 0>
	<cfquery name="approved" datasource="mysql">
	update smg_students set app_current_status = 7
	where studentid = #get_studentid.studentid#
	</cfquery>
		<cfquery name="approved2" datasource="mysql">
			insert into smg_student_app_status  (status, studentid)
			values (7, #get_studentid.studentid# )
		</cfquery>
<cfelse>
	<cfquery name="approved2" datasource="mysql">
	update smg_students set app_current_status = 5
	where studentid = #get_studentid.studentid#
	</cfquery>
		<cfquery name="approved2" datasource="mysql">
			insert into smg_student_app_status  (status, reason, studentid)
			values (5, 'XML File upload not complete.', #get_studentid.studentid# )
		</cfquery>
</cfif>
---->
</cfoutput>		
		

 
<cfflush>
<Cfelse>
 <a href="https://ise.exitsapplication.com/nsmg/index.cfm?curdoc=intrep/int_student_info&unqid=#check_soid.uniqueID#">#check_soid.firstname# #check_soid.familylastname# </a>is already in the system. <br /> ISE account: #check_soid.studentid# <Br />Submitting ID: #check_soid.soid#<br />
  
	</cfif>


</cfloop>

</cfoutput>

