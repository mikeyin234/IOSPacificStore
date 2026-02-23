//
//  DCUpdater.m
//  DCTV
//
//  Created by Frank on 2016/2/3.
//  Copyright © 2016年 DCTV. All rights reserved.
//////////////////////////////

#import "DCUpdater.h"
#import "MKNetworkKit.h"
#import "DCCommonTools.h"
#import "AESCrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import "NCChineseConverter.h"


NSString * const kDCLogin = @"kDCLogin";
NSString * const kDCForgetPWD = @"kDCForgetPWD";
NSString * const kDCRegisterUser = @"kDCRegisterUser";
NSString * const kDCGetOTP = @"kDCGetOTP";
NSString * const kDCVerifyOTP = @"kDCVerifyOTP";

NSString * const kDCDeleteAccount = @"kDCDeleteAccount";
NSString * const kDCGetForgetPasswordOTPCode = @"kDCGetForgetPasswordOTPCode";

NSString * const kDCForgetPasswordChange = @"kDCForgetPasswordChange";
NSString * const kDCForgetPasswordOTP = @"kDCForgetPasswordOTP";
NSString * const kDCVerifyForgetPwdOTP = @"kDCVerifyForgetPwdOTP";
NSString * const kDCChangePassword = @"kDCChangePassword";


NSString * const kDCGetCardOTP = @"kDCGetCardOTP";
NSString * const kDCCardVerifyOTP = @"kDCCardVerifyOTP";



NSString * const kDCGetMemberPoints = @"kDCGetMemberPoints";
NSString * const kDCGetMainHomePage = @"kDCGetMainHomePage";
NSString * const kDCGetMainHomePageExt = @"kDCGetMainHomePageExt";

NSString * const kDCGetNewsTypes = @"GetNewsTypes";
NSString * const kDCGetNewsDetail = @"GetNewsDetail";


//==================================================//
NSString * const kDCGetParking = @"GetParking";


NSString * const kDCGetBrandBuildingDetail = @"GetBrandBuildingDetail";
NSString * const kDCGetBrandClassType = @"GetBrandClassType";

NSString * const kDCGetFoodsDetail = @"GetFoodsDetail";
NSString * const kDCGetDMsDetail = @"GetDMsDetail";

//=============
NSString * const kDCGetDMTypes = @"GetDMTypes";
NSString * const kDCGetFoodTypes = @"GetFoodTypes";


NSString * const kDCUpdatePushToken = @"kDCUpdatePushToken";

NSString * const kDCGetUserInfo = @"kDCGetUserInfo";
NSString * const kDCUpdateUserInfo = @"kDCUpdateUserInfo";
NSString * const kDCCompanyInfo = @"kDCCompanyInfo";
NSString * const kDCVerifyPhoneNumber = @"kDCVerifyPhoneNumber";
NSString * const kDCForgetPwd = @"kDCForgetPwd";
NSString * const kDCLoginFBGoogle = @"kDCLoginFBGoogle";
NSString * const kDCSetTermsRead = @"kDCSetTermsRead";
NSString * const kDCCheckUser = @"kDCCheckUser";
NSString * const kDCModifyUser = @"kDCModifyUser";
NSString * const kDCQueryCardCode = @"kDCQueryCardCode";
NSString * const kDCGetPointToGift = @"kDCGetPointToGift";
NSString * const kDCGetPushMessage = @"kDCGetPushMessage";
NSString * const kDCGetPushMessageDateTime = @"kDCGetPushMessageDateTime";
NSString * const GetECusponMessage = @"GetECusponMessage";
NSString * const kDCDeleteMessage = @"kDCDeleteMessage";
NSString * const kDCGetMemberInfo = @"kDCGetMemberInfo";
NSString * const kDCSearchBrandDetail = @"kDCSearchBrandDetail";
NSString * const kDCGetExclusiveOffer = @"kDCGetExclusiveOffer";
NSString * const kDCChangeExclusiveOffer = @"kDCChnageExclusiveOffer";
NSString * const kDCGetUnReadMessage = @"kDCGetUnReadMessage";
NSString * const kDCUpdateReadMessage = @"kDCUpdateReadMessage";
NSString * const kDCReceiveExclusiveOffer = @"kDCReceiveExclusiveOffer";

//===========================================================//
NSString * const kDCGetVideoTypes = @"kDCGetVideoTypes";
NSString * const kDCGetVideoDetail = @"kDCGetVideoDetail";
NSString * const kDCGetUpdateType = @"kDCGetUpdateType";
//=======================================================//
NSString * const kDCAddAppClickLog = @"kDCAddAppClickLog";
NSString * const kDCAddVideoClickLog = @"kDCAddVideoClickLog";
//==================================================================//
NSString * const kDCExpensesRecord  = @"kDCExpensesRecord";
NSString * const kDCGameActivity  = @"kDCGameActivity";
NSString * const kDCQueryGameResult = @"kDCQueryGameResult";

//=======================================================================//
NSString * const kDCQueryTradeRecord = @"kDCQueryTradeRecord";
NSString * const kDCQueryMemberTradePoint = @"kDCQueryMemberTradePoint";


NSString * const kDCQueryPointTrade = @"kDCQueryPointTrade";
NSString * const kDCQueryEVoucher = @"kDCQueryEVoucher";



NSString * const kDCQueryExchangeVoucher = @"kDCQueryExchangeVoucher";


NSString * const kDCQueryCanChangeEVoucher = @"kDCQueryCanChangeEVoucher";


////////////////////////////////////////////////////////////////////////
//發票補登
NSString * const kDCInvoiceMakeup = @"kDCInvoiceMakeup";

NSString * const kDCQueryPointsBalance = @"kDCQueryPointsBalance";

NSString * const kDCOnLineChangeEVoucher = @"kDCOnLineChangeEVoucher";


NSString * const kDCQueryBarcode = @"kDCQueryBarcode";

NSString * const kDCCheckNotifyPage = @"kDCCheckNotifyPage";
NSString * const kDCQueryMainAdInterval = @"kDCQueryMainAdInterval";


NSString * const kDCQueryMobileCode  = @"kDCQueryMobileCode";
NSString * const kDCUpdateMobileCode  = @"kDCUpdateMobileCode";



NSString * const kDCQueryCitys  = @"kDCQueryCitys";
NSString * const kDCQueryAreas  = @"kDCQueryAreas";


//======================================================//
NSString * const kDCDeleteAllPush  = @"kDCDeleteAllPush";



NSString * const kDCPersonalDataUseTerms  = @"kDCPersonalDataUseTerms";





//kDCRegisterUser
static DCUpdater *instance_ = nil;
NSString * const NETWORK_ERROR_CONNECT = @"伺服器連線發生錯誤!";


//static NSString * const kDCHostName = @"https://testapp.pacific-mall.com.tw/PacificStoreProcess.ashx";

static NSString * const kDCHostName= @"https://newapp.pacific-mall.com.tw/PacificStoreProcess.ashx";



@interface DCUpdater ()
@property (strong, nonatomic) MKNetworkEngine *networkEngine;

- (void)setUpdating:(BOOL)isUpdating withKey:(NSString *)key;
@end

@implementation DCUpdater

#pragma mark - Private Methods
- (void)setUpdating:(BOOL)isUpdating withKey:(NSString *)key {
    if ([kDCLogin isEqualToString:key]) {
        self.isLogining = isUpdating;
    }
}


+ (DCUpdater *)sharedUpdater {
    @synchronized (self) {
        if (nil == instance_) {
            instance_ = [[DCUpdater alloc] init];
        }
    }
    return instance_;
}






- (id)init
{
    self = [super init];
    if (self)
    {
        MKNetworkEngine *networkEngine = [[MKNetworkEngine alloc] initWithHostName:kDCHostName];
        
        self.networkEngine = networkEngine;
    }
    return self;
}



-(NSString*)GetjsonData:(NSDictionary*)dictionaryOrArrayToOutput
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryOrArrayToOutput
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           error:&error];
    
    NSString *jsonString  = @"";
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        
       jsonString= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return   jsonString;
    
}

#pragma mark - 登入
- (void)didLoginWithAccount:(NSString *)account
                   password:(NSString *)password
                  PushToken:(NSString *)PushToken
                        OS:(NSString *)strOS
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                             account, @"UserID",
                             password, @"Password",
                             PushToken, @"TOKEN",
                             strOS, @"OS",
                             @"Login", @"Function",
                             nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                   httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCLogin];
}


-(void)CheckUserType:(NSString *)strAccount
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccount, @"UserID",
                                @"CheckMemberExist", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCCheckUser];
    
}


-(void)GetCardOTPCode:(NSString *)strPhone;
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strPhone, @"PhoneNumber",                               
                                @"GetCardOTPCode", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    [self PostToRemoteServer:operation andNotifyCode:kDCGetCardOTP];
    
}


-(void)CardVerifyOTP:(NSString *)strPhone andCode:(NSString*)strCode
                     andAccount:(NSString*)strAccount;
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strPhone, @"PhoneNumber",
                                strCode, @"OTPCode",
                                strAccount, @"UserID",
                                @"CardOTPVerify", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    [self PostToRemoteServer:operation andNotifyCode:kDCCardVerifyOTP];
}


-(void)GetOTPCode:(NSString *)strPhone
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strPhone, @"PhoneNumber",
                                @"GetOTPCode", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    [self PostToRemoteServer:operation andNotifyCode:kDCGetOTP];
}


-(void)VerifyOTP:(NSString *)strPhone andCode:(NSString*)strCode
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strPhone, @"PhoneNumber",
                                strCode, @"OTPCode",
                                @"OTPVerify", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    [self PostToRemoteServer:operation andNotifyCode:kDCVerifyOTP];
}


-(void)Register:(NSString *)strAccount  andPassword:(NSString *)strPassword andName:(NSString*)strName andSex:(NSString*)strSex
    andBirthday:(NSString*)strBirthday 
     andPhone:(NSString*)strPhone
     andShareCode:(NSString*)strShareCode
     andPushToken:(NSString*)strPushToken
     andZipCode:(NSString*)strZipCode
     andCity:(NSString*)strCity
     andArea:(NSString*)strArea
     andAddress:(NSString*)strAddress
     andAllowModifyData:(Boolean)bIsAllow
{
    NSString* urlString = kDCHostName;

    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccount, @"UserID",
                                strPassword, @"Password",
                                strPhone, @"Phone",
                                strName, @"Name",
                                strSex, @"Sex",
                                strShareCode, @"ShareCode",                                
                                strBirthday, @"Birthday",
                                @"Register", @"Function",
                                strPushToken, @"PushToken",
                                
                                strZipCode, @"PostCode",
                                strCity, @"City",
                                strArea, @"Area",
                                strAddress, @"Address",
                                bIsAllow ? @"1" : @"0" , @"AllowModifyData",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    [self PostToRemoteServer:operation andNotifyCode:kDCRegisterUser];
    
}



-(void)DeleteAccount:(NSString *)strAccount andPassword:(NSString*)strPassword
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccount, @"Account",
                                strPassword, @"Password",
                                @"DeleteAccount", @"Function",
                                nil];
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCDeleteAccount];
    
}



//======================================================//
-(void)ForgetPasswordOTPCode:(NSString *)strAccount
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccount, @"UserID",
                                @"GetForgetPasswordOTPCode", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetForgetPasswordOTPCode];
    
}


-(void)ForgetPasswordChange:(NSString *)strAccount
             andNewPassword:(NSString *)strNewPassword
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccount, @"UserID",
                                strNewPassword, @"Password",
                                @"ForgetPasswordModify", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCForgetPasswordChange];
    
}



-(void)VerifyForgetPwdOTP:(NSString *)strAccount andCode:(NSString*)strCode
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccount, @"UserID",
                                strCode, @"OTPCode",
                                @"ForgetPasswordOTPVerify", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCVerifyForgetPwdOTP];
    
}



-(void)ModifyPassword:(NSString*)strAccessToken andOldPassword:(NSString*)strOldPassword andNewPassword:(NSString*)strNewPassword
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                strOldPassword, @"OldPassword",
                                strNewPassword, @"NewPassword",
                                @"ModifyPassword", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCChangePassword];
}


-(void)QueryTradeRecord:(NSString *)strAccessToken andCardNbr:(NSString*)strCardNbr       andRRN:(NSString*)strRRN andTransDateStart:(NSString*)strTransDateStart andTransDateEnd:(NSString*)strTransDateEnd andTransType:(NSString*)strTransType
    andTransTypeList:(NSString*)wallet_type_list
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                strCardNbr, @"card_nbr",
                                strRRN, @"rrn",
                                strTransDateStart, @"trans_date_start",
                                strTransDateEnd, @"trans_date_end",
                                strTransType, @"trans_type",
                                wallet_type_list, @"wallet_type_list",
                                @"QueryTradeRecord", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryTradeRecord];
    
    
}


-(void)QueryMemberTradePoint:(NSString *)strAccessToken  andTransDateStart:(NSString*)strTransDateStart andTransDateEnd:(NSString*)strTransDateEnd
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                strTransDateStart, @"StartDate",
                                strTransDateEnd, @"EndDate",
                                @"QueryMemberTradePoint", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryMemberTradePoint];
}

//////////////////////////////////////////////////////////////////////////////
///Q 點  摸彩券
-(void)QueryPointTrade:(NSString *)strAccessToken  andTransDateStart:(NSString*)strTransDateStart andTransDateEnd:(NSString*)strTransDateEnd
    andWalletId:(NSString*)strWalletId
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                strTransDateStart, @"StartDate",
                                strTransDateEnd, @"EndDate",
                                strWalletId, @"wallet_id",
                                @"QueryPointTrade", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryPointTrade];
    
}

//////////////////////////////////////////////////
//電子禮卷交易查詢
-(void)QueryEVoucher:(NSString *)strAccessToken  andTransDateStart:(NSString*)strTransDateStart andTransDateEnd:(NSString*)strTransDateEnd
    andTransType:(NSString*)strTransType
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                strTransDateStart, @"StartDate",
                                strTransDateEnd, @"EndDate",
                                strTransType, @"TransType",
                                @"QueryEVoucher", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryEVoucher];
}



////////////////////////////////////////////////////////
//全部兌換卷查詢
-(void)QueryExchangeVoucher:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                @"QueryExchangeVoucher", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
     
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryExchangeVoucher];
    
}

////////////////////////////////////////////////////////
//點數換好禮/活動禮
-(void)QueryCanChangeEVoucher:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                @"QueryCanChangeEVoucher", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
     
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryCanChangeEVoucher];
}




////////////////////////////////////////////////////////
//查詢點數，（點數(0)， 電子抵用卷(L)， 禮卷(C)，  Q卷(Q)， 摸彩卷(T)。
-(void)QueryPointsBalance:(NSString *)strAccessToken andWalletType:(NSString*)strWallet_type
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                @"QueryPointsBalance", @"Function",
                                strWallet_type, @"wallet_type",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
     
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryPointsBalance];
    
    
}


-(void)OnLineChangeEVoucher:(NSString *)strAccessToken andGiftID:(NSString*)strGiftId
                            andScheduleID:(NSString*)strScheduleID
             andExchangeQty:(NSString*)strExchangeQty
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                @"OnLineChangeEVoucher", @"Function",
                                strGiftId, @"gift_id",
                                strScheduleID, @"schedule_id",
                                strExchangeQty, @"exchange_qty",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCOnLineChangeEVoucher];
    
}



-(void)PostToRemoteServer:(MKNetworkOperation*)operation andNotifyCode:(NSString*)strNotifyCode
{
    
    [operation addCompletionHandler:^(MKNetworkOperation *completionOperation) {
        
        NSString *originalResponseString =
        (nil == [completionOperation responseStringWithEncoding:NSUTF8StringEncoding]) ?
        @"" : [completionOperation responseStringWithEncoding:NSUTF8StringEncoding];
        
        
        //[strNotifyCode isEqualToString:kDCGetCitys] ||
        NSError *jsonReadError = nil;
        
        id responseObj = [NSJSONSerialization JSONObjectWithData:
                          [originalResponseString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonReadError];
        BOOL success = NO;
        NSDictionary *responseDic = [NSDictionary dictionary];
        
  
        if (nil == jsonReadError) {
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                success = YES;
                responseDic = responseObj;
            }
        }
        
        if (responseDic && success) {
            NSString *isSuccess = @"NO";
            
            
            NSString *message = [responseDic objectForKey:@"ReturnMessage"];
            if(message==nil)
                message = @"";
            
            isSuccess = @"YES";
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      isSuccess, @"isSuccess",
                                      message, @"message",
                                      responseDic, @"data",
                                      nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:strNotifyCode
                                                                object:nil
                                                              userInfo:userInfo];
        } else
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"NO", @"isSuccess",
                                      NETWORK_ERROR_CONNECT, @"message",
                                      nil, @"data", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:strNotifyCode
                                                                object:nil
                                                              userInfo:userInfo];
        }
        
        [self setUpdating:NO withKey:kDCLogin];
        
    } errorHandler:^(MKNetworkOperation *errorOperation, NSError *error)
     {
         
         NSString *originalResponseString =
         (nil == [errorOperation responseStringWithEncoding:NSUTF8StringEncoding]) ?
           @"" : [errorOperation responseStringWithEncoding:NSUTF8StringEncoding];
         
         //[strNotifyCode isEqualToString:kDCGetCitys] ||
         NSError *jsonReadError = nil;
         
         id responseObj = [NSJSONSerialization JSONObjectWithData:
                           [originalResponseString dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:NSJSONReadingMutableContainers
                                                            error:&jsonReadError];
         BOOL success = NO;
         NSDictionary *responseDic = [NSDictionary dictionary];
         
         
         if (nil == jsonReadError) {
             if ([responseObj isKindOfClass:[NSDictionary class]]) {
                 success = YES;
                 responseDic = responseObj;
             }
         }
         
         
         if (responseDic && success) {
             NSString *isSuccess = @"NO";
             NSString *message = [responseDic objectForKey:@"ModelState"];
             
             if(message==nil)
                 message = @"";
             
             isSuccess = @"YES";
             
             NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"NO", @"isSuccess",
                                       message, @"message",
                                       responseDic, @"data",
                                       nil];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:strNotifyCode
                                                                 object:nil
                                                               userInfo:userInfo];
         }else
         {
              NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"NO", @"isSuccess",
                                   NETWORK_ERROR_CONNECT, @"message",
                                   nil, @"data", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:strNotifyCode
                                                             object:nil
                                                           userInfo:userInfo];
         }
             
         [self setUpdating:NO withKey:kDCLogin];
     }];
    [_networkEngine enqueueOperation:operation];
}










-(void)ForgetPasswordOTP:(NSString *)strPhone
{
    
    /////////////////////////////////////////////
    //Modify  2018  11  26
    NSString* urlString = [NSString stringWithFormat:@"%@Account/ForgetPasswordOTP",kDCHostName];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strPhone, @"Phone",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params   httpMethod:@"GET"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCForgetPasswordOTP];
    
    
}




-(void)ForgetPassword:(NSString *)strUserID andToken:(NSString*)strToken
          andPassword:(NSString *)strPassword
        andConfirmPwd:(NSString*)strConfirmPwd
{
    NSString* urlString = [NSString stringWithFormat:@"%@Account/ForgetPassword",kDCHostName];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strUserID, @"UserId",
                            strToken, @"Token",
                            strConfirmPwd, @"ConfirmPassword",
                            strPassword, @"Password",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCForgetPwd];
    
}








-(void)VerifyPhoneNumber:(NSString *)strPhone andCode:(NSString*)strCode
{
    NSString* urlString = [NSString stringWithFormat:@"%@Account/VerifyPhoneNumber",kDCHostName];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strPhone, @"PhoneNumber",
                            strCode, @"Code",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCVerifyPhoneNumber];
    
}






//========================================================================================//
-(void)ChangePassword:(NSString *)strOldPassword andNewPassword:(NSString *)strNewPassword
         andAccessKey:(NSString*)strAccessToKey
{   
    NSString* urlString = [NSString stringWithFormat:@"%@Account/ChangePassword",kDCHostName];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strNewPassword, @"ConfirmPassword",
                            strNewPassword, @"NewPassword",
                            strOldPassword, @"OldPassword",
                            nil];
    
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    
    
    NSString*  strKey  = [NSString stringWithFormat:@"bearer %@",strAccessToKey];
    [operation addHeader:@"Authorization" withValue:strKey];
    
    
    [self PostToRemoteServer:operation andNotifyCode:kDCChangePassword];
    
}



//========================================================================================//
-(void)GetUserInfo:(NSString*)strAccessToKey
{
    NSString* urlString = [NSString stringWithFormat:@"%@Account/UserInfo",kDCHostName];
    
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:nil                                                                httpMethod:@"POST"];
    
    NSString*  strKey  = [NSString stringWithFormat:@"bearer %@",strAccessToKey];
    
    [operation addHeader:@"Authorization" withValue: strKey];
    [operation addHeader:@"Content_Type" withValue:@"application/json"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetUserInfo];
}



-(void)SetUserInfo:(NSString*)strAccessToKey andAddress:(NSString*)strAddress andCity:(NSString*)strCity
          andEmail:(NSString*)strEmail andId:(NSString*)strID
       andNickName:(NSString*)strNickName andPicture:(NSString*)strPicture
{
    
    NSString* urlString = [NSString stringWithFormat:@"%@Account/UpdateUserInfo",kDCHostName];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strAddress, @"Address",
                            strCity, @"City",
                            strEmail, @"Email",
                            strID, @"Id",
                            strNickName, @"NickName",
                            strPicture, @"Picture",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    NSString*  strKey  = [NSString stringWithFormat:@"bearer %@",strAccessToKey];    
    [operation addHeader:@"Authorization" withValue: strKey];
    [operation addHeader:@"Content_Type" withValue:@"application/json"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCUpdateUserInfo];
    
}


//========================================================//
//
//
//
//========================================================//
-(void)GetCompanyInfo:(NSString*)strAccessToKey;
{
    NSString* urlString = [NSString stringWithFormat:@"%@Account/CompanyInfo",kDCHostName];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:nil                                                                httpMethod:@"GET"];
    
    
    NSString*  strKey  = [NSString stringWithFormat:@"bearer %@",strAccessToKey];
    [operation addHeader:@"Authorization" withValue: strKey];
    [operation addHeader:@"Content_Type" withValue:@"application/json"];
    
    
    [self PostToRemoteServer:operation andNotifyCode:kDCCompanyInfo];
}



+(BOOL)judgePassWordLegal:(NSString *)pass{
    
    BOOL result = false;
    
    if ([pass length] >= 6)
    {
        NSString * regex =@"(?![0-9A-Z]+$)(?![0-9a-z]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        result = [pred evaluateWithObject:pass];
    }
    return result;
    
}




+ (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    
    if ([content length] >= 4)
    {
      //提示标签不能输入特殊字符
      NSString *str =@"^[A-Za-z\\u4e00-\u9fa5]+$";
        
      NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
        if (![emailTest evaluateWithObject:content]) {
        
            return YES;
        }
      }
      return NO;
}


    
    
-(void)LoginFBGoogle:(NSString *)strUID
{
    NSString* urlString = [NSString stringWithFormat:@"%@Account/FirebaseInfo",kDCHostName];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strUID, @"UID",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                   httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCLoginFBGoogle];
    
}


-(void)SetSetTermsRead:(NSString *)strUserID  andAccessKey:(NSString*)strAccessToKey
{
    NSString* urlString = [NSString stringWithFormat:@"%@Account/SetTermsRead",kDCHostName];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:nil                                                                   httpMethod:@"GET"];
    
    NSString*  strKey  = [NSString stringWithFormat:@"bearer %@",strAccessToKey];
    [operation addHeader:@"Authorization" withValue: strKey];
    [operation addHeader:@"Content_Type" withValue:@"application/json"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCSetTermsRead];
}


-(NSString*)Base64Encode:(UIImage*)image
{
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.5)];
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    return  base64Encoded;        
}




-(void)CardRegister:(NSString *)strAccount  andPassword:(NSString *)strPassword andName:(NSString*)strName andSex:(NSString*)strSex
    andBirthday:(NSString*)strBirthday
       andPhone:(NSString*)strPhone
  andCardNumber:(NSString*)strCardNumber
     isChildren:(int)isChildren
     andShareCode:(NSString*)strShareCode
     andPushToken:(NSString*)strPushToken
         andZipCode:(NSString*)strZipCode
         andCity:(NSString*)strCity
         andArea:(NSString*)strArea
         andAddress:(NSString*)strAddress
         andAllowModifyData:(Boolean)bIsAllow
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccount, @"UserID",
                                strPassword, @"Password",
                                strPhone, @"Phone",
                                strName, @"Name",
                                strSex, @"Sex",
                                strBirthday, @"Birthday",                               
                                strCardNumber, @"CardNumber",
                                strShareCode, @"ShareCode",
                                 [NSNumber numberWithInt:isChildren], @"isChildren",
                                @"CardRegister", @"Function",
                                strPushToken, @"PushToken",
                                strZipCode, @"PostCode",
                                strCity, @"City",
                                strArea, @"Area",
                                strAddress, @"Address",
                                bIsAllow ? @"1" : @"0" , @"AllowModifyData",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCRegisterUser];
    
}


-(void)GetMemberPoints:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                @"GetMemberPoints", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetMemberPoints];
}



-(void)GetMainHomePage
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetMainHomePage", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetMainHomePage];
    
}


-(void)GetMainHomePageExt
{
NSString* urlString = kDCHostName;

NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"GetMainHomePageFBExt", @"Function",
                            nil];
    
NSString* strJsonData  = [self GetjsonData:paramsData];
    
NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                        strJsonData, @"Param",
                        nil];
    
MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];

[self PostToRemoteServer:operation andNotifyCode:kDCGetMainHomePageExt];
}

-(void)CheckUpdateType
{
      NSString* urlString = kDCHostName;
      NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"UpdateType", @"Function",
                                  nil];
     
      NSString* strJsonData  = [self GetjsonData:paramsData];
      NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                              strJsonData, @"Param",
                              nil];
      MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
      [self PostToRemoteServer:operation andNotifyCode:kDCGetUpdateType];
}

-(void)GetNewsTypes
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetNewsTypes", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetNewsTypes];
}


-(void)GetNewsDetail:(NSString*)strTypeID
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetNewsDetail", @"Function",
                                strTypeID, @"TypeID",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetNewsDetail];
    
}


-(void)GetFoodTypes
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetFoodTypes", @"Function",
                                nil];
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetFoodTypes];
}

-(void)GetDMTypes
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetDMTypes", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetDMTypes];
}

-(void)GetParking
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetParking", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetParking];
}



-(void)GetFoodsDetail:(NSString*)strTypeID
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetFoodsDetail", @"Function",
                                strTypeID, @"TypeID",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetFoodsDetail];
}


//==========2019  12   18===================//
-(void)GetVideoTypes
{
    //NSString* urlString = @"http://1.34.131.123:8011/PacificStoreProcess.ashx";
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetVideosTypes", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                               httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetVideoTypes];
    
}


-(void)GetVideoDetail:(NSString*)strTypeID
{
    //NSString* urlString = @"http://1.34.131.123:8011/PacificStoreProcess.ashx";
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetVideosDetailEx", @"Function",
                                strTypeID, @"TypeID",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetVideoDetail];
}


-(void)GetBrandClassType:(NSString*)strTypeID;
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetBrandClassType", @"Function",
                                strTypeID, @"TypeID",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetBrandClassType];
}




-(void)GetBrandDetail:(NSString*)strTypeID andType:(NSString*)strType
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetBrandDetail", @"Function",
                                strTypeID, @"TypeID",
                                strType, @"Type",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetBrandBuildingDetail];
}



-(void)GetDMsDetail:(NSString*)strTypeID
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetDMsDetail", @"Function",
                                strTypeID, @"TypeID",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetDMsDetail];
}


-(void)UpdatePushToken:(NSString*)strSerialID
             PushToken:(NSString*)strPushToken
             AccessToken:(NSString*)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"UpdatePushToken", @"Function",
                                strSerialID, @"DeviceSerialID",
                                strPushToken, @"PushToken",
                                strAccessToken, @"AccessToken",
                                @"1", @"DeviceType",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCUpdatePushToken];
}


-(void)GetCardCode:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                @"GetMemberCardCodeEx", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryCardCode];
    
}

-(void)ModifyMember:(NSString *)strAccessToken  andName:(NSString*)strName
           andPhone:(NSString*)strPhone
        andPostCode:(NSString*)strPostCode
         andAddress:(NSString*)strAddress
         andCity:(NSString*)strCity
         andArea:(NSString*)strArea
         andAllowModifyData:(Boolean)bIsAllow
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                strAccessToken, @"AccessToken",
                                strPhone, @"Phone",
                                strName, @"Name",
                                strPostCode, @"PostCode",
                                strAddress, @"Address",
                                @"ModifyMember", @"Function",
                                strCity, @"City",
                                strArea, @"Area",
                                bIsAllow ? @"1" : @"0" , @"AllowModifyData",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString
                                                                    params:params
                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCModifyUser];
    
}


-(void)GetPointToGift
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetPointToGift", @"Function",
                                nil];
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetPointToGift];
    
    
}

-(void)GetPushMessage:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetPushMessage", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetPushMessage];
}

-(void)GetECusponMessage:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetECusponMessage", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:GetECusponMessage];
    
}

-(void)ChenageExclusiveOffer:(NSString *)strAccessToken andCode:(NSString*)strCode
                       andID:(NSString*)strID
{
    NSString* urlString = kDCHostName;
    
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"ChangeExclusiveOffer", @"Function",
                                strAccessToken, @"AccessToken",
                                strCode, @"ExclusiveOfferCode",
                                strID, @"id",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCChangeExclusiveOffer];
    
}


-(void)GetExclusiveOffer:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetExclusiveOffer", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetExclusiveOffer];
    
}



-(void)DeletePushMessage:(NSString *)strAccessToken andID:(NSString *)strID
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"DeletePushMessage", @"Function",
                                strAccessToken, @"AccessToken",
                                strID, @"id",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCDeleteMessage];
    
}


-(void)GetMemberInfo:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetMemberInfo", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetMemberInfo];
}

-(void)SearchBrandDetail:(NSString *)strName
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"SearchBrandDetail", @"Function",
                                strName, @"Name",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCSearchBrandDetail];
    
}


-(void)GetUnReadMsgCount:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetUnReadMessage", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetUnReadMessage];
}


-(void)UpdateReadMessage:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"UpdateReadMessage", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCUpdateReadMessage];
}


-(void)ReceiveExclusiveOffer:(NSString *)strAccessToken andID:(NSString*)strID
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"ReceiveExclusiveOffer", @"Function",
                                strAccessToken, @"AccessToken",
                                strID, @"id",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCReceiveExclusiveOffer];
    
}



-(void)GetPushMessageExt:(NSString *)strAccessToken  andDataTime:(NSString*)strDateTime
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetPushMessageByDateTime", @"Function",
                                strAccessToken, @"AccessToken",
                                strDateTime, @"SendDate",
                                nil];
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGetPushMessageDateTime];
}


-(void)AddAppClickLog:(int)iType andDuration:(int)iDuratiopn
                andFunctionCount:(int)iFunctionCount
                andAccessToken:(NSString*)strAccessToken
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"AddAppClickLog", @"Function",
                                strAccessToken, @"AccessToken",
                                [NSNumber numberWithInt:iType], @"Type",
                                [NSNumber numberWithInt:iDuratiopn], @"Duration",
                                [NSNumber numberWithInt:iFunctionCount], @"FunctionCount",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCAddAppClickLog];
    
}

-(void)AddVideoClickLog:(int)iVideoID  andAccessToken:(NSString*)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"AddVideoClickLog", @"Function",
                                strAccessToken, @"AccessToken",
                                [NSNumber numberWithInt:iVideoID], @"VideoID",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCAddVideoClickLog];
    
}

-(void)QueryExpensesRecordWithAccessToken:(NSString*)strAccessToken
{   
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"QueryExpensesRecord", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCExpensesRecord];
    
}


-(void)QueryActivityGame:(NSString*)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetGameActivity", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCGameActivity];
}


-(void)QueryGameResult:(int)iActivityID  andAccessToken:(NSString*)strAccessToken
{
       NSString* urlString = kDCHostName;
    
       NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"GetGameResultActivity", @"Function",
                                    strAccessToken, @"AccessToken",
                                    [NSNumber numberWithInt:iActivityID], @"ActivityID",
                                    nil];
       
       NSString* strJsonData  = [self GetjsonData:paramsData];
       NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                               strJsonData, @"Param",
                               nil];
       
       MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
       
       [self PostToRemoteServer:operation andNotifyCode:kDCQueryGameResult];
    
}


-(void)ChangeGameECCuspon:(NSString *)strAccessToken andCode:(NSString*)strCode
                       andID:(NSString*)strID
{
    NSString* urlString = kDCHostName;
    
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"ChangeECCusponOffer", @"Function",
                                strAccessToken, @"AccessToken",
                                strCode, @"ExclusiveOfferCode",
                                strID, @"id",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCChangeExclusiveOffer];
    
}

-(void)InvoiceMakeup:(NSString *)strAccessToken andInvoiceBarcode:(NSString*)strInvoiceBarcode
{
    NSString* urlString = kDCHostName;
    
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"InvoiceMakeup", @"Function",
                                strAccessToken, @"AccessToken",
                                strInvoiceBarcode, @"InvoiceBarcode",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCInvoiceMakeup];
}



-(void)QueryBarcode:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"QueryBarcode", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryBarcode];
}


-(void)CheckNotifyPage:(NSArray*)strViewInfo
{
    NSString* urlString = kDCHostName;
    
//====================================
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:strViewInfo options:NSJSONWritingPrettyPrinted error:&error];
    NSString *ViewInfoString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"CheckNotifyPage", @"Function",
                                ViewInfoString, @"ViewInfo",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCCheckNotifyPage];
    
}





-(void)QueryADInterval
{
    NSString* urlString = kDCHostName;
    
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"QueryMainAdInterval", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryMainAdInterval];
    
}


 

-(void)QueryMobileCode:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"QueryMobileBarcode", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryMobileCode];
    
    
   
   //kDCUpdateMobileCode
    
}


-(void)UpdateMobileCode:(NSString*)strMobileCode
         andAccessToken:(NSString *)strAccessToken
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"UpdateMobileBarcode", @"Function",
                                strMobileCode, @"MobileBarcode",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCUpdateMobileCode];
    
    
}

//============================================///
///
/////////////////////////////////////////////////
-(void)DeleteAllPushMessage:(NSString *)strAccessToken
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"DeleteAllMessage", @"Function",
                                strAccessToken, @"AccessToken",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCDeleteAllPush];
    
}



-(void)QueryCitys
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetCity", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                                httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryCitys];
    
    
}

-(void)QueryAreas:(NSString *)strCity
{
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"GetArea", @"Function",
                                strCity, @"City",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                               httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCQueryAreas];
    
}


-(void)QueryPersonalUserDataPolicy
{
    
    NSString* urlString = kDCHostName;
    
    NSDictionary *paramsData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"PersonalDataUseTerms", @"Function",
                                nil];
    
    NSString* strJsonData  = [self GetjsonData:paramsData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            strJsonData, @"Param",
                            nil];
    
    MKNetworkOperation *operation = [_networkEngine operationWithURLString:urlString                                                                    params:params                                                               httpMethod:@"POST"];
    
    [self PostToRemoteServer:operation andNotifyCode:kDCPersonalDataUseTerms];
    
    
}





-(BOOL)isDeviceMuted
{
    return true;
}


@end
