<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange S</title>
<style type="text/css">
<!--
-->
</style>

<link href="css/ISEstyle.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #000;
}
a:hover {
	text-decoration: none;
	color: #0B954E;
}
a:active {
	text-decoration: none;
}
.whtMiddle1 {
	background-image: url(images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	height: 500px;
	min-height: 50px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
}
-->
</style></head>

<body class="oneColFixCtr">

<div id="topBar">
<cfinclude template="topBarLinks.cfm">
<div id="logoBox"><a href="index.cfm"><img src="images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="title.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>
<div id="mainContent">
    <div id="subPages">
      <div class="whtTop"></div>
      <div class="whtMiddle1">
        <div class="shopping">
          <h1 class="enter">Program Fee</h1>
          <table width="593" height="333" border="0" cellpading=0 cellspacing="0">
            <tr>
              <th height="45" colspan="3" scope="row" align="center" ><img src="images/webStore_lines_03.gif" width="600" height="15" alt="line" /><a href="webstoreClothing.cfm">Clothing</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="webstoreAccessories.cfm">Accessories</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="fee.cfm">Program Fee</a><img src="images/webStore_lines_06.gif" width="600" height="14" /></th>
              </tr>
            <tr>
              <td  class="lightGreen" scope="row">
              <FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="mug" id="mug" target="loja">
                <p>If you would like to pay for more than one invoice, please submit a seperate payment for each invoice.</p>
            
                <table align="center">
                	<tr>
                    	<td>Invoice Number :</td><td><INPUT TYPE="text" NAME="Describe" VALUE=""></td>
                    </tr>
                	<tr>
                    	<td>Amount to Pay: </td><td><INPUT TYPE="text" NAME="Price" VALUE=""></td>
                    </tr>
				</table>
                <INPUT type="hidden" NAME="Qty"  VALUE="1" size=3>
                <INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
                <INPUT TYPE="hidden" NAME="ID" VALUE="Invoice Payment">
                
                <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="n">
            	<INPUT TYPE="HIDDEN" NAME="Multi" VALUE="n">
                
                <br />
                <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
              </p>
              </FORM>
              </td>
             
            </tr>
            
          </table>
          <p class="p1">&nbsp;</p>
        </div>
        
        <!-- end whtMiddle -->
      </div>
      <div class="whtBottom"></div>
      <!-- end lead --></div>
    <!-- end mainContent --></div>
<!-- end container --></div>
<div id="main" class="clearfix"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="bottomLinks.cfm">
<!-- end footer --></div>
</body>
</html>
