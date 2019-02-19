#CocoaSecurity [![Build Status](https://secure.travis-ci.org/kelp404/CocoaSecurity.png?branch=master)](http://travis-ci.org/#!/kelp404/CocoaSecurity)

Kelp https://twitter.com/kelp404/  
[MIT License][mit]  
[MIT]: http://www.opensource.org/licenses/mit-license.php


CocoaSecurity include 4 classes, `CocoaSecurity`, `CocoaSecurityResult`, `CocoaSecurityEncoder` and `CocoaSecurityDecoder`.

##CocoaSecurity
CocoaSecurity is core. It provides AES encrypt, AES decrypt, Hash(MD5, HmacMD5, SHA1~SHA512, HmacSHA1~HmacSHA512) messages.  
  
**MD5:**
```objective-c
CocoaSecurityResult *md5 = [CocoaSecurity md5:@"kelp"];

// md5.hex = 'C40C69779E15780ADAE46C45EB451E23'
// md5.hexLower = 'c40c69779e15780adae46c45eb451e23'
// md5.base64 = 'xAxpd54VeAra5GxF60UeIw=='
```
**SHA256:**
```objective-c
CocoaSecurityResult *sha256 = [CocoaSecurity sha256:@"kelp"];

// sha256.hexLower = '280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9'
// sha256.base64 = 'KA+LuMQ9Uy84nvDipTISILB4KwZSBdzfy42PAu1RFbk='
```
**default AES Encrypt:**<br/>
key -> SHA384(key).sub(0, 32)<br/>
iv -> SHA384(key).sub(32, 16)
```objective-c
CocoaSecurityResult *aesDefault = [CocoaSecurity aesEncrypt:@"kelp" key:@"key"];

// aesDefault.base64 = 'ez9uubPneV1d2+rpjnabJw=='
```
**AES256 Encrypt & Decrypt:**
```objective-c
CocoaSecurityResult *aes256 = [CocoaSecurity aesEncrypt:@"kelp"
                                      hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                       hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
// aes256.base64 = 'WQYg5qvcGyCBY3IF0hPsoQ=='

CocoaSecurityResult *aes256Decrypt = [CocoaSecurity aesDecryptWithBase64:@"WQYg5qvcGyCBY3IF0hPsoQ==" 
                                      hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                       hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
// aes256Decrypt.utf8String = 'kelp'
```


##CocoaSecurityResult
CocoaSecurityResult is the result class of CocoaSecurity. It provides convert result data to NSData, NSString, HEX string, Base64 string.

```objective-c
@property (strong, nonatomic, readonly) NSData *data;
@property (strong, nonatomic, readonly) NSString *utf8String;
@property (strong, nonatomic, readonly) NSString *hex;
@property (strong, nonatomic, readonly) NSString *hexLower;
@property (strong, nonatomic, readonly) NSString *base64;
```


##CocoaSecurityEncoder
CocoaSecurityEncoder provides convert NSData to HEX string, Base64 string.

```objective-c
- (NSString *)base64:(NSData *)data;
- (NSString *)hex:(NSData *)data useLower:(BOOL)isOutputLower;
```
**example:**
```objective-c
CocoaSecurityEncoder *encoder = [CocoaSecurityEncoder new];
NSString *str1 = [encoder hex:[@"kelp" dataUsingEncoding:NSUTF8StringEncoding] useLower:NO];
// str1 = '6B656C70'
NSString *str2 = [encoder base64:[@"kelp" dataUsingEncoding:NSUTF8StringEncoding]];
// str2 = 'a2VscA=='
```

##CocoaSecurityDecoder
CocoaSecurityEncoder provides convert HEX string or Base64 string to NSData.

```objective-c
- (NSData *)base64:(NSString *)data;
- (NSData *)hex:(NSString *)data;
```
**example:**
```objective-c
CocoaSecurityDecoder *decoder = [CocoaSecurityDecoder new];
NSData *data1 = [decoder hex:@"CC0A69779E15780ADAE46C45EB451A23"];
// data1 = <cc0a6977 9e15780a dae46c45 eb451a23>
NSData *data2 = [decoder base64:@"zT1PS64MnXIUDCUiy13RRg=="];
// data2 = <cd3d4f4b ae0c9d72 140c2522 cb5dd146>
```


##Installation
1. **git:**
```
$ git clone git://github.com/kelp404/CocoaSecurity.git
$ cd CocoaSecurity
$ git submodule update --init
```

2. **<a href="http://cocoapods.org/?q=CocoaSecurity" target="_blank">CocoadPods</a>:**  
add `Podfile` in your project path
```
platform :ios
pod 'CocoaSecurity'
```
```
$ pod install
```
