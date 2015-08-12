

<cftransaction action="BEGIN" isolation="SERIALIZABLE">

  <Cfquery name="qGetCompanyID"  datasource="#application.dsn#">
                select *
                from smg_companies 
                where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            </Cfquery>
            
<cfif isdefined('form.update')>   


    <cfloop From = "1" To = "#form.count#" Index = "x">
	<cfparam name="form.memberisNoSSN#x#" default="0">

	 
    <cfif len('#form["name" & x]#')>
   
    	<!---Insert stuff for background check---->
     		<cfset runCBC = 0>
        
           <cfif (len('#form["ssn" & x]#') or val('#form["memberIsNoSSN" & x]#') ) AND val('#form["runCBC" & x]#')>
           	 
			<CFSET runCBC = 1>
           </cfif> 
            
            
    	<!--- Encrypt SSNs --->
        <cfscript>
			FORM['ssn' & x] = APPLICATION.CFC.UDF.encryptVariable(FORM['ssn' & x]);
		</cfscript>
		<!--- FORMS --->
		
			<cfquery name="update_children" datasource="mysql">
				UPDATE smg_host_children
				SET name = '#form["name" & x]#',
                	lastname = '#form["lastname" & x]#',
					birthdate = <cfif form["dob" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["dob" & x])#</cfif>,
                    ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['ssn' & x]#">,
					sex =  <cfif IsDefined('form.sex'&x)>'#form["sex" & x]#'<cfelse>''</cfif>,
					membertype = '#form["membertype" & x]#',
					liveathome = <cfif IsDefined('form.athome'&x)>'#form["athome" & x]#'<cfelse>''</cfif>
				WHERE childid = '#form["childid" & x]#'
			</cfquery>
          
    	 <cfif val(runCBC)>
        
                <cfquery name="insertChildCBC" datasource="#application.dsn#">
                    insert into php_hosts_cbc (companyid, cbc_type, hostid, date_authorized, familyid, isNoSSN)
                    values (<cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="member">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostID#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#form["childid" & x]#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#form["memberisNoSSN" & x]#">)
                </cfquery>     
                
               
            <!---Run Background Check---->
					<cfscript>
                        // Get CBCs Host Members Updated
                    qGetCBCMember = APPCFC.CBC.getPendingCBCHostMember(
                        companyID=CLIENT.companyID,
                        hostID=FORM.hostID
                    );	
                    
                     // Process Batch
                            APPCFC.CBC.processBatch(
                                companyID=qGetCompanyID.companyID,
                                companyShort=qGetCompanyID.companyShort,
                                userType='member',
                                hostID=qGetCBCMember.hostid,
                                cbcID=qGetCBCMember.CBCFamID,
                                // XML variables
                                username=qGetCompanyID.gis_username,
                                password=qGetCompanyID.gis_password,
                                account=qGetCompanyID.gis_account,
                                SSN=qGetCBCMember.ssn,
                                lastName=qGetCBCMember.lastName,
                                firstName=qGetCBCMember.name,
                                middleName=Left(qGetCBCMember.middleName,1),
                                DOBYear=DateFormat(qGetCBCMember.birthdate, 'yyyy'),
                                DOBMonth=DateFormat(qGetCBCMember.birthdate, 'mm'),
                                DOBDay=DateFormat(qGetCBCMember.birthdate, 'dd'),
                                noSSN=qGetCBCMember.isNoSSN
                        );
                    </cfscript>
    	  
    		</cfif>
            
		</cfif>
	</cfloop>

<cfelse><!--- NEW CHILDREN UP TO 5 PER TIME --->
	<cfloop From = "1" To = "5" Index = "x">
    	<cfscript>
			FORM['ssn' & x] = APPLICATION.CFC.UDF.encryptVariable(FORM['ssn' & x]);
		</cfscript>
		<cfif form["name" & x] NEQ ''>
			<cfquery name="insert_kids" datasource="mysql">
				INSERT INTO smg_host_children(
                	name, 
                    lastname,
                    hostid, 
                    membertype, 
                    birthdate, 
					ssn,
                    sex, 
                    liveathome)
				VALUES('#form["name" & x]#',
                	   '#form["lastname" & x]#',
					'#form.hostid#',
					'#form["membertype" & x]#',
					<cfif form["dob" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["dob" & x])#</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['ssn' & x]#">,
					<cfif IsDefined('form.sex'&x)>'#form["sex" & x]#'<cfelse>''</cfif>,
					<cfif IsDefined('form.athome'&x)>'#form["athome" & x]#'<cfelse>''</cfif>)
			</cfquery>
        < 
	<cfparam name="form.memberisNoSSN#x#" default="0">
            
            <cfquery name="currentKidInfo" datasource="#APPLICATION.dsn#">
            select childid from 
            smg_host_children
            where name = '#form["name" & x]#' AND
            hostid = '#form.hostid#'
            and membertype = '#form["membertype" & x]#' 
            </cfquery>
    	
		<!--- FORMS --->
		
			
          
    	 <cfif val('#form["runCBC" & x]#')>
                <cfquery name="insertChildCBC" datasource="#application.dsn#">
                    insert into php_hosts_cbc (companyid, cbc_type, hostid, date_authorized, familyid, isNoSSN)
                    values (<cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="member">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostID#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#currentKidInfo.childid#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#form["memberisNoSSN" & x]#">)
                </cfquery>     
                
               
            <!---Run Background Check---->
					<cfscript>
                        // Get CBCs Host Members Updated
                    qGetCBCMember = APPCFC.CBC.getPendingCBCHostMember(
                        companyID=CLIENT.companyID,
                        hostID=FORM.hostID
                    );	
                    
                     // Process Batch
                            APPCFC.CBC.processBatch(
                                companyID=qGetCompanyID.companyID,
                                companyShort=qGetCompanyID.companyShort,
                                userType='member',
                                hostID=qGetCBCMember.hostid,
                                cbcID=qGetCBCMember.CBCFamID,
                                // XML variables
                                username=qGetCompanyID.gis_username,
                                password=qGetCompanyID.gis_password,
                                account=qGetCompanyID.gis_account,
                                SSN=qGetCBCMember.ssn,
                                lastName=qGetCBCMember.lastName,
                                firstName=qGetCBCMember.name,
                                middleName=Left(qGetCBCMember.middleName,1),
                                DOBYear=DateFormat(qGetCBCMember.birthdate, 'yyyy'),
                                DOBMonth=DateFormat(qGetCBCMember.birthdate, 'mm'),
                                DOBDay=DateFormat(qGetCBCMember.birthdate, 'dd'),
                                noSSN=qGetCBCMember.isNoSSN
                        );
                    </cfscript>
    	  
    		</cfif>
            
	
		</cfif>
	</cfloop>

</cfif>

</cftransaction>

<cflocation url="../index.cfm?curdoc=forms/host_fam_pis_3" addtoken="no">