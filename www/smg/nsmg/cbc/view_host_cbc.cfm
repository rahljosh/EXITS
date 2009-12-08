<!--- ------------------------------------------------------------------------- ----
	
	File:		view_host_cbc.cfm
	Author:		Marcus Melo
	Date:		November 25, 2009
	Desc:		Reads and Display XML

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfparam name="URL.hostID" default="0">    
    <cfparam name="URL.batchID" default="0">
    <cfparam name="URL.hostType" default="">
    <cfparam name="URL.file" default="">
    
    <cfscript>
		// Get Batch Information		
		qGetBatchInfo =  APPCFC.CBC.getCBCHostByID(
			hostID=URL.hostID,
			batchID=URL.batchID,
			cbcType=URL.hostType
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
			userType=URL.hostType,
			hostID=qGetBatchInfo.hostID,
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
                userType=URL.hostType,
                hostID=qGetBatchInfo.hostID,
				familyID=qGetBatchInfo.familyID
            );												   
        </cfscript>
	
        <cfcatch type="any">
        	<p>
	        	/uploadedfiles/xml_files/gis/#qGetBatchInfo.companyshort#/#URL.file# file could not be found.
            </p>
        </cfcatch>
    
    </cftry>

</cfif>

</cfoutput>