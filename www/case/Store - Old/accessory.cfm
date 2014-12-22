<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CASE Accessories</title>
<link href="../css/maincss.css" rel="stylesheet" type="text/css" />

<style type="text/css">
<!--
.headerStore {
	font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
	font-size: 20px;
	font-weight: bold;
	color: #FFF;
	margin: 0px;
	padding-top: 13px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
}
#StoreTabs {
	margin: 0px;
	padding: 0px;
	height: 45px;
	width: 650px;
}
-->
</style>
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
	color: #98002E;
}
a:active {
	text-decoration: none;
	color: #000;
}
.clearfix {
	display: block;
	clear: both;
	height: 30px;
}
-->
</style>

<link rel="shortcut icon" href="favicon.ico" />

</head>

<body>
<Cfif isDefined('form.sendEmail')>
<cfmail  to="jeimi@exitgroup.org" replyto="#form.email#" from="webstore@case-usa.org" type="html" SUBJECT="Magnet artwork"> 
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
<div id="wrapper">
 <cfinclude template="../includes/header.cfm">
  <div id= "mainbody">
   <cfinclude template="../includes/leftsidebar.cfm">
    <div id="mainContent">
  <div id="ContentTop"></div><!-- ContentTop -->
  <div id="content">
  <div id="aboutCaseStore">
  <div id="StoreTabs"><a href="clothing.cfm"><img src="storeimages/clothingM.png" width="200" height="45" border="0" /></a><a href="accessory.cfm"><img src="storeimages/AccessoriesLive.png" width="400" height="45" border="0" /></a></div>
  <div id="storeFront">
    <table width="605" height="267" border="0">
      <tr>
        <th colspan=3 align=center><h3>More than one item? Simply update quantity after placing in cart.</h3></th>
        </tr>
      <tr>
        <th width="300" height="152" ><img src="storeimages/pens.jpg" width="300" height="150"></th>
        <td colspan="2" align="center"><img src="storeimages/mousepad.jpg" width="300" height="150" /></td>
        </tr>
      <tr>
        <td align="right"><strong>$0.40 each</strong>
          <div class="product"><input type="hidden" class="product-title" value="CASE Pens"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/Pens.jpg"><input type="hidden" class="product-price" value="0.40"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        <td colspan="2" align="right"><strong>$3.00 each</strong><div class="product"><input type="hidden" class="product-title" value="Mouse Pad"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/mousepad.jpg"><input type="hidden" class="product-price" value="3.00"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        </tr>
      <tr>
        <th colspan="5" ><hr /></th>
        </tr>
      <tr>
        <td><img src="storeimages/keychain.jpg" width="300" height="150" /></th>
          <td colspan="2"><img src="storeimages/luggage.jpg" width="300" height="150" /></td>
        </tr>
      <tr>
        <td align="right"><strong>$1.25 each</strong><div class="product"><input type="hidden" class="product-title" value="Keychain"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/keychain.jpg"><input type="hidden" class="product-price" value="1.25"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div>
          </th>
          <td colspan="2" align="right"><strong>$1.25 each</strong>
            <div class="product"><input type="hidden" class="product-title" value="Luggage Tag"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/luggage.jpg"><input type="hidden" class="product-price" value="1.25"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        </tr>
      <tr>
        <th colspan="5" ><hr /></th>
        </tr>
      <tr>
        <td><img src="storeimages/mug.jpg" width="300" height="150" /></th>
          <td colspan="2" ><img src="storeimages/travelMug.jpg" width="300" height="150" /></td>
        </tr>
      <tr>
        <td align="right"><strong>$3.50 each</strong><div class="product"><input type="hidden" class="product-title" value="Home/Office Coffee Mug"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/mug.jpg"><input type="hidden" class="product-price" value="3.50"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        
        <td colspan="2" align="right"><strong>$7.00 each</strong><div class="product"><input type="hidden" class="product-title" value="Travel Mug"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/travelMug.jpg"><input type="hidden" class="product-price" value="7.00"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        </tr>
      <tr>
        <th colspan="5" ><hr /></th>
        </tr>
      <tr>
        <td><img src="storeimages/cap.jpg" width="300" height="150" /></th>
          <td colspan="2" ><img src="storeimages/magnet.jpg" width="300" height="150" /></td>
        </tr>
      <tr>
        <td align="right"><strong>$9.00 each</strong>
          <div class="product"><input type="hidden" class="product-title" value="All Star Cap"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/cap.jpg"><input type="hidden" class="product-price" value="9.00"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        
        <td colspan="2" align="right"><strong>$1.50 each</strong><div class="product"><input type="hidden" class="product-title" value="Clip Magnet"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/magnet.jpg"><input type="hidden" class="product-price" value="1.50"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        </tr>
      <tr>
        <th colspan="5" ><hr /></th>
        </tr>
      
      <tr>
        <td><img src="storeimages/tote.jpg" width="300" height="150" /></th>
          <td colspan="2" ><img src="storeimages/calendar.jpg" width="300" height="150" /></td>
        </tr>
      <tr>
        <td align="right"><strong>$4.50 each</strong>
          <div class="product"><input type="hidden" class="product-title" value="Tote Bag"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/tote.jpg"><input type="hidden" class="product-price" value="4.50"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        
        <td colspan="2" align="right"><strong>$3.00 each</strong>
          <div class="product"><input type="hidden" class="product-title" value="Calendar"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/calendar.jpg"><input type="hidden" class="product-price" value="3.00"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        </tr>
      <tr>
        <th colspan="5" ><hr /></th>
        </tr>
      <tr>
        <td><img src="storeimages/carmagnet.jpg" width="300" height="150" /></td>
        <td width="300" align="center" div>
          <strong> Ordering a magnet? </strong><Br /><Br /> Once your order is processed, you will be contacted regarding the information you would like on the magnet.
       <!---- <cfif not isDefined('form.sendEmail')>
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
<p class="paragraphText"> Thank you for submitting your information for a personalized magnet</p>
</cfif>
---->
        </td>
        
        
        </tr>
      <tr>
        <td align="right"><strong>$19.00 each</strong>
          <div class="product"><input type="hidden" class="product-title" value="car magnet"><input type="hidden" class="product-image" value="http://www.case-usa.org/Store/storeimages/thumbnails/carmagnet.jpg"><input type="hidden" class="product-price" value="19.00"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div></td>
        <td width="130" align="center" div>&nbsp;</td>
        </tr>
       <tr>
        <th colspan="5" ><hr /></th>
       
        </tr>
      
         <tr>
        <th colspan="5" ><div align="center"><link rel="stylesheet" href="https://checkout.google.com/seller/accept/s.css" type="text/css" media="screen" />
          <script type="text/javascript" src="https://checkout.google.com/seller/accept/j.js"></script>
          <script type="text/javascript">showMark(1);</script>
          <noscript><img src="https://checkout.google.com/seller/accept/images/st.gif" width="92" height="88" alt="Google Checkout Acceptance Mark" /></noscript></div></th>
       
        </tr>
       
      <tr>
        <th colspan=3 align=center><h3>More than one item? Simply update quantity after placing in cart.</h3></th>
        </tr>
      </table>
  </div><!-- storeFront -->
    
  </div><!-- aboutCase -->
  <p class="bodycopy">&nbsp;</p>
  </div><!-- content -->
  <div id="Contentbottom"></div>
  
  <script  id='googlecart-script' type='text/javascript' src='https://checkout.google.com/seller/gsc/v2_2/cart.js?mid=423042749881753' integration='jscart-wizard' post-cart-to-sandbox='false' currency='USD' productWeightUnits='LB'></script>
</div><!-- mainContent -->
</div><!-- end mainbody -->
    <!-- This clearing element should immediately follow the #mainContent div in order to force the container div to contain all child floats --><br class="clearfloat" />
<cfinclude template="../includes/footer.cfm">
</div><!-- end wrapper -->
</body>
</html>
