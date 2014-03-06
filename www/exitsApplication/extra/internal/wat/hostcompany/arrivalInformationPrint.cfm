<!--- ------------------------------------------------------------------------- ----
	
	File:		arrivalInformationPrint.cfm
	Author:		James Griffiths
	Date:		March 06, 2014
	Desc:		Host Family Arrival Information	

----- ------------------------------------------------------------------------- --->

<cfparam name="URL.hostID" default="0">

<cfquery name="qGetArrivalInformation" datasource="#APPLICATION.DSN.Source#">
	SELECT eh.*, airportS.stateName AS arrivalAirportStateName
    FROM extra_hostCompany eh
    LEFT OUTER JOIN smg_states airportS ON eh.arrivalAirportState = airportS.ID
    WHERE eh.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostID)#">
</cfquery>

<cfoutput query="qGetArrivalInformation">
	<table width="100%" cellpadding="3" cellspacing="3" border="0">
        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
            <td colspan="2" class="style2" bgcolor="##8FB6C9" style="color:white;">Arrival Information for #qGetArrivalInformation.name# (###qGetArrivalInformation.hostCompanyID#)</td>
        </tr>
        <tr>
            <td width="45%" class="style1" align="right"><strong>Airport/Station Code:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">
                <span class="readOnly">#arrivalAirport#</span>
            </td>
        </tr>
        <tr>
            <td class="style1" align="right"><strong>Airport/Station City:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#arrivalAirportCity#</td>
        </tr>
        <tr>
            <td class="style1" align="right"><strong>Airport/Station State:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#arrivalAirportStateName#</td>
        </tr>
        <tr>
            <td class="style1" align="right"><strong>Is pick-up available?</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#YesNoFormat(VAL(isPickUpProvided))#</td>
        </tr>
        <tr class="hiddenField pickUpInfo">
            <td class="style1" align="right"><strong>Pick Up Days:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#arrivalPickUpDays#</td>
        </tr>
        <tr class="hiddenField pickUpInfo">
            <td class="style1" align="right"><strong>Pick Up Hours:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#arrivalPickUpHours#</td>
        </tr>
        <tr class="hiddenField pickUpInfo">
            <td class="style1" align="right"><strong>Cost:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#DollarFormat(VAL(arrivalPickUpCost))#</td>
        </tr>
        <tr class="hiddenField pickUpInfo">
            <td class="style1" align="right" valign="top"><strong>Instructions:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#arrivalInstructions#</td>
        </tr>
        <tr class="hiddenField pickUpInfo">
            <td class="style1" align="right"><strong>Contact Name:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#pickUpContactName#</td>
        </tr>
        <tr class="hiddenField pickUpInfo">
            <td class="style1" align="right"><strong>Contact Phone:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#pickUpContactPhone#</td>
        </tr>
        <tr class="hiddenField pickUpInfo">
            <td class="style1" align="right"><strong>Contact Email:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#pickUpContactEmail#</td>
        </tr>
        <tr class="hiddenField pickUpInfo">
            <td class="style1" align="right"><strong>Hours of Contact:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#pickUpContactHours#</td>
        </tr>
        <tr class="hiddenField pickUpInfo">
            <td class="style1" align="right"><strong>Notes:</strong></td>
            <td class="style1" bordercolor="##FFFFFF">#pickUpNotes#</td>
        </tr>
    </table>
</cfoutput>