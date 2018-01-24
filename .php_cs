<?php

return PhpCsFixer\Config::create()
    ->setRiskyAllowed(true)
    ->setRules([
        '@Symfony' => true,
        '@Symfony:risky' => true,
        'array_syntax' => array('syntax' => 'long'),
        'combine_consecutive_unsets' => true,
        'concat_space' => ['spacing' => 'one'],
        'no_useless_else' => true,
        'no_useless_return' => true,
        'ordered_class_elements' => true,
        'ordered_imports' => true,
        'phpdoc_add_missing_param_annotation' => true,
        'phpdoc_align' => false,
        'phpdoc_order' => true,
        'psr4' => true,
        'semicolon_after_instruction' => true,
        'strict_comparison' => true,
        'strict_param' => true,
        'yoda_style' => false,
    ])
    ->setFinder(
        PhpCsFixer\Finder::create()
            ->exclude(['vendor', 'bundle/ezpublish_legacy', 'extension', 'bundle/Resources', 'bundle/Installer/_templates'])
            ->in(__DIR__)
    )
;
