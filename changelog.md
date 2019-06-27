# CHANGELOG

## v2.0.0

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

* **Mementifier** is now a dependency for cborm. (www.forgebox.io/view/mementifier), which can be used for producing state out of ORM entities for auditing or building JSON Api's.
* Performance update on creating active entities as datasource discovery has been reworked
* Updated build process to latest in Ortus template
* Dropped Railo, Lucee 4.5, ACF11 support
* More direct scoping for performance updates
* Optimized EventHandler so it is lighter and quicker when doing orm injections
* Documented all functions with extra examples and notes and hibernate references
* ColdBox 5 and 4 discrete ORM Injection DSLs

### Criteria Queries

* They have been adapted to work with Hibernate 3, 4 and 5
* When calling native restrictions, no more reflection is used to discover the restriction type thus increasing over 70% in performance when creating criteria queries

### Base ORM Service

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
* All dynamic method calls accept a structure as an argument or named as `options` that can have the following keys now:

```json
{
	ignoreCase : boolean (false)
	maxResults : numeric (0)
	offset     : numeric (0)
	cacheable  : boolean (false)
	cacheName  : string (default)
	timeout    : numeric (0)
	datasource : string (defaults)
	sortBy     : hql to sort by,
	autoCast   : boolean (true)
}

results = ormservice.findByLastLoginBetween( "User", "01/01/2008", "11/01/2008", { sortBy="LastName" } );
```

* All dynamic finders/counters values are autocasted, you no longer need to cast the values, we will do this for you. You can turn it off via the `autocast:false` in the options to the calls.

### Virtual Entity Service

Remember this entity extends Base Service, so we get all the features above plus the following:

### Active Entity

Remember this entity extends the Virtual Service, so we get all the features above plus the following:

* Faster creation speeds due to lazy loading of dependencies and better datasource determination.

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
