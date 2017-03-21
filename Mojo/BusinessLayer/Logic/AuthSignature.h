//
//  AuthSignature.h
//  HumaraShop
//
//  Created by  on 05/11/15.
//  Copyright © 2015 Mery. All rights reserved.
//

#import <Foundation/Foundation.h>


#define contentType @"application/x-www-form-urlencoded"
#define methodName @"POST"
#define GETMethod @"GET"
// please change befor live
#define AppVersions  @"3.0"

@interface AuthSignature : NSObject
+(NSString *)generateRandomNumber;
+(NSString *)generateSignatureWithURL:(NSString *)strURL withRandomNo:(NSString *)strRandom withTime:(NSString *)strTime withServiceName:(NSString *)strServiceName;
+(NSInteger)getTimeStamp;
+(NSString *)getDateFormatUTC;
+ (NSString*)base64forData:(NSData*)theData;
+(NSString *)getAutrhPeremeterWithRandomNo:(NSString *)strRandom withTime:(NSString *)strTime withServiceName:(NSString *)strServiceName withSignature:(NSString *)strSignature;

@end
