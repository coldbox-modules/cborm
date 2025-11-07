# CBOrm Copilot Instructions

CBOrm is a ColdBox module that **enhances and abstracts Hibernate ORM** for CFML engines (BoxLang, Lucee, Adobe ColdFusion). It extends Hibernate with service layers, Active Record patterns, fluent criteria queries, dynamic finders, RESTful resources, and AOP transaction management.

## Core Architecture

**Service Layer Pattern**: CBOrm uses three main service types:
- `BaseORMService` - Base service for any entity operations with CRUD, dynamic finders, criteria queries (`models/BaseORMService.cfc`)
- `VirtualEntityService` - Auto-generated entity-specific services via WireBox DSL, extends BaseORMService (`models/VirtualEntityService.cfc`)
- `ActiveEntity` - Active Record pattern for entities with direct CRUD methods (`models/ActiveEntity.cfc`)

**Criteria Query System**: Fluent API wrapping Hibernate Criteria API
- `models/criterion/BaseBuilder.cfc` - Base builder with projections, restrictions, ordering, grouping
- `models/criterion/CriteriaBuilder.cfc` - Main criteria query builder for regular queries
- `models/criterion/DetachedCriteriaBuilder.cfc` - Detached criteria for subqueries and projections
- `models/criterion/Restrictions.cfc` - Proxy to Hibernate Restrictions (eq, gt, like, between, etc.)
- `models/criterion/Subqueries.cfc` - Extends Restrictions for subquery support (subEq, subGt, etc.)

**Utilities & Helpers**:
- `models/util/ORMUtilFactory.cfc` - Factory for cross-engine ORM utilities
- `models/util/support/ORMUtilSupport.cfc` - Engine-agnostic ORM operations (session, transactions, metadata)
- `models/util/support/AdobeORMUtil.cfc` - Adobe ColdFusion-specific ORM utilities
- `models/util/support/LuceeORMUtil.cfc` - Lucee-specific ORM utilities
- `models/util/support/BoxLangORMUtil.cfc` - BoxLang-specific ORM utilities
- `models/util/DynamicProcessor.cfc` - Processes dynamic finders (findByName, countByStatus, etc.)
- `models/util/JavaProxyBuilder.cfc` - Creates Java proxies for Hibernate classes
- `models/sql/SQLHelper.cfc` - Extracts and formats SQL from criteria queries for debugging

**Event Handling**:
- `models/EventHandler.cfc` - ORM lifecycle event handler (preLoad, postLoad, preInsert, postInsert, etc.)
- `models/ACFEventHandler.cfc` - Adobe ColdFusion-specific event handler with CFIDE interface

**Integration Components**:
- `dsl/OrmDsl.cfc` - WireBox DSL for `entityService:{entityName}` injection
- `aop/HibernateTransaction.cfc` - AOP aspect for @transactional annotation support
- `interceptors/CriteriaBuilder.cfc` - ColdBox interceptor for SQL logging
- `models/resources/BaseHandler.cfc` - RESTful base handler for automatic CRUD REST APIs
- `models/validation/UniqueValidator.cfc` - Custom validator for unique entity properties

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

**Multi-Engine Testing**: Project supports BoxLang, Lucee, and Adobe CF:
- Start servers: `box start:boxlang`, `box start:lucee`, `box start:2023`
- Test harness at `/test-harness` with full ORM setup
- Database via Docker: `box run-script startdbs` (MySQL with test data)

**Build & Testing**:
- Format code: `box run-script format` (uses `.cfformat.json`)
- Run tests: Navigate to test harness server `/tests/runner.cfm`
- Build module: `box run-script build:module`

**Key Configuration**:
- Module settings in `ModuleConfig.cfc` define resources, injection, and event handling
- ORM configured in `test-harness/Application.cfc` with `cborm.models.EventHandler`
- Must add mapping: `this.mappings["/cborm"] = COLDBOX_APP_ROOT_PATH & "modules/cborm";`

## Testing Conventions

Tests in `/test-harness/tests/specs/` follow TestBox BDD style. Entity tests use `BaseTest` which provides database setup. Key test patterns:
- Use `ormClearSession()` in teardown
- Mock `EventHandler` for service tests
- Test entities in `/test-harness/models/entities/` with validation constraints

## Module Dependencies

CBOrm depends on: `cbvalidation`, `mementifier`, `cbstreams`, `cbpaginator`. These provide validation, memento pattern, streaming, and pagination capabilities respectively.
