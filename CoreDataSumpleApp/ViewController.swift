//
//  ViewController.swift
//  CoreDataSumpleApp
//
//  Created by KOTOMI TAKAHASHI on 2023/11/21.
//

import UIKit
import CoreData

class TasksViewController: UITableViewController {
    let managedCoreData = ManagedCoreData()
    // Task型のオブジェクトを格納するための空の配列を初期化
    var tasks: [Task] = []
    // データベースに対するクエリや保存といった操作を行うための前準備
    private func getContext() ->  NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // 画面が表示された時 CoreDataからTODOリストに登録されている項目を取得する。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        managedCoreData.context = getContext()
        // fetchRequestはCore DataからTaskエンティティのインスタンスを取得するためのリクエストを作成し、実行する役割を担っている。
        // ジェネリクスを使うのは定石。これにより、フェッチリクエストの結果がそのエンティティタイプの配列であることがコンパイル時に保証できる。
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        // sortDescriptionはNSSortDescriptorのインスタンスであり、フェッチリクエストの結果を特定の順序でソートするために使用される。
        // ソートキーの指定 = `key: "title"` , ソート順の指定(降順) = `ascending: false`
        
        let sortDescription = NSSortDescriptor(key: "title", ascending: false)
        
        // fetchRequestにsortDescriptorsプロパティとしてこのsortDescriptionを設定することで、
        // フェッチされるTaskのリストがtitle属性に基づいて降順にソートされた状態で取得される。
        fetchRequest.sortDescriptors = [sortDescription]
        
        // contextを使用して、fetchRequestに基づいてデータを取得し、それをtasks配列に格納する
        do {
            tasks = try managedCoreData.context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // タスクを追加する。
    @IBAction func addNewTaskButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "新しいタスク", message: "新しいタスクを追加してください", preferredStyle: .alert)
        
        let saveActrion = UIAlertAction(title: "保存", style: .default) { action in
            let textField = alertController.textFields?.first
            
            if let newTask = textField?.text {
                self.managedCoreData.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        }
        
        alertController.addTextField { _ in
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { _ in
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveActrion)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // 全てのタスクを削除する。
    @IBAction func deleteAllTaskButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "削除", message: "全てのタスクを削除しますか?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "はい", style: .default) { action in
            self.deleteAllTasks()
            self.tableView.reloadData()
        }
        
        let no = UIAlertAction(title: "いいえ", style: .default) { _ in
        }
        
        alertController.addAction(yes)
        alertController.addAction(no)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // CoreDataのタスクを全て削除する。
    internal func deleteAllTasks() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
                tasks.removeAll()
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// tableViewの描画
extension TasksViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = leadingSwipeDoneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    private func leadingSwipeDoneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Done") { [self] (action, view, completion) in
            self.managedCoreData.changeDone(at: indexPath)
            completion(true)
        }
        
        let row = tasks[indexPath.row]
        action.image = UIImage(systemName: "checkmark.square")
        if row.isFinish {
            action.image = UIImage(systemName: "checkmark.square.fill")
            action.backgroundColor = .systemRed
            
        } else {
            action.backgroundColor = .systemGray
        }
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = trailingSwipeDoneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    private func trailingSwipeDoneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Done") { [self] (action, view, completion) in
            self.managedCoreData.deleteTask(at: indexPath)
            completion(true)
            self.tableView.reloadData()
        }
        action.image = UIImage(systemName: "trash")
        
        return action
    }
}
