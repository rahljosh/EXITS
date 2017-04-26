<!--- ------------------------------------------------------------------------- ----
	
	File:		batch_flight_info.cfm
	Author:		Bruno Lopes
	Date:		April, 5 2017
	Desc:		Batch for flight Info

	Updated:  						

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param Variables 
	<cftry>
    
    </cftry>
    --->

	<!--- Param FORM variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.programName" default="">
    <cfparam name="FORM.type" default="0">
    <cfparam name="FORM.startDate" default="">
    <cfparam name="FORM.endDate" default="">
    <cfparam name="FORM.extra_sponsor" default="CSB">
    <cfparam name="upload_success" default="0">

	<cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
	</cfscript>
    


	
    <!--- Query for Program Type --->
    <cfquery name="qProgramType" datasource="MySql">
        SELECT 
        	programTypeID,
            programType             
        FROM 
        	smg_program_type
    </cfquery>

	<!--- FORM has been submitted --->
	<cfif FORM.submitted>

        <cfscript>  
            //hello = fileUpload("","fileData","application/msexcel","MakeUnique"); 
      </cfscript>

        <cfset uploaded = false />

        <cftry>
            <cffile action="upload"
                fileField="fileData"
                destination="#APPLICATION.PATH.UPLOADDOCUMENTROOT#temp/batch_flight_info/"
                nameConflict="makeunique"
                accept="application/vnd.ms-excel (official), application/msexcel, application/x-msexcel, application/x-ms-excel, application/x-excel, application/x-dos_ms_excel, application/xls, application/x-xls, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                result="upload" >

                <cfset uploaded = true />
        
            <cfcatch type="any">
                
                <cfscript>
                    ArrayAppend(Errors.Messages, "Error uploading file, please make sure to upload an Excel Sheet with the format provided.");
                </cfscript>

            </cfcatch>
        
        </cftry>


        <cfif uploaded>
            <cfset theFile = upload.serverDirectory & "/" & upload.serverFile>
            <cfif isSpreadsheetFile(theFile)>
                <cfspreadsheet action="read" src="#theFile#" query="data" headerrow="1" excludeHeaderRow="true">

                <cfloop query="data">

                    <cfquery datasource="#APPLICATION.DSN.Source#">
                        INSERT INTO 
                            extra_flight_information
                        (
                            candidateID, 
                            flightType,
                            departDate,
                            departCity, 
                            departAirportCode, 
                            departTime,
                            flightNumber,
                            arriveCity,
                            arriveAirportCode,
                            arriveTime,
                            isOvernightFlight
                        )
                        VALUES 
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#data.candidate_id#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.type#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#data.depart_date#" null="#NOT IsDate(data.depart_date)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.depart_city#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.depart_airport_code#">,
                            <cfqueryparam cfsqltype="cf_sql_time" value="#data.depart_time#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.flight_number#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.arrive_city#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.arrive_airport_code#">,
                            <cfqueryparam cfsqltype="cf_sql_time" value="#data.arrive_time#">,
                            <cfqueryparam cfsqltype="cf_sql_bit" value="#data.overnight_time#">
                        )
                    </cfquery>
                </cfloop>

            </cfif>

            <cfset upload_success = 1 />
   
        </cfif>
    
    </cfif>

</cfsilent>

<!--- Header --->
<table width="95%" cellpadding="0" cellspacing="0" border="0" align="center" height="25" bgcolor="#E4E4E4">
	<tr bgcolor="#E4E4E4">
	  	<td width="85%" class="title1">Flight Information Batch Upload</td>
		<td width="15%" class="title1">&nbsp;</td>
	</tr>
</table>

<cfoutput>

<cfform name="form" id="form" method="post" action="index.cfm?curdoc=tools/batch_flight_info" enctype="multipart/form-data"><br>
            
	<input type="hidden" name="submitted" value="1" />

	<!--- Display Errors --->
	<cfif VAL(ArrayLen(Errors.Messages))>
		<table width="95%" align="center" cellpadding="0" cellspacing="0">
        	<tr>
            	<td>
			        <font color="##FF0000">Please review the following items:</font> <br>
	
                    <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                        #Errors.Messages[i]# <br>        	
                    </cfloop>
				</td>
			</tr>
		</table> <br />                      
	</cfif>

    <cfif VAL(upload_success)>
        <table width="95%" align="center" cellpadding="10" cellspacing="0" style="background-color: ##dee9ee; color:##275165; text-align: center">
            <tr>
                <td>
                    <strong>File Uploaded</strong> <br>
    
                    Your file has been uploaded successfully.
                </td>
            </tr>
        </table> <br />                      
    </cfif>

    
        
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="section">
        <cfif NOT VAL(upload_success)>
        <tr>
            <td>
                <table width="100%" border="0" align="center">
                    <tr>
                        <td width="23%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Select File:</font></td>
                        <td width="77%"><cfinput type="file" name="fileData" /></td>
                    </tr>

                    <tr>
                        <td colspan="2" align="center"><input type="image" src="../pics/save.gif" name="button" value="Submit" alt="save" /></td>
                    </tr>
                </table>
            </td>
        </tr>
    </cfif>
        <tr>
            <td><br />
                Only excel files are accepted. Your file should look like the following:<br /><br />

                <table border="1" cellpadding="5" cellspacing="0">
                    <tr>
                        <td>candidate_id</td>   
                        <td>type</td>
                        <td>depart_date</td>
                        <td>depart_city</td>
                        <td>depart_airport_code</td>
                        <td>arrive_city </td>
                        <td>arrive_airport_code </td>
                        <td>flight_number</td>
                        <td>depart_time</td>
                        <td>arrive_time</td>
                        <td>overnight_time</td>
                    </tr>
                    <tr>
                        <td>00000</td>
                        <td>Arrival</td>
                        <td>2017-01-01</td>
                        <td>City 1</td>
                        <td>CT1</td>
                        <td>City 2</td>
                        <td>CT2</td>
                        <td>1234</td>
                        <td>8:00</td>
                        <td>11:00</td>
                        <td>No</td>
                    </tr>
                    <tr>
                        <td>00000</td>
                        <td>Departure</td>
                        <td>2017-02-02</td>
                        <td>City 2</td>
                        <td>CT2</td>
                        <td>City 1</td>
                        <td>CT1</td>
                        <td>4321</td>
                        <td>22:00</td>
                        <td>5:00</td>
                        <td>Yes</td>
                    </tr>
                </table>

                <p style="color: red">
                * The header row should not be edited<br />
                * Values for <strong>type</strong>: Arrival / Departure<br />
                * Date format for  <strong>depart_date</strong>: yyyy-mm-dd<br />
                * Time format for <strong>depart_time</strong> and <strong>arrive_time</strong>: hh:mm <em>24h format</em><br />
                * Values for <strong>overnight_time</strong>: Yes / No
                </p>

                <a href="/EXTRA-Batch-Flight-Information.xlsx">Download a Template Excel file here.</a>
            </td>
        </tr>
    </table>
    
</cfform>

</cfoutput>
