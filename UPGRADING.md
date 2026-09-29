# Upgrading to cborm 6

cborm 6 is a pure BoxLang module built on the `bx-orm` 2 module (Hibernate 7). The cborm 5.x series keeps supporting
Adobe ColdFusion and `bx-orm` 1 (Hibernate 5).

## Requirements

- BoxLang 1.17.5+ with the `bx-orm` 2 module. CFML applications run through `bx-compat-cfml`.
- ColdBox 8+.
- cborm no longer depends on `cbstreams` or `cbpaginator`. Install them yourself if your app uses them directly.
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
| `list( asStream = true )`, `asStream()` returned a cbStreams stream | `asStream()` returns a Java stream read from the database as it is consumed |
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
| `unique = true` queries | More than one matching row raises an error instead of returning the first; `findIt()` returns the first row |
| `findWhere()` returned the first match when query caching was on | Always strict: more than one match raises `orm.query.nonUnique`. Pass `{ uniqueFirst : true }` as options for the first match |
| `asStream = true` returned a cbStreams stream (`list`, `executeQuery`, `getAll`, `findAll`, `findAllWhere`, dynamic finders) | Returns a Java `Stream` read from the database as it is consumed. Use `.filter()`, `.map()`, `.toList()`, `.count()`; consume it in the same request |
| `getAll( sortOrder )` and dynamic finder `sortBy` took any HQL | Only property names or paths, each with `asc` or `desc`: anything else raises an error |
| `countWhere()` and `deleteWhere()` ignored unknown argument names as HQL | An unknown property raises `orm.property.unknown` |
| `exists()`, `getAll( id )` and `deleteByID()` assumed a single id property | Composite ids work: pass a struct of key values, or an array of them |
| `deleteWhere()`, `deleteByID()` and `deleteAll()` could miss unflushed changes | They flush pending changes first, like every bulk delete in bx-orm |
| Dynamic finder errors were rethrown as `HQLQueryException` | bx-orm's typed errors (`orm.*`, with "Did you mean") are rethrown as they are |
| `executeQuery( ignoreCase )` | Ignored: use `lower()` in the HQL |
| `ActiveEntity.getValidationResult()` returned null | Returns the last validation result, like `getValidationResults()` |

### Events

- New `ORMPostCommit` interception point: fired once an insert, update or delete is committed. Data: `entity`,
  `entityName`, `action`.
- `ORMPostNew` is announced once per `new()`, after the entity is autowired and populated. A plain `entityNew()`
  now announces it too.
- `ORMPreFlush` is announced on every flush, from bx-orm's `onFlush` and `onAutoFlush` events. Its data is
  `{ event }` (the Hibernate flush event) instead of cborm 5's entity list.
- `ORMPostFlush` is declared but never announced: bx-orm has no after-flush event.
- Entities created with `entityNew()`, `entityLoadOrNew()` and `entityLoadOrSave()` are now autowired, like loaded
  entities.

### Resources

- The resource handler builds its `pagination` block itself (`totalRecords`, `totalPages`, `maxRows`, `offset`,
  `page`, the same keys as cbPaginator).
- Entities without mementifier's `getMemento()` are marshalled with bx-orm's `entityToStruct()`. An unknown include
  is a 400 error in that case.

### New service methods

`findWhereOrFail()`, `firstOrNew()`, `firstOrCreate()`, `updateWhere()`, `getReference()`, `lock()` and `readOnly()`.
`get()`, `getOrFail()`, `list()`, `executeQuery()`, `findAll()`, `findWhere()` and `findAllWhere()` take an `options`
struct passed to bx-orm (`readOnly`, `lock`, `uniqueFirst`, `fetchSize`, `comment`, ...). `ActiveEntity` adds
`lock()` and `toStruct()`, and `getKeyValue()`, `getDirtyPropertyNames()` and `sessionContains()` default to the entity
itself.

### Removed files

`models/criterion/*`, `models/sql/SQLHelper`, `models/util/ORMUtilFactory`, `models/util/support/*` and
`models/util/JavaProxyBuilder`.
