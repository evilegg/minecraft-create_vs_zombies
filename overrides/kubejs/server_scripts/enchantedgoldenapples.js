// Re-add an enchanted golden apple recipe
ServerEvents.recipes(event => {
    event.shaped('minecraft:enchanted_golden_apple', [
        'AAA',
        'ABA',
        'AAA'
    ], {
        A: 'minecraft:gold_block',
        B: 'minecraft:apple'
    }).id('kubejs:enchanted_golden_apple')
})