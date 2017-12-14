//
//  ViewController.swift
//  testPKTRecognitionFrameworkApp
//
//  Created by Roberto Avanzi on 01/08/16.
//  Copyright © 2016 Pikkart. All rights reserved.
//

import UIKit

class ViewController: PKTRecognitionController {

    var _ViewportWidth:CGFloat = 0, _ViewportHeight:CGFloat = 0
    var _Angle:Int = 0
    var _monkeyMesh:Mesh?
    
    var context:EAGLContext?
    
    @objc internal func chiudiRealtaAumentata(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        // here we define a common openGL view, not using multisampling
        self.context = EAGLContext(api: .openGLES3)
        let textureView:GLKView = GLKView(frame: UIScreen.main.bounds, context: self.context!)
        textureView.drawableColorFormat = .RGB565
        textureView.drawableDepthFormat = .format24
        textureView.drawableStencilFormat = .format8
    
        // Disable multisampling
        textureView.drawableMultisample = .multisampleNone
        
        self.view = textureView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        EAGLContext.setCurrent(self.context)
        // tutorial for local marker -- uncomment
        _monkeyMesh = Mesh(meshFile: Bundle.main.path(forResource: "monkey", ofType: "json")!,
                           textureFile: Bundle.main.path(forResource: "texture", ofType: "png")!)
        
        glClearColor(1.0, 1.0, 1.0, 1.0)
        self.updateViewPortWithOrientation()
        
        // Do any additional setup after loading the view, typically from a nib.
        // -- tutorial for local marker recognition
        // -- tutorial for augmented video
        
        let authInfo:PKTCloudRecognitionInfo = PKTCloudRecognitionInfo(databaseName: "")
        let options:PKTRecognitionOptions = PKTRecognitionOptions(recognitionStorage:.PKTLOCAL,
                                                                             andMode: .PKTRECOGNITION_CONTINUOS_SCAN,
                                                                    andCloudAuthInfo:authInfo )
        
        self.startRecognition(options, andRecognitionCallback:self)
        
        // -- tutorial for cloud marker recognition
        /*
         let authInfo:PKTCloudRecognitionInfo = PKTCloudRecognitionInfo(databaseName: "")
         let options:PKTRecognitionOptions = PKTRecognitionOptions(recognitionStorage:.PKTGLOBAL,
         andMode: .PKTRECOGNITION_TAP_TO_SCAN,
         andCloudAuthInfo:authInfo )
         
         self.startRecognition(options, andRecognitionCallback:self)
        */
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return .all
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: {
            context in
            self.updateViewPortWithOrientation()
            }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    internal func updateViewPortWithOrientation() {
        let orientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        let mainScreen:UIScreen=UIScreen.main
        let boundScreen:CGRect=mainScreen.bounds
        let scale:CGFloat=mainScreen.scale
        var widthPort:CGFloat=boundScreen.size.width*scale;
        var heightPort:CGFloat=boundScreen.size.height*scale;
        
        if (scale == 3) // iPhone 6 plus non è un vero @3x, ma c'e' un downsampling
            // http://www.paintcodeapp.com/news/iphone-6-screens-demystified
        {
            widthPort=widthPort/1.15;
            heightPort=heightPort/1.15;
        }
        
        var angle:Int=90;
        
        switch (orientation) {
        case .portrait:
            angle=90
        case .landscapeRight:
            angle=0
        case .landscapeLeft:
            angle=180
        case .portraitUpsideDown:
            angle=270
        default:
            break
        }
        self.UpdateViewPortWithSize(CGSize(width: widthPort,height: heightPort), angle: angle)
    }

    internal func UpdateViewPortWithSize(_ size:CGSize, angle:Int) {
        _ViewportWidth = size.width;
        _ViewportHeight = size.height;
        _Angle = angle;
    }
    
    internal func computeModelViewProjectionMatrix(_ mvpMatrix:[Float]) -> Bool {
        let w:Float = 640, h:Float = 480
        
        RenderUtils.createIdentity(UnsafeMutablePointer(mutating: mvpMatrix))
        
        var ar:Float = Float(_ViewportHeight/_ViewportWidth)
        
        if (_ViewportHeight > _ViewportWidth)  {ar = 1.0 / ar}
        
        var h1:Float = h, w1:Float = w
        
        if (ar < h/w) {
            h1 = w * ar
        }
        else {
            w1 = h / ar
        }
        
        var a:Float = 0, b:Float = 0
        
        switch (_Angle) {
        case 0:
            a = 1; b = 0
        case 90:
            a = 0; b = 1
        case 180:
            a = -1; b = 0
        case 270:
            a = 0; b = -1
        default: break
        }
        
        var angleMatrix:[Float] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        
        angleMatrix[0] = a; angleMatrix[1] = b; angleMatrix[2]=0.0; angleMatrix[3] = 0.0;
        angleMatrix[4] = -b; angleMatrix[5] = a; angleMatrix[6] = 0.0; angleMatrix[7] = 0.0;
        angleMatrix[8] = 0.0; angleMatrix[9] = 0.0; angleMatrix[10] = 1.0; angleMatrix[11] = 0.0;
        angleMatrix[12] = 0.0; angleMatrix[13] = 0.0; angleMatrix[14] = 0.0; angleMatrix[15] = 1.0;
        
        var tempPtr:UnsafeMutablePointer<Float>? = nil
        
        self.getCurrentProjectionMatrix(&tempPtr)
        
        var projectionMatrix:[Float] = Array(UnsafeBufferPointer(start:tempPtr, count: 16))
        
        projectionMatrix[5] = projectionMatrix[5] * (h / h1);
        
        let correctedProjection:[Float] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        
        RenderUtils.makeMatrixMultiply(4, cols1: 4, mat1: UnsafeMutablePointer( mutating:angleMatrix), row1: 4, cols2: 4, mat2: UnsafeMutablePointer(mutating:projectionMatrix), result: UnsafeMutablePointer(mutating: correctedProjection))
        
        if self.isTracking() {
            var modelviewMatrix:UnsafeMutablePointer<Float>? = nil
            let temp_mvp:[Float] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            
            self.getCurrentModelViewMatrix(&modelviewMatrix)
            
            RenderUtils.makeMatrixMultiply(4, cols1: 4, mat1: UnsafeMutablePointer(mutating:correctedProjection), row1: 4, cols2: 4, mat2: modelviewMatrix!, result:UnsafeMutablePointer(mutating:temp_mvp))
            RenderUtils.makeTranspose(UnsafeMutablePointer(mutating:temp_mvp),m_out: UnsafeMutablePointer(mutating:mvpMatrix))
            
            return true
        }
        
        return false
        
    }
    
    internal func computeProjectionMatrix(_ mvpMatrix:[Float]) -> Bool {
        let w:Float = 640, h:Float = 480
        
        RenderUtils.createIdentity(UnsafeMutablePointer(mutating: mvpMatrix))
        
        var ar:Float = Float(_ViewportHeight/_ViewportWidth)
        
        if (_ViewportHeight > _ViewportWidth)  {ar = 1.0 / ar}
        
        var h1:Float = h, w1:Float = w
        
        if (ar < h/w) {
            h1 = w * ar
        }
        else {
            w1 = h / ar
        }
        
        var a:Float = 0, b:Float = 0
        
        switch (_Angle) {
        case 0:
            a = 1; b = 0
        case 90:
            a = 0; b = 1
        case 180:
            a = -1; b = 0
        case 270:
            a = 0; b = -1
        default: break
        }
        
        var angleMatrix:[Float] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        
        angleMatrix[0] = a; angleMatrix[1] = b; angleMatrix[2]=0.0; angleMatrix[3] = 0.0;
        angleMatrix[4] = -b; angleMatrix[5] = a; angleMatrix[6] = 0.0; angleMatrix[7] = 0.0;
        angleMatrix[8] = 0.0; angleMatrix[9] = 0.0; angleMatrix[10] = 1.0; angleMatrix[11] = 0.0;
        angleMatrix[12] = 0.0; angleMatrix[13] = 0.0; angleMatrix[14] = 0.0; angleMatrix[15] = 1.0;
        
        var tempPtr:UnsafeMutablePointer<Float>? = nil
        
        self.getCurrentProjectionMatrix(&tempPtr)
        
        var projectionMatrix:[Float] = Array(UnsafeBufferPointer(start:tempPtr, count: 16))
        
        projectionMatrix[5] = projectionMatrix[5] * (h / h1);
        
        
        RenderUtils.makeMatrixMultiply(4, cols1: 4, mat1: UnsafeMutablePointer( mutating: angleMatrix), row1: 4, cols2: 4, mat2: UnsafeMutablePointer(mutating:projectionMatrix), result: UnsafeMutablePointer(mutating:mvpMatrix))
        
        return false
        
    }
    
    //MARK: GLView rendering callback
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        if (!self.isActive()) {
            return
        }
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT));
        
        self.renderCamera(withViewPortSize: CGSize(width: _ViewportWidth, height: _ViewportHeight), andAngle: Int32(_Angle))
        // Call our native function to render content
        if self.isTracking() {
            if let currentMarker = self.getCurrentMarker() {
                if (currentMarker.markerId! == "3_543") {
                    var mvpMatrix:[Float] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
                    
                    // Tutorial for Local Recognition -
                    if (self.computeModelViewProjectionMatrix(mvpMatrix))
                    {
                        _monkeyMesh!.DrawMesh(&mvpMatrix)
                        RenderUtils.checkGLError()
                    }
                }
            }

        }
        
        glFinish();
    }
    
    //# MARK: PKTIRecognitionListener methods
    override func executingCloudSearch() {
        print("executingCloudSearch called")
    }
    
    override func cloudMarkerNotFound() {
        print("cloudMarkerNotFound called")
        
    }
    
    override func markerNotFound() {
        print("markerNotFound called")
        
    }
    
    override func markerTrackingLost(_ markerId: String) {
        print("markerTrackingLost called with Id = \(markerId)")
        /* local planar recognition
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: "Lost Marker",
                                                    message: "marker lost with id"+markerId, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK button touched")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        */
    }
    
    override func internetConnectionNeeded() {
        print("internetConnectionNeeded called")
        
    }
    
    override func markerFound(_ marker: PKTMarker!) {
        print("markerFound called with Id =\(marker.markerId!)")
    /* local planar recognition
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: "Marker Found", message: "marker Found with id"+marker.markerId!, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK button touched")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
     */
    }
    /*
    override func isConnectionAvailable() -> Bool {
        return false
    }
   */
    
}

