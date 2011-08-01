<script src="http://code.jquery.com/jquery-latest.js" type="text/javascript"></script>
<script type="text/javascript">
        $(document).ready(function() {

            $(".signin").click(function(e) {
                e.preventDefault();
                $("fieldset#signin_menu").toggle();
                $(".signin").toggleClass("menu-open");
            });

            $("fieldset#signin_menu").mouseup(function() {
                return false
            });
            $(document).mouseup(function(e) {
                if($(e.target).parent("a.signin").length==0) {
                    $(".signin").removeClass("menu-open");
                    $("fieldset#signin_menu").hide();
                }
            });            

        });
</script>
<script src="http://code.jquery.com/jquery-latest.j/jquery.tipsy.js" type="text/javascript"></script>
<script type='text/javascript'>
    $(function() {
      $('#forgot_username_link').tipsy({gravity: 'w'});
    });
 </script>
</head>

<body>
<style type="text/css">
#login_container {
    width:700px;
    margin:0 auto;
    position: relative;
}

#content {
    width:520px;
    min-height:500px;
}
a:link, a:visited {
    color:#27b;
    text-decoration:none;
}
a:hover {
    text-decoration:underline;
}
a img {
    border-width:0;
}
#topnav {
    padding:10px 0px 12px;
    font-size:11px;
    line-height:23px;
    text-align:right;
}
#topnav a.signin {
    background:#88bbd4;
    padding:4px 6px 6px;
    text-decoration:none;
    font-weight:bold;
    color:#fff;
    -webkit-border-radius:4px;
    -moz-border-radius:4px;
    border-radius:4px;
    *background:transparent url("images/signin-nav-bg-ie.png") no-repeat 0 0;
    *padding:4px 12px 6px;
}
#topnav a.signin:hover {
    background:#59B;
    *background:transparent url("images/signin-nav-bg-hover-ie.png") no-repeat 0 0;
    *padding:4px 12px 6px;
}
#topnav a.signin, #topnav a.signin:hover {
    *background-position:0 3px!important;
}

a.signin {
    position:relative;
    margin-left:3px;
}
a.signin span {
    background-image:url("images/toggle_down_light.png");
    background-repeat:no-repeat;
    background-position:100% 50%;
    padding:4px 16px 6px 0;
}
#topnav a.menu-open {
    background:#ddeef6!important;
    color:#666!important;
    outline:none;
}
#small_signup {
    display:inline;
    float:none;
    line-height:23px;
    margin:25px 0 0;
    width:170px;
}
a.signin.menu-open span {
    background-image:url("images/toggle_up_dark.png");
    color:#789;
}

/****Login Form****/
#signin_menu {
    -moz-border-radius-topleft:5px;
    -moz-border-radius-bottomleft:5px;
    -moz-border-radius-bottomright:5px;
    -webkit-border-top-left-radius:0px;
    -webkit-border-bottom-left-radius:0px;
    -webkit-border-bottom-right-radius:5px;
    display:none;
    background-color:#afcee3;
    position:absolute;
    width:210px;
    z-index:100;
    border:1px transparent;
    text-align:left;
    padding:12px;
    top: 24.5px; 
    right: 0px; 
    margin-top:5px;
    margin-right: 0px;
    *margin-right: -1px;
    color:#789;
    font-size:11px;
}

#signin_menu input[type=text], #signin_menu input[type=password] {
    display:block;
    -moz-border-radius:4px;
    -webkit-border-radius:4px;
    border:1px solid #ACE;
    font-size:13px;
    margin:0 0 5px;
    padding:5px;
    width:203px;
}
#signin_menu p {
    margin:0;
}
#signin_menu a {
    color:#6AC;
}
#signin_menu label {
    font-weight:normal;
}
#signin_menu p.remember {
    padding:10px 0;
}
#signin_menu p.forgot, #signin_menu p.complete {
    clear:both;
    margin:5px 0;
}
#signin_menu p a {
    color:#27B!important;
}
#signin_submit {
    -moz-border-radius:4px;
    -webkit-border-radius:4px;
    background:#39d url('images/bg-btn-blue.png') repeat-x scroll 0 0;
    border:1px solid #39D;
    color:#fff;
    text-shadow:0 -1px 0 #39d;
    padding:4px 10px 5px;
    font-size:11px;
    margin:0 5px 0 0;
    font-weight:bold;
}
#signin_submit::-moz-focus-inner {
padding:0;
border:0;
}
#signin_submit:hover, #signin_submit:focus {
    background-position:0 -5px;
    cursor:pointer;
}
</style>


	<!-- stylesheets -->
  	<link rel="stylesheet" href="http://111cooper.com/css/style.css" type="text/css" media="screen" />
  	<link rel="stylesheet" href="http://111cooper.com/css/slide.css" type="text/css" media="screen" />
	
  	<!-- PNG FIX for IE6 -->
  	<!-- http://24ways.org/2007/supersleight-transparent-png-in-ie6 -->
	<!--[if lte IE 6]>
		<script type="text/javascript" src="js/pngfix/supersleight-min.js"></script>
	<![endif]-->
	 
    <!-- jQuery - the core -->
	<script src="js/jquery-1.3.2.min.js" type="text/javascript"></script>
	<!-- Sliding effect -->
	<script src="js/slide.js" type="text/javascript"></script>

</head>

<body>
<!-- Panel -->
<div id="toppanel">
	<div id="panel">
		<div class="content clearfix">
			<div class="left">
				
					
				<p class="grey">If you would like to be a host family, but do not have an account, you can create an acocunt here and start the application process right now. <Br />
                <a href="meet-our-students.cfm">Get started here</a></p>
                <p class="grey">Students, please contact an agent in your home country to get started on the path to becoming an exchange student. <Br />
                <a href="">Find an organization in your country</a></p>
                <p class="grey">Looking to travel abroad? Visit our Outbound site for more information <Br />
                <a href="http://outbound.iseusa.com/">Outbound Programs</a></p>
				
				
			</div>
			<div class="left">
				<!-- Login Form -->
				<form class="clearfix" action="" method="post">
					<h1>Reps & Managers</h1>
					<a href="http://111cooper.com/login.cfm"><img src="images/exitslogo.png" width="200" height="94" alt="exitslogo" border="0"></a>
				</form>
			</div>
			<div class="left right">			
				<!-- Register Form -->
				<form class="clearfix" action="hostApp/index.cfm?hello" method="post">
                <input type="hidden" name="processLogin">
					<h1>Host Family Login</h1>
					<label class="grey" for="log">Email:</label>
					<input class="field" type="text" name="username" id="log" value="" size="23" />
					<label class="grey" for="pwd">Password:</label>
					<input class="field" type="password" name="password" id="pwd" size="23" />
	            	<div class="clear"></div>
					<input type="submit" name="submit" value="Login" class="bt_login" />
					<a class="lost-pwd" href="##">Forgot your password?</a>
				</form>
			</div>
		</div>
</div> <!-- /login -->	

	<!-- The tab on top -->	
	<div class="tab">
		<ul class="login">
			<li class="left">&nbsp;</li>
            <cfoutput>
			<li><cfif isDefined('client.hostfam')>
            		<cfif client.hostfam is not ''>
                    #client.hostFam# Family
                  	<cfelse>
             		Hello Guest!
                	 </cfif>
             <cfelse>
             Hello Guest!
             </cfif>       
             </li>
             </cfoutput>
			<li class="sep">|</li>
			<li id="toggle">
            <cfoutput>
            <cfif isDefined('client.hostfam')>
            		<cfif client.hostfam is not ''>
                     <a id="open" class="open" href="http://iseusa.com/hostLogout.cfm"><font color="##15ADFF">Log Out</font></a>            
                    <cfelse>
                        <a id="open" class="open" href="##">Log In</a>
                        <a id="close" style="display: none;" class="close" href="##">Close Panel</a>
                     </cfif>
             <cfelse>
             	    <a id="open" class="open" href="##">Log In</a>
                    <a id="close" style="display: none;" class="close" href="##">Close Panel</a>      
			 </cfif>
			</cfoutput>	
			</li>
			<li class="right">&nbsp;</li>
		</ul> 
	</div> <!-- / top -->
	
</div> <!--panel -->






