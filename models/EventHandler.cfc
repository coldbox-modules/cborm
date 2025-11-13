/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This Event Handler listens to ORM events and announces them as ColdBox events.
 * This event handler should ONLY be used for CFML engines that support ORM event handlers.
 *
 * If you are using BoxLang PRIME ORM, use the BXEventHandler.cfc instead.
 *
 */
component extends="coldbox.system.remote.ColdboxProxy" implements="CFIDE.orm.IEventHandler" {

	/**
	 * preLoad called by hibernate which in turn announces a coldbox interception: ORMPreLoad
	 */
	public void function preLoad( any entity ){
		announce( "ORMPreLoad", { "entity" : arguments.entity } );
	}

	/**
	 * postLoad called by hibernate which in turn announces a coldbox interception: ORMPostLoad
	 */
	public void function postLoad( any entity ){
		var args = {
			"entity"     : arguments.entity,
			"entityName" : getOrm().getEntityGivenName( arguments.entity )
		};
		processEntityInjection( args.entityName, args.entity );
		announce( "ORMPostLoad", args );
	}

	/**
	 * postDelete called by hibernate which in turn announces a coldbox interception: ORMPostDelete
	 */
	public void function postDelete( any entity ){
		announce( "ORMPostDelete", { "entity" : arguments.entity } );
	}

	/**
	 * preDelete called by hibernate which in turn announces a coldbox interception: ORMPreDelete
	 */
	public void function preDelete( any entity ){
		announce( "ORMPreDelete", { "entity" : arguments.entity } );
	}

	/**
	 * preUpdate called by hibernate which in turn announces a coldbox interception: ORMPreUpdate
	 */
	public void function preUpdate( any entity, Struct oldData = {} ){
		announce(
			"ORMPreUpdate",
			{
				"entity"  : arguments.entity,
				"oldData" : arguments.oldData
			}
		);
	}

	/**
	 * postUpdate called by hibernate which in turn announces a coldbox interception: ORMPostUpdate
	 */
	public void function postUpdate( any entity ){
		announce( "ORMPostUpdate", { "entity" : arguments.entity } );
	}

	/**
	 * preInsert called by hibernate which in turn announces a coldbox interception: ORMPreInsert
	 */
	public void function preInsert( any entity ){
		announce( "ORMPreInsert", { "entity" : arguments.entity } );
	}

	/**
	 * postInsert called by hibernate which in turn announces a coldbox interception: ORMPostInsert
	 */
	public void function postInsert( any entity ){
		announce( "ORMPostInsert", { "entity" : arguments.entity } );
	}

	/**
	 * preSave called by ColdBox Base service before save() calls
	 */
	public void function preSave( any entity ){
		announce( "ORMPreSave", { "entity" : arguments.entity } );
	}

	/**
	 * postSave called by ColdBox Base service after transaction commit or rollback via the save() method
	 */
	public void function postSave( any entity ){
		announce( "ORMPostSave", { "entity" : arguments.entity } );
	}

	/**
	 * Called before the session is flushed.
	 */
	public void function preFlush( any entities ){
		announce( "ORMPreFlush", { "entities" : arguments.entities } );
	}

	/**
	 * Called after the session is flushed.
	 */
	public void function postFlush( any entities ){
		announce( "ORMPostFlush", { "entities" : arguments.entities } );
	}

	/**
	 * postNew called by ColdBox which in turn announces a coldbox interception: ORMPostNew
	 */
	public void function postNew( any entity, any entityName ){
		var args = { "entity" : arguments.entity, "entityName" : "" };

		// Do we have an incoming name
		if ( !isNull( arguments.entityName ) && len( arguments.entityName ) ) {
			args.entityName = arguments.entityName;
		}

		// If we don't have the entity name, then look it up
		if ( !len( args.entityName ) ) {
			// Short-cut discovery via ActiveEntity
			if ( structKeyExists( arguments.entity, "getEntityName" ) ) {
				args.entityName = arguments.entity.getEntityName();
			} else {
				// Long Discovery
				var md          = getMetadata( arguments.entity );
				var annotations = md.keyExists( "annotations" ) ? md.annotations : md;
				args.entityName = (
					annotations.keyExists( "entityName" ) ? annotations.entityName : listLast( md.name, "." )
				);
			}
		}

		// Process the announcement
		announce( "ORMPostNew", args );
	}

	/**
	 * Get the system Event Manager
	 */
	public any function getEventManager(){
		return getWireBox().getEventManager();
	}

	/**
	 * process entity injection
	 *
	 * @entityName the entity to process, we use hash codes to identify builders
	 * @entity     The entity object
	 *
	 * @return The processed entity
	 */
	public function processEntityInjection( required entityName, required entity ){
		var ormSettings     = getController().getConfigSettings().modules[ "cborm" ].settings;
		var injectorInclude = ormSettings.injection.include;
		var injectorExclude = ormSettings.injection.exclude;

		// Enabled?
		if ( NOT ormSettings.injection.enabled ) {
			return arguments.entity;
		}

		// Include,Exclude?
		if (
			( len( injectorInclude ) AND listContainsNoCase( injectorInclude, arguments.entityName ) )
			OR
			( len( injectorExclude ) AND NOT listContainsNoCase( injectorExclude, arguments.entityName ) )
			OR
			( NOT len( injectorInclude ) AND NOT len( injectorExclude ) )
		) {
			// Process DI
			getWireBox().autowire( target = arguments.entity, targetID = "ORMEntity-#arguments.entityName#" );
		}

		return arguments.entity;
	}

	/**
	 * Lazy loading of the ORM utility according to the CFML engine you are on
	 *
	 * @return cborm.models.util.IORMUtil
	 */
	private function getOrm(){
		if ( isNull( variables.orm ) ) {
			variables.orm = new cborm.models.util.ORMUtilFactory().getORMUtil();
		}
		return variables.orm;
	}

}
