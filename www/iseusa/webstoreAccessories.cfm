<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
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
under {
	color: #900;
	text-decoration: underline;
}

under:link {
	color: #900;
	text-decoration: underline;
}
under:visited {
	text-decoration: underline;
	color: #000;
}
under:hover {
	text-decoration: underline;
	color: #999;
}
under:active {
	text-decoration: underline;
}
.whtMiddleAcc {
	background-image: url(images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
	height: 1865px;
}
.clearFixLG {
	display: block;
	clear: both;
	height: 20px;
}
.lightGText {
	color: #000;
	background-image: url(../images/webstore/greenbox.gif);
	background-repeat: repeat;
	text-align: center;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #000;
}

-->
</style>

</head>
<body class="oneColFixCtr">
<Cfif isDefined('form.sendEmail')>
<cfmail  to="jeimi@exitgroup.org" replyto="#form.email#" from="webstore@iseusa.com" type="html" SUBJECT="Magnet artwork"> 
<p> The info submitted was:
  <br /><br />
  <strong>Student Information</strong><br />
  Territory:#form.territory#<br />
  Name:#form.fullname#<br />
  Phone:#form.phone#<Br />
  Email:#form.email#<br />
  Website:#form.website#<Br />
  </p>

</cfmail>
</Cfif>
<div id="topBar">
<cfinclude template="topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="title.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>
<div id="mainContent">
    <div id="subPages">
      <div class="whtTop"></div>
      <div class="whtMiddleAcc">
        <div class="shopping">
          <h1 class="enter">Accessories</h1>
          <table width="593" height="333" border="0" cellpading=0 cellspacing="0">
            <tr>
              <th height="45" colspan="3" scope="row" align="center" ><img src="images/webStore_lines_03.gif" width="600" height="15" alt="line" /><a href="webstoreClothing.cfm">Clothing</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="webstoreAccessories.cfm">Accessories</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="fee.cfm">Program Fee</a><img src="images/webStore_lines_06.gif" width="600" height="14" /></th>
              </tr>
            <tr>
              <th width="298" height="178" class="lightGreen" scope="row"><img src="images/webstore/travelMug.jpg" width="190" height="160" alt="travel mug" /></th>
              <td width="21" valign="middle">&nbsp;</td>
              <td width="293" align="center" valign="middle" class="lightGreen"><img src="images/webstore/pens.jpg" width="190" height="160" alt="PENS" /><br /></td>
            </tr>
            
            <tr>
              <th class="lightGreen" scope="row" padding="5">
               <FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="mug" id="mug" target="loja">
                 <p>Travel mug with white ISE logo <br />
             
                18 oz. stainless steel interior with acrylic exterior.<img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
              <INPUT NAME="Qty" class="style1" VALUE="" size=3>
      Quantity - <strong>$7.00</strong> each  
 			<INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
            <INPUT TYPE="HIDDEN" NAME="ID" VALUE="TM">
            <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Travel Mug">
            <INPUT TYPE="HIDDEN" NAME="Price" VALUE="7.00">
            <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
            <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y"> <br />
               <INPUT type="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart"> </p></form></th>
              <td>&nbsp;</td>
              <th class="lightGreen">ISE Pens<br />
                Blue with white ISE logo, black ink.<br />
                <img src="images/webstore/greenLine.gif" width="208" height="20" /><br /> 
                <FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="mug" id="mug" target="loja">               
               <INPUT NAME="Qty" class="style1" VALUE="" size=2> 
                Quantity - <strong>$0.40</strong> each      
                <INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'> 
                <INPUT TYPE="HIDDEN" NAME="ID" VALUE="IP">
                <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Pens">
                <INPUT TYPE="HIDDEN" NAME="Price" VALUE="0.40">
                <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
                <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y"> <br />
<INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
</FORM>
              </th>
            </tr>
            <tr>
            	<td>&nbsp;</td>
            </tr>
            <tr>
              <th class="lightGreen" scope="row"><img src="images/webstore/MousePad.jpg" width="190" height="160" alt="mousepad" /></th>
              <td>&nbsp;</td>
              <th class="lightGreen"><img src="images/webstore/bagTags.jpg" width="190" height="160" /></th>
            </tr>
            <tr>
              <th class="lightGreen" scope="row">
              <FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="mug" id="mug" target="loja">
              Mouse Pad<br />
                Blue non-skid rubber backing. <br />
                7.75&quot; h x 9.25&quot;w x .25&quot; thick.<br /><img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
                <INPUT NAME="Qty" class="style1" VALUE="" size=3> 
                Quantity - <strong>$3.00</strong> each      
                <INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'> 
                <INPUT TYPE="HIDDEN" NAME="ID" VALUE="MP">
                <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Mouse pad">
                <INPUT TYPE="HIDDEN" NAME="Price" VALUE="3.00">
                <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
                <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y">
                
                <br />
               <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart"> 
               </FORM>
                </th>
              <td>&nbsp;</td>
              <th class="lightGreen">
              <FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="mug" id="mug" target="loja">
              <p>Business Card Luggage Tag<br />
                blue with white logo. 2 3/8&quot; h x 4 1/8&quot; w.<br /><br /><img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
                
                  <INPUT NAME="Qty" class="style1" VALUE="" size=3>
      Quantity - <strong>$1.25</strong> each  
 			<INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
            <INPUT TYPE="HIDDEN" NAME="ID" VALUE="LT">
            <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Luggage Tag">
            <INPUT TYPE="HIDDEN" NAME="Price" VALUE="1.25">
            <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
            <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y">
                  
                  <br />
                <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
                </FORM></th>
            </tr>
                        <tr>
            	<td>&nbsp;</td>
            </tr>
            <tr>
              <th class="lightGreen" scope="row"><img src="images/webstore/FridgeMagnet.jpg" width="190" height="160" /></th>
              <td>&nbsp;</td>
              <td class="lightGreen" align="center"><img src="images/webstore/mug.jpg" width="190" height="160" /></td>
            </tr>
            <tr>
              <th class="lightGreen" scope="row">
              <FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="mug" id="mug" target="loja">
              Globe Magnet Refrigerator Clip<br />
                2 3/8&quot; diameter.<br /><img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
			<INPUT NAME="Qty" class="style1" VALUE="" size=3>
     		 Quantity - <strong>$1.50</strong> each 
 			<INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
            <INPUT TYPE="HIDDEN" NAME="ID" VALUE="GMRC">
            <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Globe Magnet Refrigerator Clip">
            <INPUT TYPE="HIDDEN" NAME="Price" VALUE="1.50">
            <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
            <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y">
                
                <br />
                 <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
                </FORM>
                </th>
              <td>&nbsp;</td>
              <th class="lightGreen">
              <FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="mug" id="mug" target="loja">Coffee Mug <br />
                Light blue mug with dark blue ISE logo, 13 oz.<img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
                <INPUT NAME="Qty" class="style1" VALUE="" size=3>
      Quantity - <strong>$3.50</strong> each
 			<INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
            <INPUT TYPE="HIDDEN" NAME="ID" VALUE="CM">
            <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Light Blue Mug">
            <INPUT TYPE="HIDDEN" NAME="Price" VALUE="3.50">
            <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
            <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y">
                <br />
                 <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
                </FORM>
</th>
            </tr>
            <tr>
            	<td>&nbsp;</td>
            </tr>
                     <tr>
              <th class="lightGreen" scope="row"><img src="images/webstore/keychain.jpg" width="190" height="160" /></th>
              <td>&nbsp;</td>
              <td class="lightGreen" align="center"><img src="images/webstore/2917ntopperscapsmall.jpg" width="150" height="150" alt="ise hat" /></td>
            </tr>
            <tr>
              <th class="lightGreen" scope="row">
              <FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="mug" id="mug" target="loja">
              ISE blue key chain with whistle and light<br />
                1 h x 2.5&quot;w x .25&quot; thick.<br />
                <img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
			<INPUT NAME="Qty" class="style1" VALUE="" size=3>
     		 Quantity - <strong>$1.25</strong> each 
 			 <INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
            <INPUT TYPE="HIDDEN" NAME="ID" VALUE="KC">
            <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Key Chain">
            <INPUT TYPE="HIDDEN" NAME="Price" VALUE="1.25">
            <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
            <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y">
                
                <br />
                 <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
                </FORM>
              </th>
              <td>&nbsp;</td>
              <th class="lightGreen"><FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="cap" id="cap" target="loja">
              ISE Ball Cap - Relaxed golf cap - <br />
              khaki with Navy ISE logo. Low profile<br />
                <img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
			<INPUT NAME="Qty" class="style1" VALUE="" size=3>
     		 Quantity - <strong>$9.00</strong> each 
 			 <INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
            <INPUT TYPE="HIDDEN" NAME="ID" VALUE="BC">
            <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Ball Cap">
            <INPUT TYPE="HIDDEN" NAME="Price" VALUE="9.00">
            <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
            <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y">
                
                <br />
                 <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
              </FORM></th>
            </tr>
            <tr>
            
            	<td>&nbsp;</td>
            </tr>
         
            <tr>
              <th class="lightGreen" scope="row"><img src="images/webstore/tote.jpg" width="200" height="150" border="1" /></th>
              <td>&nbsp;</td>
              <th class="lightGreen"><img src="images/webstore/calendar.jpg" width="172" height="150" border="1" /></th>
            </tr>
            <tr>
              <th class="lightGreen" scope="row"><FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="bag" id="bag" target="loja">
              Tote Bag - Natural with Royal ISE Logo<br />
                <img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
			<INPUT NAME="Qty" class="style1" VALUE="" size=3>
     		 Quantity - <strong>$4.50</strong> each 
 			 <INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
            <INPUT TYPE="HIDDEN" NAME="ID" VALUE="TBG">
            <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Tote Bag">
            <INPUT TYPE="HIDDEN" NAME="Price" VALUE="4.50">
            <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
            <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y">
                
                <br />
                 <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
                </FORM></th>
              <td>&nbsp;</td>
              <th class="lightGreen"><FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="bag" id="bag" target="loja">
              Monthly Calendar -<br />
              7&quot; x 10&quot; with large Boxes
              <br />
                <img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
			<INPUT NAME="Qty" class="style1" VALUE="" size=3>
     		 Quantity - <strong>$3.00</strong> each 
 			 <INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
            <INPUT TYPE="HIDDEN" NAME="ID" VALUE="CDR">
            <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Calendar">
            <INPUT TYPE="HIDDEN" NAME="Price" VALUE="3.00">
            <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
            <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y">
                
                <br />
                 <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
              </FORM></th>
            </tr>
            <tr>
            	<td>&nbsp;</td>
            </tr>
            <tr>
              <th class="lightGreen" scope="row"><img src="images/webstore/carmagnet-01.jpg" width="225" height="150" border="1" /></th>
              <td>&nbsp;</td>
              <td class="lightGText">
              <cfif not isDefined('form.sendEmail')>
			  <cfoutput>
  <cfform id="RequestInfo" name="RequestInfo" method="post" action="#CGI.SCRIPT_NAME#">
  <cfinput type="hidden" name="sendEmail" value=1/>
              <p>If you are ordering the magnet, <br>
                please fill out form below.</p>
                
                  Territory:
                    <cfinput type="text" name="Territory" required="yes"><br />
                  Full Name: 
                  <cfinput type="text" name="fullname" required="yes"><br />
                  Phone:&nbsp; &nbsp; 
                  <cfinput type="text" name="phone" required="yes"><br />
                  Email:&nbsp; &nbsp; &nbsp; 
                  <cfinput type="text" name="email" required="yes"><br />
                  Website:
                  <cfinput type="text" name="website" required="yes"><br />
                  <cfinput type="submit" name="submit" value="Submit" />
      </cfform>
                
</cfoutput>
<cfelse>
<p class="paragraphText"><STRONG>THANK YOU FOR SUBMITTING YOUR INFORMATION <br>
  FOR A PERSONALIZED ISE MAGNET.</STRONG></p>
<p class="paragraphText">AN ISE REPRESENTATIVE WILL BE SENDING YOU<br>
AN ARTWORK PROOF FOR YOUR APPROVAL.</p>
              </cfif>
               
              <p><a href="mailto:budge@iseusa.com"></a><a href="pdfs/carmagnetInfo.pdf" title="Car Magnet Info" target="_blank"></a></p></td>
            </tr>
            <tr>
              <th class="lightGreen" scope="row"><FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="bag" id="bag" target="loja">
              Magnets - Fully Personalized 12&quot; x 18&quot;<br />
                <img src="images/webstore/greenLine.gif" width="211" height="15" alt="green line" /><br />
			<INPUT NAME="Qty" class="style1" VALUE="" size=3>
     		 Quantity - <strong>$19.00</strong> each 
 			 <INPUT TYPE='HIDDEN' NAME='DiscItm' VALUE='n'>
            <INPUT TYPE="HIDDEN" NAME="ID" VALUE="MGT">
            <INPUT TYPE="HIDDEN" NAME="Describe" VALUE="Car Magnet">
            <INPUT TYPE="HIDDEN" NAME="Price" VALUE="19.00">
            <INPUT TYPE="HIDDEN" NAME="Ship" VALUE="">
            <INPUT TYPE="HIDDEN" NAME="Multi" VALUE="Y">
                
                <br />
                 <INPUT TYPE="image" src="images/webstore/addtoCart.png" class="style1"  VALUE="Add to Cart">
                </FORM></th>
              <td>&nbsp;</td>
              <th class="lightGreen"><FORM action="http://www.coolcart.net/shop/coolcart.aspx/studentmanagement" method=post name="bag" id="bag" target="loja">
              </FORM></th>
            </tr>
            <tr>
              <th colspan="3" scope="row" align="center"><img src="images/webStore_lines_06.gif" width="600" height="15" alt="line" /><a href="webstoreClothing.cfm">Clothing</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="webstoreAccessories.cfm">Accessories</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="fee.cfm">Program Fee</a><img src="images/webStore_lines_03.gif" width="600" height="15" alt="line" /></th>
            </tr>
	
          </table>
          <div class="clearFixLG"></div>
          <p class="p1">&nbsp;</p>
        </div>
<!-- end whtMiddle --></div>
      <div class="whtBottom"></div>
      <!-- end lead --></div>
    <!-- end mainContent --></div>
<!-- end container -->
</div>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">
