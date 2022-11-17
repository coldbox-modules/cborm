# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----

## [v4.3.2] => 2022-NOV-17

### Fixed

* Removal of `lazy` annotations that conflict with cb7 lazy properties

----

## [v4.3.1] => 2022-NOV-16

### Fixed

* Updated `processState()` to `announce()` on all tests

----

## [v4.3.0] => 2022-NOV-16

### Changed

* Updated `processState()` to `announce()` to stay compliant

----

## [v4.2.0] => 2022-NOV-16

### Changed

* Updated `announceInterception()` to `announce()` to stay compliant

----

## [v4.1.0] => 2022-NOV-10

### Changed

* Updated the way the populator is retrieved so we can be forwards compatible

----

## [v4.0.0] => 2022-OCT-10

### Added

* Upgraded all dependencies to major bumps

### Changed

* Dropped ACF2016 Support

----

## [v3.9.0] => 2022-AUG-10

### Added

* New `when( boolean, success, fail )` fluent construct for `ActiveEntity`, `VirtualEntityService` and the `BaseORMService` to allow for fluent chaining of operations on an entity or it's service.
* Migration to new ColdBox Virtual App Testing approaches
* Removed unecessary on load logging to increase performance
* Hibernate 5.4 on Lucee experimental testing

### Fixed

* `countWhere()` invalid SQL exception if no arguments are provided: https://github.com/coldbox-modules/cborm/pull/54

----

## [v3.8.0] => 2022-MAR-09

### Fixed

* CBORM-32 - Non-Primary DSN Entities not found. Multi-datasource discovery of entities using virtual services and active entity. This was a regresion since version 1.5. This brings back multi-datasource support for active entity, and virtual entity services. https://github.com/coldbox-modules/cborm/pull/52
* Detached `Subqueries` was marked as a singleton when indeed it was indeed a transient. This could have created scoping issues on subquery based detached criteria building.
* Varscoping issues in `BaseBuilder` detached projections
* `DetachedCriteriaBuilder` was not passing the `datasource` to native criteria objects

### Added

* Root `docker-compose.yml` to startup MySQL, or PostgreSQL in docker, for further hacking and testing.
* Java proxy caching to avoid Lucee OSGi issues and increase Java object building performance
* New method in the BaseOrmService: `buildJavaProxy()` which leverages our `JavaProxyBuilder`
* Lazy loading of SQL Helper in criteria queries
* New module template guidelines and CI
* Leverage WireBox aliases for contstruction of internal objects
* Tons of internal docs and links to hibernate docs

----

## [v3.7.0] => 2022-JAN-13

### Added

* [CBORM-29](https://ortussolutions.atlassian.net/browse/CBORM-29) Allow SQL projections to be functions containing commas

----

## [v3.6.0] => 2022-JAN-10

### Added

* Removed usage of interface on DSL. Causes more issues than anything with multiple engines.

### Changed

* Renamed default object DSL

----

## [v3.5.1] => 2022-JAN-10

### Fixed

* Removed usage of interface on DSL. Causes more issues than anything with multiple engines.

----

## [v3.5.0] => 2021-DEC-16

### Fixed

* [CBORM-20](https://ortussolutions.atlassian.net/browse/CBORM-20) ActiveEntity `evict()` had the wrong method and arguments delegated to the parent class.
* [CBORM-9](https://ortussolutions.atlassian.net/browse/CBORM-9) ACF2021 - org.hibernate.SessionFactory.getAllClassMetadata is no longer supported

### Improved

* [CBORM-14](https://ortussolutions.atlassian.net/browse/CBORM-14) Inline datasource discovery in base orm service to get a performance boost
* [CBORM-13](https://ortussolutions.atlassian.net/browse/CBORM-13) virtual entity service double creating the orm utility, use the parent one instead of duplicating the effort
* [CBORM-12](https://ortussolutions.atlassian.net/browse/CBORM-12) Lazy load the getORMUtil\(\) and use it only when required.

### Added

* [CBORM-22](https://ortussolutions.atlassian.net/browse/CBORM-22) New orm util support method: setupHibernateLogging\(\) thanks to michael born
* [CBORM-19](https://ortussolutions.atlassian.net/browse/CBORM-19) Added a `isInTransaction()` util helper method to all the orm services.
* [CBORM-18](https://ortussolutions.atlassian.net/browse/CBORM-18) New ORM events based on Hibernate 5.4 Events: `ORMFlush, ORMAutoFlush, ORMPreFlush, ORMDirtyCheck, ORMEvict, and ORMClear`
* [CBORM-17](https://ortussolutions.atlassian.net/browse/CBORM-17) Hibernate 5.4 support for lucee new extension
* [CBORM-16](https://ortussolutions.atlassian.net/browse/CBORM-16) Adobe 2021 support and testing automations
* [CBORM-15](https://ortussolutions.atlassian.net/browse/CBORM-15) Migration to github actions
* [CBORM-11](https://ortussolutions.atlassian.net/browse/CBORM-11) Allow Criteria Builder Get\(\) and getOrFail\(\) Methods to Return Projection List Properties
* [CBORM-21](https://ortussolutions.atlassian.net/browse/CBORM-21) New cfformating rules

### Compatibility

* If you upgrade your lucee ORM extension to use Hibernate 5.4, all positional paramters in HQL using `?` has been deprecated. You will have to use the `?x` approach where `x` is a number according to the position in the sql:

```sql
// Old Syntax
select p
from Person p
where p.name like ? and p.isStatus = ?

// New Syntax
select p
from Person p
where p.name like ?1 and p.isStatus = ?2
```


----

## [v3.4.0] => 2021-APR-27

### Added

* Support for Adobe 2021 on resource loader

----

## [v3.3.0] => 2021-APR-27

### Added

* New `eventPrefix` setting so you can prefix the resource REST CRUD events with whatever you like.
* Useful exceptions when `results` struct does not have the required keys
* Ability to override the name of the method to use for persistence on the ORM services. Using the `variables.saveMethod` property or the `savemethod` argument.
* Ability to override the name of the method to use for deleting entities on the ORM services. Using the `variables.deleteMethod` property or the `deleteMethod` argument.
* cbSwagger docs

### Changed

* Added ACF2016 compatibilities on elvis operator which sucks on ACF2016
* Avoid using member function son some arrays to allow for working with Java arrays

----

## [v3.2.1] => 2021-MAR-31

### Fixed

* Wrong object to get the event handler manager when doing execute query calls

----

## [v3.2.0] => 2021-MAR-31

### Added

* Exposed a `getSQLHelper()` from criterias to allow for usage of formmatting of sql
* New interception points: `beforeOrmExecuteQuery, afterOrmExecuteQuery` from the base orm service: `executeQuery()` method

### Fixed

* Moved `afterCriteriaBuilderList` event before results conversions

----

## [v3.1.0] => 2021-MAR-30

### Added

* Env templates using new lucee bundles and mysql 8 support
* New interception point: `afterCriteriaBuilderGet`, `beforeCriteriaBuilderGet` called after/before criteria `get()` calls

### Fixed

* Fixed http to https for downloads
* Fixed watcher pathing

----

## [v3.0.0] => 2021-FEB-12

### Added

* [<a href='https://ortussolutions.atlassian.net/browse/CBORM-3'>CBORM-3</a>] - Updated cbValidation to v3 to suppport cbi18n v2
* [<a href='https://ortussolutions.atlassian.net/browse/CBORM-4'>CBORM-4</a>] - asQuery update to default it to false
* [<a href='https://ortussolutions.atlassian.net/browse/CBORM-5'>CBORM-5</a>] - Document v3 variant in the docs

## Improved

* [<a href='https://ortussolutions.atlassian.net/browse/CBORM-6'>CBORM-6</a>] - Source code cleanups by applying formatting rules

### Fixed

* [<a href='https://ortussolutions.atlassian.net/browse/CBORM-2'>CBORM-2</a>] - isDirty() not working with ActiveEntity due to missing entity passed

----

## [v2.6.0] => 2020-NOV-25

### Added

* Entities are now created, auto-wired and THEN populated when using the `new()` method instead of being auto-wired after population.
* Made `processEntityInjection()` public on the ORM Event Handler so it can be reused in other locations
* `processEntityInjection()` returns the passed entity so you can do chaining
* `getOrFail()` now includes in the `extendedInfo` the actual entity that caused the exception
* Formatting according to new rules
* Updated changelogs to new standards
* Added auto-publishing of changelogs to github
* Pinning to ColdBox 6 for base testing
* ColdBox 6 graceful shutdowns for tests
* Base Test Case for all tests for faster executions and cleanup due to base reusability

### Fixed

* Typo on `ORMUtilSupport` when detecting datasources, if you passed a default it would never be used
* `postNew` was not using the actual entity name so we where hitting performance on lookups for name
* compose relationships was `false` for resource handler and it needed to be `true`
* Increased timeouts for tests, due to Adobe issues with long compile times in latest patch levels that suck!
* Unique validator test was clearing the full app scope and trigger multiple testing issues

----

## [v2.5.0] => 2020-APR-20

* `Features` : Introduction of the automatic resource handler for ORM Entities based on ColdBox's 6 resources and RestHandler
* `Improvement` : Natively allow for nested transactions and savepoints by not doing preemptive transaction commits when using transactions.
* `Bug` : Fix on `getOrFail()` where if the id was 0, it would still return an empty object.
* `Task` : Added formatting via cfformat

----

## [v2.4.0] => 2020-JAN-31

* `Feature` : Upgraded to `cbValidation` 2.0.0
* `Feature` : Updated the unique validator to match 2.0.0 standards
* `Feature` : Upgraded to `mementifier` 2.0.0

----

## [v2.3.0]

* `improvement` : In `executeQuery()` Determine if we are in a UPDATE, INSERT or DELETE, if we do, just return the results instead of a stream or query as the result is always numeric, the rows that were altered.
* `bug` : Fixed `asStream` typo on `executeQuery()`
* `bug` : Missing ACF2016 compat on tests

----

## [v2.2.1]

* `bug` : virtual entity service still had `entity` required for casting methods

----

## [v2.2.0]

* `Feature`: New function for criteria query `when( boolean, target )` that you can use to build functional criterias without the use of if statements.

```
newCriteria()
    .when( isBoolean( arguments.isPublished ), function( c ){
            // Published bit
        c.isEq( "isPublished", isPublished );
        // Published eq true evaluate other params
        if( isPublished ){
            c.isLt( "publishedDate", now() )
            .$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) )
            .isEq( "passwordProtection","" );
        }
    } )
  .when( !isNull( arguments.showInSearch ), function( criteria ){
          c.isEq( "showInSearch", showInSearch );
   } )
  .list()
```

* `Feature`: Missing `nullValue()` is BaseBuilder class
* `Feature`: Added new criteria query `peek( closure )` function to allow for peeking into the building process.  Pass in your closure that receives the criteria and interact with it.
* `Feature`: Added a `validateOrFail()` to the active entity, which if the validation fails it will throw an exception or return back to you the same entity validated now.
* `Improvement`: Better documentation for `deleteById()` since it does bulk deletion, which does not do any type of cascading.
* `Improvement`: `isValid()` in active entity missing `includeFields` argument
* `Improvement`: Timeout hints for criteria builder
* `Improvement`: Updated exception type for criteria builder `get()`
* `Bug`: ACF2016 issues with elvis operator.
* `Bug`: `getOrFail()` had an invalid throw statement

----

## [v2.1.0]

* Change `populate()` in ActiveEntity so the target is the last argument so you can just pass a struct as the first argument [#29](https://github.com/coldbox-modules/cborm/issues/29)
*  Make the `save()` operation return the saved entity or array of entities instead of the BaseORM service [#28](https://github.com/coldbox-modules/cborm/issues/28)

----

## [v2.0.0]

### Compatibility Updates

* You will need to move the `orm` configuration structure in your `config/ColdBox.cfc` to the `moduleSettings` struct and rename it to `cborm` to standardize it to module settings.

```
moduleSettings = {

	cborm = {
		inject = {
			enabled = true,
			includes = "",
			excludes = ""
		}
	}

};
```

* `deleteByQuery()` reworked entirely to do native bulk delete queries.  It now also returns the number of records removed
* The `evict()` method was renamed to `evictCollection()` to better satisfy the same contract in hibernate
* The `evictEntity()` method was renamed to `evict()` to better satisfay the same contract in hibernate
* Removed `byExample` on many listing methods

### General Updates

* **Mementifier** is now a dependency for cborm (www.forgebox.io/view/mementifier), which can be used for producing state out of ORM entities for auditing or building JSON Api's.
* **cbStreams** is now a dependency for cborm (www.forgebox.io/view/cbstreams), all criteria queries and major listing methods support the return of streams instead of array of objects
* Full Null Support
* Performance update on creating active entities as datasource discovery has been reworked
* Updated build process to latest in Ortus template
* Dropped Railo, Lucee 4.5, ACF11 support
* More direct scoping for performance updates
* Optimized EventHandler so it is lighter and quicker when doing orm injections
* Documented all functions with extra examples and notes and hibernate references
* ColdBox 5 and 4 discrete ORM Injection DSLs

### Criteria Queries

* They have been adapted to work with Hibernate 3, 4 and 5
* New fail fast method for `get()` -> `getOrFail()` to throw an entity not found exception
* New alias methods for controlling the result transformations `asStruct(), asStream(), asDistinct()` that will apply result transformers for you instead of doing `.resultTransformer( c.ALIAS_TO_ENTITY_MAP )`, whish is long and boring, or return to you a java stream via cbStreams.
* When calling native restrictions, no more reflection is used to discover the restriction type thus increasing over 70% in performance when creating criteria queries
* You can now negate any criteria restriction by prefixing it with a `not`.  So you can do: `.notEq(), notBetween(), notIsNull(), notIsIn()` and much more.
* The `list()` method has a new `asStream` boolean argument that if true, will return the results as a cbStream. ((www.forgebox.io/view/cbStreams))
* New Methods: `idCast()` and `autoCast()` added for quick casting of values
* New method: `queryHint()` so you can add your own vendor specific query hints for optimizers.
* New method: `comment( string )` so you can add arbitrary comments to the generated SQL, great for debugging
* `sqlRestriction()` deprecated in favor of the shorthand notation: `sql()`
* The `sql()` restriction now supports binding positional parameters. You can pass them in an array and we will infer the types: `sql( "id = ? and isActive = ?", [ "123", true ] )`.  Or you can pass in a struct of `{value:"", type:""}` instead:

```
restrictions.sql( "userName = ? and firstName like ?", [
	{ value : "joe", type : "string" },
	{ value : "%joe%", type : "string" }
] );
```

The available types are the following which match the Hibernate Types

```
this.TYPES = {
	"string" 		: "StringType",
	"clob"			: "ClobType",
	"text"			: "TextType",
	"char"			: "ChareacterType",
	"boolean" 		: "BooleanType",
	"yesno" 		: "YesNoType",
	"truefalse"		: "TrueFalseType",
	"byte" 			: "ByteType",
	"short" 		: "ShortType",
	"integer" 		: "IntegerType",
	"long" 			: "LongType",
	"float"			: "FloatType",
	"double" 		: "DoubleType",
	"bigInteger"	: "BigIntegerType",
	"bigDecimal"	: "BigDecimalType",
	"timestamp" 	: "TimestampType",
	"time" 			: "TimeType",
	"date" 			: "DateType",
	"calendar"		: "CalendarType",
	"currency"		: "CurrencyType",
	"locale" 		: "LocaleType",
	"timezone"		: "TimeZoneType",
	"url" 			: "UrlType",
	"class" 		: "ClassType",
	"blob" 			: "BlobType",
	"binary" 		: "BinaryType",
	"uuid" 			: "UUIDCharType",
	"serializable"	: "SerializableType"
};
```

* Detached Criteria builder now has a `maxResults( maxResults )` method to limit the results by
* Detached Criteria sql projections now take aliases into account
* SQL Projections and SQL Group By projections now respect aliases


### Base ORM Service

* New Fail fast methods: `getOrFail() proxies to get(), findOrFail() proxies to findIt()` that if not entity is produced will throw a `EntityNotFound` exception
* All listing methods can now return the results as a cbStream by passing the `asStream` boolean argument.
* Removed `criteriaCount(), criteriaQuery()` from BaseService, this was the legacy criteria builder approach, please use `newCriteria()` instead.
* Update `getEntityGivenName` to support ACF2018
* Lazy loading `BeanPopulator` for performance on creations
* Lazy loading `ORMEventHandler` for performance on creations
* Lazy loading `restrictions` for performance on creations
* Base service can now be initialized with a `datasource`, or uses the default one declared
* Added optional `datasource` to many listing methods
* Added consistency on querying options to all major functions to include `ignoreCase, sorting and timeouts`.
* Added ability to `getAll()` to retrieve read only entities using the `readOnly` argument.
* The `getAll()` method has a new `properties` argument that if passed will allow you to retrieve an array of structs according to the passed in properties.
* New method: `idCast( entity, id )` to auto cast your entity `id` value to java type automatically for you, no more javacasting
* New method: `autoCast( entity, propertyName, value )` to auto cast any value for any entity property automatically, no more javacasting.
* New method: `getKeyValue( entity )` which will give you the value of the entity's unique identifier
* New method: `isDirty( entity )` which will let you know if the entity has dirty values or has its values changed since loaded from the db
* New method: `getEntityMetadata( entity )` which will return to you the hibernate's metadata for a specific entity.
* `getPropertyNames()` argument of `entityname` renamed to `entity` to allow not only for a name but an actual entity as well.
* `getTableName()` argument of `entityname` renamed to `entity` to allow not only for a name but an actual entity as well.
* `getKey()` argument of `entityname` renamed to `entity` to allow not only for a name but an actual entity as well.
* ORM Encapsulation of hibernate metadata retrieval via `getEntityMetadata()`
* `deleteByQuery()` reworked entirely to do native bulk delete queries.  It now also returns the number of records removed
* `deleteWhere()` missing flush argument, added datasource as well
* New properties: `wirebox` : a WireBox reference already injected, `logger` : a prepared logger for the class, `datasource` The default datasource or constructed datasource for the class.
* Logging of all activity now available via the `debug` level, even for dynamic methods.
* Refactored all dynamic finders and counters to their own class, which improves not only performance but weight of orm service based entities.
* All dynamic method calls can now return cbStreams as the results
* All dynamic method calls accept a structure as an argument or named as `options` that can have the following keys now:

```json
{
	ignoreCase 	: boolean (false)
	maxResults 	: numeric (0)
	offset     	: numeric (0)
	cacheable  	: boolean (false)
	cacheName  	: string (default)
	timeout    	: numeric (0)
	datasource 	: string (defaults)
	sortBy     	: hql to sort by,
	autoCast   	: boolean (true),
	asStream	: boolean (false)
}

results = ormservice.findByLastLoginBetween( "User", "01/01/2008", "11/01/2008", { sortBy="LastName" } );
```

* All dynamic finders/counters values are autocasted, you no longer need to cast the values, we will do this for you. You can turn it off via the `autocast:false` in the options to the calls.

----#

## [Virtual Entity Service]

Remember this entity extends Base Service, so we get all the features above plus the following:

### Active Entity

Remember this entity extends the Virtual Service, so we get all the features above plus the following:

* Faster creation speeds due to lazy loading of dependencies and better datasource determination.
* `refresh(), merge(), evict()` refactored to encapsulate login in the base orm service and not itself

## 1.5.0

* Performance improvements for criteria building as we now build up the dialect and support structs
* ACF 2018 Support via Hibernate 5
* Update to leverage new module template schema
* Updated readme from old text

## 1.4.0

* ColdBox 5 Support
* Dependency updates
* Some syntax updates
* Fix `getKey()` return typing to allow composite keys: https://github.com/coldbox-modules/cborm/pull/21
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
