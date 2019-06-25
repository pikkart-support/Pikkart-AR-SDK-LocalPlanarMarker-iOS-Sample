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
#import "PKTMarkerDatabase.h"

/**
 * \class PKTMarker
 * \brief PKTMarker class
 *
 * The PKTMarker is a class that model a single marker used into
 * recognition process
 *
 *
 */
@interface PKTMarker : NSObject

/*! \brief create and initialize PKTMarker object
 *
 *  \param markerId marker identifier
 *  \param internalId marker internal identifier
 *  \param customData custom Data
 *  \param markerDatabase marker Database
 *  \param width marker Width
 *  \param height marker Height
 *  \return a PKTMarker object
 */
+(PKTMarker *)PKTMarker:(NSString *)markerId
               withInternalId:(NSNumber *)internalId
          andCustomData:(NSString *)customData
      andMarkerDatabase:(PKTMarkerDatabase *)markerDatabase
               andWidth:(float)width
               andHeight:(float)height;

/*! \brief initialize PKTMarker object
 *
 *  \param markerId marker identifier
 *  \param internalId marker internal identifier
 *  \param customData custom Data
 *  \param markerDatabase marker Database
 *  \param width marker Width
 *  \param height marker Height
 *  \return a PKTMarker object
 */
-(instancetype)initWithMarker:(NSString *)markerId
               withInternalId:(NSNumber *)internalId
                andCustomData:(NSString *)customData
            andMarkerDatabase:(PKTMarkerDatabase *)markerDatabase
                     andWidth:(float)width
                    andHeight:(float)height;

/*! \brief markerId property
 *
 *  \return a marker identifier
 */
@property (nonatomic, readonly) NSString * markerId;

/*! \brief internalId property
 *
 *  \return a marker internal id
 */
@property (nonatomic, readonly) NSNumber * internalId;


/*! \brief width property
 *
 *  \return marker width
 */
@property (nonatomic,readonly) float width;

/*! \brief height property
 *
 *  \return marker width
 */
@property (nonatomic,readonly) float height;

/*! \brief customData property
 *
 *  \return customData associated to marker
 */
@property (nonatomic, strong) NSString * customData;

/*! \brief markerDatabase property
 *
 *  \return PKTMarkerDatabase object associated to marker
 */
@property (nonatomic, strong) PKTMarkerDatabase * markerDatabase;

@property (nonatomic, getter=isTracking) bool tracking;
@property (nonatomic,getter=isArLogoEnabled) bool arLogoEnabled;
@property (nonatomic) int patternCode;

@end
