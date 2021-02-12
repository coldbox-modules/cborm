/**
 * My awesome cb6 resources handler
 */
component extends="cborm.models.resources.BaseHandler" {

	// Inject the correct service as the `ormService` for the resource Handler
	property name="ormService" inject="entityService:Role";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder = "";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity    = "Role";

}
