<cfdocument format="PDF" orientation="portrait" backgroundvisible="yes" overwrite="no" fontembed="yes">

<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style7 {font-family: Verdana, Arial, Helvetica, sans-serif}
.style8 {
	font-size: 14px;
	font-weight: bold;
}
.style9 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
}
.style10 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 24px;
	font-weight: bold;
}
-->
</style>

<cfquery name="get_items_asa" datasource="MySql">
  	SELECT name, stock
	FROM inventory_items
	WHERE companyid = 3 AND status =1
</cfquery>

<cfquery name="get_items_into" datasource="MySql">
  	SELECT name, stock
	FROM inventory_items
	WHERE companyid = 2 AND status =1 OR companyid = 8 AND status =1 OR companyid = 9 AND status =1
</cfquery>

<cfquery name="get_items_dmd" datasource="MySql">
  	SELECT name, stock
	FROM inventory_items
	WHERE companyid = 4 AND status =1
</cfquery>

<cfquery name="get_items_php" datasource="MySql">
  	SELECT name, stock
	FROM inventory_items
	WHERE companyid = 6 AND status =1
</cfquery>

<cfquery name="get_items_ise" datasource="MySql">
  	SELECT name, stock
	FROM inventory_items
	WHERE companyid = 1 AND status =1 OR companyid = 7 AND status =1
</cfquery>

<cfquery name="get_items_smg" datasource="MySql">
  	SELECT name, stock
	FROM inventory_items
	WHERE companyid = 5 AND status =1
</cfquery>

</head>
<body>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="75" valign="top"><p align="center" class="style10">SMG Inventory Report<br>
      All Items
</p>    </td>
  </tr>
</table>

<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="style1 style7 style8"><div align="left">&nbsp; 
    ASA<span class="style1"><img src="../images/black_pixel.gif" width="99%" height="4"></span></div></td>
    <td><div align="left"><span class="style9">&nbsp; INTO</span><span class="style1"><img src="../images/black_pixel.gif" width="99%" height="4"></span></div></td>
  </tr>
  <tr>
    <td width="50%" valign="top">
	
	<cfoutput>
	<table width=95% align="center" cellpadding="4" cellspacing=0>
          <tr>
            <th width="85%"  align="left" class="style1">Item</th>
            <th width="15%"  align="left" class="style1">Stock </th>
          </tr>
          <tr>
            <td colspan=2 class="style1"><img src="../images/black_pixel.gif" width="100%" height="2"></td>
          </tr>
          <cfloop query="get_items_asa">
            <tr <cfif get_items_asa.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
              <td align="left" class="style1">#name#</td>
              <td align="left" class="style1">#stock#</td>
            </tr>
          </cfloop>
        </table>
      </cfoutput>
	  
	  </td>
    <td width="50%" valign="top"><span class="style1"></span><cfoutput>
	
	<table width=95% align="center" cellpadding="4" cellspacing=0>
          <tr>
            <th width="85%"  align="left" class="style1">Item</th>
            <th width="15%"  align="left" class="style1">Stock </th>
          </tr>
          <tr>
            <td colspan=2 class="style1"><img src="../images/black_pixel.gif" width="100%" height="2"></td>
          </tr>
          <cfloop query="get_items_into">
            <tr <cfif get_items_into.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
              <td align="left" class="style1">#name#</td>
              <td align="left" class="style1">#stock#</td>
            </tr>
          </cfloop>
        </table>
      </cfoutput></td>
  </tr>
  <tr>
    <td height="35" valign="bottom"><span class="style9">&nbsp; 
    DMD</span><span class="style1"><img src="../images/black_pixel.gif" width="99%" height="4"></span></td>
    <td width="50%" valign="bottom"><span class="style9">&nbsp; 
    PHP</span><span class="style1"><img src="../images/black_pixel.gif" width="99%" height="4"></span></td>
  </tr>
  <tr>
    <td valign="top">
	
	<cfoutput>
      <table width=95% align="center" cellpadding="4" cellspacing=0>
        <tr>
          <th width="85%"  align="left" class="style1">Item</th>
          <th width="15%"  align="left" class="style1">Stock </th>
        </tr>
        <tr>
          <td colspan=2 class="style1"><img src="../images/black_pixel.gif" width="100%" height="2"></td>
        </tr>
        <cfloop query="get_items_dmd">
          <tr <cfif get_items_dmd.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
              <td align="left" class="style1">#name#</td>
              <td align="left" class="style1">#stock#</td>
          </tr>
        </cfloop>
      </table>
    </cfoutput>
	
	</td>
    <td width="50%" valign="top">
	
	<cfoutput>
      <table width=95% align="center" cellpadding="4" cellspacing=0>
        <tr>
          <th width="85%"  align="left" class="style1">Item</th>
          <th width="15%"  align="left" class="style1">Stock </th>
        </tr>
        <tr>
          <td colspan=2 class="style1"><img src="../images/black_pixel.gif" width="100%" height="2"></td>
        </tr>
        <cfloop query="get_items_php">
          <tr <cfif get_items_php.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
              <td align="left" class="style1">#name#</td>
              <td align="left" class="style1">#stock#</td>
          </tr>
        </cfloop>
      </table>
    </cfoutput>
	
	</td>
  </tr>
  <tr>
    <td height="35" valign="bottom"><span class="style9">&nbsp; 
    ISE</span><span class="style1"><img src="../images/black_pixel.gif" width="99%" height="4"></span></td>
    <td width="50%" valign="bottom"><span class="style9">&nbsp; 
    SMG</span><span class="style1"><img src="../images/black_pixel.gif" width="99%" height="4"></span></td>
  </tr>
  <tr>
    <td valign="top">
	
	<cfoutput>
      <table width=95% align="center" cellpadding="4" cellspacing=0>
        <tr>
          <th width="85%"  align="left" class="style1">Item</th>
          <th width="15%"  align="left" class="style1">Stock </th>
        </tr>
        <tr>
          <td colspan=2 class="style1"><img src="../images/black_pixel.gif" width="100%" height="2"></td>
        </tr>
        <cfloop query="get_items_ise">
          <tr <cfif get_items_ise.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
              <td align="left" class="style1">#name#</td>
              <td align="left" class="style1">#stock#</td>
          </tr>
        </cfloop>
      </table>
    </cfoutput>
	
	</td>
    <td width="50%" valign="top">
	
	<cfoutput>
      <table width=95% align="center" cellpadding="4" cellspacing=0>
        <tr>
          <th width="85%"  align="left" class="style1">Item</th>
          <th width="15%"  align="left" class="style1">Stock </th>
        </tr>
        <tr>
          <td colspan=2 class="style1"><img src="../images/black_pixel.gif" width="100%" height="2"></td>
        </tr>
        <cfloop query="get_items_smg">
          <tr <cfif get_items_smg.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
              <td align="left" class="style1">#name#</td>
              <td align="left" class="style1">#stock#</td>
          </tr>
        </cfloop>
      </table>
    </cfoutput>
	
	</td>
  </tr>
</table>
<p><cfoutput><span class="style1">&nbsp; &nbsp;Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span></cfoutput></p>
</body>
</html>
</cfdocument>