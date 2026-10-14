# Architecture Knowledge Base

This folder is the single source of truth for how `flutter_boilerplate` is structured
and why. Read it before adding or changing a feature.

| File | What it answers |
| --- | --- |
| [01-reference-todo-app.md](01-reference-todo-app.md) | What the reference repo ([md-naimul-hassan/todo-app](https://github.com/md-naimul-hassan/todo-app)) does, which patterns we adopted, and which of its quirks we deliberately did **not** copy. |
| [02-boilerplate-audit.md](02-boilerplate-audit.md) | The state of this project *before* the clean-architecture migration: layers, problems, and bugs found. |
| [03-target-architecture.md](03-target-architecture.md) | The rules: layers, dependency direction, folder/file naming, error flow, DI, BLoC conventions. |
| [04-feature-catalog.md](04-feature-catalog.md) | Every feature: entities, use cases, repository methods, endpoints, blocs, screens, routes. |
| [05-new-feature-guide.md](05-new-feature-guide.md) | Step-by-step checklist and copy-paste templates for adding a new feature. |
| [06-migration-log.md](06-migration-log.md) | What changed in the migration, decisions taken, and known follow-ups. |

## One-paragraph summary

The app is **feature-first**: everything for a feature lives under `lib/features/<feature>/`.
Inside each feature the code is split into three **clean-architecture layers**:
`domain/` (entities, repository contracts, use cases — pure Dart), `data/` (models, remote
data sources, repository implementations), and `presentation/` (blocs, screens, widgets).
Data sources throw `AppException`s; repository implementations catch them and return a
`Result<T>` (`Success` or `Failed(Failure)`); blocs call use cases and `switch` on the
result. Everything is wired with `get_it` in `lib/app/di.dart`.

```text
Screen ──event──▶ Bloc ──▶ UseCase ──▶ Repository (abstract, domain)
                                            ▲
                                            │ implements
                              RepositoryImpl (data) ──▶ RemoteDataSource ──▶ ApiClient (Dio)
                                   │  catches AppException
                                   └─▶ returns Result<T> = Success(data) | Failed(Failure)
```
