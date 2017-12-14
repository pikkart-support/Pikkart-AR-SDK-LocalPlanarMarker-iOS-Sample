//
//  Mesh.swift
//  testPKTRecognitionFrameworkApp
//
//  Created by Roberto Avanzi on 01/08/16.
//  Copyright © 2016 Pikkart. All rights reserved.
//

import UIKit

open class Mesh: NSObject {
    
    var _Indices_Number:Int
    var _Vertices_Number:Int
    var _Texture_GL_ID:GLuint, _Program_GL_ID:GLuint
    var _vertices_buffer:[Float], _normals_buffer:[Float],
        _tex_vertices_buffer:[Float];
    var _indexes_buffer:[UInt16]
    var _indexes_number:Int;
    
    internal static let MESH_VERTEX_SHADER:String = "\n\n"+"attribute vec4 vertexPosition;\n"+"attribute vec2 vertexTexCoord;\n\n"+"varying vec2 texCoord;\n\n"+"uniform mat4 modelViewProjectionMatrix;\n\n"+"void main() \n{\n"+"   gl_Position = modelViewProjectionMatrix * vertexPosition;\n"+"   texCoord = vertexTexCoord;\n"+"}\n"
    
    internal static let MESH_FRAGMENT_SHADER:String = "\n\n"+"precision mediump float;\n\n"+"varying vec2 texCoord;\n\n"+"uniform sampler2D texSampler2D;\n\n"+"void main()\n{\n"+"   gl_FragColor = texture2D(texSampler2D, texCoord);\n"+"   //gl_FragColor = vec4(1.0,0.0,0.0,1.0);\n"+"}\n"
    
    //MARK: init method
    init(meshFile:String, textureFile:String) {
        _Indices_Number = 0; _Vertices_Number = 0; _Texture_GL_ID = 0 ; _Program_GL_ID = 0
        _indexes_number = 0
        _vertices_buffer = []; _normals_buffer = []; _tex_vertices_buffer = []
        _indexes_buffer = []
        
        _Texture_GL_ID = GLuint(RenderUtils.loadTextureFromFileName(textureFile))
        _Program_GL_ID = GLuint(RenderUtils.createProgram(Mesh.MESH_VERTEX_SHADER, fragmentShaderSrc: Mesh.MESH_FRAGMENT_SHADER))
        super.init()
        
        do {
            try LoadMesh(meshFile)
        } catch {
            print("Error, mesh not loaded")
        }
        
    }
    //MARK: DrawMesh method
    open func DrawMesh(_ modelViewProjection:UnsafePointer<Float>) {
        glEnable(GLenum(GL_DEPTH_TEST));
        glDisable(GLenum(GL_CULL_FACE));
        
        glUseProgram(_Program_GL_ID);
        
        RenderUtils.checkGLError()
        
        let vertexHandle = glGetAttribLocation(_Program_GL_ID, "vertexPosition");
        let textureCoordHandle = glGetAttribLocation(_Program_GL_ID, "vertexTexCoord");
        let mvpMatrixHandle = glGetUniformLocation(_Program_GL_ID, "modelViewProjectionMatrix");
        let texSampler2DHandle = glGetUniformLocation(_Program_GL_ID, "texSampler2D");
        
        RenderUtils.checkGLError()
        
        
        glVertexAttribPointer(GLuint(vertexHandle), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, _vertices_buffer);
        glVertexAttribPointer(GLuint(textureCoordHandle), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, _tex_vertices_buffer);
        
        glEnableVertexAttribArray(GLuint(vertexHandle));
        glEnableVertexAttribArray(GLuint(textureCoordHandle));
        
        RenderUtils.checkGLError()
        
        // activate texture 0, bind it, and pass to shader
        glActiveTexture(GLenum(GL_TEXTURE0));
        glBindTexture(GLenum(GL_TEXTURE_2D), _Texture_GL_ID);
        glUniform1i(texSampler2DHandle, 0);
        RenderUtils.checkGLError()
        
        // pass the model view matrix to the shader
        glUniformMatrix4fv(mvpMatrixHandle, 1, GLboolean(GL_FALSE), modelViewProjection);
        
        RenderUtils.checkGLError()
        
        // finally draw the monkey
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(_indexes_number), GLenum(GL_UNSIGNED_SHORT), _indexes_buffer);
        
        RenderUtils.checkGLError()
        
        glDisableVertexAttribArray(GLuint(vertexHandle));
        glDisableVertexAttribArray(GLuint(textureCoordHandle));
        
        RenderUtils.checkGLError()
    }
    
    internal func verticesToFloat(_ verticesArray:[Double]) -> [Float] {
        let xIndex = 0, yIndex = 1, zIndex = 2
        let nbrVertices = verticesArray.count
        var vertices:[Float] = []
        var i = 0
        
        while (i < nbrVertices) { // maybe we can use map here...
            vertices.insert(Float(verticesArray[i+xIndex] * -0.2 + 0.5), at: i+xIndex)
            vertices.insert(Float(verticesArray[i+yIndex] * -0.2 + 0.5), at: i+yIndex)
            vertices.insert(Float(verticesArray[i+zIndex] * -0.2), at: i+zIndex)
            i = i + 3
        }
        return vertices
    }
    
    internal func toFloatArray(_ verticesArray:[Double]) -> [Float] {
        return verticesArray.map({
                (value:Double) -> Float in
                return Float(value)
            })
    }
    
    internal func toShortIntArray(_ verticesArray:[Double]) -> [UInt16] {
        return verticesArray.map({
            (value:Double) -> UInt16 in
            return UInt16(value)
        })
    }
    
    internal func LoadMesh(_ fileNamePath:String) throws -> Bool {
        
        if let inputStream:InputStream = InputStream(fileAtPath: fileNamePath) {
            inputStream.open()
            do {
                let jsonMesh:[String:AnyObject] = try JSONSerialization.jsonObject(with: inputStream,
                                                                                options: []) as! [String:AnyObject]
                var values:[AnyObject]
                
                if let arrayVertices = jsonMesh["vertices"] as? [[String:AnyObject]] {
                    for dictVertices in arrayVertices {
                        values = dictVertices["values"] as! [AnyObject]
                    
                        if (dictVertices["name"] as! String == "position_buffer") {
                        _vertices_buffer = self.verticesToFloat(values as! [Double])
                        } else if (dictVertices["name"] as! String == "normal_buffer") {
                        _normals_buffer = self.toFloatArray(values as! [Double])
                        } else if (dictVertices["name"] as! String == "texcoord_buffer") {
                        _tex_vertices_buffer = self.toFloatArray(values as! [Double])
                        }
                    }
                }
                if let arrayTriangles = jsonMesh["connectivity"] as? [[String:AnyObject]] {
                    for dictTriangles in arrayTriangles {
                        if (dictTriangles["name"] as! String == "triangles") {
                            values = dictTriangles["indices"] as! [AnyObject]
                            _indexes_number = Int(values.count)
                            _indexes_buffer = self.toShortIntArray(values as! [Double])
                        }
                    }
                }
            } catch let error {
                print("decode json with error! \(error)")
            }
            inputStream.close()
        }
        return true
    }
    
}
