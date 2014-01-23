<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		January 24, 2013
	Desc:		Index

	Updated:	This is the former hostFamily app location, relocate users to the
				new host family application

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfscript>
		// Relocate to new section
		Location("/hostApplication/", "no");
	</cfscript>

</cfsilent>