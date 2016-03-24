## 2.2.0 - 2016-03-2
### Added
- Added the ESP::ScanInterval object to use the new scan interval endpoint on the API

## 2.1.0 - 2016-02-10
### Added
- Implemented searching using `where` on many object.
- Add external account script.  Run with `esp a`
- Added ability to set a proxy using either the `http_proxy` environment variable, or setting it manually wiht `ESP.http_proxy = <proxy>`

### Changed
- Changed the `esp_console` executable to just be `esp`.  Now start the console with `esp c`

## [2.0.0] - 2015-12-16
### Added
- Separate Metadata object
- Metadata relationship to the Alert object.
- Set the User-Agent header to "Ruby SDK #{ESP::VERSION}"

### Removed
- Unnecessary dependencies.

## [2.0.0.rc1] - 2015-11-05
### Added
- Complete rewrite. See the README for the new DSL.
