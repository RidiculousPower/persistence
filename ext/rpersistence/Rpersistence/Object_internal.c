#include "rpersistence_Object_internal.h"

extern VALUE															rb_mRpersistence;
extern Rpersistence_AdapterFunctions_t*		c_adapter_functions_struct;

/*********************************************************************************************************************
***********************************************  Private  ***********************************************************
*********************************************************************************************************************/

/********************
*  uniqueObjectID  *
********************/

VALUE rb_Rpersistence_Object_uniqueObjectID( VALUE rb_object )	{

	//	unique id is global and allows object's unique key (which is class/store_as specific) to be dynamic
	VALUE	rb_unique_id_for_object	=	Qnil;
	if ( c_adapter_functions_struct->unique_id != NULL )	{
		
		rb_unique_id_for_object	=	c_adapter_functions_struct->unique_id(	rb_persistence_port,
																																			rb_object );
		
	}
	else	{

		rb_unique_id_for_object	=	rb_funcall(	rb_persistence_port,
																					rb_intern( RPERSISTENCE_METHOD_UNIQUE_ID_FOR_OBJECT ),
																					1,
																					rb_object );
	}
	
	return rb_unique_id_for_object;
}

/********************
*  objectDataTable  *
********************/

//	object data table is a struct that describes:
//	* type
//	* class
//	* unique key
VALUE rb_Rpersistence_Object_objectDataTable( VALUE rb_object )	{
	
	VALUE	rb_object_data_table	=	Qnil;
	if ( c_adapter_functions_struct->object_data_table != NULL )	{
	
		rb_object_data_table	=	c_adapter_functions_struct->object_data_table(	rb_persistence_port,
																																						rb_object );
	
	}
	else	{

		rb_object_data_table		=	rb_funcall(	rb_persistence_port,
																					rb_intern( RPERSISTENCE_METHOD_OBJECT_STORE_DATA_TABLE ),
																					1,
																					rb_object );
	}

	return rb_object_data_table;
}

/*********************
*  storeObjectIVars  *
*********************/

void rb_Rpersistence_Object_storeObjectIVars( VALUE rb_object )	{

	VALUE	rb_object_data_table	=	rb_Rpersistence_Object_objectDataTable( rb_object );

		//	create ivars hash from table
	VALUE	rb_ivars_hash	=	rb_Rpersistence_Object_ivarsHash( rb_object );

	if ( c_adapter_functions_struct->store_properties_for_object != NULL )	{

		c_adapter_functions_struct->store_properties_for_object(	rb_persistence_port,
																															rb_object,
																															rb_ivars_hash );

	}
	else	{

		//	store each ivar in storage port
		rb_funcall(	rb_persistence_port,
								rb_intern( RPERSISTENCE_METHOD_OBJECT_STORE_IVARS ),
								1,
								rb_ivars_hash );
	}
}

/**************
*  ivarsHash  *
**************/

VALUE rb_Rpersistence_Object_ivarsHash( VALUE rb_object )	{
	
	//	create ruby hash object
	VALUE	rb_ivars_hash	=	;

	//	check whether :persist_declared_by was called rather than :persist_by
	VALUE	rb_persist_declared_only	=	rb_iv_get(	rb_object,
																								"@persist_declared_only" );

	//	"declared only" means only those items explicitly noted atomic/non-atomic
	VALUE	rb_declared_items_hash	=	Qnil;
	if ( persist_declared_only == Qtrue )	{

		//	if we have declared only then we need only those items in either atomic/non-atomic storage
		VALUE	rb_atomic_items_hash			=	rb_iv_get(	rb_object,
																									"@atomic_attributes" );
		VALUE	rb_non_atomic_items_hash	=	rb_iv_get(	rb_object,
																									"@non_atomic_attributes" );

		//	merge changes the hash so we have to duplicate
		rb_declared_items_hash	=	rb_hash_dup( rb_atomic_items_hash );
		rb_hash_merge(	rb_declared_items_hash,
										rb_non_atomic_items_hash	);
		
		//	delete elements in rb_ivars_hash that are not in rb_declared_items_hash
		VALUE	rb_args	=	rb_ary_new();
		rb_ary_push(	rb_args,
									rb_declared_items_hash );
		rb_ary_push(	rb_args,
									rb_ivars_hash );
		rb_hash_foreach(	rb_declared_items_hash,
											rb_Rpersistence_Object_ivarsHash_iterateAndRemoveNonDeclared,
											rb_args );
	}

	return rb_ivars_hash;
}

/********************************
*  iterateAndRemoveNonDeclared  *
********************************/

VALUE rb_Rpersistence_Object_ivarsHash_iterateAndRemoveNonDeclared(	VALUE		rb_key,
																																		VALUE		rb_data,
																																		VALUE		rb_args )	{
	
	VALUE	rb_declared_items_hash	=	rb_ary_enty( rb_args, 0 );
	VALUE	rb_ivars_hash						=	rb_ary_enty( rb_args, 1 );
	
	//	if the key isn't declared, delete it from ivars hash
	if ( rb_hash_aref(	rb_declared_items_hash,
											rb_key ) == Qnil )	{
		rb_hash_delete(	rb_ivars_hash,
										rb_key );
	}
}

/********************
*  storeFlatObject  *
********************/

VALUE rb_Rpersistence_Object_storeFlatObject(	VALUE		rb_object,
 																							VALUE		rb_persistence_port )	{
	
	const	ruby_value_type		c_ruby_type	=	TYPE( rb_object );
	switch ( ruby_value_type )	{

		case T_TRUE:
		case T_FALSE:
		case T_FIXNUM:
		case T_FLOAT:
		case T_BIGNUM:
		case T_STRING:
		case T_SYMBOL:
		case T_REGEXP:
		case T_MATCH:
		case T_STRUCT:
		case T_RATIONAL:
		case T_COMPLEX:

		case T_FILE:
			//	store on disk and references in data table
		
	}
		
}

/***************
*  storeCData  *
***************/

VALUE rb_Rpersistence_Object_storeCData(	VALUE		rb_object,
																					VALUE		rb_persistence_port )	{

	//	if object responds to :RPERSISTENCE_OBJECT_METHOD_DUMP_C_DATA (:marshal_c_data), expect a ruby string of data in response
	if ( rb_respond_to( rb_intern( RPERSISTENCE_OBJECT_METHOD_DUMP_C_DATA ) ) )	{
		//	get marshaled C data
		VALUE	rb_marshaled_c_data	=	rb_funcall(	rb_object,
																						rb_intern( RPERSISTENCE_OBJECT_METHOD_DUMP_C_DATA ),
																						1,
																						rb_persistence_port );
																						
		//	set marshaled C data as property in object - will be stored with properties
		rb_iv_set(	rb_object,
								RPERSISTENCE_OBJECT_IVAR_C_DATA,
								rb_marshaled_c_data );
								
		//	also note it as declared so it will be saved in all situations
		rb_funcall(	rb_object,
								rb_intern( "attr_non_atomic_setter" ),
								1,
								RPERSISTENCE_OBJECT_SYM_C_DATA )
	}
	
}