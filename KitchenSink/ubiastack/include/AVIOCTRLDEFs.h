/*
 * AVIOCTRLDEFs.h
 *	Define AVIOCTRL Message Type and Context
 *  Created on: 2013-08-12
 *  Author: UBIA
 *
 */

//Change Log:
//

//

#ifndef _AVIOCTRL_DEFINE_H_
#define _AVIOCTRL_DEFINE_H_

/////////////////////////////////////////////////////////////////////////////////
/////////////////// Message Type Define//////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

// AVIOCTRL Message Type
typedef enum 
{
	IOTYPE_USER_IPCAM_START 					= 0x01FF,
	IOTYPE_USER_IPCAM_STOP	 					= 0x02FF,
	IOTYPE_USER_IPCAM_AUDIOSTART 				= 0x0300,
	IOTYPE_USER_IPCAM_AUDIOSTOP 				= 0x0301,

	IOTYPE_USER_IPCAM_SPEAKERSTART 				= 0x0350,
	IOTYPE_USER_IPCAM_SPEAKERSTOP 				= 0x0351,

	IOTYPE_USER_IPCAM_SETSTREAMCTRL_REQ			= 0x0320,
	IOTYPE_USER_IPCAM_SETSTREAMCTRL_RESP		= 0x0321,
	IOTYPE_USER_IPCAM_GETSTREAMCTRL_REQ			= 0x0322,
	IOTYPE_USER_IPCAM_GETSTREAMCTRL_RESP		= 0x0323,

	IOTYPE_USER_IPCAM_SETMOTIONDETECT_REQ		= 0x0324,
	IOTYPE_USER_IPCAM_SETMOTIONDETECT_RESP		= 0x0325,
	IOTYPE_USER_IPCAM_GETMOTIONDETECT_REQ		= 0x0326,
	IOTYPE_USER_IPCAM_GETMOTIONDETECT_RESP		= 0x0327,
	
	IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_REQ		= 0x0328,	// Get Support Stream
	IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_RESP		= 0x0329,	

	IOTYPE_USER_IPCAM_DEVINFO_REQ				= 0x0330,
	IOTYPE_USER_IPCAM_DEVINFO_RESP				= 0x0331,

	IOTYPE_USER_IPCAM_SETPASSWORD_REQ			= 0x0332,
	IOTYPE_USER_IPCAM_SETPASSWORD_RESP			= 0x0333,

	IOTYPE_USER_IPCAM_LISTWIFIAP_REQ			= 0x0340,
	IOTYPE_USER_IPCAM_LISTWIFIAP_RESP			= 0x0341,
	IOTYPE_USER_IPCAM_SETWIFI_REQ				= 0x0342,
	IOTYPE_USER_IPCAM_SETWIFI_RESP				= 0x0343,
	IOTYPE_USER_IPCAM_GETWIFI_REQ				= 0x0344,
	IOTYPE_USER_IPCAM_GETWIFI_RESP				= 0x0345,
	IOTYPE_USER_IPCAM_SETWIFI_REQ_2				= 0x0346,
	IOTYPE_USER_IPCAM_GETWIFI_RESP_2			= 0x0347,

	IOTYPE_USER_IPCAM_SETRECORD_REQ				= 0x0310,
	IOTYPE_USER_IPCAM_SETRECORD_RESP			= 0x0311,
	IOTYPE_USER_IPCAM_GETRECORD_REQ				= 0x0312,
	IOTYPE_USER_IPCAM_GETRECORD_RESP			= 0x0313,

	IOTYPE_USER_IPCAM_SETRCD_DURATION_REQ		= 0x0314,
	IOTYPE_USER_IPCAM_SETRCD_DURATION_RESP  	= 0x0315,
	IOTYPE_USER_IPCAM_GETRCD_DURATION_REQ		= 0x0316,
	IOTYPE_USER_IPCAM_GETRCD_DURATION_RESP  	= 0x0317,

	IOTYPE_USER_IPCAM_LISTEVENT_REQ				= 0x0318,
	IOTYPE_USER_IPCAM_LISTEVENT_RESP			= 0x0319,
	
	IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL 		= 0x031A,
	IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL_RESP 	= 0x031B,
	
	IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ		= 0x032A,
	IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_RESP	= 0x032B,

	IOTYPE_USER_IPCAM_GET_EVENTCONFIG_REQ		= 0x0400,	// Get Event Config Msg Request
	IOTYPE_USER_IPCAM_GET_EVENTCONFIG_RESP		= 0x0401,	// Get Event Config Msg Response
	IOTYPE_USER_IPCAM_SET_EVENTCONFIG_REQ		= 0x0402,	// Set Event Config Msg req
	IOTYPE_USER_IPCAM_SET_EVENTCONFIG_RESP		= 0x0403,	// Set Event Config Msg resp

    IOTYPE_USER_IPCAM_GET_ALARMMODE_REQ         = 0x0404,	// Get Alarm Mode Request
    IOTYPE_USER_IPCAM_GET_ALARMMODE_RESP		= 0x0405,	// Get Alarm Mode Response
    IOTYPE_USER_IPCAM_SET_ALARMMODE_REQ         = 0x0406,	// Set Alarm Mode req
    IOTYPE_USER_IPCAM_SET_ALARMMODE_RESP		= 0x0407,	// Set Alarm Mode resp
    
	IOTYPE_USER_IPCAM_SET_ENVIRONMENT_REQ		= 0x0360,
	IOTYPE_USER_IPCAM_SET_ENVIRONMENT_RESP		= 0x0361,
	IOTYPE_USER_IPCAM_GET_ENVIRONMENT_REQ		= 0x0362,
	IOTYPE_USER_IPCAM_GET_ENVIRONMENT_RESP		= 0x0363,
	
	IOTYPE_USER_IPCAM_SET_VIDEOMODE_REQ			= 0x0370,	// Set Video Flip Mode
	IOTYPE_USER_IPCAM_SET_VIDEOMODE_RESP		= 0x0371,
	IOTYPE_USER_IPCAM_GET_VIDEOMODE_REQ			= 0x0372,	// Get Video Flip Mode
	IOTYPE_USER_IPCAM_GET_VIDEOMODE_RESP		= 0x0373,
	
	IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_REQ		= 0x0380,	// Format external storage
	IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_RESP		= 0x0381,	

	IOTYPE_USER_IPCAM_SETCOVER_REQ		        = 0x0382,
	IOTYPE_USER_IPCAM_SETCOVER_RESP		        = 0x0383,
	IOTYPE_USER_IPCAM_GETCOVER_REQ		        = 0x0384,
	IOTYPE_USER_IPCAM_GETCOVER_RESP		        = 0x0385,

	IOTYPE_USER_IPCAM_SETVOLUME_REQ		        = 0x0386, /* add by zlq, ‘ˆº”“Ù¡øøÿ÷∆ */
	IOTYPE_USER_IPCAM_SETVOLUME_RESP		    = 0x0387,
	IOTYPE_USER_IPCAM_GETVOLUME_REQ		        = 0x0388,
	IOTYPE_USER_IPCAM_GETVOLUME_RESP		    = 0x0389,

    /* œ¬√ÊÀƒ∏ˆΩ·ππÃÂ∫Õœ‡”¶µƒIOTYPE_USER_IPCAM_XXXVOLUME_XXX ÕÍ»´œ‡Õ¨ */
    IOTYPE_USER_IPCAM_SETMICVOLUME_REQ          = 0x038A, /* add by zlq, ‘ˆº” ‰»Î“Ù¡øøÿ÷∆£¨º¥ «ipcµƒ¬ÛøÀ∑Á ‰»Î“Ù¡ø */
    IOTYPE_USER_IPCAM_SETMICVOLUME_RESP         = 0x038B,
    IOTYPE_USER_IPCAM_GETMICVOLUME_REQ          = 0x038C,
    IOTYPE_USER_IPCAM_GETMICVOLUME_RESP         = 0x038D,

	IOTYPE_USER_IPCAM_SETMOTIONDETECT_DETAIL_REQ		= 0x038e, /* “∆∂Ø’Ï≤‚œÍœ∏–≈œ¢…Ë÷√ */
	IOTYPE_USER_IPCAM_SETMOTIONDETECT_DETAIL_RESP		= 0x038f,
	IOTYPE_USER_IPCAM_GETMOTIONDETECT_DETAIL_REQ		= 0x0390,
	IOTYPE_USER_IPCAM_GETMOTIONDETECT_DETAIL_RESP		= 0x0391,

	IOTYPE_USER_IPCAM_GETSTREAMCTRL_DETAIL_REQ			= 0x0392,
	IOTYPE_USER_IPCAM_GETSTREAMCTRL_DETAIL_RESP		    = 0x0393,

	IOTYPE_USER_IPCAM_I_FRAME_REQ			            = 0x0394,
	IOTYPE_USER_IPCAM_I_FRAME_RESP		                = 0x0395,

    IOTYPE_USER_IPCAM_SETSHARE_REQ              = 0x0396, /* …Ë÷√ø™∆Ù∫Õ»°œ˚…„œÒÕ∑π≤œÌ */
    IOTYPE_USER_IPCAM_SETSHARE_RESP             = 0x0397,
    IOTYPE_USER_IPCAM_GETSHARE_REQ              = 0x0398, /* ªÒ»°…„œÒÕ∑π≤œÌ ◊¥Ã¨*/
    IOTYPE_USER_IPCAM_GETSHARE_RESP             = 0x0399,
		

	IOTYPE_USER_IPCAM_GET_FLOWINFO_REQ			= 0x0390,
	IOTYPE_USER_IPCAM_GET_FLOWINFO_RESP			= 0x0391,
	IOTYPE_USER_IPCAM_CURRENT_FLOWINFO			= 0x0392,
	
	IOTYPE_USER_IPCAM_GET_TIMEZONE_REQ          = 0x3A0,
	IOTYPE_USER_IPCAM_GET_TIMEZONE_RESP         = 0x3A1,
	IOTYPE_USER_IPCAM_SET_TIMEZONE_REQ          = 0x3B0,
	IOTYPE_USER_IPCAM_SET_TIMEZONE_RESP         = 0x3B1,
    
    IOTYPE_USER_IPCAM_GET_OSD_REQ               = 0x3B2,
    IOTYPE_USER_IPCAM_GET_OSD_RESP              = 0x3B3,
    IOTYPE_USER_IPCAM_SET_OSD_REQ               = 0x3B4,
    IOTYPE_USER_IPCAM_SET_OSD_RESP              = 0x3B5,
    
    IOTYPE_USER_IPCAM_GET_ADVANCESETTINGS_REQ   = 0x3C0,
    IOTYPE_USER_IPCAM_GET_ADVANCESETTINGS_RESP  = 0x3C1,
    
	IOTYPE_USER_IPCAM_PTZ_COMMAND				= 0x1001,	// P2P PTZ Command Msg
	IOTYPE_USER_IPCAM_RECEIVE_FIRST_IFRAME		= 0x1002,	// Send from client, used to talk to device that
															// client had received the first I frame
    
    IOTYPE_USER_IPCAM_VIDEO_REPORT		        = 0x1100,	// video report
	IOTYPE_USER_IPCAM_AUDIO_REPORT		        = 0x1101,	// audio report

	IOTYPE_USER_IPCAM_IR_SWITCH_CMD		        = 0x1200,	// IR switch command, add by zlq
    IOTYPE_USER_IPCAM_UPDATE_CHECK_REQ      = 0x1210, 
    IOTYPE_USER_IPCAM_UPDATE_CHECK_RSP      = 0x1211,
    IOTYPE_USER_IPCAM_UPDATE_REQ            = 0x1212,
    IOTYPE_USER_IPCAM_UPDATE_RSP            = 0x1213,
    IOTYPE_USER_IPCAM_UPDATE_STATUS         = 0x1214,

	IOTYPE_USER_IPCAM_UPDATE_CHECK_PHONE_REQ      = 0x1215, //RECV APP REQ //ethanluo
    IOTYPE_USER_IPCAM_UPDATE_CHECK_PHONE_RSP      = 0x1216, //send board version info //ethanluo
    IOTYPE_USER_IPCAM_UPDATE_PHONE_REQ            = 0x1217, //recv APP update req //ethanluo
    IOTYPE_USER_IPCAM_UPDATE_PHONE_RSP            = 0x1218, // //ethanluo

	IOTYPE_USER_IPCAM_SYSTEM_REBOOT_REQ            = 0x1219, // RECV APP reboot REQ//ethanluo
	IOTYPE_USER_IPCAM_SYSTEM_REBOOT_RSP            = 0x1220, // //ethanluo

	IOTYPE_USER_IPCAM_SETMOTIONADDR_REQ			   = 0X1221, //ethanluo
	IOTYPE_USER_IPCAM_SETMOTIONADDR_RSP			   = 0X1222, //ethanluo
    
    IOTYPE_USER_IPCAM_SETAUDIOSENSITIVITY_REQ	   = 0X1231, //maxwell
	IOTYPE_USER_IPCAM_SETAUDIOSENSITIVITY_RSP      = 0X1232, //maxwell
    
    IOTYPE_USER_IPCAM_GETAUDIOSENSITIVITY_REQ	   = 0X1233, //maxwell
	IOTYPE_USER_IPCAM_GETAUDIOSENSITIVITY_RSP      = 0X1234, //maxwell
    
    IOTYPE_USER_IPCAM_SETTEMPSENSITIVITY_REQ	   = 0X1235, //maxwell
	IOTYPE_USER_IPCAM_SETTEMPSENSITIVITY_RSP       = 0X1236, //maxwell
    
    IOTYPE_USER_IPCAM_GETTEMPSENSITIVITY_REQ	   = 0X1237, //maxwell
	IOTYPE_USER_IPCAM_GETTEMPSENSITIVITY_RSP       = 0X1238, //maxwell
    
    IOTYPE_USER_IPCAM_GETTEMPERATURE_REQ            = 0X1239, //maxwell
    IOTYPE_USER_IPCAM_GETTEMPERATURE_RSP            = 0X123A, //maxwell

    /*20141217 add define for file transfer*/

    IOTYPE_USER_FILE_LIST_REQ                       = 0X1300, //maxwell
    IOTYPE_USER_FILE_LIST_REQ1                      = 0X1310, //maxwell
    IOTYPE_USER_FILE_LIST_RSP                       = 0X1301, //maxwell
    
    IOTYPE_USER_FILE_DOWNLOAD_REQ                   = 0X1302, //maxwell
    IOTYPE_USER_FILE_DOWNLOAD_RSP                   = 0X1303, //maxwell

    IOTYPE_USER_FILE_UPLOAD_REQ                     = 0X1304, //maxwell
    IOTYPE_USER_FILE_UPLOAD_RSP                     = 0X1305, //maxwell

    IOTYPE_USER_FILE_TRANS_PKT_ACK                  = 0X1306, //maxwell
    IOTYPE_USER_FILE_TRANS_PKT_NAK                  = 0X1307, //maxwell

    IOTYPE_USER_FILE_TRANS_PKT_START                = 0X1308, //maxwell
    IOTYPE_USER_FILE_TRANS_PKT_STOP                 = 0X1309, //maxwell

    IOTYPE_USER_FILE_DELETE_REQ                     = 0X130A, //maxwell
    IOTYPE_USER_FILE_DELETE_RSP                     = 0X130B, //maxwell

    IOTYPE_USER_IPCAM_SETPIR_REQ                = 0X1241,  /* PIR���� */
	IOTYPE_USER_IPCAM_SETPIR_RESP               = 0X1242,
    IOTYPE_USER_IPCAM_GETPIR_REQ                = 0X1243 ,
    IOTYPE_USER_IPCAM_GETPIR_RESP               = 0X1244,

    IOTYPE_USER_IPCAM_SETIRMODE_REQ             = 0X1251,  /* LED���� */
    IOTYPE_USER_IPCAM_SETIRMODE_RESP            = 0X1252,
    IOTYPE_USER_IPCAM_GETIRMODE_REQ             = 0X1253 ,
    IOTYPE_USER_IPCAM_GETIRMODE_RESP            = 0X1254,
	
    //Customer defined message type, start from 0xFF00:0000
	//Naming role : IOTYPE_[Company_name]_[function_name]
	//EX:
	//IOTYPE_UBIA_TEST_REQ						=0xFF000001,
	//IOTYPE_UBIA_TEST_RESP						=0xFF000002,
    
    
    /*Define for Pet Feed*/
    IOTYPE_USER_IPCAM_PET_FEED_REQ                  = 0X1260, //maxwell
    IOTYPE_USER_IPCAM_PET_FEED_RSP                  = 0X1261, //maxwell
    
    IOTYPE_USER_IPCAM_PET_LIGHT_REQ                 = 0X1262, //maxwell
    IOTYPE_USER_IPCAM_PET_LIGHT_RSP                 = 0X1263, //maxwell
    IOTYPE_USER_IPCAM_PET_ACTIVITY_REP_REQ          = 0X1264, //maxwell
    IOTYPE_USER_IPCAM_PET_FEED_REP_REQ              = 0X1265, //maxwell
    
    IOTYPE_USER_IPCAM_EVENT_REPORT                  = 0x1FFF,	// Device Event Report Msg
}ENUM_AVIOCTRL_MSGTYPE;



/////////////////////////////////////////////////////////////////////////////////
/////////////////// Type ENUM Define ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
typedef enum
{
	AVIOCTRL_OK					= 0x00,
	AVIOCTRL_ERR				= -0x01,
	AVIOCTRL_ERR_PASSWORD		= AVIOCTRL_ERR - 0x01,
	AVIOCTRL_ERR_STREAMCTRL		= AVIOCTRL_ERR - 0x02,
	AVIOCTRL_ERR_MONTIONDETECT	= AVIOCTRL_ERR - 0x03,
	AVIOCTRL_ERR_DEVICEINFO		= AVIOCTRL_ERR - 0x04,
	AVIOCTRL_ERR_LOGIN			= AVIOCTRL_ERR - 5,
	AVIOCTRL_ERR_LISTWIFIAP		= AVIOCTRL_ERR - 6,
	AVIOCTRL_ERR_SETWIFI		= AVIOCTRL_ERR - 7,
	AVIOCTRL_ERR_GETWIFI		= AVIOCTRL_ERR - 8,
	AVIOCTRL_ERR_SETRECORD		= AVIOCTRL_ERR - 9,
	AVIOCTRL_ERR_SETRCDDURA		= AVIOCTRL_ERR - 10,
	AVIOCTRL_ERR_LISTEVENT		= AVIOCTRL_ERR - 11,
	AVIOCTRL_ERR_PLAYBACK		= AVIOCTRL_ERR - 12,

	AVIOCTRL_ERR_INVALIDCHANNEL	= AVIOCTRL_ERR - 0x20,
}ENUM_AVIOCTRL_ERROR; //APP don't use it now


// ServType, unsigned long, 32 bits, is a bit mask for function declareation
// bit value "0" means function is valid or enabled
// in contract, bit value "1" means function is invalid or disabled.
// ** for more details, see "ServiceType Definitation for AVAPIs"
// 
// Defined bits are listed below:
//----------------------------------------------
// bit		fuction
// 0		Audio in, from Device to Mobile
// 1		Audio out, from Mobile to Device 
// 2		PT function
// 3		Event List function
// 4		Play back function (require Event List function)
// 5		Wi-Fi setting function
// 6		Event Setting Function
// 7		Recording Setting function
// 8		SDCard formattable function
// 9		Video flip function
// 10		Environment mode
// 11		Multi-stream selectable
// 12		Audio out encoding format

// The original enum below is obsoleted.
typedef enum
{
	SERVTYPE_IPCAM_DWH					= 0x00,
	SERVTYPE_RAS_DWF					= 0x01,
	SERVTYPE_IOTCAM_8125				= 0x10,
	SERVTYPE_IOTCAM_8125PT				= 0x11,
	SERVTYPE_IOTCAM_8126				= 0x12,
	SERVTYPE_IOTCAM_8126PT				= 0x13,	
}ENUM_SERVICE_TYPE;

// AVIOCTRL Quality Type
typedef enum 
{
	AVIOCTRL_QUALITY_UNKNOWN			= 0x00,	
	AVIOCTRL_QUALITY_MAX				= 0x01,	// ex. 640*480, 15fps, 320kbps (or 1280x720, 5fps, 320kbps)
	AVIOCTRL_QUALITY_HIGH				= 0x02,	// ex. 640*480, 10fps, 256kbps
	AVIOCTRL_QUALITY_MIDDLE				= 0x03,	// ex. 320*240, 15fps, 256kbps
	AVIOCTRL_QUALITY_LOW				= 0x04, // ex. 320*240, 10fps, 128kbps
	AVIOCTRL_QUALITY_MIN				= 0x05,	// ex. 160*120, 10fps, 64kbps
}ENUM_QUALITY_LEVEL;

// AVIOCTRL Quality Type
typedef enum 
{
	AVIOCTRL_SUBFLOWRATE_UNKNOWN			= 0x00,	
	AVIOCTRL_SUBFLOWRATE_MAX				= 384,	// ex. 640*480, 15fps, 320kbps (or 1280x720, 5fps, 320kbps)
	AVIOCTRL_SUBFLOWRATE_HIGH				= 256,	// ex. 640*480, 10fps, 256kbps
	AVIOCTRL_SUBFLOWRATE_MIDDLE				= 200,	// ex. 320*240, 15fps, 256kbps
	AVIOCTRL_SUBFLOWRATE_LOW				= 180, // ex. 320*240, 10fps, 128kbps
	AVIOCTRL_SUBFLOWRATE_MIN				= 128,	// ex. 160*120, 10fps, 64kbps
}ENUM_SUBFLOWRATE_LEVEL;

typedef enum 
{
	AVIOCTRL_MAINFLOWRATE_UNKNOWN			= 0x00,	
	AVIOCTRL_MAINFLOWRATE_MAX				= 800,	// ex. 720p, 15fps, 320kbps (or 1280x720, 5fps, 320kbps)
	AVIOCTRL_MAINFLOWRATE_HIGH				= 600,	// ex. 720p, 10fps, 256kbps
	AVIOCTRL_MAINFLOWRATE_MIDDLE			= 500,	// ex. 720p, 15fps, 256kbps
	AVIOCTRL_MAINFLOWRATE_LOW				= 400, // ex. 720p, 10fps, 128kbps
	AVIOCTRL_MAINFLOWRATE_MIN				= 300,	// ex. 720p, 10fps, 64kbps
}ENUM_MAINFLOWRATE_LEVEL;

typedef enum
{
	AVIOTC_WIFIAPMODE_NULL				= 0x00,
	AVIOTC_WIFIAPMODE_MANAGED			= 0x01,
	AVIOTC_WIFIAPMODE_ADHOC				= 0x02,
}ENUM_AP_MODE;


typedef enum
{
	AVIOTC_WIFIAPENC_INVALID			= 0x00, 
	AVIOTC_WIFIAPENC_NONE				= 0x01, 
	AVIOTC_WIFIAPENC_WEP				= 0x02, //WEP, for no password
	AVIOTC_WIFIAPENC_WPA_TKIP			= 0x03, 
	AVIOTC_WIFIAPENC_WPA_AES			= 0x04, 
	AVIOTC_WIFIAPENC_WPA2_TKIP			= 0x05, 
	AVIOTC_WIFIAPENC_WPA2_AES			= 0x06, 

	AVIOTC_WIFIAPENC_WPA_PSK_TKIP  = 0x07,
	AVIOTC_WIFIAPENC_WPA_PSK_AES   = 0x08,
	AVIOTC_WIFIAPENC_WPA2_PSK_TKIP = 0x09,
	AVIOTC_WIFIAPENC_WPA2_PSK_AES  = 0x0A,

}ENUM_AP_ENCTYPE;


// AVIOCTRL Event Type
typedef enum 
{
	AVIOCTRL_EVENT_ALL					= 0x00,	// all event type(general APP-->IPCamera)
	AVIOCTRL_EVENT_MOTIONDECT			= 0x01,	// motion detect start//==s==
	AVIOCTRL_EVENT_VIDEOLOST			= 0x02,	// video lost alarm
	AVIOCTRL_EVENT_IOALARM				= 0x03, // io alarmin start //---s--

	AVIOCTRL_EVENT_MOTIONPASS			= 0x04, // motion detect end  //==e==
	AVIOCTRL_EVENT_VIDEORESUME			= 0x05,	// video resume
	AVIOCTRL_EVENT_IOALARMPASS			= 0x06, // IO alarmin end   //---e--

	AVIOCTRL_EVENT_EXPT_REBOOT			= 0x10, // system exception reboot
	AVIOCTRL_EVENT_SDFAULT				= 0x11, // sd record exception

	AVIOCTRL_EVENT_VIDEO_SLEEP_START	= 0x20, // ø™ ºÀØæı
	AVIOCTRL_EVENT_VIDEO_SLEEP_END	    = 0x21, // ÀØæıΩ· ¯

	AVIOCTRL_EVENT_AUDIO_CRY_START	    = 0x22, // øﬁ£¨√ª”–Ω· ¯ ¬º˛£¨“ÚŒ™≤ª∫√≈–∂œ£¨¡ÌÕ‚5∑÷÷”ƒ⁄µƒÀ„Õ¨“ª¥Œøﬁ

	
}ENUM_EVENTTYPE;

// AVIOCTRL Record Type
typedef enum
{
	AVIOTCTRL_RECORDTYPE_OFF				= 0x00,
	AVIOTCTRL_RECORDTYPE_FULLTIME			= 0x01,
	AVIOTCTRL_RECORDTYPE_ALARM				= 0x02,
	AVIOTCTRL_RECORDTYPE_MANUAL			= 0x03,
}ENUM_RECORD_TYPE;

// AVIOCTRL Play Record Command
typedef enum 
{
	AVIOCTRL_RECORD_PLAY_PAUSE			= 0x00,
	AVIOCTRL_RECORD_PLAY_STOP			= 0x01,
	AVIOCTRL_RECORD_PLAY_STEPFORWARD	= 0x02, //now, APP no use
	AVIOCTRL_RECORD_PLAY_STEPBACKWARD	= 0x03, //now, APP no use
	AVIOCTRL_RECORD_PLAY_FORWARD		= 0x04, //now, APP no use
	AVIOCTRL_RECORD_PLAY_BACKWARD		= 0x05, //now, APP no use
	AVIOCTRL_RECORD_PLAY_SEEKTIME		= 0x06, //now, APP no use
	AVIOCTRL_RECORD_PLAY_END			= 0x07,
	AVIOCTRL_RECORD_PLAY_START			= 0x10,
}ENUM_PLAYCONTROL;

// AVIOCTRL Environment Mode
typedef enum
{
	AVIOCTRL_ENVIRONMENT_INDOOR_50HZ 	= 0x00,
	AVIOCTRL_ENVIRONMENT_INDOOR_60HZ	= 0x01,
	AVIOCTRL_ENVIRONMENT_OUTDOOR		= 0x02,
	AVIOCTRL_ENVIRONMENT_NIGHT			= 0x03,	
}ENUM_ENVIRONMENT_MODE;

// AVIOCTRL Video Flip Mode
typedef enum
{
	AVIOCTRL_VIDEOMODE_NORMAL 			= 0x00,
	AVIOCTRL_VIDEOMODE_FLIP				= 0x01,
	AVIOCTRL_VIDEOMODE_MIRROR			= 0x02,
	AVIOCTRL_VIDEOMODE_FLIP_MIRROR 		= 0x03,
}ENUM_VIDEO_MODE;

// AVIOCTRL PTZ Command Value
typedef enum 
{
	AVIOCTRL_PTZ_STOP					= 0,
	AVIOCTRL_PTZ_UP						= 1,
	AVIOCTRL_PTZ_DOWN					= 2,
	AVIOCTRL_PTZ_LEFT					= 3,
	AVIOCTRL_PTZ_LEFT_UP				= 4,
	AVIOCTRL_PTZ_LEFT_DOWN				= 5,
	AVIOCTRL_PTZ_RIGHT					= 6, 
	AVIOCTRL_PTZ_RIGHT_UP				= 7, 
	AVIOCTRL_PTZ_RIGHT_DOWN				= 8, 
	AVIOCTRL_PTZ_AUTO					= 9, 
	AVIOCTRL_PTZ_SET_POINT				= 10,
	AVIOCTRL_PTZ_CLEAR_POINT			= 11,
	AVIOCTRL_PTZ_GOTO_POINT				= 12,

	AVIOCTRL_PTZ_SET_MODE_START			= 13,
	AVIOCTRL_PTZ_SET_MODE_STOP			= 14,
	AVIOCTRL_PTZ_MODE_RUN				= 15,

	AVIOCTRL_PTZ_MENU_OPEN				= 16, 
	AVIOCTRL_PTZ_MENU_EXIT				= 17,
	AVIOCTRL_PTZ_MENU_ENTER				= 18,

	AVIOCTRL_PTZ_FLIP					= 19,
	AVIOCTRL_PTZ_START					= 20,

	AVIOCTRL_LENS_APERTURE_OPEN			= 21,
	AVIOCTRL_LENS_APERTURE_CLOSE		= 22,

	AVIOCTRL_LENS_ZOOM_IN				= 23, 
	AVIOCTRL_LENS_ZOOM_OUT				= 24,

	AVIOCTRL_LENS_FOCAL_NEAR			= 25,
	AVIOCTRL_LENS_FOCAL_FAR				= 26,

	AVIOCTRL_AUTO_PAN_SPEED				= 27,
	AVIOCTRL_AUTO_PAN_LIMIT				= 28,
	AVIOCTRL_AUTO_PAN_START				= 29,

	AVIOCTRL_PATTERN_START				= 30,
	AVIOCTRL_PATTERN_STOP				= 31,
	AVIOCTRL_PATTERN_RUN				= 32,

	AVIOCTRL_SET_AUX					= 33,
	AVIOCTRL_CLEAR_AUX					= 34,
	AVIOCTRL_MOTOR_RESET_POSITION		= 35,
}ENUM_PTZCMD;



/////////////////////////////////////////////////////////////////////////////
///////////////////////// Message Body Define ///////////////////////////////
/////////////////////////////////////////////////////////////////////////////

/*
IOTYPE_USER_IPCAM_START 				= 0x01FF,
IOTYPE_USER_IPCAM_STOP	 				= 0x02FF,
IOTYPE_USER_IPCAM_AUDIOSTART 			= 0x0300,
IOTYPE_USER_IPCAM_AUDIOSTOP 			= 0x0301,
IOTYPE_USER_IPCAM_SPEAKERSTART 			= 0x0350,
IOTYPE_USER_IPCAM_SPEAKERSTOP 			= 0x0351,
** @struct SMsgAVIoctrlAVStream
*/
typedef struct
{
	unsigned int channel; // Camera Index
	//unsigned char reserved[4];
	unsigned char EncodeType; /* VIDEO_TYPE , ∆‰÷–0=Œﬁ–ß, 0xff=‘§¿¿÷˜¬Î¡˜≤¢«“≤…”√µ±«∞÷µ */
	unsigned char FlowType;   //¬Î¬ ¿‡–Õ£¨1=∂®¬Î¬ £ª2=±‰¬Î¬ £ª0=Œﬁ–ß£¨0xff=∫ˆ¬‘£¨º¥≤…”√µ±«∞÷µ
	unsigned char FrameRate;  //÷°¬ 1-30,0=Œﬁ–ß£¨0xff=∫ˆ¬‘£¨º¥≤…”√µ±«∞÷µ
	unsigned char FlowRateMulti32K; //◊Ó¥Û¡˜¡ø,32kbpsµƒ±∂ ˝£¨1, 32k; 2, 64k... 255,  8160k, 0=Œﬁ–ß£¨0xff=∫ˆ¬‘£¨º¥≤…”√µ±«∞÷µ
} SMsgAVIoctrlAVStream;

#define VERSION_INFO_UNIT_LENGTH    64  // …˝º∂Œƒº˛÷–¥Ê∑≈µƒµ•∏ˆÕ∑–≈œ¢≥§∂»
typedef struct
{
	int EnableChannelFlag[4];		/* ∂®“Âø…”√”⁄RDT¥´ ‰Õ®µ¿, bit=1±Ì æÕ®µ¿ø…”√ */
	int VersionFileNum;				/* ∂®“Â”–∂‡…Ÿ∏ˆ∞Ê±æŒƒº˛–≈œ¢ */         
}SMsgAVIoctrlUpdateCheckReq;
	
typedef struct
{
    int result;                     /* ∑µªÿ «∑Òø……˝º∂∞Ê±æ 0: ∞Ê±æœ‡Õ¨≤ª…˝º∂£¨1: Ω®“È…˝º∂£¨2: ª˙–Õ≤ª∆•≈‰ , 3:…˝º∂Œƒº˛ ˝ƒø≤ª∂‘*/
    int EnableChannelFlag[4];       /* ∂®“Âø…”√”⁄RDT¥´ ‰Õ®µ¿, bit=1±Ì æÕ®µ¿ø…”√ */
    int VersionFileNum;             /* ∂®“Â”–∂‡…Ÿ∏ˆ∞Ê±æŒƒº˛–≈œ¢ */       
}SMsgAVIoctrlUpdateCheckRsp;

typedef struct
{
	int RDTChannelId;				/* client ��������RDT �����ͨ�����ȴ�device���� */
	int EnableChannelFlag[4];		/* ���������RDT����ͨ��, bit=1��ʾͨ������ */
}SMsgAVIoctrlUpdateReq;

typedef struct
{
	int result;						/* 0: ������ɣ� 1������ʧ�ܣ�ͨ�������ã�2������ʧ�ܣ��ļ����������Զ�Σ�, 3:�����ļ���Ŀ����*/
	int EnableChannelFlag[4];		/* ���������RDT����ͨ��, bit=1��ʾͨ������ */
}SMsgAVIoctrlUpdateRsp;

typedef struct
{
	unsigned char magic;	/* �̶�Ϊ��'$' 0x24 */
	unsigned char index:6;  /* ��6bit��ʾIdx,  */
	unsigned char flag:2;	/* ��2bit��0b00����ʾΪ��Ϣ��0b01����ʾΪ������Ƭ��0b10:��ʾ�����м�Ƭ��0b11:��ʾΪ����ĩβƬ  */
	unsigned short len;		/* ���ݻ���Ϣ���� */
}RdtHead;

typedef struct
{
    RdtHead Head;
    int Type;
    char DownLoadFileInfo[64];
    unsigned int StartOffset;	    /* 0: file head */
    unsigned int StopOffset;		/* 0xffffffff: file end */
}RdtMsgFileTransStartReq;

typedef struct
{
    RdtHead Head;
    int Type;
    int result;	                /* 0: ok, 1: file not exist, 2: open file err */
    char DownLoadFileInfo[64];
    unsigned int StartOffset;
    unsigned int StopOffset;		
}RdtMsgFileTransStartRsp;

typedef struct
{
    RdtHead Head; 	
    int Type;
}RdtMsgFileTransStopReq;

typedef struct
{
    RdtHead Head;
    int Type;
    int result;	/* 0: ok, 1: file not exist, 2: open file err */
}RdtMsgFileTransStopRsp;

#if 1
#define MY_FILE_TRANS_PKT_DATA_LEN	    1300
#define MY_FILE_TRANS_PKT_LEN	        1400
#define TRANS_FILE_RECEVIE_TRY_TIMES  3
typedef enum
{
    MY_FILE_TRANS_TYPE_REQ = 1,
    MY_FILE_TRANS_TYPE_RSP = 2,
    MY_FILE_TRANS_TYPE_STOP = 3,
}ENUM_MY_FILE_TRANS_CMD;
typedef enum
{
    MY_FILE_TRANS_FILE_HOME = 0,
    MY_FILE_TRANS_FILE_ROOTFS = 1,
}ENUM_TRANS_FILE_ID;
typedef struct
{
	unsigned char Msgtype;			/* 1: file rsp 3:file data trans 3: stop */
	unsigned char FileType;			/* 0: home 1:rootfs */
	unsigned short PktLen;
	unsigned int PktIdxInFile;		/* idx of filelen/pktlen */
	unsigned int PktBitmap[4];			/* bitmap */
}MyFileTransHead;
#endif

typedef struct
{
    int status;  /* 0�������У�1������ */
    int pecent;  /* ����״̬�ٷֱ� */
}SMsgAVIoctrlUpdatePercentRsp;

typedef struct
{
    unsigned int sch_starttime;  /* ������ʼʱ��*/
    unsigned int sch_endtime;  /* ��������ʱ�� */
}SChTimeINFO;//ethanluo


typedef enum
{
    RDT_TRANS_START_REQ = 1,
    RDT_TRANS_START_RSP = 2,
    RDT_TRANS_STOP_REQ = 3,
    RDT_TRANS_STOP_RSP = 4,  
}ENUM_RDT_CMD;

/*
IOTYPE_USER_IPCAM_GETSTREAMCTRL_REQ		= 0x0322,
** @struct SMsgAVIoctrlGetStreamCtrlReq
*/
typedef struct
{
	unsigned int channel;	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetStreamCtrlReq;

/*
IOTYPE_USER_IPCAM_SETSTREAMCTRL_REQ		= 0x0320,
IOTYPE_USER_IPCAM_GETSTREAMCTRL_RESP	= 0x0323,
** @struct SMsgAVIoctrlSetStreamCtrlReq, SMsgAVIoctrlGetStreamCtrlResq
*/
typedef struct
{
	unsigned int  channel;	// Camera Index
	unsigned char quality;	//refer to ENUM_QUALITY_LEVEL
	unsigned char reserved[3];
} SMsgAVIoctrlSetStreamCtrlReq, SMsgAVIoctrlGetStreamCtrlResq;

/*
IOTYPE_USER_IPCAM_SETSTREAMCTRL_RESP	= 0x0321,
** @struct SMsgAVIoctrlSetStreamCtrlResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetStreamCtrlResp;


/*
IOTYPE_USER_IPCAM_GETMOTIONDETECT_REQ	= 0x0326,
** @struct SMsgAVIoctrlGetMotionDetectReq
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetMotionDetectReq;


/*
IOTYPE_USER_IPCAM_GETSTREAMCTRL_DETAIL_REQ		= 0x0392,
** @struct SMsgAVIoctrlGetStreamCtrlDetailReq
*/
typedef struct
{
	unsigned int channel;	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetStreamCtrlDetailReq;

/*
IOTYPE_USER_IPCAM_GETSTREAMCTRL_DETAIL_RESP	= 0x0393,
** @struct SMsgAVIoctrlGetStreamCtrlDetailResq
*/
typedef struct
{
	unsigned int  channel;	// Camera Index
	unsigned int  width; 
	unsigned int  height; 
	unsigned int  frameRate;
	unsigned int  flowRate;
	unsigned int  width_a; 
	unsigned int  height_a; 
	unsigned int  frameRate_a;
	unsigned int  flowRate_a;
    unsigned int  reserved[4];	
} SMsgAVIoctrlGetStreamCtrlDetailResq;


/*
IOTYPE_USER_IPCAM_SETMOTIONDETECT_REQ		= 0x0324,
IOTYPE_USER_IPCAM_GETMOTIONDETECT_RESP		= 0x0327,
** @struct SMsgAVIoctrlSetMotionDetectReq, SMsgAVIoctrlGetMotionDetectResp
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned int sensitivity; 	// 0(Disabled) ~ 100(MAX):
								// index		sensitivity value
								// 0			0
								// 1			25
								// 2			50
								// 3			75
								// 4			100
}SMsgAVIoctrlSetMotionDetectReq, SMsgAVIoctrlGetMotionDetectResp;


/*
IOTYPE_USER_IPCAM_SETMOTIONDETECT_RESP	= 0x0325,
** @struct SMsgAVIoctrlSetMotionDetectResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetMotionDetectResp;



/*
IOTYPE_USER_IPCAM_GETMOTIONDETECT_DETAIL_REQ	= 0x038C,
** @struct SMsgAVIoctrlGetMotionDetectDetailReq
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetMotionDetectDetailReq;

/*
IOTYPE_USER_IPCAM_SETMOTIONDETECT_DETAIL_REQ		= 0x038a,
IOTYPE_USER_IPCAM_GETMOTIONDETECT_DETAIL_RESP		= 0x038d,
** @struct SMsgAVIoctrlSetMotionDetectDetailReq, SMsgAVIoctrlGetMotionDetectDetailResp
*/
typedef struct
{
    unsigned int  channel;		// camera index
    
    unsigned char md_enable;    /* 0 ���� 1 �ƶ����� 2�ƶ����ر� */    
    unsigned char motion_level; /* 0-5 ��0����������ߣ�5���*/
    unsigned char motion_GOP;   /* 1-50 */
	unsigned char rsv;

    unsigned int  bitmap[15];  /* �ƶ����20*15����,ÿ�����ֵĵ�20bit��Ч����������ж�Ӧbit0~bit19 
                                                           ���ϵ��£���Ӧbitmap[0]~bitmap[14] */
    char reserved[4];
}SMsgAVIoctrlSetMotionDetectDetailReq, SMsgAVIoctrlGetMotionDetectDetailResp;

/*
IOTYPE_USER_IPCAM_SETMOTIONDETECT_DETAIL_RESP	= 0x038b,
** @struct SMsgAVIoctrlSetMotionDetectDetailResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetMotionDetectDetailResp;


typedef struct
{
    unsigned char   cover_index;  /* 0-3 */
    unsigned char   cover_valid;  /* 0 �ڵ�������Ч��1 �ڵ�������Ч*/
    unsigned char   rsv[2];
    
    unsigned short  PTL_x; /* (Top-left point_x percent of width) x 1000 */
    unsigned short  PTL_y; /*( Top-left point_y percent of height) x 1000 */

    unsigned short  PBR_x; /* (Bottom-Right point_x percent of width) x 1000  */
    unsigned short  PBR_y; /* (Bottom-Right point_y percent of height) x 1000 */    
}SCOVER_t;

/*
IOTYPE_USER_IPCAM_GETCOVER_REQ	= 0x0384,
** @struct SMsgAVIoctrlGetCoverReq
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetCoverReq;

/*
IOTYPE_USER_IPCAM_SETCOVER_REQ		= 0x0382,
IOTYPE_USER_IPCAM_GETCOVER_RESP		= 0x0385,
** @struct SMsgAVIoctrlSetCoverReq, SMsgAVIoctrlGetCoverResp
*/
typedef struct
{
    unsigned int  channel;		// camera index
    
    unsigned char cover_enable; /* 0 ���� 1 �ڵ��� 2�ڵ��ر� */
    unsigned char rsv[3];

    SCOVER_t      cv[4]; /* �������4���ڵ����� */

    char reserved[4];
}SMsgAVIoctrlSetCoverReq, SMsgAVIoctrlGetCoverResp;


/*
IOTYPE_USER_IPCAM_SETCOVER_RESP	= 0x0383,
** @struct SMsgAVIoctrlSetCoverResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetCoverResp;

/* IOTYPE_USER_IPCAM_I_FRAME_REQ			= 0x0394, //«Î«ÛI÷°
 */
typedef struct
{
	unsigned int channel;		// camera index
	char reserved[4];
}SMsgAVIoctrlIFrameReq;

/* IOTYPE_USER_IPCAM_I_FRAME_RESP			= 0x0395,
 */
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	char reserved[4];
}SMsgAVIoctrlIFrameResp;

/*
IOTYPE_USER_IPCAM_GETSHARE_REQ		        = 0x0398,
** @struct SMsgAVIoctrlGetShareReq
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetShareReq;

/*
IOTYPE_USER_IPCAM_SETSHARE_REQ	     = 0x0396,
IOTYPE_USER_IPCAM_GETSHARE_RESP      = 0x0399,
** @struct SMsgAVIoctrlSetShareReq, SMsgAVIoctrlGetShareResp
*/
typedef struct
{
    unsigned int  channel;		// camera index
    
    unsigned char shareState; /* 0 ��ʾ�رչ�����1��ʾ�򿪹���  */
    unsigned char rsv[3];

    char reserved[4];
}SMsgAVIoctrlSetShareReq, SMsgAVIoctrlGetShareResp;


/*
IOTYPE_USER_IPCAM_SETSHARE_RESP	= 0x0397,
** @struct SMsgAVIoctrlSetShareResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetShareResp;


/*
IOTYPE_USER_IPCAM_DEVINFO_REQ			= 0x0330,
** @struct SMsgAVIoctrlDeviceInfoReq
*/
typedef struct
{
	unsigned char reserved[4];
}SMsgAVIoctrlDeviceInfoReq;


/*
IOTYPE_USER_IPCAM_DEVINFO_RESP			= 0x0331,
** @struct SMsgAVIoctrlDeviceInfo
*/
typedef struct
{
	unsigned char model[16];	// IPCam mode
	unsigned char vendor[16];	// IPCam manufacturer
	unsigned int version;		// IPCam firmware version	ex. v1.2.3.4 => 0x01020304;  v1.0.0.2 => 0x01000002
	unsigned int channel;		// Camera index
	unsigned int total;			// 0: No cards been detected or an unrecognizeable sdcard that could not be re-formatted.
								// -1: if camera detect an unrecognizable sdcard, and could be re-formatted
								// otherwise: return total space size of sdcard (MBytes)								
								
	unsigned int free;			// Free space size of sdcard (MBytes)
#if 0
	unsigned char reserved[8];	// reserved
#else
    unsigned char valid;         //0x7E 有效
    unsigned char videoquality;  //0: unknown, 1: max, 2: high, 3: middle, 4:low, 5: min
    unsigned char videoflips;    //0: no move, 1: vertical, 2: horizon, 3:vertical and horizon
    unsigned char envmode;      //0: indoor 50Hz, 1:indoor 60Hz, 2,outdoor, 3:night visison
    unsigned char motionsensitivity; //0:disbale,1:low, 2:middle, 3: high, 4, max
    unsigned char alarmmode;    // 0:silent, 1:audio, 2: vibrate, 3: audio and vibrate；
    unsigned char recordmode;   //0:close, 1:full time, 2, event trigger
    unsigned char audioCodec;  // refer ENUM_CODECID,  MEDIA_CODEC_AUDIO_G726      = 0x8F,
#endif
}SMsgAVIoctrlDeviceInfoResp;

/*
IOTYPE_USER_IPCAM_SETPASSWORD_REQ		= 0x0332,
** @struct SMsgAVIoctrlSetPasswdReq
*/
typedef struct
{
	char oldpasswd[32];			// The old security code
	char newpasswd[32];			// The new security code
}SMsgAVIoctrlSetPasswdReq;


/*
IOTYPE_USER_IPCAM_SETPASSWORD_RESP		= 0x0333,
** @struct SMsgAVIoctrlSetPasswdResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetPasswdResp;


/*
IOTYPE_USER_IPCAM_LISTWIFIAP_REQ		= 0x0340,
** @struct SMsgAVIoctrlListWifiApReq
*/
typedef struct
{
	unsigned char reserved[4];
}SMsgAVIoctrlListWifiApReq;

typedef struct
{
	char ssid[32]; 				// WiFi ssid
	char mode;	   				// refer to ENUM_AP_MODE
	char enctype;  				// refer to ENUM_AP_ENCTYPE
	char signal;   				// signal intensity 0--100%
	char status;   				// 0 : invalid ssid or disconnected
								// 1 : connected with default gateway
								// 2 : unmatched password
								// 3 : weak signal and connected
								// 4 : selected:
								//		- password matched and
								//		- disconnected or connected but not default gateway
}SWifiAp;

/*
IOTYPE_USER_IPCAM_LISTWIFIAP_RESP		= 0x0341,
** @struct SMsgAVIoctrlListWifiApResp
*/
typedef struct
{
	unsigned int number; // MAX number: 1024(IOCtrl packet size) / 36(bytes) = 28
	SWifiAp stWifiAp[1];
}SMsgAVIoctrlListWifiApResp;

/*
IOTYPE_USER_IPCAM_SETWIFI_REQ			= 0x0342,
** @struct SMsgAVIoctrlSetWifiReq
*/
typedef struct
{
	unsigned char ssid[32];			//WiFi ssid
	unsigned char password[32];		//if exist, WiFi password
	unsigned char mode;				//refer to ENUM_AP_MODE
	unsigned char enctype;			//refer to ENUM_AP_ENCTYPE
	unsigned char reserved[2];    
	int timeoffset;
	unsigned char reserved1[4];    
}SMsgAVIoctrlSetWifiReq;

//IOTYPE_USER_IPCAM_SETWIFI_REQ_2		= 0x0346,
typedef struct
{
	unsigned char ssid[32];		// WiFi ssid
	unsigned char password[64];	// if exist, WiFi password
	unsigned char mode;			// refer to ENUM_AP_MODE
	unsigned char enctype;		// refer to ENUM_AP_ENCTYPE
	unsigned char reserved[10];
}SMsgAVIoctrlSetWifiReq2;

/*
IOTYPE_USER_IPCAM_SETWIFI_RESP			= 0x0343,
** @struct SMsgAVIoctrlSetWifiResp
*/
typedef struct
{
	int result; //0: wifi connected; 1: failed to connect
	unsigned char reserved[4];
}SMsgAVIoctrlSetWifiResp;

/*
IOTYPE_USER_IPCAM_GETWIFI_REQ			= 0x0344,
** @struct SMsgAVIoctrlGetWifiReq
*/
typedef struct
{
	unsigned char reserved[4];
}SMsgAVIoctrlGetWifiReq;

/*
IOTYPE_USER_IPCAM_GETWIFI_RESP			= 0x0345,
** @struct SMsgAVIoctrlGetWifiResp //if no wifi connected, members of SMsgAVIoctrlGetWifiResp are all 0
*/
typedef struct
{
	unsigned char ssid[32];		// WiFi ssid
	unsigned char password[32]; // WiFi password if not empty
	unsigned char mode;			// refer to ENUM_AP_MODE
	unsigned char enctype;		// refer to ENUM_AP_ENCTYPE
	unsigned char signal;		// signal intensity 0--100%
	unsigned char status;		// 1: connected by IPCamera
}SMsgAVIoctrlGetWifiResp;

//changed: WI-FI Password 32bit Change to 64bit 
//IOTYPE_USER_IPCAM_GETWIFI_RESP_2    = 0x0347,
typedef struct
{
 unsigned char ssid[32];	 // WiFi ssid
 unsigned char password[64]; // WiFi password if not empty
 unsigned char mode;	// refer to ENUM_AP_MODE
 unsigned char enctype; // refer to ENUM_AP_ENCTYPE
 unsigned char signal;  // signal intensity 0--100%
 unsigned char status;  // refer to "status" of SWifiAp
}SMsgAVIoctrlGetWifiResp2;

/*
IOTYPE_USER_IPCAM_GETRECORD_REQ			= 0x0312,
** @struct SMsgAVIoctrlGetRecordReq
*/
typedef struct
{
	unsigned int channel; // Camera Index
	//unsigned char reserved[4];//ethanluo
	int alarmType;
}SMsgAVIoctrlGetRecordReq;

/*
IOTYPE_USER_IPCAM_SETRECORD_REQ			= 0x0310,
IOTYPE_USER_IPCAM_GETRECORD_RESP		= 0x0313,
** @struct SMsgAVIoctrlSetRecordReq, SMsgAVIoctrlGetRecordResq
*/
typedef struct
{
	unsigned int channel;		// Camera Index
	unsigned int recordType;	// Refer to ENUM_RECORD_TYPE
	unsigned char reserved[4];
}SMsgAVIoctrlSetRecordReq, SMsgAVIoctrlGetRecordResq;

/*
IOTYPE_USER_IPCAM_SETRECORD_REQ	= 0x0310,
** @struct SMsgAVIoctrlGetSCHReq
*/
typedef struct
{
	SChTimeINFO sChTime[2][4];
}SMsgAVIoctrlGetSCHReq;//ethanluo

typedef struct
{
	SMsgAVIoctrlGetRecordResq sGetRecord;
	SMsgAVIoctrlGetSCHReq sChTime;
}SMsgAVIoctrlGetSCHResp;//ethanluo


/*
IOTYPE_USER_IPCAM_SETRECORD_RESP		= 0x0311,
** @struct SMsgAVIoctrlSetRecordResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetRecordResp;


/*
IOTYPE_USER_IPCAM_GETRCD_DURATION_REQ	= 0x0316,
** @struct SMsgAVIoctrlGetRcdDurationReq
*/
typedef struct
{
	unsigned int channel; // Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetRcdDurationReq;

/*
IOTYPE_USER_IPCAM_SETRCD_DURATION_REQ	= 0x0314,
IOTYPE_USER_IPCAM_GETRCD_DURATION_RESP  = 0x0317,
** @struct SMsgAVIoctrlSetRcdDurationReq, SMsgAVIoctrlGetRcdDurationResp
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned int presecond; 	// pre-recording (sec)
	unsigned int durasecond;	// recording (sec)
}SMsgAVIoctrlSetRcdDurationReq, SMsgAVIoctrlGetRcdDurationResp;


/*
IOTYPE_USER_IPCAM_SETRCD_DURATION_RESP  = 0x0315,
** @struct SMsgAVIoctrlSetRcdDurationResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetRcdDurationResp;


typedef struct
{
	unsigned short year;	// The number of year.
	unsigned char month;	// The number of months since January, in the range 1 to 12.
	unsigned char day;		// The day of the month, in the range 1 to 31.
	unsigned char wday;		// The number of days since Sunday, in the range 0 to 6. (Sunday = 0, Monday = 1, ...)
	unsigned char hour;     // The number of hours past midnight, in the range 0 to 23.
	unsigned char minute;   // The number of minutes after the hour, in the range 0 to 59.
	unsigned char second;   // The number of seconds after the minute, in the range 0 to 59.
}STimeDay;

/*
IOTYPE_USER_IPCAM_LISTEVENT_REQ			= 0x0318,
** @struct SMsgAVIoctrlListEventReq
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	STimeDay stStartTime; 		// Search event from ...
	STimeDay stEndTime;	  		// ... to (search event)
	unsigned char event;  		// event type, refer to ENUM_EVENTTYPE
	unsigned char status; 		// 0x00: Recording file exists, Event unreaded
								// 0x01: Recording file exists, Event readed
								// 0x02: No Recording file in the event
	unsigned char reserved[2];
}SMsgAVIoctrlListEventReq;


typedef struct
{
	STimeDay stTime;
	unsigned char event;
	unsigned char status;	// 0x00: Recording file exists, Event unreaded
							// 0x01: Recording file exists, Event readed
							// 0x02: No Recording file in the event
	//unsigned char reserved[2];
	unsigned short length;
}SAvEvent;
	
/*
IOTYPE_USER_IPCAM_LISTEVENT_RESP		= 0x0319,
** @struct SMsgAVIoctrlListEventResp
*/
typedef struct
{
	unsigned int  channel;		// Camera Index
	unsigned int  total;		// Total event amount in this search session
	unsigned char index;		// package index, 0,1,2...; 
								// because avSendIOCtrl() send package up to 1024 bytes one time, you may want split search results to serveral package to send.
	unsigned char endflag;		// end flag; endFlag = 1 means this package is the last one.
	unsigned char count;		// how much events in this package
	unsigned char reserved[1];
	SAvEvent stEvent[1];		// The first memory address of the events in this package
}SMsgAVIoctrlListEventResp;

#define AVIOCTRL_MAX_REC_NUM_IN_RSP 84 /* ∏˘æ›SMsgAVIoctrlListEventResp∫Õ◊Ó¥Û1024Ω¯––º∆À„, (1024-12)/12 = 84 */

/*
IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL 	= 0x031A,
** @struct SMsgAVIoctrlPlayRecord
*/
typedef struct
{
	unsigned int channel;	// Camera Index
	unsigned int command;	// play record command. refer to ENUM_PLAYCONTROL
	unsigned int Param;		// command param, that the user defined
	STimeDay stTimeDay;		// Event time from ListEvent
	unsigned char reserved[4];
} SMsgAVIoctrlPlayRecord;

/*
IOTYPE_USER_IPCAM_RECORD_PLAYCONTROL_RESP 	= 0x031B,
** @struct SMsgAVIoctrlPlayRecordResp
*/
typedef struct
{
	unsigned int command;	// Play record command. refer to ENUM_PLAYCONTROL
	unsigned int result; 	// Depends on command
							//when is AVIOCTRL_RECORD_PLAY_START:
							//	result>=0   real channel no used by device for playback
							//	result <0	error
							//			-1	playback error
							//			-2	exceed max allow client amount
	unsigned char reserved[4];
} SMsgAVIoctrlPlayRecordResp; // only for play record start command


/*
IOTYPE_USER_IPCAM_PTZ_COMMAND	= 0x1001,	// P2P Ptz Command Msg 
** @struct SMsgAVIoctrlPtzCmd
*/
typedef struct
{
	unsigned char control;	// PTZ control command, refer to ENUM_PTZCMD
	unsigned char speed;	// PTZ control speed
	unsigned char point;	// no use in APP so far. preset position, for RS485 PT
	unsigned char limit;	// no use in APP so far
	unsigned char aux;		// no use in APP so far. auxiliary switch, for RS485 PT
	unsigned char channel;	// camera index
	unsigned char reserve[2];
} SMsgAVIoctrlPtzCmd;

/*
IOTYPE_USER_IPCAM_IR_SWITCH_CMD	= 0x1200,	// IR switch command, add by zlq
** @struct SMsgAVIoctrlIRSwitchCmd
*/
typedef struct
{
    unsigned char channel;	// camera index
	unsigned char control;	// 0 off, 1 on
	unsigned char reserve[2];
} SMsgAVIoctrlIRSwitchCmd;

/*
IOTYPE_USER_IPCAM_EVENT_REPORT	= 0x1FFF,	// Device Event Report Msg 
*/
/** @struct SMsgAVIoctrlEvent
 */
typedef struct
{
	STimeDay stTime;
	unsigned long time; 	// UTC Time
	unsigned int  channel; 	// Camera Index
	unsigned int  event; 	// event type, refer to ENUM_EVENTTYPE
	unsigned char reserved[4];
} SMsgAVIoctrlEvent;


#if 0

/* 	IOTYPE_USER_IPCAM_GET_EVENTCONFIG_REQ	= 0x0400,	// Get Event Config Msg Request 
 */
/** @struct SMsgAVIoctrlGetEventConfig
 */
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned char   externIoOutIndex; //extern out index: bit0->io0 bit1->io1 ... bit7->io7;=1: get this io value or not get
    unsigned char   externIoInIndex;  //extern in index: bit0->io0 bit1->io1 ... bit7->io7; =1: get this io value or not get
	char reserved[2];
} SMsgAVIoctrlGetEventConfig;
 
/*
	IOTYPE_USER_IPCAM_GET_EVENTCONFIG_RESP	= 0x0401,	// Get Event Config Msg Response 
	IOTYPE_USER_IPCAM_SET_EVENTCONFIG_REQ	= 0x0402,	// Set Event Config Msg req 
*/
/* @struct SMsgAVIoctrlSetEventConfig
 * @struct SMsgAVIoctrlGetEventCfgResp
 */
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned char mail;			// enable send email
	unsigned char ftp;			// enable ftp upload photo
	unsigned char   externIoOutStatus;   // enable extern io output //bit0->io0 bit1->io1 ... bit7->io7; 1:on; 0:off
	unsigned char   p2pPushMsg;			 // enable p2p push msg
	unsigned char   externIoInStatus;    // enable extern io input  //bit0->io0 bit1->io1 ... bit7->io7; 1:on; 0:off
	char            reserved[3];
} SMsgAVIoctrlSetEventConfig, SMsgAVIoctrlGetEventCfgResp;

/*
	IOTYPE_USER_IPCAM_SET_EVENTCONFIG_RESP	= 0x0403,	// Set Event Config Msg resp 
*/
/** @struct SMsgAVIoctrlSetEventCfgResp
 */
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned int result;	// 0: success; otherwise: failed.
}SMsgAVIoctrlSetEventCfgResp;

#endif

/*
IOTYPE_USER_IPCAM_GET_ALARMMODE_REQ         = 0x0404,	// Get Alarm Mode Request
IOTYPE_USER_IPCAM_GET_ALARMMODE_RESP		= 0x0405,	// Get Alarm Mode Response
*/
typedef struct
{
    unsigned int channel;	// camera index
} SMsgAVIoctrlGetAlarmModeReq;


typedef struct
{
    unsigned int channel;	// camera index
    unsigned char mode;	  // 0:silent, 1:audio, 2:vibrate, 3: both audio and vibrate
    unsigned char reserve[3];
} SMsgAVIoctrlGetAlarmModeResp;

/*
IOTYPE_USER_IPCAM_SET_ALARMMODE_REQ         = 0x0406,	// Set Alarm Mode req
*/
typedef struct
{
    unsigned int channel;	// camera index
    unsigned char mode;	  // 0:silent, 1:audio, 2:vibrate, 3: both audio and vibrate
    unsigned char reserve[3];
} SMsgAVIoctrlSetAlarmModeReq;

/*
IOTYPE_USER_IPCAM_SET_ALARMMODE_RESP		= 0x0407,	// Set Alarm Mode resp
*/
typedef struct
{
    unsigned int channel; 	// Camera Index
    unsigned char result;	// 0: success; otherwise: failed.
    unsigned char reserve[3];
}SMsgAVIoctrlSetAlarmModeResp;


/*
IOTYPE_USER_IPCAM_SET_ENVIRONMENT_REQ		= 0x0360,
** @struct SMsgAVIoctrlSetEnvironmentReq
*/
typedef struct
{
	unsigned int channel;		// Camera Index
	unsigned char mode;			// refer to ENUM_ENVIRONMENT_MODE
	unsigned char reserved[3];
}SMsgAVIoctrlSetEnvironmentReq;


/*
IOTYPE_USER_IPCAM_SET_ENVIRONMENT_RESP		= 0x0361,
** @struct SMsgAVIoctrlSetEnvironmentResp
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned char result;		// 0: success; otherwise: failed.
	unsigned char reserved[3];
}SMsgAVIoctrlSetEnvironmentResp;


/*
IOTYPE_USER_IPCAM_GET_ENVIRONMENT_REQ		= 0x0362,
** @struct SMsgAVIoctrlGetEnvironmentReq
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetEnvironmentReq;

/*
IOTYPE_USER_IPCAM_GET_ENVIRONMENT_RESP		= 0x0363,
** @struct SMsgAVIoctrlGetEnvironmentResp
*/
typedef struct
{
	unsigned int channel; 		// Camera Index
	unsigned char mode;			// refer to ENUM_ENVIRONMENT_MODE
	unsigned char reserved[3];
}SMsgAVIoctrlGetEnvironmentResp;


/*
IOTYPE_USER_IPCAM_SET_VIDEOMODE_REQ			= 0x0370,
** @struct SMsgAVIoctrlSetVideoModeReq
*/
typedef struct
{
	unsigned int channel;	// Camera Index
	unsigned char mode;		// refer to ENUM_VIDEO_MODE
	unsigned char reserved[3];
}SMsgAVIoctrlSetVideoModeReq;


/*
IOTYPE_USER_IPCAM_SET_VIDEOMODE_RESP		= 0x0371,
** @struct SMsgAVIoctrlSetVideoModeResp
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char result;	// 0: success; otherwise: failed.
	unsigned char reserved[3];
}SMsgAVIoctrlSetVideoModeResp;


/*
IOTYPE_USER_IPCAM_GET_VIDEOMODE_REQ			= 0x0372,
** @struct SMsgAVIoctrlGetVideoModeReq
*/
typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetVideoModeReq;


/*
IOTYPE_USER_IPCAM_GET_VIDEOMODE_RESP		= 0x0373,
** @struct SMsgAVIoctrlGetVideoModeResp
*/
typedef struct
{
	unsigned int  channel; 	// Camera Index
	unsigned char mode;		// refer to ENUM_VIDEO_MODE
	unsigned char reserved[3];
}SMsgAVIoctrlGetVideoModeResp;


/*
/IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_REQ			= 0x0380,
** @struct SMsgAVIoctrlFormatExtStorageReq
*/
typedef struct
{
	unsigned int storage; 	// Storage index (ex. sdcard slot = 0, internal flash = 1, ...)
	unsigned char reserved[4];
}SMsgAVIoctrlFormatExtStorageReq;

/*
/IOTYPE_USER_IPCAM_VIDEO_REPORT			= 0x1100,
  IOTYPE_USER_IPCAM_AUDIO_REPORT               = 0x1101,

** @struct SMsgAVIoctrlReport
*/
typedef struct
{
	unsigned int  channel; 		// Camera Index
	unsigned int  startTime; 	// Search event from ...
	unsigned int  endTime;	  	// ‘› ±√ª”√
	unsigned char event;  		// event type, refer to ENUM_EVENTTYPE
	unsigned char status; 		// ±£¡Ù
	unsigned char reserved[2];
	unsigned int  rsv[4];
}SMsgAVIoctrlReport;


/*
IOTYPE_USER_IPCAM_FORMATEXTSTORAGE_REQ		= 0x0381,
** @struct SMsgAVIoctrlFormatExtStorageResp
*/
typedef struct
{
	unsigned int  storage; 	// Storage index
	unsigned char result;	// 0: success;
							// -1: format command is not supported.
							// otherwise: failed.
	unsigned char reserved[3];
}SMsgAVIoctrlFormatExtStorageResp;


typedef struct
{
	unsigned short index;		// the stream index of camera
	unsigned short channel;		// the channel index used in AVAPIs, that is ChID in avServStart2(...,ChID)
	char reserved[4];
}SStreamDef;


/*	IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_REQ			= 0x0328,
 */
typedef struct
{
	unsigned char reserved[4];
}SMsgAVIoctrlGetSupportStreamReq;


/*	IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_RESP			= 0x0329,
 */
typedef struct
{
	unsigned int number; 		// the quanity of supported audio&video stream or video stream
	SStreamDef streams[1];
}SMsgAVIoctrlGetSupportStreamResp;


/* IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ			= 0x032A, //used to speak. but once camera is connected by App, send this at once.
 */
typedef struct
{
	unsigned int channel;		// camera index
	char reserved[4];
}SMsgAVIoctrlGetAudioOutFormatReq;

/* IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_RESP			= 0x032B,
 */
typedef struct
{
	unsigned int channel;		// camera index
	int format;					// refer to ENUM_CODECID in AVFRAMEINFO.h
	char reserved[4];
}SMsgAVIoctrlGetAudioOutFormatResp;


/* IOTYPE_USER_IPCAM_I_FRAME_REQ			= 0x0394, //ￇ￫ￇ￳Iￖﾡ
  */
typedef struct
{
	unsigned int channel;		// camera index
	char reserved[4];
}SMsgAVIoctrlReceiveFirstIFrame;

/* IOTYPE_USER_IPCAM_GET_FLOWINFO_REQ              = 0x390
 */
typedef struct
{
	unsigned int channel;			// camera index
	unsigned int collect_interval;	// seconds of interval to collect flow information
									// send 0 indicates stop collecting.
}SMsgAVIoctrlGetFlowInfoReq;

/* IOTYPE_USER_IPCAM_GET_FLOWINFO_RESP            = 0x391
 */
typedef struct
{
	unsigned int channel;			// camera index
	unsigned int collect_interval;	// seconds of interval client will collect flow information
}SMsgAVIoctrlGetFlowInfoResp;

/* IOTYPE_USER_IPCAM_CURRENT_FLOWINFO              = 0x392
 */
typedef struct
{
	unsigned int channel;						// camera index
	unsigned int total_frame_count;				// Total frame count in the specified interval
	unsigned int lost_incomplete_frame_count;	// Total lost and incomplete frame count in the specified interval
	unsigned int total_expected_frame_size;		// Total expected frame size from avRecvFrameData2()
	unsigned int total_actual_frame_size;		// Total actual frame size from avRecvFrameData2()
	unsigned int timestamp_ms;					// Timestamp in millisecond of this report.
	char reserved[8];
}SMsgAVIoctrlCurrentFlowInfo;

/* IOTYPE_USER_IPCAM_GET_TIMEZONE_REQ               = 0x3A0
 * IOTYPE_USER_IPCAM_GET_TIMEZONE_RESP              = 0x3A1
 * IOTYPE_USER_IPCAM_SET_TIMEZONE_REQ               = 0x3B0
 * IOTYPE_USER_IPCAM_SET_TIMEZONE_RESP              = 0x3B1
 */

typedef struct
{
    int channel;
}SMsgAVIoctrlGetTimeZoneReq;


typedef struct
{
	int cbSize;							// the following package size in bytes, should be sizeof(SMsgAVIoctrlTimeZone)
	int nIsSupportTimeZone;				// device is support TimeZone or not, 1: Supported, 0: Unsupported.
	int nGMTDiff;						// the difference between GMT in hours
	char szTimeZoneString[256];			// the timezone description string in multi-bytes char format
}SMsgAVIoctrlSetTimeZoneReq,SMsgAVIoctrlGetTimeZoneResp;

typedef struct
{
    int channel;
    int status; //0: sucess,1:fail
}SMsgAVIoctrlSetTimeZoneResp;

/* IOTYPE_USER_IPCAM_GET_TIME_REQ               = 0x3A2
 * IOTYPE_USER_IPCAM_GET_TIME_RESP              = 0x3A3
 * IOTYPE_USER_IPCAM_SET_TIME_REQ               = 0x3B2
 * IOTYPE_USER_IPCAM_SET_TIME_RESP              = 0x3B3
 */

typedef struct
{
	int cbSize;                         //
	int utcTime;                        //
    int nIsSupportTimeZone;				// device is support TimeZone or not, 1: Supported, 0: Unsupported.
	int nGMTDiff;						// the difference between GMT in hours
}SMsgAVIoctrlSystemTime;


/*Define for Pet Feed*/
//IOTYPE_USER_IPCAM_PET_FEED_REQ                  = 0X1260, //maxwell
//IOTYPE_USER_IPCAM_PET_FEED_RSP                  = 0X1261, //maxwell

typedef struct
{
    unsigned int  gram;
}SMsgIoctrlPetFeedReq;

//IOTYPE_USER_IPCAM_PET_LIGHT_REQ                 = 0X1262, //maxwell
//IOTYPE_USER_IPCAM_PET_LIGHT_RSP                 = 0X1263, //maxwell

typedef struct
{
    unsigned char action;   //0=off, 1=on
    unsigned char resv[3];
}SMsgIoctrlPetLightReq;

typedef struct
{
    unsigned char status;   //0=off, 1=on
    unsigned char resv[3];
}SMsgIoctrlPetLightResp;

//IOTYPE_USER_IPCAM_PET_ACTIVITY_REP_REQ          = 0X1264, //maxwell

typedef struct
{
    char uid[20];               //Unique ID of feed device. 20 bytes length from UBIC Platform.
    unsigned int time;          //UTC seconds since 1970-1-1 00:00:00
    unsigned int food;          //Food in gram.
    unsigned int playcal;       //Play in calorie.
    unsigned int activecal;     //Active in calorie
    unsigned int rest;          //Rest in calorie
}SMsgIoctrlPetActivityReport;

//IOTYPE_USER_IPCAM_PET_FEED_REP_REQ         = 0X1265, //maxwell
typedef struct
{
    char uid[20];               //Unique ID of feed device. 20 bytes length from UBIC Platform.
    unsigned int time;          //UTC seconds since 1970-1-1 00:00:00
    unsigned int amount;
}SMsgIoctrlPetFeedReport;


/*
  IOTYPE_USER_IPCAM_GET_ADVANCESETTINGS_REQ   = 0x3C0,
  IOTYPE_USER_IPCAM_GET_ADVANCESETTINGS_RESP  = 0x3C1,
 */
typedef struct
{
    unsigned int channel;		// camera index
}SMsgAVIoctrlGetAdvanceSettingReq;


#define DEVICE_CAP_PTZ          0x1 << 0
#define DEVICE_CAP_PTZ_PRESET   0x1 << 1
#define DEVICE_CAP_PTZ_ZOOM     0x1 << 2
#define DEVICE_CAP_PTZ_CRUISE   0x1 << 3

#define DEVICE_CAP_SENS_TEMP    0x1 << 4
#define DEVICE_CAP_SENS_PIR     0x1 << 5
#define DEVICE_CAP_SENS_IR      0x1 << 6

#define DEVICE_CAP_SENS_HUMITY  0x1 << 7
#define DEVICE_CAP_SENS_SMOKE   0x1 << 8
#define DEVICE_CAP_SENS_MAGNET  0x1 << 9

typedef struct
{
   
    unsigned char model[16];	// IPCam mode
    unsigned char vendor[16];	// IPCam manufacturer
    unsigned int version;		// IPCam firmware version	ex. v1.2.3.4 => 0x01020304;  v1.0.0.2 => 0x01000002
    unsigned int channel;		// Camera index
    unsigned int total;			// 0: No cards been detected or an unrecognizeable sdcard that could not be re-formatted.
    // -1: if camera detect an unrecognizable sdcard, and could be re-formatted
    // otherwise: return total space size of sdcard (MBytes)
    
    unsigned int free;			// Free space size of sdcard (MBytes)
    
    unsigned char valid;         //0x7E 有效
    unsigned char videoquality;  //0: unknown, 1: max, 2: high, 3: middle, 4:low, 5: min
    unsigned char videoflips;    //0: no move, 1: vertical, 2: horizon, 3:vertical and horizon
    unsigned char envmode;      //0: indoor 50Hz, 1:indoor 60Hz, 2,outdoor, 3:night visison
    
    unsigned char motionsensitivity; //0:disbale,1:low, 2:middle, 3: high, 4, max
    unsigned char alarmmode;    // 0:silent, 1:audio, 2: vibrate, 3: audio and vibrate；
    unsigned char recordmode;   //0:close, 1:full time, 2, event trigger
    unsigned char audioCodec;  // refer ENUM_CODECID,  MEDIA_CODEC_AUDIO_G726      = 0x8F,
    
    unsigned char pirsetting;
    unsigned char irsetting;
    unsigned char speakervolume;
    unsigned char micvolume;
    
    unsigned short Xstep_total;
    unsigned short Xstep_pos;

    unsigned short Ystep_total;
    unsigned short Ystep_pos;

    unsigned char zoomsetting;
    char nGMTDiff;
    unsigned char osdEnable;   //0: osd off,1: osd on, max indicate 8 osd items, bit define(0x01<<index of osd item);
    unsigned char resv[13];
    
    unsigned char preset[16];
    
    unsigned int capability;  //cap function
    unsigned int cap_ext[3];  //cap function
}SMsgAVIoctrlGetAdvanceSettingResp;


/*IOTYPE_USER_IPCAM_GETTEMPERATURE_REQ          = 0X1239, //maxwell
IOTYPE_USER_IPCAM_GETTEMPERATURE_RSP            = 0X123A, //maxwell
*/
typedef struct
{
    unsigned int channel;		// camera index
}SMsgAVIoctrlGetTemperatureReq;

typedef struct
{
    unsigned int channel;	// camera index
    short   temperature;    //signed value
    unsigned char type;     //0: Celsius 摄氏, 1: fahrenheit 华氏；华氏度(℉)=摄氏度(℃)×1.8+32
    unsigned char resv;
}SMsgAVIoctrlGetTemperatureResp;

#define MAX_FILE_NAME_SIZE 32
#define MAX_PATH_NAME_SIZE 128
typedef struct
{
    unsigned int  filesize;
    unsigned char flag;   //0:file, 1:Directory
    unsigned char resv[2];
    unsigned char filenamesize;
    char filename[MAX_FILE_NAME_SIZE];
    unsigned int  createtime;   //file create time,UTC second
    unsigned int  updatetime;   //file last update time,UTC second
}SFileInfo;

/*
IOTYPE_USER_FILE_LIST_REQ                       = 0X1300, //maxwell
IOTYPE_USER_FILE_LIST_RSP                       = 0X1301, //maxwell
*/
//return all files as starttime and endtime are zero
typedef struct
{
    unsigned int  channel;		// Camera Index
    unsigned char resv[3];
    unsigned char pathnamesize;
    char pathname[MAX_PATH_NAME_SIZE];
    unsigned int  startTime;   //search begin time,UTC second
    unsigned int  endtime;     //search end update time,UTC second
}SMsgFileIoctrlListFileReq;

typedef struct
{
    unsigned int  channel;		// Camera Index
    unsigned int  total;		// Total file amount in this directory
    unsigned int  index;		// package index, 0,1,2...;
    // because avSendIOCtrl() send package up to 1024 bytes one time, you may want split search results to serveral package to send.
    unsigned char endflag;		// end flag; endFlag = 1 means this package is the last one.
    unsigned char count;		// how much fileinfo in this package,MAX number: 1024(IOCtrl packet size) / 80(bytes) = 12
    unsigned char resv[2];
    SFileInfo stFileInfo[1];
}SMsgFileIoctrlListFileResp;

/*20141217 add define for file transfer*/

typedef enum{
    FILE_TRANS_CMD_NULL,
    FILE_TRANS_CMD_START,
    FILE_TRANS_CMD_FINISH,
    FILE_TRANS_CMD_PAUSE,
    FILE_TRANS_CMD_RESUME,
    FILE_TRANS_CMD_STOP,   //cancel
    FILE_TRANS_CMD_START_SEND
}ENUM_FILE_TRANS_CMD;


typedef struct
{
    char            status;             //0x00：success，0x01:fail, 0x02... errcode
    unsigned char   ubicChannel;				//UBIC 传输通道
    unsigned char   segmentindex;       //请求分段编号
    unsigned char   resv;                
    unsigned int    segmentoffset;
    unsigned int    segmentsize;
}FileSegmentInfo;

//
/*Device 端文件下载处理流程， 参照playback处理逻辑
*  1. 在channel 0上收到 IOTYPE_USER_FILE_DOWNLOAD_REQ（START）
        创建FileServer_service线程， 在FileServer_service线程里
         1a. fileavid = avServStart
         1b. 在fileavid上创建数据发送FileDataSend_thread
         1c. 在fileavid上收ioctl，收到IOTYPE_USER_IPCAM_START消息后，使能FileDataSend_thread进行数据发送
         1d。在fileavid上ioctl， 收到IOTYPE_USER_FILE_TRANS_PKT_ACK或NAK发送需要重传的数据
*
*/

/*
IOTYPE_USER_FILE_DOWNLOAD_REQ                   = 0X1302, //maxwell
IOTYPE_USER_FILE_DOWNLOAD_RSP                   = 0X1303, //maxwell
*/
typedef struct
{
    unsigned char command;	 	//see ENUM_FILE_TRANS_CMD
    unsigned char segments;     //请求同时下载/上传的线程数（分块传输数）
    unsigned short pktSize;     //请求每个发送数据包的数据大小，最后一个包可能小于此值
    unsigned char resv[3];
    unsigned char filenamesize;
    char    filename[MAX_FILE_NAME_SIZE];
    FileSegmentInfo fileSegment[1]; //one or more FileSegmentInfo append with   
}SMsgFileIoctrlDownloadReq;

typedef struct
{
    unsigned char command;	 	//see ENUM_FILE_TRANS_CMD
    unsigned char segments;     //允许同时下载/上传的线程数（分块传输数）
    unsigned short pktSize;     //请求每个发送数据包的数据大小，最后一个包可能小于此值
    unsigned char  status;      //0: success, 1:file not exist
    unsigned char resv[2];
    unsigned char filenamesize;
    char    filename[MAX_FILE_NAME_SIZE];
    unsigned int filesize;
    unsigned md5sum[32];  			//32byte md5 checksum of totle file
    FileSegmentInfo fileSegment[1]; //one or more FileSegmentInfo append with  
}SMsgFileIoctrlDownloadResp;

/*
IOTYPE_USER_FILE_UPLOAD_REQ                     = 0X1304, //maxwell
IOTYPE_USER_FILE_UPLOAD_RSP                     = 0X1305, //maxwell
*/

typedef struct
{
    unsigned char command;	 	//see ENUM_FILE_TRANS_CMD
    unsigned char segments;     //请求同时下载/上传的线程数（分块传输数）
    unsigned short pktSize;     //请求每个发送数据包的数据大小，最后一个包可能小于此值
    unsigned char flag;       	//0x80: force override exist file
    unsigned char resv[2];
    unsigned char filenamesize;
    char    filename[MAX_FILE_NAME_SIZE];
    unsigned int filesize;
    unsigned md5sum[32];  			//32byte md5 checksum of totle file 
    FileSegmentInfo fileSegment[1]; //one or more FileSegmentInfo append with   
}SMsgFileIoctrlUploadReq;

typedef struct
{
    unsigned char command;	 		//see ENUM_FILE_TRANS_CMD
    unsigned char segments;     //允许同时下载/上传的线程数（分块传输数）
    unsigned short pktSize;     //请求每个发送数据包的数据大小，最后一个包可能小于此值
    unsigned char status;      //0: success, 1:no left space :2:not permit override
    unsigned char resv[3];
    unsigned char filenamesize;
    char    filename[MAX_FILE_NAME_SIZE];
    FileSegmentInfo fileSegment[1]; //one or more FileSegmentInfo append with  
}SMsgFileIoctrlUploadResp;


typedef struct
{
    unsigned char  channel;
    unsigned char  type;
    unsigned char  flags; //置为1，和FRAMEINFO_t定义兼容
    unsigned char  segmentindex;

    unsigned int   pktSeq;   //在文件中的顺序
    unsigned short pktSize;
    unsigned short resv2;
    
    unsigned int timestamp;  // 和FRAMEINFO_t定义兼容
    
}PktDataInfo_t;//在数据通道上发送 //

/*
 IOTYPE_USER_FILE_TRANS_PKT_ACK           = 0X1306, //maxwell
 IOTYPE_USER_FILE_TRANS_PKT_NAK           = 0X1307, //maxwell
 */
//用在正常连续数据确认，以bitmap描述
typedef struct
{
    unsigned char  channel;
    unsigned char  segmentindex;
    unsigned char  resv[2];
    
    unsigned int BeginPktSeq;
    unsigned short PktNum; //后面带Pktnum个整数，以bitmap描述（1为收到，0为未收到）
    unsigned short resv2;
    //unsigned int bitmap[1];
}SMsgFileTransPktAck; //设备在通道上接收

//用在稀疏丢包的时候，单个描述需要重传的packet
typedef struct
{
    unsigned char  channel;
    unsigned char  segmentindex;
    
    unsigned char resv[4];
    unsigned short PktNum; //后面带Pktnum个整数，描述需要传输的PktSeq
}SMsgFileTransPktNak; //设备在通道上接收

/*
 IOTYPE_USER_FILE_TRANS_PKT_START          = 0X1308, //maxwell
 IOTYPE_USER_FILE_TRANS_PKT_STOP          = 0X1309, //maxwell
 */

typedef struct
{
    unsigned char  channel;
    unsigned char  segmentindex;    
    unsigned char  resv[2];
}SMsgFileTransPktCmd; 


typedef struct
{
    unsigned char resv[3];
    unsigned char filenamesize;
    char    filename[MAX_FILE_NAME_SIZE];
}SMsgFileIoctrlDeleteReq;

/*
// dropbox support
IOTYPE_USER_IPCAM_GET_SAVE_DROPBOX_REQ      = 0x500,
IOTYPE_USER_IPCAM_GET_SAVE_DROPBOX_RESP     = 0x501,
*/
typedef struct
{
    unsigned short nSupportDropbox;     // 0:no support/ 1: support dropbox
    unsigned short nLinked;             // 0:no link/ 1:linked
    char szLinkUDID[64];                // Link UDID for App
}SMsgAVIoctrlGetDropbox;


/*
 // dropbox support
 IOTYPE_USER_IPCAM_SET_SAVE_DROPBOX_REQ      = 0x502,
 IOTYPE_USER_IPCAM_SET_SAVE_DROPBOX_RESP     = 0x503,
 */
typedef struct
{
    unsigned short nLinked;             // 0:no link/ 1:linked
    char szLinkUDID[64];                // UDID for App
    char szAccessToken[128];             // Oauth token
    char szAccessTokenSecret[128];       // Oauth token secret
	char szAppKey[128];                  // App Key (reserved)
	char szSecret[128];                  // Secret  (reserved)
}SMsgAVIoctrlSetDropbox;

typedef struct
{
	unsigned int channel; 	// Camera Index
	unsigned char reserved[4];
}SMsgAVIoctrlGetVolumeReq;

/*
IOTYPE_USER_IPCAM_SETVOLUME_REQ		= 0x0386,
IOTYPE_USER_IPCAM_GETVOLUME_RESP      = 0x0389,
** @struct SMsgAVIoctrlSetVolumeReq, SMsgAVIoctrlGetVolumeResp
*/
typedef struct
{
    unsigned int  channel;		// camera index
    
    unsigned char  volume; /* 0 ﾱ￭ￊﾾﾹ￘ﾱￕ￉￹ￒ￴ﾣﾬￗ￮ﾴ￳255  */
    unsigned char rsv[3];

    char reserved[4];
}SMsgAVIoctrlSetVolumeReq, SMsgAVIoctrlGetVolumeResp;


/*
IOTYPE_USER_IPCAM_SETVOLUME_RESP	= 0x0387,
** @struct SMsgAVIoctrlSetVolumeResp
*/
typedef struct
{
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetVolumeResp;


typedef struct
{
	unsigned int channel;		 
	unsigned char pir_status;	 //0 --CLOSE 1--OPEN .
  unsigned char rsv[3]; 
  char reserved[4];
}SMsgAVIoctrlSetPIRReq, SMsgAVIoctrlGetPIRResp;

typedef struct
{	
    unsigned int channel;		 	
    unsigned char ir_mode;	 //0 --ﾰￗￌ￬ￄﾣￊﾽ 1--ￒﾹﾼ￤ￄﾣￊﾽ   otherwise: failed.  
    unsigned char rsv[3];   
    char reserved[4];
}SMsgAVIoctrlSetIRReq,SMsgAVIoctrlGetIRReq, SMsgAVIoctrlGetIRResp;

typedef struct
{
    unsigned int channel;		 	
	int result;	// 0: success; otherwise: failed.
	unsigned char reserved[4];
}SMsgAVIoctrlSetIRResp;

/*
IOTYPE_USER_IPCAM_GET_OSD_REQ               = 0x3B2,
IOTYPE_USER_IPCAM_GET_OSD_RESP              = 0x3B3,
IOTYPE_USER_IPCAM_SET_OSD_REQ               = 0x3B4,
IOTYPE_USER_IPCAM_SET_OSD_RESP              = 0x3B5,
*/

typedef struct
{
    unsigned int channel;
    char reserved[4];
}SMsgAVIoctrlGetOSDReq;

#define MAX_OSD_CONTENT_SIZE  128
typedef struct{
    unsigned char  index; //index of osd item, 0: default for date and time; 1:location; 2-255:custom define
    unsigned char  flag;  //0: hide, 1: show
    unsigned char  bytes; //valid bytes in content buf
    unsigned char  fontsize;

    short xpoint;
    short ypoint;
    int   frontargb;
    int   backgroundargb;
    char  content[MAX_OSD_CONTENT_SIZE];
}OSDItem;

typedef struct
{
    unsigned int channel;
    unsigned char itemcount; // several items append
    //OSDItem osditem[1];
}SMsgAVIoctrlGetOSDResp,SMsgAVIoctrlSetOSDReq;

typedef struct
{
    unsigned int channel;
    int result;	// 0: success; otherwise: failed.
    unsigned char reserved[4];
}SMsgAVIoctrlSetOSDResp;

#endif
