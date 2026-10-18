<?php

$theme = get_stylesheet();
$templates = get_posts([
    'post_type' => 'wp_template',
    'name' => 'page',
    'post_status' => 'publish',
    'numberposts' => -1,
]);

$data = [
    'post_type' => 'wp_template',
    'post_name' => 'page',
    'post_title' => 'Pages',
    'post_status' => 'publish',
    'post_content' => '<!-- wp:group {"tagName":"main","style":{"spacing":{"padding":{"top":"48px","right":"24px","bottom":"48px","left":"24px"}}},"layout":{"type":"constrained","contentSize":"800px"}} --><main class="wp-block-group" style="padding-top:48px;padding-right:24px;padding-bottom:48px;padding-left:24px"><!-- wp:post-title {"level":1} /--><!-- wp:post-content /--></main><!-- /wp:group -->',
];

foreach ($templates as $template) {
    if (has_term($theme, 'wp_theme', $template->ID)) {
        $data['ID'] = $template->ID;
        break;
    }
}

$id = wp_insert_post($data, true);
if (is_wp_error($id)) {
    WP_CLI::error($id->get_error_message());
}

$result = wp_set_object_terms($id, $theme, 'wp_theme');
if (is_wp_error($result)) {
    WP_CLI::error($result->get_error_message());
}
