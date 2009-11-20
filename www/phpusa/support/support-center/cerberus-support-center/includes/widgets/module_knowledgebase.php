<?php
require_once (FILESYSTEM_PATH . "includes/local-api/kb/cer_PublicKnowledgebase.class.php");
include_once(FILESYSTEM_PATH . "/cerberus-api/workstation/CerWorkstationKb.class.php");

$wskb = new CerWorkstationKb(1);
if(empty($kb)) $kb = new CerKnowledgebase(true);

$root = (isset($_REQUEST["root"])) ? $_REQUEST["root"] : 0; // $pub_root
$id = (isset($_REQUEST["id"])) ? intval($_REQUEST["id"]) : 0;
$kb_keywords = (isset($_REQUEST["kb_keywords"])) ? htmlentities(stripslashes($_REQUEST["kb_keywords"])) : "";
//$kb_tags = (isset($_REQUEST["kb_tags"])) ? $_REQUEST["kb_tags"] : array();


// [JAS]: Check that the requested root is acceptable
if(0 != $pub_kb_root) {
	// [JAS]: If we can't find the requested root in our public descendents then adapt the requested root.
	if(FALSE === array_search($root,$kb_root_desc)) {
		$root = $pub_kb_root;
	}
}
//if(isset($root)) {
//	$breadcrumb = array();
//	if(empty($root)) {
//		$tree =& $tags->root;
//		$breadcrumb[0] = "Top";
//	} else {
//		$tree =& $tags->tags[$root];
//		
//		$pid = $root;
//		while($node =& $tags->tags[$pid]) {
//			$breadcrumb[''.$node->id] = $node->name;
//			$pid = $node->parent_tag_id;
//		}
//		
//		$breadcrumb['0'] = "Top";
//		$breadcrumb = array_reverse($breadcrumb, true);
//	}
//}

if($id) { // viewing an article
	require_once ("kb/box_kb_article_view.php");
}
elseif(!empty($kb_keywords)) { // keyword search // || !empty($kb_tags)
	require_once ("kb/box_kb_keyword_results.php");
	require_once ("kb/box_kb_keyword_search.php");
}
else { // browsing KB tags
	require_once ("kb/box_kb_category_table.php");
	require_once ("kb/box_kb_article_list.php");
}

?>
