<style type="text/css">
.menu{
	border:none;
	border:0px;
	margin:0px;
	padding:0px;
	font-family:verdana,geneva,arial,helvetica,sans-serif;
	font-size:13px;
	font-weight:bold;
	color:8e8e8e;
	}
.menu ul{
	background:url(images/menu-bg.gif) top left repeat-x;
	height:43px;
	list-style:none;
	margin:0;
	padding:0;
	}
	.menu li{
		float:left;
		}
	.menu li a{
		color:#666666;
		display:block;
		font-weight:bold;
		line-height:43px;
		padding:0px 25px;
		text-align:center;
		text-decoration:none;
		}
		.menu li a:hover{
			color:#000000;
			text-decoration:none;
			}
	.menu li ul{
		background:#e0e0e0;
		border-left:2px solid #0079b2;
		border-right:2px solid #0079b2;
		border-bottom:2px solid #0079b2;
		display:none;
		height:auto;
		filter:alpha(opacity=95);
		opacity:0.95;
		position:absolute;
		width:225px;
		z-index:200;
		/*top:1em;
		/*left:0;*/
		}
	.menu li:hover ul{
		display:block;
		}
	.menu li li {
		display:block;
		float:none;
		width:225px;
		}
	.menu li ul a{
		display:block;
		font-size:12px;
		font-style:normal;
		padding:0px 10px 0px 15px;
		text-align:left;
		}
		.menu li ul a:hover{
			background:#949494;
			color:#000000;
			opacity:1.0;
			filter:alpha(opacity=100);
			}
	.menu p{
		clear:left;
		}	
	.menu #current{
		background:url(images/current-bg.gif) top left repeat-x;
		color:#ffffff;
		}
		
</style>

	<div class="menu">
		<ul>
			<li><a href="#" >Home</a></li>
			<li><a href="#" id="current">Participants</a>
				<ul>
					<li><a href="#">Becoming a Participant</a></li>
					<li><a href="#">Self-placed without Agent</a></li>
					<li><a href="#">Participant Success Stories</a></li>
					<li><a href="#">Downloads</a></li>
                    <li><a href="#">FAQ</a></li>
                    <li><a class="menu" href="#">Resources</a>
                    <ul>
                    <li><a href="#">FAQ</a></li>
                    <li><a href="#">FAQ</a></li>
                    <li><a href="#">FAQ</a></li>
                    <li><a href="#">FAQ</a></li>
                    </ul></li>
			   </ul>
		  </li>
			<li><a href="/faq.php">FAQ</a>
                <ul>
                <li><a href="#">Drop Down CSS Menus</a></li>
                <li><a href="#">Horizontal CSS Menus</a></li>
                <li><a href="#">Vertical CSS Menus</a></li>
                <li><a href="#">Dreamweaver Menus</a></li>
                </ul>
          </li>
			<li><a href="/contact/contact.php">Contact</a></li>
		</ul>
	</div>
