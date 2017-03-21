//
//  AuthSignature.m
//  HumaraShop
//
//  Created by  on 05/11/15.
//  Copyright © 2015 Mery. All rights reserved.
//

#import "AuthSignature.h"
//#import "JSON.h"
#include <CommonCrypto/CommonHMAC.h>
#pragma mark - DEV
#define PublicKey @"MCBFFUFB"

#define SecretKey   "OQIZFTWMWTGLOB9SSWSIE6B2&"
//
//
#define Developer_API @"http://www3.martjack.com/DeveloperAPI"
@implementation AuthSignature
#pragma mark OAuth


+(NSString *)getDateFormatUTC
{
    NSDate *myDate = [NSDate date];//here it returns current date of device.
    //now set the timeZone and set the Date format to this date as you want.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString * setDate = [dateFormatter stringFromDate:myDate];
    return setDate;
    // here you have new Date with desired format and TimeZone.
}

+(NSInteger)getTimeStamp
{
    NSTimeInterval currTimeStamp = [[NSDate date] timeIntervalSince1970];
    int currentTime = currTimeStamp;
    
    
    NSString *UTCTime = [self getDateFormatUTC];
    NSString *strHour=@"0";
    NSString *strMin=@"0";
    NSString *strSec=@"0";
    
    strSec=@"0";
    
    NSInteger utcTime = 0;
    NSArray *arrUTCTime =[UTCTime componentsSeparatedByString:@":"];
    if (arrUTCTime.count>2) {
        strHour=[arrUTCTime objectAtIndex:0];
        strMin=[arrUTCTime objectAtIndex:1];
        strSec=[arrUTCTime objectAtIndex:2];
        utcTime =  strHour.integerValue*60*60+strMin.integerValue*60+strSec.integerValue;
    }
    NSInteger difference=currentTime-utcTime;
    NSInteger  milliseconds = difference*1000;
    if(milliseconds<0)
        milliseconds = milliseconds*-1;
    return milliseconds;
    
}

+(NSString *)generateRandomNumber
{
    NSString *min = @"123400";
    NSString *max = @"9999999";
    
    int randNum = rand() % ([max intValue] - [min intValue]) + [min intValue];
    
    NSString *num = [NSString stringWithFormat:@"%d", randNum];
    return num;
}



+(NSString *)generateSignatureWithURL:(NSString *)strURL withRandomNo:(NSString *)strRandom withTime:(NSString *)strTime withServiceName:(NSString *)strServiceName
{
    
    strURL  = [NSString stringWithFormat:@"%@",strURL];
    
    NSString *strParam = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=%@",PublicKey,strRandom,@"HMAC-SHA1",strTime,@"1.0"];
    NSLog(@"params = %@",strParam);
    
    NSArray *array=[[self manuallyUTF8Encoding:strURL]componentsSeparatedByString:@"?"];
    NSString *strURL1= array.count > 0 ? array[0] : @"";
    NSString *strParam1=[self manuallyUTF8Encoding:strParam];
    
    
    NSString *signatureBase = [NSString stringWithFormat:@"%@&%@&%@",strServiceName,strURL1,strParam1];
    
    NSString* data1 = signatureBase;
    
    const char *cKey = SecretKey ;
    
    
    const char *cData = [data1 cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *hash = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    
    
    NSString* signature = [self base64forData:hash];
    
    
    
    
    NSString *signature1=[self manuallyUTF8Encoding:signature];
    
    return signature1;
}
+(NSString *)manuallyUTF8Encoding:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    str = [str stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    
    return str;
}
+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {  value |= (0xFF & input[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

+(NSString *)getAutrhPeremeterWithRandomNo:(NSString *)strRandom withTime:(NSString *)strTime withServiceName:(NSString *)strServiceName withSignature:(NSString *)strSignature
{
    NSString *strParam = [NSString stringWithFormat:@"oauth_consumer_key=%@,oauth_nonce=%@,oauth_signature_method=%@,oauth_timestamp=%@,oauth_version=%@,oauth_signature=%@",PublicKey,strRandom,@"HMAC-SHA1",strTime,@"1.0",strSignature];
    //   print(strParam);
    return strParam;
    
}

@end
