#ifndef _WIFI_DIRECT_CONFIG_H_
#define _WIFI_DIRECT_CONFIG_H_

#include "platform_Config.h"

#define WDC_ERR_OK  0
#define WDC_ERR_INVAILD_SSID   -1
#define WDC_ERR_INVALID_UID     -2
#define WDC_ERR_NO_CALLBACK     -3

//uid of responsed device, teh callback function should copy uid to 
//nErrorCode, 0: is OK ,

typedef void (__stdcall *wdcStatusCB)(int status,char * uid);

int WDC_StopConfig();
/*
*  Uid: may be NULL, if set will configure the device of the specified UID
*  Ssid: shall not be NULL
*  Key: shall not be NULL
*/
int WDC_StartConfig(const char *Uid, const char *Ssid, const char *Key, unsigned int tmout);

int WDC_StartConfigWithCB(const char *Uid, const char *Ssid, const char *Key, wdcStatusCB myCallback);

#endif /*_WIFI_DIRECT_CONFIG_H_*/