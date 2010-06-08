<!--- xmlUtilities.cfm - functions to
help with XML processing --->

<!--- XMLIndent()
requires one argument of type XML
returns the resulting XML as text --->
<cffunction name="XMLIndent" returntype="string">
<cfargument name="xml" type="any" required="Yes">

<cfset xsl='<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes"/>
<xsl:template match="/">
<xsl:copy-of select="."/>
</xsl:template>
</xsl:stylesheet>'>
<cfset output=xmltransform(
tostring(arguments.xml), variables.xsl)>
<cfreturn output>

</cffunction> 