<!--- ------------------------------------------------------------------------- ----
	
	File:		invoice_view.cfm
	Author:		Marcus Melo
	Date:		June 02, 2011
	Desc:		Invoice View

	Updated:	This file is included by intRep/invoice_view	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

</cfsilent>

<!--- CHECK INVOICE RIGHTS 
<cfinclude template="check_rights.cfm">---->

<!--- Include Invoice File --->
<cfinclude template="../../invoice/invoice_view.cfm">