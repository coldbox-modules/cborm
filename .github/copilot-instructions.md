# CBOrm Copilot Instructions

CBOrm is a ColdBox module that enhances Hibernate ORM for CFML engines (BoxLang, Lucee, Adobe ColdFusion). It provides service layers, Active Record patterns, fluent criteria queries, and dynamic finders.

## Core Architecture

**Service Layer Pattern**: CBOrm uses three main service types:
- `BaseORMService` - Base service for any entity operations (`models/BaseORMService.cfc`)
- `VirtualEntityService` - Auto-generated services per entity via WireBox DSL
- `ActiveEntity` - Active Record pattern for entities (`models/ActiveEntity.cfc`)

**Key Components**:
- `models/criterion/CriteriaBuilder.cfc` - Fluent query builder for Hibernate criteria
- `dsl/OrmDsl.cfc` - WireBox DSL for `entityService:{entityName}` injection
- `models/EventHandler.cfc` - ORM lifecycle event handling
- `models/util/ORMUtilFactory.cfc` - Cross-engine ORM utilities

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

// Usage: var user = new User().findByEmail("test@example.com");
```

**Fluent Criteria Queries**: Chain methods for complex queries:
```cfml
userService.newCriteria()
    .isTrue("isActive")
    .joinTo("role").eq("name", "admin")
    .withProjections(property="id,name")
    .asStream()
    .list();
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
