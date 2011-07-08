<!--- Kill extra output --->
<cfsilent>

    <cfsetting requesttimeout="9999">
        
    <!--- Param FORM variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.userID" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">
    <Cfparam name="FORM.orderBy" default="businessname">
        
    <cfquery name="qGetIntlRepList" datasource="MySql">
        SELECT 
            userid, 
            businessname
        FROM 
            smg_users
        WHERE         
            usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND 
            businessname != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        ORDER BY 
            businessname
    </cfquery>
    
    <cfscript>
        // Get Program List
        qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
    </cfscript>
    
    <cfif VAL(FORM.submitted)>
    
        <cfquery name="qGetMissingDocs" datasource="mysql">
            SELECT
                ecpc.candidateid, 
                ecpc.hostcompanyid, 
                ecpc.isTransferHousingAddressReceived, 
                ecpc.isTransferJobOfferReceived, 
                ecpc.isTransferSevisUpdated,
                ecpc.dateTransferConfirmed,
                ec.firstname, 
                ec.lastname, 
                ec.email, 
                ec.programid, 
                ec.uniqueid, 
                hc.name as hostCompanyName, 
                hc.email as hostCompanyEmail,
                u.businessname, 
                u.email as agent_email,
                p.programname
            from 
                extra_candidate_place_company ecpc
            INNER JOIN 
                extra_hostcompany hc on hc.hostcompanyid = ecpc.hostcompanyid
            LEFT JOIN 
                extra_candidates ec on ec.candidateid = ecpc.candidateid
            LEFT JOIN 
                smg_users u on u.userid = ec.intrep
            LEFT JOIN 
                smg_programs p on p.programid = ec.programid
            WHERE 
                ecpc.isTransfer = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
    
            <!----Limit by Program, if selected---->
            <Cfif VAL(FORM.programid)>
                AND 
                    ec.programid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#">
            </Cfif>
            
            <!----Limit by Agent if selected---->
            <Cfif VAL(FORM.userid)>
                AND 
                    u.userid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userid#">
            </Cfif>
                
            AND 
                (
                    ecpc.isTransferHousingAddressReceived = <cfqueryparam cfsqltype="cf_sql_bit" value="0">  
                OR 
                    ecpc.isTransferJobOfferReceived = <cfqueryparam cfsqltype="cf_sql_bit" value="0">  
                OR 
                    ecpc.isTransferSevisUpdated = <cfqueryparam cfsqltype="cf_sql_bit" value="0">  
                OR
                    ecpc.dateTransferConfirmed IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                )
            
            ORDER BY 
                <cfswitch expression="#FORM.orderBy#">
                
                	<cfcase value="businessName,candidateID,lastName,firstName,hostCompanyName">
                    	#FORM.orderBy#
                    </cfcase>
				
                	<cfdefaultcase>
                    	businessName
                    </cfdefaultcase>
				
                </cfswitch>                                        
        </cfquery>
    	
    </cfif>
    
</cfsilent>
    
<Cfoutput>

    <form action="index.cfm?curdoc=reports/missing_transfer_docs" method="post">
        <input type="hidden" name="submitted" value="1" />
    
        <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
            <tr valign="middle" height="24">
                <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Missing Documents -> Transfer Documents</font>
                </td>
            </tr>
            <tr valign="middle" height="24">
                <td valign="middle" colspan="2">&nbsp;</td>
            </tr>
            <tr valign="middle">
                <td align="right" valign="middle" class="style1"><b>Intl. Rep.:</b> </td>
                <td valign="middle">  
                    <select name="userID" class="style1">
                        <option value="0">---  All International Representatives  ---</option>
                        <cfloop query="qGetIntlRepList">
                            <option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.userID> selected</cfif> >#qGetIntlRepList.businessname#</option>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="middle" align="right" class="style1"><b>Program:</b></td>
                <td> 
                    <select name="programID" class="style1">
                        <option value="0">Select a Program</option>
                        <cfloop query="qGetProgramList">
                            <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programID EQ FORM.programID> selected</cfif> >#qGetProgramList.programname#</option>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="middle" align="right" class="style1"><b>Order By:</b></td>
                <td> 
                    <select name="orderBy" class="style1">
                        <option value="businessName" <cfif FORM.orderBy EQ 'businessName'> selected </cfif> >Intl. Rep.</option>
                        <option value="candidateID" <cfif FORM.orderBy EQ 'candidateID'> selected </cfif> >Candidate ID</option>
                        <option value="lastName" <cfif FORM.orderBy EQ 'lastName'> selected </cfif> >Last Name</option>
                        <option value="firstName" <cfif FORM.orderBy EQ 'firstName'> selected </cfif> >First Name</option>
                        <option value="hostCompanyName" <cfif FORM.orderBy EQ 'hostCompanyName'> selected </cfif> >Placement Information</option>
                    </select>
                </td>
            </tr>
            <Tr>
                <td align="right" class="style1"><b>Format: </b></td>
                <td  class="style1"> 
                    <input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                    <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2">Print (FlashPaper)</label> 
                    <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3">Print (PDF)</label>
                </td>           
            </Tr>
            <tr>
                <td colspan=2 align="center"><br />
                    <input type="submit" value="Generate Report" class="style1" />
                    <br />
                </td>
            </tr>
        </table>
    
    </form>

	<!---Output---->
    <Cfif VAL(FORM.submitted)>

        <cfsavecontent variable="reportContent">
           
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
                            
            <table width=99% cellpadding="4" align="center" cellspacing="0">  
                <tr bgcolor="##FFFFCC" style="font-weight:bold;">
                    <td align="left" class="style1">Intl. Rep.</td>	 
                    <td align="left" class="style1">ID</td>
                    <td align="left" class="style1">Last Name</td>
                    <td align="left" class="style1">First Name</td>
                    <td align="left" class="style1">Placement Information</td>  
                    <td align="left" class="style1" width="130">Missing Transfer Docs</td>	  
                </tr>
        
                <img src="../../pics/black_pixel.gif" width="100%" height="2">
                        
                <cfif NOT VAL(qGetMissingDocs.recordCount)>
                    <tr><td align="center" colspan=10 class="style1"> <div align="center">No students found based on the criteria you specified. Please change and re-run the report.</div><br /></td></tr>
                </cfif>
                
                <cfloop query="qGetMissingDocs">
                    <tr <cfif qGetMissingDocs.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
                        <td valign="top" class="style1">
                        	<a href="mailto:#qGetMissingDocs.agent_email#" class="style4">#qGetMissingDocs.businessname#</a>
                        </td>
                        <td valign="top" class="style1">
                        	<a href="?curdoc=candidate/candidate_info&uniqueid=#qGetMissingDocs.uniqueID#" target="_blank" class="style4">#qGetMissingDocs.candidateid#</a>
                        </td>
                        <td valign="top" class="style1">
                        	<a href="mailto:#qGetMissingDocs.email#" class="style4">#qGetMissingDocs.lastname#</a> 
                        </td>
                        <td valign="top" class="style1">
                        	<a href="mailto:#qGetMissingDocs.email#" class="style4">#qGetMissingDocs.firstname#</a> 
                        </td>
                        <td valign="top" class="style1">
                        	<a href="mailto:#qGetMissingDocs.hostCompanyemail#" class="style4">#qGetMissingDocs.hostCompanyName#</a> 
                        </td>
                        <td valign="top" class="style1">
                            <cfif NOT VAL(qGetMissingDocs.isTransferHousingAddressReceived)><font color="##CC0000">Housing Address</font><br /></cfif>
                            <cfif NOT VAL(qGetMissingDocs.isTransferJobOfferReceived)><font color="##CC0000">Job Offer</font><br /></cfif>
                            <cfif NOT VAL(qGetMissingDocs.isTransferSevisUpdated)><font color="##CC0000">SEVIS Update</font><br /></cfif>
                            <cfif NOT isDate(qGetMissingDocs.dateTransferConfirmed)><font color="##CC0000">Confirmation Date</font><br /></cfif>
                        </td>
                    </tr>
                </cfloop>
            </table>
            
            <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br/><br/>
            <span  class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>     
        </cfsavecontent>
    
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
    
	</Cfif>

</Cfoutput>
