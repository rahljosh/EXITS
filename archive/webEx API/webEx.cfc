<!--- ------------------------------------------------------------------------- ----
	
	File:		webEx.cfc
	Author:		Marcus Melo
	Date:		March, 05 2010
	Desc:		This holds the functions needed to manage webEx

	Development:
	http://developer.webex.com/meetingservices
	user: marcusmelo
	pass: Exchange1

	Try the WebEx APIs
	You can try out the WebEx APIs before you commit to the developer program, this will help you determine if the APIs will fit your needs. 
	A signup form is provided below that you can use to create a host account on our shared test site, https://apidemoeu.webex.com. 
	Because this is a shared site, site admin privileges cannot be granted and you will be limited to APIs that do not require admin level access.
	You will need the site id and partner id for this site to use most of the API commands. You can find this information below:
	
	Site ID: 243585
	Partner ID: g0webx!

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="webEx"
	output="false" 
	hint="A collection of functions for the webEx">
    
    <!--- Return the initialized webEx object --->
	<cffunction name="Init" access="public" returntype="webEx" output="false" hint="Returns the initialized webEx object">

		<cfscript>	
			// Declare local variables

			// Development - Set Up WebEx Variables
			if ( APPLICATION.isServerLocal ) {

				webExURL = 'https://apidemoeu.webex.com/WBXService/XMLService';	
				webExUser = 'iseusadev';
				webExPassword = 'Exchange1dev';
				webExSiteID = '243585';
				webExPartnerID = 'g0webx!';
				
			// Production - Set Up WebEx Variables
			} else {
				
				webExURL = 'https://iseusa.webex.com/WBXService/XMLService';    
				webExUser = 'iseusa';
				webExPassword = 'Exchange1';
				webExSiteID = '';
				webExPartnerID = '';
			
			}

			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>

	</cffunction>


	<!--- User --->

	<cffunction name="authenticateUser" access="public" returntype="struct" output="false" hint="The AuthenticateUser API will accept a SAML assertion in place of a user password.">
               
			<cfscript>
				// Create Structure Result
				batchResult = createResultStruct();
			</cfscript>
            
            <!--- Create XML --->
            <cfoutput>
                
                <cfsavecontent variable="bodyContent">
                    <bodyContent
	                    xsi:type="java:com.webex.service.binding.user.AuthenticateUser">
    	                <!--- <samlResponse>samlResponse message will go here</samlResponse> --->
                    </bodyContent>
				</cfsavecontent>      
                     
			</cfoutput>

			<!--- Submit XML --->
            <cfscript>
				// Submit XML File
				responseXML = submitXML(bodyContent);			
			</cfscript>

        <cfreturn batchResult>
	</cffunction>


	<cffunction name="createUser" access="public" returntype="struct" output="false" hint="Allows site administrators to creates a new user for your WebEx-hosted Web sites.">
		<cfargument name="firstName" type="string" hint="firstName is required">
        <cfargument name="lastName" type="string" hint="lastName is required">
        <cfargument name="webExUser" type="string" hint="webExUser is required">
        <cfargument name="email" type="string" hint="email is required">
        <cfargument name="password" type="string" hint="password is required">
        <cfargument name="privilegeHost" type="string" default="false" hint="privilegeHost is not required">
        <cfargument name="active" type="string" default="ACTIVATED" hint="active is not required">
        <cfargument name="welcomeMessage" type="string" default="Welcome to ISE USA WebEX!" hint="welcomeMessage is not required">
        <cfargument name="headerImageBranding" type="string" default="false" hint="headerImageBranding is not required">
        <cfargument name="defaultSessionType" type="string" default="100" hint="defaultSessionType is not required">
        <cfargument name="defaultServiceType" type="string" default="EventCenter" hint="defaultServiceType is not required">
        <cfargument name="autoDeleteAfterMeetingEnd" type="string" default="false" hint="autoDeleteAfterMeetingEnd is not required">
        <cfargument name="displayQuickStartHost" type="string" default="true" hint="displayQuickStartHost is not required">
        <cfargument name="displayQuickStartAttendees" type="string" default="false" hint="displayQuickStartHost is not required">

			<cfscript>
				// Create Structure Result
				batchResult = createResultStruct();
			</cfscript>
        	
            <!--- Create XML --->
            <cfoutput>
                
                <cfsavecontent variable="requestXML">
                    <bodyContent
                        xsi:type="java:com.webex.service.binding.user.CreateUser">
                        <firstName>#ARGUMENTS.firstName#</firstName>
                        <lastName>#ARGUMENTS.lastName#</lastName>
                        <webExUser>#ARGUMENTS.webExUser#</webExUser>
                        <email>#ARGUMENTS.email#</email>
                        <password>#ARGUMENTS.password#</password>
                        <privilege>
                            <host>#ARGUMENTS.privilegeHost#</host>
                        </privilege>
                        <active>#ARGUMENTS.active#</active>
                        <personalMeetingRoom>
                            <welcomeMessage>#ARGUMENTS.welcomeMessage#</welcomeMessage>
                            <headerImageBranding>#ARGUMENTS.headerImageBranding#</headerImageBranding>
                        </personalMeetingRoom>
                        <sessionOptions>
                            <defaultSessionType>#ARGUMENTS.defaultSessionType#</defaultSessionType>
                            <defaultServiceType>#ARGUMENTS.defaultServiceType#</defaultServiceType>
                            <autoDeleteAfterMeetingEnd>#ARGUMENTS.autoDeleteAfterMeetingEnd#</autoDeleteAfterMeetingEnd>
                            <displayQuickStartHost>#ARGUMENTS.displayQuickStartHost#</displayQuickStartHost>
                            <displayQuickStartAttendees>#ARGUMENTS.displayQuickStartAttendees#</displayQuickStartAttendees>
                        </sessionOptions>
                        <supportCenter>
                            <orderTabs>
                                <tab>Tools</tab>
                                <tab>Desktop</tab>
                                <tab>Application</tab>
                                <tab>Session</tab>
                            </orderTabs>
                        </supportCenter>
                    </bodyContent>
				</cfsavecontent>
                
			</cfoutput>

			<!--- Submit XML --->
            <cfscript>
				// Submit XML File
				responseXML = submitXML(requestXML);			
			</cfscript>
            
	    <cfreturn batchResult>
	</cffunction>


	<cffunction name="deleteUser" access="public" returntype="struct" output="false" hint="Deletes the specified user from your site. Allows for up to 50 users to be deleted at a time.">
		<cfargument name="webExID" type="string" hint="webExID is required">
        
			<cfscript>
				// Create Structure Result
				batchResult = createResultStruct();
			</cfscript>
        	
            <!--- Create XML --->
            <cfoutput>
                
                <cfsavecontent variable="requestXML">
                    <bodyContent xsi:type="java:com.webex.service.binding.user.DelUser">
                        <webExId>#ARGUMENTS.webExID#</webExId> <!--- johnson1 --->
                        <syncWebOffice>true</syncWebOffice>
                    </bodyContent>
				</cfsavecontent>
                
			</cfoutput>

			<!--- Submit XML --->
            <cfscript>
				// Submit XML File
				responseXML = submitXML(requestXML);			
			</cfscript>
            
	    <cfreturn batchResult>
	</cffunction>


	<cffunction name="getUser" access="public" returntype="struct" output="false" hint="Retrieves detailed information about the specified user.">
		<cfargument name="webExID" type="string" hint="webExID is required">
        
			<cfscript>
				// Create Structure Result
				batchResult = createResultStruct();
			</cfscript>
        	
            <!--- Create XML --->
            <cfoutput>
                
                <cfsavecontent variable="requestXML">
                    <bodyContent xsi:type="java:com.webex.service.binding.user.GetUser">
                    	<webExId>#ARGUMENTS.webExID#</webExId>
                    </bodyContent>
				</cfsavecontent>
                
			</cfoutput>

			<!--- Submit XML --->
            <cfscript>
				// Submit XML File
				responseXML = submitXML(requestXML);			
			</cfscript>
            
	    <cfreturn batchResult>
	</cffunction>


	<cffunction name="listUser" access="public" returntype="struct" output="false" hint="Lists summary information of the users on your site.">
        
			<cfscript>
				// Create Structure Result
				batchResult = createResultStruct();
			</cfscript>
        	
            <!--- Create XML --->
            <cfoutput>
                
                <cfsavecontent variable="requestXML">
                    <bodyContent
                        xsi:type="java:com.webex.service.binding.user.LstsummaryUser">
                        <listControl>
                            <serv:startFrom>1</serv:startFrom>
                            <serv:maximumNum>10</serv:maximumNum>
                            <serv:listMethod>AND</serv:listMethod>
                        </listControl>
                        <order>
                            <orderBy>UID</orderBy>
                            <orderAD>ASC</orderAD>
                        </order>
                        <dataScope>
                            <regDateStart>03/10/2004 01:00:00</regDateStart>
                            <regDateEnd>04/01/2004 10:00:00</regDateEnd>
                        </dataScope>
                    </bodyContent>
				</cfsavecontent>
                
			</cfoutput>

			<!--- Submit XML --->
            <cfscript>
				// Submit XML File
				responseXML = submitXML(requestXML);			
			</cfscript>
            
	    <cfreturn batchResult>
	</cffunction>


	<cffunction name="setUser" access="public" returntype="struct" output="false" hint="Allows site administrators to update the information of an existing user.">
		<cfargument name="firstName" type="string" default="" hint="firstName is required">
        <cfargument name="lastName" type="string" default="" hint="lastName is required">
        <cfargument name="email" type="string" default="" hint="email is required">
        <cfargument name="password" type="string" default="" hint="password is required">
        <cfargument name="privilegeHost" type="string" default="false" hint="privilegeHost is required">
        <cfargument name="active" type="string" default="ACTIVATED" hint="active is required">
        <cfargument name="welcomeMessage" type="string" default="" hint="welcomeMessage is required">
        <cfargument name="headerImageBranding" type="string" default="" hint="headerImageBranding is required">
        <cfargument name="defaultSessionType" type="string" default="" hint="defaultSessionType is required">
        <cfargument name="defaultServiceType" type="string" default="" hint="defaultServiceType is required">
        <cfargument name="autoDeleteAfterMeetingEnd" type="string" default="" hint="autoDeleteAfterMeetingEnd is required">
        <cfargument name="displayQuickStartHost" type="string" default="" hint="displayQuickStartHost is required">
        <cfargument name="displayQuickStartAttendees" type="string" default="" hint="displayQuickStartHost is required">

			<cfscript>
				// Create Structure Result
				batchResult = createResultStruct();
			</cfscript>
        	
            <!--- Create XML --->
            <cfoutput>
                
                <cfsavecontent variable="requestXML">
                    <bodyContent
                        xsi:type="java:com.webex.service.binding.user.CreateUser">
                        <firstName>aa</firstName>
                        <lastName>bb</lastName>
                        <webExUser>test102</webExUser>
                        <email>test102@webex.com</email>
                        <password>pass</password>
                        <privilege>
                            <host>#ARGUMENTS.privilegeHost#</host>
                        </privilege>
                        <active>#ARGUMENTS.active#</active>
                        <personalMeetingRoom>
                            <welcomeMessage>This is welcome message</welcomeMessage>
                            <headerImageBranding>false</headerImageBranding>
                        </personalMeetingRoom>
                        <sessionOptions>
                            <defaultSessionType>100</defaultSessionType>
                            <defaultServiceType>EventCenter</defaultServiceType>
                            <autoDeleteAfterMeetingEnd>false</autoDeleteAfterMeetingEnd>
                            <displayQuickStartHost>true</displayQuickStartHost>
                            <displayQuickStartAttendees>false</displayQuickStartAttendees>
                        </sessionOptions>
                        <supportCenter>
                            <orderTabs>
                                <tab>Tools</tab>
                                <tab>Desktop</tab>
                                <tab>Application</tab>
                                <tab>Session</tab>
                            </orderTabs>
                        </supportCenter>
                    </bodyContent>
				</cfsavecontent>
                
			</cfoutput>

			<!--- Submit XML --->
            <cfscript>
				// Submit XML File
				responseXML = submitXML(requestXML);			
			</cfscript>
            
	    <cfreturn batchResult>
	</cffunction>


	<!--- Meetings --->

	<cffunction name="getMeetings" access="public" returntype="struct" output="false" hint="Gets WebEx Meetings">

			<cfscript>
				// Create Structure Result
				batchResult = createResultStruct();
			</cfscript>
            
            <!--- Create XML --->
            <cfoutput>
                
                <cfsavecontent variable="bodyContent">
                    <bodyContent xsi:type=\"java:com.webex.service.binding.meeting.LstsummaryMeeting\" 
                        xmlns:meet=\"http://www.webex.com/schemas/2002/06/service/meeting\">
                        <listControl>
                            <startFrom/>
                            <maximumNum>5</maximumNum>
                        </listControl>
                        <order>
                            <orderBy>STARTTIME</orderBy>
                        </order>
                        <dateScope>
                        </dateScope>
                    </bodyContent>
            	</cfsavecontent>
            
            </cfoutput>
            
			<!--- Submit XML --->
            <cfscript>
				// Submit XML File
				responseXML = submitXML(bodyContent);			
			</cfscript>
            
        <cfreturn batchResult>
	</cffunction>

	
    
    <!--- Submit XML --->

	<cffunction name="submitXML" access="public" returntype="xml" output="false" hint="Submits a XML file. It receives and returns an XML">
		<cfargument name="bodyContentXML" type="string" required="yes">
                       
			<cfscript>
				// declare variable
				var requestXML = '';
				var responseXML = '';
			</cfscript>
        	
            <!--- ADD CFTRY --->

			<cfoutput>

                <cfxml variable="requestXML">
                    <?xml version="1.0" encoding="ISO-8859-1"?>
                    <serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xmlns:serv="http://www.webex.com/schemas/2002/06/service">            
                        <header>
                            <securityContext>
                                <webExUser>#webExUser#</webExUser>
                                <password>#webExPassword#</password>
                                <siteID>#webExSiteID#</siteID>
                                <partnerID>#webExPartnerID#</partnerID>
                            </securityContext>
                        </header>
                        <body>
                            #ARGUMENTS.bodyContentXML#
                        </body>
                    </serv:message>
                </cfxml>
            
            </cfoutput>
            
            <!--- Submit XML --->
            <cfhttp url="#webExURL#" method="post" throwonerror="yes">
                <cfhttpparam type="XML" value="#requestXML#" />
                <cfhttpparam type="Header" name="charset" value="utf-8" />
            </cfhttp>
            
            <cfscript>	
                // Parse XML we received back to a variable
                responseXML = XmlParse(cfhttp.filecontent);		
            </cfscript>
            
            <cfdump var="requestXML">
            <cfdump var="#requestXML#">
            
            <cfdump var="responseXML">
            <cfdump var="#responseXML#">

            <cfabort>
        
			<cfreturn responseXML>            
	</cffunction>

	
    <!--- Other --->

	<cffunction name="createResultStruct" access="private" returntype="struct" output="false" hint="Creates a structure that holds the XML results.">
                       
		<cfscript>
            // declare return structure
            var batchResult = StructNew();
    
            batchResult.message = 'Success';
            batchResult.URLResults = '';
        
            return batchResult;
        </cfscript>
	
    </cffunction>
    	
</cfcomponent>    