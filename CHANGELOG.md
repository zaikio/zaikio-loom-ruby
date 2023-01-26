# Zaikio Loom Ruby Gem Changelog

## [Unreleased]

- Support `staging` environment to allow internal testing

## 1.3.1 - 2022-01-07

- Permit Rails 7

## 1.3.0 - 2021-11-22

- Support configuration of `queue` for FireEventJob

## 1.2.0 - 2021-10-18

- **BREAKING** Fixed: Throw new `Zaikio::Loom::Error` when posting events fails (e.g. 422)

## 1.1.1 - 2021-03-25

 * Replace dependency on `rails` with a more specific dependency on `railties` and friends

## 1.1.0 - 2021-01-05

- Ensure compability with Ruby 3.0 and Ruby on Rails 6.1

## 1.0.1 - 2020-06-03

- Fix a bug in the event serializer

## 1.0.0 - 2020-06-03

- Add multi client support
- Confguration format changed

## 0.3.0 - 2020-04-22

- Do not send events to Loom in development or staging environment

## 0.2.1 - 2020-03-30

- Fix bug with event serialization

## 0.2.0 - 2020-03-30

- Events are now fired in background with ActiveJob.

## 0.1.1 – 2020-01-29

- Fixes an issue with URLS build on staging and in the sandbox

## 0.1.0 (yanked)

- Initial release
