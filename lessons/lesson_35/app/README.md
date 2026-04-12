# Lesson 35 App

This lesson implements the same task screen in both MVC and MVP styles.

## Completed homework

- task list screen implemented in MVC
- same screen implemented in MVP with a separate presenter
- business logic moved out of the UI with `load`, `add`, and `toggle`
- shared `ErrorHandler` for consistent error messages
- architecture diagram and responsibilities documented in `../ARCHITECTURE_DIAGRAM.md`

## Compare the patterns

- MVC keeps the widget closer to controller state and is simpler to wire
- MVP introduces a view contract and presenter, which makes responsibilities
  clearer and behavior easier to reason about
