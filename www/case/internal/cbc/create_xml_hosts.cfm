<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'
'http://www.w3.org/TR/html4/loose.dtd'>
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
<title>CBC Host Families</title>
</head>

<body>

<cfsetting requestTimeOut = "500">

<cfoutput>

<cfif form.usertype EQ '0' OR form.seasonid EQ '0'>
	You must select a usertype or a season in order to run the batch. Please go back and try again.
	<cfabort>
</cfif>

<cfquery name="get_company" datasource="caseusa">
	SELECT companyid, companyshort, bcc_userid, bcc_password
	FROM smg_companies
	WHERE companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- HOSTS PARENTS --->
<cfif form.usertype NEQ 'member'>
	<cfquery name="get_cbc_hosts" datasource="caseusa">
		SELECT DISTINCT cbc.cbcfamid, cbc.hostid, cbc.cbc_type, cbc.date_authorized, cbc.date_sent, cbc.date_received,
			h.familylastname, h.fatherlastname, h.fatherfirstname, h.fathermiddlename, fatherdob, fatherssn,
			h.motherlastname, h.motherfirstname, h.mothermiddlename, motherdob, motherssn
		FROM smg_hosts_cbc cbc
		INNER JOIN smg_hosts h ON h.hostid = cbc.hostid
		WHERE cbc.date_sent IS NULL AND requestid = ''
			AND cbc.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
			AND cbc.seasonid =  <cfqueryparam value="#form.seasonid#" cfsqltype="cf_sql_integer">
			AND cbc.cbc_type = '#form.usertype#'
		LIMIT 20
	</cfquery>

	<cfif get_cbc_hosts.recordcount EQ '0'>
		Sorry, there were no users to populate the XML file at this time.
		<cfabort>
	</cfif>
	
	<cfset missing = '0'>
	
	<!--- BATCH ID MUST BE UNIQUE --->
	<cfquery name="insert_batchid" datasource="caseusa">
		INSERT INTO smg_users_cbc_batch  (companyid, createdby, datecreated, total, type)
		VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#get_cbc_hosts.recordcount#', 'host')
	</cfquery>
	<cfquery name="get_batchid" datasource="caseusa">
		SELECT MAX(cbcid) as cbcid
		FROM smg_users_cbc_batch
	</cfquery>
	
	<cfloop	query="get_cbc_hosts">
		<cfif #Evaluate(usertype & "firstname")# EQ ''>
				First Name is missing for user #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif #Evaluate(usertype & "lastname")# EQ ''>
				Last Name is missing for user #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif #Evaluate(usertype & "dob")# EQ ''>
				DOB is missing for rep #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif #Evaluate(usertype & "ssn")# EQ ''>
				SSN is missing for rep #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#). <br>
				<cfset missing = missing + 1>
		</cfif>
	</cfloop>

	<cfif missing GT '0'>
		<br>There are #missing# item(s). In order to continue please enter the information missing.
		<cfabort>
	</cfif>

	<cfloop query='get_cbc_hosts'> 
	
	<cftry>
		<cfset newssn = ''>
		<cfset newssn = #Replace("#decrypt(Evaluate(usertype & "ssn"), 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', 'desede', 'hex')#","-","","All")#>
		<cfset newssn = #Replace("#newssn#", " ", "","All")#>
	<cfcatch type="any">
		Please check SSN for #get_cbc_hosts.familylastname# (###get_cbc_hosts.hostid#)
		<cfabort>
	</cfcatch>
	</cftry>
	
	<cfxml variable='cbc_batch'>
	<?xml version='1.0' encoding='UTF-8'?>
	<Requests xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
		<Authentication>
			<UserId>#XMLFormat(get_company.bcc_userid)#</UserId>
			<Password>#XMLFormat(get_company.bcc_password)#</Password>
		</Authentication>
			<Request Purpose='2'>
				<ClientId>#XMLFormat(hostid)#</ClientId>
				<Subject>
					<LastName>#Evaluate(usertype & "lastname")#</LastName>
					<FirstName>#Evaluate(usertype & "firstname")#</FirstName>
					<MiddleInitial>#Left(Evaluate(usertype & "middlename"),1)#</MiddleInitial>
					<SSN>#newssn#</SSN>
					<DOB>#DateFormat(Evaluate(usertype & "dob"), 'mm/dd/yyyy')#</DOB>
				</Subject>
				<Searches>	
					<Criminal Type='AUTO'>
					</Criminal>
				</Searches>
				<Output>
					<ReplyLine>Search results for #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")#</ReplyLine>
					<Destination>
						<URL>caroline@student-management.com</URL>
						<Method>E</Method>
						<Format>T</Format>
					</Destination>
					<SendCompleteResult>true</SendCompleteResult>
					<SendPartialResult>true</SendPartialResult>
				</Output>
			</Request>
	</Requests>
	</cfxml>
	
	* XML SENT TO INTELLICORP <br>
	<cfdump var="#cbc_batch#"> <br>
	
	<cffile action="write" file="d:\websites\nsmg\cbc\xml\#get_company.companyshort#\#get_company.companyshort#_#get_batchid.cbcid#_#get_cbc_hosts.cbcfamid#_Sent.xml" output=#toString(cbc_batch)#>
	
	<!--- SUBMIT XML --->
	<cfinvoke    
		webservice = "http://www.intellicorp.net/xgs/xgs.asmx?WSDL"    
		method = "SubmitRequestII"   
		username="#get_company.bcc_userid#"
		password="#get_company.bcc_password#"
		timeout = "300"
	   XMLRequestString = "<?xml version='1.0' encoding='UTF-8'?>
		<Requests xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
			<Authentication>
				<UserId>#get_company.bcc_userid#</UserId>
				<Password>#get_company.bcc_password#</Password>
			</Authentication>
				<Request Purpose='2'>
					<ClientId>#hostid#</ClientId>
					<Subject>
						<LastName>#Evaluate(usertype & "lastname")#</LastName>
						<FirstName>#Evaluate(usertype & "firstname")#</FirstName>
						<MiddleInitial>#Left(Evaluate(usertype & "middlename"),1)#</MiddleInitial>
						<SSN>#newssn#</SSN>
						<DOB>#DateFormat(Evaluate(usertype & "dob"), 'mm/dd/yyyy')#</DOB>
					</Subject>
					<Searches>	
						<Criminal Type='AUTO'>
						</Criminal>
					</Searches>
					<Output>
						<ReplyLine>Search results for #Evaluate(usertype & "firstname")# #Evaluate(usertype & "lastname")# (###hostid#) - HF - #get_company.companyshort#</ReplyLine>
						<Destination>
							<URL>caroline@student-management.com</URL>
							<Method>E</Method>
							<Format>T</Format>
						</Destination>
						<SendCompleteResult>true</SendCompleteResult>
						<SendPartialResult>false</SendPartialResult>
					</Output>
				</Request>
		</Requests>"
	   returnVariable = 'var_name'>
	   <cfset mydoc = ''>
	   <cfset mydoc = XmlParse(var_name)>
	   	* XML RECEIVED FROM INTELLICORP <br>
	   <cfdump var="#mydoc#">  
	
	<cffile action="write" file="d:\websites\nsmg\cbc\xml\#get_company.companyshort#\#get_company.companyshort#_#get_batchid.cbcid#_#get_cbc_hosts.cbcfamid#_Received.xml" output=#toString(mydoc)#> 
	
	<cfif IsDefined('mydoc.SearchResponse.Acknowledgement.Success.XmlText')>
		<cfquery name="update_cbc" datasource="caseusa">
			UPDATE smg_hosts_cbc  
			SET date_sent = #CreateODBCDate(now())#,
					date_received = #CreateODBCDate(now())#,
					batchid = '#get_batchid.cbcid#',
					Requestid = '#mydoc.SearchResponse.RequestId.XmlText#'
			WHERE cbcfamid = <cfqueryparam value="#get_cbc_hosts.cbcfamid#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>	
	
	</cfloop>
	
<!--- HOST MEMBERS --->
<cfelse>
	<cfquery name="get_cbc_members" datasource="caseusa">
		SELECT DISTINCT cbc.cbcfamid, cbc.hostid, cbc.cbc_type, cbc.date_authorized, cbc.date_sent, cbc.date_received,
		child.childid, child.name, child.middlename, child.lastname, child.birthdate, child.ssn, child.hostid
		FROM smg_hosts_cbc cbc
		INNER JOIN smg_host_children child ON child.childid = cbc.familyid
		WHERE cbc.date_sent IS NULL AND requestid = ''
			AND cbc.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
			AND cbc.seasonid =  <cfqueryparam value="#form.seasonid#" cfsqltype="cf_sql_integer">
			AND cbc.cbc_type = '#form.usertype#'
		LIMIT 20
	</cfquery>
	
	<cfif get_cbc_members.recordcount EQ '0'>
		Sorry, there were no host members to populate the XML file at this time.
		<cfabort>
	</cfif>
	
	<cfset missing = '0'>
	
	<cfloop query="get_cbc_members">
		<cfif name EQ ''>
				First Name is missing for host member #name# #lastname# member of (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif lastname EQ ''>
				Last Name is missing for host member #name# #lastname# member of (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif birthdate EQ ''>
				DOB is missing for host member #name# #lastname# member of (###hostid#). <br>
				<cfset missing = missing + 1>
		<cfelseif ssn EQ ''>
				SSN is missing for host member #name# #lastname# member of (###hostid#). <br>
				<cfset missing = missing + 1>
		</cfif>
	</cfloop>
	
	<cfif missing GT '0'>
		<br>There are #missing# item(s). In order to continue please enter the information msising.
		<cfabort>
	</cfif>
	
 	<!--- BATCH ID MUST BE UNIQUE --->
	<cfquery name="insert_batchid" datasource="caseusa">
		INSERT INTO smg_users_cbc_batch  (companyid, createdby, datecreated, total, type)
		VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#get_cbc_members.recordcount#', 'host')
	</cfquery>

	<cfquery name="get_batchid" datasource="caseusa">
		SELECT MAX(cbcid) as cbcid
		FROM smg_users_cbc_batch
	</cfquery>
	
	<cfloop query='get_cbc_members'> 
	
	<cfset newssn = ''>
	<cfset newssn = #Replace("#decrypt(ssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', 'desede', 'hex')#","-","","All")#>
	<cfset newssn = #Replace("#newssn#", " ", "","All")#>
	
	<cfxml variable='cbc_batch'>
	<?xml version='1.0' encoding='UTF-8'?>
	<Requests xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
		<Authentication>
			<UserId>#get_company.bcc_userid#</UserId>
			<Password>#get_company.bcc_password#</Password>
		</Authentication>
		<Request Purpose='2'>
			<ClientId>#childid#</ClientId>
			<Subject>
				<LastName>#lastname#</LastName>
				<FirstName>#name#</FirstName>
				<MiddleInitial>#Left(middlename,1)#</MiddleInitial>
				<SSN>#newssn#</SSN>
				<DOB>#DateFormat(birthdate, 'mm/dd/yyyy')#</DOB>
			</Subject>
			<Searches>	
				<Criminal Type='AUTO'>
				</Criminal>
			</Searches>
			<Output>
				<ReplyLine>Search results for #name# #lastname#</ReplyLine>
				<Destination>
					<URL>caroline@student-management.com</URL>
					<Method>E</Method>
					<Format>T</Format>
				</Destination>
				<SendCompleteResult>true</SendCompleteResult>
				<SendPartialResult>true</SendPartialResult>
			</Output>
		</Request>
	</Requests>
	</cfxml>
	
	* XML SENT TO INTELLICORP <br>
	<cfdump var="#cbc_batch#"> <br>
	
	<cffile action="write" file="d:\websites\nsmg\cbc\xml\#get_company.companyshort#\#get_company.companyshort#_#get_batchid.cbcid#_#get_cbc_members.cbcfamid#_Sent.xml" output=#toString(cbc_batch)#>
	
	<!--- SUBMIT XML --->
	<cfinvoke    
		webservice = "http://www.intellicorp.net/xgs/xgs.asmx?WSDL"    
		method = "SubmitRequestII"   
		username="#get_company.bcc_userid#"
		password="#get_company.bcc_password#"
		timeout = "200"
	   XMLRequestString = "<?xml version='1.0' encoding='UTF-8'?>
		<Requests xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
			<Authentication>
				<UserId>#get_company.bcc_userid#</UserId>
				<Password>#get_company.bcc_password#</Password>
			</Authentication>
			<Request Purpose='2'>
				<ClientId>#childid#</ClientId>
				<Subject>
					<LastName>#lastname#</LastName>
					<FirstName>#name#</FirstName>
					<MiddleInitial>#Left(middlename,1)#</MiddleInitial>
					<SSN>#newssn#</SSN>
					<DOB>#DateFormat(birthdate, 'mm/dd/yyyy')#</DOB>
				</Subject>
				<Searches>	
					<Criminal Type='AUTO'>
					</Criminal>
				</Searches>
				<Output>
					<ReplyLine>Search results for #name# #lastname# - Member of HF (###hostid#) - #get_company.companyshort#</ReplyLine>
					<Destination>
						<URL>caroline@student-management.com</URL>
						<Method>E</Method>
						<Format>T</Format>
					</Destination>
					<SendCompleteResult>true</SendCompleteResult>
					<SendPartialResult>true</SendPartialResult>
				</Output>
			</Request>
		</Requests>"
	   returnVariable = 'var_name'>
	   <cfset mydoc = ''>
	   <cfset mydoc = XmlParse(var_name)>
	   * XML RECEIVED FROM INTELLICORP<br>
	   <cfdump var="#mydoc#"><br>  
	
	<cffile action="write" file="d:\websites\nsmg\cbc\xml\#get_company.companyshort#\#get_company.companyshort#_#get_batchid.cbcid#_#get_cbc_members.cbcfamid#_Received.xml" output=#toString(mydoc)#> 
	
	<cfif IsDefined('mydoc.SearchResponse.Acknowledgement.Success.XmlText')>
		<cfquery name="update_cbc" datasource="caseusa">
			UPDATE smg_hosts_cbc  
			SET date_sent = #CreateODBCDate(now())#,
					date_received = #CreateODBCDate(now())#,
					batchid = '#get_batchid.cbcid#',
					Requestid = '#mydoc.SearchResponse.RequestId.XmlText#'
			WHERE cbcfamid = <cfqueryparam value="#get_cbc_members.cbcfamid#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>	

	</cfloop>

</cfif>		

</cfoutput>
</body>
</html>