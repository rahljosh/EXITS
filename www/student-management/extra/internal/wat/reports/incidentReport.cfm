<!--- Kill extra output --->
<cfsilent>

    <!--- Param FORM Variables --->	
    <cfparam name="FORM.hostCompanyID" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">

    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>

    <cfquery name="qGetHostCompanyList" datasource="mySQL">
        SELECT DISTINCT
        	eh.hostcompanyID, 
            eh.name 
        FROM 
        	extra_hostcompany eh
        INNER JOIN	
        	extra_candidate_place_company ecpc ON ecpc.hostCompanyID = eh.hostCompanyID
        WHERE         	
            eh.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND 
        	eh.name != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        GROUP BY
            eh.hostCompanyID
        ORDER BY
            eh.name
    </cfquery>

    <!--- FORM submitted --->
    <cfif FORM.submitted>
     
        <cfquery name="qGetCandidates" datasource="mySQL">
            SELECT DISTINCT
                ec.candidateID,
                ec.uniqueID,
                ec.firstname,             
                ec.lastname, 
                ec.hostCompanyID,
                ec.wat_placement,
                ec.startDate,
                u.businessname,
                eir.dateIncident,
                eir.subject,
                eir.notes,
                eir.isSolved,
                ehc.name AS hostCompanyName              
            FROM   
                extra_candidates ec
            INNER JOIN
                smg_users u on u.userid = ec.intrep
            INNER JOIN	
                extra_candidate_place_company ecpc ON ecpc.candidateID = ec.candidateID
				   <cfif VAL(FORM.hostcompanyID)> 
                        AND
                            ecpc.hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">                               
                    </cfif>                
			INNER JOIN
            	extra_hostCompany ehc ON ehc.hostCompanyID = ecpc.hostCompanyID
            INNER JOIN
            	extra_incident_report eir ON eir.candidateID = ec.candidateID
                	AND
                    	eir.hostCompanyID = ecpc.hostCompanyID               
            WHERE 
                ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">    
            AND 
                ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
            AND 
                ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
       		ORDER BY
                ehc.name,
                ec.candidateID
        </cfquery>
    
    </cfif>

</cfsilent>

<cfoutput>

<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
	<input type="hidden" name="submitted" value="1">
    
    <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Incident Report</font>
            </td>
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
                        <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programid EQ FORM.programID> selected</cfif>>#qGetProgramList.programname#</option>
                    </cfloop>
                </select>
	        </td>
        </tr>
        <tr>
            <td align="right"  class="style1"><b>Format: </b></td>
            <td class="style1"> 
            	<input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2">Print (FlashPaper)</label> 
	            <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3">Print (PDF)</label>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
        		<br /> <input type="submit" class="style1" value="Generate Report" />
			</td>
        </tr>
    </table> <br/>

</form>

</cfoutput>

<!--- FORM submitted --->
<cfif FORM.submitted>

    <cfsavecontent variable="reportContent">
       
        <cfoutput query="qGetCandidates" group="hostCompanyID">
            
            <table width="98%" cellpadding="3" cellspacing="0" align="center" style="margin-top:20px; margin-bottom:20px; border:1px solid ##4F8EA4"> 
                <tr>
                    <td colspan="6" style="font-weight:bold; font-size: 12px;">#qGetCandidates.hostCompanyName#</td>
                </tr>
                <tr style="background-color:##4F8EA4; color:##FFF; padding:5px; font-weight:bold; font-size: 12px;">
                    <td width="20%">Candidate</Td>
                    <td width="20%">Intl. Representative</Td>
                    <td width="10%">Date</Td>
                    <td width="15%">Incident</Td>
                    <td width="30%">Notes</Td>
                    <td width="5%">Solved</Td>
                </tr>
                
                <cfscript>
                    vRowCount = 0;
                </cfscript>
                
                <cfoutput>
                    <cfscript>
                        vRowCount = vRowCount + 1;
                    </cfscript>
                    
                    <tr bgcolor="###IIf(vRowCount MOD 2 ,DE("FFFFFF") ,DE("E4E4E4") )#" style="font-size:11px;">
                        <td valign="top">
                            <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidates.uniqueID#" target="_blank" class="style4">
                                #qGetCandidates.firstname# #qGetCandidates.lastname# (###qGetCandidates.candidateid#)
                            </a>
                        </td>		
                        <td valign="top">#qGetCandidates.businessName#</td>
                        <td valign="top">#DateFormat(qGetCandidates.dateIncident, 'mm/dd/yyyy')#</td>
                        <td valign="top">#qGetCandidates.subject#</td>
                        <td valign="top">#qGetCandidates.notes#</td>
                        <td valign="top">#YesNoFormat(VAL(qGetCandidates.isSolved))#</td>
                    </tr>
                </cfoutput>
                
            </table>
            
        </cfoutput>
        
        <cfif NOT VAL(qGetCandidates.recordCount)>
            <table width="98%" cellpadding="3" cellspacing="0" align="center" style="margin-top:20px; margin-bottom:20px; border:1px solid ##4F8EA4"> 
                <tr style="background-color:##4F8EA4; color:##FFF; padding:5px; font-size: 12px; text-align:center;">
                    <td>No incidents found.</td>
                </tr>
			</table>        
        </cfif>
        
        <cfoutput>
            <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br/><br/>
            <span  class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>     
		</cfoutput>
        
    </cfsavecontent>


	<cfoutput>
    
        <!-----Display Reports---->
        <cfswitch expression="#FORM.printOption#">
        
            <!--- Screen --->
            <cfcase value="1">
                <!--- Include Report --->
                #reportContent#
            </cfcase>
            
            <!--- Flash Paper --->
            <cfcase value="2">
                <cfdocument format="PDF" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
                    <style type="text/css">
                    <!--
                    .style1 { 
                        font-family: Arial, Helvetica, sans-serif;
                        font-size: 10;
                        }
                    -->
                    </style>
                    
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <strong><font size="4" face="Verdana, Arial, Helvetica, sans-serif" >Missing Documents Report</font></strong><br>                
                    
                    <!--- Include Report --->
                    #reportContent#
                </cfdocument>
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
                    
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <strong><font size="4" face="Verdana, Arial, Helvetica, sans-serif" >Missing Documents Report</font></strong><br>                
                    
                    <!--- Include Report --->
                    #reportContent#
                </cfdocument>
            </cfcase>
        
            <cfdefaultcase>    
                <div align="center" class="style1">
                    Print results will replace the menu options and take a bit longer to generate. <br />
                    Onscreen will allow you to change criteria with out clicking your back button.
                </div>
            </cfdefaultcase>
            
        </cfswitch>
    
    </cfoutput>

</cfif>

