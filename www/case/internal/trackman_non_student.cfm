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
 
 <!---Does the Application.Online variable exist yet?--->
 <cflock name="TrackMan" type="ReadOnly" timeout="5">
   <cfif IsDefined("Application.Online")>
     <cfset CreateStructure=FALSE>
   <cfelse>
     <cfset CreateStructure=TRUE>
   </cfif>
 </cflock>
 
 <!---Create Application.Online (once only)--->
 <cfif CreateStructure>
   <cflock name="TrackMan" type="Exclusive" timeout="5">
     <cfset Application.Online=StructNew()>
   </cflock>
 </cfif>
 
 <!---Remove "old" users ("TimeOut Minutes")--->
 <!---First build a list of users "older" than "TimeOut"--->
 <cfset TimeOut=30>
 <cfset UserList="">
 <cflock name="TrackMan" type="ReadOnly" timeout="10">
   <cfloop collection="#Application.Online#" item="ThisUser">
     <cfif DateDiff("n",Application.Online[ThisUser][1],now()) 
 GTE TimeOut>
       <cfset UserList=ListAppend(UserList,ThisUser)>
     </cfif>
   </cfloop>
 </cflock>
 
 <!---Then delete "old" users--->
 <cfloop list="#UserList#" index="ThisUser">
   <cflock name="TrackMan" type="Exclusive" timeout="5">
     <cfset Temp=StructDelete(Application.Online,ThisUser)>
   </cflock>
 </cfloop>
 
 
 <!---Build "This" Members "Info" Array--->
 <cfscript>
   Members=ArrayNew(1);
   Members[1]=now();
   Members[2]=CGI.query_string;
  
 </cfscript>
 
 <!---add Members "Info" to "Online" Structure--->
 <cflock name="TrackMan" type="Exclusive" timeout="5">
   <cfset 
 Temp=StructInsert(Application.Online,client.name,Members,TRUE)>
 </cflock>
 
  <cfif client.name is ''>
 <cfelse>

 <cfquery name="insert_tracking" datasource="caseusa">
 insert into smg_user_tracking (userid, page_viewed, time_viewed, fullurl, ip, browser )
 	values(#client.userid#, '#cgi.QUERY_STRING#', #now()#, '#cgi.HTTP_REFERER#', '#cgi.remote_host#', '#cgi.http_user_agent#')
 

 </cfquery>
  </cfif>