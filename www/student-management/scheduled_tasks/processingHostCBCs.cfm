<!--- Request a longer time out period --->
<cfsetting requesttimeout="600">

<!--- Get all host CBCs that are in processing and run them --->
<cfscript>
	// Get pending host CBCs
	qGetPendingHostCBCs = APPLICATION.CFC.CBC.getPendingCBCHost(activeSeason=1,batch=0);
	
	// Loop through all pending host CBCs
	for (i = 1; i LTE qGetPendingHostCBCs.recordCount; i = i+1) {
		// Set variables
		vSSN = "";
		vLastName = "";
		vFirstName = "";
		vMiddleName = "";
		vRunCBC = 0;
		vDOB = 0;	
		
		// Set the variables appropriately
		if (qGetPendingHostCBCs.cbc_type[i] EQ "father") {
			vSSN = 	qGetPendingHostCBCs.fatherSSN[i];
			vLastName = qGetPendingHostCBCs.fatherLastName[i];
			vFirstName = qGetPendingHostCBCs.fatherFirstName[i];
			vMiddleName = qGetPendingHostCBCs.fatherMiddleName[i];
			vDOB = qGetPendingHostCBCs.fatherDOB[i];
		} else if (qGetPendingHostCBCs.cbc_type[i] EQ "mother") {
			vSSN = 	qGetPendingHostCBCs.motherSSN[i];
			vLastName = qGetPendingHostCBCs.motherLastName[i];
			vFirstName = qGetPendingHostCBCs.motherFirstName[i];
			vMiddleName = qGetPendingHostCBCs.motherMiddleName[i];
			vDOB = qGetPendingHostCBCs.motherDOB[i];
		} else {
			vSSN = 	qGetPendingHostCBCs.memberSSN[i];
			vLastName = qGetPendingHostCBCs.memberLastName[i];
			vFirstName = qGetPendingHostCBCs.memberFirstName[i];
			vMiddleName = qGetPendingHostCBCs.memberMiddleName[i];
			vDOB = qGetPendingHostCBCs.memberDOB[i];
		}
		
		// Make sure there is enough data to run the CBC
		if (vLastName NEQ "" AND vFirstName NEQ "" AND vSSN NEQ "") {
			vRunCBC = 1;
		}
		
		// If there is enough data to run the CBC, run it.
		if (VAL(vRunCBC)) {
			APPLICATION.CFC.CBC.processBatch(
				companyID=VAL(qGetPendingHostCBCs.companyID[i]),
				userType=qGetPendingHostCBCs.cbc_type[i],
				hostID=qGetPendingHostCBCs.hostID[i],
				cbcID=qGetPendingHostCBCs.CBCFamID[i],
				// XML variables
				username=qGetPendingHostCBCs.gis_username[i],
				password=qGetPendingHostCBCs.gis_password[i],
				account=qGetPendingHostCBCs.gis_account[i],
				SSN=vSSN,
				lastName=vLastName,
				firstName=vFirstName,
				middleName=vMiddleName,
				DOBYear=VAL(DateFormat(vDOB, 'yyyy')),
				DOBMonth=VAL(DateFormat(vDOB, 'mm')),
				DOBDay=VAL(DateFormat(vDOB, 'dd')),
				isReRun=1							 
			);	
		}
	}
</cfscript>

<!--- This is for testing purposes
<cfsavecontent variable="emailBody">
	<cfoutput>
		Pending CBCs Before: (#qGetPendingHostCBCs.recordCount#)<br/>
		<cfloop query="qGetPendingHostCBCs">
			#cbcFamID# #hostID# #cbc_type#<br/>
		</cfloop>
	</cfoutput>
</cfsavecontent>

<cfmail 
    from="support@iseusa.com" 
    to="james@iseusa.com"
    subject="Attempted Processing"
    type="html">
    <cfoutput>#emailBody#</cfoutput>
</cfmail>--->