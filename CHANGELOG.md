## 0.5.2

### Fixed

- Use raw string to avoid referencing variables in generated code for custom info.

## 0.5.1

### Fixed

- Fix generating duplicate custom command variables by running build_runner in the second time and later.

## 0.5.0

### Added

- Use `powershell` to run custom command on Windows.
- Make platform related args nullable.
- Ignore custom command that both not planned to run on current platform and have no default value.

### Fixed

- Fix CI.

## 0.4.1

### Fixed

- Fix `withNullability` param issue in analyzer package APIs.
  - analyzer before 6.5.0 requires it but marked deprecated since 6.5.0. Keep the param.

## 0.4.0

### Added

- Add `gitCommitCount` for current rev total commit count.

## 0.3.0

### Added

- Add platform support for custom commands:
  - `platforms`: Specify platforms to run the command on.
  - `platformDefaultValue`: Set command result value on platforms that does not run the command.

## 0.2.1

### Fixed

- Fix failed to generate in pure dart environment (only dart, no flutter).
- Fix test.

### Changed

- Format code.

## 0.2.0

### Added

- Support custom commands.

## 0.1.0

- Initial version.
