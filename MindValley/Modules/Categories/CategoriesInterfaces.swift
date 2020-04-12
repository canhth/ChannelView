// 
//  CategoriesInterfaces.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/10/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

// Dependency
protocol CategoriesDependencyInterface {
    func makeCategoriesView() -> CategoriesViewInterface
}

// Router
protocol CategoriesRouterInterface: ViewRouterInterface {
}

// ViewController
protocol CategoriesViewInterface: ViewInterface {
}

// Presenter
protocol CategoriesPresenterInterface: PresenterInterface {
}

// Interactor
protocol CategoriesInteractorInterface {
    func fetchCategories(fromCache: Bool, completion: @escaping (Result<[Category], NetworkError>) -> Void)
}