# CHANGELOG

## 1.6.0

* Update `getEntityGivenName` to support ACF2018
* Performance update on creating active entities as datasource discovery has been reworked
* Updated build process to latest in template
* Dropped Railo support
* Lazy loading `BeanPopulator` for performance on creations
* Lazy loading `ORMEventHandler` for performance on creations
* Lazy loading `restrictions` for performance on creations
* More direct scoping for performance updates
* Optimized EventHandler so it is lighter and quicker when doing orm injections

## 1.5.0

* Performance improvements for criteria building as we now build up the dialect and support structs
* ACF 2018 Support via Hibernate 5
* Update to leverage new module template schema
* Updated readme from old text

## 1.4.0

* ColdBox 5 Support
* Dependency updates
* Some syntax updates
* Fix `getKey()` return typing to allow composite keys: https://github.com/coldbox-modules/cbox-cborm/pull/21
* Update to module standard template
* Updated dependencies

## 1.3.0

* Pass the target value as the rejected value for Unique validator
* Travis Updates
* Dependency updates
* Lucee 5 exceptions on ORM Util due to abstract keyword

## 1.2.2

* Travis updates
* COLDBOX-460 Dynamic finders fixed by always adding datasource attribute to hql query
* Fixes an interface error on AC11 startup

## 1.2.1

* Fixed box.json version number

## 1.2.0

* BaseORMService.merge doesn't seem to merge entities back into session #10
* Variable scoping in SQLHelper.cfc bug #9
* Update build process to leverage Travis
* Updated `cbvalidation` to v1.1.0
* Build cleanup
* Replaced `StringBuffer` with `StringBuilder` for performance

## 1.1.0

* Updated cbvalidation dependency
* Prevent conditionals from being stripped from property names
* Updated build for api docs and commandbox usage for dependencies
* ORM Unique validation not working

## 1.0.2

* updates to all dependencies
* production ignore lists

## 1.0.1

* https://ortussolutions.atlassian.net/browse/CCM-15 CF11Compat - arrayContainsNoCase() Is not a function
* Lucee support

## 1.0.0

* Create first module version
