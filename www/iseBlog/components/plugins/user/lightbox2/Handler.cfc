<!---
LICENSE INFORMATION:

Copyright 2008, Mark Aplet, Adam Tuttle
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Lightbox2 Mango Blog Plugin Beta1 (0.13).

The version number in parenthesis is in the format versionNumber.subversionRevisionNumber.
--->
<cfcomponent displayname="Handler">
	<cfset variables.name = "Lightbox2">
	<cfset variables.id = "com.visual28.mango.plugins.lightbox2">
	<cfset variables.package = "com/visual28/mango/plugins/lightbox2"/>
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
			
		<cfset variables.blogManager = arguments.mainManager />
		<cfset variables.prefs = arguments.preferences />
		
		<cfreturn this/>
	</cffunction>
  
	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>

	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
		<cfreturn />
	</cffunction>

	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>

	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
		<cfreturn />
	</cffunction>

	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<!--- here, we need to change the TinyMCE config so that advanced linking is turned on --->
		<!--- I've requested that Laura expose this via blogManager settings, but in the meantime we'll have to do it the hard way ;) --->
		<!--- plugins : "table, --->
		
		<!--- current version of mango --->
		<cfset var layoutCFM = expandPath(variables.blogManager.getBlog().getBasePath() & 'admin/editorSettings.cfm') />
		<cfset var content = "" />
		<cftry>
			<cffile action="read" file="#layoutCFM#" variable="content" />
			<cfset content = ReplaceNoCase(content, "plugins : ""table,", "plugins : ""table,advlink,", "one") />
			<cffile action="write" file="#layoutCFM#" output="#content#" />
			<cfcatch>
				<cfreturn "Lightbox2 has been activated, but was unable to modify TinyMCE config. See install instructions for manual setup."/>
			</cfcatch>
		</cftry>

		<!--- older versions of mango --->
		<cfset layoutCFM = expandPath(variables.blogManager.getBlog().getBasePath() & 'admin/layout.cfm') />
		<cfset content = "" />
		<cftry>
			<cffile action="read" file="#layoutCFM#" variable="content" />
			<cfset content = ReplaceNoCase(content, "plugins : ""table,", "plugins : ""table,advlink,", "one") />
			<cffile action="write" file="#layoutCFM#" output="#content#" />
			<cfcatch>
				<cfreturn "Lightbox2 has been activated, but was unable to modify TinyMCE config. See install instructions for manual setup."/>
			</cfcatch>
		</cftry>

		<!--- copy public files for this plugin to the preferred location --->
		<cfset copyAssets()/>

		<cfreturn "Lightbox2 Plugin Activated" />
	</cffunction>

	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<!--- for current version of mango --->
		<cfset var layoutCFM = expandPath(variables.blogManager.getBlog().getBasePath() & 'admin/editorSettings.cfm') />
		<cfset var content = "" />
		<cftry>
			<cffile action="read" file="#layoutCFM#" variable="content" />
			<cfset content = ReplaceNoCase(content, "plugins : ""table,advlink,", "plugins : ""table,", "one") />
			<cffile action="write" file="#layoutCFM#" output="#content#" />
			<cfcatch>
				<cfreturn "Lightbox2 has been de-activated, but was unable to modify TinyMCE config. See install instructions for manual removal."/>
			</cfcatch>
		</cftry>

		<!--- for older versions of mango --->
		<cfset layoutCFM = expandPath(variables.blogManager.getBlog().getBasePath() & 'admin/layout.cfm') />
		<cfset content = "" />
		<cftry>
			<cffile action="read" file="#layoutCFM#" variable="content" />
			<cfset content = ReplaceNoCase(content, "plugins : ""table,advlink,", "plugins : ""table,", "one") />
			<cffile action="write" file="#layoutCFM#" output="#content#" />
			<cfcatch>
				<cfreturn "Lightbox2 has been de-activated, but was unable to modify TinyMCE config. See install instructions for manual removal."/>
			</cfcatch>
		</cftry>

		<!--- remove public-facing files --->
		<cfset clearAssets()/>

		<cfreturn "Lightbox2 De-activated" />
	</cffunction>

	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<cfreturn />
	</cffunction>

	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<cfset var js = ""/>
		<cfset var data = ""/>
	
		<cfif arguments.event.name eq "beforeHtmlHeadEnd">
			<cfset data =  arguments.event.outputData />
			
			<cfset data = data & '#chr(13)##chr(10)#<link rel="stylesheet" href="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#variables.name#/lightbox.css" type="text/css" media="screen" />'/>
			<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#variables.name#/prototype.js" type="text/javascript"></script>'/>
			<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#variables.name#/scriptaculous.js?load=effects,builder" type="text/javascript"></script>'/>
			<cfset data = data & '#chr(13)##chr(10)#<script src="#variables.blogManager.getBlog().getBasePath()#assets/plugins/#variables.name#/lightbox.js" type="text/javascript"></script>'/>
			<cfset data = data & '#chr(13)##chr(10)#<script type="text/javascript">LightboxOptions.fileLoadingImage = "#variables.blogManager.getBlog().getBasePath()#assets/plugins/#variables.name#/loading.gif";LightboxOptions.fileBottomNavCloseImage = "#variables.blogManager.getBlog().getBasePath()#assets/plugins/#variables.name#/closelabel.gif";</script>'/>
			<cfset data = data & '#chr(13)##chr(10)#<style>##prevLink:hover, ##prevLink:visited:hover { background: url(#variables.blogManager.getBlog().getBasePath()#assets/plugins/lightbox2/prevlabel.gif) left 15% no-repeat; }##nextLink:hover, ##nextLink:visited:hover { background: url(#variables.blogManager.getBlog().getBasePath()#assets/plugins/lightbox2/nextlabel.gif) right 15% no-repeat; }</style>'/>
			<cfset arguments.event.outputData = data />
		</cfif>
	
		<cfreturn arguments.event />
	</cffunction>  

	<cffunction name="copyAssets" access="private" output="false" returntype="void"
	hint="I'm used during plugin activation to copy files to a public location">
		
		<!--- copy assets to correct public folder --->
		<cfset var local = structNew()/>
		<cfset local.src = getCurrentTemplatePath() />
		<cfset local.src = listAppend(listDeleteAt(local.src, listLen(local.src, "\/"), "\/"), "assets", "/")/>
		<cfset local.dest = expandPath('#variables.blogManager.getBlog().getBasePath()#/assets/plugins/#variables.name#')/>
		
		<!--- create the destination folder if it doesn't exist --->
		<cfif not directoryExists(local.dest)>
			<cfdirectory action="create" directory="#local.dest#"/>
		</cfif>
		
		<!--- copy our assets to the root/assets/plugins/RelatedEntries folder so that they are web-accessible --->
		<cfdirectory action="list" directory="#local.src#" name="local.assets"/>
		<cfloop query="local.assets">
			<cffile action="copy" source="#local.assets.directory#/#local.assets.name#" destination="#local.dest#/#local.assets.name#"/>
		</cfloop>

	</cffunction>

	<cffunction name="clearAssets" access="private" output="false" returntype="void"
	hint="I'm used during plugin de-activation to remove public files">

		<cfset var local = StructNew()/>
		<cfset local.dir = expandPath('../assets/plugins/#variables.name#')/>

		<!--- delete assets --->
		<cfdirectory action="delete" directory="#local.dir#" recurse="yes"/>
		
	</cffunction>

</cfcomponent>