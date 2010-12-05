#include "rpersist.h"
#include "rpersistence_dump.h"
#include "rpersistence_load.h"
#include "rpersistence_atomic.h"

VALUE	rb_cRpersistence;

void Init_rpersistence()	{
	
	rb_cRpersistence	=	define_module_under(	rb_cObject,
																						"Rpersistence",
																						rb_cObject );

	
}

/****************
*  storagePort  *
****************/

VALUE rb_Rpersistence_storagePort(	VALUE	rb_object )	{

		//	use storage port if specified
		
		//	otherwise use current storage port

}
