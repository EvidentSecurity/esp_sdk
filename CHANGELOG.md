## Unreleased

## 2.5.0 - 2016-07-20
### Added
- Add custom signature definitions and results. Code for a custom signature is now created/updated under a definition. Running a definition for an on demand test creates a result record which will have errors and alerts when completed.
  - This is a backwards incompatible change on the API. If you need to save or run code on a custom signature, make sure to use this version or later.

## 2.4.0 - 2016-06-30
### Added
- Report relationship to ExternalAccount
- ExternalAccount relationship to Report
### Changed
- Upgrade api-auth to 2.0.

## 2.3.0 - 2016-05-16
### Changed
- Some error messages changed a little bit on the API.  Specifically, on region suppression, signature suppress, and custom signature suppression objects.  Now when a validation trips on the related suppression object, the error message reflects that.  "Reason can't be blank" changed to "Suppression region can't be blank".  The message is built from the attribute which is in error, which changed from "Reason" to "Suppression.reason".  Had to gsub the "." to a space to make it message friendly.
- Add the teams relation to custom signature, and the custom signatures relation to team.
- Added an endpoint, ESP::Report::Export::Integration.create, to export reports to an integration

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
