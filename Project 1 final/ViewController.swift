//
//  ViewController.swift
//  Project 1 final
//
//  Created by bota on 21.02.2024.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            if let items = try? fm.contentsOfDirectory(atPath: path) {
                self.pictures = items.filter { $0.hasPrefix("nssl") }
                self.pictures.sort { $0.localizedStandardCompare($1) == .orderedAscending }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(self.pictures)
        }
            }


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = .green }
        else {
            cell.contentView.backgroundColor = .red
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
               vc.selectedImage = pictures[indexPath.row]
               vc.selectedPictureNumber = indexPath.row + 1
               vc.totalPictures = pictures.count
               navigationController?.pushViewController(vc, animated: true)
           }
       }
    
    @objc func recommendTapped() {
           let recommendMessage = "Check out this cool app Storm Viewer!"
           let activityViewController = UIActivityViewController(activityItems: [recommendMessage], applicationActivities: nil)
           present(activityViewController, animated: true, completion: nil)
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           let recommendButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendTapped))
           navigationItem.rightBarButtonItem = recommendButton
       }
   }

