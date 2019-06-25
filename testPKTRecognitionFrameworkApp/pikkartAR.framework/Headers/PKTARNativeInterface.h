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
#import <QuartzCore/QuartzCore.h>

extern NSString * PKTARNativeInterfaceInterestPointFoundNotification;
extern NSString * PKTARNativeInterfaceInterestPointLostNotification;
/**
 * \class PKTARNativeInterface
 * \brief The Pikkart Augmented Reality Native Interface
 *
 * The  Pikkart Augmented Reality  Native Interface
 * It is singleton class providing methods that build an objective c interface
 * on c++ recognition core
 *
 */
@interface PKTARNativeInterface : NSObject

#pragma mark - init
+(instancetype) sharedInstance;
+(void)Identity4x4:(float**)matrix;
+(void)setIdentity4x4:(float *)matrix;
+(void)copy4x4:(float *)in andOut:(float *)out;

-(void)initialize;
-(bool)InitRecognitionWithMinIntervalMarkNotFound:(int)min_interval_local_marker_not_found
                                    andAppDataDir:(char *)app_data_dir
                                    andCameraSize:(CGSize)cameraSize
                                      andDiagonal:(float)diagonal;
-(void)InitProjectionMatrixWithHFov:(float) hfov
                            andVFov:(float) vfov;
-(void)InitProjectionMatrixWithFx:(float)fx
                            andFy:(float)fy
                            andCx:(float)cx
                            andCy:(float)cy;
-(void)SetProjectionMatrixWithHFov:(float) hfov
                           andVFov:(float) vfov;
-(void)SetProjectionMatrix2WithFx:(float)fx
                            andFy:(float)fy
                            andCx:(float)cx
                            andCy:(float)cy;

#pragma mark - Camera Rendering
-(void)UpdateViewportWithSize:(CGSize)size
                     andAngle:(int)angle;
-(void) ForceInitCameraGL:(CGSize)cameraSize;
-(void) RenderCameraGLWithViewPortSize:(CGSize)viewPortSize
                            andAngle:(int)angle;
-(bool)ImageProcessing;
-(void)CopyNewFrameWithY:(unsigned char *) y
                   andUV:(unsigned char *)uv;
-(void) UpdateModelViewMatrix;
-(void)SetCameraOriginalSize:(CGSize)originalSize;

#pragma mark - Recognition
-(void)StartRecognitionWithOnlineRec:(bool)onlineRec
                           andEffect:(bool)effect;
-(void)StopRecognition;
-(bool)SaveLocalMarkerWithId:(char *) markerId
               andTargetDesc:(char *)targetDescriptor;
-(bool)DeleteLocalMarkerWithId:(char *)markerId;
-(void) StartEffect;
-(void) StopEffect;
-(void *) GetServerBuffer;
-(unsigned long)UpdateServerBuffer;
-(bool)ForceMarkerSearch:(char *) markerId;
-(bool)ForceMarkerSearchInternalId:(int)marker_internal_Id;
-(NSArray *)GetActiveMarkersInternalIDs;
-(bool)IsTrackingName:(char *)marker_database_Id;
-(bool)IsTrackingInternalID:(int) marker_internal_Id;
-(float)GetMarkerWidthName:(char *) marker_database_Id;
-(float)GetMarkerWidthInternalID:(int) marker_internal_Id;
-(float)GetMarkerHeightName:(char *) marker_database_Id;
-(float)GetMarkerHeightInternalID:(int) marker_internal_Id;
-(NSArray *)GetMarkerPoseName:(char *) marker_database_Id;
-(NSArray *)GetMarkerPoseInternalID:(int)marker_internal_Id;
-(void)ChangeMode:(bool)online;
-(bool)IsTracking;
-(id)GetCurrentMarker;
-(id)GetMarkerByDatabaseId:(char *)marker_database_id;

#pragma mark - interface versus c++ recognition library to objc
-(void)LocalMarkerFound:(int) marker_internal_id onDatabase:(char *)marker_database_id;
-(void)LocalMarkerNotFound;
-(void)MarkerTrackingLost:(int) marker_internal_id onDatabase:(char *)marker_database_id;
-(void)MarkerEngineToUpdate:(int) marker_internal_id onDatabase:(char *)marker_database_id;
-(void)ARLogoFound:(int)marker_internal_id
           onDatabase:(char *)marker_database_id
             withCode:(int)code;
-(void)syncMarkersWithFolder;
-(void)InterestPointFound:(int) ip_id;
-(void)InterestPointLost:(int) ip_id;

#pragma mark - GeoLocation methods
-(bool)StartGeolocation;
-(void)AddAugmentedMarker:(NSString *)Id andLatitude:(double)lat andLongitude:(double)longitude andAltitude:(double)altitude;
-(void)DeleteAugmentedMarker:(NSString *)Id;
-(double)UpdateUserPosition:(NSString *)Id andLatitude:(double)lat andLongitude:(double)longitude andAltitude:(double)altitude;
-(NSArray *)UpdateUserOrientation:(NSString *)Id;
-(void)UpdateProjectionCameraWithWidth:(int)cameraWidth
                            andHeight:(int)cameraHeight
                     andViewPortWidth:(int)viewPortWidth
                    andViewPortHeight:(int)viewportHeight
                              andAngle:(int)angle;
-(void) SetAccelerometerWithX:(float)x andY:(float)y andZ:(float)z;
-(void) SetMagneticWithX:(float)x andY:(float)y andZ:(float)z;
-(void) SetGyroWithX:(float)x andY:(float)y andZ:(float)z;
-(void) ComputeOrientation:(long) event_timestamp;
-(bool) IsLookingDown;
-(void)EnabledRecognition;
-(void)DisableRecognition;
-(void)SetOrientationMatrix:(double *)matrix;
#pragma mark - Discover
-(bool)loadDiscoverModel:(NSString *)modelName;
-(void)enableDiscover:(bool)enabled;
-(void)getPositionOfInterestPoint:(int)ip_id andPosition:(float *)pos;
-(NSString *)getInterestPointPublicID:(int)ip_id;
#pragma mark - crypto methods
+(NSString *)CreateSignatureWith:(NSString *) method
                         andBody:(NSString *) body
                         andDate:(NSString *) date
                         andPath:(NSString *) path;
+(bool)CheckLicense;
+(void)reset;
#pragma mark - property callbacks
@property (nonatomic) id recognitionManager;
@property(nonatomic,readonly) int cameraWidth;
@property(nonatomic,readonly) int cameraHeight;
@property (nonatomic,readonly) CGSize cameraSize;
@property(nonatomic,readonly) float * projectionMatrix;
@property(nonatomic) float * modelViewMatrix;

-(void)DecryptCalibParams:(void *)data
         withOutputParams:(float *)outParams;

#ifdef __URHO3D__
#pragma mark - methods for urhosharp rendering
-(void)GetYDataToRender:(unsigned char **)ydata;
-(void)GetUVDataToRender:(unsigned char **)uvdata;
#endif
@end
