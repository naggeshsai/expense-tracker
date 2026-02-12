# Contributing to Expense Tracker

First off, thank you for considering contributing to Expense Tracker! It's people like you that make this project better.

## Code of Conduct

This project and everyone participating in it is governed by respect and professionalism. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and what you expected**
- **Include screenshots if relevant**
- **Include your environment details** (OS, Flutter version, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List any alternative solutions you've considered**

### Pull Requests

1. Fork the repo and create your branch from `main`
2. If you've added code that should be tested, add tests
3. Ensure the test suite passes
4. Make sure your code follows the existing style
5. Write a clear commit message

## Development Setup

See [SETUP.md](docs/SETUP.md) for detailed setup instructions.

## Styleguides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

Examples:
```
Add CSV export functionality

- Implement CSV generation logic
- Add export button in settings
- Handle file permissions
- Add unit tests

Fixes #123
```

### Dart Styleguide

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter format .` before committing
- Run `flutter analyze` and fix warnings
- Maximum line length: 80 characters
- Use meaningful variable names
- Add comments for complex logic

### Code Organization

- Follow Clean Architecture principles
- Place files in appropriate layer directories
- Keep files focused and single-purpose
- Use dependency injection via GetIt
- Implement proper error handling

## Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Aim for >80% code coverage
- Run tests before submitting PR: `flutter test`

## Documentation

- Update README.md if needed
- Add comments for complex code
- Update docs/ folder for major changes
- Include examples in documentation

## Project Structure

Follow the existing structure:
```
lib/
├── core/           # Shared utilities
├── data/           # Data layer (repos, database)
├── domain/         # Business logic
└── presentation/   # UI layer
```

## Review Process

1. Automated checks run on PR
2. Code review by maintainer
3. Discussion and iteration
4. Merge when approved

## Community

- Be respectful and constructive
- Help others in discussions
- Share knowledge and experience
- Celebrate contributions

## Questions?

Feel free to open an issue or reach out to the maintainers.

Thank you for contributing! 🎉
