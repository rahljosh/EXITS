<cfquery name="agentInfo" datasource="mysql">
    SELECT s.studentid, s.firstname, s.familylastname, s.host_fam_approved, u.businessname, u.email, h.familylastname
    FROM smg_students s
    left join smg_users u on u.userid = s.intrep
    left join smg_hosts h on h.hostid = s.hostid 
    where (s.programid = 318 or s.programid = 320 or s.programid = 319 or s.programid = 321)
    AND s.hostid != 0 
    AND s.host_fam_approved < 5 
    AND (s.companyid = 1 or s.companyid = 2 or s.companyid = 3 or s.companyid = 4 or s.companyid = 12)

	order by studentid

</cfquery>
<Cfloop query="agentInfo">
<Cfset client.studentid = #studentid#>
<Cfset url.studentid = #studentid#>
<cfdocument filename="#AppPath.temp#idcard_#client.studentid#.pdf" format="PDF" backgroundvisible="yes" overwrite="yes" fontembed="yes" localurl="no">
			<style type="text/css">
            <!--
        	<cfinclude template="../smg.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <cfset form.pdf = 1>
  
  <!----Start of Include------>
  
  
  
  
  
  
  
  
  
  
  
  <!--- Generate Avery Standard 5371 id cars for our students. --->
<Cfif len(url.studentid) gt 10>
	<cfquery name="stuid" datasource="mysql">
    	select studentid
        from smg_students
        where uniqueid = '#url.studentid#'
    </Cfquery>
    <Cfset url.studentid = #stuid.studentid#>
    
</Cfif>

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Form Variables --->
    <cfparam name="FORM.date1" default="">
    <cfparam name="FORM.date2" default="">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.insurance_typeID" default="0">

    <cfscript>
		// Set variables 
		col = 0;
		pageBreak = 0;
	</cfscript>

	<!--- Get names, addresses from our database --->
    <cfquery name="qGetStudents" datasource="MySql"> 
        SELECT 	
        	s.studentid, 
            s.familylastname, 
            s.firstname, 
            s.dateapplication, 
            s.programid, 
            s.regionassigned, 
            s.regionalguarantee,
            s.active, 
            s.ds2019_no, 
            s.hostid AS s_hostid, 
            s.regionassigned, 
            s.arearepid,
            p.programname, 
            p.programid,
            p.seasonID,
            u.businessname, 
            u.insurance_typeID,
            c.companyname, 
            c.address AS c_address, 
            c.city AS c_city, 
            c.state AS c_state, 
            c.zip AS c_zip, 
            c.toll_free as c_tollfree, 
            c.phone as c_phone, 
            c.iap_auth, c.emergencyPhone, 
            c.companyid, 
            c.url_ref,
            r.regionid, 
            r.regionname,
            h.familylastname AS h_lastname, 
            h.address AS h_address, 
            h.address2 AS h_address2, 
            h.city AS h_city,
            h.mother_cell, 
            h.father_cell,
            h.state AS h_state, 
            h.zip AS h_zip, 
            h.phone AS h_phone				
        FROM
        	smg_students s 
        INNER JOIN 
        	smg_users u ON s.intrep = u.userid
        INNER JOIN 
        	smg_programs p ON s.programid = p.programid
        INNER JOIN
        	smg_companies c ON s.companyid = c.companyid
        LEFT OUTER JOIN 
        	smg_regions r ON s.regionassigned = r.regionid
        LEFT OUTER JOIN
        	smg_hosts h ON s.hostid = h.hostid			
        WHERE 
        	 
        
            	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
     
      
        ORDER BY
            u.businessname, 
            s.firstname,
            s.familyLastName,
            s.studentID   
    </cfquery>

	<cfscript>	
        qGetProgram = APPCFC.PROGRAM.getPrograms(programID=qGetStudents.programid);      
        qGetRegion = APPCFC.REGION.getRegions(regionID=qGetStudents.regionassigned);
        qGetRegionGuaranteed = APPCFC.REGION.getRegions(regionID=qGetStudents.regionalguarantee);
    </cfscript>

</cfsilent>

<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.4in 0.4in 0.46in;
		/* margin:'0.3in' '0.3in' '0.46in' '0.3in'; */

	}
	
	div.Section1 {		
		page:Section1;
		font-family:"Arial";
	}

	div.fullCol {
		width:100%;
		clear:both;
		padding:0px;
		display:block;
	}

	div.leftCol {
		width:45%;
		float:left;
		padding:0px;
	}
	
	div.rightCol {
		width:55%;
		float:right;
		padding:0px;
	}

	td.label {
		width:255.0pt; /* width:254.0pt; */
		height:142.0pt;
	}
	
	p {
		margin:0px, 5.3pt, 0px, 5.3pt; 
		mso-pagination:widow-orphan;
		font-size:10.0pt;
		font-family:"Arial";
	}
	h1 {padding:0;}
	.style1 {font-size: 6pt;}  /* company address */
	.style2 {font-size: 7pt;}  /* host + rep info */
	.style3 {font-size: 8pt;}  /* student's name */
	.style4 {font-size: 10pt; font-weight:bold; padding-top:5px; } /* company name */
	.style5 {font-size: 5pt;} 
</style>
							
<!--- Height = 5cm = 142 pixels = 1.96in / Width = 9cm = 255 pixels = 3.54in --->
					
<!---
	The table consists has two columns, two labels.
	To identify where to place each, we need to maintain a column counter.	
--->

<cfoutput>

<div class="Section1">
	
    <cfloop query="qGetStudents">
    	
		<!----Student Picture---->
		<cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#studentID#.*">
        
		<!--- get regional manager --->
        <cfquery name="qRegionalManager" datasource="MySQL">
            SELECT 	
                firstname, 
                lastname, 
                businessphone, 
                phone,
                cell_phone
            FROM 	
                smg_users
            INNER JOIN 
                user_access_rights uar ON uar.userid = smg_users.userid
            WHERE	
                uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
            AND 
                uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.regionassigned#">
        </cfquery>

        <!--- get rep who will follow the student --->
        <cfquery name="qLocalContact" datasource="MySQL">
            SELECT 	
                firstname, 
                lastname, 
                businessphone,
                phone,
                cell_phone
            FROM 	
                smg_users
            WHERE	
                userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudents.arearepid)#">
        </cfquery>			

        <cfquery name="qGetInsuranceInfo" datasource="MySQL">
            SELECT 
                it.type, 
                ic.policycode
            FROM 
                smg_insurance_type it
            INNER JOIN
                smg_insurance_codes ic ON ic.insuTypeID =  it.insuTypeID
                    AND
                        ic.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                    AND	
                        ic.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudents.seasonID)#"> 
                    AND
                        ic.insuTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudents.insurance_typeID)#">                           
        </cfquery>

        <link rel="stylesheet" href="../linked/css/student_profile.css" type="text/css">
        
        <!--- Header --->
        <table align="center" class="profileTable" width="750" border="0">
            <tr>
                <td class="titleRight">
                    <img src="../pics/logos/#companyid#.gif" align="right" width="110px" height="110px"> <!--- Image is 144x144 --->
                </td>
                <td class="titleCenter" valign="center">
                    <h1>#companyname#</h1>      
                    
                    <table width=100% border=0>
                        <Tr>
                            <td width=100></td>
                            <td valign="top">
                                #c_address#<br />
                                #c_city# #c_state#<br />
                                #c_zip#<Br />
                            </td>
                            <Td valign="top">
                                Local Number: #c_phone#<br />
                                Toll Free: #c_tollfree#<br />          
                                Emergency Phone:  #emergencyPhone#</h3>
                            </Td>
                        </Tr>
                    </table>
                    
                </td>
            </tr>	
        </table>
        
        <!--- Student Information --->
        <table  align="center" class="profileTable" width="750" border="0">
            <tr>
                <td valign="top" width="140px" align="Center">
                    <div align="center">
						<cfif studentPicture.recordcount>
                            <img src="../uploadedfiles/web-students/#studentPicture.name#" height="155" align="Center"/>
                        <cfelse>
                            <img src="../pics/no_stupicture.jpg" width="135">
                        </cfif>
                        <br />
                    </div>
                </td>
                <td valign="top">
                    <span class="profileTitleSection">STUDENT IDENTIFICATION</span>
                    
                    <table cellpadding="2" cellspacing="2" border="0" width=100%>
                        <tr>
                            <td valign="top" width="330">
                                <table cellpadding="2" cellspacing="2" border="0" width=100%>
                                    <tr>
                                        <td><span class="title">Name</span></td>
                                        <td><b>#Firstname# #familylastname#</b></td>
                                    </tr>	
                                    <tr>
                                        <td><span class="title">ID</span></td>
                                        <td>###studentid#</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">#CLIENT.DSFormName#</span></td>
                                        <td>#ds2019_no#</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Program</span></td>
                                        <td>#qGetProgram.programname#</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Region</span></td>
                                        <td>#qGetRegion.regionname# #qGetRegionGuaranteed.regionname# </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" width="330">
        
                                <table cellpadding="2" cellspacing="2" border="0" width=100%>
                                    <tr>
                                        <td><span class="title">Hosts</span></td>
                                        <td>The #h_lastname# Family</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Address</span></td>
                                        <td>#h_address# #h_address2#</td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">City State, Zip</span></td>
                                        <td>#h_city# #h_state#, &nbsp; #h_zip# </td>
                                    </tr>
                                    <tr>
                                        <td valign="top"><span class="title">Phone</span></td>
                                        <td>#h_phone#</td>
                                    </tr>
                                    <tr>
                                        <td><em><span class="title"><font size=-1>Alt. Phones</font></span></em></td>
                                        <td>
                                        	<em><font size=-1>
												<cfif mother_cell is '' and father_cell is ''>
                                                    No alt. phone numbers on file.
                                                <cfelse>
                                                    #mother_cell#
                                                    <cfif mother_cell is not ''>;</cfif>
                                                    #father_cell#
                                                </cfif>
                                            </font></em>
                                        </td>
                                    </tr>
                                </table>
                           
                            </td>
                        </tr>                        
                    </table>
        
                </td>
            </tr>                
        </table>
        
        <table align="center" class="profileTable" width=750>
            <tr>
                <td valign="top" colspan=10 >
        
                    <table cellpadding="2" cellspacing="2" border="0" width=100%>
                        <tr>
                            <td valign="top" width="50%">
                                <span class="profileTitleSection">Regional Contact</span>
                                
                                <table cellpadding="2" cellspacing="2" border="0">
                                    <tr>
                                        <td><span class="title">Regional Contact</span></td>
                                        <td>#qRegionalManager.firstname# #qRegionalManager.lastname#&nbsp;</td>
	                                </tr>	
	                                <tr>
                                        <td><span class="title">Primary Phone</span></td>
                                        <td>
                                            <cfif LEN(qRegionalManager.businessphone)>
                                                #qLocalContact.firstname##qRegionalManager.businessphone#
                                            <cfelse>
                                                #qRegionalManager.phone#
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Cell Phone</span></td>
                                        <td> #qRegionalManager.cell_phone#</td>
                                    </tr>
                                </table>
        
                            </td>
        					<td valign="top" width="50%">
                                <span class="profileTitleSection">LOCAL CONTACT</span>
        
                                <table cellpadding="2" cellspacing="2" border="0">
                                    <tr>
                                        <td><span class="title">Local Contact</span></td>
                                        <td>
											<cfif qLocalContact.recordCount>
                                                #qLocalContact.firstname# #qLocalContact.lastname#
                                            <cfelse>
                                                <span class="title"><em>Information not available</em></span>
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="title">Primary Phone</span></td>
                                        <td>
											<cfif LEN(qLocalContact.businessphone)>
                                                #qLocalContact.businessphone#
                                            <cfelse>
                                                #qLocalContact.phone#
                                            </cfif>
                                        </td>
                                    </tr>     
                                    <tr>
                                        <td><span class="title">Cell Phone</span></td>
                                        <td>#qLocalContact.cell_phone#</td>
                                    </tr>       
                                </table>
        
                            </td>
                        </tr> 
                        <Tr>
                            <td valign="top" width="100%" colspan="2">
                            	<span class="profileTitleSection">INSURANCE</span>
                                
                                <table cellpadding="2" cellspacing="2" border="0" width="100%">
                                    <tr>
                                        <!---
                                        <td>Global Secutive</td>
                                        <td>&middot;</td>
										--->
                                        <td>#qGetInsuranceInfo.type#</td>
                                        <td>&middot;</td>
                                        <td>Policy: #qGetInsuranceInfo.policycode#</td>
                                        <td>&middot;</td>
                                        <td>1-800-251-1712</td>
                                        <td>&middot;</td>
                                        <td>www.esecutive.com/MyInsurance</td>
                                    </tr>
                                </table>
            
                            </td>
                        </Tr>     
                        <Tr>
                            <td valign="top" width="100%" colspan=2>
                                <span class="profileTitleSection">DEPARTMENT OF STATE</span>
                            
                                <table cellpadding="2" cellspacing="2" border="0">
                                    <tr>
                                        <td >U.S. Department of State</td>
                                        <td>&middot;</td>
                                        <td>2200 C St. NW</td>
                                        <td>&middot;</td>
                                        <td>Washington, D.C. 20037</td>
                                        <td>&middot;</td>
                                        <td>1-866-283-9090<br />
                                        1-202-203-5096</td>
                                        <td>&middot;</td>
                                        <td>jvisas@state.gov</td>
                                    </tr>
                                </table>
            
                            </td>
                        </Tr>                       
                	</table> 
                    
				</td>
			</tr>
		</table>            	                                    
        
        <br />
                    
    </cfloop>
    
</div>

</cfoutput>

  
  
  
  
  
  
  
  
  <!-------->
</cfdocument>
     <cfsavecontent variable="email_message">
        <cfoutput>				
            <p>An ID card for #firstname# #familylastname# (#studentid#) is attached.  #firstname#  will need this ID card when they come to the United States. Please make sure they have a hard copy of this ID with them along with their passport and visa  upon departure.   </p>
            <p>See the attached file for the ID card.</p>
           
            <p>
            Regards-<br />
            ISE Support
            </p>
            <p>
        	
            </p>
        </cfoutput>
        </cfsavecontent>
     

	<cfset emails = '#email#'>

  <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#email#">
             
            <cfinvokeargument name="email_replyto" value="""ISE"" <support@iseusa.org>">
            <cfinvokeargument name="email_subject" value="ID Card for #firstname# #familylastname# ( #studentid# )">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_file" value="#AppPath.temp#idcard_#client.studentid#.pdf">
        </cfinvoke>	
        <Cfoutput>
       #agentInfo.currentrow# ID Card for #studentid# #firstname# #familylastname# was succesfully sent to #email#<br>
       <cfflush>
       </Cfoutput>
  </Cfloop>