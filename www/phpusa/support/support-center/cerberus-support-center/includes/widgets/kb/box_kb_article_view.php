<?php
$kb_rating = isset($_REQUEST["kb_rating"]) ? $_REQUEST["kb_rating"] : "";

if(!empty($kb_rating)) {
	$kb_rating = ($kb_rating=="yes") ? 5 : 0;
	$wskb->addArticleRating($id,$kb_rating,$_SERVER['REMOTE_ADDR']);
}

$article = $wskb->getArticleById($id); /* @var $article CerWorkstationKbArticle */

if(empty($article) || empty($article->article_id)) {
	echo "ERROR: Invalid article.";
	exit;
}

// [JAS]: Security check the article against the allowed categories
if($pub_kb_root && is_array($kb_root_desc)) {
	$found = false;
	foreach($kb_root_desc as $desc_id) {
		if(isset($article->categories[$desc_id])) {
			$found = true;
			break;
		}
	}
	
	if(!$found) {
		echo "ERROR: Access denied.";
		exit;
	}
}

// [JAS]: Don't give duplicate 'views' to an article during the same session.
if(!isset($_SESSION["cer_login"]->viewed_articles[$id])) {
	$wskb->addArticleView($id);
	$article->article_views++;
	
	$_SESSION["cer_login"]->viewed_articles[$id] = mktime();
}

$relatedIds = $tags->getRelatedArticles($id,10,$kb_root_desc);

if(!empty($relatedIds)) {
	$relatedArticles = $wskb->getArticlesByIds(array_keys($relatedIds),false,true);
}

?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
<tr>
	<td class="table_header_cell"><span class="black_heading">Knowledgebase</span></td>
</tr>

<tr>
	<td class="white_back">
	
		<span class="kb_article_title"><?php echo $article->article_title; ?></span><br>
		
		<span class="kb_category">
		<?php 
//		if(is_array($breadcrumb))
//		foreach($breadcrumb as $crumbIdx => $crumb) {
//			echo sprintf("<a href='%s&mod_id=%d&root=%d' class='kb_category'>%s</a> : ",
//				BASE_URL,
//				$mod_id,
//				$crumbIdx,
//				$crumb
//			);
//		}
		?>
		</span>
		<BR>
		
		<table cellpadding="0" cellspacing="0" border="0" class="white_back">
			<tr>
				<td class="box_content_text"><B>Article ID:</B></td>
				<td><img src="includes/images/spacer.gif" height="1" width="10"></td>
				<td class="box_content_text"><?php echo sprintf("%06d", $article->article_id); ?></td>
			</tr>
			<tr>
				<td class="box_content_text"><B>Rating:</B></td>
				<td><img src="includes/images/spacer.gif" height="1" width="10"></td>
				<td class="box_content_text">
					<?php echo sprintf("%0.1f / 5.0 (%d votes)",$article->article_rating,$article->article_votes); ?>
					<?php
						$percent = floor(($article->article_rating / 5.0) * 100);
						$percent_i = intval(100 - $percent);
					?>
					<table cellpadding="0" cellspacing="0" width="50">
						<tr>
							<td width="<?php echo $percent; ?>%" bgcolor="#EE0000"><img src="includes/images/spacer.gif" height="5" width="1"></td>
							<td width="<?php echo $percent_i; ?>%" bgcolor="#AEAEAE"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="box_content_text"><B>Views:</B></td>
				<td><img src="includes/images/spacer.gif" height="1" width="10"></td>
				<td class="box_content_text"><?php echo sprintf("%d", $article->article_views); ?></td>
			</tr>
		</table>
		
	</td>
	
</tr>
</table>

<br>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
<tr class="white_back">
	<td class="box_content_text">
		<?php
		echo $article->article_content;
		?>
		<br>
		<a href="javascript:;" onclick="history.back();" class="kb_category">&lt;&lt; back</a><br>
	</td>
</tr>	
</table>

<br>
		
<?php if(!$wskb->ipHasVoted($_SERVER['REMOTE_ADDR'],$id)) { ?>
<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
<tr>
	<td class="table_header_cell"><span class="black_heading">Rating</span></td>
</tr>

	<form action="<?php echo BASE_URL; ?>">
	<input type="hidden" name="mod_id" value="<?php echo MODULE_KNOWLEDGEBASE; ?>">
	<input type="hidden" name="id" value="<?php echo $id; ?>">
	<tr class="white_back">
		<td class="box_content_text">
			Did you find this article helpful?<br>
			<select name="kb_rating">
				<option value="yes">Yes
				<option value="no">No
			</select>
			<input type="submit" value="Rate" class="button_style">
		</td>
	</tr>
	</form>
	
</table>
<br>
<?php } ?>
			

<?php

if(!empty($relatedArticles)) {
?>
	<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
		<tr>
			<td class="table_header_cell"><span class="black_heading">Related Articles</span></td>
		</tr>
		
		<tr class="white_back">
			<td class="box_content_text">
			
				<table cellpadding="2" cellspacing="0" border="0" class="white_back" width='100%'>
				<?php
				$row = 0;
				if(is_array($relatedArticles))
				foreach($relatedArticles as $relArticle) {
					if($row % 2) {
						$bg = "#FFFFFF"; }
					else {
						$bg = "#F8F8F8"; }
				?>
					<tr>
						<td bgcolor="<?php echo $bg; ?>" class="box_content_text">
						<?php
							$article_title = $relArticle->article_title;
							echo sprintf("<a href='%s' class='url'>%s</a>",
									BASE_URL . "&mod_id=" . MODULE_KNOWLEDGEBASE . "&id=" . $relArticle->article_id,
									$article_title
								);
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
	
<?php
}
?>		
	
