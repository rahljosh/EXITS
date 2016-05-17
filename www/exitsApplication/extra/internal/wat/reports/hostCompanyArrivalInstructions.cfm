<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

    <!--- Param FORM Variables --->
	<cfparam name="FORM.programID" default="">
	<cfparam name="FORM.hostCompanyID" default="0">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.csbPlacement" default="All">

    <cfscript>
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		qGetHostCompanyList = APPLICATION.CFC.HOSTCOMPANY.getHostCompanies(companyID=CLIENT.companyID);
	</cfscript>

    <!--- FORM submitted --->
    <cfif FORM.submitted>

        <!--- Get Host Companies Assigned to Candidates --->
        <cfquery name="qGetHostCompany" datasource="#APPLICATION.DSN.Source#">
            SELECT DISTINCT
                eh.hostCompanyID,
                eh.name,
                eh.city, 
                eh.state,
                eh.isHousingProvided,
                eh.housingProvidedInstructions,
                eh.isPickUpProvided,
                eh.arrivalAirport,
                eh.arrivalAirportCity,
                eh.arrivalAirportState,
                eh.arrivalPickUpHours,
                eh.arrivalInstructions,
                eh.arrivalPickUpDays,
                eh.arrivalPickUpCost,
                eh.pickUpContactName,
                eh.pickUpContactPhone,
                eh.pickUpContactEmail,
                eh.pickUpContactHours,
                eh.housingAddress,
                eh.housingCity,
                eh.housingProviderName,
                eh.housingPhone,
                eh.housingEmail,
                housingS.stateName AS housingStateName,
                eh.housingZip,
                s.stateName, 
                airportS.state as arrivalAirportStateCode 
            FROM 
            	extra_hostcompany eh 
			<cfif VAL(FORM.programID)>
            INNER JOIN
            	extra_candidates ec ON ec.hostCompanyID = eh.hostCompanyID
                	AND
                    	ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
					AND
                    	ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
                    AND 
                        ec.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
			</cfif>                        
            LEFT OUTER JOIN 
                smg_states s ON eh.state = s.ID
            LEFT OUTER JOIN 
                smg_states airportS ON eh.arrivalAirportState = airportS.ID
          	LEFT OUTER JOIN
            	smg_states housingS ON eh.housingState = housingS.ID
            WHERE 
                1 = 1
			<cfif VAL(FORM.hostcompanyID)> 
                AND
                    eh.hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">                               
			</cfif>
            <cfif FORM.csbPlacement EQ 1>
            	AND
                	ec.wat_placement = "CSB-Placement"
            <cfelseif FORM.csbPlacement EQ 0>
            	AND
                	ec.wat_placement = "Self-Placement"            
            </cfif>
       		GROUP BY
            	eh.hostCompanyID
            ORDER BY
            	eh.name
		</cfquery>
		
	</cfif>

</cfsilent>

<style type="text/css">
<!--
	.companyTitle {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 14px;
		color: #006666;
		font-weight: bold;
		padding:0px;
	}

	.tableTitleView {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		text-align:right;
		font-weight:bold;
		font-size: 11px;
		padding:5px;
	}

	.tableDataView {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 11px;
		padding:5px;
	}

	.greyRow {
		background:#E4E4E4;
	}
-->
</style>

<cfoutput>

<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
<input type="hidden" name="submitted" value="1" />

    <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan="2">
            	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Host Company Reports -> Arrival Instructions</font>
			</td>                
        </tr>
        <tr valign="middle" height="24">
            <td valign="middle" colspan="2">&nbsp;</td>
        </tr>
        <tr valign="middle">
            <td align="right" valign="middle" class="style1"><b>Host Company: </b></td>
            <td valign="middle">  
                <select name="hostCompanyID" class="style1">
                    <option value="ALL">---  All Host Companies  ---</option>
                    <cfloop query="qGetHostCompanyList">
                    	<option value="#hostcompanyID#" <cfif qGetHostCompanyList.hostcompanyID EQ FORM.hostCompanyID> selected </cfif> >#qGetHostCompanyList.name#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>Program: </b></td>
            <td>
                <select name="programID" class="style1">
                    <option value="0"></option>
                    <cfloop query="qGetProgramList">
                    	<option value="#programID#" <cfif qGetProgramList.programID EQ FORM.programID> selected </cfif> >#programname#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>Placement Type: </b></td>
            <td>
                <select name="csbPlacement" class="style1">
                	<option value="All" <cfif form.csbPlacement EQ "All"> selected="selected" </cfif>>--- All ---</option>
                    <option value="0" <cfif form.csbPlacement EQ 0> selected="selected" </cfif>>Self-Placement</option>
                    <option value="1" <cfif form.csbPlacement EQ 1> selected="selected" </cfif>>CSB-Placement</option>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right" class="style1"><b>Format: </b></td>
            <td class="style1"> 
                <input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked="checked" </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked="checked" </cfif> > <label for="printOption2">Print (PDF)</label> 
                <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked="checked" </cfif> > <label for="printOption3">Excel (XLS)</label>
            </td>            
        </tr>
        <tr>
            <td colspan=2 align="center"><br />
                <input type="submit" value="Generate Report" class="style1" /><br />
            </td>
        </tr>
    </table>

</form>

<br /><br />

<!--- Print --->
<cfif FORM.submitted>
	
	<cfsavecontent variable="reportContent">
		
        <cfloop query="qGetHostCompany">
			            
            <table width="98%" cellpadding="3" cellspacing="0" align="center" style="margin-top:20px; border:1px solid ##4F8EA4">
                <tr>
                    <td colspan="2">
                        <a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#qGetHostCompany.hostCompanyID#" target="_blank" class="companyTitle">
                            #qGetHostCompany.name# in #qGetHostCompany.city#, #qGetHostCompany.stateName#
                        </a>
                    </td>
                </tr>
                <tr>
                	<td class="tableTitleView greyRow" width="15%">Housing:</td>
                    <td class="greyRow tableDataView">
						<cfif ListFind("0,1", qGetHostCompany.isHousingProvided)>
                            #YesNoFormat(VAL(qGetHostCompany.isHousingProvided))#
                        <cfelseif qGetHostCompany.isHousingProvided EQ 2>
                            Other (third party)
                        </cfif>
                    </td>
                </tr>
                <cfif ((qGetHostCompany.isHousingProvided EQ 1) OR (qGetHostCompany.isHousingProvided EQ 2))>
				<tr>               
                    <td class="tableTitleView" valign="top">Housing Instructions:</td>
                    <td class="tableDataView">
                        <cfif LEN(qGetHostCompany.housingProvidedInstructions)>
                            #qGetHostCompany.housingProvidedInstructions#
                        <cfelse>
                            n/a
                        </cfif>
                    </td>
                </tr>
                <tr>               
                    <td class="tableTitleView greyRow" valign="top">Housing Provider Name:</td>
                    <td class="greyRow tableDataView">#qGetHostCompany.housingProviderName#</td>
                </tr>
                <tr>               
                    <td class="tableTitleView" valign="top">Housing Phone:</td>
                    <td class="tableDataView">#qGetHostCompany.housingPhone#</td>
                </tr>
                <tr>               
                    <td class="tableTitleView greyRow" valign="top">Housing Email:</td>
                    <td class="greyRow tableDataView">#qGetHostCompany.housingEmail#</td>
                </tr>
                <tr>               
                    <td class="tableTitleView" valign="top">Housing Address:</td>
                    <td class="tableDataView">
                    	<cfif qGetHostCompany.isHousingProvided EQ 1 OR qGetHostCompany.isHousingProvided EQ 2>
                            #qGetHostCompany.housingAddress#, #qGetHostCompany.housingCity#, #qGetHostCompany.housingStateName# #qGetHostCompany.housingZip#
                        <cfelse>
                            n/a
                        </cfif>
                  	</td>
                </tr>
                </cfif>
				<tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>" valign="top">Pick-Up:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>">#YesNoFormat(VAL(qGetHostCompany.isPickUpProvided))#</td>
                </tr>
				<tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>" valign="top">Arrival Airport:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>">#qGetHostCompany.arrivalAirport#</td>
                </tr>
				<tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>" valign="top">Arrival City:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>">#qGetHostCompany.arrivalAirportCity#<cfif LEN(qGetHostCompany.arrivalAirportStateCode)>,#qGetHostCompany.arrivalAirportStateCode#</cfif></td>
                </tr>
                <tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>" valign="top">Days:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>">#qGetHostCompany.arrivalPickUpDays#</td>
                </tr>
				<tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>" valign="top">Hours:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>">#qGetHostCompany.arrivalPickUpHours#</td>
                </tr>
				<tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>" valign="top">Pick-Up Instructions:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>">
                        <cfif LEN(qGetHostCompany.arrivalInstructions)>
                            #qGetHostCompany.arrivalInstructions#
                        <cfelse>
                            n/a
                        </cfif>
                    </td>
                </tr>
                <tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>" valign="top">Cost:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>">#DollarFormat(VAL(qGetHostCompany.arrivalPickUpCost))#</td>
                </tr>
				<tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>" valign="top">Contact Name:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>">#qGetHostCompany.pickUpContactName#</td>
                </tr>
				<tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>" valign="top">Contact Phone:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>">#qGetHostCompany.pickUpContactPhone#</td>
                </tr>
				<tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>" valign="top">Contact Email:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided EQ 0)>greyRow</cfif>">#qGetHostCompany.pickUpContactEmail#</td>
                </tr>
				<tr>               
                    <td class="tableTitleView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>" valign="top">Hours of contact:</td>
                    <td class="tableDataView <cfif (qGetHostCompany.isHousingProvided NEQ 0)>greyRow</cfif>">#qGetHostCompany.pickUpContactHours#</td>
                </tr>
            </table>
            
            <br style="page-break-after:always" />
         
		</cfloop>
            
    </cfsavecontent>

	<!-----Display Reports---->
    <cfswitch expression="#FORM.printOption#">
    
        <!--- Screen --->
        <cfcase value="1">
            <!--- Include Report --->
            #reportContent#
        </cfcase>
    
        <!--- PDF --->
        <cfcase value="2">   
            <cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
                <style type="text/css">
                <!--
                .style1 {
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                    font-size: 10px;
                    padding:2;
                }
                .style2 {
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                    font-size: 8px;
                    padding:2;
                }
                .title1 {
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                    font-size: 15px;
                    font-weight: bold;
                    padding:5;
                }					
                -->
                </style>
    
                <img src="../../pics/black_pixel.gif" width="100%" height="2">
                <div class="title1">Arrival Information</div>
                <img src="../../pics/black_pixel.gif" width="100%" height="2">
                
                <!--- Include Report --->
                #reportContent#
            </cfdocument>
        </cfcase>
    
        <!--- Excel --->
        <cfcase value="3">
    
            <!--- set content type --->
            <cfcontent type="application/msexcel">
            
            <!--- suggest default name for XLS file --->
            <cfheader name="Content-Disposition" value="attachment; filename=arrivalInformation.xls"> 
    
            <style type="text/css">
            <!--
            .style1 {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 10px;
                padding:2;
            }
            .style2 {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 10px;
                padding:2;
            }
            .title1 {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 15px;
                font-weight: bold;
                padding:5;
            }					
            -->
            </style>
           
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
            <div class="title1">Arrival Information</div>
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
            
            <!--- Include Report --->
            #reportContent#
            
            <cfabort>
    
        </cfcase>
        
        <cfdefaultcase>    
            <div align="center" class="style1">
                Print results will replace the menu options and take a bit longer to generate. <br />
                Onscreen will allow you to change criteria with out clicking your back button.
            </div>  <br />
        </cfdefaultcase>
        
    </cfswitch>

<cfelse>

    <div align="center" class="style1">
        Print results will replace the menu options and take a bit longer to generate. <br />
        Onscreen will allow you to change criteria with out clicking your back button.
    </div>  <br />

</cfif>    

</cfoutput>
