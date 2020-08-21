//
//  ViewController.swift
//  tableView
//
//  Created by miyazawaryohei on 2020/08/17.
//  Copyright © 2020 miya. All rights reserved.
//

import UIKit


struct Fruit {
    var name: String
    var isChecked: Bool
}
extension Fruit:Codable {
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet private var tableView: UITableView!
    private var fruitItemRow:Int?
    //fruitItemsを初期化
    private var fruitItems: [Fruit] = [
        Fruit(name:"りんご", isChecked: false),
        Fruit(name:"みかん", isChecked: true),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.fruitItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let fruitItem = self.fruitItems[indexPath.row]
        
        if fruitItem.isChecked {
            cell.cellImage.image = UIImage(named: "checkmark")
        } else {
            cell.cellImage.image = nil
        }
        
        cell.label.text = fruitItem.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fruitItems[indexPath.row].isChecked.toggle()
         tableView.reloadRows(at: [indexPath], with: .automatic)
        saveData()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        fruitItemRow = indexPath.row
        performSegue(withIdentifier: "EditSegue", sender: indexPath)
    }
    
    
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "AddSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let fruitItemRow = fruitItemRow else { return }
        let nav = segue.destination as? UINavigationController
        if let add = nav?.topViewController as? AddViewController{
            
            switch segue.identifier ?? "" {
            case "AddSegue":
                add.mode = AddViewController.Mode.add
            case "EditSegue":
                add.mode = AddViewController.Mode.edit
                add.fruitName = fruitItems[fruitItemRow].name
            default:
                break
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        fruitItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        saveData()
    }
    
    @IBAction func exitCancell(segue:UIStoryboardSegue){
    }
    
    @IBAction func exitSaveAddSegue(segue:UIStoryboardSegue){
        guard let addVC = segue.source as? AddViewController else { return }
        fruitItems.append(Fruit(name:addVC.addTextField.text ?? "", isChecked:false))
        tableView.reloadData()
        saveData()
        
    }
    
    @IBAction func exitSaveEditSegue(segue:UIStoryboardSegue){
        guard let addVC = segue.source as? AddViewController else { return }
        guard let fruitItemRow = fruitItemRow else { return }
        fruitItems[fruitItemRow].name = addVC.addTextField.text ?? ""
        let indexPath = IndexPath(item: fruitItemRow, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        saveData()
        }
    
    func loadData(){
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: "array"),
            let fruitData = try? jsonDecoder.decode([Fruit].self, from: data) else {return}
        fruitItems = []
        fruitItems = fruitData
        }
        
    func saveData(){
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(fruitItems)else {return}
        UserDefaults.standard.set(data, forKey: "array")
        
        }
}


        
