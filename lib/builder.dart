import 'dart:async';

import 'package:build/build.dart';
import 'package:gitsumu/src/custom_info_generator.dart';
import 'package:gitsumu/src/info_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder customInfoBuilder(BuilderOptions options) {
  return SharedPartBuilder([CustomInfoGenerator(options)], 'custom_info');
}

Builder infoBuilder(BuilderOptions options) {
  return SharedPartBuilder([InfoGenerator(options)], "info");
}

class InfoBuilder implements Builder {
  InfoBuilder(this.builderOptions);

  final BuilderOptions builderOptions;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final lib = await buildStep.resolver
        .libraryFor(buildStep.inputId, allowSyntaxErrors: false);

    final infoGenerator = InfoGenerator(builderOptions);
    final data = await infoGenerator.generate(LibraryReader(lib), buildStep);
    if (data == null) {
      return;
    }
    buildStep.writeAsString(buildStep.allowedOutputs.single, data);
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return _validatedBuildExtensionsFrom(Map.of(builderOptions.config), {
      '.dart': ['.gitsumu.dart']
    });
  }
}

// Copied from source_gen package lib/src/utils.dart
/// Returns a valid buildExtensions map created from [optionsMap] or
/// returns [defaultExtensions] if no 'build_extensions' key exists.
///
/// Modifies [optionsMap] by removing the `build_extensions` key from it, if
/// present.
Map<String, List<String>> _validatedBuildExtensionsFrom(
  Map<String, dynamic>? optionsMap,
  Map<String, List<String>> defaultExtensions,
) {
  final extensionsOption = optionsMap?.remove('build_extensions');
  if (extensionsOption == null) {
    // defaultExtensions are provided by the builder author, not the end user.
    // It should be safe to skip validation.
    return defaultExtensions;
  }

  if (extensionsOption is! Map) {
    throw ArgumentError(
      'Configured build_extensions should be a map from inputs to outputs.',
    );
  }

  final result = <String, List<String>>{};

  for (final entry in extensionsOption.entries) {
    final input = entry.key;
    if (input is! String || !input.endsWith('.dart')) {
      throw ArgumentError(
        'Invalid key in build_extensions option: `$input` '
        'should be a string ending with `.dart`',
      );
    }

    final output = (entry.value is List) ? entry.value as List : [entry.value];

    for (var i = 0; i < output.length; i++) {
      final o = output[i];
      if (o is! String || (i == 0 && !o.endsWith('.dart'))) {
        throw ArgumentError(
          'Invalid output extension `${entry.value}`. It should be a string '
          'or a list of strings with the first ending with `.dart`',
        );
      }
    }

    result[input] = output.cast<String>().toList();
  }

  if (result.isEmpty) {
    throw ArgumentError('Configured build_extensions must not be empty.');
  }

  return result;
}
