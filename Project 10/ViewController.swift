//
//  ViewController.swift
//  Project 10
//
//  Created by bota on 05.09.2024.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView?.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        // Создаем первое уведомление
        let firstAlert = UIAlertController(title: "Do you want to rename the person or delete it?", message: nil, preferredStyle: .alert)

        // Действие для удаления
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView?.reloadData()
        }

        // Действие для отмены
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        // Создаем действие для переименования, которое покажет второе уведомление
        let showSecondAlertAction = UIAlertAction(title: "Rename person", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            // Создаем второе уведомление для переименования
            let secondAlert = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            secondAlert.addTextField()
            
            // Действие для подтверждения переименования
            let renameAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let self = self else { return }
                if let newName = secondAlert.textFields?.first?.text, !newName.isEmpty {
                    person.name = newName
                    self.collectionView?.reloadData()
                }
            }
            
            // Добавляем действия к второму уведомлению
            secondAlert.addAction(renameAction)
            secondAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // Показываем второе уведомление
            self.present(secondAlert, animated: true, completion: nil)
        }

        // Добавляем действия к первому уведомлению
        firstAlert.addAction(showSecondAlertAction)
        firstAlert.addAction(deleteAction)
        firstAlert.addAction(cancelAction)

        // Показываем первое уведомление
        present(firstAlert, animated: true, completion: nil)
    }
    
}
