<cfsetting requesttimeout="400">

<cfscript>
	vCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
</cfscript>

<cfquery name="qGetStudentsMissingHostAppOffice" datasource="#APPLICATION.DSN#">
    SELECT studentID, hostID
    FROM smg_students
    WHERE active = 1
    AND hostID != 0
    AND ( host_fam_approved IN (1,2,3,4) OR datePISEmailed IS NOT NULL )
    AND hostID IN (
    	SELECT smg_hosts.hostID 
       	FROM smg_hosts 
        INNER JOIN smg_host_app_season ON smg_host_app_season.hostID = smg_hosts.hostID
        	AND smg_host_app_season.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vCurrentSeason#">
      	WHERE active = 1 )
    AND studentID NOT IN (SELECT DISTINCT fk_studentID FROM virtualfolder
 WHERE fk_hostID = hostID AND fk_documentType = 28 AND isDeleted = 0)
</cfquery>

<cfoutput>
	#qGetStudentsMissingHostAppOffice.recordCount#<br/>
</cfoutput>

<cfloop query="qGetStudentsMissingHostAppOffice">
	<cfoutput>#studentID#<br/></cfoutput>
	<cfscript>
		qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=VAL(hostID));
    </cfscript>
    
    <cfoutput>
        <cfsavecontent variable="hostFamilyApplication">
            <cfset FORM.hostID = #hostID#>
            <cfset URL.reportType = "office">
            <cfset relative = "../nsmg/">
            <cfinclude template="../nsmg/hostApplication/printApplication.cfm">
        </cfsavecontent>
        <cfset fileName="#REReplace(qGetHostFamily.familyLastName,'[/, ]','','ALL')#-#DateFormat(NOW(),'mm-dd-yyyy')#-office">
        <cfoutput>
            <cfdocument format="pdf" filename="#fileName#.pdf" overwrite="yes" orientation="portrait" name="uploadFile">
                #hostFamilyApplication#
            </cfdocument>
            <!--- Optimize the PDF --->
            <cfpdf
                action="optimize"
                source="#fileName#.pdf"
                overwrite="yes"
                algo="nearest_neighbour"
                noattachments="yes"
                nobookmarks="yes"
                nocomments="yes"
                nofonts="yes"
                nojavascripts="yes"
                nolinks="yes"
                nometadata="yes"
                nothumbnails="yes"
                />
        </cfoutput>
        <cfscript>
            fullPath=GetDirectoryFromPath(GetCurrentTemplatePath()) & fileName & '.pdf';
            APPLICATION.CFC.UDF.insertInternalFile(filePath=fullPath,fieldID=1,studentID=studentID,hostID=hostID);
        </cfscript>
        <cfquery name="insertFileDetails" datasource="#application.dsn#">
            INSERT INTO  virtualfolder
 (
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

<cfquery name="qGetStudentsMissingHostAppAgent" datasource="#APPLICATION.DSN#">
    SELECT studentID, hostID
    FROM smg_students
    WHERE active = 1
    AND hostID != 0
    AND ( host_fam_approved IN (1,2,3,4) OR datePISEmailed IS NOT NULL )
        AND hostID IN (
    	SELECT smg_hosts.hostID 
       	FROM smg_hosts 
        INNER JOIN smg_host_app_season ON smg_host_app_season.hostID = smg_hosts.hostID
        	AND smg_host_app_season.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vCurrentSeason#">
      	WHERE active = 1 )
    AND studentID NOT IN (SELECT DISTINCT fk_studentID FROM virtualfolder
 WHERE fk_hostID = hostID AND fk_documentType = 29 AND isDeleted = 0)
</cfquery>

<cfoutput>
	#qGetStudentsMissingHostAppAgent.recordCount#<br/>
</cfoutput>

<cfloop query="qGetStudentsMissingHostAppAgent">
	<cfoutput>#studentID#<br/></cfoutput>
	<cfscript>
		qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=VAL(hostID));
    </cfscript>
        
   	<cfoutput>
        <cfsavecontent variable="hostFamilyApplication">
            <cfset FORM.hostID = #hostID#>
            <cfset URL.reportType = "agent">
            <cfset relative = "../nsmg/">
            <cfinclude template="../nsmg/hostApplication/printApplication.cfm">
        </cfsavecontent>
        <cfset fileName="#REReplace(qGetHostFamily.familyLastName,'[/, ]','','ALL')#-#DateFormat(NOW(),'mm-dd-yyyy')#-agent">
        <cfoutput>
            <cfdocument format="pdf" filename="#fileName#.pdf" overwrite="yes" orientation="portrait" name="uploadFile">
                #hostFamilyApplication#
            </cfdocument>
            <!--- Optimize the PDF --->
            <cfpdf
                action="optimize"
                source="#fileName#.pdf"
                overwrite="yes"
                algo="nearest_neighbour"
                noattachments="yes"
                nobookmarks="yes"
                nocomments="yes"
                nofonts="yes"
                nojavascripts="yes"
                nolinks="yes"
                nometadata="yes"
                nothumbnails="yes"
                />
        </cfoutput>
        <cfscript>
            fullPath=GetDirectoryFromPath(GetCurrentTemplatePath()) & fileName & '.pdf';
            APPLICATION.CFC.UDF.insertInternalFile(filePath=fullPath,fieldID=1,studentID=studentID,hostID=hostID);
        </cfscript>
        <cfquery name="insertFileDetails" datasource="#application.dsn#">
            INSERT INTO  virtualfolder
 (
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
                29,
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