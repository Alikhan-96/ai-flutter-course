# Lesson 37: Singleton vs get_it

Pros of Singleton:

- Very quick to implement for simple shared services like logging.
- Guarantees exactly one instance with no extra setup.
- Easy to reach from different parts of a small app.
- Useful for stateless cross-cutting helpers.
- Good for demos and learning core pattern behavior.

Cons of Singleton:

- Hidden dependencies make code harder to reason about.
- Global mutable state can leak between screens and tests.
- Replacing behavior in tests is more awkward.
- Lifecycle control is limited compared with DI containers.
- Apps can become tightly coupled to concrete implementations.

Compared with `get_it`:

- `get_it` is better when services need explicit registration, mocking, or swapped implementations.
- Singleton is simpler for a small lesson project, but `get_it` scales better in larger apps.
