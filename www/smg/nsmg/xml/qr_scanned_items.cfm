<!----Misc Documents---->
<cfoutput>

<cfset documents_exist = Len(#StudentXMLFile.applications.application[i].miscData.miscDocuments#)>
<cfoutput>
#documents_exist#
</cfoutput>

<!----
<cfset documents_exist = ArrayIsDefined(#StudentXMLFile.applications.application[i].miscData.miscDocuments.document#)>


<cfif #StudentXMLFile.applications.application[i].miscData.miscDocuments.xmltext# is not ''>
---->
<cfif #documents_exist# gt 200>

<!----
<cfif #StudentXMLFile.applications.application[i].miscData.miscDocuments# is not ''>
---->
<cfdirectory action ="create" directory ="#AppPath.onlineApp.virtualFolder##client.studentid#/page22/" mode="777">
<cfset number_misc_docs = Arraylen(#StudentXMLFile.applications.application[i].miscData.miscDocuments.document#)>
	
	<cfloop index="misc_docs" from="1" to="#number_misc_docs#">


	<cfhttp url='#StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext#'  method="get" path="#AppPath.onlineApp.virtualFolder##client.studentid#/page22/" file="#client.studentid#_#misc_docs#.#Right(StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
	<cfquery name="insert_category" datasource="MySql">
		INSERT INTO smg_virtualfolder (studentid, categoryid, filename)
		VALUES (#client.studentid#, 1, '#client.studentid#_#misc_docs#.#Right(StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext,3)#')
	</cfquery>
	<cfflush>Misc doc transfered.
	
	</Cfloop>
<cfelse>
No misc docs to transfer.	

</cfif>
</cfoutput>
Starting Student Picture Transfer...
<!----Student Picture---->
<cfhttp url='#StudentXMLFile.applications.application[i].page1.student.image.url.xmltext#'  method="get" path="#AppPath.onlineApp.picture#" file="#client.studentid#.#Right(StudentXMLFile.applications.application[i].page1.student.image.url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
<cfflush>Complete. Starting Student Letter Transfer...
<!----students letter---->
<cfhttp url='#StudentXMLFile.applications.application[i].page3.pdf.url.xmltext#'  method="get" path="#AppPath.onlineApp.studentLetter#" file="#client.studentid#.#Right(StudentXMLFile.applications.application[i].page3.pdf.url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
<cfflush>Complete.  Starting Parent Letter Transfer...
<!----parents letter---->
<cfhttp url='#StudentXMLFile.applications.application[i].page6.pdf.url.xmltext#'  method="get" path="#AppPath.onlineApp.parentLetter#" file="#client.studentid#.#Right(StudentXMLFile.applications.application[i].page6.pdf.url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
<cfflush>Complete. Starting Lang. Eval Transfer...
<!----language eval letter page 19---->
<cfhttp url='#StudentXMLFile.applications.application[i].page7.pdf.url.xmltext#'  method="get" path="#AppPath.onlineApp.inserts#page09" file="#client.studentid#.#Right(StudentXMLFile.applications.application[i].page7.pdf.url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
<cfflush>Complete. Starting Report Transfer...
<!----Report Card---->
<cfhttp url='#StudentXMLFile.applications.application[i].page8.pdf.url.xmltext#'  method="get" path="#AppPath.onlineApp.inserts#page08/" file="#client.studentid#.#Right(StudentXMLFile.applications.application[i].page8.pdf.url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
<cfflush>Complete. Starting Medical Eval Transfer...
<!----Medical Eval---->
<cfhttp url='#StudentXMLFile.applications.application[i].page9.pdf.url.xmltext#'  method="get" path="#AppPath.onlineApp.inserts#page12" file="#client.studentid#.#Right(StudentXMLFile.applications.application[i].page9.pdf.url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
<cfflush>Complete. Starting Immunization Transfer...
<!----Immunization---->
<cfhttp url='#StudentXMLFile.applications.application[i].page10.pdf.url.xmltext#'  method="get" path="#AppPath.onlineApp.inserts#page13" file="#client.studentid#.#Right(StudentXMLFile.applications.application[i].page10.pdf.url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
<cfflush>Complete. Starting Authorization to Treat Minor Transfer...

<!----Authorizaton to Treat a Minor---->
<cfhttp url='#StudentXMLFile.applications.application[i].page11.pdf.url.xmltext#'  method="get" path="#AppPath.onlineApp.inserts#page14" file="#client.studentid#.#Right(StudentXMLFile.applications.application[i].page11.pdf.url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
<cfflush>Complete. Starting Progam Agreement Transfer...
<!----Program Agreement---->
<cffile action = "copy" source = "#AppPath.onlineApp.inserts#page14/#client.studentid#.#Right(StudentXMLFile.applications.application[i].page11.pdf.url.xmltext,3)#" destination="#AppPath.onlineApp.inserts#page15/#client.studentid#.#Right(StudentXMLFile.applications.application[i].page11.pdf.url.xmltext,3)#">
<cfflush>Complete. Starting LIability Release Transfer...
<!----Liability Release---->
<cffile action = "copy" source = "#AppPath.onlineApp.inserts#page14/#client.studentid#.#Right(StudentXMLFile.applications.application[i].page11.pdf.url.xmltext,3)#" destination="#AppPath.onlineApp.inserts#page16/#client.studentid#.#Right(StudentXMLFile.applications.application[i].page11.pdf.url.xmltext,3)#">
<cfflush>Complete. Starting Travel Auth. Transfer...
<!----Travel Authorization Release---->
<cffile action = "copy" source = "#AppPath.onlineApp.inserts#page14/#client.studentid#.#Right(StudentXMLFile.applications.application[i].page11.pdf.url.xmltext,3)#" destination="#AppPath.onlineApp.inserts#page17/#client.studentid#.#Right(StudentXMLFile.applications.application[i].page11.pdf.url.xmltext,3)#">
<cfflush>Complete. Starting Language Eval Transfer...



<!----Copy Company specific files---->
<!----Copy page 10---->
<cffile action = "copy" source = "#AppPath.onlineApp.inserts#into_ger_files/EXITS_Page10_#client.userid#.jpg" destination="#AppPath.onlineApp.inserts#page10/#client.studentid#.jpg">
<!----Copy Page 19---->
<cfflush>Complete. 2 more files..
<cffile action = "copy" source = "#AppPath.onlineApp.inserts#into_ger_files/EXITS_Page19_#client.userid#.jpg" destination="#AppPath.onlineApp.inserts#page19/#client.studentid#.jpg">
<!----Copy Page 20--->
<cfflush>Complete. 1 more file...
<cffile action = "copy" source = "#AppPath.onlineApp.inserts#into_ger_files/EXITS_Page20_#client.userid#.jpg" destination="#AppPath.onlineApp.inserts#page20/#client.studentid#.jpg">


<cfset count_fam_pictures = ArrayLen(#StudentXMLFile.applications.application[i].page4_5.images.image#)>

<!----Create Directory to write images to---->
<cfdirectory action="create" directory='#AppPath.onlineApp.familyAlbum##client.studentid#/' mode="777">

<!----Loop through list and write pictures to fam album---->
<cfloop index="fampic" from="1" to="#count_fam_pictures#">

	<cfhttp url='#StudentXMLFile.applications.application[i].page4_5.images.image[fampic].url.xmltext#'  method="get" path='#AppPath.onlineApp.familyAlbum##client.studentid#/' file='#StudentXMLFile.applications.application[i].page4_5.images.image[fampic].XmlAttributes.nr#.jpg' multipart="yes" getasbinary="yes" username="exits" password="34uFka">	


		<cfquery name="pic_description" datasource="MySQL">
				INSERT INTO smg_student_app_family_album (description, filename, studentid)
					values ('#StudentXMLFile.applications.application[i].page4_5.images.image[fampic].description.XmlText#','#StudentXMLFile.applications.application[i].page4_5.images.image[fampic].XmlAttributes.nr#.jpg',#client.studentid#)		

					</cfquery>
				
<cfflush>Uploading Pic #fampic# complete.
</cfloop>
Finished uploading files 

