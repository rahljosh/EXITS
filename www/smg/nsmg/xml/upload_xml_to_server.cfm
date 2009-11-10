<cfset directory = '/var/www/html/student-management/nsmg/uploadedfiles/xml_files'>

	<!----Upload File---->
	<cffile action = "upload" destination = "#directory#" fileField = "file_upload"	nameConflict = "makeunique">
	