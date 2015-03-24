<!--- ------------------------------------------------------------------------- ----
	
	File:		view_user_cbc.cfm
	Author:		Marcus Melo
	Date:		November 25, 2009
	Desc:		Reads and Display XML

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param URL Variables --->
    <cfparam name="URL.userID" default="0">    
    <cfparam name="URL.cbcID" default="0">
    <cfparam name="URL.file" default="">
    
    <cfscript>
		// Get Batch Information		
		qGetBatchInfo = APPLICATION.CFC.CBC.getCBCUserByID(
			userID=URL.userID,
			cbcID=URL.cbcID
		);												   

		// Set Usertype
		if ( NOT VAL(qGetBatchInfo.familyID) ) {
			userType = 'User';
		} else {
			userType = 'Member';
		}
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
                userType=userType,
                userID=qGetBatchInfo.userID,
                familyID=qGetBatchInfo.familyID,
                dateProcessed=qGetBatchInfo.date_sent
            );										
        </cfscript>

        <cfcatch type="any">
        	<p>There is an issue with the XML file we received from backgroundchecks.com. You can check results for this user at <a href="http://www.backgroundchecks.com/">http://www.backgroundchecks.com/</a></p>
           <br /><Br />
           Here are the raw results, to help determine what the issue might be:  If there is a lot of informaiton, please login to the website to view the formatted results.  For some reason we are not able to format them nicely. 
           #qGetBatchInfo.xml_received#
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
                userType=userType,
                userID=qGetBatchInfo.userID,
				familyID=qGetBatchInfo.familyID,
				dateProcessed=qGetBatchInfo.date_sent
            );		
			
			// Updates XML Received		
			APPLICATION.CFC.CBC.updateUserXMLReceived(
				cbcID=qGetBatchInfo.cbcID,
				xmlReceived=responseXML
			);
			
			//Check if XML Received has been updated
			qGetBatchInfo = APPLICATION.CFC.CBC.getCBCUserByID(
				userID=URL.userID,
				cbcID=URL.cbcID
			);												   
        </cfscript>
	
    	<cfif LEN(qGetBatchInfo.xml_received)>
	    	<cffile action="delete" file="#AppPath.cbcXML##qGetBatchInfo.companyshort#/#URL.file#">
    	</cfif>
        
        <cfcatch type="any">
        	<p>
	        	The file /uploadedfiles/xml_files/gis/#qGetBatchInfo.companyshort#/#URL.file# could not be found.
            </p>
        </cfcatch>
    
    </cftry>

</cfif>

</cfoutput>