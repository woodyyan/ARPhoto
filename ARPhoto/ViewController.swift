//
//  ViewController.swift
//  ARPhoto
//
//  Created by Songbai Yan on 2018/6/29.
//  Copyright © 2018 EasyStudio. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addGesture()
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(sender:)))
        gesture.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(gesture)
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        let photoPlane = SCNBox(width: 0.07, height: 0.12, length: 0.001, chamferRadius: 1)
        let image = getScreenImage()
        
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        
        photoPlane.firstMaterial?.diffuse.contents = image
//        photoPlane.firstMaterial?.diffuse.contents = UIColor.green
        
        let photoNode = SCNNode(geometry: photoPlane)
        let frame = self.sceneView.session.currentFrame!
        photoNode.position = SCNVector3Make(frame.camera.transform.columns.3.x, frame.camera.transform.columns.3.y, frame.camera.transform.columns.3.z)
        self.sceneView.scene.rootNode.addChildNode(photoNode)
    }
    
    private func getScreenImage() -> UIImage {
        let size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
