<Cfoutput>
<!----Get the number of pictures to loop through---->
<cfset count_fam_pictures = ArrayLen(#StudentXMLFile.applications.application[i].page4_5.images.image#)>

<!----Create Directory to write images to---->
<cfdirectory action="create" directory='/var/www/html/student-management/nsmg/uploadedfiles/online_app/picture_album/#client.studentid#/'>

<!----Loop through list and write pictures to fam album---->
<cfloop index="fampic" from="1" to="#count_fam_pictures#">

	<cfhttp url='#StudentXMLFile.applications.application[i].page4_5.images.image[fampic].url.xmltext#'  method="get" path='/var/www/html/student-management/nsmg/uploadedfiles/online_app/picture_album/#client.studentid#/' file='#StudentXMLFile.applications.application[i].page4_5.images.image[fampic].XmlAttributes.nr#.jpg' multipart="yes" getasbinary="yes" username="exits" password="34uFka">	

		<cfquery name="pic_description" datasource="MySQL">
				INSERT INTO smg_student_app_family_album (description, filename, studentid)
					values ('#StudentXMLFile.applications.application[i].page4_5.images.image[fampic].description.XmlText#','#StudentXMLFile.applications.application[i].page4_5.images.image[fampic].XmlAttributes.nr#.jpg',#client.studentid#)		

					</cfquery>
				
<cfflush>Uploading Pic #fampic# complete.
</cfloop>
</cfoutput>

	


	


