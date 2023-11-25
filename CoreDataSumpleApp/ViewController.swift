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
    
    // 画面が表示された時 CoreDataからTODOリストに登録されている項目を取得する。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = getContext()
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
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
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
