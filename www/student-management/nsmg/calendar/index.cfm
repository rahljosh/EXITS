
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
        
        <h3 style="margin-top:10px;">&laquo; Recorded WebEx sessions available &raquo;</h3>

        <p>     
            [ &nbsp;
            
            <a href=" https://iseusa1.webex.com/iseusa1/lsr.php?RCID=ae3f0ad1448874a199514a32bb2998be" target="_blank">Database Navigation</a>
            
            &nbsp; &nbsp; | &nbsp; &nbsp;
            
            <a href="https://iseusa1.webex.com/iseusa1/lsr.php?RCID=5d09651fee3e22a25290d4b05a6be210" target="_blank">Department of State Regulations</a> 
            
            &nbsp; &nbsp; | &nbsp; &nbsp;
            
            <a href="https://iseusa1.webex.com/iseusa1/lsr.php?RCID=b778af8ab65efb03707587e3e796f3e7" target="_blank">Effective Recruitment</a>
            
            &nbsp; &nbsp; | &nbsp; &nbsp;
            
            <a href="https://iseusa1.webex.com/iseusa1/lsr.php?RCID=f13fea953adaedd873eea733064d6d15" target="_blank">Networking Your Way to Placements</a>
            
            &nbsp; &nbsp; | &nbsp; &nbsp;
            
            <a href="https://iseusa1.webex.com/iseusa1/lsr.php?RCID=5320c05c9c6376b761689d0e29dc7008" target="_blank">Quick Start</a>
            
            &nbsp; &nbsp; | &nbsp; &nbsp;
            
            <a href="https://iseusa1.webex.com/iseusa1/lsr.php?RCID=4bbb1e667fed8c66de5321d92813120f" target="_blank">LinkedIn - Part 1 </a>
            
            &nbsp; &nbsp; | &nbsp; &nbsp;
            
            <a href="https://iseusa1.webex.com/iseusa1/lsr.php?RCID=c6616b74c6283158f8ad7040b7588cfa" target="_blank">LinkedIn - Part 2 </a>
            
            &nbsp; &nbsp; | &nbsp; &nbsp;
            
            <a href="https://iseusa1.webex.com/iseusa1/lsr.php?RCID=21427cc3dbb0b68a164ba06950365786" target="_blank">Facebook Marketing Tips </a>
            
            <!--- Removed as Per Paul Session Request - 09/28/2012
            &nbsp; &nbsp; | &nbsp; &nbsp;
            
            <a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3457042&rKey=a9e6bbf7446fdd27" target="_blank">New Area Reps</a> 
            
            &nbsp; &nbsp; | &nbsp; &nbsp;
           
            <a href="https://iseusa1.webex.com/iseusa1/lsr.php?AT=pb&SP=EC&rID=3692602&rKey=5ba0602384323b89" target="_blank" style="width:300px;">New Lead System</a>
            --->
            
            &nbsp; ]
        </p>
    </cfsavecontent>
    
</cfsilent>

<!--- Figure out which action to include. --->
<cfswitch expression="#REQUEST.Attributes.action#">
	
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
	
	<cfdefaultcase>
		<cfinclude template="_month.cfm" />
	</cfdefaultcase>
	
</cfswitch>
