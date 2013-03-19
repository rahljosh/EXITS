<!--- ------------------------------------------------------------------------- ----
	
	File:		printApplication.cfm
	Author:		Marcus Melo
	Date:		02/01/2013
	Desc:		Print Complete Application

	Updated:	
	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printpage1&hostID=37739
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
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

</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
	filePath="../../"
/>	
	<link rel="stylesheet" href="../linked/css/hostApp.css" type="text/css">

	<!--- Check to see which action we are taking. --->
    <cfswitch expression="#action#">
        
        <!--- Individual Pages --->
        <cfcase value="printPage1,printPage2,printPage3,printPage4,printPage5,printPage6,printPage7" delimiters=",">
    
            <!--- Include template --->
            <cfinclude template="#action#.cfm" />
    
        </cfcase>
    
        <!--- Complete Application --->
        <cfdefaultcase>
            
            <!--- Include Page 1 - Name & Contact Info --->
            <cfinclude template="printPage1.cfm" />

            <!--- Include Page 2 - Family Members --->
            <cfinclude template="printPage2.cfm" />

            <!--- Include Page 3 - Background Checks --->
            <cfinclude template="printPage3.cfm" />

            <!--- Include Page 4 - Personal Description --->
            <cfinclude template="printPage4.cfm" />

            <!--- Include Page 5 - Hosting Environment --->
            <cfinclude template="printPage5.cfm" />

            <!--- Include Page 6 - Religious Preference --->
            <cfinclude template="printPage6.cfm" />

            <!--- Include Page 7 - Family Rules --->
            <cfinclude template="printPage7.cfm" />

            <!--- Include Page 8 - Family Album --->
            <cfinclude template="printPage8.cfm" />

            <!--- Include Page 9 - School Information --->
            <cfinclude template="printPage9.cfm" />

            <!--- Include Page 10 - Community Profile --->
            <cfinclude template="printPage10.cfm" />

            <!--- Include Page 11 - Confidential Data --->
            <cfinclude template="printPage11.cfm" />

            <!--- Include Page 12 - References --->
            <cfinclude template="printPage12.cfm" />
            
            <!--- Include Confidential Host Family Visit Form --->
            
            <!--- Include School Acceptance --->
            
            <!--- Include Reference Questionnaire --->
    
        </cfdefaultcase>
    
    </cfswitch>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
	filePath="../../"
/>