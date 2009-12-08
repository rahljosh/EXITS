<!--- ------------------------------------------------------------------------- ----
	
	File:		view_user_cbc.cfm
	Author:		Marcus Melo
	Date:		November 25, 2009
	Desc:		Reads and Display XML

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfparam name="URL.userID" default="0">    
    <cfparam name="URL.batchID" default="0">
    <cfparam name="URL.userType" default="">
    <cfparam name="URL.file" default="">
    
    <cfscript>
		// Get Batch Information		
		qGetBatchInfo = APPCFC.CBC.getCBCUserByID(
			userID=URL.userID,
			batchID=URL.batchID,
			cbcType=URL.userType
		);												   
	</cfscript>
    
</cfsilent>

<cfoutput>

<!--- Check if the results are stored in the database --->
<cfif LEN(qGetBatchInfo.xml_received)>

    <cfscript>
		// Display Results		
		APPCFC.CBC.displayXMLResult(
			companyID=qGetBatchInfo.companyID, 
			responseXML=qGetBatchInfo.xml_received, 
			userType='User',
			userID=qGetBatchInfo.userID,
			familyID=qGetBatchInfo.familyID
		);												   
	</cfscript>

<cfelse>
	
    <cftry>

        <cffile action="read" file="/var/www/html/student-management/nsmg/uploadedfiles/xml_files/gis/#qGetBatchInfo.companyshort#/#URL.file#" variable="receivedFile">
    
        <cfscript>
            // Parse XML File
            responseXML = XmlParse(receivedFile);
            
            // Display Results		
            APPCFC.CBC.displayXMLResult(
                companyID=qGetBatchInfo.companyID, 
                responseXML=responseXML, 
                userType='User',
                userID=qGetBatchInfo.userID,
				familyID=qGetBatchInfo.familyID
            );												   
        </cfscript>
	
        <cfcatch type="any">
        	<p>
	        	The file /uploadedfiles/xml_files/gis/#qGetBatchInfo.companyshort#/#URL.file# file could not be found.
            </p>
        </cfcatch>
    
    </cftry>

</cfif>

</cfoutput>