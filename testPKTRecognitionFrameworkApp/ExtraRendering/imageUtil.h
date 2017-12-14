/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Functions for loading an image files for textures.
 */

#pragma once

#include "glUtil.h"

typedef struct demoImageRec
{
	GLubyte* data;
	
	GLsizei size;
	
	GLuint width;
	GLuint height;
	GLenum format;
	GLenum type;
	
	GLuint rowByteSize;
	
} demoImage;

demoImage* imgLoadImage(const char* filepathname, int flipVertical);

void imgDestroyImage(demoImage* image);

int matrixMultiply(int rows1, int cols1, float mat1[], int rows2, int cols2, float mat2[], float result[]);
void mtxLoadIdentity(float* mtx);
void mtxTranspose(float m_in[], float m_out[]);

