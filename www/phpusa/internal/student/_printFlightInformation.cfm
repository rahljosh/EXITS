<!--- ------------------------------------------------------------------------- ----
	
	File:		_printFlightInformation.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Prints Flight Information in PDF Format

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- PARAM URL Variables --->
	<cfparam name="URL.uniqueID" default="">
    <cfparam name="URL.programID" default="">

	<cfscript>
		// Get Formatted Flight Information
		flightInfoReport = APPLICATION.CFC.FLIGHTINFORMATION.printFlightInformation(
			uniqueID=URL.uniqueID,
			programID=URL.programID																		 
		);
	</cfscript>	
        
</cfsilent>

<cfoutput>
    
    <cfdocument name="pdfFlightInfo" format="pdf" localUrl="no" backgroundvisible="yes" margintop="0.2" marginright="0.2" marginbottom="0.2" marginleft="0.2" saveasname="flightInformation">
    	#flightInfoReport#
    </cfdocument>

	<!--- Set up the header info --->
    <cfheader 
        name="content-disposition" 
        value="attachment; filename=flightInformation.pdf"/>


    <!--- Set up the content type --->        
    <cfcontent 
        type="application/pdf" 
        variable="#toBinary(pdfFlightInfo)#">
    
</cfoutput>