<!--- ------------------------------------------------------------------------- ----
	
	File:		view_user_cbc.cfm
	Author:		Marcus Melo
	Date:		November 25, 2009
	Desc:		Reads and Display XML

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfparam name="URL.hostID" default="0">
    <cfparam name="URL.batchID" default="0">
    <cfparam name="URL.file" default="">
    
    <cfscript>
		// Get Batch Information		
		qGetBatchInfo =  APPCFC.CBC.getCBCHostByID(
			hostID=hostID,
			batchID=batchID
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
			userType='host',
			hostID=qGetBatchInfo.hostID
		);												   
	</cfscript>

<cfelse>
	
    <cftry>

        <cffile action="read" file="/var/www/html/student-management/nsmg/uploadedfiles/xml_files/gis/#qGetBatchInfo.companyshort#/#url.file#" variable="rec_xml">
    
        <cfscript>
            // Parse XML File
            responseXML = XmlParse(rec_xml);
            
            // Display Results		
            APPCFC.CBC.displayXMLResult(
                companyID=qGetBatchInfo.companyID, 
                responseXML=responseXML, 
                userType='host',
                hostID=qGetBatchInfo.hostID, 
                firstName='', 
                lastName=''
            );												   
        </cfscript>
	
        <cfcatch type="any">
        	<p>
	        	/var/www/html/student-management/nsmg/uploadedfiles/xml_files/gis/#qGetBatchInfo.companyshort#/#url.file# file could not be found.
            </p>
        </cfcatch>
    
    </cftry>

</cfif>

</cfoutput>