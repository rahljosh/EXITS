<?php
require_once("modernbill_session.php");

// [JAS]: This is where sessions, modules and parameters need to be controlled.
$pubgui = new cer_PublicGUISettings(PROFILE_ID);

if(!$pubgui->checkProfileID(PROFILE_ID)) {
	echo "Cerberus Support Center [ERROR]: The PROFILE_ID in config.php is not valid.  Check the [Configuration]->Public GUI Profiles area in the Cerberus GUI.";
	exit;
}
include_once(FILESYSTEM_PATH . "cerberus-api/workstation/CerWorkstationKbTags.class.php");
$tags = new CerWorkstationKbTags(1);
?>

<link rel="stylesheet" href="<?php echo DIRECTORY_NAME; ?>/themes/blue/cerberus-theme.css" type="text/css">

<table cellpadding="4" cellspacing="3" border="0" width='100%'>
	<tr>
		<td valign='top'>
		
			<?php
			if(empty($_REQUEST["mod_id"]))
			switch($_REQUEST["tile"]) {
				case "getsupport_tab":
					$_REQUEST["mod_id"] = 4;
					break;
					
				case "mysupport":
					if(isset($_REQUEST["type"]) && $_REQUEST["type"] == "add")
						$_REQUEST["mod_id"] = 4;
					else
						$_REQUEST["mod_id"] = 5;
					break;
					
				case "faq":
					$_REQUEST["mod_id"] = 2;
					break;
			}
			
			include(FILESYSTEM_PATH . "includes/widgets/module_selecter.php");
			?>
			
		</td>
	</tr>
</table>
