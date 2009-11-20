<?php
//if(!empty($kb_tags)) {
//	$articles = $wskb->getArticlesByTags($kb_tags);
//} else {
$articles = $wskb->getArticlesByKeywords($kb_keywords,$kb_root_desc);
//}
?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Keyword Search Results:</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<?php
			if(is_array($articles))
			{
			?>
			<table cellpadding="2" cellspacing="0" border="0" class="white_back" width='100%'>
				<tr>
					<td><span class="black_heading">Article Summary</span></td>
					<td align="right"><span class="black_heading">Relevance</span></td>
				</tr>
				
			<?php
			$row = 0;
			if(is_array($articles))
			foreach($articles as $article) { /* @var $article CerWorkstationKbArticle */
				
				if($row % 2) {
					$row_class = "kb_alt_bg_1"; }
				else {
					$row_class = "kb_alt_bg_2"; }
			?>
				<tr class="<?php echo $row_class; ?>">
					<td>
					<?php
						$article_title = stripslashes($kbr["kb_problem_summary"]);
						echo sprintf("<a href='%s' class='url'>%s</a>",
								BASE_URL . "&mod_id=" . MODULE_KNOWLEDGEBASE . "&id=" . $article->article_id,
								$article->article_title
							);
					?>
					</td>
					<td align="right" class="box_content_text"><?php
					echo $article->article_relevance . "%";
					?></td>
				</tr>
			<?php
				$row++;
			}
			?>
				
			</table>
			
			<?php
			}
			else {
			?>
			<table cellpadding="2" cellspacing="0" border="0" class="white_back" width='100%'>
				<tr>
					<td class="box_content_text"><span>Sorry, no articles matched the keyword search.  Please different keywords.</span></td>
				</tr>
			</table>
			
			<?php
			}
			?>
		
		</td>
	</tr>
	
</table>

<br>
