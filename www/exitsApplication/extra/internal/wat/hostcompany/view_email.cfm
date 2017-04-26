<!--- ------------------------------------------------------------------------- ----
	
	File:		view_email.cfm
	Author:		Bruno Lopes
	Date:		April 25, 2017
	Desc:		

----- ------------------------------------------------------------------------- --->


<cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />

<cfparam name="URL.id" default="">
<cfparam name="URL.hostCompanyID" default="">


<cfquery name="qEmailTemplate" datasource="#APPLICATION.DSN.Source#">
    SELECT ee.name, ee.subject, eet.email_content
    FROM extra_emails ee
    INNER JOIN extra_emails_tracking eet ON ee.id = eet.email_id
    WHERE ee.id = <cfqueryparam cfsqltype="cf_sql_decimal" value="#URL.id#">
        AND eet.hc_id = <cfqueryparam cfsqltype="cf_sql_decimal" value="#URL.hostCompanyID#">
</cfquery>

<cfoutput>


	<strong>Subject:</strong> #Replace(qEmailTemplate.subject, "*2016*", year(now()), "all")#

    <hr />

    <gui:pageHeader
        headerType="email"
        companyID="8"
        displayEmailLogoHeader="1"
    />

    #qEmailTemplate.email_content#

    <!--- Page Footer --->
    <gui:pageFooter
        footerType="email"
        companyID="8"
    />

    
</cfoutput>
