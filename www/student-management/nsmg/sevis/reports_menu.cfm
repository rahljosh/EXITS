<!--- ------------------------------------------------------------------------- ----
	
	File:		reports_menu.cfm
	Author:		Marcus Melo
	Date:		May 06, 2011
	Desc:		Gets a total of students per agent by batch IDs

	Updated:	05-06-2011 - Total of Students By International Representative added
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param FORM Variables --->
	<cfparam name="FORM.submitted" default="0">    
    <cfparam name="FORM.listBatchID" default="">

	<!--- INTERNATIONAL REPS WITH KIDS ASSIGNED TO THE COMPANY--->
    <cfinclude template="../querys/get_intl_rep.cfm">

	<cfinclude template="../querys/get_active_programs.cfm">

    <cfquery name="qGetSevisHistory" datasource="MySql">
        SELECT 
            ss.batchid, 
            ss.datecreated,
            ss.totalPrint,
            c.companyShort
        FROM 
            smg_sevis ss
        LEFT OUTER JOIN
            smg_companies c ON c.companyID = ss.companyID            
        WHERE 
            ss.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="new">
		<!--- Filter for Case --->
        <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.NonISE, CLIENT.companyID)>
            AND 
                ss.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>
            AND
                ss.companyID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.NonISE#" list="yes"> )
        </cfif>	
        ORDER BY 
            ss.batchID DESC
		LIMIT
        	30           
    </cfquery>
    
    <cfif FORM.submitted>
        	
		<cfscript>
            if ( NOT LEN(FORM.listBatchID) ) {
                SESSION.formErrors.Add("Please select at least one batch ID");
            }
        </cfscript>				
    
    	<cfif NOT SESSION.formErrors.length()>
        
        	<!--- Get Results --->
            <cfquery name="qGetResults" datasource="MySql"> 
                SELECT 	                	
                    count(s.studentID) AS totalStudents,
                    u.userID,
                    u.businessName
                FROM 
                    smg_students s
                INNER JOIN 
                    smg_users u ON s.intrep = u.userid
                WHERE 
                    s.sevis_batchid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.listBatchID#" list="yes"> )
                GROUP BY
                	u.userID
                ORDER BY 
                    u.businessname
            </cfquery>
        	
        </cfif>
    
    </cfif>
    
    
</cfsilent>

<cfoutput>
            
	<!--- FORM Submitted - Display Report --->
    <cfif FORM.submitted AND NOT SESSION.formErrors.length()>

        <table width="60%" class="report" cellpadding="3" cellspacing="0" align="center">
            <tr>
            	<td colspan="2" style="font-weight:bold; border:1px solid ##CCC;" align="center">
                	<p>Total of Students By International Representative</p>
                </td>
			</tr>	  
            <tr>
            	<td colspan="2" style="font-weight:bold; border:1px solid ##CCC;">
                    <p>Batches included in this report: #FORM.listBatchID#</p>
                </td>
			</tr>	            
            <tr bgcolor="##FFFFE6">
                <td valign="top" style="font-weight:bold; border:1px solid ##CCC;">International Representative</td>
                <td valign="top" style="font-weight:bold; border:1px solid ##CCC;" align="center">Total of Students</td>
            </tr>
            <cfloop query="qGetResults">
                <tr bgcolor="###iif(qGetResults.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td style="border:1px solid ##CCC;">#qGetResults.businessName#</td>
                    <td style="border:1px solid ##CCC;" align="center">#qGetResults.totalStudents#</td>
                </tr>
			</cfloop>
		</table>                
    
    <!--- FORM --->
    <cfelse>

        <table class="nav_bar" cellpadding=4 cellspacing="0" align="center" width="100%">
            <tr>
                <th bgcolor="ededed">&nbsp; &nbsp; &nbsp; &nbsp; S E V I S &nbsp; R E P O R T S</th>
                <td width="5%" align="right" bgcolor="ededed"><a href="index.cfm?menu=tools&submenu=users&curdoc=sevis/menu"><img src="pics/sevis_menu.gif" border="0"></a></td>
           </tr>
        </table>
        
        <br />

        <!--- Table Header --->
        <gui:tableHeader
            imageName="students.gif"
            tableTitle="SEVIS Batch Reports"
            width="100%"
        />    
        
            <!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="tableSection"
                width="100%"
                />
            
            <!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="tableSection"
                width="100%"
                />

            <table border="0" cellpadding="8" cellspacing="2" width="100%" class="section">
                <tr>
                    <td>
                        
                        <table cellpadding="4" cellspacing="0" align="center" width="100%">
                            <tr>
                            	<!--- Batch Report --->
                                <td width="50%" valign="top">
                                    <form action="sevis/report_students.cfm" method="post" target="_blank">
                                        <input type="hidden" name="submitted" value="1" />
                                        <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="80%">
                                            <tr><th colspan="2" bgcolor="##e2efc7">BATCH REPORT</th></tr>
                                            <tr>
                                            	<th colspan="2" bgcolor="##e2efc7">
                                            		<font size="-2">(Batch ID, Batch Date, Bulk ID, Bulk Date and Insured Date)</font>
                                                </th>
                                            </tr>
                                            <tr align="left">
                                                <td valign="top" align="right"><label for="programID">Program:</label></td>
                                                <td>
                                                    <select name="programID" id="programID" multiple="multiple" size="6" style="width:300px;">
                                                        <cfloop query="get_program">
                                                            <option value="#get_program.programID#">#get_program.programName#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>		
                                            </tr>
                                            <tr align="left">
                                                <td valign="top" align="right"><label for="intrep">Intl. Rep.:</label></td>
                                                <td>
                                                    <select name="intrep" id="intrep" style="width:300px;">
                                                        <option value="0">All</option>
                                                        <cfloop query="get_intl_rep">
                                                            <option value="#get_intl_rep.userID#">#get_intl_rep.businessName#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>		
                                            </tr>
                                            <tr>
                                                <td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                            </tr>
                                        </table>
                                    </form>
                                </td>
                                
                                <!--- Total of Students By International Representative --->
                                <td width="50%" valign="top">
                                    <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                                        <input type="hidden" name="submitted" value="1" />
                                        <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="80%">
                                            <tr><th colspan="2" bgcolor="##e2efc7">Total of Students By International Representative</th></tr>
                                            <tr align="left">
                                                <td valign="top" align="right"><label for="listBatchID">BatchID:</label></td>
                                                <td>
                                                    <select name="listBatchID" id="listBatchID" multiple="multiple" size="9" style="width:300px;">
                                                        <cfloop query="qGetSevisHistory">
                                                            <option value="#qGetSevisHistory.batchID#">
	                                                            #qGetSevisHistory.companyShort# - 
                                                                #DateFormat(qGetSevisHistory.datecreated, 'mm/dd/yy')# - 
                                                                ###qGetSevisHistory.batchID# - 
                                                                #qGetSevisHistory.totalPrint# student(s)
                                                            </option>
                                                        </cfloop>
                                                    </select>
                                                </td>		
                                            </tr>
                                            <tr>
                                                <td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                            </tr>
                                        </table>
                                    </form>
                                </td>
                            </tr>
                        </table>
    
                    </td>
                </tr>
            </table>
            
		<!--- Table Footer --->
        <gui:tableFooter 
            width="100%"
        />
        
    </cfif>

</cfoutput>





