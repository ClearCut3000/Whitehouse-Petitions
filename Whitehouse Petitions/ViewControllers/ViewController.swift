//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Николай Никитин on 17.12.2021.
//

import UIKit

class ViewController: UITableViewController {
  //MARK: - Properties
  var petitions = [Petition]()


  //MARK: - ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

    if let url = URL(string: urlString) {
      if let data = try? Data(contentsOf: url) {
        parse(json: data)
      }
    }
  }

  func parse(json: Data){
    let decoder = JSONDecoder()
    if let jsonPetitions = try? decoder.decode(Petititons.self, from: json){
      petitions = jsonPetitions.results
      tableView.reloadData()
    }
  }

  //MARK: - TableView Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return petitions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let petition = petitions[indexPath.row]
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let viewController = DetailViewController()
    viewController.detailItem = petitions[indexPath.row]
    navigationController?.pushViewController(viewController, animated: true)
  }


}

