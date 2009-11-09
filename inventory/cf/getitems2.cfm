<cfinvoke 
webservice="http://dev.student-management.com/inventory/getitems.cfc?wsdl" method="returnquery" returnvariable="returnedQuery">
</cfinvoke>

<cfdump var="#returnedQuery#">
