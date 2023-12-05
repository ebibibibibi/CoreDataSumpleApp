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
                tasks.removeAll()
            }
        }
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    // タスクのステータスを更新する
    internal func changeDone(at indexPath: IndexPath) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let title = tasks[indexPath.row].title
        fetchRequest.predicate = NSPredicate(format: "title == %@", title!)
        
        do {
            let results = try context.fetch(fetchRequest)
            tasks[indexPath.row] = results.first!
            tasks[indexPath.row].isFinish = !tasks[indexPath.row].isFinish
            
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    // タスクの削除を行う
    internal func deleteTask(at indexPath: IndexPath) {
        do {
            tasks.remove(at: indexPath.row)
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
