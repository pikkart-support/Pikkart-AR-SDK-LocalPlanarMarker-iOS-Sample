//
//  PKTISyncMarkersDataInterface.h
//  pikkartAR
//
//  Created by Roberto Avanzi on 01/04/16.
//  Copyright © 2016 Pikkart. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PKTISyncMarkersDataInterface <NSObject>

@optional
-(void)didFinishSyncMarkerWithError:(NSError *)error;
-(void)progressWithValue:(double)value;
-(void)didFailMarkerDownload:(NSError *)error;
@end
