<?php

require 'config/config.php';


$url = $_SERVER[ 'REQUEST_URI' ];
$arrayParam = array ();
$indexParam = strpos ( $url, "?" );

if ( $indexParam !== false ) {
    $params = substr ( $url, $indexParam + 1, strlen ( $url ) );
    $paramsArray = explode ( "&", $params );
    $url = substr ( $url, 0, $indexParam );
    foreach ( $paramsArray as $param ) {
        $varArray = explode ( "=", $param );
        if ( count ( $varArray ) == 2 ) {
            $nom = $varArray[ 0 ];
            $val = $varArray[ 1 ];
            ${$nom} = $val;
            $arrayParam[] = ${$nom};
        }
    }
}



$requestURI = explode ( '/', $url );
$iniRouting = 2;

$frontController = array (
    'module' => 'default',
    'controller' => 'index',
    'action' => 'index'
);

if ( array_key_exists ( $iniRouting, $requestURI ) ) {
    if ( $requestURI[ $iniRouting ] ) {
        $frontController[ 'module' ] = $requestURI[ $iniRouting ];
    }
}
if ( array_key_exists ( $iniRouting + 1, $requestURI ) ) {
    if ( $requestURI[ $iniRouting + 1 ] ) {
        $frontController[ 'controller' ] = $requestURI[ $iniRouting + 1 ];
    }
}
if ( array_key_exists ( $iniRouting + 2, $requestURI ) ) {
    if ( $requestURI[ $iniRouting + 2 ] ) {
        $frontController[ 'action' ] = $requestURI[ $iniRouting + 2 ];
    }
}

$module = strtolower ( $frontController[ 'module' ] );
$controller = strtolower ( $frontController[ 'controller' ] );
$actionCut = explode ( '?', $frontController[ 'action' ] );
$action = strtolower ( $actionCut[ 0 ] ) . 'Action';



$requireFile = "modules/$module/" . str_replace ( ' ', '', ucwords ( str_replace ( '-', ' ', $controller ) ) ) . "Controller.php";

//require Controller File
require "$requireFile";

//instance of Controller File

$className = ucwords ( $module ) . '_' . str_replace ( ' ', '', ucwords ( str_replace ( '-', ' ', $controller ) ) ) . "Controller";
$controller = new $className();

call_user_func_array ( array ( $controller, $action ), $arrayParam );

