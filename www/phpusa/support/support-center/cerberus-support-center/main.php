<?php
require_once(FILESYSTEM_PATH . "includes/functions/compatibility.php");
require_once(FILESYSTEM_PATH . "cerberus-api/public-gui/cer_PublicGUISettings.class.php");
include_once(FILESYSTEM_PATH . "cerberus-api/knowledgebase/CerKnowledgebase.class.php");

// [JAS]: This is where sessions, modules and parameters need to be controlled.
$pubgui = new cer_PublicGUISettings(PROFILE_ID);

if(!$pubgui->checkProfileID(PROFILE_ID)) {
	echo "Cerberus Support Center [ERROR]: The PROFILE_ID in config.php is not valid.  Check the [Configuration]->Public GUI Profiles area in the Cerberus GUI.";
	exit;
}

$base_url = $_SERVER['PHP_SELF'];

// Check to see if the request URI had variables already
if(strstr($base_url,"?") === false) {
	$base_url .= "?x=";
}

//$pub_tag_sets = $pubgui->settings["pub_mod_kb_tag_sets"];
//$pub_root_children = array();

$kb = new CerKnowledgebase(true);
$pub_kb_root = $pubgui->settings['pub_mod_kb_root'];

$kb_root_desc = array();
if(0 != $pub_kb_root) {
	$cats = $kb->getCategories();
	$root_cat = $cats[$pub_kb_root]; /* @var $root_cat CerKnowledgebaseCategory */
	$kb_root_desc = $root_cat->getDescendents();
}

include_once(FILESYSTEM_PATH . "/cerberus-api/workstation/CerWorkstationKbTags.class.php");
$tags = new CerWorkstationKbTags(1);

?>

<table cellpadding="4" cellspacing="3" border="0" bgcolor="#FFFFFF" width='800'>
	<tr>
		<td valign='top' width='200'>
		
			<?php include("includes/widgets/module_left.php"); ?>
			
		</td>
		
		<td valign='top' width='600'>
		
			<?php include("includes/widgets/module_selecter.php"); ?>
			
		</td>
	</tr>
</table>
