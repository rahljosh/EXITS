
<!--- Kill extra output. --->
<cfsilent>

	<!--- Include funcitons. --->
	<cfinclude template="./includes/_functions.cfm" />
	
	<!--- Include common config setup. --->
	<cfinclude template="_config.cfm" />
	
		
	<!--- Combine FORM and URL scopes into the attributes scope. --->
	<cfset REQUEST.Attributes = StructCopy( URL ) />
	<cfset StructAppend( REQUEST.Attributes, FORM ) />
   
	<!--- Param the URL attributes. --->
	<cfparam
		name="REQUEST.Attributes.action"
		type="string"
		default="month"
		/>

	<cfscript>
		// Added by Marcus Melo 03/12/2010
		if ( NOT LEN(REQUEST.Attributes.action) ) {
			REQUEST.Attributes.action = 'month';
		}	
	</cfscript>
				
	<!--- Set the default date for this page request. --->
	<cfset REQUEST.DefaultDate = Fix( Now() ) />
	
    <cfsavecontent variable="scheduledSessions">
        
            <p>
            	&raquo; <a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3771082&rKey=7092fd35f85dfe83" target="_blank">Database Navigation</a> 
            </p>
        
            <p>
            	&raquo; <a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3680852&rKey=962a228bb9d3c2d2" target="_blank">Department of State Regulations</a> 
            </p>

            <p>
	            &raquo; <a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3469892&rKey=c358e2605164895e" target="_blank">Host Family Recruitment</a>
    		</p>
			
            <p>                    
	            &raquo; <a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3457042&rKey=a9e6bbf7446fdd27" target="_blank">New Area Reps</a> 
    		</p>
                    
            <p>           
	            &raquo; <a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3692602&rKey=5ba0602384323b89" target="_blank" style="width:300px;">New Lead System</a>
			</p>

        <!--- Phasing Out Calendar as per Gary Lubrat request on 06/02/2011 ---->
        <!--- <h3 style="margin-top:10px;">&laquo; Recorded WebEx sessions available &raquo;</h3>
		<p>     
			[ &nbsp;
			
			<a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3680852&rKey=962a228bb9d3c2d2" target="_blank">Department of State Regulations</a> 
			
			&nbsp; &nbsp; | &nbsp; &nbsp;
		
			<a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3469892&rKey=c358e2605164895e" target="_blank">Host Family Recruitment</a>
			
			&nbsp; &nbsp; | &nbsp; &nbsp;
			
			<a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3457042&rKey=a9e6bbf7446fdd27" target="_blank">New Area Reps</a> 
			
			&nbsp; &nbsp; | &nbsp; &nbsp;
		   
			<a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3692602&rKey=5ba0602384323b89" target="_blank" style="width:300px;">New Lead System</a>
			
			&nbsp; ]
		</p>
		--->
    </cfsavecontent>
    
</cfsilent>

<!--- Figure out which action to include. --->
<cfswitch expression="#REQUEST.Attributes.action#">
	
    <!--- Phasing Out Calendar as per Gary Lubrat request on 06/02/2011 ---->
    <!---
	<cfcase value="edit">
		<cfinclude template="_edit.cfm" />
	</cfcase>
	
	<cfcase value="delete">
		<cfinclude template="_delete.cfm" />
	</cfcase>
	
	<cfcase value="view">
		<cfinclude template="_view.cfm" />
	</cfcase>
	
	<cfcase value="day">
		<cfinclude template="_day.cfm" />
	</cfcase>
	
	<cfcase value="week">
		<cfinclude template="_week.cfm" />
	</cfcase>
	
	<cfcase value="month">
		<cfinclude template="_month.cfm" />
	</cfcase>
	
	<cfcase value="year">
		<cfinclude template="_year.cfm" />
	</cfcase>
	--->
    
	<cfdefaultcase>
		<cfinclude template="_month.cfm" />
	</cfdefaultcase>
	
</cfswitch>
