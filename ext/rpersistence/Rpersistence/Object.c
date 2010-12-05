#include "rpersistence_Object.h"

extern VALUE															rb_mRpersistence;
extern Rpersistence_AdapterFunctions_t*		c_adapter_functions_struct;

/*********************************************************************************************************************
************************************************  Public  ************************************************************
*********************************************************************************************************************/

void rb_Rpersistence_Object_init_Object()	{
	
	rb_define_method(							rb_cObject,		"persist!",							rb_Rpersistence_Object_store,								-1 );

	rb_define_singleton_method(		rb_cObject,		"persisted?",						rb_Rpersistence_Object_restore,							-1 );
	rb_define_method(							rb_cObject,		"persisted?",						rb_Rpersistence_Object_store,								-1 );

	rb_define_singleton_method(		rb_cObject,		"persist",							rb_Rpersistence_Object_restore,							-1 );

	rb_define_singleton_method(		rb_cObject,		"cease!",								rb_Rpersistence_Object_trash,								-1 );
	rb_define_method(							rb_cObject,		"cease!",								rb_Rpersistence_Object_trash,								-1 );

}

/*************************************************************
*  object.persist!                                           *
*  object.persist!( storage_port )                           *
*  object.persist!( :storage_port )                          *
*  object.persist!( storage_port, store_as )                 *
*  object.persist!( :storage_port, store_as )                *
*  data.persist!                                             *
*  data.persist!( storage_port )                             *
*  data.persist!( :storage_port )                            *
*  data.persist!( storage_port, store_as )                   *
*  data.persist!( :storage_port, store_as )                  *
*  class.persist!                                            *
*  class.persist!( storage_port )                            *
*  class.persist!( :storage_port )                           *
*  class.persist!( storage_port, store_as )                  *
*  class.persist!( :storage_port, store_as )                 *
*  module.persist!                                           *
*  module.persist!( storage_port )                           *
*  module.persist!( :storage_port )                          *
*  module.persist!( storage_port, store_as )                 *
*  module.persist!( :storage_port, store_as )                *
*  struct.persist!                                           *
*  struct.persist!( storage_port )                           *
*  struct.persist!( :storage_port )                          *
*  struct.persist!( storage_port, store_as )                 *
*  struct.persist!( :storage_port, store_as )                *
*  true.persist!( store_as, unique_key )                     *
*  true.persist!( storage_port, store_as, unique_key )       *
*  true.persist!( :storage_port, store_as, unique_key )      *
*  false.persist!( store_as, unique_key )                    *
*  false.persist!( storage_port, store_as, unique_key )      *
*  false.persist!( :storage_port, store_as, unique_key )     *
*  fixnum.persist!( store_as, unique_key )                   *
*  fixnum.persist!( storage_port, store_as, unique_key )     *
*  fixnum.persist!( :storage_port, store_as, unique_key )    *
*  float.persist!( store_as, unique_key )                    *
*  float.persist!( storage_port, store_as, unique_key )      *
*  float.persist!( :storage_port, store_as, unique_key )     *
*  bignum.persist!( store_as, unique_key )                   *
*  bignum.persist!( storage_port, store_as, unique_key )     *
*  bignum.persist!( :storage_port, store_as, unique_key )    *
*  string.persist!( store_as, unique_key )                   *
*  string.persist!( storage_port, store_as, unique_key )     *
*  string.persist!( :storage_port, store_as, unique_key )    *
*  symbol.persist!( store_as, unique_key )                   *
*  symbol.persist!( storage_port, store_as, unique_key )     *
*  symbol.persist!( :storage_port, store_as, unique_key )    *
*  regexp.persist!( store_as, unique_key )                   *
*  regexp.persist!( storage_port, store_as, unique_key )     *
*  regexp.persist!( :storage_port, store_as, unique_key )    *
*  match.persist!( store_as, unique_key )                    *
*  match.persist!( storage_port, store_as, unique_key )      *
*  match.persist!( :storage_port, store_as, unique_key )     *
*  struct.persist!( store_as, unique_key )                   *
*  struct.persist!( storage_port, store_as, unique_key )     *
*  struct.persist!( :storage_port, store_as, unique_key )    *
*  file.persist!( store_as, unique_key )                     *
*  file.persist!( storage_port, store_as, unique_key )       *
*  file.persist!( :storage_port, store_as, unique_key )      *
*  rational.persist!( store_as, unique_key )                 *
*  rational.persist!( storage_port, store_as, unique_key )   *
*  rational.persist!( :storage_port, store_as, unique_key )  *
*  complex.persist!( store_as, unique_key )                  *
*  complex.persist!( storage_port, store_as, unique_key )    *
*  complex.persist!( :storage_port, store_as, unique_key )   *
*  array.persist!( store_as, unique_key )                    *
*  array.persist!( storage_port, store_as, unique_key )      *
*  array.persist!( :storage_port, store_as, unique_key )     *
*  hash.persist!( store_as, unique_key )                     *
*  hash.persist!( storage_port, store_as, unique_key )       *
*  hash.persist!( :storage_port, store_as, unique_key )      *
*************************************************************/

VALUE rb_Rpersistence_Object_store(	int			argc,
																		VALUE*	args,
																		VALUE		rb_object )	{
	
	//	get storage port
	VALUE	rb_storage_port	=	rb_Rpersistence_storagePort( rb_object );

	const	ruby_value_type		c_ruby_type	=	TYPE( rb_object );
	switch ( c_ruby_type )	{
		
		case T_DATA:
			//	if object responds to :marshal_c_data, expect a ruby string of data in response
			if ( rb_respond_to( rb_intern( RPERSISTENCE_OBJECT_METHOD_DUMP_C_DATA ) ) )	{
				//	get marshaled C data
				VALUE	rb_marshaled_c_data	=	rb_funcall(	rb_object,
																								rb_intern( RPERSISTENCE_OBJECT_METHOD_DUMP_C_DATA ),
																								1,
																								storage_port );
				//	set marshaled C data as property in object - will be stored with properties
				rb_iv_set(	rb_object,
										RPERSISTENCE_OBJECT_IVAR_C_DATA,
										rb_marshaled_c_data );
			}
		case T_OBJECT:
		case T_CLASS:
		case T_MODULE:
		case T_STRUCT:
			rb_Rpersistence_Object_storeObject( rb_object );
			break;

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
		case T_FILE:
		case T_RATIONAL:
		case T_COMPLEX:
			rb_Rpersistence_Object_storeFlatObject(	rb_storage_port,
																							rb_object );
			break;

		case T_ARRAY:
		case T_HASH:

		default:
			rb_raise( rb_eArgumentError, "Unknown Data Type." );
			break;
	}


	//	return self
	return rb_object;
}

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
		
		rb_unique_id_for_object	=	c_adapter_functions_struct->unique_id(	rb_storage_port,
																																			rb_object );
		
	}
	else	{

		rb_unique_id_for_object	=	rb_funcall(	rb_storage_port,
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
	
		rb_object_data_table	=	c_adapter_functions_struct->object_data_table(	rb_storage_port,
																																						rb_object );
	
	}
	else	{

		rb_object_data_table		=	rb_funcall(	rb_storage_port,
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

		c_adapter_functions_struct->store_properties_for_object(	rb_storage_port,
																												rb_object,
																												rb_ivars_hash );

	}
	else	{

		//	store each ivar in storage port
		rb_funcall(	rb_storage_port,
								rb_intern( RPERSISTENCE_METHOD_OBJECT_STORE_IVARS ),
								1,
								rb_ivars_hash );
	}
}

/**************
*  ivarsHash  *
**************/

VALUE rb_Rpersistence_Object_ivarsHash( VALUE rb_object )	{

	//	include/exclude appropriate properties as defined
	rb_ivars_hash	=	rb_Rpersistence_Object_constrainPersistedProperties( rb_object );
	
	//	create ruby hash object
	
}

/*********************************
*  constrainPersistedProperties  *
*********************************/

VALUE rb_Rpersistence_Object_constrainPersistedProperties(	VALUE rb_object, 
																														VALUE rb_ivar_hash )	{
	
	//	check whether :persist_declared_by was called rather than :persist_by
	
	//	look for atomic items
}

/********************
*  storeFlatObject  *
********************/

VALUE rb_Rpersistence_Object_storeFlatObject(	VALUE		rb_object,
 																							VALUE		rb_storage_port )	{
	
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

