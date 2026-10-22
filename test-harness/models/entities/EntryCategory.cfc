/**
 * A composite-id entity over the entry_categories link table, for the composite id tests
 */
component persistent="true" table="entry_categories" datasource="coolblog" {

	property
		name     ="categoryId"
		column   ="FKcategory_id"
		fieldType="id";
	property
		name     ="entryId"
		column   ="FKentry_id"
		fieldType="id";

}
