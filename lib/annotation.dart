class CustomInfo {
  const CustomInfo(
    this.name, {
    this.ignoreStderr = false,
    this.useStderr = false,
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

  @override
  String toString() {
    return 'CustomInfo { "$name", ignoreStderr=$ignoreStderr }';
  }
}
