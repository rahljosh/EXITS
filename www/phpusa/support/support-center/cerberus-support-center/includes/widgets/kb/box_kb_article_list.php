<?php
$articles = $wskb->getArticlesByTags(array($root));

if($root) {
	$kb_root = $categories[$root];
} else {
	$kb_root = $kb->getRoot();
}

$articles = $kb_root->getResources(500,1);

if(is_array($articles)) {
?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">
			<?php if(!empty($kb_root->id)) { ?>
				Articles in '<?php echo $kb_root->name; ?>'
			<?php } else { ?>
				Uncategorized Articles
			<?php } ?></span>
		</td>
	</tr>

	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="0" border="0" class="white_back" width='100%'>
				<tr>
					<td><span class="black_heading">Summary</span></td>
					<td align="center" nowrap><span class="black_heading">User Rating</span></td>
				</tr>
				<?php
				$row = 0;
				foreach($articles as $article) { /* @var $article CerWorkstationKbArticle */
					if($row % 2) {
						$row_class = "kb_alt_bg_1"; }
					else {
						$row_class = "kb_alt_bg_2"; }
				?>
				<tr class="<?php echo $row_class; ?>">
					<td>
						<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_kb_article.gif" align="absmiddle">
						<?php
							echo sprintf("<a href='%s' class='url'>%s</a>",
									BASE_URL . "&mod_id=" . MODULE_KNOWLEDGEBASE . "&root=" . $kb_root->id . "&id=" . $article->id,
									$article->name
								);
						?>
					</td>
					<td valign="middle" align="center" class="box_content_text">
						<?php
						if($article->rating) {
						$percent = floor(($article->rating / 5.0) * 100);
						$percent_i = intval(100 - $percent);
						?>
						<?php echo sprintf("%0.1f",$article->rating); ?> / 5.0
						<table cellpadding="0" cellspacing="0" width="50">
							<tr>
								<td width="<?php echo $percent; ?>%" bgcolor="#EE0000"><img src="includes/images/spacer.gif" height="5" width="1"></td>
								<td width="<?php echo $percent_i; ?>%" bgcolor="#AEAEAE"></td>
							</tr>
						</table>
			        	<?php
						}
						else {
							echo "N/A";
						}
						?>
					</td>
				</tr>
				<?php
					$row++;
				}
				?>
			</table>		
		
		</td>
	</tr>	

</table>

<br>

<?php
}
?>