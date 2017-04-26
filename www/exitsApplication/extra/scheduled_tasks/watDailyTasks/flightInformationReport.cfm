<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInformationReport.cfm
	Author:		Marcus Melo
	Date:		January 19, 2011
	Desc:		Scheduled Task - Emails flight information entered/updated 
				in the last 24 hours.
				It should be scheduled to run daily.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />
	
	<cfparam name="companyID" default="8">
	
    <cfscript>
		// Get flights updated in the last 24 hours
		qGetArrivals = APPLICATION.CFC.FLIGHTINFORMATION.getDailyFlightReport(flightType='Arrival',companyID=companyID);

		// Get flights updated in the last 24 hours
		qGetDepartures = APPLICATION.CFC.FLIGHTINFORMATION.getDailyFlightReport(flightType='Departure',companyID=companyID);
	</cfscript>
	
	<!--- Get the company information --->
	<cfquery name="qGetCompany" datasource="#APPLICATION.DSN.Source#">
		SELECT *
		FROM smg_companies
		WHERE companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
	</cfquery>
    
</cfsilent>


<cfsavecontent variable="flightReport">

	<!--- Arrival Information --->
    <fieldset style="margin: 5px 0px 20px 0px; padding: 10px; border: ##DDD 1px solid;">
        
        <legend style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">FLIGHT ARRIVALS</legend>

        <cfif qGetArrivals.recordCount>
            
            <cfoutput query="qGetArrivals" group="candidateID">
                
                <div style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">
                    #qGetArrivals.firstName# #qGetArrivals.lastName# (###qGetArrivals.candidateID#) - #qGetArrivals.hostCompanyName# - #qGetArrivals.businessName#
                </div>
				
                <table cellspacing="1" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px;">	
                    <tr style="color: ##fff; font-weight: bold; text-align:center; background-color: ##0069aa;">
                        <td style="padding:4px 0px 4px 0px;">Arrival Date</td>
                        <td style="padding:4px 0px 4px 0px;">Arrival Airport</td>
                        <td style="padding:4px 0px 4px 0px;">Arrival Time / Flight ##</td>
                    </tr>                                

                    <cfoutput>
                        <tr style="text-align:center; <cfif qGetArrivals.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                            <td style="padding:4px 0px 4px 0px;">
								<cfif qGetArrivals.isOvernightFlight EQ 1>
                                    #DateFormat(DateAdd("d", 1, qGetArrivals.departDate), 'mm/dd/yyyy')# 
                                <cfelse>
                                    #qGetArrivals.departDate#
                                </cfif>
                                
                                <cfset dateDiference = DateDiff("d", qGetArrivals.startDate, qGetArrivals.departDate) >
                                
                                <cfif dateDiference LTE -5 OR dateDiference GTE 5>

                                    <cfif (dateDiference LTE -5 AND dateDiference GT -10)
                                            OR (dateDiference GTE 5 AND dateDiference LT 10)>
                                        <span style="color:##ce8500">
                                    <cfelse>
                                	   <span style="color:red">
                                    </cfif>
                                        (Program Start Date: #qGetArrivals.startDate#)</span>
                                </cfif>
                        	</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.arriveAirportCode#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetArrivals.arriveTime# / #qGetArrivals.flightNumber#</td>
                        </tr>                         
                    </cfoutput>    						
                
                </table>
                
                <br />
                
            </cfoutput>
    
        <cfelse>
            
            <table cellspacing="0" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px;">	
                <tr style="color: ##fff; font-weight: bold; background-color: ##0069aa;">
                    <td style="padding:4px 0px 4px 0px;">No flight entered/updated in the last 24 hours</td>
                </tr>                                
            </table>
			
        </cfif>

	</fieldset>
    
    <br />
    
	<!--- Departure Information --->
    <fieldset style="margin: 5px 0px 20px 0px; padding: 10px; border: ##DDD 1px solid;">
        
        <legend style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">FLIGHT DEPARTURES</legend>

        <cfif qGetDepartures.recordCount>
            
            <cfoutput query="qGetDepartures" group="candidateID">
                
                <div style="color: ##666; font-weight: bold; padding-bottom:5px; text-transform:uppercase;">
                    #qGetDepartures.firstName# #qGetDepartures.lastName# (###qGetDepartures.candidateID#) - #qGetDepartures.hostCompanyName# - #qGetDepartures.businessName#
                </div>

                <table cellspacing="1" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px;">	
                    <tr style="color: ##fff; font-weight: bold; text-align:center; background-color: ##0069aa;">
                        <td style="padding:4px 0px 4px 0px;">Departure Date</td>
                        <td style="padding:4px 0px 4px 0px;">Departure Airport</td>
                        <td style="padding:4px 0px 4px 0px;">Departure Time / Flight ##</td>
                    </tr>                                

                    <cfoutput>
                        <tr style="text-align:center; <cfif qGetDepartures.currentRow MOD 2>background-color: ##EEEEEE;</cfif> ">
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.departDate#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.departAirportCode#</td>
                            <td style="padding:4px 0px 4px 0px;">#qGetDepartures.departTime# / #qGetDepartures.flightNumber#</td>
                        </tr>                         
                    </cfoutput>    						
                
                </table>
                
                <br />
                
            </cfoutput>
    
        <cfelse>
            
            <table cellspacing="0" style="width: 100%; border:1px solid ##0069aa; margin-bottom:15px; padding:0px;">	
                <tr style="color: ##fff; font-weight: bold; background-color: ##0069aa;">
                    <td style="padding:4px 0px 4px 0px;">No flight entered/updated in the last 24 hours</td>
                </tr>                                
            </table>
			
        </cfif>

	</fieldset>

    <br />	
    
    <cfoutput>
        <div style="margin:5px 0px 10px 0px;">
			Flight Information Report Sent On #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm:ss tt')# 
        </div>
	</cfoutput>
        
</cfsavecontent>

<cfscript>
	// Send Email
	if ( qGetArrivals.recordCount OR qGetDepartures.recordCount ) {
	
		// Send this to ryan if it is for trainee, the APPLICATION.EMAIL.flightReport variable is already set for WAT
		if (qGetCompany.companyID EQ 7) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailTo=APPLICATION.EMAIL.traineeFlightReport,
				emailSubject='EXTRA - Trainee - Daily Flight Report',
				emailMessage=flightReport
			);
		} else if (qGetCompany.companyID EQ 8) {
			APPLICATION.CFC.EMAIL.sendEmail(
				emailTo=APPLICATION.EMAIL.flightReport,
				emailSubject='EXTRA - WAT - Daily Flight Report',
				emailMessage=flightReport
			);
		}
		
	}
	
	WriteOutput(flightReport);
</cfscript>
