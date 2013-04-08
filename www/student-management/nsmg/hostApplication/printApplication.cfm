<!--- ------------------------------------------------------------------------- ----
	
	File:		printApplication.cfm
	Author:		Marcus Melo
	Date:		02/01/2013
	Desc:		Print Complete Application

	Updated:	
	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?hostID=37739
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
	<!--- Param local variables --->
	<cfparam name="action" default="">

    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="0">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.hostID" default="0">

    <cfscript>	
		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
		
		// Get Host Application Information
		qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=FORM.hostID);	
	</cfscript>
    
    <cfhtmlhead text='<link rel="stylesheet" href="../linked/css/hostApp.css" type="text/css">'>

</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
	filePath="../"
/>	

	<!--- Check to see which action we are taking. --->
    <cfswitch expression="#action#">
        
        <!--- Individual Pages --->
        <cfcase value="printPage1,printPage2,printPage3,printPage4,printPage5,printPage6,printPage7,printPage8,printPage9,printPage10,printPage11,printPage12" delimiters=",">
    
            <!--- Include template --->
            <cfinclude template="#action#.cfm" />
    
        </cfcase>
    
        <!--- Complete Application --->
        <cfdefaultcase>
            
            <!--- Include Page 1 - Name & Contact Info --->
            <cfinclude template="printPage1.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>

            <!--- Include Page 2 - Family Members --->
            <cfinclude template="printPage2.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>

            <!--- Include Page 3 - Background Checks --->
            <!--- Merge Existing PDFs --->
            <!--- <cfinclude template="printPage3.cfm" /> --->

            <!--- Include Page 4 - Personal Description --->
            <cfinclude template="printPage4.cfm" />
			
            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>
            
            <!--- Include Page 5 - Hosting Environment --->
            <cfinclude template="printPage5.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>

            <!--- Include Page 6 - Religious Preference --->
            <cfinclude template="printPage6.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>

            <!--- Include Page 7 - Family Rules --->
            <cfinclude template="printPage7.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>

            <!--- Include Page 8 - Family Album --->
            <cfinclude template="printPage8.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>

            <!--- Include Page 9 - School Information --->
            <cfinclude template="printPage9.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>

            <!--- Include Page 10 - Community Profile --->
            <cfinclude template="printPage10.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>

            <!--- Include Page 11 - Confidential Data --->
            <cfinclude template="printPage11.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>

            <!--- Include Page 12 - References --->
            <cfinclude template="printPage12.cfm" />

            <!--- Page Break --->
            <div style="margin:0; padding:0; page-break-after:always"></div>
            
            <!--- Include Confidential Host Family Visit Form --->
            
            <!--- Include School Acceptance --->
            
            <!--- Include Reference Questionnaire --->
    
        </cfdefaultcase>
    
    </cfswitch>

<!--- Page Footer --->
<gui:pageFooter
	footerType="noFooter"
	filePath="../"
/>