<!--- Generate Avery Standard 5371 id cars for our students. --->

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
        	s.studentid, s.familylastname, s.firstname, s.dateapplication, 
            s.active, s.ds2019_no, s.hostid AS s_hostid, s.regionassigned, s.arearepid,
            p.programname, p.programid,
            u.businessname, 
            c.companyname, c.address AS c_address, c.city AS c_city, c.state AS c_state, c.zip AS c_zip, c.toll_free, c.iap_auth, c.emergencyPhone, c.companyid, c.url_ref,
            r.regionid, r.regionname,
            h.familylastname AS h_lastname, h.address AS h_address, h.address2 AS h_address2, h.city AS h_city,
            h.state AS h_state, h.zip AS h_zip, h.phone AS h_phone				
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
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
      <Cfif url.
        AND 
        	( 
            	<cfloop list="#FORM.programid#" index="prog"> 
                	s.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#prog#">
            		<cfif ListLast(FORM.programid) NEQ prog> OR </cfif>
              	</cfloop> 
            )
        
        <cfif IsDate(FORM.date1) AND IsDate(FORM.date2)>
            AND 
                (
                    s.dateapplication 
                    BETWEEN 
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(FORM.date1)#">
                    AND 
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(DateAdd('d', 1, FORM.date2))#">
                ) 
		</cfif>
        
        <cfif VAL(FORM.intrep)>
        	AND 
            	s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
        </cfif>
        
        <cfif FORM.insurance_typeid NEQ 0>
            AND 
            	u.insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.insurance_typeid#">
        </cfif>	
        		
        ORDER BY
            u.businessname, 
            s.firstname,
            s.familyLastName,
            s.studentID   
           
    </cfquery>
    
</cfsilent>
            
<Cfoutput>
#qGetStudents.recordcount#
</Cfoutput>
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
                phone
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
                phone
            FROM 	
                smg_users
            WHERE	
                userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudents.arearepid)#">
            AND 
                usertype 
                    BETWEEN 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="5"> 
                    AND 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="7"> 		
        </cfquery>			
                    
                    
            
            <link rel="stylesheet" href="../linked/css/student_profile.css" type="text/css">
     
    <!--- Header --->
    <table align="center" class="profileTable">
        <tr>
             <td class="titleRight">
                <img src="../pics/logos/#companyid#.gif" align="right" width="122px" height="122px"> <!--- Image is 144x144 --->
            </td>
            <td class="titleCenter">
            	
                <h1>#companyname#</h1>      
                <table width=100%>
                	<Tr>
                    	<Td valign="top">          
            			  <h3>Emergency Phone:  #emergencyPhone#</h3>
              			</Td>
                        <td valign="top">
                              #c_address#<br />
                              #c_city# #c_state#, #c_zip#<Br />
                              #toll_free#<br />
              			</td>
                   </Tr>
            	</table>
              
              
            </td>
          
        </tr>	
    </table>
    
    
    <!--- Student Information --->
    <table  align="center" class="profileTable" border=0>
        <tr>
            <td valign="top" width="140px" align="Center">
                <div align="center">
                    <cfif studentPicture.recordcount>
                      <img src="../uploadedfiles/web-students/#studentPicture.name#" height="135" align="Center"/>
                      <cfelse>
                        <img src="../pics/no_stupicture.jpg" width="135">
                  </cfif>
                    <br />
              </div>
            </td>
            <td valign="top" width="600">
                <span class="profileTitleSection">STUDENT IDENTIFICATION</span>
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr>
                        <td valign="top" width="330px">
                        
                            <table cellpadding="2" cellspacing="2" border="0">
                                <tr>
                                    <td><span class="title">Name</span></td>
                                    <td><b>#Firstname# #familylastname#</b></td>
                                </tr>	
                                <tr>
                                    <td><span class="title">ID</span></td>
                                    <td>###studentid#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">DS-2019</span></td>
                                    <td>#ds2019_no#</td>
                                </tr>
                                                                      
                            </table>
                            
                        </td>
                        <td valign="top" width="330px">
                        
                            <table cellpadding="2" cellspacing="2" border="0">
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
                                    <td><span class="title">Phone</span></td>
                                    <td>#h_phone#</td>
                                </tr>
                            </table>
                            
                        </td>
                    </tr>                        
                </table>
            
            </td>
        </tr>                
    </table>
     <table  align="center" class="profileTable">
        <tr>
      <td valign="top" width="600">
              
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr>
                        <td valign="top" width="50%">
                          <span class="profileTitleSection">Local Contact</span>
                            <table cellpadding="2" cellspacing="2" border="0">
                                <tr>
                                    <td><span class="title">Regional Contact</span></td>
                                    <td>#qRegionalManager.firstname# #qRegionalManager.lastname#&nbsp;
                          </td>
                                </tr>	
                                <tr>
                                    <td><span class="title">Regional Phone</span></td>
                                    <td><cfif LEN(qRegionalManager.businessphone)>
                                         #qRegionalManager.businessphone#
                                        <cfelse>
                                          #qRegionalManager.phone#
                                        </cfif>
                                	</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Local Contact</span></td>
                                    <td>#qLocalContact.firstname# #qLocalContact.lastname#</td>
                                </tr>
                                 <tr>
                                    <td><span class="title">Local Phone</span></td>
                                    <td>
										<cfif LEN(qLocalContact.businessphone)>
                                   			 #qLocalContact.businessphone#
                                		<cfelse>
                                   			 #qLocalContact.phone#
                                        </cfif>
                                  	</td>
                                </tr>                                     
                            </table>
                           
                      </td>
                       <td valign="top" width="50%">
                        	  <span class="profileTitleSection">INSURANCE</span>
                              <cfquery name="insurance" datasource="#application.dsn#">
                              select u.insurance_typeid, i.type, ic.policycode
                              from smg_users u
                              left join smg_insurance_codes ic on ic.insu_codeid = u.insurance_typeid
                              left join smg_students on smg_students.intrep = u.userid 
                              left join smg_insurance_type i on i.insutypeid = u.insurance_typeid
                              
                              where smg_students.studentid = #studentid#
                              </cfquery>
                              <cfquery name="insuranceDetails" datasource="#application.dsn#">
                              select policy_code
                              from smg_insurance
                              where studentid = #studentID# 
                              </cfquery>
                              
                            <table cellpadding="2" cellspacing="2" border="0">
                             	<tr>
                                    <td><span class="title">Company</span></td><td>Global Secutive</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Policy</span></td><td>#insurance.type#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Code</span></td><td>#insurance.policycode#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Phone</span></td> <td>1-888-888-8888</td>
                       		  </tr>
                                <tr>
                                    <td></td>
                                </tr>
                            </table>
                            
                      </td>
                       
                        
                    </tr> 
                    <Tr>
                    	 <td valign="top" width="100%" colspan=2>
                        	  <span class="profileTitleSection">DEPARTMENT OF STATE</span>
                            <table cellpadding="2" cellspacing="2" border="0">
                                <tr>
                                    <td>U.S. Department of State</td>
                               		<td>&middot;</td>
                                    <td>2200 C St. NW</td>
                              		 <td>&middot;</td>
                                    <td>Washington, D.C. 20037</td>
                            		 <td>&middot;</td>
                                    <td>1-866-283-9090</td>
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
     <!--- Siblings 
     <Cfquery name="sibling" datasource="#application.dsn#">
     select *
     from smg_student_siblings
     where studentid = #qGetStudentInfo.studentID#
     </cfquery>
    <table align="center" class="profileTable">
        <tr><td colspan="3"><span class="profileTitleSection">REPRESENTATIVE / DOS INFO</span></td></tr>     
        <tr>
            <td width="250px"><span class="title">Name</span></td>
            <td width="200px"><span class="title">Age</span></td>
            <td width="200px"><span class="title">Relation </span></td>
        </tr>
       <cfloop query="sibling">
        <tr>
            <td>
               #name#
            <td>
             	#DateDiff('yyyy', birthdate, now())#
            </td>
            <td>
       			<cfif sex is 'male'>Brother<cfelse>Sister</cfif>
            </td>
        </tr>
       </cfloop>
    </table>
    
    <!--- Academic and Language Evaluation --->
    <table align="center" class="profileTable">
        <tr><td colspan="3"><span class="profileTitleSection">ACADEMIC AND LANGUAGE EVALUATION</span></td></tr>     
        <tr>
            <td width="250px"><span class="title">Band:</span> <cfif qGetStudentInfo.band is ''><cfelse>#qGetStudentInfo.band#</cfif></td>
            <td width="200px"><span class="title">Orchestra:</span> <cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.orchestra#</cfif></td>
            <td width="200px"><span class="title">Est. GPA: </span> <cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.estgpa#</cfif></td>
        </tr>
        <tr>
            <td>
                <cfif qGetStudentInfo.grades EQ 12>
                     <span class="title">Must be placed in:</span> #qGetStudentInfo.grades#th grade
                <cfelse>				
                     <span class="title">Last Grade Completed:</span>
                    <cfif NOT VAL(qGetStudentInfo.grades)>
                        n/a
                    <cfelse>
                        #qGetStudentInfo.grades#th grade
                    </cfif>
                </cfif>
            </td>
            <td>
                <span class="title">Years of English:</span>
                <cfif NOT VAL(qGetStudentInfo.yearsenglish)>
                    n/a
                <cfelse>
                    #qGetStudentInfo.yearsenglish#
                </cfif>
            </td>
            <td>
                <span class="title">Convalidation needed:</span>
                <cfif NOT LEN(qGetStudentInfo.convalidation_needed)>
                    no
                <cfelse>
                    #qGetStudentInfo.convalidation_needed#
                </cfif>
            </td>
        </tr>
    </table>
    
 
    </table>     --->     
                    
    </cfloop>
</div>

</cfoutput>
