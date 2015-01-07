<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Josh Rahl
	Date:		July 25, 2013
	Desc:		Index file of the case management section
				
				#CGI.SCRIPT_NAME#?curdoc=caseMgmt/index
				
----- ------------------------------------------------------------------------- --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />


<!--- Kill extra output --->
<cfsilent>

	<!--- Param local variables --->
	<cfparam name="url.action" default="list">
    <cfparam name="URL.uniqueID" default="" />
    <cfparam name="URL.studentid" default="">
    <Cfparam name="URL.caseid" default="">
    <Cfparam name="URL.new" default="0">
    <cfparam name="FORM.uploadFile" default="0">
    <cfparam name="URL.delete" default="0">
    <cfparam name="URL.viewAll" default="0">
<cfif isDefined('url.reset')>
	<cfset SESSION.studentList = ''>
</cfif>
<cfif isDefined('form.deleteCase')>
	
	<cfif val(url.caseid)>
        <cfquery name="studentInvolved" datasource="#application.dsn#">
        select fk_studentid
        from smg_casemgmt_users_involved
        where fk_caseid = #url.caseid#
        </cfquery>
        
        <Cfquery datasource="#application.dsn#">
        update smg_casemgmt_cases set isdeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        where caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.caseid#">
        </Cfquery>
        
        <cfset SESSION.studentlist=''>
        <Cfif studentInvolved.recordcount eq 1>
        <cflocation url="?curdoc=caseMgmt/index&studentid=#studentInvolved.fk_studentid#" addtoken="no">
        <Cfelse>
            <cflocation url="?curdoc=caseMgmt/index&action=viewCaseList&viewAll=1" addtoken="no">
        </Cfif>
    
    </cfif>

</cfif>

<Cfif val(form.uploadFile) >
	<cfscript>
            // Data Validation
            // Student Transportation
            if  ( NOT  len(TRIM(FORM.fileData)) ) {
				SESSION.formErrors.Add("Please select a file.");
            } 
            // Student Transportation
            if  ( NOT LEN(TRIM(FORM.fileDescription)) and len(TRIM(FORM.fileData)) ) {
				SESSION.formErrors.Add("Please provide a brief description of the file you are uploading.");
            }
			// Student Transportation
            if  (LEN(TRIM(FORM.fileDescription)) and NOT len(TRIM(FORM.fileData)) ) {
				SESSION.formErrors.Add("You entered a description but did not select a file to upload.");
            }
			
	</cfscript>
    <cfif NOT SESSION.formErrors.length()>
	<cfscript>
        // Set Upload Path
									
                    vSetUploadPath = APPLICATION.PATH.caseMgmt & URL.caseID & "/";
    
                    // Upload File
                    stResult = APPLICATION.CFC.DOCUMENT.uploadFile(
                        foreignTable="smg_casemgmt",
                        foreignID=URL.caseID, 
                        documentTypeID=33,
                        uploadPath=vSetUploadPath,					
                        description="#form.fileDescription#",
                        allowedExt="jpg,jpeg,png,pdf,doc,docx,ppt,pps,pptx,ppsx,gif,pages,numbers,odt,xls,"
                    );
    </cfscript>
    <cfelse>
    	<cfset FORM.additionialInfoDiv = 1>
    </cfif>
</Cfif>

<Cfif val(url.caseid)>
	<cfscript>
        //Get case info based on CASE ID
        qBasicCaseDetails =  APPLICATION.CFC.CASEMGMT.basicCaseDetails(caseid=url.caseid);
		qFullCaseDetails =  APPLICATION.CFC.CASEMGMT.fullCaseDetails(caseid=url.caseid);
		qUsersInvolved =  APPLICATION.CFC.CASEMGMT.usersInvolved(caseid=url.caseid);
		qGetFiles = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="",	
			foreignID=url.caseid, 			
			documentGroup="caseMgmt" 
		);
    </cfscript>
<cfelseif val(url.studentid)>
	<cfscript>
        // Get case info based on STUDENT ID
        qBasicCaseDetails =  APPLICATION.CFC.CASEMGMT.basicCaseDetails(personid=url.studentid);
		qFullCaseDetails =  APPLICATION.CFC.CASEMGMT.fullCaseDetails(caseid=0);
		qUsersInvolved =  APPLICATION.CFC.CASEMGMT.usersInvolved(personid=url.studentid);
		qGetFiles = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_casemgmt",	
			foreignID=url.caseid, 			
			documentGroup="caseMgmt" 
		);
    </cfscript>
<cfelse>
	<cfscript>
        // Get case info based on STUDENT ID
       	qBasicCaseDetails =  APPLICATION.CFC.CASEMGMT.yourCases(personID=client.userid);
		//qBasicCaseDetails =  APPLICATION.CFC.CASEMGMT.basicCaseDetails(personID=client.userid);
		qFullCaseDetails =  APPLICATION.CFC.CASEMGMT.fullCaseDetails(caseid=0);
		qUsersInvolved =  APPLICATION.CFC.CASEMGMT.usersInvolved(personid=client.userid);
		qGetFiles = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_casemgmt",	
			foreignID=url.caseid, 			
			documentGroup="caseMgmt" 
		);
    </cfscript>
</Cfif>


<!---If there are cases, redirect to the list of cases for a student.  Otherwise, go to new case.---->
<cfif val(url.studentid)>
    <cfif qBasicCaseDetails.recordcount neq 0  and url.action neq 'viewCase' and not val(url.new)>
        <cfset url.action ="viewCaseList">
    </cfif>
</cfif>
</cfsilent>

	 <script src="linked/chosen/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="linked/css/chosen.css" />


<div align="center">
<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="divOnly"
        />
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="divOnly"
        />
</div>
<cfif ListFind("1,2,3,4,5,6,7", CLIENT.userType)>
	
    <!--- Office Users --->
    
    <cfswitch expression="#url.action#">
    
        <cfcase value="viewCase,viewCaseList,addStudent,addDetails" delimiters=",">
    
            <!--- Include template --->
            <cfinclude template="_#url.action#.cfm" />
    
        </cfcase>
    
    
        <!--- The view indv case is defualt now, shoudl be set to viewCaseList --->
        <cfdefaultcase>
            
            <!--- Include template --->
            <cfinclude template="_basics.cfm" />
    
        </cfdefaultcase>
    
    </cfswitch>

<cfelse>
    
other user needs to be set up
</cfif>