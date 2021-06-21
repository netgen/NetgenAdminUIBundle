<?php

declare(strict_types=1);

namespace Netgen\Bundle\AdminUIBundle\Form\Type;

use Netgen\Layouts\API\Service\LayoutResolverService;
use Netgen\Layouts\API\Service\LayoutService;
use Netgen\Layouts\API\Values\LayoutResolver\RuleGroup;
use Ramsey\Uuid\Uuid;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints;
use Netgen\Layouts\Validator\Constraint\LayoutName;

final class LayoutWizardType extends AbstractType
{
    private LayoutService $layoutService;

    private LayoutResolverService $layoutResolverService;

    public function __construct(LayoutService $layoutService, LayoutResolverService $layoutResolverService)
    {
        $this->layoutService = $layoutService;
        $this->layoutResolverService = $layoutResolverService;
    }

    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder->add(
            'action',
            Type\ChoiceType::class,
            [
                'label' => false,
                'expanded' => true,
                'data' => 'new_layout',
                'choices' => [
                    'layout_wizard.action.new_layout' => 'new_layout',
                    'layout_wizard.action.copy_layout' => 'copy_layout',
                ],
            ],
        );

        $builder->add(
            'layout',
            Type\ChoiceType::class,
            [
                'label' => 'layout_wizard.layout',
                'choices' => $this->layoutService->loadAllLayouts(),
                'choice_value' => 'id',
                'choice_label' => 'name',
            ],
        );

        $builder->add(
            'layout_name',
            Type\TextType::class,
            [
                'label' => 'layout_wizard.layout_name',
                'constraints' => [
                    new Constraints\NotBlank(),
                    new LayoutName(),
                ],
            ],
        );

        $builder->add(
            'layout_description',
            Type\TextareaType::class,
            [
                'label' => 'layout_wizard.layout_description',
                'required' => false,
                'constraints' => [
                    new Constraints\NotNull(),
                    new Constraints\Type(['type' => 'string']),
                ],
                'empty_data' => '',
            ],
        );

        $builder->add(
            'rule_group',
            Type\ChoiceType::class,
            [
                'label' => 'layout_wizard.rule_group',
                'choices' => $this->layoutResolverService->loadRuleGroups(
                    $this->layoutResolverService->loadRuleGroup(Uuid::fromString(RuleGroup::ROOT_UUID))
                ),
                'choice_value' => 'id',
                'choice_label' => 'name',
            ],
        );

        $builder->add(
            'activate_rule',
            Type\CheckboxType::class,
            [
                'label' => 'layout_wizard.activate_rule',
                'data' => true,
                'constraints' => [
                    new Constraints\NotNull(),
                    new Constraints\Type(['type' => 'bool']),
                ],
            ],
        );
    }
}
