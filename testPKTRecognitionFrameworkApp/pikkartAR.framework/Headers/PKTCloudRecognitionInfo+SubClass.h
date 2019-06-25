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

@interface PKTCloudRecognitionInfo (SubClass)

/*! \brief Create an PKTCloudRecognitionInfo with a Cloud Recognition server URL and a valid database name
 *
 *  PKTCloudRecognitionInfo constructor static method
 *  \param webURL an valid Cloud Server Recognition URL
 *  \param databaseName a valid database name
 */
+(PKTCloudRecognitionInfo *)PKTCloudRecognitionInfoWithWebURL:(NSString * )webURL
andDatabaseName:(NSString *)databaseName;

/*! \brief Create an PKTCloudRecognitionInfo with a Cloud Recognition server URL and a cloud database list
 *
 *  PKTCloudRecognitionInfo constructor static method
 *  \param webURL an valid Cloud Server Recognition URL
 *  \param databaseNames a list of NSString objects, each of them is a valid database name
 */
+(PKTCloudRecognitionInfo *)PKTCloudRecognitionInfoWithWebURL:(NSString * )webURL
andDatabaseNames:(NSArray *)databaseNames;

/*! \brief Create an PKTCloudRecognitionInfo with a Cloud Recognition server URL and a cloud database
 *
 *  PKTCloudRecognitionInfo init method
 *  \param webURL an valid Cloud Server Recognition URL
 *  \param databaseName a valid database name
 */
-(instancetype)initWithWebURL:(NSString * )webURL
andDatabaseName:(NSString *)databaseName;

/*! \brief Create an PKTCloudRecognitionInfo with a Cloud Recognition server URL and a cloud database list
 *
 *  PKTCloudRecognitionInfo init method
 *  \param webURL an valid Cloud Server Recognition URL
 *  \param databaseNames a list of NSString objects, each of them is a valid database name
 */
-(instancetype)initWithWebURL:(NSString * )webURL
andDatabaseNames:(NSArray *)databaseNames;

/*! \brief Set Cloud Recognition server URL
 *
 *  \param webURL an valid Cloud Server Recognition URL
 */
-(void)setWebURL:(NSString *)webURL;

@end
