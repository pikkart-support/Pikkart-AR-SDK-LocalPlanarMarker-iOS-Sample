//
//  PKTInterestPoint.h
//  pikkartAR
//
//  Created by Roberto Avanzi on 12/10/15.
//  Copyright © 2015 Pikkart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKTInterestPoint : NSObject

+(PKTInterestPoint *)PKTInterestPointWithX:(float)x
        andY:(float)y
        andIpId:(int) ipid;
-(instancetype)initWithX:(float)x
                    andY:(float)y
                 andIpId:(int)ipid;

@property (nonatomic, readonly) int InternalID;
-(void)setPosX:(float)x andY:(float)y;
@property (nonatomic) NSString * PublicID;
@property (nonatomic, readonly) float X;
@property (nonatomic, readonly) float Y;

@end
