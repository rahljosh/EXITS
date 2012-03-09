<!--- ------------------------------------------------------------------------- ----
	
	File:		labels_select_pro.cfm
	Author:		Marcus Melo
	Date:		March 22, 2010
	Desc:		Student ID Card Landing Page

	Updated:  	03/22/2010 - Adding Insurance ID Cards

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfinclude template="../querys/get_active_programs.cfm">
    
    <!--- INTERNATIONAL REPS WITH KIDS ASSIGNED TO THE COMPANY--->
    <cfinclude template="../querys/get_intl_rep.cfm">
    
    <cfinclude template="../querys/get_regions.cfm">
    
    <cfinclude template="../querys/get_countries.cfm">
    
    <cfinclude template="../querys/insurance_policies.cfm">
    
    <cfquery name="qGetBatches" datasource="MySql">
        SELECT 
        	s.batchid, 
            s.datecreated,
            c.companyShort           
        FROM 
        	smg_sevis s
		LEFT OUTER JOIN
        	smg_companies c ON c.companyID = s.companyID            
        WHERE 
        <cfif CLIENT.companyID EQ 10>
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        <cfelse>
        	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        </cfif>        
        AND 
        	s.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="new">
        AND	
        	s.dateCreated >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('m', -6, now())#">
        ORDER BY 
        	s.batchid DESC
    </cfquery>
    
    <cfquery name="qInsuranceDates" datasource="MySql">
        SELECT 
        	s.insurance
        FROM
        	smg_students s
        INNER JOIN 
        	smg_programs p ON p.programID = s.programID
        INNER JOIN 
        	smg_users u ON u.userid = s.intRep
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND 
        	u.insurance_typeid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="2,3,4,5,6" list="yes"> )
        GROUP BY 
        	insurance DESC
    </cfquery>

</cfsilent>

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
	imageName="students.gif"
	tableTitle="Labels, Insurance and Student ID Cards"
	tableRightTitle=""
/>

<table border="0" cellpadding="8" cellspacing="2" width=100% class="section">
    <tr>
    	<td valign="top">
    
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7">Student ID Cards <font size="-2">(Ordered by Agent)</font></th></tr>
                <tr align="center">
                    <td width="50%" valign="top">
                        
                        <cfform action="reports/labels_student_idcards_batchid.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="2" bgcolor="##e2efc7">Students ID Cards per Batch ID</th></tr>
                            <tr>
                                <td>Batch ID: </td>
                                <td align="left">
                                    <select name="batchid" multiple size="6">
                                        <cfloop query="qGetBatches">
                                            <option value="#batchid#">#batchid# &nbsp; #DateFormat(datecreated,'mm/dd/yy')# &nbsp; #companyShort# &nbsp;</option>
                                        </cfloop>
                                    </select>
                                </td>
                             </tr>
                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                    <cfselect name="intRep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
                                        <option value=0>All Reps</option>
                                    </cfselect>
                                </td>
                            </tr>					
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                    <cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>
                            <tr><td colspan="2"><a href="reports/intl_agent_insurance_policies.cfm" target="_blank">Intl. Representatives Insurance Policy List</a></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    <td width="50%" valign="top">
                        
                        <cfform action="reports/labels_student_idcards_batchid_list.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="2" bgcolor="##e2efc7">List of Students per Batch ID</th></tr>
                            <tr>
                                <td>Batch ID: </td>
                                <td align="left">
                                    <select name="batchid" multiple size="6">
                                        <cfloop query="qGetBatches">
                                            <option value="#batchid#">#batchid# &nbsp; #DateFormat(datecreated,'mm/dd/yy')# &nbsp; #companyShort# &nbsp;</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                    <cfselect name="intRep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below" multiple="yes" size="8"></cfselect>
                                </td>
                            </tr>					
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                    <cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>
                            <tr><td colspan="2"><a href="reports/intl_agent_insurance_policies.cfm" target="_blank">Intl. Representatives Insurance Policy List</a></td></tr>				
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                </tr>
                <tr align="center">
                    <td width="50%" valign="top">
                        
                        <cfform action="reports/labels_student_idcards.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">Students ID Cards per Entered Date</th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                    <cfselect name="intRep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
                                        <option value=0>All Reps</option>
                                    </cfselect>
                                </td>
                            </tr>					
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                    <cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>
                            <tr>
                                <td>Date Entered: </td>
                                <td>
                                    <span style="float:left">From: &nbsp;</span>
                                    <input type="text" name="date1" class="datePicker" maxlength="10">
                                    <span style="float:left;">To: &nbsp;</span>
                                    <input type="text" name="date2" class="datePicker" maxlength="10">                                                                                                                                   
                                </td>
                            </tr>
                            <tr><td align="right"><input type="checkbox" name="usa" disabled="disabled"></input></td></tr>				
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>	
                            
                    </td>
                    <td width="50%" valign="top">	
                    
                        <cfform action="reports/labels_student_idcards_id.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="2" bgcolor="##e2efc7">Students ID Cards per Program/ID<th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>

                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                    <cfselect name="intRep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
                                        <option value=0>All Reps</option>
                                    </cfselect>
                                </td>
                            </tr>					
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                    <cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>
                            <tr>
                                <td>Student ID: </td>
                                <td>
                                	From: &nbsp; <input type="text" name="id1" size="4" maxlength="6">
                                    &nbsp;
                                	To: &nbsp; <input type="text" name="id2" size="4" maxlength="6">
                                </td>
                            </tr>
                            <tr>	
                            	<td align="right"><input type="checkbox" name="isUsCitizen" id="isUsCitizen" value="1"></input></td>
                            	<td><label for="isUsCitizen">Only American Citizen Students</label></td>
                            </tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>	
                                
                    </td>
                </tr>
                
                <tr> 
                    <td colspan="2">
                    	<div align="justify">
                            <font color="FF0000">Note: </font>
                            Use Internet Explorer. Please Make sure to redefine the margins and take out the header and footer page before you
                            print the ID cards. Please redefine all margins (top, botton, left and right) to 0.3.                             
						</div>
                    </td>
                </tr>
            </table>
            
            <br><br>
     
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7">Insurance Cards <font size="-2">(Ordered by Agent)</font></th></tr>
                <tr align="center">
                    <td width="50%" valign="top">
                        
                        <cfform action="reports/insurance_cards_batchid.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="2" bgcolor="##e2efc7">Insurance Cards per Batch ID</th></tr>
                            <tr>
                                <td>Batch ID: </td>
                                <td align="left">
                                    <select name="batchid" multiple size="8">
                                        <cfloop query="qGetBatches">
                                            <option value="#batchid#">#batchid# &nbsp; #DateFormat(datecreated,'mm/dd/yy')# </option>
                                        </cfloop>
                                    </select>
                                </td>
                             </tr>
                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                    <cfselect name="intRep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
                                        <option value=0>All Reps</option>
                                    </cfselect>
                                </td>
                            </tr>					
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                    <cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    <td width="50%" valign="top">

                        <cfform action="reports/insurance_cards_studentid.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="2" bgcolor="##e2efc7">Insurance Cards per ID</th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                    <cfselect name="intRep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
                                        <option value=0>All Reps</option>
                                    </cfselect>
                                </td>
                            </tr>					
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                    <cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>
                            <tr>
                                <td>Student ID: </td>
                                <td>
                                	From: &nbsp; <input type="text" name="id1" size="4" maxlength="6">
                                    &nbsp;
                                	To: &nbsp; <input type="text" name="id2" size="4" maxlength="6">
                                </td>
                            </tr>
                            <tr>	
                            	<td align="right"><input type="checkbox" name="isUsCitizen" id="isUsCitizen2" value="1"></input></td>
                            	<td><label for="isUsCitizen2">Only American Citizen Students</label></td>
                            </tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
						                       
                    </td>
                </tr>
                
                <tr> 
                    <td colspan="2">
                    	<div align="justify">
                            Set margins to: <br>
                            IE: top: 0.5 / bottom: 0.4 / left: 0.7 / right: 0.5 <br>                                                
                            Firefox: top: 0.3 / bottom: 0.3 / left: 0.5 / right: 0.5 <br>                                                
                            Make sure you set page scaling to: Shrink to Printable Area <br>
                        </div>
                    </td>
                </tr>
            </table>
            
            <br><br>
            
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7">ID CARDS & MAILING LABELS - STUDENTS IN THE USA <font size="-2">(Approved placements only)</font></th></tr>
                <tr align="center">
                	<td width="50%" valign="top">
                        
                        <cfform action="reports/labels_student_idcards_place_date.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="2" bgcolor="##e2efc7">Students ID Cards per Placement Date</th></tr>
                            <tr>
                            	<td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>				
                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                	<cfselect name="intRep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
                                        <option value=0>All Reps</option>
                                    </cfselect>
                                </td>
                            </tr>					
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                	<cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>
                            <tr>
                                <td>Date Placed:</td>
                                <td>
                                    <span style="float:left">From: &nbsp;</span>
                                    <input type="text" name="date1" class="datePicker" maxlength="10">
                                    <span style="float:left;">To: &nbsp;</span>
                                    <input type="text" name="date2" class="datePicker" maxlength="10">                                                                                                                                   
                                </td>
                            </tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    <td width="50%" valign="top">
                        
                        <cfform action="reports/labels_students_place_date.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">Labels per Placement Date</th></tr>
                            <tr>
                            	<td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>				
                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                	<cfselect name="intRep" query="get_intl_rep" value="userid" display="businessname" queryPosition="below">
                                        <option value=0>All Reps</option>
                                    </cfselect>
                                </td>
                            </tr>					
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                	<cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>
                            <tr>
                                <td>Date Placed:</td>
                                <td>
                                    <span style="float:left">From: &nbsp;</span>
                                    <input type="text" name="date1" class="datePicker" maxlength="10">
                                    <span style="float:left;">To: &nbsp;</span>
                                    <input type="text" name="date2" class="datePicker" maxlength="10">                                                                                                                                   
                                </td>
                            </tr>
                            
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        		
                    </td>
                </tr>
            </table>
            
            <br><br>
                
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7">LABELS FOR FILING</th></tr>
                <tr align="center">
                	<td width="50%" valign="top">
                        
                        <cfform action="reports/labels_for_filing.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">Students Accepted per Period</th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr>
                            	<td>Acceptance From: </td>
                                <td><input type="text" name="date1" class="datePicker" maxlength="10"> mm/dd/yyyy</td>
                            </tr>
                            <tr>
                            	<td>To: </td>
                                <td><input type="text" name="date2" class="datePicker" maxlength="10"> mm/dd/yyyy</td>
                            </tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    <td width="50%" valign="top">
                    
                        <cfform action="reports/labels_for_filing_id.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="2" bgcolor="##e2efc7">Students per ID</th></tr>
                            <tr>
                                <td>Student ID: </td>
                                <td>
                                	From: &nbsp; <input type="text" name="id1" size="4" maxlength="6">
                                    &nbsp;
                                	To: &nbsp; <input type="text" name="id2" size="4" maxlength="6">
                                </td>
                            </tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                </tr>

                <tr align="center">
                    <td width="50%" valign="top">
                       
                        <cfform action="reports/labels_intRep.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">International Representatives</th></tr>
                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                	<cfselect name="intRep" query="get_intl_rep" value="userID" display="businessName" queryPosition="below">
                                    	<option value=0>All Reps</option>
                                    </cfselect>
                                </td>
                            </tr>								
                            <tr><td colspan="3"><input type="checkbox" name="inactive">Include Inactive Intl. Reps.</input></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    <td width="50%" valign="top">
                   		<!----Empty Cell---->
                    </td>
                </tr>
            </table>
          
            <br><br>

            <!--- BULK MAILING - LABELS + WELCOME LETTERS --->
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7">BULK Mailing <font size="-2">(Approved placements only)</font></th></tr>
                <tr align="center">
                    <td width="50%" valign="top">
                    
                        <cfform action="reports/bulk_host_family_letter.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">Host Family Welcome Letters</th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr>
                            	<td>Region:</td>
                                <td><cfselect name="regionID" query="get_regions" value="regionID" display="regionname" multiple="yes" size="8" queryPosition="below"></cfselect></td>
                            </tr>
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                	<cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>		
                            <tr>
                                <td>Date Placed:</td>
                                <td>
                                    <span style="float:left">From: &nbsp;</span>
                                    <input type="text" name="date1" class="datePicker" maxlength="10">
                                    <span style="float:left;">To: &nbsp;</span>
                                    <input type="text" name="date2" class="datePicker" maxlength="10">                                                                                                                                   
                                </td>
                            </tr>
                            <tr><td colspan="2"><font size="-2" color="000066">* Date Placed (Leave blank for all)</font></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    <td width="50%" valign="top">
                        
                        <cfform action="reports/bulk_host_family_label.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="2" bgcolor="##e2efc7">Host Family Labels</th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr>
                            	<td>Region:</td>
                                <td><cfselect name="regionID" query="get_regions" value="regionID" display="regionname" multiple="yes" size="8" queryPosition="below"></cfselect></td>
                            </tr>
                            <tr>
                                <td>Insurance Type:</td>
                                <td>
                                	<cfselect name="insurance_typeid" query="insurance_policies" value="insuTypeID" display="type" queryPosition="below">
                                        <option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>
                            <tr>
                                <td>Date Placed:</td>
                                <td>
                                    <span style="float:left">From: &nbsp;</span>
                                    <input type="text" name="date1" class="datePicker" maxlength="10">
                                    <span style="float:left;">To: &nbsp;</span>
                                    <input type="text" name="date2" class="datePicker" maxlength="10">                                                                                                                                   
                                </td>
                            </tr>
                            <tr><td colspan="2"><font size="-2" color="000066">* Date Placed (Leave blank for all)</font></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                </tr>
                <tr align="center">
                	<td width="50%" valign="top">
                        
                        <cfform action="reports/bulk_school_welc_letter.cfm" method="post" target="_blank">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">School Welcome Letters</th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr>
                                <td>Date Placed:</td>
                                <td>
                                    <span style="float:left">From: &nbsp;</span>
                                    <input type="text" name="date1" class="datePicker" maxlength="10">
                                    <span style="float:left;">To: &nbsp;</span>
                                    <input type="text" name="date2" class="datePicker" maxlength="10">                                                                                                                                   
                                </td>
                            </tr>
                               <tr>
                            	<td>Region:</td>
                                <td><cfselect name="regionID" query="get_regions" value="regionID" display="regionname" multiple="yes" size="8" queryPosition="below"></cfselect></td>
                            </tr>
                            <tr><td colspan="2"><font size="-2" color="000066">* Date Placed (Leave blank for all)</font></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    
                    <!----School Address Labels---->
                    <td width="50%" valign="top">
            
                        <cfform action="reports/labels_schools_address.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">School Labels</th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr>
                                <td>Date Placed:</td>
                                <td>
                                    <span style="float:left">From: &nbsp;</span>
                                    <input type="text" name="date1" class="datePicker" maxlength="10">
                                    <span style="float:left;">To: &nbsp;</span>
                                    <input type="text" name="date2" class="datePicker" maxlength="10">                                                                                                                                   
                                </td>
                            </tr>
                                 <tr>
                            	<td>Region:</td>
                                <td><cfselect name="regionID" query="get_regions" value="regionID" display="regionname" multiple="yes" size="8" queryPosition="below"></cfselect></td>
                            </tr>
                            <tr><td colspan="2"><font size="-2" color="000066">* Date Placed (Leave blank for all)</font></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                
                </tr>	
            </table>
            
            <br><br>
                
            <table class="nav_bar" cellpadding="6" cellspacing="0" align="center" width="95%">
                <tr><th colspan="2" bgcolor="##e2efc7">MAILING LABELS</th></tr>
                <tr align="center">
                	<td width="50%" valign="top">
                        
                        <cfform action="reports/labels_students.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">Students per period <br> <font size="-2">(Students in the USA - Approved placements only)</font></th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr>
                            	<td>Country:</td>
                                <td>
                                	<cfselect name="countryID" query="get_countries" value="countryID" display="countryname" queryPosition="below">
                                    	<option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>	
                            <tr>
                                <td>Date Received:</td>
                                <td>
                                    <span style="float:left">From: &nbsp;</span>
                                    <input type="text" name="date1" class="datePicker" maxlength="10">
                                    <span style="float:left;">To: &nbsp;</span>
                                    <input type="text" name="date2" class="datePicker" maxlength="10">                                                                                                                                   
                                </td>
                            </tr>
                            <tr><td colspan="2"><font size="-2" color="000066">* Application Received Date</font></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    <td width="50%" valign="top">
                        
                        <cfform action="reports/labels_students_id.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="2" bgcolor="##e2efc7">Students per ID <br> <font size="-2">(Students in the USA - Approved placements only)</font> </th></tr>
                            <tr>
                            	<td>Country:</td>
                                <td>
                                	<cfselect name="countryID" query="get_countries" value="countryID" display="countryname" queryPosition="below">
                                    	<option value="0"></option>
                                    </cfselect>
                                </td>
                            </tr>					
                            <tr>
                                <td>Student ID: </td>
                                <td>
                                	From: &nbsp; <input type="text" name="id1" size="4" maxlength="6">
                                    &nbsp;
                                	To: &nbsp; <input type="text" name="id2" size="4" maxlength="6">
                                </td>
                            </tr>
                            <tr><td colspan="2"><font size="-2" color="000066">* Student ID's</font></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                </tr>
                <tr align="center">
                	<td width="50%" valign="top">
                    
                        <cfform action="reports/labels_stu_per_region.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">Students in Care of Host Family per Region <br> <font size="-2">(Approved placements only)</font></th></tr>
                            <tr>
                                <td>Program:</td>
                                <td><cfselect name="programID" query="get_program" value="programID" display="programname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr>
                            	<td>Region:</td>
                                <td><cfselect name="regionid" query="get_regions" value="regionid" display="regionname" multiple="yes" size="8"></cfselect></td>
                            </tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    <td width="50%" valign="top">
						<!--- Empty Cell --->
                    </td>
                </tr>
                <tr align="center">
                	<td width="50%" valign="top">
                
                        <cfform action="reports/labels_rep_per_region.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">Representatives per Region</th></tr>
                            <tr>
                            	<td>Region:</td>
                                <td><cfselect name="regionID" query="get_regions" value="regionID" display="regionname" queryPosition="below"></cfselect></td>
                            </tr>
                            <tr><td colspan="3"><input type="checkbox" name="inactive">Include Inactive Reps.</input></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                    <td width="50%" valign="top">
                    
                        <!--- Int Rep Mailing Labels --->
                        <cfform action="reports/int_rep_mailing_labels.cfm" method="post">
                        <Table class="nav_bar" cellpadding="6" cellspacing="0" width="90%">
                            <tr><th colspan="3" bgcolor="##e2efc7">International Representatives</th></tr>
                            <tr align="left">
                                <td>Intl. Rep:</td>
                                <td>
                                	<cfselect name="intRep" query="get_intl_rep" value="userID" display="businessName" queryPosition="below">
                                    	<option value=0>All Reps</option>
                                    </cfselect>
                                </td>
                            </tr>								
                            <tr><td colspan="3"><input type="checkbox" name="inactive">Include Inactive Intl. Reps.</input></td></tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/preview.gif" align="center" border="0"></td></tr>
                        </table>
                        </cfform>
                        
                    </td>
                </tr>
            </table>
            
            <br><br>
                
    	</td>
    </tr>
</table>

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>
