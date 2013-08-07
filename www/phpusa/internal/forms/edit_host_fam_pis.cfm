<!--- ------------------------------------------------------------------------- ----
	
	File:		edit_host_fam_pis.cfm
	Author:		Marcus Melo
	Date:		August 2, 2012
	Desc:		Host Family Information
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="">

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.hostID" default="0">
    <cfparam name="FORM.familyLastName" default="">
    <cfparam name="FORM.fatherLastName" default="null" >
    <cfparam name="FORM.fatherMiddleName" default="">
    <cfparam name="FORM.fatherFirstName" default="null">
    <cfparam name="FORM.fatherdob" default="">
    <cfparam name="FORM.fatherWorkType" default="">
    <cfparam name="FORM.father_cell" default="">
    <cfparam name="FORM.fatherSSN" default="">
    <cfparam name="FORM.fatherIsNoSSN" default="0">
    <cfparam name="FORM.motherLastName" default="">
    <cfparam name="FORM.motherMiddleName" default="">
    <cfparam name="FORM.motherFirstName" default="">
    <cfparam name="FORM.motherdob" default="">
    <cfparam name="FORM.motherWorkType" default="">
    <cfparam name="FORM.mother_cell" default="">
    <cfparam name="FORM.motherSSN" default="">
    <cfparam name="FORM.motherIsNoSSN" default="0">
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.emergency_contact_name" default="">
    <cfparam name="FORM.emergency_phone" default="">
    <cfparam name="FORM.fatherrunCBC" default="0">
    <cfparam name="FORM.motherrunCBC" default="0">

	<cfscript>
    	if ( VAL(URL.hostID) ) {
			FORM.hostID = URL.hostID;			
		}
		
		if ( VAL(CLIENT.hostID) ) {
			FORM.hostID = CLIENT.hostID;			
		}
	
		// Get Host Family Info
		qGetHostFamilyInfo = APPLICATION.CFC.HOST.getHosts(hostID=VAL(FORM.hostID));
		
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
	// Gets Host Father CBC
			qGetCBCFather = APPCFC.CBC.getCBCHostByID(
				hostID=FORM.hostID, 
				cbcType='father'
			);
    // Gets Host Mother CBC
			qGetCBCMother = APPCFC.CBC.getCBCHostByID(
				hostID=FORM.hostID, 
				cbcType='mother'
			);
    </cfscript>
	
	<!--- FORM Submitted --->
    <cfif FORM.submitted>
	
		<!------------------------------------------------------
			ADDRESS CHANGE - SEND EMAIL NOTIFICATION 
		------------------------------------------------------->

		<cfif qGetHostFamilyInfo.recordCount
			AND
			(
				FORM.address NEQ qGetHostFamilyInfo.address
			OR
				FORM.address2 NEQ qGetHostFamilyInfo.address2
			OR
				FORM.city NEQ qGetHostFamilyInfo.city
			OR
				FORM.state NEQ qGetHostFamilyInfo.state
			OR
				FORM.zip NEQ qGetHostFamilyInfo.zip)>    
        
            <cfsavecontent variable="vEmailMessage">
                <cfoutput>
                    <p>HOST FAMILY NOTICE OF ADDRESS CHANGE</p>
                    
                    <p><strong>#CLIENT.firstName# #CLIENT.lastName# (###CLIENT.userID#)</strong> has made an address change.</p>
                    
                    <p>
                    	Host Family: 
                        <strong>
                            #FORM.motherFirstName# 
                            <cfif LEN(FORM.motherFirstName) AND LEN(fatherFirstName)>&</cfif>
                            #FORM.fatherFirstName# #FORM.familyLastName# (###FORM.hostID#)
                        </strong>
                    </p>
                    
                    <p><strong>NEW ADDRESSS</strong></p>
                    
                    #FORM.address#<br />
                    <cfif LEN(FORM.address2)>#FORM.address2#<br /></cfif>
                    #FORM.city# #FORM.state# #FORM.zip#<br /><br />
                    
                    <p><strong>PREVIOUS ADDRESS</strong></p>
                    
                    #qGetHostFamilyInfo.address#<br />
                    <cfif LEN(qGetHostFamilyInfo.address2)> #qGetHostFamilyInfo.address2#<br /></cfif>
                    #qGetHostFamilyInfo.city# #qGetHostFamilyInfo.state# #qGetHostFamilyInfo.zip#<br /><br />
                    
                    <p>This is the only notification of this change that you will receive.</p>
                    
                    <p>Please update any records that do NOT pull information from EXITS.</p>
                    
                    <p>The following were notified:</p>
                    
                    #APPLICATION.EMAIL.hostFamilyNotification#
                </cfoutput>
            </cfsavecontent>
        
			<!--- send email --->
            <cfinvoke component="internal.extensions.components.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#APPLICATION.EMAIL.hostFamilyNotification#">
            <cfinvokeargument name="email_subject" value="PHP - Host Family Notice of Address Change">
            <cfinvokeargument name="email_message" value="#vEmailMessage#">            
            </cfinvoke>
        
        </cfif>
		<!------------------------------------------------------
			END OF ADDRESS CHANGE - SEND EMAIL NOTIFICATION 
		------------------------------------------------------->
         
        
        
        <Cfquery name="qGetCompanyID"  datasource="#application.dsn#">
                select *
                from smg_companies 
                where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            </Cfquery>
          
        <!--- Encrypt SSNs --->
        <cfif val(form.fatherrunCBC)>
       
			<cfquery name="insertHostFather" datasource="#application.dsn#">
            	insert into php_hosts_cbc (companyid, cbc_type, hostid, date_authorized,isNoSSN)
            	values (<cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="father">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostID#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fatherIsNoSSN#">
                        )
            </cfquery>     
           
            
        	
			<cfscript>
				// Get CBCs Host Parents Updated
				qGetCBCHost = APPLICATION.CFC.CBC.getPendingCBCHost(
					companyID=CLIENT.companyID,
					hostID=FORM.hostID,
					userType='father'
				);	
			
            
                FORM.fatherSSN = APPLICATION.CFC.UDF.encryptVariable(FORM.fatherSSN);
				
				// Process Batch
					APPLICATION.CFC.CBC.processBatch(
                       companyID=qGetCBCHost.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        userType=qGetCBCHost.cbc_type,
                        hostID=qGetCBCHost.hostid,
                        cbcID=qGetCBCHost.CBCFamID,
                        // XML variables
                        username=qGetCompanyID.gis_username,
                        password=qGetCompanyID.gis_password,
                        account=qGetCompanyID.gis_account,
                        SSN=Evaluate(qGetCBCHost.cbc_type & 'ssn'),
                        lastName=Evaluate(qGetCBCHost.cbc_type & 'lastname'),
						middleName=Evaluate(qGetCBCHost.cbc_type & 'middlename',1),
                        firstName=Evaluate(qGetCBCHost.cbc_type & 'firstname'),
                        DOBYear=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'yyyy'),
                        DOBMonth=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'mm'),
                        DOBDay=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'dd'),
						noSSN=qGetCBCHost.isNoSSN
                    );
			</cfscript>
			
        </cfif>
        <!----
        <cfif len(trim(form.motherssn)) and left(form.motherSSN,3) neq 'XXX'>
          ---->
         <cfif val(form.motherrunCBC)> 
          
        <cfquery name="insertHostMother" datasource="#application.dsn#">
            	insert into php_hosts_cbc (companyid, cbc_type, hostid, date_authorized,isNoSSN)
            	values (<cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="mother">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostID#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.motherIsNoSSN#">)
            </cfquery>   
            
			<cfscript>
				// Get CBCs Host Parents Updated
				qGetCBCHost = APPLICATION.CFC.CBC.getPendingCBCHost(
					companyID=CLIENT.companyID,
					hostID=FORM.hostID,
					userType='mother'
				);	
	
                 FORM.motherSSN = APPLICATION.CFC.UDF.encryptVariable(FORM.motherSSN);   
				 
				 
				
				// Process Batch
					APPLICATION.CFC.CBC.processBatch(
                       companyID=qGetCBCHost.companyID,
                        companyShort=qGetCompanyID.companyShort,
                        userType=qGetCBCHost.cbc_type,
                        hostID=qGetCBCHost.hostid,
                        cbcID=qGetCBCHost.CBCFamID,
                        // XML variables
                        username=qGetCompanyID.gis_username,
                        password=qGetCompanyID.gis_password,
                        account=qGetCompanyID.gis_account,
                        SSN=Evaluate(qGetCBCHost.cbc_type & 'ssn'),
                        lastName=Evaluate(qGetCBCHost.cbc_type & 'lastname'),
						middleName=Evaluate(qGetCBCHost.cbc_type & 'middlename',1),
                        firstName=Evaluate(qGetCBCHost.cbc_type & 'firstname'),
                        DOBYear=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'yyyy'),
                        DOBMonth=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'mm'),
                        DOBDay=DateFormat(Evaluate(qGetCBCHost.cbc_type & 'dob'), 'dd'),
						noSSN=qGetCBCHost.isNoSSN
                    );
            </cfscript>
            
         
        </cfif>
 
        <cfquery datasource="mysql">
            UPDATE 
                smg_hosts
            SET familylastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.familylastname#">,
                fatherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherlastname#" null="#IIF(FORM.fatherlastname EQ "", true, false)#">,
                fatherfirstname= <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherfirstname#" null="#IIF(FORM.fatherfirstname EQ "", true, false)#">,
				fatherdob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.fatherdob#" null="#IIF(FORM.fatherdob EQ "", true, false)#">,
                fatherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherworktype#">,
                father_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
                <cfif left(form.fatherSSN,3) neq 'XXX'>
                	fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherSSN#" null="#IIF(FORM.fatherSSN EQ "", true, false)#">,
                </cfif>
                motherfirstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherfirstname#" null="#IIF(FORM.motherfirstname EQ "", true, false)#">,
                motherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherlastname#" null="#IIF(FORM.motherlastname EQ "", true, false)#">, 		
                emergency_contact_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_contact_name#">,
                emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#">,
                motherdob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.motherdob#" null="#IIF(FORM.motherdob EQ "", true, false)#">,
                motherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherworktype#">,
                mother_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mother_cell#">,
                <cfif left(form.motherSSN,3) neq 'XXX'>
                	motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherSSN#" null="#IIF(FORM.motherSSN EQ "", true, false)#">,
                </cfif>
                address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
            WHERE 
                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostID)#">
        </cfquery>
        
        <cflocation url="?curdoc=forms/host_fam_pis_2" addtoken="No">

	<cfelse>
    
		<cfscript>
			// Set Default Values
			FORM.familyLastName = qGetHostFamilyInfo.familyLastName;
			FORM.fatherLastName = qGetHostFamilyInfo.fatherLastName;
			FORM.fatherFirstName = qGetHostFamilyInfo.fatherFirstName;
			FORM.fatherDOB = qGetHostFamilyInfo.fatherDOB;
			FORM.fatherWorkType = qGetHostFamilyInfo.fatherWorkType;
			FORM.father_cell = qGetHostFamilyInfo.father_cell;
			FORM.fatherSSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetHostFamilyInfo.fatherSSN, displayType='user');
			FORM.motherLastName = qGetHostFamilyInfo.motherLastName;
			FORM.motherFirstName = qGetHostFamilyInfo.motherFirstName;
			FORM.motherDOB = qGetHostFamilyInfo.motherDOB;
			FORM.motherSSN = qGetHostFamilyInfo.motherSSN;
			FORM.motherWorkType = qGetHostFamilyInfo.motherWorkType;
			FORM.mother_cell = qGetHostFamilyInfo.mother_cell;
			FORM.motherSSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetHostFamilyInfo.motherSSN, displayType='user');
			FORM.address = qGetHostFamilyInfo.address;
			FORM.address2 = qGetHostFamilyInfo.address2;
			FORM.city = qGetHostFamilyInfo.city;
			FORM.state = qGetHostFamilyInfo.state;
			FORM.zip = qGetHostFamilyInfo.zip;
			FORM.phone = qGetHostFamilyInfo.phone;
			FORM.email = qGetHostFamilyInfo.email;
			FORM.emergency_contact_name = qGetHostFamilyInfo.emergency_contact_name;
			FORM.emergency_phone = qGetHostFamilyInfo.emergency_phone;
		</cfscript>

    </cfif>

</cfsilent>

<script type="text/javascript">
	function areYouSure() { 
	   if(confirm("You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue")) { 
		 form.submit(); 
			return true; 
	   } else { 
			return false; 
	   } 
	}
	
	
</script>

<cfoutput query="qGetHostFamilyInfo">
    
    <cfform method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
    	<input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="hostID" value="#qGetHostFamilyInfo.hostID#" />
        
        <h2 style="margin-left:80px; margin-bottom:5px;">H o s t &nbsp;&nbsp;&nbsp; P a r e n ts  &nbsp;&nbsp;&nbsp;  I n f o r m a t i o n <font size=-2>[ <cfoutput><a href="?curdoc=host_fam_info&hostID=#qGetHostFamilyInfo.hostID#">overview</a></cfoutput> ] </font></h2>
        
        <table width="90%" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##FFFFFF" class="section">
            <tr>
            	<td width="80%" class="box">
                    <table border="0" cellpadding="4" cellspacing="0" align="left">
                        <tr>
                        	<td class="label">Family Name:</td>
                            <td colspan="3"><input type="text" name="familylastname" class="xLargeField"  onBlur="javascript:lastname(this.form);" value="#FORM.familylastname#"></td>
                        </tr>
                        <tr>
                        	<td class="label">Address:</td>
                            <td colspan="3"><input type="text" name="address" class="xLargeField" value="#FORM.address#"></td>
                        </tr>
                        <tr>
                        	<td class="label">Mailing Address:</td>
                            <td colspan="3"><input type="text" name="address2" class="xLargeField" value="#FORM.address2#"></td>
                        </tr>
                        <tr>
                        	<td class="label">City: </td>
                            <td colspan="3"><input type="text" name="city" class="xLargeField" value="#FORM.city#"></td>
                        </tr>
                        <tr>
                        	<td class="label">State:</td>
                            <td width="10">
                                <select name="state" class="mediumField">
                                    <option value=""></option>
                                    <cfloop query="qGetStateList">
                                        <option value="#qGetStateList.state#" <Cfif FORM.state EQ qGetStateList.state>selected</cfif>>#qGetStateList.stateName#</option>
                                    </cfloop>
                               	</select> 
                            <td class="label">Zip:</td>
                            <td><input type="text" name="zip" class="smallField" value="#FORM.zip#" maxlength="5"></td>
	                    </tr>
                        <tr>
                        	<td class="label">Phone:</td>
                            <td colspan="3"><input type="text" name="phone" class="mediumField" value="#FORM.phone#"> nnn-nnn-nnnn</td>
                        </tr>
                        <tr>
                        	<td class="label">Email:</td>
                            <td colspan="3"><input type="text" name="email" class="xLargeField" value="#FORM.email#"></td>
                        </tr>
                        <tr bgcolor="##C2D1EF">
                        	<td class="label">Fathers First Name:</td>
                            <td colspan="3"><input type="text" name="fatherFirstName" class="largeField" value="#FORM.fatherfirstname#"></td>
                        </tr>
                        <tr bgcolor="##C2D1EF">
                        	<td class="label">Fathers Last Name:</td>
                            <td colspan="3"><input type="text" name="fatherLastName" class="largeField" value="#FORM.fatherLastName#"></td>
                        </tr>
                        <tr bgcolor="##C2D1EF">
                        	<td class="label">Fathers Cell Phone:</td>
                            <td colspan="3"><input type="text" name="father_cell" class="mediumField" value="#FORM.father_cell#"></td>
                        </tr>
                        <tr bgcolor="##C2D1EF">
                        	<td class="label">Date of Birth:</td>
                            <td colspan="3"><input type="text" name="fatherdob" class="smallField" value="#DateFormat(FORM.fatherdob, 'mm/dd/yyyy')#"> mm/dd/yyyy</td>
                        </tr>
                        <tr bgcolor="##C2D1EF">
                        	<td class="label">SSN:</td>
                            <td colspan="3"><input type="text" name="fatherSSN" class="smallField ssnField" value="#FORM.fatherSSN#">
                         
                             No SSN:
                            
                                	<input type="checkbox" name="fatherIsNoSSN" value="1" <cfif VAL(qGetCBCFather.isNoSSN)>checked="checked"</cfif>>
                       
                             </td>
                        </tr>
                        <Tr bgcolor="##C2D1EF">
                        	<Td align="right">Run Father's CBC</Td><td colspan=3><input type="checkbox" name="fatherrunCBC" value="1"/></td>
                        </Tr>
                        
                        <tr bgcolor="##C2D1EF">
                        	<td class="label">Occupation:</td>
                            <td colspan="3"><input type="text" name="fatherWorkType" class="largeField" value="#FORM.fatherworktype#"></td>
                        </tr>
                        <tr>
                        	<td class="label">Mothers First Name:</td>
                            <td colspan="3"><input type="text" name="motherfirstname" class="largeField" value="#FORM.motherfirstname#"></td>
                        </tr>
                        <tr>
                        	<td class="label">Mothers Last Name:</td>
                            <td colspan="3"><input type="text" name="motherLastName" class="largeField" value="#FORM.motherlastname#"></td>
                        </tr>
                        <tr>
                        	<td class="label">Mothers Cell Phone:</td>
                            <td colspan="3"><input type="text" name="mother_cell" class="mediumField" value="#FORM.mother_cell#"></td>
                        </tr>
                        <tr>
                        	<td class="label">Date of Birth:</td>
                            <td colspan="3"><input type="text" name="motherdob" class="smallField" value="#DateFormat(FORM.motherdob, 'mm/dd/yyyy')#"> mm/dd/yyyy</td>
                        </tr>
                   
                        <tr>
                        	<td class="label">SSN:</td>
                            
                            <td colspan="3"><input type="text" name="motherSSN" class="smallField ssnField" value="#FORM.motherSSN#">
                          
                              No SSN:  
                      
                                	<input type="checkbox" name="motherIsNoSSN" value="1" <cfif VAL(qGetCBCFather.isNoSSN)>checked="checked"</cfif>>
                               
                              
                      
                            
                              </td>
                        </tr>
					 <Tr>
                        	<Td align="right">Run Mother's CBC</Td><td><input type="checkbox" name="motherrunCBC" value="1"/></td>
                        </Tr>
                        <tr>
                        	<td class="label">Occupation:</td>
                            <td colspan="3"><input type="text" class="largeField" name="motherWorkType" value="#FORM.motherworktype#"></td>
                        </tr>
                        <tr bgcolor="##C2D1EF">
                        	<td class="label">Emergency Contact Name:</td>
                            <td colspan="3"><input type="text" class="largeField" name="emergency_contact_name" value="#FORM.emergency_contact_name#"></td>
                        </tr>
                        <tr bgcolor="##C2D1EF">
                        	<td class="label">Emergency Phone:</td>
                            <td colspan="3"><input type="text" class="largeField" name="emergency_phone" value="#FORM.emergency_phone#"></td>
                        </tr>
                       
                       
                    
                	</table>
                    
                   
                </td>
                <!--- Insert Left Menu --->
                <td width="20%" align="right" valign="top" class="box">
                    <table border="0" cellpadding="4" cellspacing="0" align="right">
                        <tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
                    </table> 		
                </td>
            </tr>
            
            <tr>
                <td align="center" colspan="2">
                    <input name="Submit" type="image" value="next" src="pics/next.gif" align="middle" width="74" height="29" border="0">
                </td>
			</tr>
        </table>
    </cfform>
    
</cfoutput>
