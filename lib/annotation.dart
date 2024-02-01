/// Use to specify custom info run on which platform when compiling.
enum CustomInfoPlatforms {
  linux,
  macos,
  windows,
}

class CustomInfo {
  const CustomInfo(
    this.name, {
    this.ignoreStderr = false,
    this.useStderr = false,
    this.platforms = const {
      CustomInfoPlatforms.linux,
      CustomInfoPlatforms.macos,
      CustomInfoPlatforms.windows,
    },
    this.platformDefaultValue = '',
  });

  /// Output variable name.
  ///
  /// @CustomInfo('myResult')
  /// const someNameHereNotImportant = ['command', 'arg1', 'arg2'];
  ///
  /// will generate name:
  ///
  /// const 'myResult' = 'xxx';
  final String name;

  /// Ignore message in stderr when running command.
  /// This flag is useful when running command that prints warning message to
  /// stderr.
  final bool ignoreStderr;

  /// Use output int stderr as command result.
  /// This flag also will see command running succeed if stderr has message.
  final bool useStderr;

  /// Specify only run current command on which compile platform.
  ///
  /// Contains:
  /// * Linux
  /// * MacOS
  /// * Windows
  ///
  /// On platforms not set to run command, the generated variable value will be set to [platformDefaultValue] to avoid compile error since dart has no `constexpr`.
  ///
  /// For example:
  ///
  /// * To only run command on Windows, set value to \[[CustomInfoPlatforms.windows]\].
  /// * To only run command on Linux and MacOS, set value to \[[CustomInfoPlatforms.linux], [CustomInfoPlatforms.macos]\].
  ///
  ///
  /// Default value is all platforms.
  final Set<CustomInfoPlatforms> platforms;

  /// Set the default value for command result on platforms that not available.
  ///
  /// Default is an empty string.
  ///
  /// Warning: the Default value of this option will be null from the future v1.0.0 version.
  /// Keep empty in current versions because settings a null default
  /// value will cause the type of generated variables changes from `String`
  /// to `String?`, which is a BREAKING CHANGE.
  final String platformDefaultValue;

  @override
  String toString() {
    return 'CustomInfo { "$name", ignoreStderr=$ignoreStderr }';
  }
}
