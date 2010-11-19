<cfhttp method="get" url="http://192.168.0.21/student-management/nsmg/xml/received_file.xml"></cfhttp>
<cfset StudentXMLFile = XMLParse(cfhttp.FileContent)>


<cfdump var="#StudentXMLFile#">
<!---- 
#StudentXMLFile.applications.application[1].page9.illness.type[description is 'Measles'].flag.child#
<!---- 
---->

<cfoutput>

#StudentXMLFile.applications.application[1].page9.illness.type[2].description.xmltext# <br /><br />

<cfif StudentXMLFile.applications.application[1].page9.illness.type[2].description.xmltext EQ 'Measles'>
	#StudentXMLFile.applications.application[1].page9.illness.type[2].flag.xmltext# <br /><br />
</cfif>

<cfscript>
	if(StudentXMLFile.applications.application[1].page9.illness.type[2].description.xmltext EQ 'Measles') {
		WriteOutput(#StudentXMLFile.applications.application[1].page9.illness.type[2].flag.xmltext#);
	}
</cfscript>

<br /><br />

#StudentXMLFile.applications.application[1].page9.illness.type[1].description.xmltext# <br />
#StudentXMLFile.applications.application[1].page9.illness.type[2].description.xmltext# <br />
#StudentXMLFile.applications.application[1].page9.illness.type[3].description.xmltext# <br />


</cfoutput>
---->