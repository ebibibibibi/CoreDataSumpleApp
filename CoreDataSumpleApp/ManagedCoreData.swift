//
//  ManagedCoreData.swift
//  CoreDataSumpleApp
//
//  Created by TakahashiKotomi on 2023/12/05.
//

import Foundation
import CoreData

class ManagedCoreData {
    // データストアを操作するマネージャーを設定
    var context: NSManagedObjectContext!
    var tasks: [Task] = []
    // 新しいタスクをCore Dataに保存する
    internal func saveTask(withTitle title: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        taskObject.isFinish = false
        do {
            try context.save()
            tasks.append(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    // CoreDataのタスクを全て削除する。
    internal func deleteAllTasks() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        // コンテキストに変更がある場合のみ保存を試みる
        if context.hasChanges {
            do {
                try context.save()
                tasks.removeAll()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // タスクのステータスを更新する
    internal func changeDone(at indexPath: Int) {
        guard let title = tasks[indexPath].title else {
            print("指定されたタスクにタイトルがない")
            return
        }
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        // フェッチリクエストの結果をフィルタリング
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        do {
            let results = try context.fetch(fetchRequest)
            guard let taskToUpdate = results.first else {
                print("タイトルが一致するタスクが見つかりません")
                return
            }
            taskToUpdate.isFinish = !taskToUpdate.isFinish
            
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // タスクの削除を行う
    internal func deleteTask(at indexPath: Int) {
        guard let title = tasks[indexPath].title else {
            print("指定されたタスクにタイトルがない")
            return
        }
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        // フェッチリクエストの結果をフィルタリング
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        do {
            let results = try context.fetch(fetchRequest)
            guard let taskToDelete = results.first else {
                print("タイトルが一致するタスクが見つかりません")
                return
            }
            context.delete(taskToDelete)
            // コンテキストに変更がある場合のみ保存を試みる
            if context.hasChanges {
                try context.save() // 変更を保存
                tasks.remove(at: indexPath) // 配列からもタスクを削除
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
