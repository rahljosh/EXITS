<Cfoutput>

</Cfoutput>
<Cfif isDefined('form.deny')>
  <cfif isDefined('processDeny')>
    <cfif form.denyReason is ''>
    <table bgcolor="#FFFF99" align="Center">
    	<tr>
        <td><img src="../pics/error.gif" /></td>
        	<td>
    Please provide a reason that you are denying this portion of the application.
    		</td>
        </tr>
     </table>
        	
    <cfelse>
		<cfoutput>
        
                <cfscript>
                // Get update ToDoList
                updateToDoList = APPLICATION.CFC.UDF.updateHostAppToDoList(hostID=client.hostid,studentID=client.studentid,itemid=url.itemid,usertype=url.usertype,denyApp=1);
                </cfscript>
                
                  <div align="center">
                
                <h1>Succesfully Submited.</h1>
                <em>this window should close shortly</em>
                </div>
            
                 <body onLoad="parent.$.fn.colorbox.close();">
                    <cfabort>
					
        
        </cfoutput>
       </cfif>
    </cfif>


	<div align="center">
    <h2>Please enter the reason you are denying this item. </h2>
    <em> Host Family will see this message.</em><br />
    <cfoutput>
    <form method="post" action="#listlast(cgi.script_name,"/")#?itemID=#url.itemID#&userType=#url.usertype#">
    <input type="hidden" name="deny" value="1" />
    <input type="hidden" name="processDeny" value=1>
    <textarea cols="60" rows="20" name="denyReason" placeholder="More information is needed regarding...."></textarea><br />
    
    <input type="image" src="../pics/buttons/Next.png" />
    </div>
    </form>
    </cfoutput>
	<cfabort>
</Cfif>

<cfif isDefined('form.approve')>


			<cfscript>
			// Get update ToDoList
			updateToDoList = APPLICATION.CFC.UDF.updateHostAppToDoList(hostID=client.hostid,studentID=client.studentid,itemid=url.itemid,usertype=url.usertype,denyApp=0);
			</cfscript>
              <div align="center">
            
            <h1>Succesfully Submited.</h1>
            <em>this window should close shortly</em>
            </div>
         
             <body onload="parent.$.fn.colorbox.close();">
                <cfabort>
</cfif>