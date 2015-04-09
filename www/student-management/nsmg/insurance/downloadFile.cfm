<!--- ------------------------------------------------------------------------- ----
	
	File:		download_file.cfm
	Author:		Marcus Melo
	Date:		August 05, 2010
	Desc:		Generates an insurance file from data in the history table

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfsetting requesttimeout="99999">
    
    <!--- Param variables --->
    <cfparam name="URL.file" default="0">
    <cfparam name="URL.date" default="0">
    
    <cfscript>
   		// Decode URL
		URL.file = URLDecode(URL.file);
		URL.date = URLDecode(URL.date);
		
		// Get Students for this batch
		qGetStudentsHistory = APPLICATION.CFC.INSURANCE.getStudentsHistory(
			file=URL.file,
			date=URL.date
		);
    </cfscript>
 
</cfsilent>	

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=#URL.file#">

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>

	<!--- New and Return --->
	<cfif ListFind("N", qGetStudentsHistory.type)>
    
        <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
            <tr>
                <td colspan="6" style="font-size:18pt; font-weight:bold; text-align:center; border:none;">
                    Enrollment Sheet         
                </td>
                <td style="font-size:11pt; text-align:right;  border:none;">
                    eSecutive                
                </td>
            </tr>
            <tr>
                <td colspan="8" style="background-color:##CCCCCC; border:none;">&nbsp;</td>
            </tr>
            <tr>
                <td style="width:200px; text-align:left; font-weight:bold;">Last Name</td>
                <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
                <td style="width:100px; text-align:center; font-weight:bold;">Date of Birth</td>
                <td style="width:80px; text-align:center; font-weight:bold;">Start Date</td>
                <td style="width:80px; text-align:center; font-weight:bold;">End Date</td>
                <td style="width:1px;">&nbsp;</td>
                <td style="width:80px; text-align:center; font-weight:bold;">Days</td>
                <td style="width:300px; text-align:left; font-weight:bold;">Email Address (optional)</td>
                <td style="width:80px; text-align:left; font-weight:bold;">Gender (F/M)</td>
            </tr>
            
			<cfloop query="qGetStudentsHistory">
          
                <tr>
                    <td>#qGetStudentsHistory.familyLastName#</td>
                    <td>#qGetStudentsHistory.firstName#</td>
                    <td>#DateFormat(qGetStudentsHistory.dob, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetStudentsHistory.startDate, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetStudentsHistory.endDate, 'dd/mmm/yyyy')#</td>
                    <td>&nbsp;</td>
                    <td>#DateDiff("d", qGetStudentsHistory.startDate, qGetStudentsHistory.endDate)#</td>  
                    <td>
                        <cfif LEN(qGetStudentsHistory.email)>
                        	#qGetStudentsHistory.email#
						<cfelse>
                        	&nbsp;
						</cfif>
                    </td>
                    <td>#qGetStudentsHistory.gender#</td>                              
                </tr>
                
			</cfloop>
		</table>
	
    <!--- Cancelation / Extension --->
	<cfelse>
    
        <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
            <tr>
                <td style="height:70px; text-align:center; border:none;">
                    The CORRECT Date format to enter in the Spreadsheet is: MM/DD/YYYY. 
                    You will then see the date converted to DD-MMM-YY. 
                    When this is takes place, your dates are correct.
                </td>
                <td colspan="3" style="font-size:18pt; font-weight:bold; text-align:center; border:none;">
                    <cfif ListFind("X", qGetStudentsHistory.type)>
                    	Batch Cancelation Sheet
                    <cfelse>
                    	Batch Extension Sheet  
                    </cfif>
                </td>
                <td style="border:none;">&nbsp;</td>
                <td style="border:none;">&nbsp;</td>
                <td style="text-align:right; border:none;">
                    <cfif ListFind("X", qGetStudentsHistory.type)>
						BatchCancel
                    <cfelse>
                    	BatchExtend
                    </cfif>
                </td>
            </tr>
            <tr>
                <td colspan="4" style="background-color:##CCCCCC; border:none;">&nbsp;</td>
                <td colspan="3" style="border:none;">&nbsp;</td>
            </tr>
            <tr>
                <td style="width:350px; text-align:left; font-weight:bold;">Last Name</td>
                <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
                <td style="width:100px; text-align:center; font-weight:bold;">Date of Birth</td>
                <td style="width:200px; text-align:center; font-weight:bold;">New End Date</td>
                <td style="border:none;">&nbsp;</td>
                <td style="border:none;">&nbsp;</td>
                <td style="border:none;">&nbsp;</td>
            </tr>
            
            <cfloop query="qGetStudentsHistory">
                <tr>
                    <td>#qGetStudentsHistory.familyLastName#</td>
                    <td>#qGetStudentsHistory.firstName#</td>
                    <td>#DateFormat(qGetStudentsHistory.dob, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetStudentsHistory.endDate, 'dd/mmm/yyyy')#</td>
                    <td style="border:none;">&nbsp;</td>
                    <td style="border:none;">&nbsp;</td>
                    <td style="border:none;">&nbsp;</td>
                </tr>
            </cfloop>
            
        </table>
        
    </cfif>

</cfoutput> 
