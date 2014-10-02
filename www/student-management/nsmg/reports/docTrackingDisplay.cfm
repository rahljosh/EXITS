  <cfloop query="qGetRepsInRegion">

            <cfquery name="qGetStudentsByRep" dbtype="query">
                SELECT 	
                	*
                FROM 
                	qGetAllStudentsInRegion
                WHERE 
                	#tableField# = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRepsInRegion.userID#">
				ORDER BY
                	firstName,
                    familyLastName                    
            </cfquery> 
		
			<cfif qGetStudentsByRep.recordcount> 

                <table width="100%" cellpadding="4" cellspacing="0" align="center" frame="below">
                    <tr bgcolor="##CCCCCC">
                        <td width="85%" align="left">
							<cfif LEN(qGetRepsInRegion.repName)>
                                <strong>#qGetRepsInRegion.repName# (###qGetRepsInRegion.userID#)</strong>
                            <cfelse>
                                <font color="red">Missing or Unknown</font>
                            </cfif>
                        </td>
                        <td width="15%" align="center">#qGetStudentsByRep.recordcount#</td>
                    </tr>
                </table>
                                    
                <table width="100%" frame=below cellpadding="4" cellspacing="0" align="center" frame="border">
                    <tr>
                        <td width="4%"><strong>ID</strong></td>
                        <td width="18%"><strong>Student</strong></td>
                        <td width="8%"><strong>Placement</strong></td>
                        <td width="70%"><strong>Missing Documents</strong></td>
                    </tr>	
                    <cfloop query="qGetStudentsByRep">		
                    
                    <cfquery name="get_host_info" datasource="MySQL">
                        SELECT  h.hostid, h.motherfirstname, h.fatherfirstname, h.familylastname as hostlastname, h.hostid as hostfamid
                        FROM smg_hosts h
                        WHERE hostid = #hostid#
                    </cfquery>
	 				  <!---number kids at home---->
                        <cfquery name="kidsAtHome" datasource="#application.dsn#">
                        select count(childid) as kidcount
                        from smg_host_children
                        where liveathome = 'yes' and hostid =#get_host_info.hostid#
                        AND isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        </cfquery>
						
						<Cfset father=0>
                        <cfset mother=0>
                      
                        <Cfif get_host_info.fatherfirstname is not ''>
                            <cfset father = 1>
                        </Cfif>
                        <Cfif get_host_info.motherfirstname is not ''>
                            <cfset mother = 1>
                        </Cfif>
                        <cfset client.totalfam = #mother# + #father# + #kidsAtHome.kidcount#>
                        
                        <tr bgcolor="###iif(qGetStudentsByRep.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
                            <td>#qGetStudentsByRep.studentID#</td>
                            <td>#qGetStudentsByRep.firstname# #qGetStudentsByRep.familylastname#</td>
                            <td>#DateFormat(qGetStudentsByRep.datePlaced, 'mm/dd/yyyy')#</td>
                            <td align="left">
                                <i>
                                    <font size="-2">
                                        <cfif NOT isDate(qGetStudentsByRep.doc_host_app_page1_date)>Host Family Application p.1 &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.doc_host_app_page2_date)>Host Family Application p.2 &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.doc_letter_rec_date)>Host Family Letter p.3 &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.doc_rules_rec_date)>HF Rules &nbsp; &nbsp;</cfif>
										<cfif NOT isDate(qGetStudentsByRep.doc_rules_sign_date)>HF Rules Date Signed &nbsp; &nbsp;</cfif>
										<cfif NOT isDate(qGetStudentsByRep.doc_photos_rec_date)>HF Photos &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.doc_school_accept_date)>School Acceptance &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.doc_school_profile_rec)>School & Community Profile &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.doc_conf_host_rec)>Visit Form &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.doc_date_of_visit)>Date of Visit &nbsp; &nbsp; </cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.doc_ref_form_1)>Ref. 1 &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.doc_ref_form_2)>Ref. 2 &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.stu_arrival_orientation)>Student Orientation &nbsp; &nbsp;</cfif>
                                        <cfif NOT isDate(qGetStudentsByRep.host_arrival_orientation)>HF Orientation &nbsp; &nbsp;</cfif>
<!---                                        <cfif NOT isDate(qGetStudentsByRep.doc_class_schedule)>Class Schedule &nbsp; &nbsp;</cfif> --->
                                        <cfif seasonid gt 8>
											<cfif NOT isDate(qGetStudentsByRep.doc_income_ver_date)>Income Verification &nbsp; &nbsp;</cfif>
                                            <cfif NOT isDate(qGetStudentsByRep.doc_conf_host_rec2)> 2nd Conf. Host Visit &nbsp; &nbsp;</cfif>
                                        </cfif>
                                        <cfif client.totalfam eq 1>
											<cfif NOT isDate(qGetStudentsByRep.doc_single_ref_check1)>Ref Check (Single) &nbsp; &nbsp;</cfif>
                                            <cfif NOT isDate(qGetStudentsByRep.doc_single_ref_check2)>2nd Ref Check (Single) &nbsp; &nbsp;</cfif>
                                        </cfif>
                                    </font>
                                </i>
                            </td>		
                        </tr>								
                    </cfloop>	
                </table>

                <br />				
                
            </cfif>  <!--- qGetStudentsByRep.recordcount ---> 
	
		</cfloop> <!--- cfloop query="qGetRepsInRegion" --->
	
	<cfelse> <!---  qGetAllStudentsInRegion.recordcount --->
        
        <table width="100%" cellpadding="4" cellspacing="0" align="center">
        	<tr><td>There are no students missing documents.</td></tr>
        </table>