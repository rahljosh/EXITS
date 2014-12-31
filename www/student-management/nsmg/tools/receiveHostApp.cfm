<Cfparam name="form.process" default="0">
<cfif val(form.process)>

<Cfloop list="#form.submittedStudentList#" index=i>
<cfquery name="hostStuCombo" datasource="#application.dsn#">
select distinct hostid
from smg_hosthistory
where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
</cfquery>
    <cfloop query="hostStuCombo">
    <cfoutput>
    <cfif hostid gt 0>
		<Cfif isDate('#Evaluate("FORM." & i & "_" & hostStuCombo.hostid)#')>
            <cfquery name="updateDateReceived" datasource="#APPLICATION.DSN#">
            	UPDATE smg_hosthistory 
                SET 
                	dateReceived = <cfqueryparam cfsqltype="cf_sql_date" value="#Evaluate("FORM." & i & "_" & hostStuCombo.hostid)#">,
                    updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
            	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
            	AND hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostStuCombo.hostid#"> 
            </cfquery>
        </Cfif>
    </cfif>
    </cfoutput>
   
    </cfloop>
</Cfloop>
</cfif>

<script type="text/javascript">
	function zp(n){
		return n<10?("0"+n):n;
		}
	function insertDate(t,format){
	var now=new Date();
	var DD=zp(now.getDate());
	var MM=zp(now.getMonth()+1);
	var YYYY=now.getFullYear();
	var YY=zp(now.getFullYear()%100);
	format=format.replace(/DD/,DD);
	format=format.replace(/MM/,MM);
	format=format.replace(/YYYY/,YYYY);
	format=format.replace(/YY/,YY);
	t.value=format;
	}
</script>
<style type="text/css">
.border {
	padding: 3px;
	border: 1px solid #ccc;
	height:170px;
	width:135px;
	overflow: hidden;
	margin-right: 15px;
	-moz-box-shadow: 3px 3px 4px #999; /* Firefox */
	-webkit-box-shadow: 3px 3px 4px #999; /* Safari/Chrome */
	box-shadow: 3px 3px 4px #999; /* Opera and other CSS3 supporting browsers */
	-ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=4, Direction=135, Color='#999999')";/* IE 8 */
 : progid:DXImageTransform.Microsoft.Shadow(Strength=4, Direction=135, Color='#999999');/* IE 5.5 - 7 */  
}
</style>
 <div style="width:49%;float:left;display:block;">
 	 <div class="rdholder" style="width:100%; float:left;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">Instructions / Input</span> 
    </div> <!-- end top --> 
    
    <div class="rdbox">
      <Cfparam name="form.studentid" default="">
       <form method="post" action="index.cfm?curdoc=tools/receiveHostApp">
        
        <table width=80%>
            <tr>
                <td colspan = 2>
            Please enter the ID(s) of the students that you want to mark host applciations approved for.  All host families that have been assigned this student will be presented and you can enter in the date the application was received. <br>
                </td>
            </tr>
            <tr>
                <td align="right">Student ID(s)</td><Td><input type="text" size=20 name="studentID" placeholder="EX: 12345,9876,6789"></Td>
            </tr>
            <tr>
                <td colspan=2 align="center"><input type="submit" value="Submit"></td>
            </tr>
        </table>
        </form>
       
                            </div>
    
    <div class="rdbottom"></div> <!-- end bottom --> 
    
</div>
</div>
        	
            <!--- Right Column --->
            <div style="width:49%;float:right;display:block;">

 <div class="rdholder" style="width:100%; float:right;"> 
   
    <div class="rdtop"> 
        <span class="rdtitle">Results</span> 
    </div> <!-- end top --> 
    
    <div class="rdbox" style="padding:20px;">
    <cfset submittedStudentList = ''>
      <form method="post" action="index.cfm?curdoc=tools/receiveHostApp">
     <input type="hidden" name="process" value="1" />
                           <cfoutput>
  <cfif form.studentid is ''>
 Please submit a student ID or list of ID's for results.
  <cfelse>
 <cfset listRow = 1> 
<Cfloop list="#form.studentid#" index=i>

	<!---get host info on student---->
    <cfquery name="getHostList" datasource="#application.dsn#">
    select distinct hh.hostid, h.familylastname, hh.dateReceived, hh.isWelcomeFamily, hh.historyID
    from smg_hosthistory hh
    left join smg_hosts h on h.hostid = hh.hostid
    where studentid in (<cfqueryparam value="#i#" cfsqltype="CF_SQL_integer" list="yes">) 
    and hh.hostid > 0
    order by historyid desc
    </cfquery>
    <cfquery name="currentHost" datasource="#application.dsn#">
    select hostid 
    from smg_students
    where studentid = <Cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
    </cfquery>
    <cfif getHostList.recordcount eq 0>
    <table width=95% cellpadding="10" cellspacing="0" bgcolor="##FC6" align="Center">
        <Tr>
            <Td align="center"><img src="pics/WarningSignMedium.png" height=100 /></Td>
    		<td><h2><font color="##000000">We could not find a student with the ID: <em>#i#</em></font></h2></td>
        </Tr>
    </table><br /><br />
    <cfelse>
    <cfset submittedStudentList = #ListAppend(submittedStudentList, #i#)#>
    <cfscript>
        // Get Student Info
            qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentid=i);
    </cfscript>
    <!--- Student Picture --->
        <cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#i#.*">
  <cfif listRow mod 2>
  <div style="padding:15px;background-color:##EDEFF4;">
  <cfelse>
  <div style="padding:15px;">
  </cfif>
    <table width=95% cellpadding="4" cellspacing="0" align="Center" >
        <Tr>
        
            <Td align="center"><!--- Use a cftry instead of cfif. Using cfif when image is not available CF throws an error. --->
            <div class="border">
             <cfif getHostList.recordcount eq 0>
                        <img src="pics/WarningSignMedium.png" />
                <cfelse>
                <cftry>
                
                    <cfscript>
                        // CF throws errors if can't read head of the file "ColdFusion was unable to create an image from the specified source file". 
                        // Possible cause is a gif file renamed as jpg. Student #17567 per instance.
                    
                        // this file is really a gif, not a jpeg
                        pathToImage = AppPath.onlineApp.picture & studentPicture.name;
                        imageFile = createObject("java", "java.io.File").init(pathToImage);
                        
                        // read the image into a BufferedImage
                        ImageIO = createObject("java", "javax.imageio.ImageIO");
                        bi = ImageIO.read(imageFile);
                        img = ImageNew(bi);
                    </cfscript>              
                    
                    <cfimage source="#img#" name="myImage">
                    <!---- <cfset ImageScaleToFit(myimage, 250, 135)> ---->
                    <cfimage source="#myImage#" action="writeToBrowser" border="0" width="135px"><br />
                   
                    
                    <cfcatch type="any">
                        <img src="pics/no_stupicture.jpg" width="135">
                    </cfcatch>
                    
                </cftry>
              
                </cfif>
             </div>
             </td>
             <Td valign="top">
                <span class="rdtitle" style="font-size: 16px;"><a href="https://ise.exitsapplication.com/nsmg/index.cfm?curdoc=student_info&studentID=#i#">#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (#i#)</a></span><br /><br />
                <cfif getHostList.recordcount eq 0>
                        There are no host families on record for #qGetStudentInfo.firstname#.
                <cfelse>
                
                	<table width=100% cellpadding=4 cellspacing="0">
                    	<tr>
                        	<td><strong>Family</strong></td><td><strong>App Received</strong></td><td><strong>Welcome</strong></td><td><strong>Current</strong> </td>					<cfset submittedHostList = "">
                    <Cfloop query="getHostList">
                    <cfset submittedHostList = #LIstAppend(submittedHostList, #hostid#)#>
                   		<tr  <Cfif hostid eq 0> bgcolor="##FC6"<<Cfelse><cfif currentrow mod 2>bgcolor="##a6bfe8"</cfif></cfif>>
                        	<td>#familylastname# (#hostid#)</td>
                            <td><Cfif hostid eq 0><em>Problem with HOST assignment</em><cfelse>
                            
                            
                            <input type="datefield" name=#i#_#hostid# size=10 <cfif NOT IsDate(dateReceived) is ''>onfocus="insertDate(this,'MM/DD/YYYY')"</cfif> value="#DateFormat(dateReceived, 'mm/dd/yyyy')#" size="8" maxlength="10"></Cfif>
                           
                            </td>
                          
                            <td><Cfif isWelcomeFamily eq 1>Yes<cfelse>No</Cfif></td>
                            <td><cfif currentHost.hostid eq #hostid#>Yes<cfelse>No</cfif> </td>
                        </tr>
                        <input type="hidden" name="hl_#studentid#" value="#submittedHostList#"/>
                    </Cfloop>
                    
                    </table>
       				
                </cfif>
             </Td>
         </tr>
     </table>
  </div>
     <br><br>
     <cfset listRow = listRow + 1>
   </cfif>
   
</cfloop>
<input type="hidden" name="submittedStudentList" value="#submittedStudentList#" />
<div align="center"><input type="image" src="pics/buttons/submit.png" /></div>
</cfif>
</cfoutput>
</form>
                          
                          
                          
                          
                        </div>
                        
                        <div class="rdbottom"></div> <!-- end bottom --> 
                        
                    </div>
 
       </div>