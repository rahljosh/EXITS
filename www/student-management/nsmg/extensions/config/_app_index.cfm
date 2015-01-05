<!--- ------------------------------------------------------------------------- ----
	
	File:		_app_index.cfm
	Author:		Marcus Melo
	Date:		March, 30 2010
	Desc:		Application Configuration index - configures the system. 
				
----- ------------------------------------------------------------------------- --->

<!--- Set up init variables --->

<!--- Stores the date of the last APPLICATION initialization --->
<cfparam 
	name="APPLICATION.DateLastInit" 
	type="string"
	default="#Now()#" 
	/>


<!--- Set up Components --->
<cfinclude template="_app_components.cfm" />


<!--- Set up Application variables --->
<cfinclude template="_app.cfm" />
