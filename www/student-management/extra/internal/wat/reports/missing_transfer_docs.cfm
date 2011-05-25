    <cfsetting requesttimeout="9999">
    
    <!--- Param FORM variables --->
	<cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.userID" default="0">
	<cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.submitted" default="0">
    <Cfparam name="missingdocs.recordcount" default="0">
    <Cfparam name="url.orderBy" default="intrep">
    
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

<cfif isDefined('form.submitted')>
	<cfquery name="missingDocs" datasource="mysql">
    SELECT ecpc.candidateid, ecpc.hostcompanyid, ecpc.transNewHousingAddress, ecpc.transNewJobOffer, ecpc.transSevisUpdate,
    ec.firstname, ec.lastname, ec.email, ec.programid, ec.uniqueid, hc.name as hostCompanyName, hc.email as hostCompanyEmail,
    u.businessname, u.email as agent_email,
    p.programname
    from extra_candidate_place_company ecpc
    JOIN extra_hostcompany hc on hc.hostcompanyid = ecpc.hostcompanyid
    LEFT JOIN extra_candidates ec on ec.candidateid = ecpc.candidateid
    LEFT JOIN smg_users u on u.userid = ec.intrep
    LEFT JOIN smg_programs p on p.programid = ec.programid
    WHERE ecpc.transfer = 1 
    AND (transNewHousingAddress = 0 OR transNewJobOffer = 0 OR transSevisUpdate = 0)
    <!----Limit by Program, if selected---->
	<Cfif form.programid gt 0>
    AND ec.programid = #form.programid#
    </Cfif>
    <!----Limit by Agent if selected---->
    <Cfif form.userid gt 0>
    AND u.userid = #form.userid#
    </Cfif>
    order by #url.orderby#
    </cfquery>

</cfif>
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
                	<option value="#programID#" <cfif qGetProgramList.programID eq FORM.programID> selected</cfif> >#programname#</option>
                </cfloop>
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
<Cfif isDefined('form.submitted')>
<cfif LEN(printOption)>

    <cfsavecontent variable="reportContent">
       
    
        <img src="../../pics/black_pixel.gif" width="100%" height="2">
                        
        <table width=99% cellpadding="4" align="center" cellspacing=0>
            <tr bgcolor="##FFFFCC">
                <td align="left" class="style1"><strong><a href="index.cfm?curdoc=reports/missing_transfer_docs&orderby=intrep"><font color="##000000">Intl. Rep.</strong></td>	 
                <td align="left" class="style1"><strong><a href="index.cfm?curdoc=reports/missing_transfer_docs&orderby=candidateID"><font color="##000000">ID</strong></td>
                <td align="left" class="style1"><strong><a href="index.cfm?curdoc=reports/missing_transfer_docs&orderby=lastname"><font color="##000000">Last Name</strong></td>
                <td align="left" class="style1"><strong><a href="index.cfm?curdoc=reports/missing_transfer_docs&orderby=firstname"><font color="##000000">First Name</strong></td>
                <td align="left" class="style1"><strong><a href="index.cfm?curdoc=reports/missing_transfer_docs&orderby=hostCompanyName"><font color="##000000">Placement Information</strong></td>  
                <td align="left" class="style1" width="130"><strong>Missing Trans Docs</strong></td>	  
               	
            </tr>
    
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    
            <cfif NOT VAL(missingDocs.recordCount)>
                <tr><td align="center" colspan=10 class="style1"> <div align="center">No students found based on the criteria you specified. Please change and re-run the report.</div><br /></td></tr>
            </cfif>
            
            <cfloop query="missingDocs">
            	<cfquery name="HostCompanyInfo" datasource="mysql">
                select name, email
                from extra_hostcompany
                where hostcompanyid = #hostcompanyid#
                </cfquery>
                <tr <cfif missingDocs.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
                    <td valign="top" class="style1">
                    <a href="mailto:#missingDocs.agent_email#" class="style4">#missingDocs.businessname#</a> </td>
                    <td valign="top" class="style1"><a href="?curdoc=candidate/candidate_info&uniqueid=#missingDocs.uniqueID#" target="_blank" class="style4">		#missingDocs.candidateid#</td>
                    <td valign="top" class="style1">
                    <a href="mailto:#missingDocs.email#" class="style4">#missingDocs.lastname#</a> </td>
                    <td valign="top" class="style1">
                    <a href="mailto:#missingDocs.email#" class="style4">#missingDocs.firstname#</a> </td>
                    <td valign="top" class="style1">
                    <a href="mailto:#missingDocs.hostCompanyemail#" class="style4">#missingDocs.hostCompanyName#</a> </td>
                    <td valign="top" class="style1">
                        <cfif NOT VAL(missingDocs.transNewHousingAddress)><font color="##CC0000">Housing Address</font><br /></cfif>
                        <cfif NOT VAL(missingDocs.transNewJobOffer)><font color="##CC0000">Job Offer</font><br /></cfif>
                        <cfif NOT VAL(missingDocs.transSevisUpdate)><font color="##CC0000">SEVIS Update</font><br /></cfif>
                       
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

</cfif>
</Cfif>

</Cfoutput>
