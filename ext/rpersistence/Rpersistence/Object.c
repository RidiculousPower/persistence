#include "rpersistence_Object.h"
#include "rpersistence_Object_internal.h"

extern VALUE															rb_mRpersistence;
extern Rpersistence_AdapterFunctions_t*		c_adapter_functions_struct;

/*********************************************************************************************************************
************************************************  Public  ************************************************************
*********************************************************************************************************************/

void rb_Rpersistence_Object_init_Object()	{
	
	rb_define_method(							rb_cObject,		"persist!",										rb_Rpersistence_Object_store,								-1 );

	rb_define_singleton_method(		rb_cObject,		"persisted?",									rb_Rpersistence_Object_isPersisted,					-1 );
	rb_define_method(							rb_cObject,		"persisted?",									rb_Rpersistence_Object_isPersisted,					-1 );

	rb_define_singleton_method(		rb_cObject,		"persist",										rb_Rpersistence_Object_restore,							-1 );

	rb_define_singleton_method(		rb_cObject,		"persistence_data_table",			rb_Rpersistence_Object_restore,							-1 );
	rb_define_singleton_method(		rb_cObject,		"instance_variables_hash",			rb_Rpersistence_Object_restore,							-1 );

	rb_define_singleton_method(		rb_cObject,		"cease!",											rb_Rpersistence_Object_trash,								-1 );
	rb_define_method(							rb_cObject,		"cease!",											rb_Rpersistence_Object_trash,								-1 );

}

/***********************************************
*  object.persist!                             *
*  object.persist!( persistence_port )             *
*  object.persist!( :persistence_port )            *
*  object.persist!( persistence_port, store_as )   *
*  object.persist!( :persistence_port, store_as )  *
*  data.persist!                               *
*  data.persist!( persistence_port )               *
*  data.persist!( :persistence_port )              *
*  data.persist!( persistence_port, store_as )     *
*  data.persist!( :persistence_port, store_as )    *
*  class.persist!                              *
*  class.persist!( persistence_port )              *
*  class.persist!( :persistence_port )             *
*  class.persist!( persistence_port, store_as )    *
*  class.persist!( :persistence_port, store_as )   *
*  module.persist!                             *
*  module.persist!( persistence_port )             *
*  module.persist!( :persistence_port )            *
*  module.persist!( persistence_port, store_as )   *
*  module.persist!( :persistence_port, store_as )  *
*  struct.persist!                             *
*  struct.persist!( persistence_port )             *
*  struct.persist!( :persistence_port )            *
*  struct.persist!( persistence_port, store_as )   *
*  struct.persist!( :persistence_port, store_as )  *
***********************************************/

VALUE rb_Rpersistence_Object_storeObject(	int			argc,
																					VALUE*	args,
																					VALUE		rb_object )	{
	
	VALUE	rb_persistence_port	=	Qnil;
	rb_scan_args(	argc,
								args,
								"03",
								& rb_persistence_port,
								& rb_store_as,
								& rb_unique_key );

	//	get storage port if wasn't specified in args
	if ( rb_persistence_port == Qnil )	{
		rb_persistence_port	=	rb_Rpersistence_storagePort( rb_object );
	}	

	const	ruby_value_type		c_ruby_type	=	TYPE( rb_object );
	switch ( c_ruby_type )	{
		
		case T_DATA:
			rb_Rpersistence_Object_storeCData( rb_object );		
		case T_OBJECT:
		case T_CLASS:
		case T_MODULE:
		case T_STRUCT:
			rb_Rpersistence_Object_storeObject( rb_object );
			break;

		default:
			rb_raise( rb_eArgumentError, "Unknown Data Type." );
			break;
	}


	//	return self
	return rb_object;
}

/*************************************************************
*  true.persist!( store_as, unique_key )                     *
*  true.persist!( persistence_port, store_as, unique_key )       *
*  true.persist!( :persistence_port, store_as, unique_key )      *
*  false.persist!( store_as, unique_key )                    *
*  false.persist!( persistence_port, store_as, unique_key )      *
*  false.persist!( :persistence_port, store_as, unique_key )     *
*  fixnum.persist!( store_as, unique_key )                   *
*  fixnum.persist!( persistence_port, store_as, unique_key )     *
*  fixnum.persist!( :persistence_port, store_as, unique_key )    *
*  float.persist!( store_as, unique_key )                    *
*  float.persist!( persistence_port, store_as, unique_key )      *
*  float.persist!( :persistence_port, store_as, unique_key )     *
*  bignum.persist!( store_as, unique_key )                   *
*  bignum.persist!( persistence_port, store_as, unique_key )     *
*  bignum.persist!( :persistence_port, store_as, unique_key )    *
*  string.persist!( store_as, unique_key )                   *
*  string.persist!( persistence_port, store_as, unique_key )     *
*  string.persist!( :persistence_port, store_as, unique_key )    *
*  symbol.persist!( store_as, unique_key )                   *
*  symbol.persist!( persistence_port, store_as, unique_key )     *
*  symbol.persist!( :persistence_port, store_as, unique_key )    *
*  regexp.persist!( store_as, unique_key )                   *
*  regexp.persist!( persistence_port, store_as, unique_key )     *
*  regexp.persist!( :persistence_port, store_as, unique_key )    *
*  match.persist!( store_as, unique_key )                    *
*  match.persist!( persistence_port, store_as, unique_key )      *
*  match.persist!( :persistence_port, store_as, unique_key )     *
*  struct.persist!( store_as, unique_key )                   *
*  struct.persist!( persistence_port, store_as, unique_key )     *
*  struct.persist!( :persistence_port, store_as, unique_key )    *
*  file.persist!( store_as, unique_key )                     *
*  file.persist!( persistence_port, store_as, unique_key )       *
*  file.persist!( :persistence_port, store_as, unique_key )      *
*  rational.persist!( store_as, unique_key )                 *
*  rational.persist!( persistence_port, store_as, unique_key )   *
*  rational.persist!( :persistence_port, store_as, unique_key )  *
*  complex.persist!( store_as, unique_key )                  *
*  complex.persist!( persistence_port, store_as, unique_key )    *
*  complex.persist!( :persistence_port, store_as, unique_key )   *
*  array.persist!( store_as, unique_key )                    *
*  array.persist!( persistence_port, store_as, unique_key )      *
*  array.persist!( :persistence_port, store_as, unique_key )     *
*  hash.persist!( store_as, unique_key )                     *
*  hash.persist!( persistence_port, store_as, unique_key )       *
*  hash.persist!( :persistence_port, store_as, unique_key )      *
*************************************************************/

VALUE rb_Rpersistence_Object_store(	int			argc,
																		VALUE*	args,
																		VALUE		rb_object )	{
	
	VALUE	rb_persistence_port	=	Qnil;
	rb_scan_args(	argc,
								args,
								"13",
								& rb_persistence_port,
								& rb_store_as,
								& rb_unique_key );

	//	get storage port if wasn't specified in args
	if ( rb_persistence_port == Qnil )	{
		rb_persistence_port	=	rb_Rpersistence_storagePort( rb_object );
	}	
	
	const	ruby_value_type		c_ruby_type	=	TYPE( rb_object );
	switch ( c_ruby_type )	{
		
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
			rb_Rpersistence_Object_storeFlatObject(	rb_persistence_port,
																							rb_object,
																							rb_store_as,
																							rb_unique_key );
			break;

		case T_ARRAY:
			rb_Rpersistence_Object_storeArray(	rb_persistence_port,
																					rb_object,
																					rb_store_as,
																					rb_unique_key );
			break;

		case T_HASH:
			rb_Rpersistence_Object_storeHash(		rb_persistence_port,
																					rb_object,
																					rb_store_as,
																					rb_unique_key );
			break;

		default:
			rb_raise( rb_eArgumentError, "Unknown Data Type." );
			break;
	}

	//	return self
	return rb_object;
}

/**************************************************************
*  object.persisted?                                          *
*  object.persisted?( persistence_port )                          *
*  object.persisted?( :persistence_port )                         *
*  object.persisted?( persistence_port, store_as )                *
*  object.persisted?( :persistence_port, store_as )               *
*  <Class>.persisted?                                         *
*  <Class>.persisted?( unique_key )                           *
*  <Class>.persisted?( unique_key, persistence_port )             *
*  <Class>.persisted?( unique_key, :persistence_port )            *
*  <Class>.persisted?( unique_key, persistence_port, store_as )   *
*  <Class>.persisted?( unique_key, :persistence_port, store_as )  *
**************************************************************/

VALUE rb_Rpersistence_Object_isPersisted(	int			argc,
																					VALUE*	args,
																					VALUE		rb_object )	{
	
}

/***********************************************
*  <Class>.persist( unique_key )               *
*  <Class>.persist( persistence_port )             *
*  <Class>.persist( :persistence_port )            *
*  <Class>.persist( persistence_port, store_as )   *
*  <Class>.persist( :persistence_port, store_as )  *
***********************************************/

VALUE rb_Rpersistence_Object_restore(	int			argc,
																			VALUE*	args,
																			VALUE		rb_object )	{
	
}

/**********************************************************
*  object.cease!                                          *
*  object.cease!( persistence_port )                          *
*  object.cease!( :persistence_port )                         *
*  object.cease!( persistence_port, store_as )                *
*  object.cease!( :persistence_port, store_as )               *
*  <Class>.cease!                                         *
*  <Class>.cease!( unique_key )                           *
*  <Class>.cease!( unique_key, persistence_port )             *
*  <Class>.cease!( unique_key, :persistence_port )            *
*  <Class>.cease!( unique_key, persistence_port, store_as )   *
*  <Class>.cease!( unique_key, :persistence_port, store_as )  *
**********************************************************/

VALUE rb_Rpersistence_Object_trash(	int			argc,
																		VALUE*	args,
																		VALUE		rb_object )	{
	
}

