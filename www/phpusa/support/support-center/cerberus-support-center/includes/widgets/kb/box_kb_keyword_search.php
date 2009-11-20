<?php

require_once (FILESYSTEM_PATH . "cerberus-api/search/cer_SearchIndex.class.php");
$search = new cer_searchIndex();

if(!empty($kb_ask)) {
	$search->indexWords($kb_ask);
	$search->removeExcludedKeywords();
	$search->loadWordIDs(1);
}

$keywords = array();

$sql = sprintf("SELECT si.word_id, w.word, count(si.word_id)  AS instances ".
		"FROM (`search_index_kb` si, `search_words` w) ".
		"WHERE si.word_id = w.word_id AND si.word_id IN ( %s )  ".
		"GROUP BY si.word_id ".
		"ORDER BY instances DESC ".
		"LIMIT 0,5", // keep the five top linked keywords
			implode(",", array_values($search->wordarray))
	);
$res = $cerberus_db->query($sql);

if($cerberus_db->num_rows($res)) {
	while($word_row = $cerberus_db->fetch_row($res)) {
		$id = $word_row["word_id"];
		$word = $word_row["word"];
		$count = $word_row["instances"];
		$keywords[] = $word;
	}
}

$keyword_string = "";

if(!empty($keywords)) {
	$keyword_string = implode(' ',$keywords);
}
else if (!empty($kb_keywords)) {
	$keyword_string = $kb_keywords;
}

?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Didn't Find the Answer you were Looking for?</span></td>
	</tr>
	
	<tr class="white_back">
		<td class="box_content_text">

			<form action="<?php echo BASE_URL; ?>">
			<B>Try a Keyword Search:</B><br>
			<input type="text" name="kb_keywords" value="<?php echo $keyword_string; ?>" size="45"><input type="submit" value="Search" class="button_style"><br>
			<input type="hidden" name="mod_id" value="<?php echo MODULE_KNOWLEDGEBASE; ?>">
			<?php if (!empty($_REQUEST["op"])) {?>
				<input type="hidden" name="op" value="<?php echo $_REQUEST["op"]; ?>">
			<?php }
			if (!empty($_REQUEST["tile"])) { ?>
				<input type="hidden" name="tile" value="<?php echo $_REQUEST["tile"]; ?>">
			<?php } ?>
			(Enter keywords separated by a space. For example: <i>product warranty information</i>)<br>
			<br>
			Some high probablility keywords from your question may have already been added for you.<br>
			</form>		
		
		</td>
	</tr>
	
</table>

