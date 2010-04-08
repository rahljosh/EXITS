<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>SMG Online Application - Welcome</title>
</head>
<body>

<cftry>

<cfif isDefined('url.unqid')>
	<!----Get student id  for office folks linking into the student app---->
	<cfquery name="get_student_id" datasource="caseusa">
	select studentid from smg_students
	where uniqueid = '#url.unqid#'
	</cfquery>
	<cfset client.studentid = #get_student_id.studentid#>
</cfif>

<!----Trac Students---->
<cfif not isDefined('client.name')>
	<cfset client.name = ''>
</cfif>
 
 <!---Does the Application.stuOnline variable exist yet?--->
 <cflock name="trackstu" type="ReadOnly" timeout="5">
   <cfif IsDefined("Application.stuOnline")>
     <cfset CreateStructure=FALSE>
   <cfelse>
     <cfset CreateStructure=TRUE>
   </cfif>
 </cflock>
 
 <!---Create Application.stuOnline (once only)--->
 <cfif CreateStructure>
   <cflock name="trackstu" type="Exclusive" timeout="5">
     <cfset Application.stuOnline=StructNew()>
   </cflock>
 </cfif>
 
 <!---Remove "old" users ("TimeOut Minutes")--->
 <!---First build a list of users "older" than "TimeOut"--->
 <cfset TimeOut=30>
 <cfset UserList="">
 <cflock name="trackstu" type="ReadOnly" timeout="10">
   <cfloop collection="#Application.stuOnline#" item="ThisUser">
     <cfif DateDiff("n",Application.stuOnline[ThisUser][1],now()) 
 GTE TimeOut>
       <cfset UserList=ListAppend(UserList,ThisUser)>
     </cfif>
   </cfloop>
 </cflock>
 
 <!---Then delete "old" users--->
 <cfloop list="#UserList#" index="ThisUser">
   <cflock name="trackstu" type="Exclusive" timeout="5">
     <cfset Temp=StructDelete(Application.stuOnline,ThisUser)>
   </cflock>
 </cfloop>
 
 
 <!---Build "This" Members "Info" Array--->
 <cfscript>
   Members=ArrayNew(1);
   Members[1]=now();
   Members[2]=CGI.query_string;
  
 </cfscript>
 
 <!---add Members "Info" to "Online" Structure--->
 <cflock name="trackstu" type="Exclusive" timeout="5">
   <cfset 
 Temp=StructInsert(Application.stuOnline,client.name,Members,TRUE)>
 </cflock>
 
  <cfif client.name is ''>
 <cfelse>

 <cfquery name="insert_tracking" datasource="caseusa">
 insert into smg_user_tracking (userid, page_viewed, time_viewed, fullurl, ip, browser, type )
 	values(#client.studentid#, '#cgi.QUERY_STRING#', #now()#, '#cgi.HTTP_REFERER#', '#cgi.remote_host#', '#cgi.http_user_agent#', #client.usertype#)
 </cfquery>
</cfif>
  
<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>