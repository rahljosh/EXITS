<cfsetting requesttimeout="20000" />
<cfset i = 1>
<cfset client.studentid = 16852>
<cfhttp url="https://secure.into-exchange.com/exitsxml/SMG-DEH14880-20081222.xml"></cfhttp>

<cfset StudentXMLFile = XMLParse(cfhttp.FileContent)>
<cfset numberofstudents = ArrayLen(#StudentXMLFile.applications.application[i].miscData.miscDocuments#)>

<cfoutput>
fuck
	<cfset number_misc_docs = Arraylen(#StudentXMLFile.applications.application[i].miscData.miscDocuments.document#)>
	Number of Documents: #number_misc_docs#<br>
	<cfloop index="misc_docs" from="1" to="#number_misc_docs#">
	Current Doc: #misc_docs#<br> 
	Filename: #client.studentid#_#misc_docs#.#Right(StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext,3)#<br>
	URL: #StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext#<br>
	Path: /var/www/html/student-management/nsmg/uploadedfiles/virtualfolder/#client.studentid#/page22/
	<br><br>....<br>
	<cfhttp url='#StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext#'  method="get" path="/var/www/html/student-management/nsmg/uploadedfiles/virtualfolder/#client.studentid#/page22/" file="#client.studentid#_#misc_docs#.#Right(StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext,3)#" multipart="yes" getasbinary="yes" username="exits" password="34uFka">
	<cfquery name="insert_category" datasource="MySql">
		INSERT INTO smg_virtualfolder (studentid, categoryid, filename)
		VALUES (#client.studentid#, 1, '#client.studentid#_#misc_docs#.#Right(StudentXMLFile.applications.application[i].miscData.miscDocuments.document[misc_docs].url.xmltext,3)#')
	</cfquery>
	<cfflush>Misc doc transfered.
	
	</Cfloop>
</cfoutput>


