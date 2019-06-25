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

/**
 * \class PKTMarkerDatabase
 * \brief PKTMarkerDatabase class
 *
 * The PKTMarkerDatabase is a class that model a single marker database 
 * used into recognition process
 *
 *
 */
@interface PKTMarkerDatabase : NSObject

/*! \brief create and initialize PKTMarkerDatabase object
 *
 *  \param code database code identifier
 *  \param customData custom data associated to database
 *  \return a PKTMarkerDatabase object
 */
+(PKTMarkerDatabase *)PKTMarkerDatabaseWithCode:(NSString *)code
                                  andCustomData:(NSString *)customData;

/*! \brief initialize PKTMarkerDatabase object
 *
 *  \param code database code identifier
 *  \param customData custom data associated to database
 *  \return a PKTMarkerDatabase object
 */
-(instancetype)initWithCodeDatabase:(NSString *)code
                      andCustomData:(NSString *)customData;

/*! \brief code property
 *
 *  \return database code identifier
 */
@property (nonatomic,readonly) NSString * code;

/*! \brief customData property
 *
 *  \return custom data associated to database
 */
@property (nonatomic,readonly) NSString * customData;

@end
