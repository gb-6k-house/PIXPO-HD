/*! \file IOTCAPIs.h
This file describes all the APIs of the IOTC module in IOTC platform.
IOTC module is a kind of data communication modules to provide basic data
transfer among devices and clients.

\copyright Copyright (c) 2013 by Ubianet Co., Ltd. All Rights Reserved.
 
Revision Table

Version     | Name             |Date           |Description
------------|------------------|---------------|-------------------
*/

#ifndef _IOTCAPIs_H_
#define _IOTCAPIs_H_

/* ============================================================================
 * Platform Dependant Macro Definition
 * ============================================================================
 */
#include "platform_Config.h"

#ifdef IOTCWin32
/** @cond */
#ifdef IOTCSTATIC_LIB
#define P2PAPI_API  
#elif defined P2PAPI_EXPORTS
#define P2PAPI_API __declspec(dllexport)
#else
#define P2PAPI_API __declspec(dllimport)
#endif // #ifdef P2PAPI_EXPORTS

/** @endcond */
/** The default max number of IOTC sessions in IOTC module.
 * It is platform dependent and refer to source code for more detail. */
#define MAX_DEFAULT_IOTC_Session_NUMBER				128
#endif // #ifdef IOTCWin32

#ifdef IOTCARC_HOPE312
#define P2PAPI_API
#define MAX_DEFAULT_IOTC_Session_NUMBER				16
#define __stdcall 
#endif // #ifdef IOTCARC_HOPE312

#ifdef IOTC_Linux
#define P2PAPI_API
#define MAX_DEFAULT_IOTC_Session_NUMBER				128
#define __stdcall 
#endif // #ifdef IOTC_Linux

#ifdef IOTCASIX8051
#define P2PAPI_API
#define MAX_DEFAULT_IOTC_Session_NUMBER				4
#define __stdcall 
#endif // #ifdef IOTC_Linux

#ifdef IOTCUCOSII
#define P2PAPI_API
#define MAX_DEFAULT_IOTC_Session_NUMBER				8
#define __stdcall 
extern u32  TutkLoginTaskPri;
extern u32  TutkRoutineTaskPri;
#endif // #ifdef IOTCUCOSII

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* ============================================================================
 * Generic Macro Definition
 * ============================================================================
 */
/** The maximum size, in byte, of the buffer used in IOTC_Session_Read(),
 * IOTC_Session_Write() and IOTC_Session_Read_Check_Lost(). */
#define IOTCMAX_PACKET_SIZE						1400

/** The maximum number of IOTC channels for each IOTC session */
#define MAX_CHANNEL_NUMBER							32

/** The timeout, in unit of second, for keeping an IOTC session alive since
 * the last time remote site has response */
#define IOTC_Session_ALIVE_TIMEOUT					15

/* ============================================================================
 * Error Code Declaration
 * ============================================================================
 */
/** The function is performed successfully. */
#define	IOTCER_NoERROR								0

/** IOTC servers have no response, probably caused by many types of Internet connection issues. */
// See [Troubleshooting](..\Troubleshooting\index.htm#IOTCER_SERVER_NOT_RESPONSE)
#define	IOTCER_SERVER_NOT_RESPONSE					-1

/** IOTC masters cannot be resolved their domain name, probably caused
 * by network connection or DNS setting issues. */
#define	IOTCER_FAIL_RESOLVE_HOSTNAME				-2

/** IOTC module is already initialized. It is not necessary to re-initialize. */
#define IOTCER_ALREADY_INITIALIZED                 -3

/** IOTC module fails to create Mutexs when doing initialization. Please
 * check if OS has sufficient Mutexs for IOTC platform. */
#define IOTCER_FAIL_CREATE_MUTEX                   -4

/** IOTC module fails to create threads. Please check if OS has ability
 * to create threads for IOTC module. */
#define IOTCER_FAIL_CREATE_THREAD                  -5

/** IOTC module fails to create sockets. Please check if OS supports socket service */
#define IOTCER_FAIL_CREATE_SOCKET                  -6

/** IOTC module fails to set up socket options. */
#define IOTCER_FAIL_SOCKET_OPT                     -7

/** IOTC module fails to bind sockets */
#define IOTCER_FAIL_SOCKET_BIND                    -8

/** The specified UID is not licensed or expired. */
#define IOTCER_UNLICENSE                           -10

/** The device is already under login process currently
 * so it is prohibited to invoke login again at this moment. */
#define IOTCER_LOGIN_ALREADY_CALLED                -11

/** IOTC module is not initialized yet. Please use IOTC_Initialize() or
 * IOTC_Initialize2() for initialization. */
#define IOTCER_NOT_INITIALIZED                     -12

/** The specified timeout has expired during the execution of some IOTC
 * module service. For most cases, it is caused by slow response of remote
 * site or network connection issues */
#define IOTCER_TIMEOUT                             -13

/** The specified IOTC session ID is not valid */
#define IOTCER_INVALID_SID                         -14

/** The specified device's name is unknown to the IOTC servers */
#define IOTCER_UNKNOWN_DEVICE                      -15

/** IOTC module fails to get the local IP address */
#define IOTCER_FAIL_GET_LOCAL_IP                   -16

/** The device already start to listen for connections from clients. It is
 * not necessary to listen again. */
#define IOTCER_LISTEN_ALREADY_CALLED               -17

/** The number of IOTC sessions has reached maximum.
 * To increase the max number of IOTC sessions, please use IOTCSet_Max_Session_Number()
 * before initializing IOTC module. */
#define IOTCER_EXCEED_MAX_SESSION                  -18

/** IOTC servers cannot locate the specified device, probably caused by
 * disconnection from the device or that device does not login yet. */
#define IOTCER_CAN_NOT_FIND_DEVICE                 -19

/** The client is already connecting to a device currently
 * so it is prohibited to invoke connection again at this moment. */
#define IOTCER_CONNECT_IS_CALLING                  -20

/** The remote site already closes this IOTC session.
 * Please call IOTC_Session_Close() to release IOTC session resource in locate site. */
#define IOTCER_SESSION_CLOSE_BY_REMOTE             -22

/** This IOTC session is disconnected because remote site has no any response
 * after a specified timeout expires, i.e. #IOTC_Session_ALIVE_TIMEOUT */
#define IOTCER_REMOTE_TIMEOUT_DISCONNECT           -23

/** The client fails to connect to a device because the device is not listening for connections. */
#define IOTCER_DEVICE_NOT_LISTENING                -24

/** The IOTC channel of specified channel ID is not turned on before transferring data. */
#define IOTCER_CH_NOT_ON                           -26

/** A client stops connecting to a device by calling IOTCConnect_Stop() */
#define IOTCER_FAIL_CONNECT_SEARCH                 -27

/** Too few masters are specified when initializing IOTC module.
 * Two masters are required for initialization at minimum. */
#define IOTCER_MASTER_TOO_FEW                      -28

/** A client fails to pass certification of a device due to incorrect key. */
#define IOTCER_AES_CERTIFY_FAIL                    -29

/** The number of IOTC channels for a IOTC session has reached maximum, say, #MAX_CHANNEL_NUMBER */
#define IOTCER_SESSION_NO_FREE_CHANNEL             -31

/** Cannot connect to masters neither UDP mode nor TCP mode by IP or host name ways */
#define IOTCER_TCP_TRAVEL_FAILED					-32

/** Cannot connect to IOTC servers in TCP */
#define IOTCER_TCP_CONNECT_TO_SERVER_FAILED        -33

/** A client wants to connect to a device in non-secure mode while that device
 * supports secure mode only. */
#define IOTCER_CLIENT_NOT_SECURE_MODE              -34

/** A client wants to connect to a device in secure mode while that device does
 * not support secure mode. */
#define IOTCER_CLIENT_SECURE_MODE					-35

/** A device does not support connection in secure mode */
#define IOTCER_DEVICE_NOT_SECURE_MODE              -36

/** A device does not support connection in non-secure mode */
#define IOTCER_DEVICE_SECURE_MODE					-37

/** The IOTC session mode specified in IOTCListen2(), IOTCConnect_ByUID2()
 * is not valid. Please see #IOTCSessionMode for possible modes. */
#define IOTCER_INVALID_MODE                        -38

/** A device stops listening for connections from clients. */
#define IOTCER_EXIT_LISTEN                         -39

/** The specified device does not support advance function
 *(TCP relay and P2PTunnel module) */
#define IOTCER_NO_PERMISSION                  		-40

/** Network is unreachable, please check the network settings */
#define	IOTCER_NETWORK_UNREACHABLE     			-41

/** A client fails to connect to a device via relay mode */
#define IOTCER_FAIL_SETUP_RELAY					-42

/** A client fails to use UDP relay mode to connect to a device
 * because UDP relay mode is not supported for that device by IOTC servers */
#define IOTCER_NOT_SUPPORT_RELAY					-43

/** No IOTC server information while device login or client connect
 * because no IOTC server is running or not add IOTC server list */
#define IOTCER_NO_SERVER_LIST						-44

/** The connecting device duplicated loggin and may unconnectable. */
#define IOTCER_DEVICE_MULTI_LOGIN					-45

/** The arguments passed to a function is invalid. */
#define IOTCER_INVALID_ARG                         -46

/** The remote device not support partial encoding */
#define IOTCER_NOT_SUPPORT_PE			-47


/* ============================================================================
 * Enumeration Declaration
 * ============================================================================
 */

/**
 * \details IOTC session mode, used in IOTCListen2(), IOTCConnect_ByUID2()
 *			to specify what kinds of IOTC session
 *			that devices will listen or clients will connect.
 */
typedef enum
{
	/// IOTC session will be established in non-secure mode. <br>
	/// - For devices, the behavior is the same as IOTCListen(). <br>
	/// - For clients, the behavior is the same as IOTCConnect_ByUID()
	IOTCNON_SECURE_MODE = 0,

	/// IOTC session will be established in secure mode. <br>
	/// - For devices, it means only secure connection will be accepted. <br>
	/// - For clients, it means only secure connection will be performed
	IOTCSECURE_MODE = 1,

	/// IOTC session will be established in either non-secure or secure mode,
	/// depending on remote site's request. Can use IOTC_Session_Check()
	/// to check what mode is actually used. <br>
	/// - For devices, it means both non-secure or secure modes are accepted. <br>
	/// - For clients, it means either non-secure or secure modes can be performed.
	IOTCARBITRARY_MODE = 2
} IOTCSessionMode;


/* ============================================================================
 * Structure Definition
 * ============================================================================
 */

/**
 * \details IOTC session info, containing all the information when a IOTC session is
 *  established between a device and a client. Users can use IOTC_Session_Check()
 *  to get IOTC session information.
 */
struct st_SInfo
{
	unsigned char Mode; //!< 0: P2P mode, 1: Relay mode, 2: LAN mode
	char CorD; //!< 0: As a Client, 1: As a Device
	char UID[21]; //!< The UID of the device
	char RemoteIP[17]; //!< The IP address of remote site used during this IOTC session
	unsigned short RemotePort; //!< The port number of remote site used during this IOTC session
	unsigned long TX_Packetcount; //!< The total packets sent from the device and the client during this IOTC session
	unsigned long RX_Packetcount; //!< The total packets received in the device and the client during this IOTC session
	unsigned long IOTCVersion; //!< The IOTC version 
	unsigned short VID; //!< The Vendor ID, part of VPG mechanism
	unsigned short PID; //!< The Product ID, part of VPG mechanism
	unsigned short GID; //!< The Group ID, part of VPG mechanism
	unsigned char NatType; //!< The remote NAT type
	unsigned char isSecure; //!< 0: The IOTC session is in non-secure mode, 1: The IOTC session is in secure mode
};

/**
 * \details Device serch info, containing all the information
 * when client searches devices in LAN. 
 */
struct st_LanSearchInfo
{
	char UID[21]; //!< The UID of discoveried device
	char IP[16]; //!< The IP address of discoveried device
	unsigned short port; //!< The port number of discoveried device used for IOTC session connection
	char Reserved; //!< Reserved, no use
};


struct st_SessionNetStatus
{
    int             NetDelay;
    int             NetLostPecent;
    unsigned char   NetType;
    unsigned char   Rsv[7];
};



/* ============================================================================
 * Type Definition
 * ============================================================================
 */

/**
 * \details The prototype of getting login info function, used by a device
 *			to be notified if it is still kept login with IOTC servers or is
 *			disconnected with IOTC servers.
 *
 * \param nLoginInfo [out] The login info with meanings of following bits
 *			- bit 0: the device is ready for connection by client from LAN if this bit is 1
 *			- bit 1: the device is ready for connection by client from Internet if this bit is 1 
 *			- bit 2: if this bit is 1, it means the device has received login
 *						response from IOTC servers since IOTCGet_Login_Info()
 *						is called last time.
 *
 */
typedef void (__stdcall *loginInfoCB)(unsigned long nLoginInfo);

/**
 * \details The prototype of getting session status function, used by a device
 *			or client to be notified if session is disconnected.
 *
 * \param nIOTCSessionID [out] The session ID of the session being disconnected
 * \param nErrorCode [out]
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *
 */
typedef void (__stdcall *sessionStatusCB)(int nIOTCSessionID, int nErrorCode);

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
P2PAPI_API void IOTCGet_Version(unsigned long *pnVersion);


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
 *				default max number of IOTC sessions, i.e. MAX_DEFAULT_IOTC_Session_NUMBER.
 *				However, if users really wants to change it, this function
 *				shall be called before IOTC platform is initialized.<br><br>
 *				(2) The maximum IOTC session number is platform dependent.
 *				See the definition of MAX_DEFAULT_IOTC_Session_NUMBER for each
 *				platform.
 */
P2PAPI_API void IOTCSet_Max_Session_Number(unsigned long nMaxSessionNum);


/**
 * \brief Initialize IOTC module
 *
 * \details This function is used by devices or clients to initialize IOTC
 *			module and shall be called before any IOTC module related
 *			function is invoked except for IOTCSet_Max_Session_Number().
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
 * \return #IOTCER_NoERROR if initializing successfully
 * \return Error code if return value < 0
 *			- #IOTCER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTCER_ALREADY_INITIALIZED IOTC module is already initialized
 *			- #IOTCER_MASTER_TOO_FEW Two masters are required as parameters at minimum
 *			- #IOTCER_FAIL_CREATE_MUTEX Fails to create Mutexs
 *			- #IOTCER_FAIL_CREATE_THREAD Fails to create threads
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
P2PAPI_API int IOTC_Initialize(unsigned short nUDPPort, const char* cszP2PHostNamePrimary,
								const char* cszP2PHostNameSecondary, const char* cszP2PHostNameThird,
								const char* cszP2PHostNameFourth);


/**
 * \brief Initialize IOTC module
 *
 * \details This function is used by devices or clients to initialize IOTC
 *			module and shall be called before	any IOTC module related
 *			function is invoked except for IOTCSet_Max_Session_Number().
 *			<br>
 *			The different between this function and IOTC_Initialize() is this
 *			function uses following steps to connect masters (1) IP addresses
 *			of master (2) if fails to connect in step 1, resolve predefined
 *			domain name of masters (3) try to connect again with the resolved
 *			IP address of step 2 if IP is resolved successfully.
 *
 * \param nUDPPort [in] Specify a UDP port. Random UDP port is used if it is specified as 0.
 *
 * \return #IOTCER_NoERROR if initializing successfully
 * \return Error code if return value < 0
 *			- #IOTCER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTCER_ALREADY_INITIALIZED IOTC module is already initialized
 *			- #IOTCER_FAIL_CREATE_MUTEX Fails to create Mutexs
 *			- #IOTCER_FAIL_CREATE_THREAD Fails to create threads
 *
 * \see IOTC_Initialize(), IOTC_DeInitialize()
 *
 * \attention This function is the key entry to whole IOTC platform, including
 *				RDT module and AV module. That means, if you want to use
 *				RDT module, users shall still use this function to initialize IOTC
 *				module before calling RDT_Initialize().
 */
P2PAPI_API int IOTC_Initialize2(unsigned short nUDPPort);


/**
 * \brief Deinitialize IOTC module
 *
 * \details This function will deinitialize IOTC module.
 *
 * \return #IOTCER_NoERROR if deinitialize successfully
 * \return Error code if return value < 0
 *			- #IOTCER_NOT_INITIALIZED the IOTC module is not initialized yet.
 *
 * \see IOTC_Initialize(), IOTC_Initialize2()
 *
 * \attention IOTC_DeInitialize() will automatically close all IOTC sessions
 *				in local site while the remote site will find sessions have
 *				been closed after certain period of time. Therefore, it is
 *				suggested to close all sessions before invoking this function
 *				to ensure the remote site and real-time session status.
 */
P2PAPI_API int IOTC_DeInitialize(void);


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
 * \return #IOTCER_NoERROR if device had obtained server list and sent login packets successfully
 * \return Error code if return value < 0
 *			- #IOTCER_UNLICENSE The UID is not licensed or expired
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_LOGIN_ALREADY_CALLED The device is already under login process currently
 *			- #IOTCER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTCER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTCER_FAIL_SOCKET_BIND Fails to bind sockets
 *			- #IOTCER_FAIL_CREATE_THREAD Fails to create threads
 *			- #IOTCER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTCER_TCP_TRAVEL_FAILED Cannot connect to masters in neither UDP nor TCP
 *			- #IOTCER_TCP_CONNECT_TO_SERVER_FAILED Cannot connect to IOTC servers in TCP
 *			- #IOTCER_NO_PERMISSION The device does not support TCP relay
 *			- #IOTCER_SERVER_NOT_RESPONSE IOTC servers have no response
 *			- #IOTCER_FAIL_GET_LOCAL_IP Fails to get the device's local IP address
 *			- #IOTCER_NETWORK_UNREACHABLE Network is unreachable
 *			- #IOTCER_NO_SERVER_LIST No IOTC server information while device login 
 *
 * \attention (1) This function is a block process. That means this function will return until
 *				the device can login into IOTC servers successfully or some error happens
 *				during the process. It is suggested to use another thread to perform
 *				login process so that sequential instructions will not blocked. <br><br>
 *				(2) Please use IOTCGet_Login_Info() to check if device really logins
 * 				into server successfully.
 */
P2PAPI_API int IOTCDevice_Login(const char *cszUID, const char *cszDeviceName, const char *cszDevicePWD);


/**
 * \brief Used by a device to get the login information
 *
 * \details This function gets the login information of a device to IOTC servers.
 *
 * \param pnLoginInfo [out] The login info with meanings of following bits
 *			- bit 0: the device is ready for connection by client from LAN if this bit is 1
 *			- bit 1: the device is ready for connection by client from Internet if this bit is 1 
 *			- bit 2: if this bit is 1, it means the device has received login
 *						response from IOTC servers since IOTCGet_Login_Info()
 *						is called last time.
 *
 * \return The number of fails to login to IOTC servers.
 *
 */
P2PAPI_API int IOTCGet_Login_Info(unsigned long *pnLoginInfo);


/**
 * \brief Used by a device to get the login information
 *
 * \details This function gets the login information of a device to IOTC servers. <br>
 *			The difference of this function and IOTCGet_Login_Info() is
 *			this function will set callback function inside IOTC module and
 *			that callback function will be invoked whenever the login status
 *			of that device is updated from IOTC servers, for example, IOTC
 *			servers response login message to that device or the connection
 *			between IOTC servers and that device has been lost.
 *
 * \param pfxLoginInfoFn [in] The function pointer to getting login info function
 *
 */
P2PAPI_API void IOTCGet_Login_Info_ByCallBackFn(loginInfoCB pfxLoginInfoFn);

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
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in device side
 *			- #IOTCER_LISTEN_ALREADY_CALLED The device is already in listen process
 *			- #IOTCER_TIMEOUT No connection is established from clients before timeout expires
 *			- #IOTCER_EXIT_LISTEN The device stops listening for connections from clients.
 *
 * \attention (1) This function is a block process, waiting for following two
 *				conditions happens before executing	sequential instructions
 *				(a) any connection from clients is established (b) timeout expires.<br><br>
 *				(2) nTimeout has no effect in 8051 platform.
 */
P2PAPI_API int  IOTCListen(unsigned long nTimeout);


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
P2PAPI_API void IOTCListen_Exit(void);


#if defined(IOTCWin32) || defined(IOTCARC_HOPE312) || defined(IOTC_Linux)
/**
 * \brief Used by a device to listen connections from clients
 *
 * \details This function is for a device to listen any connection from clients.
 *			If connection is established with the help of IOTC servers, the
 *			IOTC session ID will be returned in this function and then device and
 *			client can communicate for the other later by using this IOTC session ID.
 *			<br> <br>
 *			The difference between this function and IOTCListen() is that
 *			this function supports IOTC session established in secure mode. Also,
 *			by specifying IOTCARBITRARY_MODE as IOTC session mode, this function can
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
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in device side
 *			- #IOTCER_LISTEN_ALREADY_CALLED The device is already in listen process
 *			- #IOTCER_TIMEOUT No connection is established from clients before timeout expires
 *			- #IOTCER_EXIT_LISTEN The device stops listening for connections from clients.
 *			- #IOTCER_INVALID_MODE The IOTC session mode is not valid. Please refer to #IOTCSessionMode
 *			- #IOTCER_CLIENT_NOT_SECURE_MODE A client wants to connect to a device in
 *					non-secure mode while that device supports secure mode only.
 *			- #IOTCER_CLIENT_SECURE_MODE A client wants to connect to a device
 *					in secure mode while that device does not support secure mode.
 *			- #IOTCER_AES_CERTIFY_FAIL The AES certification fails
 *
 * \attention (1) This function is available on Win32, Linux, Android, iOS and ARC platforms.<br><br>
 *				(2) The AES key shall be matched between a device and a client 
 *				in order to establish connection successfully.
 */
P2PAPI_API int  IOTCListen2(unsigned long nTimeout, const char *cszAESKey, IOTCSessionMode nSessionMode);


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
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_CONNECT_IS_CALLING The client is already connecting to a device
 *			- #IOTCER_UNLICENSE The specified UID of that device is not licensed or expired
 *			- #IOTCER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in client side
 *			- #IOTCER_DEVICE_NOT_LISTENING The device is not listening for connection now
 *			- #IOTCER_FAIL_CONNECT_SEARCH The client stop connecting to the device
 *			- #IOTCER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTCER_FAIL_CREATE_THREAD Fails to create threads
 *			- #IOTCER_TCP_TRAVEL_FAILED Cannot connect to masters in neither UDP nor TCP
 *			- #IOTCER_TCP_CONNECT_TO_SERVER_FAILED Cannot connect to IOTC servers in TCP
 *			- #IOTCER_CAN_NOT_FIND_DEVICE IOTC servers cannot locate the specified device
 *			- #IOTCER_NO_PERMISSION The specified device does not support TCP relay
 *			- #IOTCER_SERVER_NOT_RESPONSE IOTC servers have no response
 *			- #IOTCER_FAIL_GET_LOCAL_IP Fails to get the client's local IP address
 *			- #IOTCER_FAIL_SETUP_RELAY Fails to connect the device via relay mode
 *			- #IOTCER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTCER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTCER_FAIL_SOCKET_BIND Fails to bind sockets
 *			- #IOTCER_NOT_SUPPORT_RELAY Not support relay connection by IOTC servers
 *			- #IOTCER_NO_SERVER_LIST No IOTC server information while client connect
 *			- #IOTCER_DEVICE_MULTI_LOGIN The connecting device duplicated loggin and may unconnectable 
 *
 * \attention This process is a block process.
 *
 */
P2PAPI_API int  IOTCConnect_ByUID(const char *cszUID);

/**
* \brief Used by a client to get a free session ID.
*
* \details This function is for a client to get a free session ID used for a parameter of
*          IOTC_Connect_ByUID_Parallel().
*
* \return IOTC session ID if return value >= 0
* \return Error code if return value < 0
*			- #IOTCER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in client side
*
*/
P2PAPI_API int  IOTC_Get_SessionID(void);

/**
 * \brief Used by a client to connect a device and bind to a specified session ID.
 *
 * \details This function is for a client to connect a device by specifying
 *			the UID of that device, and bind to a free session ID from IOTC_Get_SessionID(). 
 * 			If connection is established with the help of IOTC servers, 
 *			the #IOTCER_NoERROR will be returned in this function and then device and 
 *			client can communicate for the other later by using this IOTC session ID. 
 *			If this function is called by multiple threads, the connections will be 
 *			processed concurrently. 
 *
 * \param cszUID [in] The UID of a device that client wants to connect
 * \param SID [in] The Session ID got from IOTC_Get_SessionID() the connection should bind to.
 *
 * \return IOTC session ID if return value >= 0 and equal to the input parameter SID.
 * \return Error code if return value < 0
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_UNLICENSE The specified UID of that device is not licensed or expired
 *			- #IOTCER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in client side
 *			- #IOTCER_DEVICE_NOT_LISTENING The device is not listening for connection now
 *			- #IOTCER_FAIL_CONNECT_SEARCH The client stop connecting to the device
 *			- #IOTCER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTCER_FAIL_CREATE_THREAD Fails to create threads
 *			- #IOTCER_TCP_TRAVEL_FAILED Cannot connect to masters in neither UDP nor TCP
 *			- #IOTCER_TCP_CONNECT_TO_SERVER_FAILED Cannot connect to IOTC servers in TCP
 *			- #IOTCER_CAN_NOT_FIND_DEVICE IOTC servers cannot locate the specified device
 *			- #IOTCER_NO_PERMISSION The specified device does not support TCP relay
 *			- #IOTCER_SERVER_NOT_RESPONSE IOTC servers have no response
 *			- #IOTCER_FAIL_GET_LOCAL_IP Fails to get the client's local IP address
 *			- #IOTCER_FAIL_SETUP_RELAY Fails to connect the device via relay mode
 *			- #IOTCER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTCER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTCER_FAIL_SOCKET_BIND Fails to bind sockets
 *			- #IOTCER_NOT_SUPPORT_RELAY Not support relay connection by IOTC servers
 *			- #IOTCER_NO_SERVER_LIST No IOTC server information while client connect
 *			- #IOTCER_DEVICE_MULTI_LOGIN The connecting device duplicated loggin and may unconnectable 
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *
 */
P2PAPI_API int  IOTC_Connect_ByUID_Parallel(const char *cszUID, int SID);


/**
 * \brief Used by a client to connect a device
 *
 * \details This function is for a client to connect a device by specifying
 *			the UID of that device. If connection is established with the
 *			help of IOTC servers, the IOTC session ID will be returned in this
 *			function and then device and client can communicate for the other
 *			later by using this IOTC session ID.
 *			<br> <br>
 *			The different between this function and IOTCConnect_ByUID() is
 *			that this function supports IOTC session established in secure mode.
 *			Also, by specifying IOTCARBITRARY_MODE as IOTC session mode, this
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
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_CONNECT_IS_CALLING The client is already connecting to a device
 *			- #IOTCER_UNLICENSE The specified UID of that device is not licensed or expired
 *			- #IOTCER_EXCEED_MAX_SESSION The number of IOTC sessions has reached maximum in client side
 *			- #IOTCER_DEVICE_NOT_LISTENING The device is not listening for connection now
 *			- #IOTCER_FAIL_CONNECT_SEARCH The client stop connecting to the device
 *			- #IOTCER_FAIL_RESOLVE_HOSTNAME Cannot resolve masters' host name
 *			- #IOTCER_FAIL_CREATE_THREAD Fails to create threads
 *			- #IOTCER_TCP_TRAVEL_FAILED Cannot connect to masters in neither UDP nor TCP
 *			- #IOTCER_TCP_CONNECT_TO_SERVER_FAILED Cannot connect to IOTC servers in TCP
 *			- #IOTCER_CAN_NOT_FIND_DEVICE IOTC servers cannot locate the specified device
 *			- #IOTCER_NO_PERMISSION The specified device does not support TCP relay
 *			- #IOTCER_SERVER_NOT_RESPONSE IOTC servers have no response
 *			- #IOTCER_FAIL_GET_LOCAL_IP Fails to get the client's local IP address
 *			- #IOTCER_FAIL_SETUP_RELAY Fails to connect the device via relay mode
 *			- #IOTCER_INVALID_MODE The IOTC session mode is not valid. Please refer to #IOTCSessionMode
 *			- #IOTCER_DEVICE_NOT_SECURE_MODE A client wants to connect to a device in
 *					secure mode while that device supports non-secure mode only.
 *			- #IOTCER_DEVICE_SECURE_MODE A client wants to connect to a device
 *					in non-secure mode while that device supports secure mode only.
 *			- #IOTCER_AES_CERTIFY_FAIL The AES certification fails
 *			- #IOTCER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTCER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTCER_FAIL_SOCKET_BIND Fails to bind sockets
 *			- #IOTCER_NOT_SUPPORT_RELAY Not support relay connection by IOTC servers
 *			- #IOTCER_NO_SERVER_LIST No IOTC server information while client connect
 *			- #IOTCER_DEVICE_MULTI_LOGIN The connecting device duplicated loggin and may unconnectable 
 *
 * \attention (1) This process is a block process.<br><br>
 *				(2) The AES key shall be matched between a device and a client in
 *				order to establish connection successfully.<br><br>
 *				(3) This function is available on Win32, Linux, Android, iOS and ARC platforms.
 *
 */
P2PAPI_API int  IOTCConnect_ByUID2(const char *cszUID, const char *cszAESKey, IOTCSessionMode nSessionMode);

/**
 * \brief Used by a client to stop connecting a device
 *
 * \details This function is for a client to stop connecting a device. Since
 *			IOTCConnect_ByUID(), IOTCConnect_ByUID2() are all block processes, that means
 *			the client will have to wait for the return of these functions before
 *			executing sequential instructions. In some cases, users may want
 *			the client to stop connecting immediately by this function in
 *			another thread before the return of connection process.
 *
 * \attention Only use to stop IOTCConnect_ByUID() and 2, NOT use to stop IOTC_Connect_ByUID_Parallel().
 */
P2PAPI_API void IOTCConnect_Stop(void);

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
 * \return #IOTCER_NoERROR
 * \return Error code if return value < 0
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 */
P2PAPI_API int IOTC_Connect_Stop_BySID(int SID);

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
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_CH_NOT_ON The IOTC channel of specified channel ID is not turned on
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTCER_TIMEOUT The timeout specified by nTimeout expires before
 *				read process is performed completely
 *
 * \attention The IOTC channel of ID 0 is enabled by default when a IOTC session is established.
 *				That means nIOTCChannelID can be specified as 0 if only one IOTC channel
 *				is needed by the user. If more IOTC channels are required, users
 *				should use IOTC_Session_Get_Free_Channel() and IOTC_Session_Channel_ON()
 *				to get more IOTC channel IDs and then specifying those IOTC channel IDs
 *				in this function according to the purpose defined by the user.
 */
P2PAPI_API int  IOTC_Session_Read_Check_Lost(int nIOTCSessionID, char *abBuf, int nMaxBufSize,unsigned long nTimeout, unsigned short *pnPacketSN,char *pbFlagLost, unsigned char nIOTCChannelID);
#endif // defined(IOTCWin32) || defined(IOTCARC_HOPE312) || defined(IOTC_Linux)


/**
 * \brief Used by a device or a client to check the IOTC session info
 *
 * \details A device or a client may use this function to check if the IOTC session
 *			is still alive as well as getting the IOTC session info.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to be checked
 * \param psSessionInfo [out] The session info of specified IOTC session
 *
 * \return #IOTCER_NoERROR if getting the IOTC session info successfully
 * \return Error code if return value < 0
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 */
P2PAPI_API int  IOTC_Session_Check(int nIOTCSessionID, struct st_SInfo *psSessionInfo);

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
 * \return #IOTCER_NoERROR if getting the IOTC session info successfully
 * \return Error code if return value < 0
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 */
P2PAPI_API int IOTC_Session_Check_ByCallBackFn(int nIOTCSessionID, sessionStatusCB pfxSessionStatusFn);

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
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_CH_NOT_ON The IOTC channel of specified channel ID is not turned on
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTCER_TIMEOUT The timeout specified by nTimeout expires before
 *				read process is performed completely
 *
 * \attention (1) The IOTC channel of ID 0 is enabled by default when a IOTC session is established.
 *				That means nIOTCChannelID can be specified as 0 if only one IOTC channel
 *				is needed by the user. If more IOTC channels are required, users
 *				should use IOTC_Session_Get_Free_Channel() and IOTC_Session_Channel_ON()
 *				to get more IOTC channel IDs and then specifying those IOTC channel IDs
 *				in this function according to the purpose defined by the user.<br><br>
 *				(2) If the size of abBuf, i.e. defined by nMaxBufSize, is less than
 *				the size of data to be read, then this function will only read
 *				the data up to nMaxBufSize and the remaining part will be truncated without
 *				error code returned. Therefore, it is suggested to allocate the size
 *				of abBuf as #IOTCMAX_PACKET_SIZE for ensure complete reading.
 */
P2PAPI_API int  IOTC_Session_Read(int nIOTCSessionID, char *abBuf, int nMaxBufSize, unsigned long nTimeout, unsigned char nIOTCChannelID);


/**
 * \brief Used by a device or a client to write data to the other
 *
 * \details A device or a client uses this function to write data through
 *			a specific IOTC channel in a IOTC session.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to write data
 * \param cabBuf [in] The array of byte buffer containing the data to write.
 *			Its size cannot be larger than #IOTCMAX_PACKET_SIZE
 * \param nBufSize [in] The length of the byte buffer. It cannot be larger than
 *			#IOTCMAX_PACKET_SIZE
 * \param nIOTCChannelID [in] The IOTC channel ID in this IOTC session to write data
 *
 * \return The actual length of buffer to be written if write successfully. In non-blocking
 *         mode, the length with zero usually means the socket buffer is full and unable to
 *         write into.
 * \return Error code if return value < 0
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_CH_NOT_ON The IOTC channel of specified channel ID is not turned on
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *
 * \attention (1) The IOTC channel of ID 0 is enabled by default when a IOTC session is established.
 *				That means nIOTCChannelID can be specified as 0 if only one IOTC channel
 *				is needed by the user. If more IOTC channels are required, users
 *				should use IOTC_Session_Get_Free_Channel() and IOTC_Session_Channel_ON()
 *				to get more IOTC channel IDs and then specifying those IOTC channel IDs
 *				in this function according to the purpose defined by the user. <br><br>
 *				(2) This function will block when session is connected via TCP and socket buffer is full.
 */
P2PAPI_API int IOTC_Session_Write(int nIOTCSessionID, const char *cabBuf, int nBufSize, unsigned char nIOTCChannelID);


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
P2PAPI_API void IOTC_Session_Close(int nIOTCSessionID);


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
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTCER_SESSION_NO_FREE_CHANNEL Already reach the maximum
 *				number of IOTC channels, no more free IOTC channel is available
 *
 * \attention (1) The IOTC channel returned by this function is already turned on.<br><br>
 *				(2) The IOTC channel is only turned on in the local site
 *				calling	this function. That means, the remote site shall use
 *				IOTC_Session_Channel_ON() to turn on the same IOTC channel at its
 *				side before communication.
 */
P2PAPI_API int IOTC_Session_Get_Free_Channel(int nIOTCSessionID);


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
 * \return IOTCER_NoERROR if turning on the IOTC channel successfully
 * \return Error code if return value < 0
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTCER_CH_NOT_ON The specified IOTC channel ID is not valid
 *
 * \attention The IOTC channel is only turned on in the local site calling
 *				this function. That means, the remote site shall also use
 *				IOTC_Session_Channel_ON() to turn on the same IOTC channel
 *				at its side	before communication.
 */
P2PAPI_API int IOTC_Session_Channel_ON(int nIOTCSessionID, unsigned char nIOTCChannelID);


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
 * \return IOTCER_NoERROR if turning off the IOTC channel successfully
 * \return Error code if return value < 0
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTCER_CH_NOT_ON The specified IOTC channel ID is not valid
 *
 * \attention (1) IOTC Channel 0 cannot be turned off because it is a default channel.<br><br>
 *				(2) Turn off a IOTC channel will also make the data remaining
 *				in receiving queue of this channel be deleted.
 */
P2PAPI_API int IOTC_Session_Channel_OFF(int nIOTCSessionID, unsigned char nIOTCChannelID);


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
 * \return IOTCER_NoERROR if search devices in LAN successfully
 * \return Error code if return value < 0
 *			- #IOTCER_INVALID_ARG The arguments passed in to this function is invalid. 
 *			- #IOTCER_FAIL_CREATE_SOCKET Fails to create sockets
 *			- #IOTCER_FAIL_SOCKET_OPT Fails to set up socket options
 *			- #IOTCER_FAIL_SOCKET_BIND Fails to bind sockets 
 */
P2PAPI_API int IOTC_Lan_Search(struct st_LanSearchInfo *psLanSearchInfo, int nArrayLen, int nWaitTimeMs);

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
P2PAPI_API	void IOTCSet_Log_Path(char *path, int nMaxSize);

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
 *			- #IOTCER_NOT_INITIALIZED The IOTC module is not initialized yet
 *			- #IOTCER_INVALID_SID The specified IOTC session ID is not valid
 *			- #IOTCER_SESSION_CLOSE_BY_REMOTE The IOTC session of specified
 *				session ID has been closed by remote site
 *			- #IOTCER_REMOTE_TIMEOUT_DISCONNECT The timeout defined by #IOTC_Session_ALIVE_TIMEOUT
 *				expires because	remote site has no response
 *			- #IOTCER_NOT_SUPPORT_PE The remote device don't support partial encryption
 *
 */
P2PAPI_API	int IOTCSet_Partial_Encryption(int nIOTCSessionID, unsigned char bPartialEncryption);

#ifdef IOTCUCOSII
void *malloc(unsigned int size);
void free(void *addr);
#endif

#ifdef IOTCASIX8051
void IOTCPeriodicRun();  //--call it in main loop
#endif



//P2PAPI_API IOTC_Get_Session_Net_Status(int nIOTCSessionID, int nType);

P2PAPI_API int IOTCGet_Session_Net_Status(int nIOTCSessionID, struct st_SessionNetStatus *pNetStatus);
    
P2PAPI_API int IOTCGet_Session_Net_Status(int nIOTCSessionID, struct st_SessionNetStatus *pNetStatus);

P2PAPI_API int IOTC_Session_Write_Ex(int nIOTCSessionID
    , const char *cabBuf
    , int nBufSize
    , unsigned char nIOTCChannelID
    , unsigned short RlyIdx
    , unsigned char PktType);

P2PAPI_API int IOTC_Session_Read_Ex(int nIOTCSessionID
    , char *abBuf
    , int nMaxBufSize
    , unsigned long nTimeout
    , unsigned char nIOTCChannelID
    , unsigned short *RlyIdx
    , unsigned char *PktType);





#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _IOTCAPIs_H_ */
