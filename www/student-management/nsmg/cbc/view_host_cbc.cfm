<!--- ------------------------------------------------------------------------- ----
	
	File:		view_host_cbc.cfm
	Author:		Marcus Melo
	Date:		November 25, 2009
	Desc:		Reads and Display XML

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="0">    
    <cfparam name="URL.CBCFamID" default="0">.
    <cfparam name="URL.file" default="">
    
    <cfscript>
		// Get Batch Information		
		qGetBatchInfo =  APPLICATION.CFC.CBC.getCBCHostByID(
			hostID=URL.hostID,
			CBCFamID=URL.CBCFamID
		);												   
	</cfscript>
    
</cfsilent>

<cfoutput>

<!--- Check if the results are stored in the database --->
<cfif LEN(qGetBatchInfo.xml_received)>
	
    <cftry>
    
		<cfscript>
            // Display Results		
            APPLICATION.CFC.CBC.displayXMLResult(
                companyID=qGetBatchInfo.companyID, 
                responseXML=qGetBatchInfo.xml_received, 
                userType=qGetBatchInfo.cbc_type,
                hostID=qGetBatchInfo.hostID,
                familyID=qGetBatchInfo.familyID,
                dateProcessed=qGetBatchInfo.date_sent
            );												   
        </cfscript>
        
        <cfcatch type="any">
        	<p>It seems we have received an invalid XML file from backgroundchecks.com. Please check results for this host family at <a href="http://www.backgroundchecks.com/">http://www.backgroundchecks.com/</a></p>
        </cfcatch>
    
    </cftry>

<cfelse>
	
    <cftry>

        <cffile action="read" file="#AppPath.cbcXML##qGetBatchInfo.companyshort#/#URL.file#" variable="receivedFile">
    
        <cfscript>
            // Parse XML File
            responseXML = XmlParse(receivedFile);
            
            // Display Results		
            APPLICATION.CFC.CBC.displayXMLResult(
                companyID=qGetBatchInfo.companyID, 
                responseXML=responseXML, 
                userType=qGetBatchInfo.cbc_type,
                hostID=qGetBatchInfo.hostID,
				familyID=qGetBatchInfo.familyID,
				dateProcessed=qGetBatchInfo.date_sent
            );			
			
			// Updates XML Received		
			APPLICATION.CFC.CBC.UpdateHostXMLReceived(
				cbcFamID=qGetBatchInfo.cbcfamID,
				xmlReceived=responseXML
			);
			
			//Check if XML Received has been updated
			qGetBatchInfo =  APPLICATION.CFC.CBC.getCBCHostByID(
				hostID=URL.hostID,
				CBCFamID=URL.CBCFamID
			);												   
        </cfscript>

		<!--- Delete XML file --->
    	<cfif LEN(qGetBatchInfo.xml_received)>
	    	<cffile action="delete" file="#AppPath.cbcXML##qGetBatchInfo.companyshort#/#URL.file#">
    	</cfif>
    	
        <cfcatch type="any">
        	<p>The file /uploadedfiles/xml_files/gis/#qGetBatchInfo.companyshort#/#URL.file# could not be found.</p>
        </cfcatch>
    
    </cftry>

</cfif>

</cfoutput>