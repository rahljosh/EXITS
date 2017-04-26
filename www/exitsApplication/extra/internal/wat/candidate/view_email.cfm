<!--- ------------------------------------------------------------------------- ----
	
	File:		view_email.cfm
	Author:		Bruno Lopes
	Date:		April 25, 2017
	Desc:		

----- ------------------------------------------------------------------------- --->



    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />
    
    
    
    <cfparam name="URL.id" default="">

    
    <cfquery name="qEmailTemplate" datasource="#APPLICATION.DSN.Source#">
        SELECT name, subject, content
        FROM extra_emails
        WHERE id = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.id#">
    </cfquery>
    
    



<cfoutput>


	<strong>Subject:</strong> #Replace(qEmailTemplate.subject, "*2016*", year(now()), "all")#

    <hr />

    #Replace(qEmailTemplate.content, "*2016*", year(now()), "all")#

    
</cfoutput>