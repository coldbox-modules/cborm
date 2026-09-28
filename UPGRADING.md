# Upgrading to cborm 6

cborm 6 is a pure BoxLang module built on the `bx-orm` 2 module (Hibernate 7). The cborm 5.x series keeps supporting
Adobe ColdFusion and `bx-orm` 1 (Hibernate 5).

## Requirements

- BoxLang 1.17.5+ with the `bx-orm` 2 module. CFML applications run through `bx-compat-cfml`.
- ColdBox 8+.
- Adobe ColdFusion and Lucee are no longer supported: stay on cborm 5.x.

## ORM settings

Use the one cborm event handler and turn event handling on:

```js
this.ormSettings = {
    eventHandling : true,
    eventHandler  : "cborm.models.EventHandler"
};
```

`cborm.models.BXEventHandler` still works as a deprecated alias.

## What stays the same

- `BaseORMService`, `VirtualEntityService` and `ActiveEntity`: same methods and arguments.
- Dynamic finders and counters (`findBy...`, `findAllBy...`, `countBy...`).
- The `entityService` WireBox DSL, the `HibernateTransaction` aspect, the resource handler, the `UniqueValidator`,
  population and validation.
- The ColdBox interception points (`ORMPreLoad`, `ORMPostLoad`, ..., `onCriteriaBuilderAddition`,
  `beforeCriteriaBuilderList`, ...).

## What changed

### Criteria

`newCriteria()` returns a bx-orm `entityCriteria()` builder. It keeps cborm's method names (`isEq`, `like`,
`between`, `isIn`, `createAlias`, `withProjections`, `list`, `count`, `get`, `getOrFail`, ...), `c.restrictions`,
the quantified subqueries (`subGeAll`, `propertyLtSome`, ...) and the SQL log (`startSqlLog()`, `logSQL()`,
`getSqlLog()`).

| cborm 5 | cborm 6 |
| --- | --- |
| `getRestrictions()` returned a Hibernate `Restrictions` proxy | Returns the same condition builder as `c.restrictions`; pass its results to `add()`, `or()`, `and()`, `not()` |
| `createSubcriteria()` / `DetachedCriteriaBuilder` | `c.subquery( "Entity", "alias" )` |
| `get( properties = "a,b" )` | `withProjections( property = "a,b" ).asStruct().get()` |
| `list( asStream = true )`, `asStream()` returned a cbStreams stream | `asStream()` returns a Java stream; wrap a list with `StreamBuilder@cbStreams` for cbStreams |
| `cacheRegion( name )` | `cache( true, name )` |
| `getNativeCriteria()`, `resultTransformer()`, `setProjection()` | Removed: the Hibernate criteria API no longer exists in Hibernate 7 |
| `getPositionalSQLParameters()` and other `SQLHelper` methods | Use `getSQL()`, `peekSQL()` and `logSQL()` |

### Services

| cborm 5 | cborm 6 |
| --- | --- |
| `getOrm()` (the engine ORM utility) | Removed: call the bx-orm functions (`entityGetDatasource()`, `ormGetSession()`, ...) |
| `getEntityMetadata()` returned Hibernate `ClassMetadata` | Returns the Hibernate 7 entity persister, which keeps the `ClassMetadata` methods (`getPropertyNames()`, `getPropertyTypes()`, `getIdentifierPropertyName()`, ...). For a BoxLang struct use `entityGetMetadata()` |
| `idCast()` / `convertIdValueToJavaType()` converted ids to Java types | Only normalize an id, list or array to an array: bx-orm converts values itself |
| `autoCast()` / `convertValueToJavaType()` | Return the value as is |
| `buildJavaProxy()` | Removed |
| HQL with legacy `?` parameters | Use `?1`, `?2`, ... or named `:name` parameters (Hibernate 6+) |
| HQL property names in any case (`firstname`) | Use the property's declared case (`firstName`): Hibernate 6+ is case-sensitive; bx-orm's error suggests the right name |
| `unique = true` queries | More than one matching row raises an error instead of returning the first; `findIt()` limits to one row |

### Events

- New `ORMPostCommit` interception point: fired once an insert, update or delete is committed. Data: `entity`,
  `entityName`, `action`.
- `ORMPostNew` is announced once per `new()`, after the entity is autowired and populated. A plain `entityNew()`
  now announces it too.
- `ORMPreFlush` and `ORMPostFlush` are declared but bx-orm does not fire flush events.

### Removed files

`models/criterion/*`, `models/sql/SQLHelper`, `models/util/ORMUtilFactory`, `models/util/support/*` and
`models/util/JavaProxyBuilder`.
