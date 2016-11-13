<?php
/**
 * The template includes necessary functions for theme.
 *
 * @package maverick
 * @since 1.0
 */
add_action( 'after_setup_theme', 'maverick_after_setup' );
/**
 * Theme options variable $rs_theme_options
 */
define ('REDUX_OPT_NAME', 'maverick_theme_options');

/**
 * Theme version used for styles,js
 */
define ('MAVERICK_THEME_VERSION','1.0');

require get_template_directory() . '/framework/includes/rs-actions-config.php';
require get_template_directory() . '/framework/includes/rs-helper-functions.php';
require get_template_directory() . '/framework/includes/rs-frontend-functions.php';
require get_template_directory() . '/framework/includes/rs-include-config.php';
require get_template_directory() . '/framework/includes/rs-filters-config.php';
require get_template_directory() . '/framework/includes/rs-menu-walker.php';
require get_template_directory() . '/framework/admin/admin-init.php';
require get_template_directory() . '/framework/includes/widgets/WP_Latest_Posts_Widget.class.php';
require get_template_directory() . '/framework/includes/widgets/WP_Social_Widget.class.php';
require get_template_directory() . '/framework/includes/widgets/WP_Custom_Ads_Widget.class.php';

//get subtitles from old Newspaper theme
function get_newspaper_subtitle($post) {
    $meta_data = get_post_meta($post->ID, 'td_post_theme_settings', true);
    if (is_array($meta_data) && array_key_exists('td_subtitle', $meta_data)){
      return $meta_data['td_subtitle'];
    } else {
      return false;
    }
}
// After Theme Setup.
// ----------------------------------------------------------------------------------------------------
if( !function_exists('maverick_after_setup')) {

  function maverick_after_setup() {

    add_image_size('maverick-big',        690, 460, true );
    add_image_size('maverick-big-alt',    735, 735, true);
    add_image_size('maverick-medium',     310, 260, true );
    add_image_size('maverick-medium-alt', 330, 230, true );
    add_image_size('maverick-small',      210, 140, true );
    add_image_size('maverick-thumb',      90,  70, true );

    add_theme_support('post-thumbnails');
    add_theme_support('custom-background' );
    add_theme_support('automatic-feed-links' );
    add_theme_support('post-formats',   array('video', 'gallery') );
    add_theme_support('title-tag' );
    // Register Menus.
    // ----------------------------------------------------------------------------------------------------
    register_nav_menus (array(
      'primary-menu' => esc_html__( 'Main Menu', 'maverick' ),
      'top-menu'     => esc_html__('Header Menu', 'maverick')
    ) );
  }

}

if ( ! isset( $content_width ) ) {
  $content_width = 1140;
}

// Makes Youtube Videos Responsive
add_filter( 'embed_oembed_html', 'custom_oembed_filter', 10, 4 ) ;

function custom_oembed_filter($html, $url, $attr, $post_ID) {
    $return = '<div class="video-container">'.$html.'</div>';
    return $return;
}

// This links the thumbnail to the post permalink

add_filter( 'post_thumbnail_html', 'my_post_image_html', 10, 3 );

function my_post_image_html( $html, $post_id, $post_image_id ) {

	$html = '<a href="' . get_permalink( $post_id ) . '" title="' . esc_attr( get_post_field( 'post_title', $post_id ) ) . '">' . $html . '</a>';

	return $html;
}

?>