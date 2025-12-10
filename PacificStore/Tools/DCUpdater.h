//
//  DCUpdater.h
//  DCTV
//
//  Created by Frank on 2016/2/3.
//  Copyright © 2016年 DCTV. All rights reserved.
/////////////////////////////
#import <UIKit/UIKit.h>


#define          PARAMETER_ERROR    0
#define          ERROR_SUCCESS      1
#define          MAIL_FAILED        2
#define          NO_DATA            3
#define          ACCOUNT_NO_EXIT    4
#define          PASSWORD_ERROR     5
#define          ACCOUNT_EXIST      6
#define          NO_POINTS_LEFT     10
#define          NO_EXIST_COUPON      13
#define          NO_EXCHANGE_COUPON   14
#define          ALREADY_EXCHANGE     15


extern NSString * const kDCLogin;
extern NSString * const kDCForgetPWD;
extern NSString * const kDCRegisterUser;
extern NSString * const kDCGetOTP;
extern NSString * const kDCVerifyOTP;
extern NSString * const kDCDeleteAccount;

extern NSString * const kDCGetUpdateType;



extern NSString * const kDCGetForgetPasswordOTPCode;
extern NSString * const kDCForgetPasswordChange;
extern  NSString * const kDCVerifyForgetPwdOTP;
extern  NSString * const kDCChangePassword;


//===============================================//
extern NSString * const kDCGetCardOTP;
extern NSString * const kDCCardVerifyOTP;
extern NSString * const kDCGetMemberPoints;
extern NSString * const kDCGetMainHomePage;
extern NSString * const kDCGetMainHomePageExt;





extern  NSString * const kDCGetUserInfo;
extern  NSString * const kDCUpdateUserInfo;

extern  NSString * const kDCCompanyInfo;
extern  NSString * const kDCVerifyPhoneNumber;

extern  NSString * const kDCForgetPwd;
extern  NSString * const kDCLoginFBGoogle;

extern  NSString * const kDCSetTermsRead;
extern  NSString * const kDCCheckUser;

extern  NSString * const kDCGetNewsTypes;
extern  NSString * const kDCGetNewsDetail;

//==================================================//
extern  NSString * const kDCGetParking;
extern  NSString * const kDCGetBrandBuildingDetail; ;
extern  NSString * const kDCGetBrandClassType;

extern  NSString * const kDCGetFoodsDetail;
extern  NSString * const kDCGetDMsDetail;

extern  NSString * const kDCGetDMTypes;
extern  NSString * const kDCGetFoodTypes;

extern  NSString * const kDCUpdatePushToken;
extern  NSString * const kDCModifyUser;

extern NSString * const kDCQueryCardCode;
extern NSString * const kDCGetPointToGift;

extern NSString * const kDCGetPushMessage;
extern NSString * const GetECusponMessage;
extern NSString * const kDCDeleteMessage;
extern NSString * const kDCGetMemberInfo;
extern NSString * const kDCSearchBrandDetail;
extern NSString * const kDCGetExclusiveOffer;
extern NSString * const kDCChangeExclusiveOffer;
extern NSString * const kDCGetUnReadMessage;
extern NSString * const kDCUpdateReadMessage;

extern NSString * const kDCReceiveExclusiveOffer;
extern NSString * const kDCGetPushMessageDateTime;

extern NSString * const kDCGetVideoTypes;
extern NSString * const kDCGetVideoDetail;
extern NSString * const kDCAddAppClickLog;

extern NSString * const kDCAddVideoClickLog;
extern NSString * const kDCExpensesRecord;


extern NSString * const kDCGameActivity;
extern NSString * const kDCQueryGameResult;


//============================================================================//
extern NSString * const kDCQueryTradeRecord;
extern NSString * const kDCQueryMemberTradePoint;
extern NSString * const kDCQueryPointTrade;
extern NSString * const kDCQueryEVoucher;
extern NSString *  const kDCQueryExchangeVoucher;

extern NSString * const kDCQueryCanChangeEVoucher;
extern NSString * const kDCInvoiceMakeup;
extern NSString * const kDCQueryPointsBalance;


//=========================================================
extern NSString * const kDCOnLineChangeEVoucher;


extern  NSString * const kDCQueryBarcode;

extern  NSString * const kDCCheckNotifyPage;

extern  NSString * const kDCQueryMainAdInterval;
extern  NSString * const kDCQueryMobileCode;
extern  NSString * const kDCUpdateMobileCode;


extern  NSString * const kDCQueryCitys;
extern  NSString * const kDCQueryAreas;
extern  NSString * const kDCDeleteAllPush;

extern  NSString * const kDCPersonalDataUseTerms;


@interface DCUpdater : NSObject
@property (assign, nonatomic) BOOL isLogining;
@property (assign, nonatomic) BOOL isGettingEvents;
@property (assign, nonatomic) BOOL isChangingPassword;

// Class Method
+ (DCUpdater *)sharedUpdater;


/////////////////////////////////////////////////////
// 登入
- (void)didLoginWithAccount:(NSString *)account
                   password:(NSString *)password
                   PushToken:(NSString *)PushToken
                         OS:(NSString *)strOS;

-(void)CheckUserType:(NSString *)strAccount;
-(void)GetOTPCode:(NSString *)strPhone;
-(void)VerifyOTP:(NSString *)strPhone andCode:(NSString*)strCode;

-(void)GetCardOTPCode:(NSString *)strPhone;
-(void)CardVerifyOTP:(NSString *)strPhone andCode:(NSString*)strCode
          andAccount:(NSString*)strAccount;


-(void)Register:(NSString *)strAccount  andPassword:(NSString *)strPassword andName:(NSString*)strName andSex:(NSString*)strSex
    andBirthday:(NSString*)strBirthday
       andPhone:(NSString*)strPhone
       andShareCode:(NSString*)strShareCode
   andPushToken:(NSString*)strPushToken
     andZipCode:(NSString*)strZipCode
     andCity:(NSString*)strCity
     andArea:(NSString*)strArea
     andAddress:(NSString*)strAddress
     andAllowModifyData:(Boolean)bIsAllow;


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
         ;



-(void)DeleteAccount:(NSString *)strAccount andPassword:(NSString*)strPassword;

//======================================================//
-(void)ForgetPasswordOTPCode:(NSString *)strAccount;

-(void)ForgetPasswordChange:(NSString *)strAccount
             andNewPassword:(NSString *)strNewPassword;

-(void)VerifyForgetPwdOTP:(NSString *)strAccount andCode:(NSString*)strCode;


-(void)ModifyPassword:(NSString*)strAccessToken andOldPassword:(NSString*)strOldPassword andNewPassword:(NSString*)strNewPassword;





//==============================================================//
-(void)SetUserInfo:(NSString*)strAccessToKey andAddress:(NSString*)strAddress andCity:(NSString*)strCity
          andEmail:(NSString*)strEmail andId:(NSString*)strID

 andNickName:(NSString*)strNickName andPicture:(NSString*)strPicture
    ;


-(void)GetCompanyInfo:(NSString*)strAccessToKey;


-(void)VerifyPhoneNumber:(NSString *)strPhone andCode:(NSString*)strCode;




-(void)ForgetPassword:(NSString *)strUserID andToken:(NSString*)strToken
          andPassword:(NSString *)strPassword
                        andConfirmPwd:(NSString*)strConfirmPwd;

+(BOOL)judgePassWordLegal:(NSString *)pass;

+(BOOL)JudgeTheillegalCharacter:(NSString *)content;


//============================================//
-(void)LoginFBGoogle:(NSString *)strUID;


-(void)SetSetTermsRead:(NSString *)strUserID  andAccessKey:(NSString*)strAccessToKey;


-(void)ForgetPasswordOTP:(NSString *)strPhone;





-(NSString*)Base64Encode:(UIImage*)image;
-(void)GetMemberPoints:(NSString *)strAccessToken;

-(void)GetMainHomePage;

-(void)GetMainHomePageExt;

-(void)GetNewsTypes;

-(void)GetFoodTypes;
-(void)GetDMTypes;
-(void)GetParking;


//====================================//
-(void)GetNewsDetail:(NSString*)strTypeID;
-(void)GetFoodsDetail:(NSString*)strTypeID;
-(void)GetDMsDetail:(NSString*)strTypeID;


//==========2019  12   18===================//
-(void)GetVideoTypes;
-(void)GetVideoDetail:(NSString*)strTypeID;





-(void)GetBrandClassType:(NSString*)strTypeID;

-(void)GetBrandDetail:(NSString*)strTypeID andType:(NSString*)strType;


-(void)UpdatePushToken:(NSString*)strSerialID
             PushToken:(NSString*)strPushToken
             AccessToken:(NSString*)strAccessToken;


-(void)ModifyMember:(NSString *)strAccessToken  andName:(NSString*)strName
           andPhone:(NSString*)strPhone
           andPostCode:(NSString*)strPostCode
           andAddress:(NSString*)strAddress
           andCity:(NSString*)strCity
           andArea:(NSString*)strArea
andAllowModifyData:(Boolean)bIsAllow;





-(void)GetCardCode:(NSString *)strAccessToken;



-(void)GetPointToGift;


-(void)GetPushMessage:(NSString *)strAccessToken;


-(void)GetPushMessageExt:(NSString *)strAccessToken  andDataTime:(NSString*)strDateTime;


-(void)GetECusponMessage:(NSString *)strAccessToken;

-(void)DeletePushMessage:(NSString *)strAccessToken andID:(NSString *)strID;


-(void)GetMemberInfo:(NSString *)strAccessToken;


-(void)SearchBrandDetail:(NSString *)strName;


-(void)GetExclusiveOffer:(NSString *)strAccessToken;


-(void)ChenageExclusiveOffer:(NSString *)strAccessToken andCode:(NSString*)strCode
                       andID:(NSString*)strID;

-(void)GetUnReadMsgCount:(NSString *)strAccessToken;
-(void)UpdateReadMessage:(NSString *)strAccessToken;
-(void)ReceiveExclusiveOffer:(NSString *)strAccessToken andID:(NSString*)strID;
-(void)CheckUpdateType;


-(void)AddAppClickLog:(int)iType andDuration:(int)iDuratiopn
                       andFunctionCount:(int)iFunctionCount
       andAccessToken:(NSString*)strAccessToken;



-(void)AddVideoClickLog:(int)iVideoID  andAccessToken:(NSString*)strAccessToken;


-(void)QueryExpensesRecordWithAccessToken:(NSString*)strAccessToken;


-(void)QueryActivityGame:(NSString*)strAccessToken;


-(void)QueryGameResult:(int)iActivityID  andAccessToken:(NSString*)strAccessToken;


-(void)ChangeGameECCuspon:(NSString *)strAccessToken andCode:(NSString*)strCode andID:(NSString*)strID;

-(BOOL)isDeviceMuted;




///消費記錄
-(void)QueryTradeRecord:(NSString *)strAccessToken andCardNbr:(NSString*)strCardNbr       andRRN:(NSString*)strRRN andTransDateStart:(NSString*)strTransDateStart andTransDateEnd:(NSString*)strTransDateEnd andTransType:(NSString*)strTransType
    andTransTypeList:(NSString*)wallet_type_list;



////////////////////////////////
///積點記錄
-(void)QueryMemberTradePoint:(NSString *)strAccessToken  andTransDateStart:(NSString*)strTransDateStart andTransDateEnd:(NSString*)strTransDateEnd;


//////////////////////////////////////////////////////////////////////////////
///Q 點  摸彩券
-(void)QueryPointTrade:(NSString *)strAccessToken  andTransDateStart:(NSString*)strTransDateStart andTransDateEnd:(NSString*)strTransDateEnd
    andWalletId:(NSString*)strWalletId;



//////////////////////////////////////////////////
//電子禮卷交易查詢
-(void)QueryEVoucher:(NSString *)strAccessToken  andTransDateStart:(NSString*)strTransDateStart andTransDateEnd:(NSString*)strTransDateEnd
    andTransType:(NSString*)strTransType;


////////////////////////////////////////////////////////
//全部兌換卷查詢
-(void)QueryExchangeVoucher:(NSString *)strAccessToken;



////////////////////////////////////////////////////////
//點數換好禮/活動禮
-(void)QueryCanChangeEVoucher:(NSString *)strAccessToken;


///補登發票
-(void)InvoiceMakeup:(NSString *)strAccessToken andInvoiceBarcode:(NSString*)strInvoiceBarcode;

-(void)QueryPointsBalance:(NSString *)strAccessToken andWalletType:(NSString*)strWallet_type;



//===========================================================//
//
//
//===========================================================//
-(void)OnLineChangeEVoucher:(NSString *)strAccessToken andGiftID:(NSString*)strGiftId
                            andScheduleID:(NSString*)strScheduleID
             andExchangeQty:(NSString*)strExchangeQty;


-(void)QueryBarcode:(NSString *)strAccessToken;

-(void)CheckNotifyPage:(NSArray*)strViewInfo;

-(void)QueryADInterval;


-(void)QueryMobileCode:(NSString *)strAccessToken;

-(void)UpdateMobileCode:(NSString*)strMobileCode andAccessToken:(NSString *)strAccessToken;



//=========================================================//
-(void)QueryCitys;
-(void)QueryAreas:(NSString *)strCity;



-(void)DeleteAllPushMessage:(NSString *)strAccessToken;



-(void)QueryPersonalUserDataPolicy;




@end
