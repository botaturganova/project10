//
//  ViewController.swift
//  Project 1
//
//  Created by bota on 09.09.2024.
//

import UIKit

class ViewController: UICollectionViewController {
    var picture = [String]()

    override func viewDidLoad() {
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        super.viewDidLoad()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                picture.append(item)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picture.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picture", for: indexPath) as? pictureCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        let pictureName = picture[indexPath.item]
        let imagePath = Bundle.main.path(forResource: pictureName, ofType: nil)!
        cell.imageView.image = UIImage(contentsOfFile: imagePath)
        cell.name.text = picture[indexPath.item]
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
            cell.imageView.layer.borderWidth = 2
            cell.imageView.layer.cornerRadius = 3
            cell.layer.cornerRadius = 7

            return cell
    
    }

    
    override func collectionView(_ collectionViewView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = picture[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

