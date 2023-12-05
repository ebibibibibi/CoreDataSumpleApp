//
//  TasksViewControllerTests.swift
//  CoreDataSumpleAppTests
//
//  Created by TakahashiKotomi on 2023/11/26.
//

import UIKit
import CoreData
import XCTest
@testable import CoreDataSumpleApp

final class TasksViewControllerTests: XCTestCase {
    let managedCoreData = ManagedCoreData()
    // テストのための初期設定
    override func setUp() {
        super.setUp()
        // インメモリストアを持つNSPersistentContainerを設定
        // NSPersistentContainer ← 一番大事。
        let container = NSPersistentContainer(name: "Task")
        // 永続ストアを作成およびロードするために使用される
        // NSPersistentStoreDescription はストアの種類、場所
        // NSPersistentStoreDescriptionオブジェクトを作成し、typeをNSInMemoryStoreTypeに設定
        // => addPersistentStoreWithTypeの呼び出しに相当。内部的にインメモリの永続ストアをセットアップ。
        let description = NSPersistentStoreDescription()
        // NSPersistentStoreDescription はpersistent storeの設定と構成を定義する
        // テストの際には、データをディスクに永続化せずにメモリ上にのみ保持するために、永続ストアとしてNSInMemoryStoreTypeを指定する
        // ユニットテストの際には、テストごとに独立したデータ環境を用意する
        // NSInMemoryStoreTypeを使用すると、データがメモリ上にのみ存在し、テストの実行が終了するとデータが破棄される
        // これにより、テスト間でのデータの干渉を避けることができる
        // メモリ上のストアはディスクへの読み書きがないため、テストの実行速度も向上する。
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [
            description
        ]
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load stores: \(error)")
            }
        }
        
        // NSPersistentContainerのviewContextを取得
        // viewContextはNSPersistentContainerによって提供されるNSManagedObjectContextのインスタンス
        // viewContextはデフォルトでメインキュー上で動作するように設定されている
        //
        self.managedCoreData.context = container.viewContext
    }
    
    // tearDown()メソッドは各テストケースの実行後に呼び出される
    // テスト間で共有される状態やリソースがないことを保証
    // => 各テストは互いに独立して実行される
    override func tearDown() {
        // テストで使用された NSManagedObjectContextインスタンスをリセット
        managedCoreData.context.reset()
        super.tearDown()
    }
    
    // managedObjectContextはNSManagedObjectContextのインスタンスであることを確認
    private func testGetContext() {
        // 戻り値contextはNSManagedObjectContextのインスタンスであることを確認
        XCTAssertNotNil(managedCoreData.context, "Contextは必ず存在する")
        XCTAssertTrue(managedCoreData.context is NSManagedObjectContext, "contextはNSManagedObjectContext型のインスタンスです。")
        XCTAssertNotNil(managedCoreData.context, "managedObjectContextは必ず存在する")
    }
    
    // saveTask(withTitle:)メソッドが新しいタスクを正しくCore Dataに保存していることを確認する
    private func testSaveTask() {
        managedCoreData.saveTask(withTitle: "新しいタスク")
        XCTAssertEqual(managedCoreData.tasks.count, 1, "フェッチされるタスクは1つであるべきだ")
        XCTAssertEqual(managedCoreData.tasks.first?.title, "新しいタスク", "フェッチされたタスクは正しいタイトルを持つべきである")
    }
    
    // deleteAllTasks()メソッドがCore Dataの全タスクを適切に削除することを確認
    private func testDeleteAllTasks() {
        managedCoreData.saveTask(withTitle: "新しいタスク")
        managedCoreData.saveTask(withTitle: "2つ目のタスク")
        managedCoreData.deleteAllTasks()
        XCTAssertEqual(managedCoreData.tasks.count, 0, "フェッチされるタスクは存在しない")
    }
    
    // deleteTask(at:)メソッドが特定のタスクを正しく削除することを確認
    private func testDeleteTask() {
        managedCoreData.saveTask(withTitle: "新しいタスク")
        managedCoreData.saveTask(withTitle: "2つ目のタスク")
        managedCoreData.deleteTask(at: 1)
        XCTAssertEqual(managedCoreData.tasks.count, 1, "タスクは1つだけ存在する。")
        XCTAssertEqual(managedCoreData.tasks.first?.title, "新しいタスク", "フェッチされたタスクは正しいタイトルを持つべきである")
    }
    
    // changeDone(at:)メソッドがタスクの完了状態を正しく切り替えることを確認
    private func testChangeDone() {
        managedCoreData.saveTask(withTitle: "新しいタスク")
        managedCoreData.changeDone(at: 0)
        XCTAssertEqual(managedCoreData.tasks.first?.isFinish, true, "フェッチされたタスクはtrueであるべき")
    }
}
