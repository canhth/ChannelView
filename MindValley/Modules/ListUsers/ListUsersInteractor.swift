// 
//  ListUsersInteractor.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

final class ListUsersInteractor {
    // MARK: - Private Properties

    private let networkClient: NetworkRequestable

    // MARK: - LifeCycle

    init(networkClient: NetworkRequestable = NetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - ListUsersInteractorInterface

extension ListUsersInteractor: ListUsersInteractorInterface {
}
