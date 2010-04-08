<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'
'http://www.w3.org/TR/html4/loose.dtd'>
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
<title>CBC Users</title>
</head>

<body>

<cfsetting requestTimeOut = "500">

<cfif form.usertype EQ '0' OR form.seasonid EQ '0'>
	You must select a usertype or a season in order to run the batch. Please go back and try again.
	<cfabort>
</cfif>

<cfquery name="get_company" datasource="MySql">
	SELECT companyid, companyshort, bcc_userid, bcc_password
	FROM smg_companies
	WHERE companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- OFFICE AND REP USERS --->
<cfif form.usertype NEQ '3'>
	<cfquery name="get_cbc_users" datasource="MySql">
		SELECT DISTINCT cbc.cbcid, cbc.userid, cbc.familyid, cbc.date_authorized, cbc.date_sent, cbc.date_received,
			u.firstname, u.lastname, u.middlename, u.dob, u.ssn
		FROM smg_users_cbc cbc
		INNER JOIN smg_users u ON u.userid = cbc.userid
		INNER JOIN user_access_rights uar ON uar.userid = u.userid
		WHERE cbc.date_sent IS NULL 
			AND cbc.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
			AND cbc.seasonid =  <cfqueryparam value="#form.seasonid#" cfsqltype="cf_sql_integer">
			<cfif form.usertype EQ '1'> <!--- OFFICE --->
				AND uar.usertype <= '4' AND cbc.familyid = '0'
			<cfelseif form.usertype EQ '2'> <!--- FIELD --->
				AND uar.usertype >= '5' AND uar.usertype <= '7' AND cbc.familyid = '0'
			</cfif>
		LIMIT 20
	</cfquery>
<!--- FAMILY USERS --->
<cfelse>
	<cfquery name="get_cbc_users" datasource="MySql">
		SELECT DISTINCT cbc.cbcid, cbc.userid, cbc.familyid, cbc.date_authorized, cbc.date_sent, cbc.date_received,
			u.firstname, u.lastname, u.middlename, u.dob, u.ssn
		FROM smg_users_cbc cbc
		INNER JOIN smg_user_family u ON u.id = cbc.familyid
		WHERE cbc.date_sent IS NULL 
			AND cbc.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
			AND cbc.seasonid =  <cfqueryparam value="#form.seasonid#" cfsqltype="cf_sql_integer">
			AND cbc.familyid != '0'
		LIMIT 20
	</cfquery>
</cfif>

<!---
<CFSCRIPT>
function cleanssn(newssn){
var nssn = newssn;
nssn = Replace("#newssn#","-","","All");
nssn = Replace("#newssn#", " ", "","All"); 
return marcus;
}
</CFSCRIPT>
--->

<cfif get_cbc_users.recordcount EQ '0'>
	Sorry, there were no users to populate the XML file at this time.
	<cfabort>
</cfif>

<cfset missing = '0'>

<cfoutput query="get_cbc_users">
	<cfif firstname EQ ''>
			First Name is missing for user #firstname# #lastname# (###userid#). <br>
			<cfset missing = missing + 1>
	<cfelseif lastname EQ ''>
			Last Name is missing for user #firstname# #lastname# (###userid#). <br>
			<cfset missing = missing + 1>
	<cfelseif dob EQ ''>
			DOB is missing for rep #firstname# #lastname# (###userid#). <br>
			<cfset missing = missing + 1>
	<cfelseif ssn EQ ''>
			SSN is missing for rep #firstname# #lastname# (###userid#). <br>
			<cfset missing = missing + 1>
	<cfelseif missing GT '0'>
			There are #missing# item(s). Please enter the information missing above in order to continue.
		<cfabort>
	</cfif>
</cfoutput>

<!--- BATCH ID MUST BE UNIQUE --->
<cfquery name="insert_batchid" datasource="MySqL">
	INSERT INTO smg_users_cbc_batch  (companyid, createdby, datecreated, total, type)
	VALUES ('#get_company.companyid#', '#client.userid#', #CreateODBCDateTime(now())#, '#get_cbc_users.recordcount#', 'user')
</cfquery>

 <cfquery name="get_batchid" datasource="MySql">
	SELECT MAX(cbcid) as cbcid
	FROM smg_users_cbc_batch
</cfquery>

<cfoutput>

<cfloop query='get_cbc_users'> 

	<cfset newssn = ''>
	<cfset newssn = #Replace("#decrypt(get_cbc_users.ssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', 'desede', 'hex')#","-","","All")#>
	<cfset newssn = #Replace("#newssn#", " ", "","All")#>
	
	<cfxml variable='cbc_batch'>
	<?xml version='1.0' encoding='UTF-8'?>
	<Requests xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
		<Authentication>
			<UserId>#get_company.bcc_userid#</UserId>
			<Password>#get_company.bcc_password#</Password>
		</Authentication>
			<Request Purpose='2'>
				<ClientId>#get_cbc_users.userid#</ClientId>
				<Subject>
					<LastName>#get_cbc_users.lastname#</LastName>
					<FirstName>#get_cbc_users.firstname#</FirstName>
					<MiddleInitial>#Left(get_cbc_users.middlename, 1)#</MiddleInitial>
					<SSN>#newssn#</SSN>
					<DOB>#DateFormat(get_cbc_users.dob, 'mm/dd/yyyy')#</DOB>
				</Subject>
				<Searches>	
					<Criminal Type='AUTO'>
					</Criminal>
				</Searches>
				<Output>
					<ReplyLine>Search results for #get_cbc_users.firstname# #get_cbc_users.lastname#</ReplyLine>
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

	<cfdump var="#cbc_batch#"> <br>
	<cffile action="write" file="d:\websites\nsmg\cbc\xml\#get_company.companyshort#\#get_company.companyshort#_#get_batchid.cbcid#_#get_cbc_users.userid#_Sent.xml" output=#toString(cbc_batch)#>

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
			<ClientId>#get_cbc_users.userid#</ClientId>
			<Subject>
				<LastName>#get_cbc_users.lastname#</LastName>
				<FirstName>#get_cbc_users.firstname#</FirstName>
				<MiddleInitial>#Left(get_cbc_users.middlename, 1)#</MiddleInitial>
				<SSN>#newssn#</SSN>
				<DOB>#DateFormat(get_cbc_users.dob, 'mm/dd/yyyy')#</DOB>
			</Subject>
			<Searches>	
				<Criminal Type='EXACT'>
					<Crim>
						<ProductId>SUPER</ProductId>
					</Crim>
					<Crim>
						<ProductId>SEXOFNDR</ProductId>
					</Crim>				
				</Criminal>
			</Searches>
			<Output>
				<ReplyLine>Search results for #get_cbc_users.firstname# #get_cbc_users.lastname# (###get_cbc_users.userid#) - User - #get_company.companyshort#</ReplyLine>
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
	   returnVariable = "var_name">
	   <cfset mydoc = ''>
	   <cfset mydoc = XmlParse(var_name)>
	   <cfdump var="#mydoc#">  
	
	<cffile action="write" file="d:\websites\nsmg\cbc\xml\#get_company.companyshort#\#get_company.companyshort#_#get_batchid.cbcid#_#get_cbc_users.userid#_Received.xml" output=#toString(mydoc)#> 
	
	<cfif IsDefined('mydoc.SearchResponse.Acknowledgement.Success.XmlText')>
		<cfquery name="update_cbc" datasource="MySql">
			UPDATE smg_users_cbc 
				set date_sent = #CreateODBCDate(now())#,
					date_received = #CreateODBCDate(now())#,
					batchid = '#get_batchid.cbcid#',
					Requestid = '#mydoc.SearchResponse.RequestId.XmlText#'
			WHERE cbcid = <cfqueryparam value="#get_cbc_users.cbcid#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>	

</cfloop>

</cfoutput>
</body>
</html>

<!--- CBC SEARCH --->
<!---
<cfinvoke    
	webservice = "http://www.intellicorp.net/xgs/xgs.asmx?WSDL"    
	method = "SubmitRequest"   
	username="briancr4"
	password="isebcc4"
	timeout = "200"
   XMLRequestString = "<?xml version='1.0' encoding='UTF-8'?>
	<Requests xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
		<Authentication>
			<UserId>briancr4</UserId>
			<Password>isebcc4</Password>
		</Authentication>
		<Request Purpose='2'>
			<ClientId>510</ClientId>
			<Subject>
				<LastName>Melo</LastName>
				<FirstName>Marcus</FirstName>
				<MiddleInitial>V</MiddleInitial>
				<SSN>051942070</SSN>
				<DOB>07/20/78</DOB>
			</Subject>
			<Searches>	
				<Criminal Type='EXACT'>
					<Crim>
						<ProductId>SUPER</ProductId>
					</Crim>
				</Criminal>
			</Searches>
			<Output>
				<ReplyLine>Search results for Marcus Melo</ReplyLine>
				<Destination>
					<URL>support@student-management.com</URL>
					<Method>E</Method>
					<Format>T</Format>
				</Destination>
				<SendCompleteResult>true</SendCompleteResult>
				<SendPartialResult>false</SendPartialResult>
			</Output>
		</Request>
	</Requests>"
   returnVariable = "var_name">
   <cfset mydoc = XmlParse(var_name)>
   <cfdump var="#mydoc#">
   
	<cfoutput>
	<cffile action="write" file="d:\websites\nsmg\cbc\xml\marcuscbc.xml" output=#toString(mydoc)#>
	</cfoutput>
   
  <!---- ADD USER ---->
  	<cfinvoke    
		webservice = "http://www.intellicorp.net/xgs/xgs.asmx?WSDL"    
		method = "SubmitRequestII"   
		username="briancr4"
		password="isebcc4"
		timeout = "200"
	   XMLRequestString = "<?xml version='1.0' encoding='UTF-8'?>
		<AddUser>
			<Authentication>
				<UserId>briancr4</UserId>
				<Password>isebcc4</Password>
			</Authentication>
			<User>
				<LastName>Melo</LastName>
				<FirstName>Marcus</FirstName>
				<Email>marcus@student-management.com</Email>	
				<Admin>1</Admin>
				<AutoEmail>1</AutoEmail>	
				<Screen>1</Screen>		
			</User>
		</AddUser>"
	   returnVariable = "var_name">
	   <cfset mydoc = XmlParse(var_name)>
	   <cfdump var="#mydoc#">   

<!--- SEARCH FOR PRODUCTS --->
	<cfinvoke    
		webservice = "http://www.intellicorp.net/xgs/xgs.asmx?WSDL"    
		method = "SubmitRequestII"   
		username="briancr4"
		password="isebcc4"
		timeout = "200"
	   XMLRequestString = "<?xml version='1.0' encoding='UTF-8'?>
		<ProdRequest xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' type='list'>
			<Authentication>
				<UserId>briancr4</UserId>
				<Password>isebcc4</Password>
			</Authentication>
			<State>NY</State>
			<Type>Criminal</Type>
		</ProdRequest>"
	   returnVariable = 'var_name'>
	   <cfset mydoc = XmlParse(var_name)>
	   <cfdump var="#mydoc#">  
 --->
 
 
 <!--- OLD FILE
 
 <cfxml variable="bcc">
<cfoutput>
<?xml version='1.0' encoding='UTF-8'?>
<Requests xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' >
	<Authentication>
		<UserId></UserId>
		<Password></Password>
	</Authentication>
	<cfloop query='get_cbc_users'>
	<Request Purpose='2'>
		<ClientId><cfif familyid EQ '0'>#userid#<cfelse>#familyid#</cfif></ClientId>
		<Subject>			
			<LastName>#lastname#</LastName>
			<FirstName>#firstname#</FirstName>
			<MiddleInitial></MiddleInitial>	
			<SSN>987456123</SSN>
			<DOB>#DateFormat(dob, 'mm/dd/yy')#</DOB>
		</Subject>		
		<Searches>			
			<Criminal Type='AUTO'>
				<Crim>
					<ProductId>OHSWC</ProductId>
				</Crim>			
			</Criminal>		
		</Searches>		
		<Output>			
			<ReplyLine>Search results for #firstname# #lastname#</ReplyLine>
			<Destination>	
				<URL>support@student-management.com</URL>
				<Method>E</Method>
				<Format>T</Format>
			</Destination>	
			<SendCompleteResult>true</SendCompleteResult>
			<SendPartialResult>false</SendPartialResult>
		</Output>
		<UniqueId/>	
	</Request>
	</cfloop>
</Requests>
</cfoutput>
</cfxml>

<!-- dump the resulting XML document object -->
<cfdump var="#bcc#">
<cfoutput>
<cffile action="write" file="d:\websites\nsmg\bcc\xml\#get_company.companyshort#\#get_company.companyshort#_new_00#get_batchid.batchid#.xml" output=#toString(bcc)#>
</cfoutput>

--->