#import "BTThreeDSecureCardNonce.h"
#if __has_include("BraintreeCard.h")
#import "BTCardNonce_Internal.h"
#else
#import <BraintreeCard/BTCardNonce_Internal.h>
#endif


@interface BTThreeDSecureCardNonce ()

@property (nonatomic, strong) BTJSON *threeDSecureJSON;

@end

@implementation BTThreeDSecureCardNonce

- (instancetype)initWithPaymentMethodNonce:(NSString *)nonce
                               description:(NSString *)description
                               cardNetwork:(BTCardNetwork)cardNetwork
                                   lastTwo:(NSString *)lastTwo
                          threeDSecureJSON:(BTJSON *)threeDSecureJSON
{
    self = [super initWithPaymentMethodNonce:nonce description:description cardNetwork:cardNetwork lastTwo:lastTwo];
    if (self) {
        _threeDSecureJSON = threeDSecureJSON;
    }
    return self;
}

+ (instancetype)cardNonceWithJSON:(BTJSON *)cardJSON {
    BTThreeDSecureCardNonce *card = [super cardNonceWithJSON:cardJSON];
    card.threeDSecureJSON = cardJSON[@"threeDSecureInfo"];
    return card;
}

- (BOOL)liabilityShifted {
    return self.threeDSecureJSON[@"liabilityShifted"].isTrue;
}

- (BOOL)liabilityShiftPossible {
    return self.threeDSecureJSON[@"liabilityShiftPossible"].isTrue;
}

@end
