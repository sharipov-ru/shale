## [0.4.0] - 2022-05-30

### Added
- Allow to add title to JSON Schema
- Map Shale::Type::Value to "anyType" XML Schema type
- Map Shale::Type::Value to "any" JSON Schema type
- Allow to generate Shale model from JSON Schema

### Changed
- Performance improvements
- Reformat README a little bit and fix typos

### Fixed
- Fix stack overflow caused by circular dependency when generating JSON and XML schemas

## [0.3.1] - 2022-04-29

### Changed
- Rename `id` -> `$id` and add info about supported JSON Schema dialect

## [0.3.0] - 2022-04-29

### Added
- Support for XML namespaces
- Add option to pretty print JSON and XML and to include XML declaration
- Add support for generating JSON and XML Schema

### Changed
- Various fixes to documentation
- Rename `hash` -> `hsh` (`hash` is used internally by Ruby)
- Rename `Shale::Type::Base` -> `Shale::Type::Value`
- Use ISO 8601 format for date and time in JSON, YAML and XML

## [0.2.2] - 2022-03-06

### Fixed
- Fix handling of blank attributes in XML format
- Fix incorrect types in README examples

## [0.2.1] - 2022-02-06

### Fixed
- Fix attribute declaration causing problems in some runtimes (e.g Opal)

## [0.2.0] - 2022-01-20

### Added
- Support for using methods to extract/generate data from/to document

### Changed
- deduplicate code
- Rename `Shale::Type::Complex` -> `Shale::Type::Composite`

## [0.1.0] - 2021-11-30

First public release
