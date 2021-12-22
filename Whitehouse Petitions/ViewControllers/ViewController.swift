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
  var filteredPetitions = [Petition]()

  //MARK: - ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    performSelector(inBackground: #selector (fetchJSON), with: nil)
  }

//MARK: - UI Methods

  @objc func fetchJSON(){
    let urlString: String
    setNavigationItems()
    if navigationController?.tabBarItem.tag == 0 {
      urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
      urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
      if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
          parse(json: data)
          return
        }
    }
    performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
  }

  func setNavigationItems(){
    let credits = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
    let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(addFilter))
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
    navigationItem.rightBarButtonItem = credits
    navigationItem.leftBarButtonItems = [filter, refresh]
  }

  @objc func addFilter(){
    let alert = UIAlertController(title: "Please, enter some text for search/filtering.", message: nil, preferredStyle: .alert)
    alert.addTextField()
    let filter = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] action in
      guard let someFilterWords = alert?.textFields?[0].text else { return }
      self?.filter(someFilterWords)
    }
    alert.addAction(filter)
    present(alert, animated: true)
  }

  @objc func reload(){
    filteredPetitions = petitions
    tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
  }

  func filter(_ word: String) {
    if word != "" {
    filteredPetitions = filteredPetitions.filter{ $0.title.contains(word)}
    } else {
      filteredPetitions = petitions
    }
    tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
  }

  @objc func showCredits(){
    let alert = UIAlertController(title: "The data comes from the We The People API of the Whitehouse", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
    present(alert, animated: true)
  }

  @objc func showError(){
      let alert = UIAlertController(title: "Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "Ok", style: .default))
      present(alert, animated: true)
  }

  func parse(json: Data){
    let decoder = JSONDecoder()
    if let jsonPetitions = try? decoder.decode(Petititons.self, from: json){
      petitions = jsonPetitions.results
      filteredPetitions = petitions
      tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    } else {
      performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
  }

  //MARK: - TableView Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredPetitions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let petition = filteredPetitions[indexPath.row]
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

