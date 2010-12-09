#include "rpersistence_Object.h"
#include "rpersistence_Object_internal.h"

extern VALUE															rb_mRpersistence;
extern Rpersistence_AdapterFunctions_t*		c_adapter_functions_struct;

/*********************************************************************************************************************
************************************************  Public  ************************************************************
*********************************************************************************************************************/

void Init_rpersistence()	{
	
	rb_define_singleton_method(		rb_cObject,		"bucket_and_key_for_object_table",			rb_Rpersistence_bucketAndKeyForObjectTable,				-1 );
	rb_define_singleton_method(		rb_cObject,		"persistence_data_table",								rb_Rpersistence_persistenceDataTable,							-1 );

}

/************************************
*  bucket_and_key_for_object_table  *
************************************/

//	it is possible we need to produce a secondary key from primary key/data pair
//	we want to be able to describe this from Ruby
//	so we need to be able to get ruby values back out of the packed key/data
//	object ID => {c struct}
VALUE rb_Rpersistence_bucketAndKeyForObjectTable(	int			argc,
																									VALUE*	args,
																									VALUE		rb_object )	{

}

/***************************
*  persistence_data_table  *
***************************/

VALUE rb_Rpersistence_persistenceDataTable(	int			argc,
																						VALUE*	args,
																						VALUE		rb_object )	{

}

