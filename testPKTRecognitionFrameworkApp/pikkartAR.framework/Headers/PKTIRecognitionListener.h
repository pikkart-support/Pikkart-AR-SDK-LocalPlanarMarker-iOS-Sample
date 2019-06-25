/* ===============================================================================
 * Copyright (c) 2016 Pikkart S.r.l. All Rights Reserved.
 * Pikkart is a trademark of Pikkart S.r.l., registered in Europe,
 * the United States and other countries.
 *
 * This file is part of Pikkart AR Recognition SDK.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ===============================================================================*/

#import <Foundation/Foundation.h>
#import "PKTINetworkInfoProvider.h"

@class PKTMarker;

/**
 * \protocol PKTIRecognitionListener
 * \brief PKTIRecognitionListener protocol
 *
 * This Procotol expose a list of methods use to track
 * the state of recognition process
 *
 */
@protocol PKTIRecognitionListener <NSObject, PKTINetworkInfoProvider>

@optional

/*! \brief Called whenever the current image is sent to the Pikkart Cloud Recognition Service.
 *
 */
-(void)executingCloudSearch;

/*! \brief Called whenever the Pikkart Cloud Recognition Service returns a negative response.
 *
 */
-(void)cloudMarkerNotFound;

/*! \brief called after check if internet Connection is not available but needed
 *
 */
-(void) internetConnectionNeeded;

/*! \brief called after marker has been found
 *
 *  \param marker a PKTMarker object encapsulating all the information about the marker just found
 */
-(void)markerFound:(PKTMarker *)marker;

/*! \brief Called whenever the Pikkart-AR SDK doesn't find any marker before the timeout exceed. This callback is called only 
 *  with RecognitionStorage set to GLOBAL and RecognitionMode set to TAP_TO_SCAN.
 *
 */
-(void) markerNotFound;

/*! \brief Called whenever the tracking of the marker is lost
 *
 *  \param markerId marker identifier
 */
-(void)markerTrackingLost:(NSString *)markerId;

/*! \brief Called whenever the ARLogo is found
 *
 *  \param markerId marker identifier
 *  \param code code associate with arlogo
 */
-(void)ARLogoFound:(NSString *) markerId withCode:(NSNumber *)code;

/**
 * \brief Called whenever the app has an old SDK and can't open new markers.
 *
 * Called whenever the app has an old SDK and can't open new markers.
 *
 * @param markerId The id of the marker that cannot be loaded.
 */
-(void)markerEngineToUpdate:(NSString *) markerId;

#pragma  mark - added for UhroSharp rendering
-(void) didUpdateFrameY:(void *)y andYSize:(CGSize)ySize
                  andUV:(void *)uv andUVSize:(CGSize)UVsize;

@end
