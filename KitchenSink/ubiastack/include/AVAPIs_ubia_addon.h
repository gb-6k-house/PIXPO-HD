/*! \file AVAPIs.h
This file describes all the APIs of the AV module in IOTC platform.
AV module is a kind of data communication modules in IOTC platform to provide
fluent streaming Audio / Video data from AV servers to AV clients in
unidirectional way.

\copyright Copyright (c) 2010 by Throughtek Co., Ltd. All Rights Reserved.
 
Revision Table

Version     | Name             |Date           |Description
------------|------------------|---------------|-------------------
 */

#ifndef _AVAPIs_UBIA_ADDON_H_
#define _AVAPIs_UBIA_ADDON_H_

/* ============================================================================
 * Platform Dependant Macro Definition
 * ============================================================================
 */

#include "platform_Config.h"

#ifdef IOTC_Win32
/** @cond */
#ifdef IOTC_STATIC_LIB
#define AVAPI_API  
#elif defined AVAPI_EXPORTS
#define AVAPI_API __declspec(dllexport)
#else
#define AVAPI_API __declspec(dllimport)
#endif // #ifdef P2PAPI_EXPORTS
/** @endcond */
#endif // #ifdef IOTC_Win32

#ifdef IOTC_ARC_HOPE312
#define AVAPI_API 
#define _stdcall 
#endif // #ifdef IOTC_ARC_HOPE312

#ifdef IOTC_Linux
#define AVAPI_API
#define _stdcall  
#endif // #ifdef IOTC_Linux

#ifdef IOTC_UCOSII
#define AVAPI_API
#define _stdcall  
#endif // #ifdef IOTC_UCOSII

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

struct AVCodecConfig{
    int codecid;
    int framerate;
    int bitrate; //Kbps
    int rateMode; //CBR=1, VBR=2
    int GOP; //I Frame gap
    int quality;
};

/* ============================================================================
 * Type Definition
 * ============================================================================
 */

/**
 * \details The prototype of authentication function used for an AV server.
 *			The authentication function is set by UBIC_avAdaptiveCodingCallback() after an AV server starts. 
 *			The AV server will call back adaptive coding function periodic when an AV
 *			client connected.

 * \return true if authentication passes and false if fails.
 *
 */
typedef int (_stdcall *adaptiveCodingFn)(int nAVChannelID, unsigned int AvailableBw, unsigned int LostRate, unsigned int Delay, struct AVCodecConfig* Param);
AVAPI_API int UBIC_avAdaptiveCodingCallback(int nAVChannelID, adaptiveCodingFn pfxAdaptiveCodingFn);

/* ============================================================================
 * Type Definition
 * ============================================================================
 */

/**
 * \details The prototype of authentication function used for an AV server.
 *			The authentication function is set when an AV server starts by avServStart2(). 
 *			The AV server will call back authentication function when an AV
 *			client wants to connect with szViewAccount and szViewAccount
 * \param szViewAccount [in] The view account provided by AV clients for authentication
 * \param szViewPassword [in] The view password provided by AV clients for authentication
 *
 * \return true if authentication passes and false if fails.
 *
 */
//typedef int (_stdcall *authFn)(char *szViewAccount,char *szViewPassword);

/* ============================================================================
 * Function Declaration
 * ============================================================================
 */

/**
 * \brief Get the version of AV module
 *
 * \details This function returns the version of AV module.
 *
 * \return The version of AV module from high byte to low byte, for example,
 *			0x01020304 means the version is 1.2.3.4
 *
 * \see IOTC_Get_Version(), RDT_GetRDTApiVer()
 */
AVAPI_API int UBIC_avGetAVApiVer(void);


/**
 * \brief Initialize AV module
 *
 * \details This function is used by AV servers or AV clients to initialize AV
 *			module and shall be called before any AV module related function
 *			is invoked.
 *
 * \param nMaxChannelNum [in] The max number of AV channels. If it is
 *			specified less than 1, AV will set max number of AV channels as 1.
 *
 * \return The actual maximum number of AV channels to be set.
 *
 */
AVAPI_API int UBIC_avInitialize(int nMaxChannelNum);


/**
 * \brief Deinitialize AV module
 *
 * \details This function will deinitialize AV module.
 *
 * \return #AV_ER_NoERROR if deinitialize successfully
 * \return Error code if return value < 0
 *			- #AV_ER_NOT_INITIALIZED the AV module is not initialized yet
 *
 * \attention AV module shall be deinitialized before IOTC module is
 *				deinitialized.
 */
AVAPI_API int UBIC_avDeInitialize(void);


/**
 * \brief Start an AV server
 *
 * \details Start an AV server with predefined view account and password.
 *			Any AV client wanting to connect with this AV server shall
 *			provide matched view account and password.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to start AV server
 * \param cszViewAccount [in] The predefined view account
 * \param cszViewPassword [in] The predefined view password
 * \param nTimeout [in] The timeout for this function in unit of second
 *						Specify it as 0 will make AV server start process return
 *						until an AV client connects successfully.
 * \param nServType [in] The user-defined service type. An AV client will get
 *						this value when it invokes avClientStart() successfully.
 * \param nIOTCChannelID [in] The channel ID of the channel to start AV server
 *
 * \return AV channel ID if return value >= 0
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The IOTC session ID is incorrect or reuse of IOTC session ID
                and IOTC channel ID.
 *			- #AV_ER_NOT_INITIALIZED AV module is not initialized yet
 *			- #AV_ER_EXCEED_MAX_CHANNEL The number of AV channels has reached maximum
 *			- #AV_ER_FAIL_CREATE_THREAD Fails to create threads
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session ID is not valid
 *			- #AV_ER_SERVER_EXIT Users stop this function with avServExit() in another thread
 *			- #AV_ER_TIMEOUT The timeout specified by nTimeout expires before
 *				AV start is performed completely
 *
 * \see avServStart2(), avServExit(), avServStop()
 *
 * \attention (1) This function is a block process.<br><br>
 *				(2) The IOTC channel of	specified channel ID will be turned on automatically
 *				by avServStart()
 *
 */
AVAPI_API int UBIC_avServStart(int nIOTCSessionID, const char *cszViewAccount, const char *cszViewPassword, unsigned long nTimeout, unsigned long nServType, unsigned char nIOTCChannelID);


/**
 * \brief Start an AV server
 *
 * \details Start an AV server with user defined authentication function.
 *			Any AV client wanting to connect with this AV server shall
 *			pass the authentication with view account and password.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to create AV server
 * \param pfxAuthFn [in] The function pointer to an authentication function
 * \param nTimeout [in] The timeout for this function in unit of second.
 *						Specify it as 0 will make AV server start process return
 *						until an AV client connects successfully.
 * \param nServType [in] The user-defined service type. An AV client will get
 *						this value when it invokes avClientStart() successfully.
 * \param nIOTCChannelID [in] The channel ID of the channel to create AV server
 *
 * \return AV channel ID if return value >= 0
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The IOTC session ID is incorrect or reuse of IOTC session ID
                and IOTC channel ID.
 *			- #AV_ER_NOT_INITIALIZED AV module is not initialized yet
 *			- #AV_ER_EXCEED_MAX_CHANNEL The number of AV channels has reached maximum
 *			- #AV_ER_FAIL_CREATE_THREAD Fails to create threads
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session ID is not valid
 *			- #AV_ER_SERVER_EXIT Users stop this function with avServExit() in another thread
 *			- #AV_ER_TIMEOUT The timeout specified by nTimeout expires before
 *				AV start is performed completely
 *
 * \see avServStart(), avServExit(), avServStop()
 *
 * \attention (1) This function is a block process.<br><br>
 *			  (2) The IOTC channel of	specified channel ID will be turned on automatically
 *				by avServStart2()
 *
 */
AVAPI_API int UBIC_avServStart2(int nIOTCSessionID, authFn pfxAuthFn, unsigned long nTimeout, unsigned long nServType, unsigned char nIOTCChannelID);

/**
 * \brief Start an AV server
 *
 * \details Start an AV re-send supported server with user defined authentication function.
 *			Any AV client wanting to connect with this AV server shall
 *			pass the authentication with view account and password. Whether the re-send mechanism
 *          is enabled or not depends on AV client settings and will set the result into 
 *          pnResend parameter.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to create AV server
 * \param pfxAuthFn [in] The function pointer to an authentication function
 * \param nTimeout [in] The timeout for this function in unit of second.
 *						Specify it as 0 will make AV server start process return
 *						until an AV client connects successfully.
 * \param nServType [in] The user-defined service type. An AV client will get
 *                       this value when it invokes avClientStart() successfully.
 * \param nIOTCChannelID [in] The channel ID of the channel to create AV server
 *
 * \param pnResend [out] Set the re-send is enabled or not.
 *
 * \return AV channel ID if return value >= 0
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The IOTC session ID is incorrect or reuse of IOTC session ID
 *               and IOTC channel ID.
 *			- #AV_ER_NOT_INITIALIZED AV module is not initialized yet
 *			- #AV_ER_EXCEED_MAX_CHANNEL The number of AV channels has reached maximum
 *			- #AV_ER_FAIL_CREATE_THREAD Fails to create threads
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session ID is not valid
 *			- #AV_ER_SERVER_EXIT Users stop this function with avServExit() in another thread
 *			- #AV_ER_TIMEOUT The timeout specified by nTimeout expires before
 *				AV start is performed completely
 *
 * \see avServStart(), avServStart2(), avServExit(), avServStop()
 *
 * \attention (1) This function is a block process.<br><br>
 *			  (2) The IOTC channel of specified channel ID will be turned on automatically
 *			 	   by avServStart3()
 *
 */
AVAPI_API int UBIC_avServStart3(int nIOTCSessionID, authFn pfxAuthFn, unsigned long nTimeout, unsigned long nServType, unsigned char nIOTCChannelID, int *pnResend);


/**
 * \brief Used by an AV server exit avServStart() or avServStart2() process
 *
 * \details Since avServStart() and avServStart2() are block processes and
 *			that means the caller has to wait for AV start or specified timeout
 *			expires	before these two functions return. In some cases,
 *			caller may want	to exit AV start process immediately by this
 *			function in another thread.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to exit AV start process
 * \param nIOTCChannelID [in] The channel ID of the channel to exit AV start process
 *
 */
AVAPI_API void UBIC_avServExit(int nIOTCSessionID, unsigned char nIOTCChannelID);


/**
 * \brief Stop an AV server
 *
 * \details An AV server stop AV channel by this function if this channel is
 *			no longer required.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to be stopped
 *
 */
AVAPI_API void UBIC_avServStop(int nAVChannelID);

/**
 * \brief Set re-send buffer size. 
 *
 * \details Use this API to set the re-send buffer size if re-send mechanism is enabled.
 *          Default re-send buffer size is 256KB and recommend size is 1 second data.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to be set.
 * \param nSize [in] The size of re-send buffer.
 *
 */
AVAPI_API void UBIC_avServSetResendSize(int nAVChannelID, unsigned long nSize);


/**
 * \brief An AV server sends frame data to an AV client
 *
 * \details An AV server uses this function to send frame data to AV client
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to be sent
 * \param cabFrameData [in] The frame data to be sent
 * \param nFrameDataSize [in] The size of the frame data
 * \param cabFrameInfo [in] The video frame information to be sent
 * \param nFrameInfoSize [in] The size of the video frame information
 *
 * \return #AV_ER_NoERROR if sending successfully
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid or frame data is null
 *			- #AV_ER_CLIENT_NOT_SUPPORT An AV client uses this function to send frame data
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session of this AV channel is not valid
 *			- #AV_ER_CLIENT_NO_AVLOGIN An AV client does not pass authentication yet
 *			- #AV_ER_EXCEED_MAX_SIZE The frame data and frame info to be sent exceeds
 *				currently remaining video frame buffer. The max size of video frame
 *				buffer is determined by avServSetMaxBufSize()
 *			- #AV_ER_MEM_INSUFF Insufficient memory for allocation
 *			- #AV_ER_EXCEED_MAX_ALARM A warning to indicate the sending queue is almost full
 *
 * \see avSendAudioData()
 *
 */
AVAPI_API int UBIC_avSendFrameData(int nAVChannelID, const char *cabFrameData, int nFrameDataSize, 
								const void *cabFrameInfo, int nFrameInfoSize);


/**
 * \brief An AV server sends audio data to an AV client
 *
 * \details An AV server uses this function to send audio data to AV client
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to be sent
 * \param cabAudioData [in] The audio data to be sent
 * \param nAudioDataSize [in] The size of the audio data
 * \param cabFrameInfo [in] The audio frame information to be sent
 * \param nFrameInfoSize [in] The size of the audio frame information
 *
 * \return #AV_ER_NoERROR if sending successfully
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid or frame data is null
 *			- #AV_ER_CLIENT_NOT_SUPPORT An AV client uses this function to send frame data
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session of this AV channel is not valid
 *			- #AV_ER_CLIENT_NO_AVLOGIN An AV client does not pass authentication yet
 *			- #AV_ER_MEM_INSUFF Insufficient memory for allocation
 *			- #AV_ER_EXCEED_MAX_SIZE The audio data and frame info to be sent exceeds
 *				#AV_MAX_AUDIO_DATA_SIZE
 *
 * \see avSendFrameData()
 *
 */
AVAPI_API int UBIC_avSendAudioData(int nAVChannelID, const char *cabAudioData, int nAudioDataSize, 
								const void *cabFrameInfo, int nFrameInfoSize);


/**
 * \brief Set the maximum video frame buffer used in AV server
 *
 * \details AV server sets the maximum video frame buffer by this function.
 *			The size of video frame buffer will affect the streaming fluency.
 *			The default size of video frame buffer is 2MB.
 *
 * \param nMaxBufSize The maximum video frame buffer, in unit of kilo-byte
 *
 */
AVAPI_API void UBIC_avServSetMaxBufSize(unsigned long nMaxBufSize);


/**
 * \brief Set interval of sending video data in AV server
 *
 * \details An AV server how to send video data to AV client.
 *			It determined the delay time at regular interval between how many packets.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to be sent
 * \param nPacketNum [in] How many number of packet as a regular interval
 * \param nDelayMs [in] Delay time in unit of million-second
 *
 * \return #AV_ER_NoERROR if set successfully
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid
 *
 *
 */
AVAPI_API int UBIC_avServSetDelayInterval(int nAVChannelID, unsigned short nPacketNum, unsigned short nDelayMs);


/**
 * \brief Start an AV client
 *
 * \details Start an AV client by providing view account and password.
 *			It shall pass the authentication of the AV server before receiving
 *			AV data.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to start AV client
 * \param cszViewAccount [in] The view account for authentication
 * \param cszViewPassword [in] The view password for authentication
 * \param nTimeout [in] The timeout for this function in unit of second
 *						Specify it as 0 will make this AV client try connection
 *						once and this process will exit immediately if not
 *						connection is unsuccessful.
 * \param pnServType [out] The user-defined service type set when an AV server
 *						starts. Can be NULL.
 * \param nIOTCChannelID [in] The channel ID of the channel to start AV client
 *
 * \return AV channel ID if return value >= 0
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The IOTC session ID is incorrect or reuse of IOTC session ID
 *              and IOTC channel ID.
 *			- #AV_ER_NOT_INITIALIZED AV module is not initialized yet
 *			- #AV_ER_EXCEED_MAX_CHANNEL The number of AV channels has reached maximum
 *			- #AV_ER_FAIL_CREATE_THREAD Fails to create threads
 *			- #AV_ER_SERV_NO_RESPONSE The AV server has no response
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session ID is not valid
 *			- #AV_ER_CLIENT_EXIT Users stop this function with avClientExit() in another thread
 *			- #AV_ER_TIMEOUT The timeout specified by nTimeout expires before
 *				AV start is performed completely
 *			- #AV_ER_WRONG_VIEWACCorPWD The client fails in authentication due
 *				to incorrect view account or password
 *
 * \see avClientStop(), avClientExit()
 *
 * \attention (1) This function is a block process.<br><br>
 *				 (2) The IOTC channel of specified channel ID will be turned on automatically
 *				by avClientStart().
 *
 */
AVAPI_API int UBIC_avClientStart(int nIOTCSessionID, const char *cszViewAccount, const char *cszViewPassword, 
								unsigned long nTimeout,unsigned long *pnServType, unsigned char nIOTCChannelID);

/**
 * \brief Start an AV client
 *
 * \details Start an AV re-send supported client by providing view account and password.
 *			It shall pass the authentication of the AV server before receiving
 *			AV data. Whether the re-send mechanism is enabled or not depends on AV server settings
 *          and will set the result into pnResend parameter.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to start AV client
 * \param cszViewAccount [in] The view account for authentication
 * \param cszViewPassword [in] The view password for authentication
 * \param nTimeout [in] The timeout for this function in unit of second
 *						Specify it as 0 will make this AV client try connection
 *						once and this process will exit immediately if not
 *						connection is unsuccessful.
 * \param pnServType [out] The user-defined service type set when an AV server
 *						starts. Can be NULL.
 * \param nIOTCChannelID [in] The channel ID of the channel to start AV client
 * \param pnResend [out] Set the re-send is enabled or not.
 *
 * \return AV channel ID if return value >= 0
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The IOTC session ID is incorrect or reuse of IOTC session ID
                and IOTC channel ID.
 *			- #AV_ER_NOT_INITIALIZED AV module is not initialized yet
 *			- #AV_ER_EXCEED_MAX_CHANNEL The number of AV channels has reached maximum
 *			- #AV_ER_FAIL_CREATE_THREAD Fails to create threads
 *			- #AV_ER_SERV_NO_RESPONSE The AV server has no response
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session ID is not valid
 *			- #AV_ER_CLIENT_EXIT Users stop this function with avClientExit() in another thread
 *			- #AV_ER_TIMEOUT The timeout specified by nTimeout expires before
 *				AV start is performed completely
 *			- #AV_ER_WRONG_VIEWACCorPWD The client fails in authentication due
 *				to incorrect view account or password
 *
 * \see avClientStop(), avClientExit()
 *
 * \attention (1) This function is a block process.<br><br>
 *			  (2) The IOTC channel of specified channel ID will be turned on automatically
 *				  by avClientStart2().<br><br>
 *            (3) If AV client uses avClientStart2() to enable AV re-send mechanism, it has
 *                to use avRecvFrameData2() to receive video data.
 *
 */
AVAPI_API int UBIC_avClientStart2(int nIOTCSessionID, const char *cszViewAccount, const char *cszViewPassword, 
								unsigned long nTimeout,unsigned long *pnServType, unsigned char nIOTCChannelID, int *pnResend);
								
/**
 * \brief Used by an AV client exit avClientStart() process
 *
 * \details Since avClientStart() is a block process and
 *			that means the caller has to wait for AV start or specified timeout
 *			expires	before these two functions return. In some cases,
 *			caller may want	to exit AV start process immediately by this
 *			function in another thread.
 *
 * \param nIOTCSessionID [in] The session ID of the IOTC session to exit AV start process
 * \param nIOTCChannelID [in] The channel ID of the channel to exit AV start process
 *
 */
AVAPI_API void UBIC_avClientExit(int nIOTCSessionID, unsigned char nIOTCChannelID);


/**
 * \brief Stop an AV client
 *
 * \details An AV client stop AV channel by this function if this channel is
 *			no longer required.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to be stopped
 *
 */
AVAPI_API void UBIC_avClientStop(int nAVChannelID);


/**
 * \brief An AV client receives frame data from an AV server
 *
 * \details An AV client uses this function to receive frame data from AV server
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to be received
 * \param abFrameData [out] The frame data to be received
 * \param nFrameDataMaxSize [in] The max size of the frame data
 * \param abFrameInfo [out] The video frame information to be received
 * \param nFrameInfoMaxSize [in] The max size of the video frame information
 * \param pnFrameIdx [out] The index of current receiving video frame
 *
 * \return The actual length of received result stored in abFrameData if successfully
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid or frame data is null
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session of this AV channel is not valid
 *			- #AV_ER_DATA_NOREADY The data is not ready for receiving yet.
 *			- #AV_ER_LOSED_THIS_FRAME The whole frame is lost during receiving
 *			- #AV_ER_BUFPARA_MAXSIZE_INSUFF The frame to be received exceeds
 *				the size of abFrameData, i.e. nFrameDataMaxSize
 *			- #AV_ER_MEM_INSUFF Insufficient memory for allocation
 *			- #AV_ER_INCOMPLETE_FRAME Some parts of a frame are lost during receiving
 *
 * \see avRecvAudioData()
 *
 */
AVAPI_API int UBIC_avRecvFrameData(int nAVChannelID, char *abFrameData, int nFrameDataMaxSize,
								char *abFrameInfo, int nFrameInfoMaxSize, unsigned int *pnFrameIdx);

/**
 * \brief A new version AV client receives frame data from an AV server
 *
 * \details An AV client uses this function to receive frame data from AV server
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to be received
 * \param abFrameData [out] The frame data to be received
 * \param nFrameDataMaxSize [in] The max size of the frame data
 * \param pnActualFrameSize [in] The actual size of frame data to be received, maybe less than expected size
 * \param pnExpectedFrameSize [in] The size of frame data expect to be received that sent from av server
 * \param abFrameInfo [out] The video frame information to be received
 * \param nFrameInfoMaxSize [in] The max size of the video frame information
 * \param pnActualFrameInfoSize [in] The actual size of the video frame information to be received
 * \param pnFrameIdx [out] The index of current receiving video frame
 *
 * \return The actual length of received result stored in abFrameData if successfully
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid or frame data is null
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session of this AV channel is not valid
 *			- #AV_ER_DATA_NOREADY The data is not ready for receiving yet.
 *			- #AV_ER_LOSED_THIS_FRAME The whole frame is lost during receiving
 *			- #AV_ER_BUFPARA_MAXSIZE_INSUFF The frame to be received exceeds
 *				the size of abFrameData, i.e. nFrameDataMaxSize
 *			- #AV_ER_MEM_INSUFF Insufficient memory for allocation
 *			- #AV_ER_INCOMPLETE_FRAME Some parts of a frame are lost during receiving
 *
 * \see avRecvAudioData()
 *
 */
AVAPI_API int UBIC_avRecvFrameData2(int nAVChannelID, char *abFrameData, int nFrameDataMaxSize, int *pnActualFrameSize,
								int *pnExpectedFrameSize, char *abFrameInfo, int nFrameInfoMaxSize,
								int *pnActualFrameInfoSize, unsigned int *pnFrameIdx);
				  
/**
 * \brief An AV client receives audio data from an AV server
 *
 * \details An AV client uses this function to receive audio data from AV server
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to be received
 * \param abAudioData [out] The audio data to be received
 * \param nAudioDataMaxSize [in] The max size of the audio data
 * \param abFrameInfo [out] The audio frame information to be received
 * \param nFrameInfoMaxSize [in] The max size of the audio frame information
 * \param pnFrameIdx [out] The index of current receiving audio frame
 *
 * \return The actual length of received result stored in abAudioData if successfully
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid or frame data is null
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session of this AV channel is not valid
 *			- #AV_ER_DATA_NOREADY The data is not ready for receiving yet.
 *			- #AV_ER_LOSED_THIS_FRAME The whole frame is lost during receiving
 *			- #AV_ER_BUFPARA_MAXSIZE_INSUFF The data and frame info to be received
 *				exceeds	the size of abAudioData and abFrameInfo, respectively.
 *
 * \see avRecvFrameData()
 *
 */
AVAPI_API int UBIC_avRecvAudioData(int nAVChannelID, char *abAudioData, int nAudioDataMaxSize,
								char *abFrameInfo, int nFrameInfoMaxSize, unsigned int *pnFrameIdx);


/**
 * \brief Get the frame count of audio buffer remaining in the queue
 *
 * \details An AV client uses this function to get the frame count of audio buffer
 *			that is still remaining in the receiving queue, then determine
 *			whether it is a right time to invoke avRecvAudioData().
 *			Keeping audio buffer in audio queue instead of receiving immediately
 *			can greatly improve the discontinuous audio issues. However,
 *			it is not good to receive audio in a very long time since audio
 *			buffer will overflow and audio data will be lost.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to check audio buffer
 *
 * \return The frame count of audio buffer
 */
AVAPI_API int UBIC_avCheckAudioBuf(int nAVChannelID);


/**
 * \brief Set the maximum video frame buffer used in AV client
 *
 * \details AV client sets the maximum video frame buffer by this function.
 *			The size of video frame buffer will affect the streaming fluency.
 *			The default size of video frame buffer is 1MB.
 *
 * \param nMaxBufSize The maximum video frame buffer, in unit of kilo-byte
 *
 */
AVAPI_API void UBIC_avClientSetMaxBufSize(unsigned long nMaxBufSize);


/**
 * \brief Clean the video and audio buffer
 *
 * \details A client with multiple device connection application should call
 *			this function to clean AV buffer while switch to another devices.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to clean buffer
 *
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid or frame data is null
 */
AVAPI_API int UBIC_avClientCleanBuf(int nAVChannelID);


/**
 * \brief Clean the video buffer
 *
 * \details A client with multiple device connection application should call
 *			this function to clean video buffer while switch to another devices.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to clean buffer
 *
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid or frame data is null
 */
AVAPI_API int UBIC_avClientCleanVideoBuf(int nAVChannelID);


/**
 * \brief Clean the aduio buffer
 *
 * \details A client with multiple device connection application should call
 *			this function to clean audio buffer while switch listen to speaker.
 *
 * \param nAVChannelID [in] The channel ID of the audio channel to clean buffer
 *
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid or frame data is null
 */
AVAPI_API int UBIC_avClientCleanAudioBuf(int nAVChannelID);


/**
 * \brief Send AV IO control
 *
 * \details This function is used by AV servers or AV clients to send a 
 *			AV IO control.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to send IO control
 * \param nIOCtrlType [in] The type of IO control
 * \param cabIOCtrlData [in] The buffer of IO control data
 * \param nIOCtrlDataSize [in] The length of IO control data
 *
 * \return #AV_ER_NoERROR if sending successfully
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid
 *			- #AV_ER_SENDIOCTRL_ALREADY_CALLED This AV channel is already in sending
 *				IO control process
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session of this AV channel is not valid
 *			- #AV_ER_SENDIOCTRL_EXIT avSendIOCtrlExit() is called before this
 *				function is returned
 *			- #AV_ER_EXCEED_MAX_SIZE The IO control data and type to be sent exceeds
 *				#AV_MAX_IOCTRL_DATA_SIZE
 *
 * \see avRecvIOCtrl(), avSendIOCtrlExit()
 *
 * \attention This function is a block process and it will return until 
 *				having acknowledgment from the receiver.
 */
AVAPI_API int UBIC_avSendIOCtrl(int nAVChannelID, unsigned int nIOCtrlType, const char *cabIOCtrlData, int nIOCtrlDataSize);
AVAPI_API int UBIC_avSendIOCtrlEx(int nAVChannelID, unsigned short RlyIdx, unsigned int nIOCtrlType, const char *cabIOCtrlData, int nIOCtrlDataSize);

/**
 * \brief Receive AV IO control
 *
 * \details This function is used by AV servers or AV clients to receive a 
 *			AV IO control.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel to receive IO control
 * \param pnIOCtrlType [out] The type of received IO control
 * \param abIOCtrlData [out] The buffer of received IO control data
 * \param nIOCtrlMaxDataSize [in] The max length of buffer of received IO control data
 * \param nTimeout [in] The timeout for this function in unit of million-second, give 0 means return immediately
 *
 * \return The actual length of received result stored in abIOCtrlData if
 *			receiving IO control successfully
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid or IO control type
 *				/ data is null
 *			- #AV_ER_SESSION_CLOSE_BY_REMOTE The remote site already closes
 *				this IOTC session
 *			- #AV_ER_REMOTE_TIMEOUT_DISCONNECT The timeout expires because
 *				remote site has no response.
 *			- #AV_ER_INVALID_SID The IOTC session of this AV channel is not valid
 *			- #AV_ER_DATA_NOREADY The IO control is not ready for receiving yet.
 *			- #AV_ER_TIMEOUT The timeout specified by nTimeout expires before
 *				receiving IO control process is performed completely
 *			- #AV_ER_BUFPARA_MAXSIZE_INSUFF The IO control data to be received exceeds
 *				the size of abIOCtrlData, i.e. nIOCtrlMaxDataSize
 *
 * \see avSendIOCtrl()
 *
 */
AVAPI_API int UBIC_avRecvIOCtrl(int nAVChannelID, unsigned int *pnIOCtrlType, char *abIOCtrlData, int nIOCtrlMaxDataSize, unsigned int nTimeout);
AVAPI_API int UBIC_avRecvIOCtrlEx(int nAVChannelID, unsigned short *RlyIdx, unsigned int *pnIOCtrlType, char *abIOCtrlData, int nIOCtrlMaxDataSize, unsigned int nTimeout);


/**
 * \brief Used by an AV server or an AV client to exit sending IO control process
 *
 * \details Since avSendIOCtrl() process is a block process and that means
 *			the caller has to wait for the acknowledgment from the receipt
 *			before avSendIOCtrl() returns. In some cases, caller may want
 *			to exit sending immediately by this function in another thread.
 *
 * \param nAVChannelID [in] The channel ID of the AV channel in sending IO control
 *
 * \return #AV_ER_NoERROR if sending successfully
 * \return Error code if return value < 0
 *			- #AV_ER_INVALID_ARG The AV channel ID is not valid
 */
AVAPI_API int UBIC_avSendIOCtrlExit(int nAVChannelID);

AVAPI_API int UBIC_avClientGetLostInfo(int AvIdx
    , unsigned int *pTotalLostRate          /* 总丢包率 */
    , unsigned int *pTotalSendPktNum        /* 总发送数据包数量 */
    , unsigned int *pTotalLostPktNum        /* 总丢包数量 */
    , unsigned int *pTotalSendFecNum        /* 总FEC发送数量 */
    , unsigned int *pTotalLostFecNum        /* 总FEC丢包数量 */
    , unsigned int *pTotalFixedPktNum       /* 总修复成功数量 */
    , unsigned int *pTotalUnFixPktNum       /* 总不能修复数量 */
    , unsigned int *pTotalFixFailPktNum     /* 总修复失败数量 */
    , unsigned int *pTotalSendBlockNum      /* 总发送块数 默认10PKT=1BLK */
    , unsigned int *pTotalCompleteBlockNum  /* 一次接收成功块数  */
    , unsigned int *pTotalFixedBlockNum     /* 总修复成功块数  */
    , unsigned int *pTotalSendFrmNum        /* 总发送帧数量 */
    , unsigned int *pTotalFixedFrmNum       /* 总修复帧数量 */    
    , unsigned int *pAvgBw    
    , unsigned int *pAvgLostRate            /* 平均丢包率*/
    );

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _AVAPIs_UBIA_ADDON_H_ */
