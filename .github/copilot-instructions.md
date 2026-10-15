# CBORM Copilot Instructions

CBORM is a ColdBox module that **enhances and abstracts the BoxLang ORM** (the `bx-orm` 2 module, Hibernate 7). It is pure BoxLang (all sources are `.bx` classes) and runs CFML applications through `bx-compat-cfml`. It adds service layers, Active Record patterns, fluent criteria queries, dynamic finders, RESTful resources, and AOP transaction management. Adobe ColdFusion is supported by the cborm 5.x series only.

## Core Architecture

Every service method delegates to the bx-orm built-in functions (`entityLoad()`, `ormExecuteQuery()`, `entityCriteria()`, `entityGetMetadata()`, ...). There is no engine abstraction layer.

**Service Layer Pattern**: CBOrm uses three main service types:
- `BaseORMService` - Base service for any entity operations with CRUD, dynamic finders, criteria queries (`models/BaseORMService.bx`)
- `VirtualEntityService` - Auto-generated entity-specific services via WireBox DSL, extends BaseORMService (`models/VirtualEntityService.bx`)
- `ActiveEntity` - Active Record pattern for entities with direct CRUD methods (`models/ActiveEntity.bx`)

**Criteria Queries**: `newCriteria()` returns the bx-orm `entityCriteria()` builder, which carries cborm's method names, `c.restrictions`, subqueries, projections and the SQL log (`startSqlLog()`, `logSQL()`, `getSqlLog()`).

**Utilities & Helpers**:
- `models/util/DynamicProcessor.bx` - Processes dynamic finders (findByName, countByStatus, etc.) into HQL

**Event Handling**:
- `models/EventHandler.bx` - bx-orm global event handler: announces ORM events as ColdBox interception points (ORMPreLoad, ORMPostLoad, ..., ORMPostCommit) and autowires entities. `models/BXEventHandler.bx` is a deprecated alias.
- `models/CriteriaEventBridge.bx` - Relays bx-orm's criteria events (announced on the BoxLang runtime) to ColdBox interceptors

**Integration Components**:
- `dsl/OrmDsl.bx` - WireBox DSL for `entityService:{entityName}` injection
- `aop/HibernateTransaction.bx` - AOP aspect for @transactional annotation support (wraps BoxLang `transaction{}`)
- `interceptors/CriteriaBuilder.bx` - ColdBox interceptor for SQL logging
- `models/resources/BaseHandler.bx` - RESTful base handler for automatic CRUD REST APIs
- `models/validation/UniqueValidator.bx` - Custom validator for unique entity properties

## Essential Patterns

**Service Injection**: Use WireBox DSL patterns:
```cfml
// Inject base ORM service for any entity
property name="ormService" inject="entityService";

// Inject virtual service for specific entity
property name="userService" inject="entityService:User";
```

**Active Entity Usage**: Entities extend `ActiveEntity` for Active Record pattern:
```cfml
component extends="cborm.models.ActiveEntity" persistent="true" {
    // Entity definition
}

// Usage examples:
var user = new User().findByEmail("test@example.com");
user.setName("New Name").save();
user.delete();
```

**Fluent Criteria Queries**: Chain methods for complex queries:
```cfml
// Basic criteria with restrictions
userService.newCriteria()
    .isTrue("isActive")
    .eq("status", "approved")
    .like("name", "John%")
    .list();

// With joins and projections
userService.newCriteria()
    .joinTo("role").eq("name", "admin")
    .withProjections(property="id,name,email")
    .asStream()
    .list();

// Subqueries with DetachedCriteriaBuilder
var subQuery = roleService.createSubcriteria("Role", "r")
    .eq("type", "premium");
userService.newCriteria()
    .propertyIn("roleID", subQuery)
    .list();
```

**Dynamic Finders**: Auto-generated methods from BaseORMService:
```cfml
// findBy{Property}, findAllBy{Property}
userService.findByUsername("admin");
userService.findAllByStatus("active");

// countBy{Property}
userService.countByRole("admin");

// Conditional finders: LessThan, GreaterThan, Like, Between, InList, etc.
userService.findByAgeLessThan(18);
userService.findAllByCreatedDateBetween(startDate, endDate);
```

**RESTful Resources**: Automatic CRUD REST API handlers:
```cfml
component extends="cborm.models.resources.BaseHandler" {
    property name="ormService" inject="entityService:User";

    variables.entity = "User";
    variables.sortOrder = "lastName,firstName";
}
// Provides: index, create, show, update, delete actions
```

**Transaction Management**: AOP-based transaction support:
```cfml
// Add @transactional annotation to methods
function saveUser(user) transactional {
    // Automatically wrapped in transaction
    userService.save(arguments.user);
}

// Multi-datasource support
function saveUser(user) transactional="myDatasource" {
    userService.save(arguments.user);
}
```

## Development Workflow

**Testing**: BoxLang only, with and without `bx-compat-cfml`:
- Start servers: `box server start serverConfigFile=server-boxlang@1.json` or `server-boxlang-cfml@1.json` (the harness specs stay `.cfc`)
- Test harness at `/test-harness` with full ORM setup
- Database via Docker: `box run-script startdbs` (MySQL with test data)

**Build & Testing**:
- Format code: `box run-script format` (uses `.cfformat.json`)
- Run tests: Navigate to test harness server `/tests/runner.cfm`
- Build module: `box run-script build:module`

**Key Configuration**:
- Module settings in `ModuleConfig.bx` define resources, injection, and event handling
- ORM configured in `test-harness/Application.cfc` with `cborm.models.EventHandler`
- Must add mapping: `this.mappings["/cborm"] = COLDBOX_APP_ROOT_PATH & "modules/cborm";`

## Testing Conventions

Tests in `/test-harness/tests/specs/` follow TestBox BDD style. Entity tests use `BaseTest` which provides database setup. Key test patterns:
- Use `ormClearSession()` in teardown
- Mock `EventHandler` for service tests
- Test entities in `/test-harness/models/entities/` with validation constraints

## Module Dependencies

CBOrm depends on: `cbvalidation` and `mementifier`, for validation and the memento pattern. Streams are native Java streams from bx-orm, and the resource handler builds its own pagination block.
