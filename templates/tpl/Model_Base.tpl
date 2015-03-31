<?php

class #{$_modelName}#
{

#{foreach key=key item=item from=$_fields}#
  const #{$item['field']}# = '#{$item['field']}#';
#{/foreach}#
}