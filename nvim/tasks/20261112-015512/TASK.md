# Vim expand `%:h`

- STATUS: OPEN
- PRIORITY: 100
- TAGS: bug,

We should do this? The user must want to create a task with `%:h` without it being automatically expanded, if the user want to make it expand they can make it manually before

use `<Tab>` in % to expand it
`:CCcompile ls %:h` -> `:CCcompile ls %:h<Tab>` ->  `:CCcompile ls /path/to/dir`

And when user make something like this, it will keep the original text
`:CCcompile grep -rn '%:h'` 

Also in the `input()` the '%:h' is not expanded automatically and cant be expanded with <Tab>

In this case the user will have more control
