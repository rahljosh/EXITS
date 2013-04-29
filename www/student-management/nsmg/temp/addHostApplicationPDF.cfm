<cfsetting requesttimeout="600">

<cfquery name="qGetStudentsMissingHostApp" datasource="#APPLICATION.DSN#">
    SELECT studentID, hostID
    FROM smg_students
    WHERE active = 1
    AND hostID != 0
    AND host_fam_approved IN (1,2,3,4)
    AND hostID IN (SELECT hostID FROM smg_hosts WHERE hostAppStatus != 0 AND active = 1)
    AND studentID NOT IN (SELECT DISTINCT fk_studentID FROM virtualFolder WHERE fk_documentType = 28)
</cfquery>

<cfoutput>
	#qGetStudentsMissingHostApp.recordCount#<br/>
</cfoutput>

<cfloop query="qGetStudentsMissingHostApp">
	<cfoutput>#studentID#<br/></cfoutput>
	<cfscript>
		qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=VAL(hostID));
    </cfscript>
    
    <cfoutput>
        <cfsavecontent variable="hostFamilyApplication">
            <cfset FORM.hostID = #hostID#>
            <cfset URL.reportType = "office">
            <cfset relative = "../">
            <cfinclude template="../hostApplication/printApplication.cfm">
        </cfsavecontent>
        <cfset fileName="#qGetHostFamily.familyLastName#-#DateFormat(NOW(),'mm-dd-yyyy')#-office">
        <cfoutput>
            <cfdocument format="pdf" filename="#fileName#.pdf" overwrite="yes" orientation="portrait" name="uploadFile">
                #hostFamilyApplication#
            </cfdocument>
        </cfoutput>
        <cfscript>
            fullPath=GetDirectoryFromPath(GetCurrentTemplatePath()) & fileName & '.pdf';
            APPLICATION.CFC.UDF.insertInternalFile(filePath=fullPath,fieldID=1,studentID=studentID,hostID=hostID);
        </cfscript>
        <cfquery name="insertFileDetails" datasource="#application.dsn#">
            INSERT INTO  virtualFolder (
                fk_categoryID, 
                fk_documentType, 
                fileDescription,
                fileName, 
                filePath, 
                fk_studentID,
                fk_hostid,
                dateAdded,
                generatedHow,
                uploadedBy)
            VALUES(
                6,
                28,
                'Host Family Application',
                '#fileName#.pdf', 
                'uploadedfiles/virtualFolder/#studentID#/#hostID#/',
                #studentID#,
                #hostID#,
                #now()#,
                'auto',
                #client.userid#)
        </cfquery>
        
        <cfsavecontent variable="hostFamilyApplication">
            <cfset FORM.hostID = #hostID#>
            <cfset URL.reportType = "agent">
            <cfset relative = "../">
            <cfinclude template="../hostApplication/printApplication.cfm">
        </cfsavecontent>
        <cfset fileName="#qGetHostFamily.familyLastName#-#DateFormat(NOW(),'mm-dd-yyyy')#-agent">
        <cfoutput>
            <cfdocument format="pdf" filename="#fileName#.pdf" overwrite="yes" orientation="portrait" name="uploadFile">
                #hostFamilyApplication#
            </cfdocument>
        </cfoutput>
        <cfscript>
            fullPath=GetDirectoryFromPath(GetCurrentTemplatePath()) & fileName & '.pdf';
            APPLICATION.CFC.UDF.insertInternalFile(filePath=fullPath,fieldID=1,studentID=studentID,hostID=hostID);
        </cfscript>
        <cfquery name="insertFileDetails" datasource="#application.dsn#">
            INSERT INTO  virtualFolder (
                fk_categoryID, 
                fk_documentType, 
                fileDescription,
                fileName, 
                filePath, 
                fk_studentID,
                fk_hostid,
                dateAdded,
                generatedHow,
                uploadedBy)
            VALUES(
                2,
                28,
                'Host Family Application',
                '#fileName#.pdf', 
                'uploadedfiles/virtualFolder/#studentID#/#hostID#/',
                #studentID#,
                #hostID#,
                #now()#,
                'auto',
                #client.userid#)
        </cfquery>
    </cfoutput>
</cfloop>