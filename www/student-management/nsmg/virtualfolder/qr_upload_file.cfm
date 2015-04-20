<!--- Kill Extra Output --->
<cfsilent>
    	
	<!--- Param Form Variables ---> 
    <cfparam name="FORM.UploadFile" default="">  
    <cfparam name="FORM.unqid" default="">         
    <cfparam name="FORM.other_category" default="">

	<cfparam name="emailRecipient" default="#APPLICATION.EMAIL.support#">

	<cfscript>	
        // Make sure there is a file
		if ( NOT LEN(FORM.UploadFile) OR NOT LEN(FORM.unqid) ) { 
			include "error_message.cfm";
			abort;
		}
	
		// Get Student Info
        qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=FORM.unqID);

		// Get Status
		qGetCategory = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='virtualFolderCategory', fieldID=FORM.category);
		
        // Get Folder Path 
        currentDirectory = "#APPLICATION.PATH.onlineApp.virtualFolder##qGetStudentInfo.studentid#";
    
        // Make sure the folder Exists
        AppCFC.UDF.createFolder(currentDirectory);

		studentProfileLink = '#CLIENT.exits_url#/nsmg/index.cfm?curdoc=student_info&studentID=#qGetStudentInfo.studentID#';		
		//studentProfileLink = '#CLIENT.exits_url#/nsmg/virtualfolder/#qGetStudentInfo.uniqueID#';
		
		studentProfileIntLink = '#client.exits_url#/nsmg/index.cfm?curdoc=intrep/int_student_info&unqid=#qGetStudentInfo.uniqueID#';
	</cfscript>

    <cfquery name="qGetUser" datasource="MySql">
        SELECT 
            userid, 
            firstname, 
            lastname, 
            businessname, 
            email
        FROM 
            smg_users
        WHERE 
            userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    </cfquery>

    <cfquery name="qIntlRep" datasource="mysql">
        SELECT 
        	email
        FROM 
        	smg_users 
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.intrep#">
    </cfquery>
	
    <!--- EMAIL FACILITATORS TO LET THEM KNOW THERE IS A DOCUMENT ---->
    <cfquery name="qGetRegionInfo" datasource="MySQL">
        SELECT 
            s.regionassigned, 
            r.regionname, 
            r.regionfacilitator, 
            r.regionid, 
            r.company,
            u.firstname, 
            u.lastname, 
            u.email 
        FROM 
            smg_students s 
        INNER JOIN 
            smg_regions r ON s.regionassigned = r.regionid
        LEFT JOIN 
            smg_users u ON r.regionfacilitator = u.userid
        WHERE 
            s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
    </cfquery>
    
    <cfscript>
		// Dev - Always Email Support
        if ( APPLICATION.isServerLocal ) {
			emailRecipient = APPLICATION.EMAIL.support; 	
		// Check if is a PHP student - Email PHP
		} else if ( qGetStudentInfo.companyid EQ 6 ) {
            emailRecipient = APPLICATION.EMAIL.PHPContact;
		// Checki if ESI student - Email all facilitators
		} else if ( qGetStudentInfo.companyID EQ 14 ) {
			emailRecipient = APPLICATION.EMAIL.ESIFacilitators;
        // Check if there is a valid facilitator email address
		} else if ( IsValid("email", qGetRegionInfo.email) ) {
            emailRecipient = qGetRegionInfo.email;
        }
	</cfscript>	
    
</cfsilent>

<cfoutput>

    <cffile action="upload" filefield="UploadFile" destination="#currentDirectory#" nameconflict="makeunique" mode="777">
    
    <!--- check file size - 4mb limit --->
    <cfset newfilesize = file.FileSize / 4024>
    
    <cfif newfilesize GT 4048>  
        <cffile action = "delete" file = "#currentDirectory#/#cffile.serverfile#">
        <script language="JavaScript">
            <!-- 
            alert("The file you are trying to upload is bigger than 4mb. Please try again. Files can not be bigger than 4mb.");
                location.replace("list_vfolder.cfm?unqid=#FORM.unqid#");
            -->
        </script>
    </cfif>
    
    <!--- Resize Image Files --->
    <cfif ListFind("jpg,peg,gif,tif,tiff,png", LCase(file.ServerFileExt))>
        
        <cfscript>
            // Invoke image.cfc component
            imageCFC = createObject("component","image");
            
            // scaleX image to 1000px wide
            scaleX1000 = imageCFC.scaleX("", "#currentDirectory#/#CFFILE.serverfile#", "#currentDirectory#/new#CFFILE.serverfile#", 1000);
        </cfscript>
        
        <!--- if file has been resized ---->
        <cfif FileExists("#currentDirectory#/new#CFFILE.ServerFileName#.#CFFILE.ServerFileExt#")>
            
            <!--- delete original file --->
            <cffile action="delete" file="#currentDirectory#/#CFFILE.serverfile#">
            
            <!--- rename resized file --->
            <cffile action="rename" source="#currentDirectory#/new#CFFILE.ServerFileName#.#CFFILE.ServerFileExt#" destination="#currentDirectory#/#file.ServerFileName#.#LCase(CFFILE.ServerFileExt)#" attributes="normal" mode="777">
    
        </cfif>
    
    </cfif>
    
    <cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">
    
    <cfquery name="insert_category" datasource="MySql">
        INSERT INTO 
            smg_virtualfolder 
            (
                studentid, 
                categoryid, 
                other_category, 
                filename, 
                filesize
            )
        VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.category#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.other_category#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydirectory.name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#mydirectory.size#">
            )
    </cfquery>
    
    <!--- Email Local Person --->
        <cfsavecontent variable="email_message">
            Dear #qGetRegionInfo.firstname# #qGetRegionInfo.lastname#,<br><br>This e-mail is just to let you know a new document has been uploaded into #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#'s (###qGetStudentInfo.studentid#) virtual folder by #qGetUser.businessname# #qGetUser.firstname# #qGetUser.lastname#.
            The document has been recorded in the category #qGetCategory.name# <cfif LEN(FORM.other_category)>&nbsp; - &nbsp; #FORM.other_category#</cfif>.<br><br>
            Please click <a href="#studentProfileLink#">here</a> and click on "virtual folder" in the right menu. <br><br>
            
            Sincerely,<br>
            EXITS - #CLIENT.companyname#<br><br>
        </cfsavecontent>
                    
        <!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#emailRecipient#">
            <cfinvokeargument name="email_subject" value="Virtual Folder - Upload Notification for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
        </cfinvoke>
    <!----End of Email---->
    
    
    <!--- Email International Representative if file has been upload by Office and in Production Environment --->
	<cfif ListFind("1,2,3,4,5,6,7", CLIENT.userType) AND NOT APPLICATION.isServerLocal>
    
        <cfsavecontent variable="email_message">
            This e-mail is just to let you know a new document has been uploaded into #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#'s (###qGetStudentInfo.studentid#) virtual folder by #qGetUser.businessname# #qGetUser.firstname# #qGetUser.lastname#.
            The document has been recorded in the category #qGetCategory.name# <cfif LEN(FORM.other_category)>&nbsp; - &nbsp; #FORM.other_category#</cfif>.<br><br>
            Please click <a href="#studentProfileIntLink#">here</a> to see the student's virtual folder.<br><br>
            Sincerely,<br>
            EXITS - #CLIENT.companyname#<br><br>
        </cfsavecontent>
        
        <!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#qIntlRep.email#">
            <cfinvokeargument name="email_subject" value="Virtual Folder - Upload Notification for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
        </cfinvoke>
        
    </cfif> 
    <!---- End of Email to Intl. Representative --->

    <cfscript>
        // Set Page Message
        SESSION.pageMessages.Add("Form successfully submitted.");
        Location("list_vfolder.cfm?unqid=#FORM.unqid#", "no");
    </cfscript>

</cfoutput>
