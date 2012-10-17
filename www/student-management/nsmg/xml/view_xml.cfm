<cfhttp method="get" url="http://ise.exitsapplication.com/nsmg/temp/into-export.xml"></cfhttp>
<cfset StudentXMLFile = XMLParse(cfhttp.FileContent)>
<cfoutput>
<cfset StudentXMLFile = XMLParse(cfhttp.FileContent)>
<cfset numberofstudents = ArrayLen(#StudentXMLFile.applications.application#)>
<cfset numberill = ArrayLen(#StudentXMLFile.applications.application[1].page9.illness.type#)>

Total Number of Applications: #numberofstudents# applications.<br /><br />

<cfloop from="1" to="#numberofstudents#" index="i">


	<cfloop from="1" to="#ArrayLen(StudentXMLFile.applications.application[i].page2.languages.language)#" index="x">
   			<cfif #StudentXMLFile.applications.application[i].page2.languages.language[x].primarylanguage.xmlText#>
            	<Cfset curLangPrim = 1>
            <cfelse>
            	<Cfset curLangPrim = 0>
            </cfif>
    
   
    	<cfquery name="getLangFieldID" datasource="#application.dsn#">
        select fieldid 
        from smg.applicationlookup
        where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(StudentXMLFile.applications.application[i].page2.languages.language[x].xmlText)#">
        and fieldkey = <cfqueryparam cfsqltype="cf_sql_varchar" value='language'>
        </cfquery> 
       
      
        
        
        
        <Cfif #Trim(StudentXMLFile.applications.application[i].page2.languages.language[x].xmlText)# is 'English'>
            <cfquery name="getISEStudentID" datasource="#application.dsn#">
            select studentID 
            from smg_students where soid = <Cfqueryparam cfsqltype="cf_sql_integer" value="#StudentXMLFile.applications.application[i].XmlAttributes.studentid#">
            </cfquery>
            <Cfquery datasource="#applciation.dsn#">
                update smg_students set
                yearsenglish = <cfqueryparam cfsqltype="cf_sql_integer" value="#StudentXMLFile.applications.application[i].page2.languages.language[x].yearsofstudy.xmlText#">
                    where studentid = 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#getISEStudentID.studentid#">
            </Cfquery>
        <cfelse>
            <cfquery datasource="#application.dsn#">
            insert into smg_student_app_language (studentid, languageid, isPrimary, dateCreated, dateModified)
                        values (#getISEStudentID.studentid#, #getLangFieldID.fieldid#, #curIangPrim#, #CreateODBCDate(now())#, #CreateODBCDate(now())#)
            </cfquery>
        </Cfif>
        
  <br />
    </cfloop>
</cfloop>
</cfoutput>
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