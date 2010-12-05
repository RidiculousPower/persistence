/*********************************************************************************************************************
************************************************  Public  ************************************************************
*********************************************************************************************************************/

/********************
*  Adapter Methods  *
********************/

//	Adapter methods are defined either in C or in Ruby (or a combination thereof). 
//
//	If a method is defined in one it does not need to be defined in the other.
//
//	If both C and Ruby methods are defined, the C method will be preferred.
//
//	If C RPERSISTENCE_METHOD_UNIQUE_ID_FOR_OBJECT or Ruby :unique_id_function initially return nil, 
//	RPERSISTENCE_METHOD_OBJECT_STORE_DATA_TABLE is expected to create and store the globally unique object ID that 
//	will later be returned by RPERSISTENCE_METHOD_UNIQUE_ID_FOR_OBJECT. 
//
//	This configuration is intended to support relational databases where the sequence is built into the table where 
//	object data will be inserted and thus requires the data to be inserted to get the ID rather than inserting by 
//	using the ID (as key/value stores are likely to do).

	/*------------------------
	|  Ruby Adapter Methods  |
	------------------------*/

	//	Create and return globally unique ID for rb_object
	#define RPERSISTENCE_METHOD_UNIQUE_ID_FOR_OBJECT			"unique_id_for_object"
	//	Create and return data table describing storage format for object info so that location and recreation are possible
	#define RPERSISTENCE_METHOD_OBJECT_STORE_DATA_TABLE		"store_object_data_table"
	//	Store contents of IVar Hash from rb_object
	#define RPERSISTENCE_METHOD_OBJECT_STORE_IVARS				"store_properties_for_object"
	//	Returns a Ruby byte string of marshaled data from the C pointer in the T_DATA
	#define RPERSISTENCE_OBJECT_METHOD_DUMP_C_DATA				"dump_c_data"
	#define RPERSISTENCE_OBJECT_METHOD_LOAD_C_DATA				"load_c_data"

	/*---------------------
	|  C Adapter Methods  |
	--------------------*/

	//	Global pointer to C adapter methods
	extern	 	Rpersistence_AdapterFunctions_t*						c_adapter_functions_struct;

	typedef		Rpersistence_AdapterFunctions_s							Rpersistence_AdapterFunctions_t;
	typedef		Rpersistence_ObjectDataTable_s							Rpersistence_ObjectDataTable_t;
	typedef		Rpersistence_VersionData_s									Rpersistence_VersionData_t;

	//	Struct defines storage format for object info so that location and recreation are possible
	struct		Rpersistence_ObjectDataTable_s	{
		
		ruby_value_type										c_type;
		VALUE															rb_class;
		Rpersistence_VersionData_t*				c_version_data;
		
	};

		struct	Rpersistence_VersionData_s	{
		
			char*			c_branch;
			int				c_major;
			int				c_minor;
			int				c_patch;
			int				c_merge_revert;
		
		};

	//	Global struct holding C pointers to Adapter methods
	struct 		Rpersistence_AdapterFunctions_s	{

		//	Create and return globally unique ID for rb_object
		VALUE	(*unique_id_function)( rb_storage_port, rb_object );
		//	Create and return data table describing storage format for object info so that location and recreation are possible
		Rpersistence_ObjectDataTable_t*	(*object_data_table)( rb_storage_port, rb_object );
		//	Store contents of IVar Hash from rb_object
		VALUE	(*store_properties_for_object)( rb_storage_port, rb_object );

	};
