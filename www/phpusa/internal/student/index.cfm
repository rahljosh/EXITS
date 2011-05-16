<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		May 13, 2011
	Desc:		Index file of the student section
				
				#CGI.SCRIPT_NAME#?curdoc=student/index
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param local variables --->
	<cfparam name="action" default="list">
    <cfparam name="URL.uniqueID" default="" />
    
</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->

<cfif ListFind("1,2,3,4", CLIENT.userType)>
	
    <!--- Office Users --->
    
    <cfswitch expression="#action#">
    
        <cfcase value="flightInformation" delimiters=",">
    
            <!--- Include template --->
            <cfinclude template="_#action#.cfm" />
    
        </cfcase>
    
    
        <!--- The default case is the login page --->
        <cfdefaultcase>
            
            <!--- Include template --->
            <cfinclude template="_flightInformation.cfm" />
    
        </cfdefaultcase>
    
    </cfswitch>

<cfelse>
    
    <!--- Other Users Only Have Access to Certain Pages --->
    <cfswitch expression="#action#">
    
        <cfcase value="flightInformation,flightInformationList" delimiters=",">
    
            <!--- Include template --->
            <cfinclude template="_#action#.cfm" />
    
        </cfcase>
        
    
        <!--- The default case is the login page --->
        <cfdefaultcase>
            
            <!--- Include template --->
            <cfinclude template="_flightInformation.cfm" />
    
        </cfdefaultcase>
    
    </cfswitch>
    
</cfif>
