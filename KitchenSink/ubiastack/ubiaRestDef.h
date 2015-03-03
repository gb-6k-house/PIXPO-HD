//
//  ubiaRestDef.h
//  P4PLive
//
//  Created by Maxwell on 14-3-12.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#ifndef P4PLive_ubiaRestDef_h
#define P4PLive_ubiaRestDef_h

enum DEVICE_OP_CMD {
    DEVICE_OP_ADD = 1,
    DEVICE_OP_MODIFY = 2,
    DEVICE_OP_DEL = 3
    };

enum{
    
    ACCOUNT_ACCOUNT_NULL = 101, //'账户名不能为空！'
    ACCOUNT_DELETE = 102, //'账户注销，记录删除！'
    ACCOUNT_DELETE_SHARECAM = 103, //'已取消摄像头共享'
    ACCOUNT_EXISTS = 104, //'账户已存在！'
    ACCOUNT_NO_ROLE = 105, //'无权对不属于自己的设备设置'
    ACCOUNT_NO_SHARE = 106, //'没有共享用户'
    ACCOUNT_NOT_EXISTS = 107, //'用户不存在！'
    ACCOUNT_OFFLINE = 109, //'用户登出！'
    ACCOUNT_PASSWORD = 110, //'密码修改成功！'
    ACCOUNT_PASSWORD_ERR = 111, //'密码错误！'
    ACCOUNT_REG = 112, //'注册成功'
    ACCOUNT_SHARECAM = 113, //'共享邀请已发送'
    ACCOUNT_SHARECAM_EXISTS = 114, //'共享邀请已存在'
    ACCOUNT_UPDATE = 115, //'账户信息已更新！'
    ACCOUNT_NAME_ILLEGAL = 116, //'账户名称格式错误！'
    
    DEVICE_ADD = 201, //'设备添加成功！'
    DEVICE_DELETE = 203, //'设备删除成功'
    DEVICE_EVENT_END = 204, //'事件结束！'
    DEVICE_EVENT_OVERFLOW = 205, //'查询事件数量超出范围'
    DEVICE_EVENT_START = 206, //'事件已记录！'
    DEVICE_EXISTS = 207, //'设备已添加！'
    DEVICE_FILE = 208, //'文件上传已记录！'
    DEVICE_HEART = 209, //'设备心跳'
    
    DEVICE_NO_KUAIPAN = 210, //'设备所有人kuaipan未注册'
    DEVICE_NO_UID = 211, //'设备编号不能为空'
    DEVICE_NOT_EXISTS = 212, //'设备不存在！'
    DEVICE_NOT_REG = 213, //'设备未注册！'
    DEVICE_OFFLINE = 214, //'设备下线成功！'
    DEVICE_UPDATE = 215, //'设备修改成功'
    DEVICE_ILLEGAL = 216, //'非法的设备UID（未曾导入的uid）'
    DEVICE_TOKEN_EXPIRED = 217, //'设备Token过期'
    
    FUNCTION_NOT_EXISTS = 301, //'不能识别的调用'
    HMAC_NOT_MATCH = 302, //'签名验证失败！'
    TOKEN_NOT_MATCH = 303, //'非法Token！'
    TOKEN_NULL = 304, //'Token不能为空！'
    KUAIPAN_ERR = 305, //'云端（快盘）错误！
    
    SHAREACCOUNT_ADD_CAM = 401, //'添加共享成功'
    SHAREACCOUNT_DELETE = 402, //'shareaccount账户注销，记录删除！'
    SHAREACCOUNT_DELETE_CAM = 403, //'删除共享成功'
    SHAREACCOUNT_NO_ROLE = 404, //'共享账户无权限！'
    SHAREACCOUNT_NULL_DEVICE_UID = 405, //'设备编号不能为空！'
    SHAREACCOUNT_NO_ROLE_DEVICE_EVENT = 406, //'无获取设备事件权限！'
    SHAREACCOUNT_NO_ROLE_DEVICE_LIST = 407, //'无获取设备列表权限！'
    SHAREACCOUNT_NOT_EXISTS = 408, //'共享目标账户不存在'
    SHAREACCOUNT_REG = 409, //'shareaccount创建成功！'
    SHAREACCOUNT_UPDATE = 410, //'shareaccount信息更新成功！'
  
};


#endif
