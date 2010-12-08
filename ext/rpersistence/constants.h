
/*********************************************************************************************************************
************************************************  Public  ************************************************************
*********************************************************************************************************************/

/******************
*  Instance Vars  *
******************/

//	Instance variables defined in Object
#define RPERSISTENCE_OBJECT_IVAR_UNIQUE_ID						"@__rpersistence_id__"
#define RPERSISTENCE_OBJECT_IVAR_C_DATA								"@__rpersistence_c_data__"
#define RPERSISTENCE_OBJECT_SYM_C_DATA								":__rpersistence_c_data__"

/*********************************************************************************************************************
***********************************************  Private  ***********************************************************
*********************************************************************************************************************/

/*********************************
*  Internal Constants and Types  *
*********************************/

#ifndef TRUE
	#define TRUE 1
#endif
#ifndef FALSE
	#define FALSE 0
#endif
#ifndef BOOL
	typedef BOOL int;
#endif

//	Convenience constants for adapters
#define RPERSISTENCE_INDEX_UNIQUE_ID									"unique_id"

#define RPERSISTENCE_MODULE_RPERSISTENCE							"Rpersistence"


//	temporary until handled by make system
#define	RPERSISTENCE_HAS_ADAPTER_RBDB									TRUE


