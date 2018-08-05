//
//  FeedListController.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/01.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class FeedListController: NSViewController {
    @IBOutlet var treeController: NSTreeController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        treeController.managedObjectContext = appDelegate.persistentContainer.viewContext
        treeController.fetch(nil)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.characters {
        case "s":
            selectNext(direction: +1)
        case "a":
            selectNext(direction: -1)
        case "j":
            fallthrough
        case "k":
            let splitView = view.superview?.superview as? NSSplitView
            view.window?.makeFirstResponder(splitView?.arrangedSubviews.last?.subviews.first)
        default:
            ()
        }
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    func selectNext(direction: Int) {
        guard let selectedNode = treeController.selectedNodes.first else {
            treeController.setSelectionIndexPath([0])
            return
        }
        guard let indexPath = getNextNode(node: selectedNode, direction: direction)?.indexPath else {
            return
        }
        treeController.setSelectionIndexPath(indexPath)
        feedSelectedAction(self)
    }
    
    func getNextNode(node: NSTreeNode, direction: Int) -> NSTreeNode? {
        if !node.isLeaf {
            return direction > 0 ? node.children?.first : node.children?.last
        }
        
        let indexPath = node.indexPath
        if let sibling = node.parent?.descendant(at: [indexPath.item + direction]) {
            return sibling
        }
        
        if let parentSibling = node.parent?.parent?.descendant(at: [indexPath.section + direction]) {
            return getNextNode(node: parentSibling, direction: direction)
        }
        
        return nil
    }
    
    @IBAction func feedSelectedAction(_ sender: Any) {
        let selectedObjects = treeController.selectedObjects
        if selectedObjects.isEmpty {
            return
        }
        guard let feed = selectedObjects[0] as? Feed else { return }
        SelectedFeed.shared.feed = feed
    }
}
