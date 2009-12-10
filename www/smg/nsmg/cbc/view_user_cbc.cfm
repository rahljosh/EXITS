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
		qGetBatchInfo = APPCFC.CBC.getCBCUserByID(
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EXITS - CBC Results</title>
</head>
<body>

<cfoutput>

<!--- Check if the results are stored in the database --->
<cfif LEN(qGetBatchInfo.xml_received)>

    <cfscript>
		// Display Results		
		APPCFC.CBC.displayXMLResult(
			companyID=qGetBatchInfo.companyID, 
			responseXML=qGetBatchInfo.xml_received, 
			userType=userType,
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
                userType=userType,
                userID=qGetBatchInfo.userID,
				familyID=qGetBatchInfo.familyID
            );												   
        </cfscript>
	
        <cfcatch type="any">
        	<p>
	        	The file /uploadedfiles/xml_files/gis/#qGetBatchInfo.companyshort#/#URL.file# could not be found.
            </p>
        </cfcatch>
    
    </cftry>

</cfif>

</cfoutput>

</body>
</html>
