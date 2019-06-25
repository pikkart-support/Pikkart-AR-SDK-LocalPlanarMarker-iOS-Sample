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
#import "PKTCloudRecognitionInfo.h"

/*! \brief enum PKTRecognitionStorage
 */
typedef NS_ENUM(int, PKTRecognitionStorage) {
    PKTLOCAL, /*!< search marker in local database */
    PKTGLOBAL /*!< Search marker in local database and in the cloud. This mode is available only with PKTRecognitionMode set to PKTRECOGNITION_TAP_TO_SCAN. */
};

/*! \brief enum PKTRecognitionMode
 */
typedef NS_ENUM(NSUInteger, PKTRecognitionMode)
{
    PKTRECOGNITION_TAP_TO_SCAN = 0, /*!< Stop after a ten second timeout if it doesn't find any marker. Stop searching for new markers after first recognition */
    PKTRECOGNITION_CONTINUOS_SCAN /*!< Scan continuously for new markers. This mode is available only with PKTRecognitionStorage set to PKTLOCAL.  */
};

/**
 * \class PKTRecognitionOptions
 * \brief Pikkart Recognition Process tracking options
 *
 * PKTRecognitionOptions defines some options that user
 * can set for the recognition tracking process
 *
 */
@interface PKTRecognitionOptions : NSObject


/*! \brief create and initialize PKTRecognitionOptions object with storage and cloud Info
 *
 *  \param storage PKTRecognitionStorage parameter
 *  \param PKTRecognitionMode parameter
 *  \return a PKTRecognitionOptions object
 */
+(PKTRecognitionOptions *)PKTRecognitionOptionsWithRecognitionStorage:(PKTRecognitionStorage)storage
                                                              andMode:(PKTRecognitionMode)mode
                                                     andCloudAuthInfo:(PKTCloudRecognitionInfo *)cloudAuthInfo;

/*! \brief initialize PKTRecognitionOptions object with storage, mode and cloud Info
 *
 *  \param storage PKTRecognitionStorage parameter
 *  \param PKTRecognitionMode parameter
 *  \return a PKTRecognitionOptions object
 */
-(instancetype) initWithRecognitionStorage:(PKTRecognitionStorage)storage
                                   andMode:(PKTRecognitionMode)mode
                          andCloudAuthInfo:(PKTCloudRecognitionInfo *)cloudAuthInfo;

/*! \brief Get storage parameter
 *
 *  \return PKTRecognitionStorage
 */
@property (nonatomic) PKTRecognitionStorage storage;

/*! \brief Get mode parameter
 *
 *  \return PKTRecognitionMode
 */
@property (nonatomic) PKTRecognitionMode mode;

/*! \brief Get cloudAuthInfo parameter
 *
 *  \return PKTCloudRecognitionInfo
 */
@property (nonatomic) PKTCloudRecognitionInfo * cloudAuthInfo;

@end
