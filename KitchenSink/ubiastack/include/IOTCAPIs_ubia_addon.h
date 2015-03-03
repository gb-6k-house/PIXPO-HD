
#ifndef _IOTCAPIs_UBIA_ADDON_H_
#define _IOTCAPIs_UBIA_ADDON_H_

#include "platform_Config.h"

#ifdef IOTC_Win32
/** @cond */
#ifdef IOTC_STATIC_LIB
#define P2PAPI_API  
#elif defined P2PAPI_EXPORTS
#define P2PAPI_API __declspec(dllexport)
#else
#define P2PAPI_API __declspec(dllimport)
#endif // #ifdef P2PAPI_EXPORTS
#endif

/** @endcond */

#ifdef IOTC_Linux
#define P2PAPI_API
#define __stdcall
#endif // #ifdef IOTC_Linux


#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* ============================================================================
 * Function Declaration
 * ============================================================================
 */

/**
 * \brief Get the version of IOTC module
 *
 * \details This function returns the version of IOTC module.
 *
 * \param pnVersion [out] The version of IOTC module. It contains
 *			the version from high byte to low byte, for example, 0x01020304
 *			means the version is 1.2.3.4
 *
 * \see RDT_GetRDTApiVer(), avGetAVApiVer()
 */
P2PAPI_API void UBIC_Get_Version(unsigned long *pnVersion);


/**
 * \brief Set the max number of IOTC sessions of IOTC module
 *
 * \details This function set the max number of allowable IOTC sessions in IOTC
 *			module. The max number of IOTC session limits the max number of
 *			connected clients in device side, while it limits the max number
 *			connected devices in client	side. A device or a client could use
 *			this function to reduce the number of IOTC sessions in order to save
 *			some memory usage.
 *
 * \param nMaxSessionNum [in] The max number of IOTC sessions
 *
 * \attention	(1) This function is optional if users do not want to change the
 *				default max number of IOTC sessions, i.e. MAX_DEFAULT_IOTC_SESSION_NUMBER.
 *				However, if users really wants to change it, this function
 *				shall be called before IOTC platform is initialized.<br><br>
 *				(2) The maximum IOTC session number is platform dependent.
 *				See the definition of MAX_DEFAULT_IOTC_SESSION_NUMBER for each
 *				platform.
 */
P2PAPI_API void UBIC_Set_Max_Session_Number(unsigned long nMaxSessionNum);


/**
 * \brief Initialize IOTC module
 *
 * \details This function is used by devices or clients to initialize IOTC
 *			module and shall be called before any IOTC module related
 *			function is invoked except for IOTC_Set_Max_Session_Number().
 *
 * \param nUDPPort [in] Specify a UDP port. Random UDP port is used if it is specified as 0.
 * \param cszP2PHostNamePrimary [in] Specify the host name or IP address of
 *			the primary master. Cannot be NULL. See attention below for more detail.
 * \param cszP2PHostNameSecondary [in] Specify the host name or IP address of
 *			the secondary master. Cannot be NULL. See attention below for more detail.
 * \param cszP2PHostNameThird [in] Specify the host name or IP address of
 *			the third master. Can be NULL if only two masters are required.
 *			See attention below for more detail.
 * \param cszP2PHostNameFourth [in] Specify the host name or IP address of 
 *			the fourth master. Can be NULL if only two masters are required.
 *			See attention below for more detail.
 *
 * \return #IOTC_ER_NoERROR if initializing successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTC_ER_ALREADY_INITIALIZED IOTC module is already initialized
 *			- #IOTC_ER_MASTER_TOO_FEW Two masters are required as parameters at minimum
 *			- #IOTC_ER_FAIL_CREATE_MUTEX Fails to create Mutexs
 *			- #IOTC_ER_FAIL_CREATE_THREAD Fails to create threads
 *
 * \see IOTC_Initialize2(), IOTC_DeInitialize()
 *
 * \attention   (1) This function is the key entry to whole IOTC platform, including
 *				RDT module and AV module. That means, if you want tso use
 *				RDT module, users shall still use this function to initialize IOTC
 *				module before calling RDT_Initialize(). <br><br>
 *				(2) Usually, host name is suggested to be used to specify a master.
 *				because that will ensure devices and clients can still connect
 *				to masters even the network address configuration of masters
 *				changes in the future. However, in rare case, the host name
 *				of masters can not be resolved due to network issue and it is 
 *				necessary to specify IP address of masters in this function
 *				in order for successful connection. The host name and IP address
 *				of each master is listed as below:
 *				- Master #1: m1.iotcplatform.com => 50.19.254.134
 *				- Master #2: m2.iotcplatform.com => 122.248.234.207
 *				- Master #3: m3.iotcplatform.com => 46.137.188.54
 *				- Master #4: m4.iotcplatform.com => 122.226.84.253
 *				- Master #5: m5.iotcplatform.com => 61.188.37.21
 */
P2PAPI_API int UBIC_Initialize(unsigned short nUDPPort, const char* cszP2PHostNamePrimary,
								const char* cszP2PHostNameSecondary, const char* cszP2PHostNameThird,
								const char* cszP2PHostNameFourth);


/**
 * \brief Initialize IOTC module
 *
 * \details This function is used by devices or clients to initialize IOTC
 *			module and shall be called before	any IOTC module related
 *			function is invoked except for IOTC_Set_Max_Session_Number().
 *			<br>
 *			The different between this function and IOTC_Initialize() is this
 *			function uses following steps to connect masters (1) IP addresses
 *			of master (2) if fails to connect in step 1, resolve predefined
 *			domain name of masters (3) try to connect again with the resolved
 *			IP address of step 2 if IP is resolved successfully.
 *
 * \param nUDPPort [in] Specify a UDP port. Random UDP port is used if it is specified as 0.
 *
 * \return #IOTC_ER_NoERROR if initializing successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTC_ER_ALREADY_INITIALIZED IOTC module is already initialized
 *			- #IOTC_ER_FAIL_CREATE_MUTEX Fails to create Mutexs
 *			- #IOTC_ER_FAIL_CREATE_THREAD Fails to create threads
 *
 * \see IOTC_Initialize(), IOTC_DeInitialize()
 *
 * \attention This function is the key entry to whole IOTC platform, including
 *				RDT module and AV module. That means, if you want to use
 *				RDT module, users shall still use this function to initialize IOTC
 *				module before calling RDT_Initialize().
 */
P2PAPI_API int UBIC_Initialize2(unsigned short nUDPPort);


/**
 * \brief Deinitialize IOTC module
 *
 * \details This function will deinitialize IOTC module.
 *
 * \return #IOTC_ER_NoERROR if deinitialize successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED the IOTC module is not initialized yet.
 *
 * \see IOTC_Initialize(), IOTC_Initialize2()
 *
 * \attention IOTC_DeInitialize() will automatically close all IOTC sessions
 *				in local site while the remote site will find sessions have
 *				been closed after certain period of time. Therefore, it is
 *				suggested to close all sessions before invoking this function
 *				to ensure the remote site and real-time session status.
 */
P2PAPI_API int UBIC_DeInitialize(void);


/**
 * \brief Used by a device to login to IOTC servers
 *
 * \details This function will let a device login to IOTC servers. UID is required
 *			when login to IOTC servers. The device name and password are applicable
 *			only in LAN mode when the device cannot login to IOTC servers
 *			due to network issue.
 *
 * \param cszUID [in] The UID of that device login to IOTC servers
 * \param cszDeviceName [in] The name of that device, used in LAN mode for clients
 *			to connect
 * \param cszDevicePWD [in] The password of that device, used in LAN mode for
 *			clients to connect
 *
 * \return #IOTC_ER_NoERROR if device had obtained server list and sent login packets successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_UNLICENSE The UID is not licensed or expired
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_LOGIN_ALREADY_CALLED The device is already under login process currently
 *			- #IOTC_ER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTC_ER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTC_ER_FAIL_SOCKET_BIND Fails to bind sockets
 *			- #IOTC_ER_FAIL_CREATE_THREAD Fails to create threads
 *			- #IOTC_ER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTC_ER_TCP_TRAVEL_FAILED Cannot connect to masters in neither UDP nor TCP
 *			- #IOTC_ER_TCP_CONNECT_TO_SERVER_FAILED Cannot connect to IOTC servers in TCP
 *			- #IOTC_ER_NO_PERMISSION The device does not support TCP relay
 *			- #IOTC_ER_SERVER_NOT_RESPONSE IOTC servers have no response
 *			- #IOTC_ER_FAIL_GET_LOCAL_IP Fails to get the device's local IP address
 *			- #IOTC_ER_NETWORK_UNREACHABLE Network is unreachable
 *			- #IOTC_ER_NO_SERVER_LIST No IOTC server information while device login 
 *
 * \attention (1) This function is a block process. That means this function will return until
 *				the device can login into IOTC servers successfully or some error happens
 *				during the process. It is suggested to use another thread to perform
 *				login process so that sequential instructions will not blocked. <br><br>
 *				(2) Please use IOTC_Get_Login_Info() to check if device really logins
 * 				into server successfully.
 */
P2PAPI_API int UBIC_Device_Login(const char *cszUID, const char *cszDeviceName, const char *cszDevicePWD);


/**
 * \brief Used by a device to get the login information
 *
 * \details This function gets the login information of a device to IOTC servers.
 *
 * \param pnLoginInfo [out] The login info with meanings of following bits
 *			- bit 0: the device is ready for connection by client from LAN if this bit is 1
 *			- bit 1: the device is ready for connection by client from Internet if this bit is 1 
 *			- bit 2: if this bit is 1, it means the device has received login
 *						response from IOTC servers since IOTC_Get_Login_Info()
 *						is called last time.
 *
 * \return The number of fails to login to IOTC servers.
 *
 */
P2PAPI_API int UBIC_Get_Login_Info(unsigned long *pnLoginInfo);


/**
 * \brief Used by a device to get the login information
 *
 * \details This function gets the login information of a device to IOTC servers. <br>
 *			The difference of this function and IOTC_Get_Login_Info() is
 *			this function will set callback function inside IOTC module and
 *			that callback function will be invoked whenever the login status
 *			of that device is updated from IOTC servers, for example, IOTC
 *			servers response login message to that device or the connection
 *			between IOTC servers and that device has been lost.
 *
 * \param pfxLoginInfoFn [in] The function pointer to getting login info function
 *
 */
P2PAPI_API void UBIC_Get_Login_Info_ByCallBackFn(loginInfoCB pfxLoginInfoFn);

/**
 * \brief Used by a device to listen connections from clients
 *
 * \details This function is for a device to listen any connection from clients.
 *			If connection is established with the help of IOTC servers, the
 *			IOTC session ID will be returned in this function and then device and
 *			client can communicate for the other later by using this IOTC session ID.
 *
 * \param nTimeout [in] The timeout for this function in unit of millisecond, give 0 means block forever
 *
 * \return IOTC session ID if return value >= 0
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in device side
 *			- #IOTC_ER_LISTEN_ALREADY_CALLED The device is already in listen process
 *			- #IOTC_ER_TIMEOUT No connection is established from clients before timeout expires
 *			- #IOTC_ER_EXIT_LISTEN The device stops listening for connections from clients.
 *
 * \attention (1) This function is a block process, waiting for following two
 *				conditions happens before executing	sequential instructions
 *				(a) any connection from clients is established (b) timeout expires.<br><br>
 *				(2) nTimeout has no effect in 8051 platform.
 */
P2PAPI_API int  UBIC_Listen(unsigned long nTimeout);


/**
 * \brief Used by a device to exit listen process
 *
 * \details Since listen process is a block process and that means a device
 *			will wait for following two conditions happens before executing
 *			sequential instructions (1) any connection from clients is established
 *			(2) timeout expires. In some cases, users may want the device to
 *			exit listen immediately by this function in another thread before
 *			the two conditions above happens.
 */
P2PAPI_API void UBIC_Listen_Exit(void);


#if defined(IOTC_Win32) || defined(IOTC_ARC_HOPE312) || defined(IOTC_Linux)
/**
 * \brief Used by a device to listen connections from clients
 *
 * \details This function is for a device to listen any connection from clients.
 *			If connection is established with the help of IOTC servers, the
 *			IOTC session ID will be returned in this function and then device and
 *			client can communicate for the other later by using this IOTC session ID.
 *			<br> <br>
 *			The difference between this function and IOTC_Listen() is that
 *			this function supports IOTC session established in secure mode. Also,
 *			by specifying IOTC_ARBITRARY_MODE as IOTC session mode, this function can
 *			let devices establish IOTC session in either non-secure mode and secure
 *			mode according to clients' request.
 *
 * \param nTimeout [in] The timeout for this function in unit of millisecond, give 0 means block forever
 * \param cszAESKey [in] The AES key for certification. Specify it as NULL will make
 *			IOTC module use predefined AES key.
 * \param nSessionMode [in] The IOTC session mode that a device want to connect.
 *			Please refer to #IOTCSessionMode for more detail
 *
 * \return IOTC session ID if return value >= 0
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in device side
 *			- #IOTC_ER_LISTEN_ALREADY_CALLED The device is already in listen process
 *			- #IOTC_ER_TIMEOUT No connection is established from clients before timeout expires
 *			- #IOTC_ER_EXIT_LISTEN The device stops listening for connections from clients.
 *			- #IOTC_ER_INVALID_MODE The IOTC session mode is not valid. Please refer to #IOTCSessionMode
 *			- #IOTC_ER_CLIENT_NOT_SECURE_MODE A client wants to connect to a device in
 *					non-secure mode while that device supports secure mode only.
 *			- #IOTC_ER_CLIENT_SECURE_MODE A client wants to connect to a device
 *					in secure mode while that device does not support secure mode.
 *			- #IOTC_ER_AES_CERTIFY_FAIL The AES certification fails
 *
 * \attention (1) This function is available on Win32, Linux, Android, iOS and ARC platforms.<br><br>
 *				(2) The AES key shall be matched between a device and a client 
 *				in order to establish connection successfully.
 */
P2PAPI_API int  UBIC_Listen2(unsigned long nTimeout, const char *cszAESKey, IOTCSessionMode nSessionMode);


/**
 * \brief Used by a client to connect a device
 *
 * \details This function is for a client to connect a device by specifying
 *			the UID of that device. If connection is established with the
 *			help of IOTC servers, the IOTC session ID will be returned in this
 *			function and then device and client can communicate for the other
 *			later by using this IOTC session ID.
 *
 * \param cszUID [in] The UID of a device that client wants to connect
 *
 * \return IOTC session ID if return value >= 0
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_CONNECT_IS_CALLING The client is already connecting to a device
 *			- #IOTC_ER_UNLICENSE The specified UID of that device is not licensed or expired
 *			- #IOTC_ER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in client side
 *			- #IOTC_ER_DEVICE_NOT_LISTENING The device is not listening for connection now
 *			- #IOTC_ER_FAIL_CONNECT_SEARCH The client stop connecting to the device
 *			- #IOTC_ER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTC_ER_FAIL_CREATE_THREAD Fails to create threads
 *			- #IOTC_ER_TCP_TRAVEL_FAILED Cannot connect to masters in neither UDP nor TCP
 *			- #IOTC_ER_TCP_CONNECT_TO_SERVER_FAILED Cannot connect to IOTC servers in TCP
 *			- #IOTC_ER_CAN_NOT_FIND_DEVICE IOTC servers cannot locate the specified device
 *			- #IOTC_ER_NO_PERMISSION The specified device does not support TCP relay
 *			- #IOTC_ER_SERVER_NOT_RESPONSE IOTC servers have no response
 *			- #IOTC_ER_FAIL_GET_LOCAL_IP Fails to get the client's local IP address
 *			- #IOTC_ER_FAIL_SETUP_RELAY Fails to connect the device via relay mode
 *			- #IOTC_ER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTC_ER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTC_ER_FAIL_SOCKET_BIND Fails to bind sockets
 *			- #IOTC_ER_NOT_SUPPORT_RELAY Not support relay connection by IOTC servers
 *			- #IOTC_ER_NO_SERVER_LIST No IOTC server information while client connect
 *			- #IOTC_ER_DEVICE_MULTI_LOGIN The connecting device duplicated loggin and may unconnectable 
 *
 * \attention This process is a block process.
 *
 */
P2PAPI_API int  UBIC_Connect_ByUID(const char *cszUID);

/**
* \brief Used by a client to get a free session ID.
*
* \details This function is for a client to get a free session ID used for a parameter of
*          IOTC_Connect_ByUID_Parallel().
*
* \return IOTC session ID if return value >= 0
* \return Error code if return value < 0
*			- #IOTC_ER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in client side
*
*/
P2PAPI_API int  UBIC_Get_SessionID(void);

/**
 * \brief Used by a client to connect a device and bind to a specified session ID.
 *
 * \details This function is for a client to connect a device by specifying
 *			the UID of that device, and bind to a free session ID from IOTC_Get_SessionID(). 
 * 			If connection is established with the help of IOTC servers, 
 *			the #IOTC_ER_NoERROR will be returned in this function and then device and 
 *			client can communicate for the other later by using this IOTC session ID. 
 *			If this function is called by multiple threads, the connections will be 
 *			processed concurrently. 
 *
 * \param cszUID [in] The UID of a device that client wants to connect
 * \param SID [in] The Session ID got from IOTC_Get_SessionID() the connection should bind to.
 *
 * \return IOTC session ID if return value >= 0 and equal to the input parameter SID.
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_UNLICENSE The specified UID of that device is not licensed or expired
 *			- #IOTC_ER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in client side
 *			- #IOTC_ER_DEVICE_NOT_LISTENING The device is not listening for connection now
 *			- #IOTC_ER_FAIL_CONNECT_SEARCH The client stop connecting to the device
 *			- #IOTC_ER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTC_ER_FAIL_CREATE_THREAD Fails to create threads
 *			- #IOTC_ER_TCP_TRAVEL_FAILED Cannot connect to masters in neither UDP nor TCP
 *			- #IOTC_ER_TCP_CONNECT_TO_SERVER_FAILED Cannot connect to IOTC servers in TCP
 *			- #IOTC_ER_CAN_NOT_FIND_DEVICE IOTC servers cannot locate the specified device
 *			- #IOTC_ER_NO_PERMISSION The specified device does not support TCP relay
 *			- #IOTC_ER_SERVER_NOT_RESPONSE IOTC servers have no response
 *			- #IOTC_ER_FAIL_GET_LOCAL_IP Fails to get the client's local IP address
 *			- #IOTC_ER_FAIL_SETUP_RELAY Fails to connect the device via relay mode
 *			- #IOTC_ER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTC_ER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTC_ER_FAIL_SOCKET_BIND Fails to bind sockets
 *			- #IOTC_ER_NOT_SUPPORT_RELAY Not support relay connection by IOTC servers
 *			- #IOTC_ER_NO_SERVER_LIST No IOTC server information while client connect
 *			- #IOTC_ER_DEVICE_MULTI_LOGIN The connecting device duplicated loggin and may unconnectable 
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *
 */
P2PAPI_API int  UBIC_Connect_ByUID_Parallel(const char *cszUID, int SID);


/**
 * \brief Used by a client to connect a device
 *
 * \details This function is for a client to connect a device by specifying
 *			the UID of that device. If connection is established with the
 *			help of IOTC servers, the IOTC session ID will be returned in this
 *			function and then device and client can communicate for the other
 *			later by using this IOTC session ID.
 *			<br> <br>
 *			The different between this function and IOTC_Connect_ByUID() is
 *			that this function supports IOTC session established in secure mode.
 *			Also, by specifying IOTC_ARBITRARY_MODE as IOTC session mode, this
 *			function can let clients establish IOTC session in either non-secure
 *			mode and secure	mode according to devices' secure settings.
 *
 * \param cszUID [in] The UID of a device that client wants to connect
 * \param cszAESKey [in] The AES key for certification. Specify it as NULL will make
 *			IOTC module use predefined AES key.
 * \param nSessionMode [in] The IOTC session mode that a client want to connect.
 *			Please refer to #IOTCSessionMode for more detail
 *
 * \return IOTC session ID if return value >= 0
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_CONNECT_IS_CALLING The client is already connecting to a device
 *			- #IOTC_ER_UNLICENSE The specified UID of that device is not licensed or expired
 *			- #IOTC_ER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in client side
 *			- #IOTC_ER_DEVICE_NOT_LISTENING The device is not listening for connection now
 *			- #IOTC_ER_FAIL_CONNECT_SEARCH The client stop connecting to the device
 *			- #IOTC_ER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTC_ER_FAIL_CREATE_THREAD Fails to create threads
 *			- #IOTC_ER_TCP_TRAVEL_FAILED Cannot connect to masters in neither UDP nor TCP
 *			- #IOTC_ER_TCP_CONNECT_TO_SERVER_FAILED Cannot connect to IOTC servers in TCP
 *			- #IOTC_ER_CAN_NOT_FIND_DEVICE IOTC servers cannot locate the specified device
 *			- #IOTC_ER_NO_PERMISSION The specified device does not support TCP relay
 *			- #IOTC_ER_SERVER_NOT_RESPONSE IOTC servers have no response
 *			- #IOTC_ER_FAIL_GET_LOCAL_IP Fails to get the client's local IP address
 *			- #IOTC_ER_FAIL_SETUP_RELAY Fails to connect the device via relay mode
 *			- #IOTC_ER_INVALID_MODE The IOTC session mode is not valid. Please refer to #IOTCSessionMode
 *			- #IOTC_ER_DEVICE_NOT_SECURE_MODE A client wants to connect to a device in
 *					secure mode while that device supports non-secure mode only.
 *			- #IOTC_ER_DEVICE_SECURE_MODE A client wants to connect to a device
 *					in non-secure mode while that device supports secure mode only.
 *			- #IOTC_ER_AES_CERTIFY_FAIL The AES certification fails
 *			- #IOTC_ER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTC_ER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTC_ER_FAIL_SOCKET_BIND Fails to bind sockets
 *			- #IOTC_ER_NOT_SUPPORT_RELAY Not support relay connection by IOTC servers
 *			- #IOTC_ER_NO_SERVER_LIST No IOTC server information while client connect
 *			- #IOTC_ER_DEVICE_MULTI_LOGIN The connecting device duplicated loggin and may unconnectable 
 *
 * \attention (1) This process is a block process.<br><br>
 *				(2) The AES key shall be matched between a device and a client in
 *				order to establish connection successfully.<br><br>
 *				(3) This function is available on Win32, Linux, Android, iOS and ARC platforms.
 *
 */
P2PAPI_API int  UBIC_Connect_ByUID2(const char *cszUID, const char *cszAESKey, IOTCSessionMode nSessionMode);

/**
 * \brief Used by a client to stop connecting a device
 *
 * \details This function is for a client to stop connecting a device. Since
 *			IOTC_Connect_ByUID(), IOTC_Connect_ByUID2() are all block processes, that means
 *			the client will have to wait for the return of these functions before
 *			executing sequential instructions. In some cases, users may want
 *			the client to stop connecting immediately by this function in
 *			another thread before the return of connection process.
 *
 * \attention Only use to stop IOTC_Connect_ByUID() and 2, NOT use to stop IOTC_Connect_ByUID_Parallel().
 */
P2PAPI_API void UBIC_Connect_Stop(void);

/**
 * \brief Used by a client to stop a specific session connecting a device
 *
 * \details This function is for a client to stop connecting a device. Since
 *			IOTC_Connect_ByUID_Parallel() is a block processes, that means
 *			the client will have to wait for the return of these functions before
 *			executing sequential instructions. In some cases, users may want
 *			the client to stop connecting immediately by this function in
 *			another thread before the return of connection process.
 *
 * \param SID [in] The Session ID of a connection which will be stop.
 *	
 * \return #IOTC_ER_NoERROR
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 */
P2PAPI_API int UBIC_Connect_Stop_BySID(int SID);

/**
 * \brief Used by a device or a client to read data from the other
 *
 * \details A device or a client uses this function to read data through
 *			a specific IOTC channel in a IOTC session. <br>
 *			The difference between this function and IOTC_Session_Read() is
 *			this function provides packet lost information. Users may use
 *			this to check how many packets, if any, have been lost since the last
 *			time reading from this session.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to read data
 * \param abBuf [out] The array of byte buffer to receive read result
 * \param nMaxBufSize [in] The maximum length of the byte buffer
 * \param nTimeout [in] The timeout for this function in unit of millisecond, give 0 means return immediately
 * \param pnPacketSN [out] The serial number of the packet that is read successfully
 *							this time. Could be NULL.
 * \param pbFlagLost [out] A boolean value to indicate if there are some packets
 *							lost between this time and previous successful read.
 *							Could be NULL.
 * \param nIOTCChannelID [in] The IOTC channel ID in this IOTC session to read data
 *
 * \return The actual length of read result stored in abBuf if read successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_CH_NOT_ON The IOTC channel of specified channel ID is not turned on
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTC_ER_TIMEOUT The timeout specified by nTimeout expires before
 *				read process is performed completely
 *
 * \attention The IOTC channel of ID 0 is enabled by default when a IOTC session is established.
 *				That means nIOTCChannelID can be specified as 0 if only one IOTC channel
 *				is needed by the user. If more IOTC channels are required, users
 *				should use IOTC_Session_Get_Free_Channel() and UBIC_Session_Channel_ON()
 *				to get more IOTC channel IDs and then specifying those IOTC channel IDs
 *				in this function according to the purpose defined by the user.
 */
P2PAPI_API int  UBIC_Session_Read_Check_Lost(int nIOTCSessionID, char *abBuf, int nMaxBufSize,unsigned long nTimeout, unsigned short *pnPacketSN,char *pbFlagLost, unsigned char nIOTCChannelID);
#endif // defined(IOTC_Win32) || defined(IOTC_ARC_HOPE312) || defined(IOTC_Linux)


/**
 * \brief Used by a device or a client to check the IOTC session info
 *
 * \details A device or a client may use this function to check if the IOTC session
 *			is still alive as well as getting the IOTC session info.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to be checked
 * \param psSessionInfo [out] The session info of specified IOTC session
 *
 * \return #IOTC_ER_NoERROR if getting the IOTC session info successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 */
P2PAPI_API int  UBIC_Session_Check(int nIOTCSessionID, struct st_SInfo *psSessionInfo);

/**
 * \brief Used by a device or a client to get the session status
 *
 * \details This function gets the session status between device and client. <br>
 *			The difference of this function and IOTC_Session_Check() is
 *			this function will set callback function inside IOTC module and
 *			that callback function will be invoked whenever the session status
 *			between device and client disconnected, for example, IOTC
 *			alive timeout or one side call IOTC_Session_Close() to close
 *			this session.
 
 * \param nIOTCSessionID [in] The session ID of the IOTC session to check status
 * \param pfxSessionStatusFn [in] The function pointer to getting session status function
 *
 * \return #IOTC_ER_NoERROR if getting the IOTC session info successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 */
P2PAPI_API int UBIC_Session_Check_ByCallBackFn(int nIOTCSessionID, sessionStatusCB pfxSessionStatusFn);

/**
 * \brief Used by a device or a client to read data from the other
 *
 * \details A device or a client uses this function to read data through
 *			a specific IOTC channel in a IOTC session.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to read data
 * \param abBuf [out] The array of byte buffer to receive read result
 * \param nMaxBufSize [in] The maximum length of the byte buffer
 * \param nTimeout [in] The timeout for this function in unit of millisecond, give 0 means return immediately
 * \param nIOTCChannelID [in] The IOTC channel ID in this IOTC session to read data
 *
 * \return The actual length of read result stored in abBuf if read successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_CH_NOT_ON The IOTC channel of specified channel ID is not turned on
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTC_ER_TIMEOUT The timeout specified by nTimeout expires before
 *				read process is performed completely
 *
 * \attention (1) The IOTC channel of ID 0 is enabled by default when a IOTC session is established.
 *				That means nIOTCChannelID can be specified as 0 if only one IOTC channel
 *				is needed by the user. If more IOTC channels are required, users
 *				should use IOTC_Session_Get_Free_Channel() and UBIC_Session_Channel_ON()
 *				to get more IOTC channel IDs and then specifying those IOTC channel IDs
 *				in this function according to the purpose defined by the user.<br><br>
 *				(2) If the size of abBuf, i.e. defined by nMaxBufSize, is less than
 *				the size of data to be read, then this function will only read
 *				the data up to nMaxBufSize and the remaining part will be truncated without
 *				error code returned. Therefore, it is suggested to allocate the size
 *				of abBuf as #IOTC_MAX_PACKET_SIZE for ensure complete reading.
 */
P2PAPI_API int  UBIC_Session_Read(int nIOTCSessionID, char *abBuf, int nMaxBufSize, unsigned long nTimeout, unsigned char nIOTCChannelID);


/**
 * \brief Used by a device or a client to write data to the other
 *
 * \details A device or a client uses this function to write data through
 *			a specific IOTC channel in a IOTC session.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to write data
 * \param cabBuf [in] The array of byte buffer containing the data to write.
 *			Its size cannot be larger than #IOTC_MAX_PACKET_SIZE
 * \param nBufSize [in] The length of the byte buffer. It cannot be larger than
 *			#IOTC_MAX_PACKET_SIZE
 * \param nIOTCChannelID [in] The IOTC channel ID in this IOTC session to write data
 *
 * \return The actual length of buffer to be written if write successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_CH_NOT_ON The IOTC channel of specified channel ID is not turned on
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *
 * \attention (1) The IOTC channel of ID 0 is enabled by default when a IOTC session is established.
 *				That means nIOTCChannelID can be specified as 0 if only one IOTC channel
 *				is needed by the user. If more IOTC channels are required, users
 *				should use IOTC_Session_Get_Free_Channel() and UBIC_Session_Channel_ON()
 *				to get more IOTC channel IDs and then specifying those IOTC channel IDs
 *				in this function according to the purpose defined by the user. <br><br>
 *				(2) This function will block when session is connected via TCP and socket buffer is full.
 */
P2PAPI_API int UBIC_Session_Write(int nIOTCSessionID, const char *cabBuf, int nBufSize, unsigned char nIOTCChannelID);


/**
 * \brief Used by a device or a client to close a IOTC session
 *
 * \details A device or a client uses this function to close a IOTC session
 *			specified by its session ID if this IOTC session is no longer
 *			required.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to be closed
 *
 */
P2PAPI_API void UBIC_Session_Close(int nIOTCSessionID);


/**
 * \brief Used by a device or a client to get a free IOTC channel
 *
 * \details A device or a client uses this function to get a free IOTC channel
 *			in a specified IOTC session. By default, IOTC channel of ID 0 is turned on
 *			once a IOTC session is established. If more IOTC channels are required
 *			by users, this function can always return a free IOTC channel until
 *			maximum IOTC channels are reached.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to get free IOTC channel
 *
 * \return The IOTC channel ID of a free IOTC channel if successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTC_ER_SESSION_NO_FREE_CHANNEL Already reach the maximum
 *				number of IOTC channels, no more free IOTC channel is available
 *
 * \attention (1) The IOTC channel returned by this function is already turned on.<br><br>
 *				(2) The IOTC channel is only turned on in the local site
 *				calling	this function. That means, the remote site shall use
 *				UBIC_Session_Channel_ON() to turn on the same IOTC channel at its
 *				side before communication.
 */
P2PAPI_API int UBIC_Session_Get_Free_Channel(int nIOTCSessionID);


/**
 * \brief Used by a device or a client to turn on a IOTC channel
 *
 * \details A device or a client uses this function to turn on a IOTC channel
 *			before sending or receiving data through this IOTC channel.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session containing the
 *			IOTC channel to be turned on
 * \param nIOTCChannelID [in] The channel ID of the IOTC channel to be turned on
 *
 * \return IOTC_ER_NoERROR if turning on the IOTC channel successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTC_ER_CH_NOT_ON The specified IOTC channel ID is not valid
 *
 * \attention The IOTC channel is only turned on in the local site calling
 *				this function. That means, the remote site shall also use
 *				UBIC_Session_Channel_ON() to turn on the same IOTC channel
 *				at its side	before communication.
 */
P2PAPI_API int UBIC_Session_Channel_ON(int nIOTCSessionID, unsigned char nIOTCChannelID);


/**
 * \brief Used by a device or a client to turn off a IOTC channel
 *
 * \details A device or a client uses this function to turn off a IOTC channel
 *			when this IOTC channel is no longer needed for communication.	
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session containing the
 *			IOTC channel to be turned off
 * \param nIOTCChannelID [in] The channel ID of the IOTC channel to be turned off
 *
 * \return IOTC_ER_NoERROR if turning off the IOTC channel successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTC_ER_CH_NOT_ON The specified IOTC channel ID is not valid
 *
 * \attention (1) IOTC Channel 0 cannot be turned off because it is a default channel.<br><br>
 *				(2) Turn off a IOTC channel will also make the data remaining
 *				in receiving queue of this channel be deleted.
 */
P2PAPI_API int UBIC_Session_Channel_OFF(int nIOTCSessionID, unsigned char nIOTCChannelID);


/**
 * \brief Used by search devices in LAN.
 *
 * \details When clients and devices are stay in a LAN environment, client can call this function
 *			to discovery devices and connect it directly.
 *
 * \param psLanSearchInfo [in] The array of struct st_LanSearchInfo to store search result
 *
 * \param nArrayLen [in] The size of the psLanSearchInfo array
 *
 * \param nWaitTimeMs [in] The timeout in milliseconds before discovery process end.
 *
 * \return IOTC_ER_NoERROR if search devices in LAN successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_INVALID_ARG The arguments passed in to this function is invalid. 
 *			- #IOTC_ER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTC_ER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTC_ER_FAIL_SOCKET_BIND Fails to bind sockets 
 */
P2PAPI_API int UBIC_Lan_Search(struct st_LanSearchInfo *psLanSearchInfo, int nArrayLen, int nWaitTimeMs);

/**
 * \brief Set path of log file
 *
 * \details Set the absolute path of log file
 *
 * \param path [in] The path of log file, NULL = disable Log
 *
 * \param nMaxSize [in] The maximum size of log file in Bytes, 0 = unlimit
 *
 */
P2PAPI_API	void UBIC_Set_Log_Path(char *path, int nMaxSize);
/**
 * \brief Set partial encode On/Off
 *
 * \details Set partial encode On/Off
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to be encrypted.
 * 
 * \param bPartialEncryption [in] 1: Enable partial encode, 0: Disable partial encode
 *
 * \return Error code if return value < 0
 *			- #IOTC_ER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTC_ER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTC_ER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTC_ER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_SESSION_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTC_ER_NOT_SUPPORT_PE The remote device don't support partial encryption
 *
 */
P2PAPI_API	int UBIC_Set_Partial_Encryption(int nIOTCSessionID, unsigned char bPartialEncryption);

/**
 * \brief Set device name.
 *
 * \details Device can let client know its name when client call IOTC_Lan_Search2().
 *          The maximum size of device name is 128 Byte. We filled in 0 at the 129th Byte.
 *
 * \param cszDeviceName  [in] This is user-defined device name. Clients will get it by calling IOTC_Lan_Search2().
 * 
 */
P2PAPI_API  void UBIC_Set_Device_Name(const char *cszDeviceName);

/**
 * \brief Used for searching devices in LAN.
 *
 * \details When client and devices are in LAN, client can search devices and their name
 *			by calling this function.
 *
 * \param psLanSearchInfo2 [in] The array of struct st_LanSearchInfo2 store the search result and Device name.
 *
 * \param nArrayLen [in] The size of psLanSearchInfo2 array
 *
 * \param nWaitTimeMs [in] Period (or timeout) of searching LAN. (milliseconds)
 *
 * \return IOTC_ER_NoERROR if search devices in LAN successfully
 * \return Error code if return value < 0
 *			- #IOTC_ER_INVALID_ARG The arguments passed in to this function is invalid. 
 *			- #IOTC_ER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTC_ER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTC_ER_FAIL_SOCKET_BIND Fails to bind sockets 
 */
//P2PAPI_API  int UBIC_Lan_Search2 (struct st_LanSearchInfo2 *psLanSearchInfo2, int nArrayLen, int nWaitTimeMs);


#ifdef IOTC_UCOSII
void *malloc(unsigned int size);
void free(void *addr);
#endif

#ifdef IOTC_ASIX8051
void IOTC_PeriodicRun();  //--call it in main loop
#endif



struct st_VPGInfo
{
    unsigned short  Vid;
    unsigned short  Pid;
    unsigned short  Gid;
    unsigned short  Rsv;
};

P2PAPI_API int UBIC_Get_Session_Net_Status(int nIOTCSessionID, struct st_SessionNetStatus *pNetStatus);

P2PAPI_API int UBIC_Session_Write_Ex(int nIOTCSessionID
    , const char *cabBuf
    , int nBufSize
    , unsigned char nIOTCChannelID
    , unsigned short RlyIdx
    , unsigned char PktType);

P2PAPI_API int UBIC_Session_Read_Ex(int nIOTCSessionID
    , char *abBuf
    , int nMaxBufSize
    , unsigned long nTimeout
    , unsigned char nIOTCChannelID
    , unsigned short *RlyIdx
    , unsigned char *PktType
    , unsigned int *PktTick);
    

P2PAPI_API int UBIC_GetDevLibVer(char *Uid);
P2PAPI_API int UBIC_GetVPGByUID(char *Uid, struct st_VPGInfo *pVPGInfo);
P2PAPI_API int UBIC_Get_Session_RlyIdx(int Sid);
P2PAPI_API int UBIC_Get_Session_CorD(int Sid);


#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _IOTCAPIs_UBIA_ADDON_H_ */
