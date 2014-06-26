$ ( document ).ready ( function () {
    $ ( '#formLogin' ).submit ( function ( e ) {
        e.preventDefault ();

        var data = $ ( this ).serialize ();
        var url = $ ( this ).attr ( 'action' );

        $.get ( url, data, function ( response ) {
            if ( response.success ) {

            } else {
                $ ( '#msjError' ).show ();
                $ ( '#user' ).val ( '' );
                $ ( '#pass' ).val ( '' );

                $ ( '#user' ).focus ();
            }
        }, 'json' );
    } );
} );