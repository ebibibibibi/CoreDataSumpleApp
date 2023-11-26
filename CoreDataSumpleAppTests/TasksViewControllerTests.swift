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
    var mockPersistantContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
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
    
    // viewWillAppearメソッド内で、Core Dataからデータをフェッチする処理が正しく行われることを確認
    private func testFatchData() throws {
        // getContext()メソッドを呼び出し
        let context = viewController.getContext()
        let task = Task(context: context)
        task.title = "Test Task"
        task.isFinish = false
        try context.save()
        
        // viewWillAppearメソッドのTrigger
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        
        XCTAssertEqual(viewController.tasks.count, 1, "フェッチされるタスクは1つであるべきだ")
        
        XCTAssertEqual(viewController.tasks.first?.title, "Test Task", "フェッチされたタスクは正しいタイトルを持つべきである")
    }
    
    // saveTask(withTitle:)メソッドが新しいタスクを正しくCore Dataに保存していることを確認する
    private func testSaveTask() {
        
    }
    
    // deleteAllTasks()メソッドがCore Dataの全タスクを適切に削除することを確認
    private func testDeleteAllTasks() {
        
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
