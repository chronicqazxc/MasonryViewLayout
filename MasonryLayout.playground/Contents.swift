//
//  MasonryViewLayout.swift
//  MasonryLayout
//
//  Created by Hsiao, Wayne on 2019/7/31.
//  Copyright © 2019 com.wayne.hsiao. All rights reserved.
//

  
import UIKit
import PlaygroundSupport

class CollectionViewController : UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "item")
        collectionView.collectionViewLayout = MasonryViewLayout(delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
}

extension CollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        let labelFrame = CGRect(x: cell.bounds.width/2, y: 0, width: cell.bounds.width, height: cell.bounds.height)
        let labelTag = 12345

        if let label = cell.subviews.filter({ (view) -> Bool in
            return view.tag == labelTag
        }).first as? UILabel {
            label.frame = labelFrame
            label.text = "\(indexPath.row)"
        } else {
            let label = UILabel(frame: labelFrame)
            label.text = "\(indexPath.row)"
            label.tag = labelTag
            cell.addSubview(label)
        }
        cell.backgroundColor = .orange
        return cell
    }
}

extension CollectionViewController: MasonryViewDelegateLayout {
    var interItemSpacing: CGFloat {
        return 12.5
    }

    var numberOfColums: Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        heightForItemAtIndexPath: IndexPath) -> CGFloat {
        let randomHeight = 100 + (arc4random() % 140)
        return CGFloat(randomHeight)
    }
}

PlaygroundPage.current.liveView = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())


