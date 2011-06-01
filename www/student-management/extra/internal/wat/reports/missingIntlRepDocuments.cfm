<!--- Kill extra output --->
<cfsilent>

    <!--- Param FORM Variables --->	
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.userID" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.printOption" default="1">

    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>

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

	<cfif VAL(FORM.submitted)>
     
        <cfquery name="qGetResults" datasource="mysql">
            SELECT DISTINCT
                u.companyID, 
                u.businessname,
				<!--- Documents Control --->
                watDocBusinessLicense,
                watDocBankrupcyDisclosure,
                watDocWrittenReference1,
                watDocWrittenReference2,
                watDocWrittenReference3,
                watDocPreviousExperience,
                watDocOriginalCBC,
                watDocEnglishCBC,
                watDocOriginalAdvertisingMaterial,
                watDocEnglishAdvertisingMaterial
            FROM 
                smg_users u
                
            <cfif VAL(FORM.programID)>
            	INNER JOIN
                	extra_candidates c ON c.intRep = u.userID 
                    	AND 
                        	c.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#"> 
            </cfif>
            
            WHERE 
                u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND
            	u.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
                
            <cfif VAL(FORM.userID)> 
                AND 
                    u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
			</cfif>
            
            AND (
                    u.watDocBusinessLicense = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    u.watDocBankrupcyDisclosure = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    u.watDocWrittenReference1 = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    u.watDocWrittenReference2 = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    u.watDocWrittenReference3 = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    u.watDocPreviousExperience = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR
                    u.watDocOriginalCBC = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    u.watDocEnglishCBC = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    u.watDocOriginalAdvertisingMaterial = <cfqueryparam cfsqltype="cf_sql_integer" value="0">   
                OR
                	u.watDocEnglishAdvertisingMaterial = <cfqueryparam cfsqltype="cf_sql_integer" value="0">  
				)                    
            ORDER BY 
                u.businessname 
        </cfquery>
     
    </cfif>

</cfsilent>

<style type="text/css">
	<!--
		.style1 { 
			font-family: Arial, Helvetica, sans-serif;
			font-size: 10;
			}
	-->
</style>

<cfoutput>

<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
    <input type="hidden" name="submitted" value="1">
    
    <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Missing Intl. Rep. Documents</font>
            </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>Intl. Representative: </b></td>
            <td> 
            	<select name="userID" class="style1">
                    <option value="0">All</option>
                    <cfloop query="qGetIntlRepList">
                        <option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.userID> selected</cfif>>#qGetIntlRepList.businessName#</option>
                    </cfloop>
                </select>
	        </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>Program:</b></td>
            <td> 
                <select name="programID" class="style1">
                    <option value="0"></option>
                    <cfloop query="qGetProgramList">
                        <option value="#programID#" <cfif qGetProgramList.programID eq FORM.programID> selected</cfif> >#programname#</option>
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

<cfif VAL(FORM.submitted)>

    <cfsavecontent variable="reportContent">
        <div class="style1"><strong>&nbsp; &nbsp; ------------------------------------------------------</strong></div>
        <div class="style1"><strong>&nbsp; &nbsp; Total Number of Intl. Rep.:</strong> #qGetResults.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; ------------------------------------------------------</strong></div>		
    
        <img src="../../pics/black_pixel.gif" width="100%" height="2">
                        
        <table width=99% cellpadding="4" align="center" cellspacing=0>
            <tr bgcolor="##FFFFCC" style="font-weight:bold;">
                <td align="left" class="style1" width="30%">International Representative</td>	 
                <td align="left" class="style1" width="70%">Missing Documents</td>	  
            </tr>
    
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    
            <cfif NOT VAL(qGetResults.recordCount)>
                <tr><td align="center" colspan=10 class="style1"> <div align="center">No intl. representative found based on the criteria you specified. Please change and re-run the report.</div><br /></td></tr>
            </cfif>
            
            <cfloop query="qGetResults">
                <tr <cfif qGetResults.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
                    <td valign="top" class="style1">#qGetResults.businessname#</td>
                    <td valign="top" class="style1" style="color:##CC0000">
                        <cfif NOT VAL(qGetResults.watDocBusinessLicense)>- Proof of business license<br /></cfif>
                        <cfif NOT VAL(qGetResults.watDocBankrupcyDisclosure)>- Disclosure of any previous bankrupcy and of any pending legal actions<br /></cfif>
						<cfif NOT VAL(qGetResults.watDocWrittenReference1)>- Written references from current business associates or partner organizations 1<br /></cfif>
						<cfif NOT VAL(qGetResults.watDocWrittenReference2)>- Written references from current business associates or partner organizations 2<br /></cfif>
                        <cfif NOT VAL(qGetResults.watDocWrittenReference3)>- Written references from current business associates or partner organizations 3<br /></cfif>
						<cfif NOT VAL(qGetResults.watDocPreviousExperience)>- Summary of previous experience conducting J-1 exchange visitor program activities<br /></cfif>
                        <cfif NOT VAL(qGetResults.watDocOriginalCBC)>- Original criminal backgound check<br /></cfif>
						<cfif NOT VAL(qGetResults.watDocEnglishCBC)>- English criminal backgound check<br /></cfif>
                        <cfif NOT VAL(qGetResults.watDocOriginalAdvertisingMaterial)>- Original copy of the sponsor-approved advertising materials<br /></cfif>
						<cfif NOT VAL(qGetResults.watDocEnglishAdvertisingMaterial)>- English copy of the sponsor-approved advertising materials<br /></cfif>
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

</cfoutput>