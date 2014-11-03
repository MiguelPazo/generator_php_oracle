<?php

require 'App/Controller.php';
require 'Zend/Db/Table/Abstract.php';

class Default_IndexController extends App_Controller
{

    public function indexAction () {
        $this->render ( 'index.tpl' );
    }

    public function pageAction () {
        $this->render ( 'page.tpl' );
    }

}
