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
 * \class PKTCloudRecognitionInfo
 * \brief A class that encapsulates the information for the connection to the Pikkart Cloud Recognition Service
 *
 *
 *
 */
@interface PKTCloudRecognitionInfo : NSObject

/*! \brief Create an PKTCloudRecognitionInfo with a valid cloud database
 *
 *  PKTCloudRecognitionInfo constructor static method
 *  \param databaseName a valid cloud database name
 */
+(PKTCloudRecognitionInfo *)PKTCloudRecognitionInfoWithDatabaseName:(NSString *)databaseName;

/*! \brief Create an PKTCloudRecognitionInfo with a cloud database list
 *
 *  PKTCloudRecognitionInfo constructor static method
 *  \param databaseNames a list of NSString objects, each of them is a valid cloud database name
 */
+(PKTCloudRecognitionInfo *)PKTCloudRecognitionInfoWithDatabaseNames:(NSArray *)databaseNames;

/*! \brief Create an PKTCloudRecognitionInfo with a valid cloud database
 *
 *  PKTCloudRecognitionInfo init method
 *  \param databaseName a valid cloud database name
 */
-(instancetype)initWithDatabaseName:(NSString *)databaseName;

/*! \brief Create an PKTCloudRecognitionInfo with a cloud database list
 *
 *  PKTCloudRecognitionInfo init method
 *  \param databaseNames a list of NSString objects, each of them is a valid cloud database name
 */
-(instancetype)initWithDatabaseNames:(NSArray *)databaseNames;

-(NSString *)webURL;
@property (nonatomic,strong) NSString * databaseName;
@property (nonatomic,strong) NSArray * databaseNames; 

@end
