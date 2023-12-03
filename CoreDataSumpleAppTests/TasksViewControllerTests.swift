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
    var viewController: TasksViewController!
    // テスト用のデータストアを操作するマネージャーを設定。
    var managedObjectContext: NSManagedObjectContext!
    
    // テストのための初期設定
    override func setUp() {
        super.setUp()
        // インメモリストアを持つNSPersistentContainerを設定
        // NSPersistentContainer ← 一番大事。
        /*
         - NSPersistentStoreCoordinatorを内部で管理しているので、初期化と永続化ストアの読み込みプロセスがすでに完了している。
         - NSPersistentContainer(name: "Task")により、指定された名前（この場合は"Task"）のモデルファイル（.xcdatamodeld）をアプリケーションのバンドルから検索し、NSManagedObjectModelを生成する
         -
         */
        let container = NSPersistentContainer(name: "Task")
        // 永続ストアを作成およびロードするために使用される
        // NSPersistentStoreDescription はストアの種類、場所
        // NSPersistentStoreDescriptionオブジェクトを作成し、typeをNSInMemoryStoreTypeに設定
        // => addPersistentStoreWithTypeの呼び出しに相当。内部的にインメモリの永続ストアをセットアップ。
        let description = NSPersistentStoreDescription()
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
        self.managedObjectContext = container.viewContext
        // テスト用のViewControllerインスタンスを生成
        viewController = TasksViewController()
    }
    
    // tearDown()メソッドは各テストケースの実行後に呼び出される
    // テスト間で共有される状態やリソースがないことを保証
    // => 各テストは互いに独立して実行される
    override func tearDown() {
        // テストで使用されたviewControllerインスタンスへの参照を解放
        viewController = nil
        super.tearDown()
    }
    
    // getContext()メソッドがNSManagedObjectContextを返すことを確認
    private func testGetContext() {
        // getContext()メソッドを呼び出し
        let context = viewController.getContext()
        
        // 戻り値contextはNSManagedObjectContextのインスタンスであることを確認
        XCTAssertNotNil(context, "Contextは必ず存在する")
        XCTAssertTrue(context is NSManagedObjectContext, "contextはNSManagedObjectContext型のインスタンスです。")
    }
    
    // Core Dataからデータをフェッチする処理が正しく行われることを確認
    private func testFatchData() throws {
        // viewWillAppearメソッドのTrigger
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        // そのとき何も保存されていないのであれば `[]`が取得されるし、何か
        XCTAssertNotNil(viewController.tasks)
    }
    
    // saveTask(withTitle:)メソッドが新しいタスクを正しくCore Dataに保存していることを確認する
    private func testSaveTask() {
        viewController.saveTask(withTitle: "新しいタスク")
        XCTAssertEqual(viewController.tasks.count, 1, "フェッチされるタスクは1つであるべきだ")
        XCTAssertEqual(viewController.tasks.first?.title, "新しいタスク", "フェッチされたタスクは正しいタイトルを持つべきである")
    }
    
    // deleteAllTasks()メソッドがCore Dataの全タスクを適切に削除することを確認
    private func testDeleteAllTasks() {
        self.testSaveTask()
        viewController.deleteAllTasks()
        XCTAssertEqual(viewController.tasks.count, 0, "フェッチされるタスクは存在しない")
    }
    
    // deleteTask(at:)メソッドが特定のタスクを正しく削除することを確認
    private func testDeleteTask() {
        
    }
    
    // changeDone(at:)メソッドがタスクの完了状態を正しく切り替えることを確認
    private func testChangeDone() {
        
    }
    
    // tableView(_:cellForRowAt:)メソッドがタスクのデータに基づいて正しいセルを表示していることを確認
    private func testTableView() {
        
    }
    
    // leadingSwipeDoneAction(at:)とtrailingSwipeDoneAction(at:)メソッドが正しいアクションを提供していることを確認
    private func testLeadingSwipeDoneAction() {
        
    }
}
