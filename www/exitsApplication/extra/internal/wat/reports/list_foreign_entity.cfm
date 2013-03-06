<!--- ------------------------------------------------------------------------- ----
	
	File:		list_foreign_entity.cfm
	Author:		James Griffiths
	Date:		June 5, 2012
	Desc:		Lists all foreign entities based on input program.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param FORM Variables --->	
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">
    
	<cfinclude template="../querys/get_company_short.cfm">

	<cfscript>
        // Get Program List
        qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
    </cfscript>

    <cfif FORM.submitted>
    
    	<cfquery name="qGetResults" datasource="#APPLICATION.DSN.Source#">
        	SELECT
            	r.userID,
                r.firstName,
                r.lastName,
                r.businessName,
                r.city,
                r.address,
                r.phone,
                r.email,
                r.website,
                c.countryName
           	FROM
            	smg_users r
           	INNER JOIN
            	smg_countrylist c ON c.countryID = r.country
           	INNER JOIN
            	extra_candidates ec ON ec.intRep = r.userID
          	WHERE
            	r.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
          	AND
            	r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
          	AND
            	ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#">
          	GROUP BY
            	r.userID
        </cfquery>

    </cfif>
    
	<cfscript>
		// Set bgColor
		bgColor = '##4F8EA4';
		bgColorSubTitle = '##4F8EA4';
		tbBorder = 0;
	</cfscript>

</cfsilent>

<cfoutput>

<form action="index.cfm?curdoc=reports/list_foreign_entity" method="post">
<input type="hidden" name="submitted" value="1" />

<table width="95%" cellpadding="4" cellspacing="4" border="0" align="center">
    <tr valign="middle" height="24">
        <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> List of Foreign Entities for DOS</font>
        </td>
	</tr>
    <tr>
        <td valign="middle" align="right" class="style1"><b>Program:</b></td>
        <td class="style1"> 
            <select name="programID" class="style1">
                <option></option>
                <cfloop query="qGetProgramList">
                    <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programID EQ FORM.programID> selected</cfif> >#qGetProgramList.programname#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    <tr>
        <td align="right" class="style1"><b>Format: </b></td>
        <td class="style1"> 
        	<input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1"> Onscreen (View Only) </label>
            <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2"> Excel Spreadsheet</label>            
            <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3"> Print (PDF) </label>
            <input type="radio" name="printOption" id="printOption4" value="4" <cfif FORM.printOption EQ 4> checked </cfif> > <label for="printOption4"> Print (FlashPaper) </label>
		</td>            	
    </tr>
    <tr>
        <td colspan=2 align="center">
        	<br /> <input type="submit" class="style1" value="Generate Report" /><br />
        </td>
    </tr>
</table>
</form>

<cfif FORM.submitted>

    <cfsavecontent variable="reportContent">
    
        <cfscript>
            if(ListFind("2,3,4", FORM.printOption)) {
                bgColor = '##CCCCCC';
                tbBorder = 1;
            }
        </cfscript>
    
        <table width=100% cellpadding="4" cellspacing="0" border="#tbBorder#">
            <tr>
            	<th class="style2" bgcolor="#bgColor#" align="left">Sponsor Name</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Program ID</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Sponsor Point of Contact</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Sponsor Phone Number</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Sponsor Email Address</th>
            	<th class="style2" bgcolor="#bgColor#" align="left">Overseas Partner Name</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Country of Business</th>
                <th class="style2" bgcolor="#bgColor#" align="left">City</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Street Address</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Partner Point of Contact</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Partner Phone Number</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Partner Email Address</th>
                <th class="style2" bgcolor="#bgColor#" align="left">Partner Website URL</th>
            </tr>
            <cfloop query="qGetResults">
            
                <cfscript>
                    if(qGetResults.currentrow MOD 2) {
                        rowColor = '##E4E4E4';
                    } else {
                        rowColor = '';
                    }
                </cfscript>
                
                <tr style="font-size:11px;">
                	<td bgcolor="#rowColor#"></td>
                    <td bgcolor="#rowColor#"></td>
                    <td bgcolor="#rowColor#"></td>
                    <td bgcolor="#rowColor#"></td>
                    <td bgcolor="#rowColor#"></td>
                	<td bgcolor="#rowColor#">#qGetResults.businessName#</td>
                    <td bgcolor="#rowColor#">#qGetResults.countryName#</td>
                    <td bgcolor="#rowColor#">#qGetResults.city#</td>
                    <td bgcolor="#rowColor#">#qGetResults.address#</td>
                    <td bgcolor="#rowColor#">#qGetResults.firstName# #qGetResults.lastName#</td>
                    <td bgcolor="#rowColor#">#qGetResults.phone#</td>
                    <td bgcolor="#rowColor#">#qGetResults.email#</td>
                    <td bgcolor="#rowColor#">#qGetResults.website#</td>
                </tr>
                
            </cfloop>
            
            <cfif NOT VAL(qGetResults.recordCount)>
                <tr>
                    <td align="center" colspan="10">
                        <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">No records found based on the criteria you specified. Please change and re-run the report.</font></div><br />
                    </td>
                </tr>
            </cfif>
            
            <cfif FORM.printOption EQ 1>
            <tr>
                <td colspan="10">
                    <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br/><br/>
                    <font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font> 
                </td>
            </tr>  
            </cfif> 
                         
        </table>
        
    </cfsavecontent>


    <cfswitch expression="#FORM.printOption#">
    
        <!--- Screen --->
        <cfcase value="1">
            <font size="2" face="Verdana, Arial, Helvetica, sans-serif" style="font-weight:bold;">Total Number of Foreign Entities: #qGetResults.recordcount#</font>
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
            <!--- Include Report --->
            #reportContent#
        </cfcase>
        
        <!--- Excel --->
        <cfcase value="2">
    
            <!--- set content type --->
            <cfcontent type="application/msexcel">
            
            <!--- suggest default name for XLS file --->
            <cfheader name="Content-Disposition" value="attachment; filename=DOS-Report.xls"> 
    
            <!--- Include Report --->
            #reportContent#
            
            <cfabort>
        </cfcase>
    
        <!--- PDF --->
        <cfcase value="3">   
            <cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
                <style type="text/css">
                <!--
                .style1 { 
                    font-family: Arial, Helvetica, sans-serif;
                    font-size: 10;
                    }
                -->
                </style>
                <!--- Include Report --->
                #reportContent#
            </cfdocument>
        </cfcase>
    
        <!--- Flash Paper --->
        <cfcase value="4">  
            <cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">  
                <style type="text/css">
                <!--
                .style1 { 
                    font-family: Arial, Helvetica, sans-serif;
                    font-size: 10;
                    }
                -->
                </style>
                <!--- Include Report --->
                #reportContent#
            </cfdocument>
        </cfcase>
    
        <cfdefaultcase>    
            <span class="style1">
                <center>Print resutls will replace the menu options and take a bit longer to generate.<br /> 
                Onscreen will allow you to change criteria with out clicking your back button.</center>
            </span> <br />
        </cfdefaultcase>
        
    </cfswitch>

<cfelse>
    
    <span class="style1">
        <center>Print resutls will replace the menu options and take a bit longer to generate.<br /> 
        Onscreen will allow you to change criteria with out clicking your back button.</center>
    </span> <br />

</cfif>

</cfoutput>