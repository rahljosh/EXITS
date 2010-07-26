<!--- 
Project:     jQuery plugin for Mango Blog <http://mangoblog.org>Author:      Seb Duggan <seb@sebduggan.com>Version:     1.4.2Build date:  2010-02-22 15:59:05Check for updated versions at <http://code.google.com/p/mangoplugins/>


Copyright 2010 Seb Duggan

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--->

<cfcomponent extends="BasePlugin">

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		
		<cfset setManager(arguments.mainManager) />
		<cfset setPreferencesManager(arguments.preferences) />
	
		<cfreturn this/>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfreturn "jQuery plugin activated. jQuery will now be available to all pages and plugins." />
	</cffunction>
	
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />		
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

			<cfset var LOCAL = StructNew() />
			
			<cfswitch expression="#ARGUMENTS.event.name#">
				
				<cfcase value="beforeHtmlHeadEnd">
					<cfset LOCAL.outputData = arguments.event.getOutputData() />
					
<cfsavecontent variable="LOCAL.jquery">
<cfoutput><script type="text/javascript" src="#getAssetPath()#js/jquery-1.4.2.min.js"></script></cfoutput></cfsavecontent>
					
					<cfset arguments.event.setOutputData(LOCAL.outputData & LOCAL.jquery) />
				</cfcase>
				
			</cfswitch>
		
		<cfreturn ARGUMENTS.event />
	</cffunction>
	
</cfcomponent>