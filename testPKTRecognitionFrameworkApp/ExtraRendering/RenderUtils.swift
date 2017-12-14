//
//  RenderUtils.swift
//  testPKTRecognitionFrameworkApp
//
//  Created by Roberto Avanzi on 01/08/16.
//  Copyright © 2016 Pikkart. All rights reserved.
//

import UIKit
import OpenGLES

open class RenderUtils: NSObject {

    static func initShader(_ shaderType:Int, source:String) -> Int {
        
        var logLength:GLint = 0
        var status:GLint = 0
        let shader:GLuint = glCreateShader(GLenum(shaderType))
        let tempString = source as NSString
        var shaderCString = UnsafePointer<GLchar>(tempString.utf8String)

        if (shader != 0) {
            glShaderSource(shader, GLsizei(1), &shaderCString, nil)
            glCompileShader(shader)
            glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            
            if (logLength > 0) {
                let log:[GLchar] = [GLchar]()
                glGetShaderInfoLog(shader, GLsizei(logLength), nil,
                                   UnsafeMutablePointer(mutating: log))
                print("Vtx Shader compile log: \(log)\n")
            }
            glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status);
            if (status == 0) {
                print("Failed to compile vtx shader: \(source)\n")
            }
        }
        return Int(shader)
    }
    /*
     - (BOOL)validateProgram:(GLuint)prog
     {
     GLint logLength, status;
     
     glValidateProgram(prog);
     glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
     if (logLength > 0)
     {
     GLchar *log = (GLchar *)malloc(logLength);
     glGetProgramInfoLog(prog, logLength, &logLength, log);
     NSLog(@"Program validate log:\n%s", log);
     free(log);
     }
     
     glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
     if (status == 0)
     return FALSE;
     
     return TRUE;
     }
     */
    static func validateProgram(_ prog:GLuint) -> Bool {
        
        var logLength:GLint = 0, status:GLint = 0
        
        glValidateProgram(prog);
        glGetProgramiv(prog, GLuint(GL_INFO_LOG_LENGTH), &logLength);
        if (logLength > 0)
        {
            let log:[GLchar] = []
            glGetProgramInfoLog(prog, logLength, &logLength, UnsafeMutablePointer(mutating: log));
            print("Program validate log:\(log)\n")
        }
        
        glGetProgramiv(prog, GLuint(GL_VALIDATE_STATUS), &status);
        if (status == 0) {return false}
        
        return true
    }
    
    static func createProgram(_ vertexShaderSrc:String, fragmentShaderSrc:String) -> Int {
        
        let vertShader:GLuint = GLuint(initShader(Int(GL_VERTEX_SHADER), source: vertexShaderSrc));
        let fragShader:GLuint = GLuint(initShader(Int(GL_FRAGMENT_SHADER), source: fragmentShaderSrc));
        
         if (vertShader == 0 || fragShader == 0)
         {
         return 0;
         }
        
         var programStatus:GLint = 0, logLength:GLint = 0;
         let program:GLuint = glCreateProgram();
         
         if (program != 0) {
            glAttachShader(program, vertShader);
            glAttachShader(program, fragShader);
            glLinkProgram(program);
         
             glGetProgramiv(program, GLuint(GL_INFO_LOG_LENGTH), &logLength);
             if (logLength > 0)
             {
             let log:[GLchar] = []
             glGetProgramInfoLog(program, logLength, nil,  UnsafeMutablePointer(mutating: log));
             print("Program link log:\n\(log)\n");
             }
             
             glGetProgramiv(program, GLuint(GL_LINK_STATUS), &programStatus);
             if (programStatus == 0)
             {
             print("Failed to link program:\n)");
             return 0;
             }
         }
         return Int(program);
    }
    
    internal static func buildTexture(_ image:demoImage) -> GLuint {
        var  texName:GLuint = 0;
        
        // Create a texture object to apply to model
        glGenTextures(1, &texName);
        glBindTexture(GLuint(GL_TEXTURE_2D), texName);
        
        // Set up filter and wrap modes for this texture object
        glTexParameteri(GLuint(GL_TEXTURE_2D), GLuint(GL_TEXTURE_MIN_FILTER), GL_NEAREST);

        /*
        glTexParameteri(GLuint(GL_TEXTURE_2D), GLuint(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLuint(GL_TEXTURE_2D), GLuint(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLuint(GL_TEXTURE_2D), GLuint(GL_TEXTURE_MAG_FILTER), GL_LINEAR);
        glTexParameteri(GLuint(GL_TEXTURE_2D), GLuint(GL_TEXTURE_MIN_FILTER), GL_LINEAR_MIPMAP_LINEAR);
        */
        
        // Indicate that pixel rows are tightly packed
        //  (defaults to stride of 4 which is kind of only good for
        //  RGBA or FLOAT data types)
        //glPixelStorei(GLuint(GL_UNPACK_ALIGNMENT), 1);
        
        // Allocate and load image data into texture
        glTexImage2D(GLuint(GL_TEXTURE_2D), 0, GLint(image.format), GLsizei(image.width), GLsizei(image.height), 0,
                     image.format, image.type, image.data);
        
        // Create mipmaps for this texture for better image quality
        //glGenerateMipmap(GLuint(GL_TEXTURE_2D));
        
        checkGLError();
        
        return texName;
    }
    
    static func loadTextureFromFileName(_ filePathName:String) -> Int {
        let cString = filePathName.cString(using: String.Encoding.ascii)
        let image:demoImage = imgLoadImage(UnsafeMutablePointer(mutating: cString!), 1).pointee
        
        return Int(buildTexture(image))
    }
    
    static func loadTextureFromFileName(_ filePathName:String, dims:inout CGSize) -> Int {
        let cString = filePathName.cString(using: String.Encoding.ascii)
        let image:demoImage = imgLoadImage(UnsafeMutablePointer(mutating: cString!), 1).pointee
        dims = CGSize(width:CGFloat(image.width), height:CGFloat(image.height))
        
        return Int(buildTexture(image))
    }

    static func checkGLError() -> Void {
        var err:GLenum = glGetError()
        
        while (err != GLenum(GL_NO_ERROR)) {
            print("GLError \(GetGLErrorString(err))")
            err = glGetError()
        }
    }
    
    static func makeMatrixMultiply(_ rows1:Int, cols1:Int, mat1:UnsafeMutablePointer<Float>, row1:Int,
                               cols2:Int, mat2:UnsafeMutablePointer<Float>, result:UnsafeMutablePointer<Float>) -> Int {
        return Int(matrixMultiply(Int32(rows1), Int32(cols1), mat1, Int32(row1), Int32(cols2), mat2, result));

    }
    
    static func createIdentity(_ mtx:UnsafeMutablePointer<Float>) -> Void {
        mtxLoadIdentity(mtx);
    }
    
    static func makeTranspose(_ m_in:UnsafeMutablePointer<Float>, m_out:UnsafeMutablePointer<Float>) {
        mtxTranspose(m_in, m_out);
    }
    
    static func createVideoTexture() -> Int {
        var textureID:GLuint = 0
        
        glGenTextures(1, &textureID);
        glBindTexture(GLenum(GL_TEXTURE_2D), textureID);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR);
        glTexParameterf(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GLfloat(GL_CLAMP_TO_EDGE));
        glTexParameterf(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GLfloat(GL_CLAMP_TO_EDGE));
        glBindTexture(GLenum(GL_TEXTURE_2D), 0);
        
        return Int(textureID);
    }
}
