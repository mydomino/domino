
function snippetsInit() {
    $('[data-toggle="tooltip"]').tooltip();
}

$( snippetsInit ); // For direct page loads
$( document ).on( 'page:load', snippetsInit ); // For following links

