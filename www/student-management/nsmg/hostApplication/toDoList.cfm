<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
    	
    <link href="../linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
    <link href="css/hostApp.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../linked/css/colorbox2.css" />
 <!----
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	---->
	<script src="linked/js/jquery.colorbox.js"></script>
	
	<script>
        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            $(".iframe").colorbox({width:"80%", height:"80%", iframe:true, 
               onClosed:function(){ location.reload(true); } });
        });
    </script>
    
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
			.smlink         		{font-size: 11px;}
			.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #ffffff;}
			.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
			.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
			.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
			.sectionSubHead			{font-size:11px;font-weight:bold;}
			.alert{
				width:auto;
				height:55px;
				border:#666;
				background-color:#FF9797;
				text-align:center;
				-moz-border-radius: 15px;
				border-radius: 15px;
				vertical-align:center;
				}
			.clearfix {
				display: block;
				clear: both;
				height: 5px;
				width: 100%;
				}
		</style>
</head>
<body>

<Cfparam name="url.usertype" default="#client.usertype#">
<Cfparam name="usertype" default="#client.usertype#">
<Cfset client.hostid = #url.hostid#>




<!----Approve app if needed---->
<cfif isDefined('approveApp')>
    <cfquery name="appStatus" datasource="#application.dsn#">
    select hostAppStatus, familylastname, arearepid, regionid
    from smg_hosts
    where hostid = #client.hostid#
    </cfquery>
    
    <cfquery datasource="#application.dsn#">
        update smg_hosts set hostAppStatus = #client.usertype#
        where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
    </cfquery>
    <Cfquery name="repInfo" datasource="#application.dsn#">
    select email
    from smg_users
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.arearepid#">
    </Cfquery>
       <cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
        SELECT user_access_rights.advisorid, smg_users.email, smg_users.firstname
        FROM user_access_rights
        LEFT JOIN smg_users on smg_users.userid = user_access_rights.advisorid
        WHERE user_access_rights.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.arearepid#">
        AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.regionid#">
    </cfquery>
   
	
    <cfquery name="get_regional_director" datasource="#application.dsn#">
        SELECT smg_users.userid, smg_users.email, smg_users.firstname
        FROM smg_users
        LEFT JOIN user_access_rights on smg_users.userid = user_access_rights.userid
        WHERE user_access_rights.usertype = 5
        AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.regionid#">
        AND smg_users.active = 1
    </cfquery>
   

    <cfquery name="get_facilitator" datasource="#application.dsn#">
        SELECT smg_regions.regionfacilitator, smg_users.email, smg_users.firstname
        FROM smg_regions
        LEFT JOIN smg_users on smg_users.userid = smg_regions.regionfacilitator
        WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.regionid#">
    </cfquery>
   <cfif client.usertype eq 7>
   	<cfset mailTo = #get_regional_director.email#>
   <Cfelseif client.usertype eq 6>
   	<cfset mailTo = #get_regional_director.email#>
   <cfelseif client.usertype eq 5>
   	<cfset mailTo = #get_facilitator.email#>
   <cfelseif client.usertype lte 4>
   	<cfset mailTo = "#get_regional_director.email#,#repInfo.email#">
   </cfif>
   <cfif client.usertype lte 4>
      	<cfsavecontent variable="nextLevel">                      
		<cfoutput>
        Great News!<br />
          The #appStatus.familylastname# application has been approved by #client.name#.
        
        </cfoutput>
    </cfsavecontent>
   
   <Cfelse>
   	<cfsavecontent variable="nextLevel">                      
		<cfoutput>
          The #appStatus.familylastname# application has been approved by #client.name# and is ready for your approval. 
        <br /><br />  
          You can review the app <a href="http://111cooper.com/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=#client.usertype#">here</a>.
        
        
        </cfoutput>
    </cfsavecontent>
    </cfif>
    <cfinvoke component="nsmg.cfc.email" method="send_mail">
   
        <cfinvokeargument name="email_to" value="#mailTo#">
		<!---
        <cfinvokeargument name="email_cc" value="#client.email#">
		---->
        <cfinvokeargument name="email_subject" value="#appStatus.familylastname# App Needs your Approval">
        <cfinvokeargument name="email_message" value="#nextLevel#">
        <cfinvokeargument name="email_from" value="#client.email#">
    </cfinvoke>
<cfoutput>
   <div align="center"><h2>Application has been marked Approved.  Email notificaiton was sent to #mailto#</h2></div>
</cfoutput>
</cfif>

<cfquery name="appStatus" datasource="#application.dsn#">
select hostAppStatus, fatherlastname, motherlastname, motherfirstname, fatherfirstname, familylastname, email, city, state, password, hostid
from smg_hosts
where hostid = #client.hostid#
</cfquery>

<cfoutput>

</cfoutput>
<cfform method="post" action="?curdoc=hostApplication/toDoList&status=#url.status#&hostid=#client.hostid#">


</cfform>     
	
<!---Get items that need to be checked---->
<cfquery name="toDoList" datasource="#application.dsn#">
    SELECT *
    FROM smg_ToDoList 
    where whoViews LIKE '%#client.usertype#%'
    order by listOrder
</cfquery>

<cfquery name="approvalList" datasource="#application.dsn#">
	SELECT *
    FROM smg_ToDoList
    where isRequiredForApproval LIKE '%#client.usertype#%'
</cfquery>

<!---set up hide scripts---->
<cfoutput>
<cfloop query="toDoList">
<script type="text/javascript">
	function ShowHide#toDoList.currentrow#(){
	$("##denialReason#toDoList.currentrow#").animate({"height": "toggle"}, { duration: 1000 });
	}
</script>

</cfloop>

</cfoutput>

<cfif client.usertype eq 7>
	<Cfset approvalLevel = 'approvalDates.areaRepApproval'>
<Cfelseif client.usertype eq 6>
	<Cfset approvalLevel = 'approvalDates.regionalAdvisorApproval'>
<Cfelseif client.usertype eq 5>
	<Cfset approvalLevel = 'approvalDates.regionalDirectorApproval'>
<Cfelseif client.usertype lte 4>
	<Cfset approvalLevel = 'approvalDates.facApproval'>
</cfif>



    <!----Get the references ---->
    <cfquery name="references" datasource="#application.dsn#">
    select fr.firstname, fr.lastname, fr.phone, fr.refid, fr.approved, fr.approved
    from smg_family_references fr
    where fr.referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostID#">
    </cfquery>


	
<cfif isDefined('url.status')>
 	<cfset client.appStatus = #url.status#>
</cfif>

 <!----Personal Information---->
		   <div class="rdholder" style="width:100%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Host Family Summary</span> 
              
				
            	</div> <!-- end top --> 
             <div class="rdbox">
             <Cfoutput>
<table width=30% align="Center">
	<tr>
    	<th align="left">Family</th><th align="left">Login Info</th>
    </tr>
    	<td><cfif appStatus.fatherfirstname is not ''>#appStatus.fatherfirstname#</cfif> <cfif appStatus.fatherfirstname is not '' and appStatus.motherfirstname is not ''>& </cfif>#appStatus.motherfirstname# #appStatus.familylastname# (#appStatus.hostid#)<br />#appStatus.city# #appStatus.state#</td>
        <td>#appStatus.email#<br />#appStatus.password#</td>
    </tr>
</table>
</Cfoutput>
</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
          
    <!----To Do List---->
		   <div class="rdholder" style="width:100%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">To Do List for Application Approval</span> 
              	<Cfoutput><a href="?curdoc=hostApplication/listOfApps&status=#client.appStatus#" class="floatRight"><img src="pics/buttons/back.png" border=0 /></a></Cfoutput>
				
            	</div> <!-- end top --> 
             <div class="rdbox">
 <cfform action="hostApplication/toDoList.cfm" method="post" preloader="no">        
 <cfoutput>  
 
 <div align="center">
 	<table>
   		<tr>
        	<td valign="center"><img src="pics/information.png" width=16 heigh=16>No Action Required</td>
            <td valign="center"><img src="pics/warning.png" width=16 heigh=16>Approval Required</td>
            <td valign="center"><img src="pics/valid.png" width=16 heigh=16> Approved</td> 
            <td valign="center"><img src="pics/error.gif" width=16 heigh=16> Item Denied</td>
            
        </tr>
    </table>
 </div>
 
	<table width=100% cellpadding=8 cellspacing="0">
        <tr bgcolor="##1b99da">
            	<td><h2><font color="##FFFFFF">Status</h2></font></td>
                <td><h2><font color="##FFFFFF">Item</h2></font></td>
                <td><h2><font color="##FFFFFF">Action</h2></font></td>
                <td><h2><font color="##FFFFFF">Area Rep</h2></font></td>
                <td><h2><font color="##FFFFFF">Advisor</h2></font></td>
                <td><h2><font color="##FFFFFF">Manager</h2></font></td>
                <td><h2><font color="##FFFFFF">Facilitator</h2></font></td>
                
            </tr>
       <cfset itemsNeedApproved = #approvalList.recordcount# + #references.recordcount# - 2>
       <cfset itemsApproved = 0> 
       
       <cfloop query="toDoList">
       <cfset appLevelDenied = 0>
       <cfquery datasource="#application.dsn#" name="approvalDates">
       select *
       from smg_ToDoListDates
       where itemid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
       and fk_hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostID#">
       </cfquery>
      <cfif approvalDates.areaRepDenial is not '' 
	  	OR approvalDates.regionalAdvisorDenial is not ''
		OR approvalDates.regionalDirectorDenial is not ''
		OR approvalDates.facDenial is not ''>
        <cfset appLevelDenied = 1>
      </cfif>
      
    
      <!----Figure out of if available for approval--->
      
      	
     
       	<tr <cfif appLevelDenied eq 1>bgcolor="##fddfdc" <cfelseif currentRow mod 2> bgcolor="##F7F7F7"</cfif>>
            	<Td>
                <cfif ListFind(isRequiredForApproval, client.usertype)>
        		<cfif appLevelDenied eq 1>
                	<a onclick="ShowHide#toDoList.currentrow#(); return false;" href="##"><font color="##993333"> <img src="pics/error.gif" width=16 heigh=16></a>
                <cfelseif #Evaluate(approvalLevel)# is ''> 
               		<img src="pics/warning.png" width=16 heigh=16>
                <cfelse>
               		<img src="pics/valid.png" width=16 heigh=16>
                </cfif>
                <cfelse>
                	<img src="pics/information.png" width=16 heigh=16>
                </cfif>
                </Td>
                <td>#description#</td>
                <Cfif 1 eq 2>
                    <td colspan=4><em><font color="##ccc">No student assigned, student assignment needed for this item.
                    <Cfelse>
                <td>
                	<cfif listFind("View Visit Report", linkDesc)>
                    	<a href="#link#?itemID=#id#&userType=#client.usertype#" target="_blank">#linkDesc#</a>
                    <cfelse>
                    	<a href="#link#?itemID=#id#&userType=#client.usertype#" class="iframe">#linkDesc#</a>
                    </cfif>
                </td> 
				<td><Cfif listFind(whoViews, 7)>
                	<!----If the Area Rep should approve, show mask or date of approval, if not, show N/A---->
						<cfif approvalDates.areaRepApproval is '' and approvalDates.areaRepDenial is ''>
                            <font color="##ccc">MM/DD/YYYY</font>
                        <cfelseif approvalDates.areaRepDenial is not ''>
                        	<a onclick="ShowHide#toDoList.currentrow#(); return false;" href="##"> <strong><font color="##993333">#DateFormat(approvalDates.areaRepApproval, 'MM/DD/YYYY')#</font></strong></a>
                        <cfelse>
                             #DateFormat(approvalDates.areaRepApproval, 'MM/DD/YYYY')#
                             <Cfif client.usertype eq 7>
                             	<cfset itemsApproved = #itemsApproved# + 1>
                             </Cfif> 
                        </cfif>
                     <cfelse>
                     <font color="##ccc"><em>N/A</em></font>
                     </Cfif>
                </td>
                <td><Cfif listFind(whoViews, 6)>
                	<!----If the Area Rep should approve, show mask or date of approval, if not, show N/A---->
						<cfif approvalDates.regionalAdvisorApproval is '' and approvalDates.regionalAdvisorDenial is ''>
                            <font color="##ccc">MM/DD/YYYY</font>
                        <cfelseif approvalDates.regionalAdvisorDenial is not ''>
                        	<a onclick="ShowHide#toDoList.currentrow#(); return false;" href="##"> <strong><font color="##993333">#DateFormat(approvalDates.regionalAdvisorApproval, 'MM/DD/YYYY')#</font></strong></a>
                        <cfelse>
                             #DateFormat(approvalDates.regionalAdvisorApproval, 'MM/DD/YYYY')#
                             <Cfif client.usertype eq 6>
                             	<cfset itemsApproved = #itemsApproved# + 1>
                             </Cfif> 
                        </cfif>
                     <cfelse>
                     <font color="##ccc"><em>N/A</em></font>
                     </Cfif>
                </td>
                <td>
               		 <cfif approvalDates.regionalDirectorApproval is '' and approvalDates.regionalDirectorDenial is ''>
                    	<font color="##ccc">MM/DD/YYYY</font>
                     <cfelseif approvalDates.regionalDirectorDenial is not ''>
                        	<a onclick="ShowHide#toDoList.currentrow#(); return false;" href="##"> <strong><font color="##993333">#DateFormat(approvalDates.regionalDirectorApproval, 'MM/DD/YYYY')#</strong></font></a>
                    <cfelse>
                    	 #DateFormat(approvalDates.regionalDirectorApproval, 'MM/DD/YYYY')#
                         <Cfif client.usertype eq 5>
                             	<cfset itemsApproved = #itemsApproved# + 1>
                             </Cfif> 
                	</cfif>
                </td>
                <td>
                	<cfif approvalDates.facApproval is '' and approvalDates.facDenial is ''>
                    	<font color="##ccc">MM/DD/YYYY</font>
                    <cfelseif approvalDates.facDenial is not ''>
                        	<a onclick="ShowHide#toDoList.currentrow#(); return false;" href="##"><font color="##993333">  <strong>#DateFormat(approvalDates.facApproval, 'MM/DD/YYYY')#</strong></font></a>
                    <cfelse>
                    	 #DateFormat(approvalDates.facApproval, 'MM/DD/YYYY')#
                          <Cfif client.usertype lte 4>
                             	<cfset itemsApproved = #itemsApproved# + 1>
                             </Cfif> 
                	</cfif>
                </td>
                </cfif>
         	</tr>
        	 <Tr id="denialReason#toDoList.currentRow#" style="display: none;"  bgcolor="##FFC2BC">
             	  
	     	     <td align="left" colspan=7 >
                 <em>
                 <Cfif approvalDates.areaRepDenial is not ''>
                 Area Rep Denied for: #approvalDates.areaRepDenial#<br />
                 </Cfif>
                 <Cfif approvalDates.regionalDirectorDenial is not ''>
                 Reg. Director Denied for: #approvalDates.regionalDirectorDenial#<br />
                 </Cfif>
                 <Cfif approvalDates.facDenial is not ''>
                 Facilitator Denied for: #approvalDates.facDenial#<br />
                 </Cfif>
                 </em>
                   </td>
                   
             </Tr>
        
 
       </cfloop>     
           <!---References: Everyone Sees these---->
            <tr bgcolor="##ccc">
            	
                <td colspan="7" align="center" ><h2>&lt;&lt; References &gt;&gt;</h2></td>
            
              
                
                <cfloop query="references">
                
                <cfquery name="dateInfo" datasource="#application.dsn#">
                select RQT.id, RQT.arApproved, RQT.rdApproved, RQT.rmApproved, RQT.nyApproved, RQT.dateInterview, smg_users.firstname, smg_users.lastname
     			from hostRefQuestionaireTracking RQT
                left join smg_users on RQT.interviewer = smg_users.userid
                where  RQT.fk_ReferencesID = #refid#
                </cfquery>
               
                
                
                <tr <cfif dateInfo.currentrow mod 2> bgcolor="##F7F7F7"</cfif>>
                    <td>
					 <Cfif approved neq 2 >
					<img src="pics/warning.png" width=16 heigh=16>
                    	<cfelse><img src="pics/valid.png" width=16 heigh=16></Cfif></td>
                        
                        
                        
                        <td>#firstname# #lastname# - #phone#</td>
                    
                    
                    
                    <td>
                    
                    	<Cfif dateInfo.arApproved is not ''  OR  dateInfo.rdApproved is not '' OR  dateInfo.nyApproved is not '' OR  dateInfo.rmApproved is not ''  >	 
                         <a  href="forms/viewHostRefrencesQuestionaire.cfm?reportid=#dateInfo.id#" target="_blank">View Report</a> <!--- class="iframe" --->
                         <cfset itemsApproved = #itemsApproved# + 1>
                        <cfelse>
                            <a class="iframe" href="forms/hostRefrencesQuestionaire.cfm?ref=#refid#&rep=#client.userid#&hostid=#hostid#" >Submit Report</a>
                        </Cfif>
                   
						
                           
                    </td>
                    <td colspan=3 align="left">
                    <Cfif dateInfo.recordcount gt 0>
                    Report submitted on #DateFormat(dateInfo.dateInterview,'mm/dd/yyyy')# by #dateInfo.firstname# #dateInfo.lastname# - <cfif approved eq 2><em>Approved</em><cfelseif approved eq 3><em>Rejected</em><cfelse><em>Pending Approval</em></cfif>
                    <cfelse>
                    No report has been submitted.
                    </Cfif>
                    </td>
               	<td></td>
                </tr>
                </cfloop>
         
            </table>

     </cfoutput> 
</cfform>           
<br /><br />

 <cfif appStatus.hostAppStatus lt client.usertype>
 <div align="center"><h3>Application has been approved.</h3></div>
 
 <cfelse>

<table cellpadding=10 align="center">
	<tr>
    
    	
    	<td>
        <a class="iframe" href="hostApplication/denyHostApp.cfm">
        	<img  src="pics/buttons/deny.png" width=90% border=0>
            </a>
        
        </td><td>&nbsp;</td><Td>
        <cfif itemsNeedApproved neq itemsApproved>
        <img src="pics/buttons/approveButBW.png" width="90%" />
        <Cfelse>
        <cfoutput>
        <form method="post" action="?curdoc=hostApplication/toDoList&status=#url.status#&hostid=#client.hostid#">
        	<input type="hidden" name="approveApp" value=1/>
        	<input type="image" src="pics/buttons/approveBut.png" width=90%>
        </form>
        </cfoutput>
        </cfif>
        </Td>
    </tr>
</table> 
</cfif>
			</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
</body>
</html>