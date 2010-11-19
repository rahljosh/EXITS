<cfif client.userid neq 20>
You do not currently have access to the XML upload tool.
<cfelse>
Currently, you can upload limited information to the student applciation via an XML file.  Once uploaded, you can update the application through the EXITS application interface.  I am currently working on capturing more information as quickly as possible.<br /><br />
<form action="?curdoc=xml/upload_apps" method="post">
Upload XML File (limit to 5 students per XML file) <input name="xml_file" type="file" size="20" /> <input type="submit" value="upload" />
</form>
</cfif>