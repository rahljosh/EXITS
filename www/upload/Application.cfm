<cfapplication 
	name="smg" 
    clientmanagement="yes" 
    sessionmanagement="yes" 
    setdomaincookies="yes" 
    sessiontimeout="#CreateTimeSpan(0,10,40,1)#">

    <CFQUERY name="selectdb" datasource="MySQL">
        USE smg
    </CFQUERY>
	
    <cfparam name="URL.referrer" default="ise.exitsapplication.com">

	<!--- Added by Marcus Melo 03-31-2010 --->
	<cfscript>	
		/***** Create APPLICATION.PATH structure *****/
		APPLICATION.PATH = StructNew();		
		
		// Set a short name for the APPLICATION.PATH
		AppPath = APPLICATION.PATH;
		
		// Base Path eg. C:\websites\smg\nsmg\
		AppPath.base = getDirectoryFromPath(getBaseTemplatePath());
		
		// Replace C:\websites\upload\ to C:\websites\student-management\nsmg
		AppPath.Base = ReplaceNoCase(AppPath.Base, 'upload', 'student-management/nsmg');

		
		AppPath.companyLogo = AppPath.base & "pics/logos/"; 
		AppPath.uploadedFiles = AppPath.base & 'uploadedfiles/';	
		
		// These are inside uploadedFiles folder
		AppPath.cbcXML = AppPath.uploadedFiles & "xml_files/gis/";
		AppPath.newsMessage = AppPath.uploadedFiles & "news/";
		AppPath.pdfDocs = AppPath.uploadedFiles & 'pdf_docs/';	
		AppPath.sevis = AppPath.uploadedFiles & "sevis/";
		AppPath.temp = AppPath.uploadedFiles & "temp/";	
		AppPath.welcomePics = AppPath.uploadedFiles & "welcome_pics/";	
		AppPath.xmlFiles = AppPath.uploadedFiles & "xml_files/";	
	
	
		// Make sure we have a valid URL.referrer
		if ( NOT ListFind("ise.exitsapplication.com,case.exitsapplication.com,sea.exitsapplication.com,php.exitsapplication.com,wep.exitsapplication.com,www.student-management.com", URL.referrer) ) {
			URL.referrer = "ise.exitsapplication.com"; 
		}		


		// These are used in the student online application
		AppPath.onlineApp = StructNew();
		
		// URL Used on Upload/Delete Files
		AppPath.onlineApp.URL = 'https://' & URL.referrer & '/nsmg/student_app/';				
		AppPath.onlineApp.reloadURL = 'https://' & URL.referrer & '/nsmg/student_app/querys/reload_window.cfm';		
		AppPath.onlineApp.imageURL = 'http://' & URL.referrer & '/nsmg/pics/';				

		AppPath.onlineApp.uploadURL = 'http://new.upload.student-management.com/';

		AppPath.onlineApp.picture = AppPath.uploadedFiles & "web-students/";
		AppPath.onlineApp.letters = AppPath.uploadedFiles & "letters/";
		AppPath.onlineApp.studentLetter = AppPath.uploadedFiles & "letters/students/";
		AppPath.onlineApp.parentLetter = AppPath.uploadedFiles & "letters/parents/";		
		AppPath.onlineApp.familyAlbum = AppPath.uploadedFiles & "online_app/picture_album/";
		AppPath.onlineApp.inserts = AppPath.uploadedFiles & "online_app/";
		AppPath.onlineApp.virtualFolder = AppPath.uploadedFiles & "virtualfolder/";
		AppPath.onlineApp.xmlApp = AppPath.uploadedFiles & "xml_app/";
	</cfscript>
	<!--- End of Added by Marcus Melo 03-31-2010 --->
    
    <!--- Include Functions Template --->
    <cfinclude template="_functions.cfm">
    
