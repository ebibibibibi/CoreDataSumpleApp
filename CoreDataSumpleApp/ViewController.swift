//
//  ViewController.swift
//  CoreDataSumpleApp
//
//  Created by KOTOMI TAKAHASHI on 2023/11/21.
//

import UIKit
import CoreData

class TasksViewController: UITableViewController {
    var tasks: [Task] = []
    
    // NSManagedObjectContextを取得。
    // データベースに対するクエリや保存といった操作を行うための前準備
    private func getContext() ->  NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // テーブルビューに表示するタスクの数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // 各タスクに対応するテーブルビューセルを設定
    // セルを取得し、タスクのタイトルをセルのテキストラベルに表示
    // タスクが完了している（isFinishがtrue）場合は、セルの背景色を赤に変更
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        if task.isFinish {
            cell.backgroundColor = .red
        }
        return cell
    }
}
