#
# Build APEX_Clothing
#

SET(GW_DEPS_ROOT $ENV{GW_DEPS_ROOT})
FIND_PACKAGE(PxShared REQUIRED)

SET(APEX_MODULE_DIR ${PROJECT_SOURCE_DIR}/../../../module)

SET(AM_SOURCE_DIR ${APEX_MODULE_DIR}/clothing)

if(DEFINED APEX_LINUX_SHARED_LIBRARIES)
	SET(APEX_CLOTHING_LIBTYPE SHARED)
else(DEFINED APEX_LINUX_SHARED_LIBRARIES)
	SET(APEX_CLOTHING_LIBTYPE STATIC)
endif(DEFINED APEX_LINUX_SHARED_LIBRARIES)
	
SET(APEX_CLOTHING_PLATFORM_INCLUDES
	${PROJECT_SOURCE_DIR}/../../../common/include/linux
)

SET(APEX_CLOTHING_COMPILE_DEFS
	# Common to all configurations
	${APEX_LINUX_COMPILE_DEFS};_LIB;PX_PHYSX_STATIC_LIB;
	__Linux__;Linux;NX_USE_SDK_STATICLIBS;NX_FOUNDATION_STATICLIB;NV_PARAMETERIZED_HIDE_DESCRIPTIONS=1;_LIB;ENABLE_TEST=0;cloth=cloth_embedded;	
)


if(${CMAKE_BUILD_TYPE_LOWERCASE} STREQUAL "debug")
	LIST(APPEND APEX_CLOTHING_COMPILE_DEFS
		${APEX_LINUX_DEBUG_COMPILE_DEFS};PX_PHYSX_DLL_NAME_POSTFIX=DEBUG;
	)
elseif(${CMAKE_BUILD_TYPE_LOWERCASE} STREQUAL "checked")
	LIST(APPEND APEX_CLOTHING_COMPILE_DEFS
		${APEX_LINUX_CHECKED_COMPILE_DEFS};PX_PHYSX_DLL_NAME_POSTFIX=CHECKED;
	)
elseif(${CMAKE_BUILD_TYPE_LOWERCASE} STREQUAL "profile")
	LIST(APPEND APEX_CLOTHING_COMPILE_DEFS
		${APEX_LINUX_PROFILE_COMPILE_DEFS};PX_PHYSX_DLL_NAME_POSTFIX=PROFILE;
	)
elseif(${CMAKE_BUILD_TYPE_LOWERCASE} STREQUAL release)
	LIST(APPEND APEX_CLOTHING_COMPILE_DEFS
		${APEX_LINUX_RELEASE_COMPILE_DEFS}
	)
else(${CMAKE_BUILD_TYPE_LOWERCASE} STREQUAL "debug")
	MESSAGE(FATAL_ERROR "Unknown configuration ${CMAKE_BUILD_TYPE}")
endif(${CMAKE_BUILD_TYPE_LOWERCASE} STREQUAL "debug")

# include common ApexClothing.cmake
INCLUDE(../common/ApexClothing.cmake)

# Do final direct sets after the target has been defined
TARGET_LINK_LIBRARIES(APEX_Clothing NvParameterized PsFastXml PxFoundation PxPvdSDK PhysXCommon)

# enable -fPIC so we can link static libs with the editor
SET_TARGET_PROPERTIES(APEX_Clothing PROPERTIES POSITION_INDEPENDENT_CODE TRUE)
