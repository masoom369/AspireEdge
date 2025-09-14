# TODO: Fix Flutter Analyze Lint Issues

## Tasks:
- [ ] Replace all 58 instances of deprecated 'withOpacity' with '.withValues(alpha: value)'
- [ ] Replace or remove 5 'print' statements with 'debugPrint' or remove if not needed
- [ ] Add 'Key? key' parameter to public widget constructors missing it
- [ ] Fix 'use_build_context_synchronously' by checking context.mounted or using mounted property
- [ ] Add curly braces around if statements without them
- [ ] Remove unused catch clauses
- [ ] Replace type literals in constant patterns with 'TypeName _'
- [ ] Use super parameters for key
- [ ] Add 'http' dependency to pubspec.yaml for depend_on_referenced_packages
- [ ] Replace SizedBox with SizedBox for whitespace
- [ ] Remove unnecessary .toList() in spreads
- [ ] Fix invalid use of private types in public API

## Completed:
- [x] Analyzed flutter analyze output and identified all issues
- [x] Searched for withOpacity and print usages
