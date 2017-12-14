/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Functions for loading an image files for textures.
 */

#include "imageUtil.h"

#import <UIKit/UIKit.h>

int matrixMultiply(int rows1, int cols1, float mat1[], int rows2, int cols2, float mat2[], float result[])
{
    if( cols1 != rows2 )
    {
        return 0;
    }
    else
    {
        float tempResult;
        for (int i=0;i<rows1;i++)
        {
            for(int j=0;j<cols2;j++)
            {
                tempResult = 0;
                for(int k=0;k<rows2;k++)
                {
                    tempResult += mat1[i*cols1 + k] * mat2[k*cols2 + j];
                }
                result[i*cols2 + j] = tempResult;
            }
        }
    }
    return 1;
}

void mtxLoadIdentity(float* mtx) {
    
    mtx[ 0] = mtx[ 5] = mtx[10] = mtx[15] = 1.0f;
    
    mtx[ 1] = mtx[ 2] = mtx[ 3] = mtx[ 4] =
    mtx[ 6] = mtx[ 7] = mtx[ 8] = mtx[ 9] =
    mtx[11] = mtx[12] = mtx[13] = mtx[14] = 0.0;
}

void mtxTranspose(float m_in[], float m_out[]) {
    
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 4; j++)
            m_out[i * 4 + j] = m_in[i + 4 * j];
}

demoImage* imgLoadImage(const char* filepathname, int flipVertical)
{
	NSString *filepathString = [[NSString alloc] initWithUTF8String:filepathname];
	
	UIImage* imageClass = [[UIImage alloc] initWithContentsOfFile:filepathString];

	
	CGImageRef cgImage = imageClass.CGImage;
	if (!cgImage)
	{
		return NULL;
	}
	
	demoImage* image = malloc(sizeof(demoImage));
	image->width = (GLuint)CGImageGetWidth(cgImage);
	image->height = (GLuint)CGImageGetHeight(cgImage);
	image->rowByteSize = image->width * 4;
	image->data = malloc(image->height * image->rowByteSize);
	image->format = GL_RGBA;
	image->type = GL_UNSIGNED_BYTE;
	
	CGContextRef context = CGBitmapContextCreate(image->data, image->width, image->height, 8, image->rowByteSize, CGImageGetColorSpace(cgImage), kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);
	CGContextSetBlendMode(context, kCGBlendModeCopy);
	if(flipVertical)
	{
		CGContextTranslateCTM(context, 0.0, image->height);
		CGContextScaleCTM(context, 1.0, -1.0);
	}
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, image->width, image->height), cgImage);
	CGContextRelease(context);
	
	if(NULL == image->data)
	{
		imgDestroyImage(image);
		return NULL;
	}

	return image;
}

void imgDestroyImage(demoImage* image)
{
	free(image->data);
	free(image);
}