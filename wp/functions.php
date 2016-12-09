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
    if (array_key_exists('td_subtitle', $meta_data)){
      return $meta_data['td_subtitle'];
    } else {
      return false;
    }
}

/******* Begin custom functions for WP REST API *******/

add_action( 'rest_api_init', 'slug_register_subtitle' );
function slug_register_subtitle() {
    register_rest_field( 'post',
        'wps_subtitle',
        array(
            'get_callback'    => 'slug_get_subtitle',
            'update_callback' => null,
            'schema'          => null,
        )
    );
}

/**
 * Get the value of the "wps_subtitle" field
 *
 * @param array $object Details of current post.
 * @param string $field_name Name of field.
 * @param WP_REST_Request $request Current request
 *
 * @return mixed
 */
function slug_get_subtitle( $object, $field_name, $request ) {
    return get_post_meta( $object[ 'id' ], $field_name, true );
}

add_action( 'rest_api_init', 'slug_register_td_post_theme_settings' );
function slug_register_td_post_theme_settings() {
    register_rest_field( 'post',
        'td_post_theme_settings',
        array(
            'get_callback'    => 'slug_get_td_post_theme_settings',
            'update_callback' => null,
            'schema'          => null,
        )
    );
}

/**
 * Get the value of the "td_post_theme_settings" field
 *
 * @param array $object Details of current post.
 * @param string $field_name Name of field.
 * @param WP_REST_Request $request Current request
 *
 * @return mixed
 */
function slug_get_td_post_theme_settings( $object, $field_name, $request ) {
    return get_post_meta( $object[ 'id' ], $field_name, true );
}


add_action('rest_api_init', 'md_register_author_meta_rest_field');
function md_get_author_meta($object, $field_name, $request) {

    $user_data = get_userdata($object['author']); // get user data from author ID.

    $array_data = (array)($user_data->data); // object to array conversion.

    $array_data['first_name'] = get_user_meta($object['author'], 'first_name', true);
    $array_data['last_name']  = get_user_meta($object['author'], 'last_name', true);

    // prevent user enumeration.
    unset($array_data['user_login']);
    unset($array_data['user_pass']);
    unset($array_data['user_activation_key']);

    return array_filter($array_data);

}

function md_register_author_meta_rest_field() {

    register_rest_field('post', 'author_meta', [
        'get_callback'    => 'md_get_author_meta',
        'update_callback' => 'null',
        'schema'          => 'null',
    ]);

}

add_action( 'rest_api_init', 'md_insert_thumbnail_url' );
function md_insert_thumbnail_url() {
    register_rest_field( 'post',
        'md_thumbnail',
        array(
            'get_callback'    => 'md_get_thumbnail_url',
            'update_callback' => null,
            'schema'          => null,
        )
    );
}

function md_get_thumbnail_url($post){
    if(has_post_thumbnail($post['id'])){
        $imgArray = wp_get_attachment_image_src( get_post_thumbnail_id( $post['id'] ), 'maverick-big' );
        $imgURL = $imgArray[0];
        return $imgURL;
    }else{
        return false;   
    }
}

/******* END custom functions for WP REST API *******/

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