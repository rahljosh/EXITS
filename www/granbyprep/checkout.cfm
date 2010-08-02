 	<!--- Force SSL --->
	<cfif NOT APPLICATION.IsServerLocal AND NOT CGI.SERVER_PORT_SECURE>
        <cflocation url="https://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" addToken="no" />
    </cfif>
    
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    
                        <title>Granby Preparatory Academy</title>
                        <meta name="description" content="" />
                        <meta name="keywords" content="" />
                        <link rel="stylesheet" href="../linked/css/appSection.css" type="text/css" />

                        <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css" />
                        <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/excite-bike/jquery-ui.css" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
						<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script> <!-- jQuery -->
                        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script> <!-- JQuery UI 1.8 Tab -->
                        <script src="../linked/js/appSection.js " type="text/javascript"></script>
                    
                </head>

                <body>
                
                
                <div class="wrapper">
                    
                    <div class="topBar">
                        
                        <div class="topLeft">
                            <a href="/admissions/index.cfm?action=initial" title="Granby Preparatory Academy Application For Admission">
                                <div class="mainLogo"></div>
                                <div class="title">Granby Preparatory Academy</div>
                                <div class="subTitle">Application for Admission</div>

                            </a>
						</div>
                                                
                        <div class="topRight">
                            <a href="/admissions/index.cfm?action=home" class="ui-corner-top ">Home</a>
                            <a href="/admissions/index.cfm?action=help" class="ui-corner-top ">Get Help</a>
                            <a href="/admissions/index.cfm?action=faq" class="ui-corner-top ">FAQ</a>
                            <a href="/admissions/index.cfm?action=myAccount" class="ui-corner-top ">Update Login</a>

                            <a href="/admissions/index.cfm?action=logoff" class="ui-corner-top">Logoff</a>

                            <div class="welcomeMessage">
                                
                                    Welcome Back Marcus Melo! &nbsp;
                                    Your last login was on 07/20/2010 at 11:03 AM EST
                                
                            </div>

                        </div>
                        
                    </div>

		
					
                    <div class="leftSideBar ui-corner-all">
                        
                        <div class="insideBar form-container">
                            <a href="/admissions/index.cfm?action=initial" id="itemLinks" class="itemLinks">Start Application</a> 
                            
                            <a href="/admissions/index.cfm?action=initial" id="itemLinks" class="itemLinks">Application Checklist</a> 
                                <ul>
                                    <li class="Yes"><a href="/admissions/index.cfm?action=initial&currentTabID=0">Student Information</a></li>
                                    <li class="Yes"><a href="/admissions/index.cfm?action=initial&currentTabID=1">Family Information</a></li>
									
									
                                    
                                    
                                    <li class="Yes"><a href="/admissions/index.cfm?action=initial&currentTabID=3">Other</a></li>

                                    <li class="Yes"><a href="/admissions/index.cfm?action=initial&currentTabID=4">Student Essay</a></li>
                                </ul>    
                            
                            <a href="/admissions/index.cfm?action=download" class="itemLinks ">Download Forms</a>
                            <a href="/admissions/index.cfm?action=printApplication" class="itemLinks">Print Application</a>
                            <a href="/admissions/index.cfm?action=applicationFee" id="itemLinks" class="itemLinks  selected ">Application Fee</a>                                 
                            <a href="/admissions/index.cfm?action=submit" class="itemLinks">Submit Application</a>
                        </div>                            
                    
                    </div>

                    
            
    
    
    <div class="rightSideContent ui-corner-all">
        
        <div class="insideBar">

			
            <div class="form-container">
                
				
                  
                    <form action="/admissions/index.cfm?action=applicationFee" method="post">
                    <input type="hidden" name="submitted" value="1" />
                    
                    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>

                    
                    <fieldset>
                       
                        <legend>Application Fee</legend>

                        <div class="field controlset">
                            <span class="label">Application Fee <em>*</em></span>
							<strong>$150.00</strong>
                        </div>

                    </fieldset>                

                    
                    
                    <fieldset>
                       
                        <legend>Payment Method</legend>

                        <div class="field controlset">
                            <span class="label">Payment Method <em>*</em></span>
                            
                                <input type="radio" name="paymentMethodID" id="Credit Card" value="Credit Card"  /> <label for="Credit Card">Credit Card</label>

                            
                        </div>
                
                    </fieldset>                
                    
                    
                    <fieldset>
                       
                        <legend>Credit Card Information</legend>
    
                        <p class="note">Enter information for a Credit Card. Your session is <a href="privacy.cfm" target="_blank">secure</a>.</p>
                            
                        <div class="field">
                            <label for="nameOnCreditCard">Name on Credit Card <em>*</em></label> 
                            <input type="text" name="nameOnCreditCard" id="nameOnCreditCard" value="" class="largeField" maxlength="100" />

                        </div>
  
  

                        <div class="field controlset">
                            <span class="label">&nbsp;</span>
                            <div class="creditCardAccepted">&nbsp;</div>
                        </div>


                
                        <div class="field controlset">
                            <span class="label">Credit Card Type <em>*</em></span>

                            <select name="creditCardType" id="creditCardType" class="mediumField" onchange="displayCreditCard(this.value);">
                                <option value=""></option>
                                
                                    <option value="1"  >American Express</option>
                                
                                    <option value="2"  >Discover</option>
                                
                                    <option value="3"  >MasterCard</option>
                                
                                    <option value="4"  >Visa</option>
                                
                            </select>

                        </div>
                
                        <div class="field">
                            <label for="creditCardNumber">Credit Card Number <em>*</em></label> 
                            <input type="text" name="creditCardNumber" id="creditCardNumber" value="" class="largeField" maxlength="100" />
                            <p class="note">no spaces or dashes</p>
                        </div>
                
                        <div class="field">
                            <label for="expirationMonth">Expiration Date <em>*</em></label> 
                            <select name="expirationMonth" id="expirationMonth" class="smallField">

                                <option value=""></option>
                                
                                    <option value="1"  >January</option>
                                
                                    <option value="2"  >February</option>
                                
                                    <option value="3"  >March</option>
                                
                                    <option value="4"  >April</option>
                                
                                    <option value="5"  >May</option>

                                
                                    <option value="6"  >June</option>
                                
                                    <option value="7"  >July</option>
                                
                                    <option value="8"  >August</option>
                                
                                    <option value="9"  >September</option>
                                
                                    <option value="10"  >October</option>
                                
                                    <option value="11"  >November</option>

                                
                                    <option value="12"  >December</option>
                                
                            </select>
                            /
                            <select name="expirationYear" id="expirationYear" class="xSmallField">
                                <option value=""></option>
                                
                                    <option value="2010"  >2010</option>
                                
                                    <option value="2011"  >2011</option>
                                
                                    <option value="2012"  >2012</option>

                                
                                    <option value="2013"  >2013</option>
                                
                                    <option value="2014"  >2014</option>
                                
                                    <option value="2015"  >2015</option>
                                
                                    <option value="2016"  >2016</option>
                                
                                    <option value="2017"  >2017</option>
                                
                                    <option value="2018"  >2018</option>

                                
                            </select>
                        </div>
                
                        <div class="field">
                            <label for="ccvCode">CCV/CID Code <em>*</em></label> 
                            <input type="text" name="ccvCode" id="ccvCode" value="" class="xSmallField" maxlength="4" />
                            <p class="note">See credit card image</p>
                        </div>
                      
                        <div class="creditCardImageDiv">

                            <div id="displayCardImage" class="card1"></div>
                        </div>
                        
                    </fieldset>
                    
                    
                    <fieldset>
                       
                        <legend>Billing Address</legend>
                            
                        <div class="field">
                            <label for="billingFirstName">First Name <em>*</em></label> 
                            <input type="text" name="billingFirstName" id="billingFirstName" value="" class="largeField" maxlength="100" />

                        </div>
                
                        <div class="field">
                            <label for="billingLastName">Last Name <em>*</em></label> 
                            <input type="text" name="billingLastName" id="billingLastName" value="" class="largeField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="billingCompany">Company Name </label> 
                            <input type="text" name="billingCompany" id="billingCompany" value="" class="largeField" maxlength="100" />

                        </div>
    
                        <div class="field">
                            <label for="billingAddress">Address <em>*</em></label> 
                            <input type="text" name="billingAddress" id="billingAddress" value="" class="largeField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="billingAddress2">Address 2</label> 
                            <input type="text" name="billingAddress2" id="billingAddress2" value="" class="largeField" maxlength="100" />

                        </div>
    
                        <div class="field">
                            <label for="billingApt">Apt/Suite</label> 
                            <input type="text" name="billingApt" id="billingApt" value="" class="smallField" maxlength="20" />
                        </div>
    
                        <div class="field">
                            <label for="billingCity">City <em>*</em></label> 
                            <input type="text" name="billingCity" id="billingCity" value="" class="mediumField" maxlength="100" />

                        </div>
    
                        <div class="field">
                            <label for="billingState">State/Province <em>*</em></label> 
                            <input type="text" name="billingState" id="billingState" value="" class="mediumField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="billingZipCode">Zip/Postal Code <em>*</em></label> 
                            <input type="text" name="billingZipCode" id="billingZipCode" value="" class="smallField" maxlength="20" />

                        </div>
    
                        <div class="field">
                            <label for="billingCountryID">Country <em>*</em></label> 
                            <select name="billingCountryID" id="billingCountryID" class="mediumField">
                                <option value=""></option> 
                                
                                    <option value="1"  >Afghanistan</option>
                                
                                    <option value="2"  >Albania</option>
                                
                                    <option value="3"  >Algeria</option>

                                
                                    <option value="4"  >American Samoa</option>
                                
                                    <option value="5"  >Andorra</option>
                                
                                    <option value="6"  >Angola</option>
                                
                                    <option value="7"  >Anguilla</option>
                                
                                    <option value="8"  >Antigua & Barbuda</option>
                                
                                    <option value="9"  >Argentina</option>

                                
                                    <option value="10"  >Armenia</option>
                                
                                    <option value="11"  >Aruba</option>
                                
                                    <option value="12"  >Australia</option>
                                
                                    <option value="13"  >Austria</option>
                                
                                    <option value="14"  >Azerbaijan</option>
                                
                                    <option value="15"  >Bahamas</option>

                                
                                    <option value="16"  >Bahrain</option>
                                
                                    <option value="17"  >Bangladesh</option>
                                
                                    <option value="18"  >Barbados</option>
                                
                                    <option value="19"  >Belarus</option>
                                
                                    <option value="20"  >Belgium</option>
                                
                                    <option value="21"  >Belize</option>

                                
                                    <option value="22"  >Benin</option>
                                
                                    <option value="23"  >Bermuda</option>
                                
                                    <option value="24"  >Bhutan</option>
                                
                                    <option value="25"  >Bolivia</option>
                                
                                    <option value="26"  >Bosnia & Herzegovina</option>
                                
                                    <option value="27"  >Botswana</option>

                                
                                    <option value="28"  >Brazil</option>
                                
                                    <option value="29"  >British Indian Ocean Territory</option>
                                
                                    <option value="30"  >Brunei</option>
                                
                                    <option value="31"  >Bulgaria</option>
                                
                                    <option value="32"  >Burkina Faso</option>
                                
                                    <option value="33"  >Burundi</option>

                                
                                    <option value="34"  >Cambodia</option>
                                
                                    <option value="35"  >Cameroon</option>
                                
                                    <option value="36"  >Canada</option>
                                
                                    <option value="37"  >Cape Verde</option>
                                
                                    <option value="38"  >Cayman Islands</option>
                                
                                    <option value="39"  >Central African Republic</option>

                                
                                    <option value="40"  >Chad</option>
                                
                                    <option value="41"  >Chile</option>
                                
                                    <option value="42"  >China</option>
                                
                                    <option value="43"  >Christmas Island</option>
                                
                                    <option value="44"  >Cocos Island</option>
                                
                                    <option value="45"  >Colombia</option>

                                
                                    <option value="46"  >Comoros</option>
                                
                                    <option value="47"  >Congo</option>
                                
                                    <option value="48"  >Cook Islands</option>
                                
                                    <option value="49"  >Costa Rica</option>
                                
                                    <option value="50"  >Cote D'Ivore</option>
                                
                                    <option value="51"  >Croatia</option>

                                
                                    <option value="52"  >Cuba</option>
                                
                                    <option value="53"  >Czech Republic</option>
                                
                                    <option value="54"  >Denmark</option>
                                
                                    <option value="55"  >Djibouti</option>
                                
                                    <option value="56"  >Dominica</option>
                                
                                    <option value="57"  >Dominican Republic</option>

                                
                                    <option value="58"  >East Timor</option>
                                
                                    <option value="59"  >Ecuador</option>
                                
                                    <option value="60"  >Egypt</option>
                                
                                    <option value="61"  >El Salvador</option>
                                
                                    <option value="62"  >Equatorial Guinea</option>
                                
                                    <option value="63"  >Eritrea</option>

                                
                                    <option value="64"  >Estonia</option>
                                
                                    <option value="65"  >Ethiopia</option>
                                
                                    <option value="66"  >Falkland Islands</option>
                                
                                    <option value="67"  >Faroe Islands</option>
                                
                                    <option value="68"  >Fiji</option>
                                
                                    <option value="69"  >Finland</option>

                                
                                    <option value="70"  >France</option>
                                
                                    <option value="71"  >French Guiana</option>
                                
                                    <option value="72"  >French Polynesia</option>
                                
                                    <option value="73"  >French Southern Territories</option>
                                
                                    <option value="74"  >Gabon</option>
                                
                                    <option value="75"  >Gambia</option>

                                
                                    <option value="76"  >Gaza</option>
                                
                                    <option value="77"  >Georgia</option>
                                
                                    <option value="78"  >Germany</option>
                                
                                    <option value="79"  >Ghana</option>
                                
                                    <option value="80"  >Gibraltar</option>
                                
                                    <option value="81"  >Greece</option>

                                
                                    <option value="82"  >Greenland</option>
                                
                                    <option value="83"  >Grenada</option>
                                
                                    <option value="84"  >Guadeloupe</option>
                                
                                    <option value="85"  >Guam</option>
                                
                                    <option value="86"  >Guatemala</option>
                                
                                    <option value="87"  >Guinea</option>

                                
                                    <option value="88"  >Guyana</option>
                                
                                    <option value="89"  >Haiti</option>
                                
                                    <option value="90"  >Honduras</option>
                                
                                    <option value="91"  >Hong Kong</option>
                                
                                    <option value="92"  >Hungary</option>
                                
                                    <option value="93"  >Iceland</option>

                                
                                    <option value="94"  >India</option>
                                
                                    <option value="95"  >Indonesia</option>
                                
                                    <option value="96"  >Iran</option>
                                
                                    <option value="97"  >Iraq</option>
                                
                                    <option value="98"  >Ireland</option>
                                
                                    <option value="99"  >Israel</option>

                                
                                    <option value="100"  >Italy</option>
                                
                                    <option value="101"  >Jamaica</option>
                                
                                    <option value="102"  >Japan</option>
                                
                                    <option value="103"  >Jordan</option>
                                
                                    <option value="104"  >Kazakhstan</option>
                                
                                    <option value="105"  >Kenya</option>

                                
                                    <option value="106"  >Kiribati</option>
                                
                                    <option value="107"  >Korea North</option>
                                
                                    <option value="108"  >Korea South</option>
                                
                                    <option value="109"  >Kuwait</option>
                                
                                    <option value="110"  >Kyrgyzstan</option>
                                
                                    <option value="111"  >Laos</option>

                                
                                    <option value="112"  >Latvia</option>
                                
                                    <option value="113"  >Lebanon</option>
                                
                                    <option value="114"  >Lesotho</option>
                                
                                    <option value="115"  >Liberia</option>
                                
                                    <option value="116"  >Libya</option>
                                
                                    <option value="117"  >Liechtenstein</option>

                                
                                    <option value="118"  >Lithuania</option>
                                
                                    <option value="119"  >Luxembourg</option>
                                
                                    <option value="120"  >Macau</option>
                                
                                    <option value="121"  >Macedonia</option>
                                
                                    <option value="122"  >Madagascar</option>
                                
                                    <option value="123"  >Malawi</option>

                                
                                    <option value="124"  >Malaysia</option>
                                
                                    <option value="125"  >Maldives</option>
                                
                                    <option value="126"  >Mali</option>
                                
                                    <option value="127"  >Malta</option>
                                
                                    <option value="128"  >Marshall Islands</option>
                                
                                    <option value="129"  >Martinique</option>

                                
                                    <option value="130"  >Mauritania</option>
                                
                                    <option value="131"  >Mauritius</option>
                                
                                    <option value="132"  >Mayotte</option>
                                
                                    <option value="133"  >Mexico</option>
                                
                                    <option value="134"  >Moldova</option>
                                
                                    <option value="135"  >Monaco</option>

                                
                                    <option value="136"  >Mongolia</option>
                                
                                    <option value="137"  >Montenegro</option>
                                
                                    <option value="138"  >Montserrat</option>
                                
                                    <option value="139"  >Morocco</option>
                                
                                    <option value="140"  >Mozambique</option>
                                
                                    <option value="141"  >Nambia</option>

                                
                                    <option value="142"  >Nauru</option>
                                
                                    <option value="143"  >Nepal</option>
                                
                                    <option value="144"  >Netherland Antilles</option>
                                
                                    <option value="145"  >Netherlands</option>
                                
                                    <option value="146"  >New Caledonia</option>
                                
                                    <option value="147"  >New Zealand</option>

                                
                                    <option value="148"  >Nicaragua</option>
                                
                                    <option value="149"  >Niger</option>
                                
                                    <option value="150"  >Nigeria</option>
                                
                                    <option value="151"  >Niue</option>
                                
                                    <option value="152"  >Norfolk Island</option>
                                
                                    <option value="153"  >Norway</option>

                                
                                    <option value="154"  >Oman</option>
                                
                                    <option value="155"  >Pakistan</option>
                                
                                    <option value="156"  >Palau Island</option>
                                
                                    <option value="157"  >Panama</option>
                                
                                    <option value="158"  >Papua New Guinea</option>
                                
                                    <option value="159"  >Paraguay</option>

                                
                                    <option value="160"  >Peru</option>
                                
                                    <option value="161"  >Philippines</option>
                                
                                    <option value="162"  >Pitcairn Island</option>
                                
                                    <option value="163"  >Poland</option>
                                
                                    <option value="164"  >Portugal</option>
                                
                                    <option value="165"  >Puerto Rico</option>

                                
                                    <option value="166"  >Qatar</option>
                                
                                    <option value="167"  >Republic of Kosovo</option>
                                
                                    <option value="168"  >Republic of San Marino</option>
                                
                                    <option value="169"  >Reunion</option>
                                
                                    <option value="170"  >Romania</option>
                                
                                    <option value="171"  >Russia</option>

                                
                                    <option value="172"  >Rwanda</option>
                                
                                    <option value="173"  >Samoa</option>
                                
                                    <option value="174"  >Sao Tome & Principe</option>
                                
                                    <option value="175"  >Saudi Arabia</option>
                                
                                    <option value="176"  >Senegal</option>
                                
                                    <option value="177"  >Serbia</option>

                                
                                    <option value="178"  >Serbia and Montenegro</option>
                                
                                    <option value="179"  >Seychelles</option>
                                
                                    <option value="180"  >Sierra Leone</option>
                                
                                    <option value="181"  >Singapore</option>
                                
                                    <option value="182"  >Slovakia</option>
                                
                                    <option value="183"  >Slovenia</option>

                                
                                    <option value="184"  >Solomon Islands</option>
                                
                                    <option value="185"  >Somalia</option>
                                
                                    <option value="186"  >South Africa</option>
                                
                                    <option value="187"  >Spain</option>
                                
                                    <option value="188"  >Sri Lanka</option>
                                
                                    <option value="189"  >Stateless</option>

                                
                                    <option value="190"  >Suriname</option>
                                
                                    <option value="191"  >Sweden</option>
                                
                                    <option value="192"  >Switzerland</option>
                                
                                    <option value="193"  >Syria</option>
                                
                                    <option value="194"  >Taiwan</option>
                                
                                    <option value="195"  >Tajikistan</option>

                                
                                    <option value="196"  >Tanzania</option>
                                
                                    <option value="197"  >Thailand</option>
                                
                                    <option value="198"  >Togo</option>
                                
                                    <option value="199"  >Tokelau</option>
                                
                                    <option value="200"  >Tonga</option>
                                
                                    <option value="201"  >Trinidad & Tobago</option>

                                
                                    <option value="202"  >Tunisia</option>
                                
                                    <option value="203"  >Turkey</option>
                                
                                    <option value="204"  >Turkmenistan</option>
                                
                                    <option value="205"  >Turks & Caicos Is</option>
                                
                                    <option value="206"  >Tuvalu</option>
                                
                                    <option value="207"  >Uganda</option>

                                
                                    <option value="208"  >Ukraine</option>
                                
                                    <option value="209"  >United Arab Erimates</option>
                                
                                    <option value="210"  >United Kingdom</option>
                                
                                    <option value="211"  >United States of America</option>
                                
                                    <option value="212"  >Uruguay</option>
                                
                                    <option value="213"  >Uzbekistan</option>

                                
                                    <option value="214"  >Vanuatu</option>
                                
                                    <option value="215"  >Vatican City State</option>
                                
                                    <option value="216"  >Venezuela</option>
                                
                                    <option value="217"  >Vietnam</option>
                                
                                    <option value="218"  >Virgin Islands (USA)</option>
                                
                                    <option value="219"  >Wallis & Futana Is</option>

                                
                                    <option value="220"  >West Bank</option>
                                
                                    <option value="221"  >Yemen</option>
                                
                                    <option value="222"  >Yugoslavia</option>
                                
                                    <option value="223"  >Zambia</option>
                                
                                    <option value="224"  >Zimbabwe</option>
                                
                            </select>

                        </div>
    
                    </fieldset>
    
                    <fieldset>
                                           
                        <div class="controlset">
                            <span class="label"><em>*</em></span>
                            <div class="field">
                                <input type="checkbox" name="paymentAgreement" id="paymentAgreement" value="1" /> 
                                &nbsp; 
                                <label for="paymentAgreement">

                                    I Agree with the Terms and Conditions listed below.
                                </label>
                            </div>
                        </div>

						
                        <div class="field">
                            <span class="label">&nbsp;</span>  
                            <textarea name="granbyPolicy" id="granbyPolicy" class="largeTextFieldPolicy" readonly="readonly">APPLICATION FEE PAYMENT - A $150.00 application fee is required. The fee is non-refundable and is independent of an admission decision or decision to withdraw or decline an offer of acceptance. 
You may pay by credit or debit card. Your application will not be processed until full payment is received. Granby Preparatory Academy is affiliated with IEC, LLC.</textarea>                                    	
                        </div>

                    </fieldset>

                    <div class="buttonrow">
                        <input type="submit" value="Submit" class="button ui-corner-top" />
                    </div>
                
                    </form>
				
                                    
            
            </div><!-- /form-container -->

		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        



    			
                </div> 
                
                <div class="pageFooter">

                    <div class="footerText">Copyright &copy; 2010 Granby Preparatory Academy. ALL RIGHTS RESERVED.</div>
                </div>
                
            
    
    </body>
    </html>
    
    

<script type="text/javascript">
	// Display Credit Card
	$(document).ready(function() {
		// Get Current Value
		getSelected = $("#creditCardType").val();
		//getSelected = $("input[@name='creditCardType']:checked").val(); // CheckBox
		displayCreditCard(getSelected);
	});
</script>


