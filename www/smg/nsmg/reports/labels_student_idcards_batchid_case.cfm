<!--- Generate Avery Standard 5371 id cars for our students. --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Form Variables --->
    <cfparam name="FORM.batchID" default="0">
    <cfparam name="FORM.intRep" default="0">
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
            s.active,
            s.ds2019_no, 
            s.hostid AS s_hostid, 
            s.regionassigned, 
            s.arearepid,
            u.businessname,
            p.programname, 
            p.programid, 
            c.companyname, 
            c.address AS c_address, 
            c.city AS c_city, 
            c.state AS c_state, 
            c.zip AS c_zip, 
            c.toll_free, 
            c.iap_auth,
            r.regionid, 
            r.regionname,
            h.familylastname AS h_lastname, 
            h.address AS h_address, 
            h.address2 AS h_address2, 
            h.city AS h_city,
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
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    
        AND 
            ( 
                <cfloop list="#FORM.batchid#" index="batchID">
                     s.sevis_batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#batchID#">
                     <cfif batchID NEQ ListLast(FORM.batchid)> OR </cfif>
                </cfloop> 
            )
    
        <cfif VAL(FORM.intrep)>
            AND 
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
        </cfif>
    
        <cfif VAL(FORM.insurance_typeid)>
            AND 
                u.insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.insurance_typeid#">
        </cfif>
    
        ORDER BY 
            u.businessname, 
            s.firstname,
            s.familyLastName       
    </cfquery>
    
</cfsilent>

<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.4in 0.4in 0.46in;
		/* margin:'0.3in' '0.3in' '0.46in' '0.3in'; */

	}
	
	div.Section1 {		
		page:Section1;
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
                userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.arearepid#">
            AND 
                usertype 
                    BETWEEN 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="5"> 
                    AND 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="7"> 		
        </cfquery>			
                    
		<cfif pagebreak EQ 0>				
			<!--- Start a table for our labels --->
            <table align="center" width="670px" cellspacing="2" cellpadding="0"> <!--- border="0" ---->
		</cfif>
        
		  <!--- If this is the first column, then start a new row --->
		<cfif col EQ "0">
            <tr>
		</cfif>	
        			
			<!--- Output label --->			
			<td class="label" valign="top">
					
				<!--- HEADER --->
                <table border="0" width="100%">
                    <tr>
                        <td align="center"> <!--- width="25%" --->
                            <img src="../pics/logos/#client.companyid#_small.gif" border="0">
                        </td>
                        <td align="center"> <!--- width="75%" --->
                            <p class="style4">#companyname#</p>
                            <p class="style1">#c_address#</p>
                            <p class="style1">#c_city#, #c_state# &nbsp; #c_zip#</p>
                            <p class="style1">Toll Free: #toll_free#</p>
                            <p class="style5">&nbsp;</p>
                            <p class="style3">STUDENT: <b>#Firstname# #familylastname#</b></p>
                            <p class="style2">DS-2019: #ds2019_no# &nbsp; &nbsp; ID: ###studentid#</p>
                        </td>
                    </tr>
                </table>
                
                <div class="fullCol">
                
					<!--- Left Column --->
                    <div class="leftCol">
                        <cfif VAL(qGetStudents.s_hostid)>
                            <p class="style2">Hosts: The #h_lastname# Family &nbsp;</p>
                            <p class="style2"><cfif h_address is ''>#h_address2#<cfelse>#h_address#</cfif> &nbsp;</p>
                            <p class="style2">#h_city#, #h_state# &nbsp; #h_zip# &nbsp;</p>
                            <p class="style2">#h_phone# &nbsp;</p>
                        <cfelse>						
                            <p class="style2">&nbsp;</p>
                            <p class="style2">&nbsp;</p>	
                            <p class="style2">&nbsp;</p>						
                            <p class="style2">&nbsp;</p>																
                        </cfif>
                    </div>
                    
                    <!--- Right Column --->
                    <div class="rightCol">
                        <!--- check if there's an region assigned --->
                        <cfif VAL(qGetStudents.regionassigned)>
                            <p class="style2">
                                Regional Contact: #qRegionalManager.firstname# #qRegionalManager.lastname# &nbsp;
                            </p>
                            <p class="style2">
                                <cfif LEN(qRegionalManager.businessphone)>
                                    Toll Free: #qRegionalManager.businessphone#
                                <cfelse>
                                    Toll Free: #qRegionalManager.phone#
                                </cfif> &nbsp; 
                            </p>
                        <cfelse>
                            <p class="style2">&nbsp;</p>
                            <p class="style2">&nbsp;</p>
                        </cfif>
                        
                        <p class="style5">&nbsp;</p>
                        
                        <!--- check if there's an area rep --->
                        <cfif VAL(qGetStudents.arearepid)> 
                            <p class="style2">
                                Local Contact: #qLocalContact.firstname# #qLocalContact.lastname# &nbsp;
                            </p>			
                            <p class="style2">
                                Phone: 
                                <cfif LEN(qLocalContact.businessphone)>
                                    #qLocalContact.businessphone#
                                <cfelse>
                                    #qLocalContact.phone#
                                </cfif> 
                                &nbsp;
                            </p>
                        <cfelse>
                            <p class="style2">&nbsp;</p>
                            <p class="style2">&nbsp;</p>
                        </cfif>
                    </div>
            	
                </div>    
                
                
                <!--- DoS Information --->
                <div class="fullCol">
                
					<!--- Left Column --->
                    <div class="leftCol">
                        <p class="style2">U.S. Department of State</p>
                        <p class="style2">2200 C St. NW</p>
                        <p class="style2">Washington, D.C. 20037</p>
                    </div>
                    
                    <!--- Right Column --->
                    <div class="rightCol">
                        <p class="style2">&nbsp;</p>
                        <p class="style2">Phone: 1-866-283-9090</p>
                        <p class="style2">Email: jvisas@state.gov</p>
                    </div>
            	
                </div>    

		  	</td>
            
			<cfset col=col+1>						
			
			<!---If it's column 2, then end the row and reset the column number.--->
			<cfif col EQ 2>
                </tr>
				<cfset col=0>			
			</cfif>
					
			<cfset pagebreak=pagebreak+1>
			
			<cfif pagebreak EQ 10> <!--- close table and add a page break --->
				</table>
				<cfset pagebreak=0>
				<div style="page-break-before:always;"></div>					
			</cfif>	
            
	</cfloop>
		
	<!---If we didn't end on column 2, then we have to output blank labels --->
    <cfif col EQ 1>
            <td class="label">
                <p>&nbsp;</p>
            </td>
        </tr>		
    </cfif>
    
    </table>

</div>

</cfoutput>
